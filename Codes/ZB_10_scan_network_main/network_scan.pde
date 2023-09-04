void network_scan()
{
  max_rssi=100;
   rssi_str[4]={};
  delay(20000);
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
  delay(5000);
  //  flag=1;
  error1 = xbeeZB.send( final_dest, "1" );

  // check TX flag
  if ( error1 == 0 )
  {
    USB.println(F("send recv end ok"));
  }
  
}

