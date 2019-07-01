package com.example.slatejack.smartfrim1;

import android.os.Bundle;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;
import androidx.viewpager.widget.ViewPager;

import com.google.android.material.tabs.TabLayout;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
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

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate( savedInstanceState );
        setContentView( R.layout.activity_nongchang );
        //初始化控件
        initView();
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
        //toolbar
        TabLayout tabLayout = (TabLayout) findViewById(R.id.tab_layout);
        tabLayout.addTab(tabLayout.newTab()
                .setIcon( R.drawable.icon_sensor_active )
                .setText("传感器"));
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

}
