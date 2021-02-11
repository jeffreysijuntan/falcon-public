
#!/bin/bash
USERNAME=ubuntu

#LAN->1,2,3
IP1=100.25.131.222		#Oregon
IP2=100.26.236.168		#Oregon
IP3=54.197.21.135	    #Oregon

#WAN->1,4,5
IP4=52.23.63.224			#Virginia
IP5=54.215.77.155			#Cali


#########################################################################################
NETWORK=AlexNet			# NETWORK {SecureML, Sarda, MiniONN, LeNet, AlexNet, and VGG16}
DATASET=ImageNet		# DATASET {MNIST, CIFAR10, and ImageNet}
SECURITY=Semi-honest 		# SECURITY {Semi-honest or Malicious} 
RUN_TYPE=LAN 				# RUN_TYPE {LAN or WAN or localhost}
PRINT_TO_FILE=false			# PRINT_TO_FILE {true or false}
FILENAME=time.txt
#########################################################################################

if [[ $PRINT_TO_FILE = true ]]; then
	printf "%s\n" "---------------------------------------------" >> $FILENAME
	printf "%s %s %s %s\n" $RUN_TYPE $NETWORK $DATASET $SECURITY >> $FILENAME
	printf "%s\n" "---------------------------------------------" >> $FILENAME
fi


if [[ $RUN_TYPE = LAN ]]; then
	sudo ssh -i ~/.ssh/east.pem $USERNAME@$IP1 "cd falcon-public; pkill Falcon.out; echo clean completed; make -j; chmod +x Falcon.out; ./Falcon.out 0 files/IP_$RUN_TYPE files/keyA files/keyAB files/keyAC $NETWORK $DATASET $SECURITY 1>./time.txt; less time.txt" & 
	sudo ssh -i ~/.ssh/east.pem $USERNAME@$IP2 "cd falcon-public; pkill Falcon.out; echo clean completed; make -j; chmod +x Falcon.out; ./Falcon.out 1 files/IP_$RUN_TYPE files/keyA files/keyAB files/keyAC $NETWORK $DATASET $SECURITY 1>./time.txt" & 
	sudo ssh -i ~/.ssh/east.pem $USERNAME@$IP3 "cd falcon-public; pkill Falcon.out; echo clean completed; make -j; chmod +x Falcon.out; ./Falcon.out 2 files/IP_$RUN_TYPE files/keyA files/keyAB files/keyAC $NETWORK $DATASET $SECURITY 1>./time.txt" & 
elif [[ $RUN_TYPE = WAN ]]; then
	ssh -i ~/.ssh/falcon_ohio.pem $USERNAME@$IP1 "pkill Falcon.out; echo clean completed; cd malicious-security; make -j; chmod +x Falcon.out; ./Falcon.out 0 files/IP_$RUN_TYPE files/keyA files/keyAB files/keyAC $NETWORK $DATASET $SECURITY 1>./time.txt; less time.txt" & 
	ssh -i ~/.ssh/falcon_virg.pem $USERNAME@$IP4 "pkill Falcon.out; echo clean completed; cd malicious-security; make -j; chmod +x Falcon.out; ./Falcon.out 1 files/IP_$RUN_TYPE files/keyA files/keyAB files/keyAC $NETWORK $DATASET $SECURITY 1>./time.txt" & 
	ssh -i ~/.ssh/falcon_cali.pem $USERNAME@$IP5 "pkill Falcon.out; echo clean completed; cd malicious-security; make -j; chmod +x Falcon.out; ./Falcon.out 2 files/IP_$RUN_TYPE files/keyA files/keyAB files/keyAC $NETWORK $DATASET $SECURITY 1>./time.txt" & 
elif [[ $RUN_TYPE = localhost ]]; then
	make
	./Falcon.out 1 files/IP_$RUN_TYPE files/keyB files/keyBC files/keyAB $NETWORK $DATASET $SECURITY >/dev/null &
	./Falcon.out 2 files/IP_$RUN_TYPE files/keyC files/keyAC files/keyBC $NETWORK $DATASET $SECURITY >/dev/null &
	if [[ $PRINT_TO_FILE = true ]]; then
		./Falcon.out 0 files/IP_$RUN_TYPE files/keyA files/keyAB files/keyAC $NETWORK $DATASET $SECURITY >> $FILENAME
	else
		./Falcon.out 0 files/IP_$RUN_TYPE files/keyA files/keyAB files/keyAC $NETWORK $DATASET $SECURITY 
	fi
else
	echo "RUN_TYPE error" 
fi




########################################## SET-UP COMMANDS ##########################################
#sudo apt-get update; sudo apt-get install g++; sudo apt-get install libssl-dev; sudo apt install make; sudo apt-get install iperf3 
#git clone https://github.com/snwagh/malicious-security.git; cd malicious-security

# ssh -i ~/.ssh/falcon_sp_oregon.pem ubuntu@18.237.39.209
# ssh -i ~/.ssh/falcon_sp_oregon.pem ubuntu@34.221.35.166
# ssh -i ~/.ssh/falcon_sp_oregon.pem ubuntu@34.219.97.126
