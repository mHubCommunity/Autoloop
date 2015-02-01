#include <SPI.h>       
#include <Ethernet.h>
#include <EthernetUdp.h>
#include <avr/wdt.h>

#define kLOCAL_PORT 8888
#define kDEBUG false

const uint8_t relayPins[] = {2, 3, 4, 5, 6, 7, 8, 9,
                    16, 17, 18, 19, 20, 21,
                    34, 35, 36, 37, 38, 39, 40,
                    41, 42, 43, 44, 46, 47,
                    48, 49};

unsigned long startedTime[sizeof(relayPins)];

//Ethernet
EthernetUDP udpServer;

//Buffers
char packetBuffer[UDP_TX_PACKET_MAX_SIZE];


void setup(){
  wdt_enable(WDTO_4S);
  wdt_reset();
  
  if(kDEBUG){
    Serial.begin(115200);
    Serial.println(F("setup()"));
    Serial.print("Relays: ");
    Serial.println(sizeof(relayPins));
  }
  
  initEthernet();
  initPins();
  
  if(kDEBUG) Serial.println(F("setup() done"));
  wdt_reset();
}

void loop(){
  wdt_reset();
  killPinsTimer();
  lookForUDPMessages();
}
