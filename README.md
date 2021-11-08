# bash-rebalancer
With bash-rebalancer as a wrapper, you can use Carsten Otto's rebalance-lnd with > more than one channel in a batch system.
It'll allow to add a bunch of channels when calling the script, and then a menu will guide you through the next steps.

The prerequisits are
  - Installed Python Environment
  - Rebalance-lnd https://github.com/C-Otto/rebalance-lnd
  
Optional but helpful to retrieve the right channels to rebalance
  - LNDManage https://github.com/bitromortac/lndmanage 
  `lndmanage listchannels rebalance`

### Key Feature Set
  - Add **more than one channel** to rebalance
  - Incrementally start the ratio to rebalance with **10%, 30%, 50%, 70%** and remainder ratio to rebalance
  - For < 2M sats channels, the script will strive to achieve a 50:50 ratio. For > 2M Channel size, it'll aim to get 1M at either side
  - Alternatively, it allows to set a fixed amount of satoshis, and tries that _amount_ divided into 5 attempts for every selected channel

### Installation
```
$ git clone https://github.com/TrezorHannes/bash-rebalancer
$ nano bash-rebalancer/my_rebalancer.sh
```
1) In case not successfully identifying your LND directory, add a direct link in the header
2) If your rebalance-lnd directory isn't stored in $HOME (~/rebalance-lnd/), add a direct link in the header, too

#### Syntax for one channel
`$ ./bash-rebalancer/my_rebalancer.sh -j cidxxxxxxxxxxxxxxx`

This command will try one _specific channel_ (j). 

#### Syntax for more than one channel
`$ ./bash-rebalancer/my_rebalancer.sh -j cidxxxxxxxxxxxxxxx -k cidxxxxxxxxxxxxxxx -l cidxxxxxxxxxxxxxxx -m cidxxxxxxxxxxxxxxx -n cidxxxxxxxxxxxxxxx -o cidxxxxxxxxxxxxxxx`

This command will try to rebalance _for 6 different channels_ (j-o).

### Attributes
```
  - Fee-Setting
  - Direction push (👉) outbound or pull (👈) inbound liquidity
  - -j Single channel ID of first and required channel
  - -k to -p arguments allow for passing additional optional channels to rebalance
  - Specify Automated or Defined Amount to be rebalanced
 ```

### Hints
1. Since the process is going to take a long time, pending the number of channels you like to rebalance, it's generally advised to **run the bash script via TMUX**.
2. Get a list of target rebalancing channels with `$ lndmanage listchannels rebalance` before-hand, and identify the top 1-7 with too much outbound or too much inbound by hand
3. Focus on the **channels with reasonable fee-settings**. When you use charge-lnd, you may have channels with extra-ordinary high or low pricing to dis- or encourage balancing. Fee-Factor for those channels can have undersirable side-effects (too high or too low ppm).

### Contribution
Please feel free to help this getting better, issues and pull requests @ https://github.com/TrezorHannes/bash-rebalancer
I'm always grateful for inbound, feel free to connect or message me for a joined channel opening:

#### HODLmeTight: 
  - 037f66e84e38fc2787d578599dfe1fcb7b71f9de4fb1e453c5ab85c05f5ce8c2e3@z5keqdwlv7mr5bjudwczzfok775d4xfxlxh3bbp7ug5nyjrjkxup3cyd.onion:9735
  - https://amboss.space/node/037f66e84e38fc2787d578599dfe1fcb7b71f9de4fb1e453c5ab85c05f5ce8c2e3
