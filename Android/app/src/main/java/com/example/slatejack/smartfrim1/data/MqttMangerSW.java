package com.example.slatejack.smartfrim1.data;

import android.content.Context;
import android.os.Handler;
import android.os.Message;
import android.util.Log;

import com.example.slatejack.smartfrim1.selectsw;
import com.google.gson.Gson;

import org.eclipse.paho.android.service.MqttAndroidClient;
import org.eclipse.paho.client.mqttv3.IMqttActionListener;
import org.eclipse.paho.client.mqttv3.IMqttDeliveryToken;
import org.eclipse.paho.client.mqttv3.IMqttToken;
import org.eclipse.paho.client.mqttv3.MqttCallback;
import org.eclipse.paho.client.mqttv3.MqttCallbackExtended;
import org.eclipse.paho.client.mqttv3.MqttClient;
import org.eclipse.paho.client.mqttv3.MqttConnectOptions;
import org.eclipse.paho.client.mqttv3.MqttException;
import org.eclipse.paho.client.mqttv3.MqttMessage;
import org.eclipse.paho.client.mqttv3.MqttPersistenceException;

public class MqttMangerSW {
    public static final String TAG = "MQTT";

    private String host;
    private String clientId;
    //创建用于连接mqtt服务器的相关内容，分别是服务器的地址
    private MqttAndroidClient client;
    //创建mqttClient对象，以及连接的对象
    private MqttConnectOptions connectOptions;
    private Context ctx;
    private Handler handler1;



    /**
     * 三个参数的构造方法
     * 以及自动获取客户端的ID
     * 这就是上面的三个参数，还有一个是当时准备传入主UI线程的，后来就没用到
     *  @param host
     *
     */
    public MqttMangerSW(String host,Context context, Handler handler1){
        this.host=host;
        this.clientId= MqttClient.generateClientId();
        this.ctx = context;
        this.handler1 = handler1;
    }


    /**
     * 连接操作
     * 首先创建一个客户端对象，同时把地址，id传进去
     * 其次再把账户密码穿进去
     * 输入一个callback实例
     * 开始连接服务器
     */
    public void connect(){
        try{
            client = new MqttAndroidClient(this.ctx, this.host, this.clientId  );
            connectOptions = new MqttConnectOptions();
            client.setCallback( new MqttCallbackExtended() {
                @Override
                public void connectComplete(boolean reconnect, String serverURI) {
                   //发布查询开关状态消息
                    Gson gson = new Gson();
                    selectsw s1=new selectsw( "SW",0,"Query" );
                    String s11=gson.toJson( s1 );
                    publish( "jcsf/gh/control",s11,true,2 );
                    Log.d( TAG,"主线程发出消息" +s11);
                }

                @Override
                public void connectionLost(Throwable cause) {

                }

                @Override
                public void messageArrived(String topic, MqttMessage message) throws Exception {
                    String  s1 = new String(message.getPayload(), "UTF-8");
                    Log.i(TAG,"收到从："+topic+"发来的消息，内容为："+s1);
                    Message m1 = new Message();
                    m1.obj = s1;
                    handler1.sendMessage( m1 );
                }

                @Override
                public void deliveryComplete(IMqttDeliveryToken token) {

                }
            } );
            client.connect( connectOptions, null, new IMqttActionListener() {
                @Override
                public void onSuccess(IMqttToken asyncActionToken) {
                    Log.i(TAG,"连接成功");
                    subscribe( "jcsf/gh/iotdata",0 );
                }

                @Override
                public void onFailure(IMqttToken asyncActionToken, Throwable exception) {
                    Log.i(TAG,"连接失败，请重试", exception);
                }
            } );

        }catch (MqttException e){
            e.printStackTrace();
        }
    }

    /**
     * 获取函数
     * 下面两个参数主要是一个是消息对列的名称，一个是服务质量
     * 然后把这两个对象装程数组类型
     * 然后通过调用客户端的函数subscribe来读取消息
     *
     * @param topic
     * @param qos
     */

    public void subscribe(String topic, int qos) {
        if (client != null) {
            int[] Qos = {qos};
            String[] topic1 = {topic};
            try {
                client.subscribe( topic1, Qos, null, new IMqttActionListener() {
                    @Override
                    public void onSuccess(IMqttToken asyncActionToken) {
                        Log.i(TAG,"订阅成功！");
                    }

                    @Override
                    public void onFailure(IMqttToken asyncActionToken, Throwable exception) {
                        Log.i( TAG,"订阅失败！" );
                    }
                } );
                Log.d( TAG, "订阅topic : " + topic );
            } catch (MqttException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * 此为向服务器发布数据的操作封装函数
     * 在这里的四个参数的意思分别是
     *
     * @param topic      消息队列
     * @param msg        向服务器发送到消息
     * @param isRetained 是否保留，一般false
     * @param qos        服务质量
     *                   新建一个MqttMessa对象然后分别通过对应的set函数将
     *                   这四个参数穿进去然后调用客户端里面的publish函数进行
     *                   获取服务器里面的信息
     *                   并打印日志
     */

    public void publish(String topic, String msg, boolean isRetained, int qos) {
        try {
            if (client != null) {
                MqttMessage message = new MqttMessage();
                message.setQos( qos );
                message.setRetained( isRetained );
                message.setPayload( msg.getBytes() );
                client.publish( topic, message );
                Log.i( TAG, "publish成功，发出的消息为"+message );
            }
        } catch (MqttPersistenceException e) {
            e.printStackTrace();
        } catch (MqttException e) {
            e.printStackTrace();
        }
    }

    String payload;
    private MqttCallback mqttCallback = new MqttCallback() {
        @Override
        public void connectionLost(Throwable cause) {
            Log.i( TAG, "connection lost" );
        }

        @Override
        public void messageArrived(String topic, MqttMessage message) {
            Log.i( TAG, "received topic : " + topic );
            payload = new String( message.getPayload() );
            //捕获从服务器端发送过来的信息通过下面的apply（）函数传出去
            Log.i( TAG, "received msg : " + payload );

        }

        @Override
        public void deliveryComplete(IMqttDeliveryToken token) {
            Log.i( TAG, "deliveryComplete" );
        }
    };

    public String apply() {
        //别的类读取信息调用此函数即可
        return payload;
    }
}
