Multihop Routing

Setting up Zigbee nodes:
1. Open XCTU software and plugin zigbee modules one by one.
2. Configure one of the node as Co-ordinator and rest three nodes as Router.
3. Set all zigbee module in API-2 mode.
4. Set up baudrate to 15200
5. Connect each module to one waspmote.

Configuring PAN ID:
1. To configure Cluster Head waspmote(Cordinator node) upload example code "Cordinator Creates a Network" and open Serial Monitor. The cordinator mode will be enabled and PAN ID will be set to create a network.

2. To configure each cluster member waspmote (Router nodes) upload example code "Router Joins Unknown Network" and open Serial Monitor( keeping the Cluster Head Waspmote operating). The router mode will be enabled and PAN ID will be set such that the router will join the network of the cordinator.

Codes:

1. ZB_10_scan_network_main (Code for Cluster Head)

	Special Variables:
	1.final_dest[8] -Stores 64 bit MAC address of next level node. It is of uint8_t type.

	Tabs:
	1.ZB_10_scan_network_main:
		a. find_neigh() - This function is used by node to send message to the discovered zigbee nodes nearby and get a response from it and store the RSSI of the node calculate the 		min rssi to find the nearest neighbour.
		b. printScanInfo() - This function is used to print the info of dicovered zigbee modules nearby.
		c. checkNetworkParams() - This function check the network information whether zigbee is connected to a network.
		d. setup() - This setups the zigbee module network and initialises zigbee module and turns it on.
		e. loop() - The receiving mode and message send to last node through multihop. 

	2.neighbour_recv: neighbour_recv()- This function enables recieving mode of mote.

	3.network_scan: network_scan()- This function scans the network for neighbour and call the reqd functions to find and store the nearest node.


2. ZB_10_scan_network (Code for cluster members)

	Special variables:
	1.cluster_head[8] - Stores 64 bit MAC address of cluster head. It is of uint8_t type.
	2.src_addr[8] - Stores 64 bit MAC address of src from which it received acknowlodgement to star neighbour discovery and exit receiving mode. It is of uint8_t type.
	3.final_dest[8] -Stores 64 bit MAC address of next level node. It is of uint8_t type.
	4.lvl1_node[8] -Stores 64 bit MAC address of level-1 head. It is of uint8_t type.
	
	Tabs:
	1.ZB_10_scan_network_main:
		a. find_neigh() - This function is used by node to send message to the discovered zigbee nodes nearby and get a response from it and store the RSSI of the node and calculate 		the min rssi to find the nearest neighbour.
		b. printScanInfo() - This function is used to print the info of dicovered zigbee modules nearby.
		c. checkNetworkParams() - This function check the network information whether zigbee is connected to a network.
		d. setup() - This setups the zigbee module network and initialises zigbee module and turns it on and puts it in receiving mode.
		e. loop() - The receiving mode and forwarding message send to next node and if it's last node a message is displayed "Last node Reached".

	2.neighbour_recv: neighbour_recv()- This function enables recieving mode of mote.

	3.network_scan: network_scan()- This function scans the network for neighbour and call the reqd functions to find and store the nearest node.

--> Upload the first code in cluster head mote and the second code in the other motes.