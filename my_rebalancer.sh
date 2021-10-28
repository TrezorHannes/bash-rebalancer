#!/bin/bash
# A sample Bash script, by Hakuna
#ToDo: 
# Add selection process: https://ryanstutorials.net/bash-scripting-tutorial/bash-loops.php#select
# to allow for selecting the fee-settings: fee-factor, fee-limit or fee-ppm-limit

activate () {
  . ../.venv/bin/activate
}

# Set LN-Path for Rebalance-LND
if [ "`uname -a | grep umbrel`" != "" ]
then 
        # LNPATH setting on umbrel
        LNPATH="~/umbrel/lnd/"
else
        #Other installations
# Set your own Path to LND in case the below does not work for you
        LNPATH="~/.lnd/"
fi

helpFunction()
{
   echo "FUCK - something went wrong"
   echo "Usage: $0 -f parameterF -d parameterD -j parameterJ"
   echo -e "\t-f For Fee-Factor parameterF"
   echo -e "\t-d For Direction push (f) or pull (t) liquidity parameterD"
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

rebalance_something () {

#       python ~/rebalance-lnd/rebalance.py --lnddir $LNPATH --fee-factor $parameterF -$parameterD $1 -p $2
#       python ~/rebalance-lnd/rebalance.py --lnddir $LNPATH --fee-factor $parameterF -$parameterD $1 -p $3
#       python ~/rebalance-lnd/rebalance.py --lnddir $LNPATH --fee-factor $parameterF -$parameterD $1 -p $4
#       python ~/rebalance-lnd/rebalance.py --lnddir $LNPATH --fee-factor $parameterF -$parameterD $1 -p $5
#       python ~/rebalance-lnd/rebalance.py --lnddir $LNPATH --fee-factor $parameterF -$parameterD $1
echo "python ~/rebalance-lnd/rebalance.py --lnddir $LNPATH --$feeoption $parameterF -$parameterD $1 -p $2"
}

# Parse parameters from the command initiation
echo "Fee Attribute > $parameterF"
echo "Direction Push (f) or Pull (t) > $parameterD"
echo "Channel ID 1 > $parameterJ"
echo "Channel ID 2 > $parameterK"
echo "Channel ID 3 > $parameterL"
echo "Channel ID 4 > $parameterM"
echo "Channel ID 5 > $parameterN"
echo "Channel ID 6 > $parameterO"
echo "Channel ID 7 > $parameterP"

# Fee-Selection Process
   echo -e "\tfee-factor: set b/w 0.1 and 1.0. Compare the costs against the expected income, scaled by this factor. fee-factor 1.5, routes that cost at most 150% of the expected earnings"
   echo -e "\tfee-limit: enter total amount of Satoshis willing to spend per rebalance.  If set, only consider rebalance transactions that cost up to the given number of satoshis."
   echo -e "\tfee-ppm-limit: If set, only consider rebalance transactions that cost up to the given number of satoshis per 1M satoshis sent."

feeoptions='fee-factor fee-limit fee-ppm-limit Quit'

PS3='Select Fee Option: '

select feeoption in $feeoptions
do
        if [ $feeoption == 'Quit' ]
        then
                break
        fi
        echo "We'll go for --$feeoption"

#Channel 1
echo "Starting the rebalancing on Channel 1"
rebalance_something $parameterJ 10 30 50 70

if [ -z "$parameterK" ] 
then
        echo "We are done for now with Channel 1 concluding, Pleb";
        break
else
        echo "Starting the rebalancing on Channel 2"
        rebalance_something $parameterK 10 30 50 70

        if [ -z "$parameterL" ]
        then
                echo "We are done for now with Channel 2 concluding, Pleb";
                break
        else 
                echo "Starting the rebalancing on Channel 3"
                rebalance_something $parameterL 10 30 50 70

                if [ -z "$parameterM" ] 
                then
                        echo "We are done for now with Channel 3 concluding, Pleb";
                        break
                else 
                        echo "Starting the rebalancing on Channel 4"
                        rebalance_something $parameterM 10 30 50 70

                        if [ -z "$parameterN" ] 
                        then
                                echo "We are done for now with Channel 4 concluding, Pleb";
                                break
                        else 
                                echo "Starting the rebalancing on Channel 5"
                                rebalance_something $parameterN 10 30 50 70

                                if [ -z "$parameterO" ] 
                                then
                                        echo "We are done for now with Channel 5 concluding, Pleb";
                                        break
                                else 
                                        echo "Starting the rebalancing on Channel 6"
                                        rebalance_something $parameterO 10 30 50 70

                                        if [ -z "$parameterP" ] 
                                        then
                                                echo "We are done for now with Channel 6 concluding, Pleb";
                                                break
                                        else 
                                                echo "Starting the rebalancing on Channel 7"
                                                rebalance_something $parameterP 10 30 50 70

                                        fi
                                fi
                        fi
                fi
        fi
fi
done
echo "ALL DONE - move on Pleb!"
