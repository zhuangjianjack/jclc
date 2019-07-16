package com.example.slatejack.smartfrim1.data;

import java.util.List;

public class ResultSw {
    String Obj;
    int Num;
    List<SensorSw> Payload;

    public String getObj() {
        return Obj;
    }

    public void setObj(String obj) {
        Obj = obj;
    }

    public int getNum() {
        return Num;
    }

    public void setNum(int num) {
        Num = num;
    }

    public List<SensorSw> getPayload() {
        return Payload;
    }

    public void setPayload(List<SensorSw> payload) {
        Payload = payload;
    }
}
