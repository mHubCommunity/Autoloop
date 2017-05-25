
String SerinData;

unsigned long time;
unsigned long startedTime[50];

#include <SPI.h>         // needed for Arduino versions later than 0018
#include <Ethernet.h>
#include <EthernetUdp.h>         // UDP library from: bjoern@cs.stanford.edu 12/30/2008


// Enter a MAC address and IP address for your controller below.
// The IP address will be dependent on your local network:
byte mac[] = {  
  0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };
IPAddress ip(10, 1, 10, 177);

unsigned int localPort = 8888;      // local port to listen on

// buffers for receiving and sending data
char packetBuffer[UDP_TX_PACKET_MAX_SIZE]; //buffer to hold incoming packet,
char  ReplyBuffer[] = "acknowledged";       // a string to send back

// An EthernetUDP instance to let us send and receive packets over UDP
EthernetUDP Udp;

void setup() {

  Serial.begin(57600);

  // start the Ethernet and UDP:
  Ethernet.begin(mac,ip);
  Udp.begin(localPort);
  Serial.println("EthernetConnected");

  for(int i=2;i<50;i++){
    pinMode(i,OUTPUT);
  }


}

void loop() {


  for(int i=2;i<50;i++) {
    if(startedTime[i] + 65 < millis()) {
      digitalWrite(i,HIGH);
    }
  }


  while (Serial.available() > 0)
  {
    char recieved = Serial.read();
    if (recieved != '!')
    {
      SerinData += recieved; 
    }

    if (recieved == 13)
    {
      Serial.print("Arduino Received: ");
      Serial.println(SerinData.toInt());
      int PinNumber = SerinData.toInt();
      digitalWrite(PinNumber,LOW);
      startedTime[PinNumber] = millis();
      SerinData = ""; // Clear recieved buffer
    }
  }


  // if there's data available, read a packet
  int packetSize = Udp.parsePacket();


  if(packetSize == 8)
  {
    Serial.print("Received packet of size ");
    Serial.println(packetSize);
    Serial.print("From ");
    IPAddress remote = Udp.remoteIP();
    for (int i =0; i < 4; i++)
    {
      Serial.print(remote[i], DEC);
      if (i < 3)
      {
        Serial.print(".");
      }
    }
    Serial.print(", port ");
    Serial.println(Udp.remotePort());

    // read the packet into packetBufffer
    Udp.read(packetBuffer,UDP_TX_PACKET_MAX_SIZE);
    Serial.println("Contents:");

    String inData;

    for (int i =0; i < 4; i++)
    { 
      char recieved = packetBuffer[i];
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
  else{
  }
}








