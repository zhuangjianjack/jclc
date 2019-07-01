package com.example.slatejack.smartfrim1;


import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CompoundButton;
import android.widget.ImageView;
import android.widget.SeekBar;
import android.widget.Switch;
import android.widget.TextView;

import androidx.fragment.app.Fragment;

import com.example.slatejack.smartfrim1.data.MqttMangerSW;
import com.example.slatejack.smartfrim1.data.ResultSw;
import com.example.slatejack.smartfrim1.data.SensorSw;
import com.google.gson.Gson;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static com.example.slatejack.smartfrim1.data.Sensor.SENSOR_LIGHT;


/**
 * A simple {@link Fragment} subclass.
 */
public class FragmentSet extends Fragment{
    private Map<String, String> map;
    private List<Map<String, String>> list;
    private TextView tvcity;
    private TextView tvweather;
    private TextView tvtemp;
    private TextView tvwind;
    private TextView tvpm;
    private ImageView tvicon;
    private MqttMangerSW mqttMangerSW;
    private Switch swhlfj;
    private Switch swzmd;
    private SeekBar sb_zy;
    private SeekBar sb_jm;
    private boolean zyseeking=false;
    public static final String TAG = "MQTT";

    public FragmentSet() {
        // Required empty public constructor
    }


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View txview=inflater.inflate( R.layout.fragment_fragment_set,container,false );
        initView(txview);
        //解析xml文件
        InputStream inputStream = getResources().openRawResource( R.raw.weather );
        try {
            List<weatherinfo> weatherinfos = weatherservice.getInfoFromXml( inputStream );
            list = new ArrayList<Map<String, String>>();
            for (weatherinfo info : weatherinfos) {
                map = new HashMap<>();
                map.put( "temp", info.getTemp() );
                map.put( "weather", info.getWeather() );
                map.put( "wind", info.getWind() );
                map.put( "pm", info.getPm() );
                map.put( "name", info.getName() );
                list.add( map );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        //显示天气控件到文本框中
        getMap( 1, R.drawable.sun );
        changelistener();
        initView( txview );
        return txview;
    }

    private void initView(View txview) {
        tvcity = txview.findViewById( R.id.city );
        tvweather = txview.findViewById( R.id.weather );
        tvtemp = txview.findViewById( R.id.temp );
        tvwind = txview.findViewById( R.id.wind );
        tvpm = txview.findViewById( R.id.pm );
        tvicon = txview.findViewById( R.id.imageView2 );
        swhlfj=txview.findViewById( R.id.sw_hlfj );
        swzmd=txview.findViewById( R.id.sw_zmd );
        sb_zy=txview.findViewById( R.id.sb_zy );
        sb_jm=txview.findViewById( R.id.sb_jm );
    }

    //天气信息
    private void getMap(int number, int iconnumber) {
        Map<String, String> citymap = list.get( number - 1 );
        String weather = citymap.get( "weather" );
        String name = citymap.get( "name" );
        String pm = citymap.get( "pm" );
        String wind = citymap.get( "wind" );
        String temp = citymap.get( "temp" );
        tvcity.setText( name );
        tvweather.setText( weather );
        tvwind.setText( wind );
        tvpm.setText( pm );
        tvicon.setImageResource( iconnumber );

    }

    private void updateView(String data) {
        Log.d( TAG, "主线程收到消息" + data );
        //chuangan1_name1.setText( data );
        Gson gson = new Gson();
        ResultSw res = gson.fromJson( data, ResultSw.class );
        SensorSw sensor=new SensorSw();
        //查询开关状态
        if (res.getObj().equals( "SW" )) {
            if (sensor.getType()==SENSOR_LIGHT){
                if(sensor.getData().toArray()[0]=="0"){
                    swhlfj.setChecked( true );
                }
                else if (sensor.getData().toArray()[0]=="2"){
                    swhlfj.setChecked( false );
                }
            }
        }
    }

    //switch按钮监听
    private void changelistener(){
        final Gson gson=new Gson();
        //1.环流风机switch监听
        swhlfj.setOnCheckedChangeListener( new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (isChecked){//如果被点击为开
                    pushin p1=new pushin("SW",1,"Action",1);
                    String str1=gson.toJson( p1 );
                    mqttMangerSW.publish( "jcsf/gh/control",str1,true,0 );
                }
                else {//如果被点击为关
                    pushin p2=new pushin( "SW",1,"Action",2 );
                    String str2=gson.toJson( p2 );
                    mqttMangerSW.publish( "jcsf/gh/control",str2,true,0);
                }
            }
        } );

