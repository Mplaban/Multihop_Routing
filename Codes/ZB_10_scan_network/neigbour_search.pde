void search_neigh()
{
   cluster_head[8]=0;
   lvl1_node[8]=0;
   cluster_str=0;
   final_dest[8] = 0;
   src_addr[8] = 0;
   max_rssi=100;
  if (start_fl == 1)
  {
    USB.println(F("Delay Started"));
    xbeeZB.OFF();
    delay(35000);
    xbeeZB.ON();
    USB.println(F("Delay Sucess"));

  }
  USB.print(F("Started"));
  //////////////////////////
  // 2. check XBee's network parameters
  //////////////////////////

  while (flag == 0)
    neighbout_recv();
  if (level > 0 && level < 3)
  {
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
    delay(2000);
    //  flag=1;
  }
  if (final_dest[0] == 0 && final_dest[1] == 0 && final_dest[2] == 0 && final_dest[3] == 0 && final_dest[4] == 0 && final_dest[5] == 0 && final_dest[6] == 0 && final_dest[7] == 0)
  {
    USB.println(F("This is End Node"));
    flag2 = 1;
    fwd_flag = 1;
    end_fl = 1;
    USB.println("Moving to Forwading mode");
  }
  else
  {
    end_fl = 0;
    char lev [30];
    error1 = xbeeZB.send( final_dest, itoa(level + 1, lev, 20 ));

    // check TX flag
    if ( error1 == 0 )
    {
      USB.println(F("Send Recving end ok"));
    }
  }
  start_fl = 1;
}

