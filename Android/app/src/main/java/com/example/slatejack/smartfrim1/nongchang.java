package com.example.slatejack.smartfrim1;

import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;
import androidx.viewpager.widget.ViewPager;

import com.example.slatejack.smartfrim1.data.fore;
import com.example.slatejack.smartfrim1.data.weather;
import com.google.android.material.tabs.TabLayout;
import com.google.gson.Gson;

import java.util.List;
import java.util.Map;


public class nongchang extends AppCompatActivity {
    private Map<String, String> map;
    private List<Map<String, String>> list;
    private TextView tvcity;
    private TextView tvweather;
    private TextView tvtemp;
    private TextView tvwind;
    private TextView tvpm;
    private ImageView tvicon;
    public static final String TAG = "HTTP";
    private static final int SET = 0;
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
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate( savedInstanceState );
        setContentView( R.layout.activity_nongchang );
        //初始化控件
        initView();
        new Thread(new NewThread()).start();

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
        //toolbar
        TabLayout tabLayout = (TabLayout) findViewById(R.id.tab_layout);
        tabLayout.addTab(tabLayout.newTab()
                .setIcon( R.drawable.icon_sensor_active )
                .setText("传感器") );
        tabLayout.addTab(tabLayout.newTab()
                .setIcon( R.drawable.icon_controller_active )
                .setText("控制器"));
        tabLayout.setTabGravity(TabLayout.GRAVITY_FILL);

        final ViewPager viewPager = (ViewPager) findViewById(R.id.pager);
        final agerAdapter adapter = new agerAdapter(getSupportFragmentManager(), tabLayout.getTabCount());
        viewPager.setAdapter(adapter);
        viewPager.addOnPageChangeListener(new TabLayout.TabLayoutOnPageChangeListener(tabLayout));
        tabLayout.setOnTabSelectedListener(new TabLayout.OnTabSelectedListener() {
            @Override
            public void onTabSelected(TabLayout.Tab tab) {
                viewPager.setCurrentItem(tab.getPosition());
            }

            @Override
            public void onTabUnselected(TabLayout.Tab tab) {

            }

            @Override
            public void onTabReselected(TabLayout.Tab tab) {

            }
        });
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

    private void initView() {
        tvcity = findViewById( R.id.city );
        tvweather = findViewById( R.id.weather );
        tvtemp = findViewById( R.id.temp );
        tvwind = findViewById( R.id.wind );
        tvpm = findViewById( R.id.pm );
        tvicon = findViewById( R.id.imageView2 );

    }
    //强制界面全屏化
    public void onWindowFocusChanged(boolean hasFocus) {
        super.onWindowFocusChanged(hasFocus);
        if (hasFocus && Build.VERSION.SDK_INT >= 19) {
            View decorView = getWindow().getDecorView();
            decorView.setSystemUiVisibility(
                    View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                            | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                            | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                            | View.SYSTEM_UI_FLAG_FULLSCREEN
                            | View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY);
        }
    }
    //handle传输天气数据
    private class NewThread implements Runnable{
        public void run(){
            String address="http://t.weather.sojson.com/api/weather/city/101270101".toString();
            HttpDownloader httpDownloader=new HttpDownloader();
            String jsonStr=httpDownloader.download( address );
            Message msg=nongchang.this.handler.obtainMessage(nongchang.SET,jsonStr);
            Log.d( TAG, String.valueOf( msg ) );
            nongchang.this.handler.sendMessage( msg );
        }
    }

}
