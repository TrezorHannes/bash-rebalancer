#!/bin/bash
# A sample Bash script, by Hakuna and Ziggie
#ToDo:
# 1) In case the below LND directory doesn't work for you, add a direct link in line 18
# 2) Secondly, alternate the path to your rebalance-lnd directory if it's not in ~/rebalance-lnd/ in line 13 (umbrel) or line 19 (!umbrel)

set -uo pipefail


#Default Values
LNPATH="$HOME/working_freetime/rebalance-lnd/rebalance.py"
REBLANCELNDPATH="$HOME/working_freetime/rebalance-lnd/rebalance.py"
VIRTUALENVPATH="$HOME/.pyenv/versions/reblance-lnd/bin/activate"
PULL=0
PUSH=0
MINAMOUNT=10000 #Sats
directionabrv=''
amountoption='Automated'
amountvalue=50000 # Sats
feevaluelimit=80 #PPM
interactive=0 #not interacive
feeoption='fee-ppm-limit'

# Set LN-Path & Rebalance-LND
if [ "`uname -a | grep umbrel`" != "" ]
then
        # LNPATH setting on umbrel
        LNPATH="~/umbrel/lnd/"
        REBLANCELNDPATH="/home/umbrel/rebalance-lnd/rebalance.py"
        source ~/venv/bin/activate
fi






usage()
{
  echo "LFG PLEB: Ziggie Hakuna Balancer Script
                               [ -h | --help                     Display this help]
                               [ -c | --channelid                Paste ChannelIDs separated by /]
                               [ -l | --lnddir                   Paste lnd directory default = $LNPATH]
                               [ -i | --interactive              Interactive means userinput needed]
                               [ -v | --virtualenvpath           Paste virtualenvpath defalut = $VIRTUALENVPATH]
                               [ -d | --direction                'f' for 👉Push Outbound Liquidity away FROM a channel,
                                                                 't' 👈 Pull  Outbound Liquidity TO  a channel]
                               [-a | --amount                    amount to reblance (will be diveded into smaller peaces to send)
                                                                 if not set standard reblance to 50:50 or at least 1 mio on each side is tried]
                               [-f  | --fee-ppm-limit            Max Fee in PPM  ]"





  exit 1
}



if [[ ${#} -eq 0 ]]; then
   usage
fi



# Transform long options to short ones
for arg in "$@"; do
  shift
  case "$arg" in
    "--channelid") set -- "$@" "-c" ;;
    "--lnddir") set -- "$@" "-l" ;;
    "--interactive") set -- "$@" "-i" ;;
    "--virtualenvpath") set -- "$@" "-v" ;;
    "--direction") set -- "$@" "-d" ;;
    "--amount") set -- "$@" "-a" ;;
    "--fee-ppm-limit") set -- "$@" "-f" ;;
    "--help") set -- "$@" "-h" ;;
    *)        set -- "$@" "$arg"
  esac
done

# list of arguments expected in the input
optstring=":hl:c:iv:d:a:f:"

while getopts ${optstring} arg; do
  case ${arg} in
    h)
      echo "=========showing usage!=========="
      usage
      ;;

    c)

      CHANNELIDS=($(echo $OPTARG | tr "/" "\n"))
      ;;
    l)
        LNPATH=$OPTARG
        ;;
    i)
        interactive=1
        ;;
    v)
        VIRTUALENVPATH=$OPTARG
            ;;
    d)
        directionabrv=$OPTARG
        if [ $directionabrv != 'f' ] && [ $directionabrv != 't' ]
        then
            echo "Specifiy correct direction either 't' or 'f'"
            usage
            exit 1
        fi
            ;;
    a)
        amountoption="Defined"
        amountvalue=$OPTARG
            ;;
    f)
        feevaluelimit=$OPTARG

            ;;
    :)
      echo "$0: Must supply an argument to -$OPTARG." >&2
      exit 1
      ;;
    ?)
      echo "Invalid option: -${OPTARG}."
      exit 1
      ;;
  esac
done



interactive_function()

{

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

# Amount-Definition Process
   echo -e ""
   echo -e "[AMOUNT-SELECTION PROCESS]==========================================================================================================="
   echo -e "Now lastly, let's determine the girth: Do you want the Script to take over how much to rebalance, or want to specify the size?"
   echo -e ""
   echo -e "\tAutomated: The script will aim for 5 steps to get your channel to 50:50 balance, or 1M on either side for channels bigger > 2M satoshis"
   echo -e "\tDefined: You aim to rebalance a defined amount satoshis. It'll be divided into 5 chunks, since smaller sizes usually rebalance easier "
   echo -e ""
   echo -e "Please note: In case you called > more than one channel to rebalance, the second option "Defined" will be tried for ALL channels given"
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
  else
  amountvalue=50000
#  break
fi

# Parse parameters from the command initiation
echo -e ""
echo -e "[SUMMARY]==========================================================================================================================="
echo -e "Fee Attribute > \t\t $feeoption"
echo -e "Fee Value > \t\t\t $feevalue"
echo -e "Direction 👉Push or 👈Pull > \t $direction"
echo -e "Amount-Definition > \t\t $amountoption $amountvalue"



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
        for i in "${CHANNELIDS[@]}"
        do
          channel=$i
          reblance_python_lnd $channel $amountoption $amountvalue $feevalue $feeoption
        done
        echo "ALL DONE ⚡ - move on Pleb!"
        fi
break
done





}



#Parameter $1 = Amount to Reblance
reblance_python_lnd()
{

  fee_cycle=2
  channel=$1
  amountoption=$2
  amountvalue=$3
  feevaluelimit=$4
  feeoption=$5
  amount_size=50000


  #Split in 50000 sats packages

  if [ $amountoption == 'Defined' ]
    then
      let reblance_cycle=$amountvalue/$amount_size

  else
     reblance_cycle=5

  fi



  trial_counter=1





  while [ $trial_counter -le $reblance_cycle ]
  do
    echo "Number of Trials: $trial_counter with the following feevalue $feevaluelimit ppm"


    if [ $amountoption == 'Defined' ]
      then
        #let a=($amountvalue/$reblance_cycle)*$trial_counter

        if [ $amountvalue -lt  $MINAMOUNT ]
        then
           amountvalue=$MINAMOUNT
        fi
        #set -x;
        python $REBLANCELNDPATH  --$feeoption $feevaluelimit -$directionabrv $channel -a $amount_size

    else

        #let percentage=$trial_counter*10
        percentage=20
        #set -x;
        python $REBLANCELNDPATH  --$feeoption $feevaluelimit -$directionabrv $channel -p $percentage
        #set +x;

        #python $REBLANCELNDPATH  --$feeoption $actual_fee -$directionabrv $channel -p $percentage 2>&1| tee fail.txt
        # if grep -q "not find" "fail.txt"; then
        #     echo "Aborted because first try did not find suitable route for percentage $percentage with $feeoption: $actual_fee"
        #     echo ''
        #     break
        # fi

    fi

    ((trial_counter++))



  done




}



#Activate Virtualenv

source $VIRTUALENVPATH
#Check whether Channels were passed

if [ ${#CHANNELIDS[@]} -eq 0 ]
then
   echo "Provide ChannelIDS"
   usage
   exit 1
fi

if [[ -z $directionabrv ]]
then
   echo "Provide Direction"
   usage
   exit 1
fi


if [ $interactive -eq 0 ]
  then
    for i in "${CHANNELIDS[@]}"
    do
      channel=$i
      reblance_python_lnd $channel $amountoption $amountvalue $feevaluelimit $feeoption
    done
else
  #echo "Test"
  interactive_function

fi
