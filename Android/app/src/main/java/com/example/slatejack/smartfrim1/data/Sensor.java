package com.example.slatejack.smartfrim1.data;

import java.util.List;

public class Sensor {
    public static final int SENSOR_LIGHT  = 1;
    public static final int SENSOR_CO2  = 2;
    public static final int SENSOR_WATER1=3;
    public static final int SENSOR_WATER2=4;
    public static final int SENSOR_WATER3=5;
    public static final int SENSOR_SOIL=10;

    private int ID;
    private int Type;
    private List<Float> Data;

    public int getID() {
        return ID;
    }

    public void setID(int ID) {
        this.ID = ID;
    }

    public int getType() {
        return Type;
    }

    public void setType(int type) {
        Type = type;
    }

    public List<Float> getData() {
        return Data;
    }

    public void setData(List<Float> data) {
        Data = data;
    }




}
