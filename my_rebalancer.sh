#!/bin/bash
# A Rebalancing Bash script, by Hakuna
#ToDo: ii) Abort when failed route and move to next iii) Advanced / Expert mode for quick calls
#DONE: i) Add fee-ppm-limit && fee-factor combination iv) Add Reckless Option vi) added cycle-division setting v) Add -exclude Option

#**********[HEADER / SETTINGS SECTION]***************************************************************************************************
reblance_cycle=10 # Standard setting for how often your defined amount gets divided to allow for smaller rebalances = higher probability to succeed. Can be overwritten here, or via -c in the command call

# 1) Validate LND directory in line 14 or 18
# 2) Secondly, alternate the path to your rebalance-lnd directory if it's not in ~/rebalance-lnd/ in line 15 (umbrel) or line 19 (!umbrel)

if [ "`uname -a | grep umbrel`" != "" ]
then
        LNPATH="~/umbrel/lnd/" # LNPATH setting on umbrel
        RLND="/home/umbrel/rebalance-lnd/rebalance.py" # Rebalance-lnd setting on umbrel
        umbrel=1
else
        LNPATH="~/.lnd/" # LNPATH setting for other installations
        RLND="/home/admin/rebalance-lnd/rebalance.py" # Rebalance-lnd setting for other installations
        umbrel=0
fi

activate()
{
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
   echo -e "\t-c argument to alter the number of parts your original defined amount should get divided by. eg -c 15 divides your amount by 15 to allow for smaller rebalances"
   echo -e "\t-e allows for adding a single channel-ID which should be excluded in the rebalance attempt"
   exit 1 # Exit script after printing help
}

while getopts "j:k:l:m:n:o:p:c:e:" opt
do
   case "$opt" in
      j ) parameterJ="$OPTARG" ;;
      k ) parameterK="$OPTARG" ;;
      l ) parameterL="$OPTARG" ;;
      m ) parameterM="$OPTARG" ;;
      n ) parameterN="$OPTARG" ;;
      o ) parameterO="$OPTARG" ;;
      p ) parameterP="$OPTARG" ;;
      c ) reblance_cycle="$OPTARG" ;;
      e ) exclude_dat="$OPTARG" ;;
      ? ) helpFunction Oben ;; # Print helpFunction in case essential parameter is non-existent
   esac
done

if [ -z "$parameterJ" ]
then
   echo "Required parameters are empty";
   helpFunction
fi

if [ -n "$exclude_dat" ]
        then
	exclusion="--exclude $exclude_dat"
   echo "We'll exclude Channel-ID $exclude_dat"
fi

rebalance_something()
{
	if [ $amountoption == 'Defined' ]
  	then
	trial_counter=1
        let a=$(( $amountvalue / $reblance_cycle ))
	rebalance_dat="python $RLND --lnddir $LNPATH --$feeoption $feevalue -$directionabrv $1 -a $a $reckless $exclusion"
		while [ $trial_counter -le $reblance_cycle ]
  		do
			if [ -z "$feemax" ]
			then
		$rebalance_dat
			else
		$rebalance_dat --fee-ppm-limit $feemax
			fi
		((trial_counter++))
		done
  	else
	rebalance_dat="python $RLND --lnddir $LNPATH --$feeoption $feevalue -$directionabrv $1 $exclusion"
			if [ -z "$feemax" ]
			then
		$rebalance_dat -p $2
		$rebalance_dat -p $3
		$rebalance_dat -p $4
		$rebalance_dat -p $5
		$rebalance_dat
			else
		$rebalance_dat -p $2 --fee-ppm-limit $feemax
		$rebalance_dat -p $3 --fee-ppm-limit $feemax
		$rebalance_dat -p $4 --fee-ppm-limit $feemax
		$rebalance_dat -p $5 --fee-ppm-limit $feemax
		$rebalance_dat --fee-ppm-limit $feemax
			fi
	fi
}

rebalance_start()
{
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
   echo -e ""
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
	if [ $direction == '👉Push' ]
  	then
  	directionabrv='f'
  	else
  	directionabrv='t'
	fi
break
done

# Fee-Selection Process
   echo -e ""
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
   echo -e ""
   echo -e "[FEE-VALUE]========================================================================================================================="
   echo -e "Economically viable pricing your rebalance-action is important!"
   echo -e "Indicate the price-ranges you want to allow as ceiling for your rebalance across all channels indicated. This is not error prone, read carefully"
   echo -e ""
   echo -e "\t - fee-factor: decimal set. Examples: 0.1 indicates rebalance for max 10% costs. 0.5 = 50%, 1.5 = 150%. Start low eg 0.5"
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

# Offer fee-ppm-limit as Ceiling Option
if [ $feeoption == 'fee-factor' ]
then
   echo -e ""
   echo -e "[FEE-FACTOR]========================================================================================================================="
   echo -e "Under some circumstances, Fee-Factor may compute a too high profit, eg if you use extreme high fees to stop routing"
   echo -e "To prevent routing from those channels with extremely high fees, you can add an additional PPM-limit as ceiling here."
   echo -e "This will allow the rebalance to only consider profitable routes with fee-factor, but install a max-limit in combination"
   echo -e ""
   echo -e "\t - fee-ppm-limit: enter fee-rate per million satoshis. Set to 200 will set max 200 satoshis for every million satoshis rebalanced"
   echo -e "\t - Set to 3000 or something if you don't care"
   echo -e ""


echo "Enter your fee-ppm-limit (eg 200 for 200ppm)"
read feemax
fi
echo "We'll add a ceiling of $feemax PPM"

# Amount-Definition Process
   echo -e ""
   echo -e "[AMOUNT-SELECTION PROCESS]==========================================================================================================="
   echo -e "Now lastly, let's determine the girth: Do you want the Script to take over how much to rebalance, or want to specify the size?"
   echo -e ""
   echo -e "\tAutomated: The script will aim for 5 steps to get your channel to 50:50 balance, or 1M on either side for channels bigger > 2M satoshis"
   echo -e "\tDefined: You aim to rebalance a defined amount satoshis. It'll be divided into 5 chunks, since smaller sizes usually rebalance easier "
   echo -e ""
   echo -e "Please note: In case you called > more than one channel to rebalance, the second option >Defined< will be tried for ALL channels given"
   echo -e ""

amountoptions='Automated Defined'
PS3='Select Amount Option: '

select amountoption in $amountoptions
do
        echo "We'll go for $amountoption"
break
done

if [ $amountoption == 'Defined' ]
  then
  echo "How much do you want to $direction? Enter the absolute amount in Satoshis, eg 1000000"
  read amountvalue
  echo -e ""

# Offer Reckless Mode but only when Amount is Defined
	if [ -z "$feemax" ]
        	then
		echo "Do you want to be >>>reckless<<< and consider economical unprofitable routes for your rebalancing?"
		echo ""
		reckless_options='✅Yes ⛔No'

		PS3='Chose wisely:'

		select reckless_option in $reckless_options
		do
	        	if [ $reckless_option == '⛔No' ]
		        then
	        	        echo "kthx we play it safe"
				reckless=""
	                break
#                exit 1
	        	else
		        echo ""
		        echo "All right let's play it hardball - careful, this can get expensive 🥊"
		        echo ""
		        reckless="--reckless"
			break
			fi
		done
	else
	reckless=""
	fi
else
  amountvalue=""
fi

# Parse parameters from the command initiation
echo -e ""
echo -e "[SUMMARY]==========================================================================================================================="
if [ -z "$feemax" ]
	then
echo -e "Fee Attribute > \t\t $feeoption"
	else
echo -e "Fee Attribute > \t\t $feeoption + fee-ppm-limit Combo"
fi
if [ -z "$feemax" ]
        then
echo -e "Fee Value > \t\t\t $feevalue"
	else
echo -e "Fee Values > \t\t\t $feevalue + $feemax PPM limit"
fi
echo -e "Direction 👉Push or 👈Pull > \t $direction"
echo -e "Amount-Definition > \t\t $amountoption $amountvalue"
if [ -n "$reckless" ]
        then
echo -e "Reckless Option > \t\t ENABLED"
fi
if [ -n "$exclude_dat" ]
        then
        exclusion="--exclude $exclude_dat"
echo -e "We'll exclude Channel-ID \t $exclude_dat"
fi
echo -e ""
echo -e "Channel ID 1 > \t\t\t $parameterJ"
if [ -n "$parameterK" ]
	then
echo -e "Channel ID 2 > \t\t\t $parameterK"
fi
if [ -n "$parameterL" ]
        then
echo -e "Channel ID 3 > \t\t\t $parameterL"
fi
if [ -n "$parameterM" ]
        then
echo -e "Channel ID 4 > \t\t\t $parameterM"
fi
if [ -n "$parameterN" ]
        then
echo -e "Channel ID 5 > \t\t\t $parameterN"
fi
if [ -n "$parameterO" ]
        then
echo -e "Channel ID 6 > \t\t\t $parameterO"
fi
if [ -n "$parameterP" ]
        then
echo -e "Channel ID 7 > \t\t\t $parameterP"
fi
echo -e "===================================================================================================================================="
echo -e ""

kickoffs='✅Yes ⛔Cancel'

PS3='Should we go ahead? '

select kickoff in $kickoffs
do
        if [ $kickoff == '⛔Cancel' ]
        then
                echo "kthxbye - exiting"
                break
                exit 1
        else
        echo ""
        echo "All right let's f'ing go 🚀"
        echo ""
        rebalance_start
        echo "ALL DONE ⚡ - WAGMI!"
        fi
break
done
