import "@nomiclabs/hardhat-waffle"
import { ethers } from 'hardhat'
import { expect, use } from 'chai'
import { BigNumberish, BytesLike, PayableOverrides, utils, ContractTransaction } from "ethers"
const { reverts } = require('truffle-assertions')
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/dist/src/signer-with-address"

let owner: SignerWithAddress
let addr1: SignerWithAddress
let addr2: SignerWithAddress

//test contracts and parameters
import { TCGLoot } from "typechain/TCGLoot"

describe("testing for TCGLoot", async () => {
    let contract: TCGLoot

    beforeEach(async () => {
        const signers = await ethers.getSigners()
        owner = signers[0]
        addr1 = signers[1]
        addr2 = signers[2]

        const TCGLoot = await ethers.getContractFactory("TCGLoot");
        contract = (await TCGLoot.deploy()) as TCGLoot
        await contract.deployed()
    })

    describe("tokenURI", async () => {

        it("success", async () => {
            const tokenId = 11
            await contract.claim(tokenId)
            const m = await contract.tokenURI(tokenId)
            console.log(m)

            const m2 = m.split(",")[1]
            const m3 = utils.toUtf8String(utils.base64.decode(m2))

            const m4 = m3.split(",")[3].split('"')[0]
            const m5 = utils.toUtf8String(utils.base64.decode(m4))
            console.log(m5)
        });

        it("success", async () => {

            for(let i = 1;i < 200; i++){
                const m1 = await contract.getRarity(i, "SPECIES1")
                if(m1 == 'Legend'){console.log(i)}
                const m2 = await contract.getRarity(i, "SPECIES2")
                if(m2 == 'Legend'){console.log(i)}
                const m3 = await contract.getRarity(i, "SPECIES3")
                if(m3 == 'Legend'){console.log(i)}
                const m4 = await contract.getRarity(i, "SPECIES4")
                if(m4 == 'Legend'){console.log(i)}
                const m5 = await contract.getRarity(i, "SPECIES5")
                if(m5 == 'Legend'){console.log(i)}

                // console.log(i,m1,m2,m3,m4,m5)
            }
            
            
        });

        
    });

});
