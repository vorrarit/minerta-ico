docker run --rm -it --name geth-minerta -v ${PWD}:/root -p 8545:8545 -p 30303:30303 ethereum/client-go --nodiscover --maxpeers 1 --networkid 13 --rpc --rpccorsdomain "https://wallet.ethereum.org/"

geth account new

geth --datadir=datadir --mine --minerthreads=1 --etherbase=0x70e79531823cd040d844daf2ea0fc881fa921a47 --networkid 13






docker run --rm -it --name geth-minerta -v ${PWD}:/root -p 8545:8545 -p 30303:30303 ethereum/client-go account new

4cfd2c13d845d598e950d341ef5866bfbb72e26f

docker run --rm -it --name geth-minerta -v ${PWD}:/root -p 8545:8545 -p 30303:30303 ethereum/client-go init /root/genesis.json

root@minerta-s-1vcpu-1gb-sgp1-01:/mnt/volume-sgp1-02/geth-minerta# docker run -d --name geth-minerta -v ${PWD}:/root -p 8545:8545 -p 30303:30303 ethereum/client-go --nodiscover --maxpeers 5 --networkid 13 --rpc --rpcaddr 0.0.0.0 --rpccorsdomain "https://wallet.ethereum.org/"

$ eth.accounts

$ eth.getBalance(eth.accounts[0])

$ web3.fromWei(eth.getBalance(eth.accounts[0]), "ether")

geth --datadir=datadir init genesis.json
geth --datadir=datadir --mine --minerthreads=1 --etherbase=0x18dcf7Cd9cA07a9E39c41A275E35E94902758c9b --networkid 13