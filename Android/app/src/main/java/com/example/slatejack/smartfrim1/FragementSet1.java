package com.example.slatejack.smartfrim1;

import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CompoundButton;
import android.widget.SeekBar;
import android.widget.Switch;
import android.widget.TextView;

import androidx.fragment.app.Fragment;

import com.example.slatejack.smartfrim1.data.MqttMangerSW;
import com.example.slatejack.smartfrim1.data.ResultSw;
import com.example.slatejack.smartfrim1.data.SensorSw;
import com.google.gson.Gson;

import static com.example.slatejack.smartfrim1.data.Sensor.SENSOR_LIGHT;


public class FragementSet1 extends Fragment {
    // TODO: Rename parameter arguments, choose names that match
    private Switch swhlfj;
    private Switch swzmd;
    private SeekBar sb_zy;
    private SeekBar sb_jm;
    private boolean zyseeking=false;
    private TextView tv_hlfj;
    private TextView tv_zmd;
    private TextView tv_zyw;
    private TextView tv_djm;
    private TextView tv_cjm;
    private MqttMangerSW mqttMangerSW;
    private SeekBar sb_cjm;
    public static final String TAG = "MQTT";
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
    public FragementSet1() {
        // Required empty public constructor
    }




    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View txview=inflater.inflate( R.layout.fragment_set1, container, false );
        initView( txview );
        changelistener();
        return txview;
    }

    private void initView(View txview) {
        swhlfj=txview.findViewById( R.id.sw_hlfj );
        swzmd=txview.findViewById( R.id.sw_zmd );
        sb_zy=txview.findViewById( R.id.sb_zy );
        sb_jm=txview.findViewById( R.id.sb_djm );
        sb_cjm=txview.findViewById( R.id.sb_cjm );
        tv_hlfj=txview.findViewById( R.id.tv_hlfj );
        tv_zmd=txview.findViewById( R.id.tv_zmd );
        tv_zyw=txview.findViewById( R.id.tv_zyw );
        tv_djm=txview.findViewById( R.id.tv_djm );
        tv_cjm=txview.findViewById( R.id.tv_cjm );
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
                    tv_zyw.setText( "开启中" );
                }
                else {
                    return;
                }
                sb_zy.setEnabled( false );
                mhandler.postDelayed( mrunnable,1000 );
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
                    tv_djm.setText( "开启中" );
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
