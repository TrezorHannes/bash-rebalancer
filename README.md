# bash-rebalancer
Adding my amateur bash script to get familiar with github, storing the changes and developing bash scripting further

With bash-rebalancer as a wrapper, you can use Carsten Otto's rebalance-lnd with > more than one channel in a batch system.
The prerequisits are
  - Installed Python Environment
  - Rebalance-lnd https://github.com/C-Otto/rebalance-lnd
  - LNDManage https://github.com/bitromortac/lndmanage

It'll allow you to
  - Add **more than one channel** to rebalance
  - Incrementally start the ratio to rebalance with **10%, 30%, 50%, 70%** and remainder ratio to rebalance*
  - For < 2M sats channels, the script will strive to achieve a 50:50 ratio. For > 2M Channel size, it'll aim to get 1M at either side

Syntax for one channel
sh .local/bin/bash-rebalancer/my_rebalancer.sh -f 0.7 -d t -j 777743784397454

Syntax for more than one channel
sh .local/bin/bash-rebalancer/my_rebalancer.sh -f 0.7 -d t -j 777743784397454 -k 777743784397454 -l 777743784397454 -m 777743784397454 -n 777743784397454 -o 777743784397454

Attributes
  -f For Fee-Factor
  -d For Direction push (-f) outbound or pull (-t) inbound liquidity
  -j Single channel ID of first and required channel"
  -k to -p arguments allow for passing additional optional channels to rebalance"
  
Hints
Since the process is going to take a long time, pending the number of channels you like to rebalance, it's generally advised to run the bash script via TMUX.
