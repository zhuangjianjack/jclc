package com.example.slatejack.smartfrim1;

public class selectsw {
    String Obj;
    int ID;
    String Cmd;

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

    public selectsw(String Obj, int ID, String Cmd){
        super();
        this.Obj=Obj;
        this.ID=ID;
        this.Cmd=Cmd;
    }
}
