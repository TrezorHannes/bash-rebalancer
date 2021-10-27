#!/bin/bash
# A sample Bash script, by Hakuna
#ToDo: 
# Add selection process: https://ryanstutorials.net/bash-scripting-tutorial/bash-loops.php#select
# to allow for selecting the fee-settings: fee-factor, fee-limit or fee-ppm-limit

activate () {
  . ../.venv/bin/activate
}

helpFunction()
{
   echo "FUCK - something went wrong"
   echo "Usage: $0 -a parameterA -b parameterB -c parameterC"
   echo -e "\t-f For Fee-Factor parameterA"
   echo -e "\t-d For Direction push (f) or pull (t) liquidity parameterB"
   echo -e "\t-j Single channel ID of first and required channel"
   echo -e "\t-k-p arguments allow for passing additional optional channels to rebalance"
   exit 1 # Exit script after printing help
}

while getopts "f:d:r:j:k:l:m:n:o:p:" opt
do
   case "$opt" in
      f ) parameterF="$OPTARG" ;;
      d ) parameterD="$OPTARG" ;;
      j ) parameterJ="$OPTARG" ;;
      k ) parameterK="$OPTARG" ;;
      l ) parameterL="$OPTARG" ;;
      m ) parameterM="$OPTARG" ;;
      n ) parameterN="$OPTARG" ;;
      o ) parameterO="$OPTARG" ;;
      p ) parameterP="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case essential parameter is non-existent
   esac
done

# Print helpFunction in case parameters are empty
if [ -z "$parameterF" ] || [ -z "$parameterD" ] || [ -z "$parameterJ" ]
then
   echo "Required parameters are empty";
   helpFunction
fi

# Begin script in case all parameters are correct
echo "Fee Factor is\t\t\t\t> $parameterF"
echo "Direction Push (f) or Pull (t) is\t> $parameterD"
echo "Channel ID 1 is\t\t\t\t> $parameterJ"
echo "Channel ID 2 is\t\t\t\t> $parameterK"
echo "Channel ID 3 is\t\t\t\t> $parameterL"
echo "Channel ID 4 is\t\t\t\t> $parameterM"
echo "Channel ID 5 is\t\t\t\t> $parameterN"
echo "Channel ID 6 is\t\t\t\t> $parameterO"
echo "Channel ID 7 is\t\t\t\t> $parameterP"

