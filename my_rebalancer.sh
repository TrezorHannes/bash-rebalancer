#!/bin/bash
# A sample Bash script, by Hakuna
#ToDo: 
# 1) In case the below LND directory doesn't work for you, add a direct link in line 18
# 2) Secondly, alternate the path to your rebalance-lnd directory if it's not in ~/rebalance-lnd/ in line 13 (umbrel) or line 19 (!umbrel)


# Set LN-Path & Rebalance-LND
if [ "`uname -a | grep umbrel`" != "" ]
then
        # LNPATH setting on umbrel
        LNPATH="~/umbrel/lnd/"
        RLND="/home/umbrel/rebalance-lnd/rebalance.py"
        umbrel=1
else
        #Other installations
# Set your own Path to LND in case the below does not work for you
        LNPATH="~/.lnd/"
        #Adjust this directory in case you installed Rebalance-LND somewhere different
        RLND="/home/admin/apps/rebalance-lnd/rebalance.py"
        umbrel=0
fi

activate () {
if [ $umbrel=1 ]
then
        source ~/venv/bin/activate
else
        . ../.venv/bin/activate
fi
}
activate

helpFunction()
{
   echo "FUCK $1 - something went wrong"
   echo "Usage: $0 -j <CHAN-ID1> -k <CHAN-ID2> -l <CHAN-ID3> ..."
   echo -e "\t-j Single channel ID of first and required channel"
   echo -e "\t-k-p arguments allow for passing additional optional channels to rebalance"
   exit 1 # Exit script after printing help
}

while getopts "j:k:l:m:n:o:p:" opt
do
   case "$opt" in
      j ) parameterJ="$OPTARG" ;;
      k ) parameterK="$OPTARG" ;;
      l ) parameterL="$OPTARG" ;;
      m ) parameterM="$OPTARG" ;;
      n ) parameterN="$OPTARG" ;;
      o ) parameterO="$OPTARG" ;;
      p ) parameterP="$OPTARG" ;;
      ? ) helpFunction Oben ;; # Print helpFunction in case essential parameter is non-existent
   esac
done

# Print helpFunction in case parameters are empty
if [ -z "$parameterJ" ]
then
   echo "Required parameters are empty";
   helpFunction
fi

rebalance_something ()
{

if [ $direction == '👉Push' ]
  then
  direction='f'
  else
  direction='t'
fi
        python $RLND --lnddir $LNPATH --$feeoption $feevalue -$direction $1 -p $2
        python $RLND --lnddir $LNPATH --$feeoption $feevalue -$direction $1 -p $3
        python $RLND --lnddir $LNPATH --$feeoption $feevalue -$direction $1 -p $4
        python $RLND --lnddir $LNPATH --$feeoption $feevalue -$direction $1 -p $5
        python $RLND --lnddir $LNPATH --$feeoption $feevalue -$direction $1
}

rebalance_start()
{
#Channel 1
echo "Starting the rebalancing on Channel 1"
rebalance_something $parameterJ 10 30 50 70

if [ -z "$parameterK" ]
then
        echo "We are done for now with Channel 1 concluding, Pleb";
else
        echo "Starting the rebalancing on Channel 2"
        rebalance_something $parameterK 10 30 50 70

        if [ -z "$parameterL" ]
        then
                echo "We are done for now with Channel 2 concluding, Pleb";
        else
                echo "Starting the rebalancing on Channel 3"
                rebalance_something $parameterL 10 30 50 70

                if [ -z "$parameterM" ]
                then
                        echo "We are done for now with Channel 3 concluding, Pleb";
                else
                        echo "Starting the rebalancing on Channel 4"
                        rebalance_something $parameterM 10 30 50 70

                        if [ -z "$parameterN" ]
                        then
                                echo "We are done for now with Channel 4 concluding, Pleb";
                        else
                                echo "Starting the rebalancing on Channel 5"
                                rebalance_something $parameterN 10 30 50 70

                                if [ -z "$parameterO" ]
                                then
                                        echo "We are done for now with Channel 5 concluding, Pleb";
                                else
                                        echo "Starting the rebalancing on Channel 6"
                                        rebalance_something $parameterO 10 30 50 70

                                        if [ -z "$parameterP" ]
                                        then
                                                echo "We are done for now with Channel 6 concluding, Pleb";
                                        else
                                                echo "Starting the rebalancing on Channel 7"
                                                rebalance_something $parameterP 10 30 50 70

                                        fi
                                fi
                        fi
                fi
        fi
fi
}

