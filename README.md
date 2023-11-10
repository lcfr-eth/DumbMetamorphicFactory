## "Lazy" Metamorphic Deployment Demo

Want to deploy a contract that can be upgradable, without using a proxy or clone?

Want to hardcode all your state variables and save gas avoiding sload() in calls while also allowing for upgrading/changing contract code?

Metamorphic contracts might be right for you.

## Explanation: 

To understand how to morph contracts you need to understand these three EVM instructions:

```create``` : computes the address using the sender's address and a nonce, which is incremented with each transaction. 
```create2``` : the address is computed using four parameters: a 0xFF constant, the sender's address, a salt (which is a random value from the sender), and the bytecode of the contract.
```selfdestruct``` : removes code at address and resets the nonce to 0 (also sends the balance to a specified address).

Deploy a Factory contract via create2 using a salt "xxxx".

Deploy a contract from the deployed Factory contract using create() via the deploy() method. 
This will use the Factory contracts nonce for the future contracts address. Setting the contracts nonce to 1.

Destruct the Deployed contract. - Removes code at the address sets nonce to 0.
Destruct the Factory contract. - Removes code and resets the nonce to 0.

Redeploy the Factory contract using the same salt. 
Now the Factories nonce is 0 and deploying a new contract using create will result in the same address being used as the previous address before selfdestruct(). 

### Counter.sol
Modified to accept a constructor argument for demo purposes

### Factory.sol
The Factory contract which is deployed via create2() using a salt.
This contract has a deploy() method that allows for deploying contracts by supplying bytecode.

### DeployFactory.s.sol
create2 deployment script for the Factory contract.

### GetContractCode.s.sol
Returns the contracts creation code + encoded constructor arguments

### demo.s.sol
Demo script that puts it all together. 

```
DumbMetamorphicFactory$ export SALT=fuck
DumbMetamorphicFactory$ forge script script/demo.s.sol 
...
== Logs ==
  created Factory: 0x4C754bEc5EEcda1C13083732DDefc0D4f80ed77c
  salt: fuck
  Counter(1337) Address: 0x31591CCb029aa4875D6A7f6e6896521a23A29CD6

  Redeployed Factory: 0x4C754bEc5EEcda1C13083732DDefc0D4f80ed77c
  salt: fuck
  Counter(1234) Address: 0x31591CCb029aa4875D6A7f6e6896521a23A29CD6
```