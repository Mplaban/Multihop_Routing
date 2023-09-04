/*
    ------   Cluster Head Code     --------

*/

#include <WaspXBeeZB.h>
#include <WaspFrame.h>

uint8_t error, error1;
uint8_t destination[3][8];
uint8_t final_dest[8];
uint8_t dest[8], destination1[8];
int rssi, max_rssi = 100;
int rssi_str[4];
int tot_neighbours;
int i = 0;
long lastMsg = 0;
int flag, send_wait, flag_send;

void setup()
{
  // init USB port
  USB.ON();
  USB.println(F("ZB_10 main"));
  frame.setID("node_TX");
  //////////////////////////
  // 1. init XBee
  //////////////////////////
  xbeeZB.ON();

  delay(3000);

  //////////////////////////
  // 2. check XBee's network parameters
  //////////////////////////
  checkNetworkParams();

  ////////////////////////////////
  // 3. scan network
  ////////////////////////////////
  USB.print(F("\n Scanning"));
  xbeeZB.scanNetwork();

  ////////////////////////////////
  // 4. print info
  ////////////////////////////////

  USB.print(F("\n\ntotalScannedBrothers:"));
  USB.println(xbeeZB.totalScannedBrothers, DEC);
  tot_neighbours = xbeeZB.totalScannedBrothers;
  // print all scanned nodes information
  printScanInfo();
  find_neigh();
  //  flag=1;
  error1 = xbeeZB.send( final_dest, "1" );

  // check TX flag
  if ( error1 == 0 )
  {
    USB.println(F("Send end Receiving ok"));
  }
}
int er = 0;
void loop()
{
  if (flag_send == 0)
  {
    long now = millis();
    if ((now - lastMsg) > 45000) {
      lastMsg = now;
      USB.print(F("--> Final Address: "));
      USB.printHex( final_dest[0] );
      USB.printHex( final_dest[1] );
      USB.printHex( final_dest[2] );
      USB.printHex( final_dest[3] );
      USB.printHex( final_dest[4] );
      USB.printHex( final_dest[5] );
      USB.printHex( final_dest[6] );
      USB.printHex( final_dest[7] );
      USB.println();
      send_wait += 1;
      if (send_wait > 2)
      {
        error1 = xbeeZB.send( final_dest, "Hello from Cluster Head" );
        if ( error1 == 0 )
        {
          flag_send = 1;
          USB.println(F("Send Forwading mssg"));

        }
        else
        {
          USB.println(F("Error2"));
          flag_send = 0;
          network_scan();

        }
        send_wait = 0;
      }
    }
  }
  else
  {
    USB.println(F("Flag send 1 "));
    delay(20000);
    USB.print(F("--> Final Address: "));
    USB.printHex( final_dest[0] );
    USB.printHex( final_dest[1] );
    USB.printHex( final_dest[2] );
    USB.printHex( final_dest[3] );
    USB.printHex( final_dest[4] );
    USB.printHex( final_dest[5] );
    USB.printHex( final_dest[6] );
    USB.printHex( final_dest[7] );
    USB.println();
    error1 = xbeeZB.send( final_dest, "Hello from Cluster Head" );
    if ( error1 == 0 )
    {
      flag_send = 1;
      USB.println(F("Send Forwading mssg"));

    }
    else
    {
      USB.println(F("Error4"));
      flag_send = 0;
      network_scan();

    }

  }

}

