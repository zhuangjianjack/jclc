package com.example.slatejack.smartfrim1.data;

import java.util.List;

public class SensorSw {
    private List<Float> Data;
    private int ID;
    private int Type;

    public List<Float> getData() {
        return Data;
    }

    public void setData(List<Float> data) {
        Data = data;
    }
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

}