# Direction-Selection Process
   echo -e "[DIRECTION-SELECTION PROCESS]======================================================================================================="
   echo -e "You have successfully added one or more channels to be rebalanced. Now define where the liquidity should move to."
   echo -e ""
   echo -e "\t - 👉 Pushing liquidity indicates low inbound, high amount of local outbound sats"
   echo -e "\t - 👈 Pulling liquidity indicates high inbound, low amount of local outbound sats"
   echo -e ""

directions='👉Push 👈Pull'
PS3='Select Direction: '

select direction in $directions
do
        echo "We'll go for $direction liquidity"
break
done

# Fee-Selection Process
   echo -e "[FEE-SELECTION PROCESS]============================================================================================================="
   echo -e "Rebalance-LND offers 3 ways to set the price-ceiling for your rebalance. Chose one of three different options below."
   echo -e ""
   echo -e "\tfee-factor: set b/w 0.1 and 1.0. Compare the costs against the expected income, scaled by this factor. fee-factor 1.5, routes that cost at most 150% of the expected earnings"
   echo -e "\tfee-limit: enter total amount of Satoshis willing to spend per rebalance.  If set, only consider rebalance transactions that cost up to the given number of satoshis."
   echo -e "\tfee-ppm-limit: If set, only consider rebalance transactions that cost up to the given number of satoshis per 1M satoshis sent."
   echo -e ""

feeoptions='fee-factor fee-limit fee-ppm-limit'
PS3='Select Fee Option: '

select feeoption in $feeoptions
do
        echo "We'll go for $feeoption"
break
done

# Fee-Value Process
   echo -e "[FEE-VALUE]========================================================================================================================="
   echo -e "Economically viable pricing your rebalance-action is important! Indicate the price-ranges you want to allow as ceiling for your rebalance across all channels indicated. This is not error prone, read carefully"
   echo -e ""
   echo -e "\t - fee-factor:decimal set. Examples: 0.1 indicates rebalance for max 10% costs. 0.5 = 50%, 1.5 = 150%. Start low eg 0.5"
   echo -e "\t - fee-limit: total amount of satoshis per rebalance, eg. 30"
   echo -e "\t - fee-ppm-limit: fee-rate per million satoshis. Set to 200 will pay a max of 200 satoshis for every million satoshis rebalanced"
   echo -e ""

if [ $feeoption == 'fee-factor' ]
then
echo "Enter your fee-factor setting as decimal (recommended between 0.1 and 1.5)"
read feevalue
else
        if [ $feeoption == 'fee-limit' ]
        then
        echo "Enter your fee-limit setting as total number of sats per rebalance (eg 50)"
        read feevalue
        else
                if [ $feeoption == 'fee-ppm-limit' ]
                then
                echo "Enter your fee-ppm-limit (eg 200 for 200ppm)"
                read feevalue
                fi
        fi
fi
echo "We'll go for $feevalue"

# Parse parameters from the command initiation
echo -e ""
echo -e "[SUMMARY]==========================================================================================================================="
echo -e "Fee Attribute > \t\t $feeoption"
echo -e "Fee Value > \t\t\t $feevalue"
echo -e "Direction 👉Push or 👈Pull > \t $direction"
echo -e ""
echo -e "Channel ID 1 > \t\t\t $parameterJ"
echo -e "Channel ID 2 > \t\t\t $parameterK"
echo -e "Channel ID 3 > \t\t\t $parameterL"
echo -e "Channel ID 4 > \t\t\t $parameterM"
echo -e "Channel ID 5 > \t\t\t $parameterN"
echo -e "Channel ID 6 > \t\t\t $parameterO"
echo -e "Channel ID 7 > \t\t\t $parameterP"
echo -e "===================================================================================================================================="
echo -e ""

kickoffs='✅Yes ⛔Cancel'

PS3='Should we go ahead? '

select kickoff in $kickoffs
do
        if [ $kickoff == '⛔Cancel' ]
        then
                echo "kthxbuy - exiting"
                break
                exit 1
        else
        echo ""
        echo "All right let's f'ing go 🚀"
        echo ""
        rebalance_start
        echo "ALL DONE ⚡ - move on Pleb!"
        fi
break
done