        //2.照明灯switch监听
        swzmd.setOnCheckedChangeListener( new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (isChecked){
                    pushin p1=new pushin("SW",2,"Action",1);
                    String str1=gson.toJson( p1 );
                    mqttMangerSW.publish( "jcsf/gh/control",str1,true,0 );
                }

                else {//如果被点击为关
                    pushin p2=new pushin( "SW",2,"Action",2 );
                    String str2=gson.toJson( p2 );
                    mqttMangerSW.publish( "jcsf/gh/control",str2,true,0);
                }
            }
        } );
        sb_zy.setOnSeekBarChangeListener( new SeekBar.OnSeekBarChangeListener() {
            private int  value;
            private void send(int value) {
                if (!zyseeking) {
                    //send mqtt
                    Log.i( TAG, "send: " + value );

                }
            }
            @Override
            public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
                value = progress;
                Log.i( TAG, "onProgressChanged: "+progress );

            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {
                Log.i( TAG, "onStartTrackingTouch: " );
            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {
                send(value);
                if (value==0){
                    pushin p3=new pushin( "SW",2,"Action",2 );
                    String str3=gson.toJson( p3 );
                    mqttMangerSW.publish( "jcsf/gh/control",str3,true, 0);
                }
                else if (value==1){
                    pushin p4=new pushin( "SW",2,"Action",0 );
                    String str4=gson.toJson( p4 );
                    mqttMangerSW.publish( "jcsf/gh/control",str4,true,0 );
                }
                else if (value==2){
                    pushin p5=new pushin( "SW",2,"Action",1 );
                    String str5=gson.toJson( p5 );
                    mqttMangerSW.publish( "jcsf/gh/control",str5,true,0 );
                }
                else {
                    return;
                }
                Log.i( TAG, "onStopTrackingTouch: " );
            }
        } );

        sb_jm.setOnSeekBarChangeListener( new SeekBar.OnSeekBarChangeListener() {
            private int  value;
            private void send(int value) {
                if (!zyseeking) {
                    //send mqtt
                    Log.i( TAG, "send: " + value );

                }
            }
            @Override
            public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
                value = progress;
                Log.i( TAG, "onProgressChanged: "+progress );
            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {

            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {
                send(value);
                if (value==0){
                    pushin p3=new pushin( "SW",3,"Action",2 );
                    String str3=gson.toJson( p3 );
                    mqttMangerSW.publish( "jcsf/gh/control",str3,true, 0);
                }
                else if (value==1){
                    pushin p4=new pushin( "SW",3,"Action",0 );
                    String str4=gson.toJson( p4 );
                    mqttMangerSW.publish( "jcsf/gh/control",str4,true,0 );
                }
                else if (value==2){
                    pushin p5=new pushin( "SW",3,"Action",1 );
                    String str5=gson.toJson( p5 );
                    mqttMangerSW.publish( "jcsf/gh/control",str5,true,0 );
                }
                else {
                    return;
                }
            }
        });
    }




    @Override
    public void onResume() {
        super.onResume();
        final Handler handler = new Handler() {
            @Override
            public void handleMessage(Message msg) {
                updateView( msg.obj.toString() );
            }
        };
        //连接mqtt服务器
        mqttMangerSW = new MqttMangerSW( "tcp://118.24.19.135:1883", getContext(), handler );
        mqttMangerSW.connect();
    }


}