rebalance_something () {

#Channel 1
	echo "Starting the rebalancing with Ratio $1 on Channel 1"

	python ~/rebalance-lnd/rebalance.py --lnddir ~/umbrel/lnd/ --fee-factor $parameterF -$parameterD $parameterJ -p $1
	python ~/rebalance-lnd/rebalance.py --lnddir ~/umbrel/lnd/ --fee-factor $parameterF -$parameterD $parameterJ -p $2
	python ~/rebalance-lnd/rebalance.py --lnddir ~/umbrel/lnd/ --fee-factor $parameterF -$parameterD $parameterJ -p $3
	python ~/rebalance-lnd/rebalance.py --lnddir ~/umbrel/lnd/ --fee-factor $parameterF -$parameterD $parameterJ -p $4
	python ~/rebalance-lnd/rebalance.py --lnddir ~/umbrel/lnd/ --fee-factor $parameterF -$parameterD $parameterJ
if [ -z "$parameterK" ] 
then
   	echo "We are done for now with Channel 1 concluding, Pleb";

else
	echo "Starting the rebalancing with Ratio $1 on Channel 2"
	python ~/rebalance-lnd/rebalance.py --lnddir ~/umbrel/lnd/ --fee-factor $parameterF -$parameterD $parameterK -p $1
	python ~/rebalance-lnd/rebalance.py --lnddir ~/umbrel/lnd/ --fee-factor $parameterF -$parameterD $parameterK -p $2
	python ~/rebalance-lnd/rebalance.py --lnddir ~/umbrel/lnd/ --fee-factor $parameterF -$parameterD $parameterK -p $3
	python ~/rebalance-lnd/rebalance.py --lnddir ~/umbrel/lnd/ --fee-factor $parameterF -$parameterD $parameterK -p $4
	python ~/rebalance-lnd/rebalance.py --lnddir ~/umbrel/lnd/ --fee-factor $parameterF -$parameterD $parameterK

	if [ -z "$parameterL" ]
	then
        	echo "We are done for now with Channel 2 concluding, Pleb";
	else 
        	echo "Starting the rebalancing with Ratio $1 on Channel 3"
		python ~/rebalance-lnd/rebalance.py --lnddir ~/umbrel/lnd/ --fee-factor $parameterF -$parameterD $parameterL -p $1
		python ~/rebalance-lnd/rebalance.py --lnddir ~/umbrel/lnd/ --fee-factor $parameterF -$parameterD $parameterL -p $2
		python ~/rebalance-lnd/rebalance.py --lnddir ~/umbrel/lnd/ --fee-factor $parameterF -$parameterD $parameterL -p $3
		python ~/rebalance-lnd/rebalance.py --lnddir ~/umbrel/lnd/ --fee-factor $parameterF -$parameterD $parameterL -p $4
		python ~/rebalance-lnd/rebalance.py --lnddir ~/umbrel/lnd/ --fee-factor $parameterF -$parameterD $parameterL

		if [ -z "$parameterM" ] 
		then
		        echo "We are done for now with Channel 3 concluding, Pleb";
		else 
		        echo "Starting the rebalancing with Ratio $1 on Channel 4"
			python ~/rebalance-lnd/rebalance.py --lnddir ~/umbrel/lnd/ --fee-factor $parameterF -$parameterD $parameterM -p $1
			python ~/rebalance-lnd/rebalance.py --lnddir ~/umbrel/lnd/ --fee-factor $parameterF -$parameterD $parameterM -p $2
			python ~/rebalance-lnd/rebalance.py --lnddir ~/umbrel/lnd/ --fee-factor $parameterF -$parameterD $parameterM -p $3
			python ~/rebalance-lnd/rebalance.py --lnddir ~/umbrel/lnd/ --fee-factor $parameterF -$parameterD $parameterM -p $4
			python ~/rebalance-lnd/rebalance.py --lnddir ~/umbrel/lnd/ --fee-factor $parameterF -$parameterD $parameterM
			if [ -z "$parameterN" ] 
			then
			        echo "We are done for now with Channel 4 concluding, Pleb";
			else 
			        echo "Starting the rebalancing with Ratio $1 on Channel 5"
				python ~/rebalance-lnd/rebalance.py --lnddir ~/umbrel/lnd/ --fee-factor $parameterF -$parameterD $parameterN -p $1
				python ~/rebalance-lnd/rebalance.py --lnddir ~/umbrel/lnd/ --fee-factor $parameterF -$parameterD $parameterN -p $2
				python ~/rebalance-lnd/rebalance.py --lnddir ~/umbrel/lnd/ --fee-factor $parameterF -$parameterD $parameterN -p $3
				python ~/rebalance-lnd/rebalance.py --lnddir ~/umbrel/lnd/ --fee-factor $parameterF -$parameterD $parameterN -p $4
				python ~/rebalance-lnd/rebalance.py --lnddir ~/umbrel/lnd/ --fee-factor $parameterF -$parameterD $parameterN

				if [ -z "$parameterO" ] 
				then
				        echo "We are done for now with Channel 5 concluding, Pleb";
				else 
				        echo "Starting the rebalancing with Ratio $1 on Channel 6"
					python ~/rebalance-lnd/rebalance.py --lnddir ~/umbrel/lnd/ --fee-factor $parameterF -$parameterD $parameterO -p $1
					python ~/rebalance-lnd/rebalance.py --lnddir ~/umbrel/lnd/ --fee-factor $parameterF -$parameterD $parameterO -p $2
					python ~/rebalance-lnd/rebalance.py --lnddir ~/umbrel/lnd/ --fee-factor $parameterF -$parameterD $parameterO -p $3
					python ~/rebalance-lnd/rebalance.py --lnddir ~/umbrel/lnd/ --fee-factor $parameterF -$parameterD $parameterO -p $4
					python ~/rebalance-lnd/rebalance.py --lnddir ~/umbrel/lnd/ --fee-factor $parameterF -$parameterD $parameterO

					if [ -z "$parameterP" ] 
					then
					        echo "We are done for now with Channel 6 concluding, Pleb";
					else 
					        echo "Starting the rebalancing with Ratio $1 on Channel 7"
						python ~/rebalance-lnd/rebalance.py --lnddir ~/umbrel/lnd/ --fee-factor $parameterF -$parameterD $parameterP -p $1
						python ~/rebalance-lnd/rebalance.py --lnddir ~/umbrel/lnd/ --fee-factor $parameterF -$parameterD $parameterP -p $2
						python ~/rebalance-lnd/rebalance.py --lnddir ~/umbrel/lnd/ --fee-factor $parameterF -$parameterD $parameterP -p $3
						python ~/rebalance-lnd/rebalance.py --lnddir ~/umbrel/lnd/ --fee-factor $parameterF -$parameterD $parameterP -p $4
						python ~/rebalance-lnd/rebalance.py --lnddir ~/umbrel/lnd/ --fee-factor $parameterF -$parameterD $parameterP

					fi
				fi
			fi
		fi
	fi
fi
echo "ALL DONE - move on Pleb!"
}

rebalance_something 10 30 50 70
