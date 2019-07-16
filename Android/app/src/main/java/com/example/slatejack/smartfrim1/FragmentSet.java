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
import com.example.slatejack.smartfrim1.data.fore;
import com.example.slatejack.smartfrim1.data.weather;
import com.google.gson.Gson;

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
    private TextView tv_hlfj;
    private TextView tv_zmd;
    private TextView tv_zyw;
    private TextView tv_djm;
    private TextView tv_cjm;
    private ImageView tvicon;
    private MqttMangerSW mqttMangerSW;
    private Switch swhlfj;
    private Switch swzmd;
    private SeekBar sb_zy;
    private SeekBar sb_jm;
    private SeekBar sb_cjm;
    private boolean zyseeking=false;
    public static final String TAG = "MQTT";
    private static final int SET = 0;
    Handler mhandler=new Handler(  );//设置一个handler对象用于设置switch按钮间隔时间
    Runnable mrunnable=new Runnable() {//设置一个runnable对象用于设置经过多少秒后可以点击
        @Override
        public void run() {
            swhlfj.setEnabled( true );
            swzmd.setEnabled( true );
            sb_cjm.setEnabled( true );
            sb_zy.setEnabled( true );
            sb_jm.setEnabled( true );
        }
    };
    public FragmentSet() {
        // Required empty public constructor
    }
    //json改变天气信息
    private Handler handler=new Handler(  ){
        @Override
        public void handleMessage(Message msg) {
            super.handleMessage( msg );
            String msg1=msg+"] } }";
            String msg2= msg1.substring( msg1.indexOf("{\"") );
            String msg3=msg2.substring( 0,msg2.indexOf( "target" ) );
            Log.i( TAG, "handleMessage: "+msg3 );
            fore fore=new fore();
            Gson gson=new Gson();
            weather we=gson.fromJson( msg3,weather.class );
            tvpm.setText( we.getData().getPm25());
            tvtemp.setText( we.getData().getWendu()+"℃" );
            tvweather.setText( we.getData().getForecast().get( 0 ).getType() );
            if (we.getData().getForecast().get( 0 ).getType().contains( "雨" )){
                tvicon.setImageResource( R.drawable.rain );
            }
            else if (we.getData().getForecast().get( 0 ).getType().contains( "晴" )){
                tvicon.setImageResource( R.drawable.sun );
            }
            else if(we.getData().getForecast().get( 0 ).getType().contains( "云" )){
                tvicon.setImageResource( R.drawable.yin );
            }
        }

    };

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View txview=inflater.inflate( R.layout.fragment_fragment_set,container,false );
        initView(txview);
        new Thread(new FragmentSet.NewThread()).start();
        /*
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
        */

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
        tv_hlfj=txview.findViewById( R.id.tv_hlfj );
        tv_zmd=txview.findViewById( R.id.tv_zmd );
        tv_zyw=txview.findViewById( R.id.tv_zyw );
        tv_djm=txview.findViewById( R.id.tv_djm );
        tv_cjm=txview.findViewById( R.id.tv_cjm );
        swhlfj=txview.findViewById( R.id.sw_hlfj );
        swzmd=txview.findViewById( R.id.sw_zmd );
        sb_zy=txview.findViewById( R.id.sb_zy );
        sb_jm=txview.findViewById( R.id.sb_djm );
        sb_cjm=txview.findViewById( R.id.sb_cjm );
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
                    mqttMangerSW.publish( "jcsf/gh/control",str1,true,2 );
                    tv_hlfj.setText( "打开" );
                }
                else {//如果被点击为关
                    pushin p2=new pushin( "SW",1,"Action",0 );
                    String str2=gson.toJson( p2 );
                    mqttMangerSW.publish( "jcsf/gh/control",str2,true,2);
                    tv_hlfj.setText( "关闭" );
                }
                swhlfj.setEnabled( false );
                mhandler.postDelayed( mrunnable,1000 );//经过一秒过后才能继续点击
                }


        } );

        //2.照明灯switch监听
        swzmd.setOnCheckedChangeListener( new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (isChecked){
                    pushin p1=new pushin("SW",5,"Action",1);
                    String str1=gson.toJson( p1 );
                    mqttMangerSW.publish( "jcsf/gh/control",str1,true,2 );
                    tv_zmd.setText( "打开" );
                }

                else {//如果被点击为关
                    pushin p2=new pushin( "SW",5,"Action",0 );
                    String str2=gson.toJson( p2 );
                    mqttMangerSW.publish( "jcsf/gh/control",str2,true,2);
                    tv_zmd.setText( "关闭" );
                }
                swzmd.setEnabled( false );
                mhandler.postDelayed( mrunnable,1000 );
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
                    mqttMangerSW.publish( "jcsf/gh/control",str3,true, 2);
                    tv_zyw.setText( "关闭中" );

                }
                else if (value==1){
                    pushin p4=new pushin( "SW",2,"Action",0 );
                    String str4=gson.toJson( p4 );
                    mqttMangerSW.publish( "jcsf/gh/control",str4,true,2 );
                    tv_zyw.setText( "停止" );
                }
                else if (value==2){
                    pushin p5=new pushin( "SW",2,"Action",1 );
                    String str5=gson.toJson( p5 );
                    mqttMangerSW.publish( "jcsf/gh/control",str5,true,2 );
                    tv_zyw.setText( "正在开启" );
                }
                else {
                    return;
                }
                Log.i( TAG, "onStopTrackingTouch: " );
                sb_zy.setEnabled( false );
                mhandler.postDelayed( mrunnable,1000 );
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
                    mqttMangerSW.publish( "jcsf/gh/control",str3,true, 2);
                    tv_djm.setText( "关闭中" );

                }
                else if (value==1){
                    pushin p4=new pushin( "SW",3,"Action",0 );
                    String str4=gson.toJson( p4 );
                    mqttMangerSW.publish( "jcsf/gh/control",str4,true,2 );
                    tv_djm.setText( "停止" );
                }
                else if (value==2){
                    pushin p5=new pushin( "SW",3,"Action",1 );
                    String str5=gson.toJson( p5 );
                    mqttMangerSW.publish( "jcsf/gh/control",str5,true,2 );
                    tv_djm.setText( "正在开启" );
                }
                else {
                    return;
                }
                sb_jm.setEnabled( false );
                mhandler.postDelayed( mrunnable,1000 );
            }
        });
        sb_cjm.setOnSeekBarChangeListener( new SeekBar.OnSeekBarChangeListener() {
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
                send( value );
                if (value==0){
                    pushin p3=new pushin( "SW",4,"Action",2 );
                    String str3=gson.toJson( p3 );
                    mqttMangerSW.publish( "jcsf/gh/control",str3,true, 2);
                    tv_cjm.setText( "关闭中" );
                }
                else if (value==1){
                    pushin p4=new pushin( "SW",4,"Action",0 );
                    String str4=gson.toJson( p4 );
                    mqttMangerSW.publish( "jcsf/gh/control",str4,true,2 );
                    tv_cjm.setText( "停止" );

                }
                else if (value==2){
                    pushin p5=new pushin( "SW",4,"Action",1 );
                    String str5=gson.toJson( p5 );
                    mqttMangerSW.publish( "jcsf/gh/control",str5,true,2 );
                    tv_cjm.setText( "开启中" );
                }
                else {
                    return;
                }
                sb_cjm.setEnabled( false );
                mhandler.postDelayed( mrunnable,1000 );
            }
        } );

    }

    //handle传输天气数据
    private class NewThread implements Runnable{
        public void run(){
            String address="http://t.weather.sojson.com/api/weather/city/101270101".toString();
            HttpDownloader httpDownloader=new HttpDownloader();
            String jsonStr=httpDownloader.download( address );
            Message msg=FragmentSet.this.handler.obtainMessage(FragmentSet.SET,jsonStr);
            Log.d( TAG, String.valueOf( msg ) );
            FragmentSet.this.handler.sendMessage( msg );
        }
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
