import { ethers } from 'hardhat'
import { TCGLoot } from "typechain/TCGLoot"

const main = async () => {
    const TCGLootContract = await ethers.getContractFactory("TCGLoot");

    const contract = (await TCGLootContract.deploy()) as TCGLoot
    await contract.deployed();

    console.log('deployed txHash:', contract.deployTransaction.hash);
    console.log('deployed address:', contract.address);
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });
