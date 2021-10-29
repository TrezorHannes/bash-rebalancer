# bash-rebalancer
With bash-rebalancer as a wrapper, you can use Carsten Otto's rebalance-lnd with > more than one channel in a batch system.

The prerequisits are
  - Installed Python Environment
  - Rebalance-lnd https://github.com/C-Otto/rebalance-lnd
  - LNDManage https://github.com/bitromortac/lndmanage

It'll allow you to
  - Add **more than one channel** to rebalance
  - Incrementally start the ratio to rebalance with **10%, 30%, 50%, 70%** and remainder ratio to rebalance*
  - For < 2M sats channels, the script will strive to achieve a 50:50 ratio. For > 2M Channel size, it'll aim to get 1M at either side

#### Installation
```
$ git clone https://github.com/TrezorHannes/bash-rebalancer
$ nano bash-rebalancer/my_rebalancer.sh
```
1) Adjust LND directory in line 19
2) Alternate the path to your rebalance-lnd directory if it's not in ~/rebalance-lnd/ in line 25


##### Syntax for one channel
`$ ./bash-rebalancer/my_rebalancer.sh -j cidxxxxxxxxxxxxxxx`

This command will try one _specific channel_ (j). 

##### Syntax for more than one channel
`$ ./bash-rebalancer/my_rebalancer.sh -j cidxxxxxxxxxxxxxxx -k cidxxxxxxxxxxxxxxx -l cidxxxxxxxxxxxxxxx -m cidxxxxxxxxxxxxxxx -n cidxxxxxxxxxxxxxxx -o cidxxxxxxxxxxxxxxx`

This command will try to rebalance _for 6 different channels_ (j-o).

#### Attributes
```
  - Fee-Setting
  - Direction push (👉) outbound or pull (👈) inbound liquidity
  - -j Single channel ID of first and required channel
  - -k to -p arguments allow for passing additional optional channels to rebalance
 ```

#### Hints
1. Since the process is going to take a long time, pending the number of channels you like to rebalance, it's generally advised to **run the bash script via TMUX**.
2. Get a list of target rebalancing channels with `$ lndmanage listchannels rebalance` before-hand, and identify the top 1-7 with too much outbound or too much inbound by hand
3. Focus on the **channels with reasonable fee-settings**. When you use charge-lnd, you may have channels with extra-ordinary high or low pricing to dis- or encourage balancing. Fee-Factor for those channels can have undersirable side-effects (too high or too low ppm).
