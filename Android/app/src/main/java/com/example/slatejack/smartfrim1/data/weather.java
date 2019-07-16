package com.example.slatejack.smartfrim1.data;

public class weather {
   String time;
   cityInfo cityif;
   String date;
   String message;
   int status;
   data data;

   public String getTime() {
      return time;
   }

   public void setTime(String time) {
      this.time = time;
   }

   public cityInfo getCityif() {
      return cityif;
   }

   public void setCityif(cityInfo cityif) {
      this.cityif = cityif;
   }

   public String getDate() {
      return date;
   }

   public void setDate(String date) {
      this.date = date;
   }

   public String getMessage() {
      return message;
   }

   public void setMessage(String message) {
      this.message = message;
   }

   public int getStatus() {
      return status;
   }

   public void setStatus(int status) {
      this.status = status;
   }

   public com.example.slatejack.smartfrim1.data.data getData() {
      return data;
   }

   public void setData(com.example.slatejack.smartfrim1.data.data data) {
      this.data = data;
   }
}
