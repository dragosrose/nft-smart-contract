# Metapocalypse Contract

Handles the minting of NFTs during Presales/Sales.

## VSCode

### Dependencies:
```shell
npm install --save-dev hardhat
npx hardhat
npm install --save-dev @nomiclabs/hardhat-waffle ethereum-waffle chai @nomiclabs/hardhat-ethers ethers
npm install @openzeppelin/contracts
npm i -D @nomiclabs/hardhat-etherscan
```

### Commands:

```shell
npx hardhat run scripts/deploy.js --network rinkeby #Deploys contract on rinkeby network.
npx hardhat verify YOUR_CONTRACT_ADDRESS --network rinkeby "CONSTRUCTOR ARG1" "CONSTRUCTOR ARG2" .. #Verfies the contract on the deployed address.
```

### General Hardhat Commands

```shell
npx hardhat accounts
npx hardhat compile
npx hardhat clean
npx hardhat test
npx hardhat node
node scripts/sample-script.js
npx hardhat help
```

## Contract Interaction

Copy the source code into Remix, compile it, then either deploy the contract through Remix, where you can interact with it within a local environment (Javascript VM London/Berlin), or load the already deployed contract.

### Noteworthy Functions:

```solidity
function whitelistUsers(address[] calldata _users) public onlyOwner
// Adds the list with the users that are going to be whitelisted. When calling the function add the addresses the following way: ["address1", "address2", .. ]

function reveal(address[] calldata _users) public onlyOwner
// Reveals the baseURI

function setNftPerAddressLimit(uint256 _limit) public onlyOwner
// Sets the maximum number of NFTs that can be minted (during the presales period)

function pause(bool _state) public onlyOwner
// When set to true nobody can mint, including the owner of the contract.

function setOnlyWhitelisted(bool _state) public onlyOwner
// When set to false, users outside the whitelist can mint.
```