void find_neigh()
{


  // 1.1. create new frame
  frame.createFrame(ASCII);

  // 1.2. add frame fields
  frame.addSensor(SENSOR_STR, "Complete example message");
  frame.addSensor(SENSOR_BAT, PWR.getBatteryLevel() );

  USB.println(F("\n1. Created frame to be sent"));
  frame.showFrame();

  //////////////////////////
  // 2. send packet
  //////////////////////////

  for (int i = 0; i < tot_neighbours; i++)
  {

    // send XBee packet
    error = xbeeZB.send( destination[i], frame.buffer, frame.length );

    USB.println(F("\n2. Send a packet to the RX node: "));

    // check TX flag
    if ( error == 0 )
    {
      USB.println(F("send ok"));

      // blink green LED
      Utils.blinkGreenLED();
    }
    else
    {
      USB.println(F("send error"));

      // blink red LED
      Utils.blinkRedLED();
    }


    //////////////////////////
    // 3. receive answer
    //////////////////////////

    USB.println(F("\n3. Wait for an incoming message"));

    // receive XBee packet
    error = xbeeZB.receivePacketTimeout( 10000 );

    // check answer
    if ( error == 0 )
    {
      // Show data stored in '_payload' buffer indicated by '_length'
      USB.print(F("--> Data: "));
      USB.println( xbeeZB._payload, xbeeZB._length);


      // Show data stored in '_payload' buffer indicated by '_length'
      USB.print(F("--> Length: "));
      USB.println( xbeeZB._length, DEC);

      // Show data stored in '_payload' buffer indicated by '_length'
      USB.print(F("--> Source MAC address: "));
      USB.printHex( xbeeZB._srcMAC[0] );
      USB.printHex( xbeeZB._srcMAC[1] );
      USB.printHex( xbeeZB._srcMAC[2] );
      USB.printHex( xbeeZB._srcMAC[3] );
      USB.printHex( xbeeZB._srcMAC[4] );
      USB.printHex( xbeeZB._srcMAC[5] );
      USB.printHex( xbeeZB._srcMAC[6] );
      USB.printHex( xbeeZB._srcMAC[7] );
      USB.println();

      // Getting RSSI using the API function
      // This function returns the last received packet's RSSI
      xbeeZB.getRSSI();

      // check AT flag
      if ( xbeeZB.error_AT == 0 )
      {
        USB.print(F("getRSSI(dBm): "));

        //get rssi from getRSSI function and make conversion
        rssi = xbeeZB.valueRSSI[0];
        rssi_str[i] = rssi;
        rssi *= -1;
        USB.println(rssi, DEC);
      }
      USB.println();
      if (rssi_str[i] < max_rssi)
      {
        max_rssi = rssi_str[i];
        final_dest[0] = destination[i][0];
        final_dest[1] = destination[i][1];
        final_dest[2] = destination[i][2];
        final_dest[3] = destination[i][3];
        final_dest[4] = destination[i][4];
        final_dest[5] = destination[i][5];
        final_dest[6] = destination[i][6];
        final_dest[7] = destination[i][7];
      }

    }
    else
    {
      // Print error message:
      /*
         '7' : Buffer full. Not enough memory space
         '6' : Error escaping character within payload bytes
         '5' : Error escaping character in checksum byte
         '4' : Checksum is not correct
         '3' : Checksum byte is not available
         '2' : Frame Type is not valid
         '1' : Timeout when receiving answer
      */
      USB.print(F("Error receiving a packet:"));
      USB.println(error, DEC);
    }

    // wait for 5 seconds
    USB.println(F("\n----------------------------------"));
    delay(2000);
  }
  USB.print(F("\n Total Neigbours Discovered :"));
  USB.println(tot_neighbours);
  delay(2000);
}


