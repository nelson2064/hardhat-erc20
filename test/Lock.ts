

//Testing 
// how can we test smart contracts ?
// 1.  first solutiong you might have upload a contract to the test net and try to call the function on the test net contract but obiously takes lot time and enven  testing small thing is quite complicated this way 
// 2. so how can we more efficiently  and especially becuase contract might have a lot different edge cases which takes a lot of time to test our  solution for this is autmated testing  which basically testing our contract by writing code you probably endup writing more code for test rather then the contract itself
// 3. >> aumated testing > instead of deploying contract calling function and verifying the contract manually you end up writing code that automaticallyl deploys the contract calls the funcitons adn verifies the results are as expected this is extremely powerful you do it either by testing very small unit of contract called uint testing or by testing all in one called integration testing  one of the best thing of automated testing is we have to write them only ones  and everytime you chang the code you can run the test again to double check that you changes didn't break any exesting behaviour  in an unexpected way 
// so how can we do for the smart contract ?
// > well again we need a blockchain that runs locally on our computer luckily the etherum tool devloper system take all the hard work from you so this all happens without having any setup we can just write test in javascript using a framework like mocha 
// >  test in mocha follow simple structure

// describe for context
// beforeEach for setup
// it for assertion 

// >lets have a look how you wil use this 




import { SignerWithAddress} from "@nomiclabs/hardhat-ethers/signers"
import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";
import {ERC20 } from "../typechain-types"



describe("MYERC20Contract" , function () { //high level describe we put our contract name                                      

let myERC20Contract: ERC20
let someAddress: SignerWithAddress
let someOtherAddress: SignerWithAddress

  beforeEach(async function () {  //lets first implement the before each  which will deploy the erc20 contract             
const ERC20ContractFactory = await ethers.getContractFactory("ERC20"); // we have to deploy erc20 contract first create a factory pass the name of the contract that is erc20
  myERC20Contract = await ERC20ContractFactory.deploy("Hello", "SYM"); //next we can deploy the contract // type in the parameter to the constructor name and symbol
await myERC20Contract.deployed() //this ensure we actually waiting for the contract to be fully deployed to the blockchain


someAddress = (await ethers.getSigners())[1];
someOtherAddress = (await ethers.getSigners())[2];  

}) 


  describe("when I have 10 tokens", function() {
    beforeEach(async function () { 
        await  myERC20Contract.transfer(someAddress.address , 10);
    })


describe("When i transfer 10 tokens", function(){
  it("should transfer tokens correctly" , async function (){
    await myERC20Contract.connect(someAddress).transfer(someOtherAddress.address, 10)
  
    expect(await myERC20Contract.balanceOf(someOtherAddress.address)).to.equal(10);
  
  })
})

  })



}) 

