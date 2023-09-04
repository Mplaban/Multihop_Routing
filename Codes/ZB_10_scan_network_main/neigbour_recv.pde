void neighbout_recv()
{

   // receive XBee packet (wait message for 20 seconds)
  error1 = xbeeZB.receivePacketTimeout( 20000 );

  // check answer  
  if( error1 == 0 ) 
  {    
    USB.println(F("\n1. New packet received"));
    
    // Show data stored in '_payload' buffer indicated by '_length'
    USB.print(F("--> Data: "));  
    USB.println( xbeeZB._payload, xbeeZB._length);
    
    // Show data stored in '_payload' buffer indicated by '_length'
    USB.print(F("--> Length: "));  
    USB.println( xbeeZB._length,DEC);


    /*** Available info in library structure ***/

    // get Source's MAC address
    destination1[0] = xbeeZB._srcMAC[0]; 
    destination1[1] = xbeeZB._srcMAC[1]; 
    destination1[2] = xbeeZB._srcMAC[2]; 
    destination1[3] = xbeeZB._srcMAC[3]; 
    destination1[4] = xbeeZB._srcMAC[4]; 
    destination1[5] = xbeeZB._srcMAC[5]; 
    destination1[6] = xbeeZB._srcMAC[6]; 
    destination1[7] = xbeeZB._srcMAC[7]; 
    
    
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
    if( error1 == 0 )
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
  else
  {
    // Print error message:
    /*
     * '7' : Buffer full. Not enough memory space
     * '6' : Error escaping character within payload bytes
     * '5' : Error escaping character in checksum byte
     * '4' : Checksum is not correct    
     * '3' : Checksum byte is not available 
     * '2' : Frame Type is not valid
     * '1' : Timeout when receiving answer   
     */
    USB.print(F("Error receiving a packet:"));
    USB.println(error,DEC);
     flag=0;     
  }
  
 
  USB.println(F("\n----------------------------------"));
}

