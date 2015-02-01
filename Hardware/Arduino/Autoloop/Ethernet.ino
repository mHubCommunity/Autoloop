void initEthernet(){
  if(kDEBUG) Serial.println(F("\tinitEthernet()"));
  
  byte mac[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };
  IPAddress ip(192, 168, 3, 10);
  IPAddress gateway(192, 168, 1, 254);	
  IPAddress subnet(255, 255, 0, 0);
  IPAddress dns(192, 168, 1, 254);
  
  Ethernet.begin(mac, ip, dns, gateway, subnet);
  udpServer.begin(kLOCAL_PORT);
  
  if(kDEBUG) Serial.println(F("\tinitEthernet() done"));
}

void lookForUDPMessages(){
  wdt_reset();
  if( udpServer.parsePacket() ){
    udpServer.read(packetBuffer, UDP_TX_PACKET_MAX_SIZE);
    
    if(kDEBUG){
      Serial.print(F("Raw Incoming: "));
      Serial.println(packetBuffer);
    }
    
    //Convert packet to int and fire
    int pinNumber = atoi(packetBuffer);
    firePin(pinNumber);
    //Clear the array otherwise short numbers build on long
    memset(packetBuffer,0,sizeof(packetBuffer));
    
    if(kDEBUG){
      if(pinNumber < sizeof(relayPins)){
        Serial.print(F("Pin Number: "));
        Serial.println(relayPins[pinNumber]);
        Serial.print(F("Free SRAM: "));
        Serial.println(freeRam());
      }else{
        Serial.println(F("Out of range"));
      }
    }
  }
}
