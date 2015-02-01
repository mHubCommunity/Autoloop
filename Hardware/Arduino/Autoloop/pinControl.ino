void initPins(){
  if(kDEBUG) Serial.println(F("\tinitPins()"));

  for(int i=0; i < sizeof(relayPins); i++){
    pinMode(relayPins[i], OUTPUT);
    digitalWrite(relayPins[i], HIGH);
  }

  if(kDEBUG) Serial.println(F("\tinitPins() done"));
}

void killPinsTimer(){
  for(int i = 0; i < sizeof(relayPins); i++) {
    wdt_reset();
    if(startedTime[i] + 65 < millis()) {
      digitalWrite(relayPins[i], HIGH);
    }
  }
}

void firePin(int pinNumber){
  if( pinNumber < sizeof(relayPins) ){
    digitalWrite(relayPins[pinNumber], LOW);
    startedTime[pinNumber] = millis();
  }
}
