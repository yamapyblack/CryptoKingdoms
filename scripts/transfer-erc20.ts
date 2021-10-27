import { ethers } from 'hardhat'
import { ERC20 } from "typechain/ERC20"

const main = async () => {
    const contract = (await ethers.getContractAt("ERC20", "0x2370f9d504c7a6e775bf6e14b3f12846b594cd53")) as ERC20
    const tx = await contract.transfer('0xCDF4f278c469Fd3961707D6b4D54B8f244eA5d9E', ethers.utils.parseEther("182472"))
    console.log(tx);
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });
