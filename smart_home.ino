#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266mDNS.h>
#include <ESP8266HTTPClient.h>
#include <FirebaseESP8266.h>


#ifndef STASSID
#define STASSID "WIFISSID"
#define STAPSK "WIIFIPASS"
#define FIREBASE_HOST "" 
#define FIREBASE_AUTH ""
#endif

const char* ssid = STASSID;
const char* password = STAPSK;

FirebaseData firebaseData;

#define LIGHT D1
#define AC D2
#define TV D3
#define FAN D4


void setup() {

  pinMode(LIGHT, OUTPUT);
  pinMode(AC, OUTPUT);
  pinMode(TV, OUTPUT);
  pinMode(FAN, OUTPUT);


  Serial.begin(115200);
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);
  Serial.println("");

  while (WiFi.status() != WL_CONNECTED){
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.print(" Connted to ==> ");
  Serial.println(ssid);
  Serial.print("IP Address ==> ");
  Serial.println(WiFi.localIP());

  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);  

  Firebase.reconnectWiFi(true);
  delay(1000);
}

void loop() {
  if (Firebase.get(firebaseData, "/Smart AC/status")) {
      bool smartACValue = firebaseData.boolData();
      Serial.print("Value at /Smart AC: ");
      Serial.println(smartACValue);
      if(smartACValue){
          digitalWrite(AC, HIGH);
          delay(4000);  
      } else {
          digitalWrite(AC, LOW);
          delay(1000);  
      }
  
  } else {
    Serial.print("Firebase Error: ");
    Serial.println(firebaseData.errorReason());
  }

  if (Firebase.get(firebaseData, "/Smart Fan/status")) {
      bool smartFanValue = firebaseData.boolData();
      Serial.print("Value at /Smart Fan: ");
      Serial.println(smartFanValue);
      if(smartFanValue){
          digitalWrite(FAN, HIGH); 
          // delay(4000);  
      } else {
          digitalWrite(FAN, LOW); 
          // delay(1000);  
      }
  
  } else {
    Serial.print("Firebase Error: ");
    Serial.println(firebaseData.errorReason());
  }


  if (Firebase.get(firebaseData, "/Smart Light/status")) {
      bool smartLightValue = firebaseData.boolData();
      Serial.print("Value at /Smart Light: ");
      Serial.println(smartLightValue);
      if(smartLightValue){
          digitalWrite(LIGHT, HIGH); 
      }else{
          digitalWrite(LIGHT, LOW); 
      }
  
  } else {
    Serial.print("Firebase Error: ");
    Serial.println(firebaseData.errorReason());
  }


  if (Firebase.get(firebaseData, "/Smart TV/status")) {
      bool smartTVValue = firebaseData.boolData();
      Serial.print("Value at /Smart TV: ");
      Serial.println(smartTVValue);

      if(smartTVValue){
          digitalWrite(TV, HIGH); 

      }else {
          digitalWrite(TV, LOW); 

      }
  
  } else {
    Serial.print("Firebase Error: ");
    Serial.println(firebaseData.errorReason());
  }
}