/*
    printScanInfo

    This function prints all info related to the scan
    process given by the XBee module
*/
void printScanInfo()
{
  USB.println(F("----------------------------"));

  for (int i = 0; i < xbeeZB.totalScannedBrothers; i++)
  {
    USB.print(F("MAC:"));
    USB.printHex(xbeeZB.scannedBrothers[i].SH[0]);
    USB.printHex(xbeeZB.scannedBrothers[i].SH[1]);
    USB.printHex(xbeeZB.scannedBrothers[i].SH[2]);
    USB.printHex(xbeeZB.scannedBrothers[i].SH[3]);
    USB.printHex(xbeeZB.scannedBrothers[i].SL[0]);
    USB.printHex(xbeeZB.scannedBrothers[i].SL[1]);
    USB.printHex(xbeeZB.scannedBrothers[i].SL[2]);
    USB.printHex(xbeeZB.scannedBrothers[i].SL[3]);

    destination[i][0] = xbeeZB.scannedBrothers[i].SH[0];
    destination[i][1] = xbeeZB.scannedBrothers[i].SH[1];
    destination[i][2] = xbeeZB.scannedBrothers[i].SH[2];
    destination[i][3] = xbeeZB.scannedBrothers[i].SH[3];
    destination[i][4] = xbeeZB.scannedBrothers[i].SL[0];
    destination[i][5] = xbeeZB.scannedBrothers[i].SL[1];
    destination[i][6] = xbeeZB.scannedBrothers[i].SL[2];
    destination[i][7] = xbeeZB.scannedBrothers[i].SL[3];


    USB.print(F("\nNI:"));
    USB.print(xbeeZB.scannedBrothers[i].NI);

    USB.print(F("\nDevice Type:"));
    switch (xbeeZB.scannedBrothers[i].DT)
    {
      case 0:
        USB.print(F("Coordinator"));
        break;
      case 1:
        USB.print(F("Router"));
        break;
      case 2:
        USB.print(F("End Device"));
        break;
    }

    USB.print(F("\nPMY:"));
    USB.printHex(xbeeZB.scannedBrothers[i].PMY[0]);
    USB.printHex(xbeeZB.scannedBrothers[i].PMY[1]);

    USB.print(F("\nPID:"));
    USB.printHex(xbeeZB.scannedBrothers[i].PID[0]);
    USB.printHex(xbeeZB.scannedBrothers[i].PID[1]);

    USB.print(F("\nMID:"));
    USB.printHex(xbeeZB.scannedBrothers[i].MID[0]);
    USB.printHex(xbeeZB.scannedBrothers[i].MID[1]);

    USB.println(F("\n----------------------------"));

  }
}





/*******************************************

    checkNetworkParams - Check operating
    network parameters in the XBee module

 *******************************************/
void checkNetworkParams()
{
  // 1. get operating 64-b PAN ID
  xbeeZB.getOperating64PAN();

  // 2. wait for association indication
  xbeeZB.getAssociationIndication();

  while ( xbeeZB.associationIndication != 0 )
  {
    delay(2000);

    // get operating 64-b PAN ID
    xbeeZB.getOperating64PAN();

    USB.print(F("operating 64-b PAN ID: "));
    USB.printHex(xbeeZB.operating64PAN[0]);
    USB.printHex(xbeeZB.operating64PAN[1]);
    USB.printHex(xbeeZB.operating64PAN[2]);
    USB.printHex(xbeeZB.operating64PAN[3]);
    USB.printHex(xbeeZB.operating64PAN[4]);
    USB.printHex(xbeeZB.operating64PAN[5]);
    USB.printHex(xbeeZB.operating64PAN[6]);
    USB.printHex(xbeeZB.operating64PAN[7]);
    USB.println();

    xbeeZB.getAssociationIndication();
  }

  USB.println(F("\nJoined a network!"));

  // 3. get network parameters
  xbeeZB.getOperating16PAN();
  xbeeZB.getOperating64PAN();
  xbeeZB.getChannel();

  USB.print(F("operating 16-b PAN ID: "));
  USB.printHex(xbeeZB.operating16PAN[0]);
  USB.printHex(xbeeZB.operating16PAN[1]);
  USB.println();

  USB.print(F("operating 64-b PAN ID: "));
  USB.printHex(xbeeZB.operating64PAN[0]);
  USB.printHex(xbeeZB.operating64PAN[1]);
  USB.printHex(xbeeZB.operating64PAN[2]);
  USB.printHex(xbeeZB.operating64PAN[3]);
  USB.printHex(xbeeZB.operating64PAN[4]);
  USB.printHex(xbeeZB.operating64PAN[5]);
  USB.printHex(xbeeZB.operating64PAN[6]);
  USB.printHex(xbeeZB.operating64PAN[7]);
  USB.println();

  USB.print(F("channel: "));
  USB.printHex(xbeeZB.channel);
  USB.println();

}





