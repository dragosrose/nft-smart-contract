const main = async () => {
  const nftContractFactory = await hre.ethers.getContractFactory('Metapocalypse');
  const nftContract = await nftContractFactory.deploy("Metapocalypse", "META", "ipfs://Qmav2iKsvmxdknagbK94oUh1PQV3BSAdpuPerj2JyLNMdS/", "ipfs://QmfF7F45YVe2B5mKN7CZFJKUDrxfWnZzxMQCXDTcW2wTeQ/");
  await nftContract.deployed();
  console.log("Contract deployed to:", nftContract.address);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();
