String inData;

unsigned long time;
unsigned long startedTime[50];

void setup() {
  for(int i=2;i<50;i++){
    pinMode(i,OUTPUT);
  }
  Serial.begin(57600);
}
void loop() {
  for(int i=2;i<50;i++) {
    if(startedTime[i] + 65 < millis() && startedTime[i] !=0) {
      digitalWrite(i,HIGH);
    }
  }
  while (Serial.available() > 0)
  {
    char recieved = Serial.read();
    if (recieved != '!')
    {
      inData += recieved; 
    }
    if (recieved == '!')
    {
      Serial.print("Arduino Received: ");
      Serial.println(inData.toInt());
      int PinNumber = inData.toInt();
      digitalWrite(PinNumber,LOW);
      startedTime[PinNumber] = millis();
      inData = ""; // Clear recieved buffer
    }
  }
}



