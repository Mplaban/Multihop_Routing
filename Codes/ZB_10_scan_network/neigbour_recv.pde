void neighbout_recv()
{

  // receive XBee packet (wait message for 20 seconds)
  error1 = xbeeZB.receivePacketTimeout( 20000 );

  // check answer
  if ( error1 == 0 )
  {
    wait_fl = 0;
    USB.println(F("\n1. New packet received"));

    // Show data stored in '_payload' buffer indicated by '_length'
    USB.print(F("--> Data: "));
    USB.println( xbeeZB._payload, xbeeZB._length);
    uint8_t *a = xbeeZB._payload;

    char b[100];
    for (int i = 0; i < xbeeZB._length; i++)
    {
      b[i] = a[i];
    }
    int n = atoi(b);
    //    USB.println(n);

    // Show data stored in '_payload' buffer indicated by '_length'


    // get Source's MAC address
    destination1[0] = xbeeZB._srcMAC[0];
    destination1[1] = xbeeZB._srcMAC[1];
    destination1[2] = xbeeZB._srcMAC[2];
    destination1[3] = xbeeZB._srcMAC[3];
    destination1[4] = xbeeZB._srcMAC[4];
    destination1[5] = xbeeZB._srcMAC[5];
    destination1[6] = xbeeZB._srcMAC[6];
    destination1[7] = xbeeZB._srcMAC[7];

    if (cluster_str == 0 && n==0)
    {
      cluster_head[0] = xbeeZB._srcMAC[0];
      cluster_head[1] = xbeeZB._srcMAC[1];
      cluster_head[2] = xbeeZB._srcMAC[2];
      cluster_head[3] = xbeeZB._srcMAC[3];
      cluster_head[4] = xbeeZB._srcMAC[4];
      cluster_head[5] = xbeeZB._srcMAC[5];
      cluster_head[6] = xbeeZB._srcMAC[6];
      cluster_head[7] = xbeeZB._srcMAC[7];

      USB.print(F("--> Cluster Head MAC address: "));
      USB.printHex( xbeeZB._srcMAC[0] );
      USB.printHex( xbeeZB._srcMAC[1] );
      USB.printHex( xbeeZB._srcMAC[2] );
      USB.printHex( xbeeZB._srcMAC[3] );
      USB.printHex( xbeeZB._srcMAC[4] );
      USB.printHex( xbeeZB._srcMAC[5] );
      USB.printHex( xbeeZB._srcMAC[6] );
      USB.printHex( xbeeZB._srcMAC[7] );
      USB.println();

      cluster_str = 1;
    }
    else if (cluster_str == 1 && n == 0)
    {
      lvl1_node[0] = xbeeZB._srcMAC[0];
      lvl1_node[1] = xbeeZB._srcMAC[1];
      lvl1_node[2] = xbeeZB._srcMAC[2];
      lvl1_node[3] = xbeeZB._srcMAC[3];
      lvl1_node[4] = xbeeZB._srcMAC[4];
      lvl1_node[5] = xbeeZB._srcMAC[5];
      lvl1_node[6] = xbeeZB._srcMAC[6];
      lvl1_node[7] = xbeeZB._srcMAC[7];
      USB.print(F("--> Level 1 MAC address: "));
      USB.printHex( xbeeZB._srcMAC[0] );
      USB.printHex( xbeeZB._srcMAC[1] );
      USB.printHex( xbeeZB._srcMAC[2] );
      USB.printHex( xbeeZB._srcMAC[3] );
      USB.printHex( xbeeZB._srcMAC[4] );
      USB.printHex( xbeeZB._srcMAC[5] );
      USB.printHex( xbeeZB._srcMAC[6] );
      USB.printHex( xbeeZB._srcMAC[7] );
      USB.println();
      cluster_str=2;
    }

    if (n > 0 && n < 4)
    {
      flag = 1;
      level = n;
      src_addr[0] = destination1[0];
      src_addr[1] = destination1[1];
      src_addr[2] = destination1[2];
      src_addr[3] = destination1[3];
      src_addr[4] = destination1[4];
      src_addr[5] = destination1[5];
      src_addr[6] = destination1[6];
      src_addr[7] = destination1[7];

      USB.print(F("--> Level: "));
      USB.println(level);

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

    }
    else
    {
      USB.print(F("--> Length: "));
      USB.println(xbeeZB._length, DEC);

      // Show data stored in '_payload' buffer indicated by '_length'
      USB.print(F("--> Source MAC address: "));
      USB.printHex( destination1[0] );
      USB.printHex( destination1[1] );
      USB.printHex( destination1[2] );
      USB.printHex( destination1[3] );
      USB.printHex( destination1[4] );
      USB.printHex( destination1[5] );
      USB.printHex( destination1[6] );
      USB.printHex( destination1[7] );
      USB.println();

      // insert small delay to wait TX node
      // to prepare to receive messages
      delay(1000);


      /*** Send message to TX node ***/

      USB.println(F("\n2. Send a response to the TX node: "));

      // send XBee packet
      error1 = xbeeZB.send( destination1, "Message_from_RX_node" );

      // check TX flag
      if ( error1 == 0 )
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

    }
    //    flag = 1;
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
    USB.print(F("Waiting"));
    USB.println(error, DEC);
    wait_fl += 1;
    if (wait_fl > 6)
      flag = 1;
    else
      flag = 0;
  }


  USB.println(F("\n----------------------------------"));
}

