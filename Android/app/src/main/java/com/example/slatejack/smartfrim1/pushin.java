package com.example.slatejack.smartfrim1;

public class pushin {
    private String Obj;
    private int ID;
    private String Cmd;
    private int Param;

    public String getObj() {
        return Obj;
    }

    public void setObj(String obj) {
        Obj = obj;
    }

    public int getID() {
        return ID;
    }

    public void setID(int ID) {
        this.ID = ID;
    }

    public String getCmd() {
        return Cmd;
    }

    public void setCmd(String cmd) {
        Cmd = cmd;
    }

    public int getParam() {
        return Param;
    }

    public void setParam(int param) {
        Param = param;
    }

    public pushin(String Obj, int ID, String Cmd, int Param) {
        super();
        this.Obj=Obj;
        this.ID=ID;
        this.Cmd=Cmd;
        this.Param=Param;
    }
}
