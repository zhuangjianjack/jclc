package com.example.slatejack.smartfrim1;

import android.util.Xml;

import org.xmlpull.v1.XmlPullParser;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

/**
 * 解析天气工具类
 */
public class weatherservice {
    public static List<weatherinfo> getInfoFromXml(InputStream is) throws Exception {
        List<weatherinfo> weatherinfos=null;
        weatherinfo weatherinfo=null;
        //获取pull解析器
        XmlPullParser parser = Xml.newPullParser();
        //初始化解析器
        parser.setInput( is, "utf-8" );
        //获取当时事件类型
        int type=parser.getEventType();
        //若获取不了文件结尾则一直解析
        while (type!=XmlPullParser.END_DOCUMENT){
            //判断标签为开始还是结尾
            switch (type){
                case XmlPullParser.START_TAG://若为开始标签
                    if ("infos".equals( parser.getName() ))
                        weatherinfos=new ArrayList<weatherinfo>();
                    else if ("city".equals( parser.getName() )){
                        weatherinfo=new weatherinfo();
                        String idstr=parser.getAttributeValue( 0 );
                        weatherinfo.setId( idstr );}
                    else if ("tmp".equals( parser.getName() )) {
                        String temp = parser.nextText();
                        weatherinfo.setTemp( temp );
                    }
                    else if ("weather".equals( parser.getName() )) {
                        String weather = parser.nextText();
                        weatherinfo.setWeather( weather );
                    }
                    else if ("name".equals( parser.getName() )) {
                        String name = parser.nextText();
                        weatherinfo.setName( name );
                    }
                    else if ("pm".equals( parser.getName() )) {
                        String pm = parser.nextText();
                        weatherinfo.setPm( pm );
                    }
                    else if ("wind".equals( parser.getName() )) {
                        String wind = parser.nextText();
                        weatherinfo.setWind( wind );
                    }
                    break;
                    case XmlPullParser.END_TAG:
                        if ("city".equals( parser.getName() )){
                            //加入bean对象加入集合中
                            weatherinfos.add( weatherinfo );
                        }

            }
            type=parser.next();
        }
        return weatherinfos;
    }
}