package com.example.slatejack.smartfrim1;


import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import androidx.fragment.app.Fragment;

import com.example.slatejack.smartfrim1.data.Result;
import com.example.slatejack.smartfrim1.data.Sensor;
import com.google.gson.Gson;


/**
 * A simple {@link Fragment} subclass.
 */
public class TapFragment1 extends Fragment {
    private MqttManager mqttManager;
    private BaseAdapter baseAdapter;
    private TextView chuangan1_name1;
    private TextView chuangan1_name2;
    private TextView chuangan1_name3;
    private TextView chuangan2_name1;
    private TextView chuangan2_name2;
    private TextView chuangan2_name3;
    private TextView chuangan3_name1;
    private TextView chuangan3_name2;
    private TextView chuangan4_name1;
    private TextView chuangan4_name2;
    private TextView chuangan5_name1;
    private TextView chuangan5_name2;
    private TextView chuangan6_name1;
    private TextView chuangan6_name2;
    private TextView chuangan1;
    private TextView chuangan2;
    private TextView chuangan3;
    private TextView chuangan4;
    private TextView chuangan5;
    private TextView chuangan6;
    public static final String TAG = "MQTT";

    public TapFragment1() {
        // Required empty public constructor
    }


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View view=inflater.inflate( R.layout.fragment_tap1, container, false );
        initView( view );
        return view;
    }
    private void updateView(String data)  {
        Log.d( TAG, "主线程收到消息" + data );
        //chuangan1_name1.setText( data );
        Gson gson = new Gson();
        Result res = gson.fromJson( data, Result.class );
        Sensor sensor1 =new Sensor();
        if (res.getPayload().size()<=0) {
            //show error on ui
            Log.e( TAG, "Payload empty..."  );
            return;
        }
        if ( res.getPayload().get( 0 ).getData().get( 0 ).toString()=="0"){
            chuangan1.setText( "error" );
            chuangan1_name1.setText( "error" );
            chuangan1_name2.setText( "error" );
            chuangan1_name3.setText( "error" );
            chuangan2.setText( "error" );
            chuangan2_name1.setText( "error" );
            chuangan2_name2.setText( "error" );
            chuangan2_name3.setText( "error" );
            chuangan3.setText( "error" );
            chuangan3_name1.setText( "error" );
            chuangan3_name2.setText( "error" );
            chuangan4.setText( "error" );
            chuangan4_name1.setText( "error" );
            chuangan4_name2.setText( "error" );
            chuangan5.setText( "error" );
            chuangan5_name1.setText( "error" );
            chuangan5_name2.setText( "error" );
            chuangan6.setText( "error" );
            chuangan6_name1.setText( "error" );
            chuangan6_name2.setText( "error" );

        }
        else if (res.getObj().equals( "Sens" )) {
            for (Sensor sensor : res.getPayload()) {
                switch (sensor.getID()) {
                    case Sensor.SENSOR_LIGHT:
                        chuangan1.setText( "光照温湿度变送器" );
                        chuangan1_name1.setText("温度："+sensor.getData().get( 0 ).toString());
                        chuangan1_name2.setText("空气湿度："+sensor.getData().get( 1 ).toString());
                        chuangan1_name3.setText("光照："+sensor.getData().get( 2 ).toString());
                        break;
                    case Sensor.SENSOR_CO2:
                        chuangan2.setText( "co2温湿度变送器" );
                        chuangan2_name1.setText("温度："+sensor.getData().get( 0 ).toString());
                        chuangan2_name2.setText("空气湿度："+sensor.getData().get( 1 ).toString());
                        chuangan2_name3.setText("CO2浓度："+sensor.getData().get( 2 ).toString());
                        break;
                    case Sensor.SENSOR_WATER1:
                        chuangan3.setText( "土壤水分传感器1" );
                        chuangan3_name1.setText( "温度："+sensor.getData().get( 0 ).toString() );
                        chuangan3_name2.setText( "土壤湿度："+sensor.getData().get( 1 ).toString() );
                    case Sensor.SENSOR_WATER2:
                        chuangan4.setText( "土壤水分传感器2" );
                        chuangan4_name1.setText( "温度："+sensor.getData().get( 0 ).toString() );
                        chuangan4_name2.setText( "土壤湿度："+sensor.getData().get( 1 ).toString() );
                    case Sensor.SENSOR_WATER3:
                        chuangan5.setText( "土壤水分传感器3" );
                        chuangan5_name1.setText( "温度："+sensor.getData().get( 0 ).toString() );
                        chuangan5_name2.setText( "土壤湿度："+sensor.getData().get( 1 ).toString() );
                    case Sensor.SENSOR_SOIL:
                        chuangan6.setText( "土壤检测传感器" );
                        chuangan6_name1.setText( "电导度："+sensor.getData().get( 0 ).toString() );
                        chuangan6_name2.setText( "盐分："+sensor.getData().get( 1 ).toString() );
                    default:
                        break;
                }
            }
        }

    }
    private void initView(View view){
        chuangan1_name1 = view.findViewById( R.id.chuangan1_name1 );
        chuangan1_name2 = view.findViewById( R.id.chuangan1_name2 );
        chuangan1_name3 = view.findViewById( R.id.chuangan1_name3 );
        chuangan2_name1 = view.findViewById( R.id.chuangan2_name1 );
        chuangan2_name2 = view.findViewById( R.id.chuangan2_name2 );
        chuangan2_name3 = view.findViewById( R.id.chuangan2_name3 );
        chuangan3_name1 = view.findViewById( R.id.chuangan3_name1 );
        chuangan3_name2 = view.findViewById( R.id.chuangan3_name2 );
        chuangan4_name1 = view.findViewById( R.id.chuangan4_name1 );
        chuangan4_name2 = view.findViewById( R.id.chuangan4_name2 );
        chuangan5_name1 = view.findViewById( R.id.chuangan5_name1 );
        chuangan5_name2 = view.findViewById( R.id.chuangan5_name2 );
        chuangan6_name1 = view.findViewById( R.id.chuangan6_name1 );
        chuangan6_name2 = view.findViewById( R.id.chuangan6_name2 );
        chuangan1=view.findViewById( R.id.chuangan1 );
        chuangan2=view.findViewById( R.id.chuangan2 );
        chuangan3=view.findViewById( R.id.chuangan3 );
        chuangan4=view.findViewById( R.id.chuangan4 );
        chuangan5=view.findViewById( R.id.chuangan5 );
        chuangan6=view.findViewById( R.id.chuangan6 );
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
        mqttManager = new MqttManager( "tcp://118.24.19.135:1883", getActivity().getApplicationContext(), handler );
        mqttManager.connect();
    }
}
