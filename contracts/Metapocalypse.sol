// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Metapocalypse is ERC721Enumerable, Ownable {
  using Strings for uint256;

  string public baseURI;
  string public hiddenURI;
  string public baseExtension = ".json";
  uint256 public cost = 0.01 ether;
  uint256 public maxSupply = 100;
  uint256 public maxMintAmount = 20;
  uint256 public nftsPerAddressLimit = 10;
  bool public paused = false;
  bool public revealed = false;
  bool public onlyWhitelisted = true;
  address[] public whitelistedAddresses;
  mapping(address => uint256) public addressMintedBalance;

  constructor(
    string memory _name,
    string memory _symbol,
    string memory _initBaseURI,
    string memory _initHiddenUri
  ) ERC721(_name, _symbol) {
    setBaseURI(_initBaseURI);
    setHiddenURI(_initHiddenUri);
    //mint(msg.sender, 20);
  }

  // internal
  function _baseURI() internal view virtual override returns (string memory) {
    return baseURI;
  }

  // public
  function mint(address _to, uint256 _mintAmount) public payable {
    uint256 supply = totalSupply();
    require(!paused, "The sale has ended");
    require(_mintAmount > 0, "The minimum amount to mint is 1.");
    require(_mintAmount <= maxMintAmount, "You exceeded the maximum amount of tokens to mint at once.");
    require(supply + _mintAmount <= maxSupply, "The maximum supply of tokens has been overreached.");

    if (msg.sender != owner()) {
        if(onlyWhitelisted == true){
          require(isWhitelisted(msg.sender), "User is not whitelisted.");
          uint256 ownerMintedCount = addressMintedBalance[msg.sender];
            require(ownerMintedCount + _mintAmount <= nftsPerAddressLimit, "max NFT per address exceeded");
        }

        require(msg.value >= cost * _mintAmount,"The amount sent is too low.");
    }

    for (uint256 i = 1; i <= _mintAmount; i++) {
      addressMintedBalance[msg.sender]++;
      _safeMint(_to, supply + i);
    }
  }

  function isWhitelisted(address _user) public view returns (bool) {
    for (uint i = 0; i < whitelistedAddresses.length; i++) {
      if (whitelistedAddresses[i] == _user) {
          return true;
      }
    }
    return false;
  }

  function walletOfOwner(address _owner)
    public
    view
    returns (uint256[] memory)
  {
    uint256 ownerTokenCount = balanceOf(_owner);
    uint256[] memory tokenIds = new uint256[](ownerTokenCount);
    for (uint256 i; i < ownerTokenCount; i++) {
      tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
    }
    return tokenIds;
  }

  function tokenURI(uint256 tokenId)
    public
    view
    virtual
    override
    returns (string memory)
  {
    require(
      _exists(tokenId),
      "ERC721Metadata: URI query for nonexistent token"
    );

    if(revealed == false) {
        return hiddenURI;
    }

    string memory currentBaseURI = _baseURI();
    return bytes(currentBaseURI).length > 0
        ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
        : "";
  }

  //only owner
  function setCost(uint256 _newCost) public onlyOwner() {
    cost = _newCost;
  }
  
  function setBaseURI(string memory _newBaseURI) public onlyOwner {
    baseURI = _newBaseURI;
  }

  function setHiddenURI(string memory _newHiddenURI) public onlyOwner {
    hiddenURI = _newHiddenURI;
  }

  function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
    baseExtension = _newBaseExtension;
  }

  function setOnlyWhitelisted(bool _state) public onlyOwner {
    onlyWhitelisted = _state;
  }

  function pause(bool _state) public onlyOwner {
    paused = _state;
  }
 
 function whitelistUsers(address[] calldata _users) public onlyOwner {
    delete whitelistedAddresses;
    whitelistedAddresses = _users;
  }
  
  function reveal() public onlyOwner {
      revealed = true;
  }
  
  function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
    nftsPerAddressLimit = _limit;
  }

  function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
    maxMintAmount = _newmaxMintAmount;
  }
  

  function withdraw() public payable onlyOwner {
    require(payable(msg.sender).send(address(this).balance));
  }
}
