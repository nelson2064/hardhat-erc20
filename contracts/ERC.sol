

// pragma solidity  ^0.8.11; 

// contract ZTMToken {


//     uint256 public totalSupply;
//     string public name;
//     string public symbol;
// // uint8 public decimals;
    
//     mapping (address => uint256) public balanceOf;

//     constructor(string memory _name, string memory _symbol) {
//         name = _name;
//         symbol = _symbol;

//     }

//     function decimals() external pure returns (uint8){
//     return 18;
//     }


//     function transfer(address recipient , uint256 amount) external returns (bool){
//    require(recipient != address(0), "ERC20: transfer to the zero address");
// uint256 senderBalacne = balanceOf[msg.sender]; //person calling transfer msg.sender
//  require(senderBalacne >= amount, "Not enough tokens");

//   balanceOf[msg.sender] = senderBalacne - amount;
//         balanceOf[recipient] += amount;
    
//         return true;

//     }
  

// //finally we have all  the tools to eplement  our first erc 20 token
// //so lets starts emplementing transfer function which allow anyone to transfer our token to someone else etherum address
// //before transfer anything we need a way to to store the balances for address
// //first lets create a new  mapping  this mapping is for address to uint256


// }





// pragma solidity  ^0.8.11; 

// contract ZTMToken {


//     uint256 public totalSupply;
//     string public name;
//     string public symbol;

//        //before we can transfer anything we need a way to store the balances for an address
//     mapping (address => uint256) public balanceOf;


//     constructor(string memory _name, string memory _symbol) {
//         name = _name;
//         symbol = _symbol;

//     }
    

//     function decimals() external pure returns (uint8){
//     return 18;
//     }



// // 1. transfer 

// //allows any one to transfer our token to anyone someoe else etherum address
//    //before we can transfer anything we need a way to store the balances for an address
    
//     function transfer(address recipient , uint256 amount) external returns (bool){    //it is external because offcourse we want people from outside to able to  call  this function
    
//     require(recipient != address(0), "ERC20: transfer to the zero address");//make sure we are not sending to 0 address additonal safety feature so people don't accidentaly send token to an addres they may have forgot to enter and  deafult the 0 addres it means sender has lost money so we don't want that //reverting the transaction if the addres is 0 and giving message  //make sure not sending to 0 address  //so if it is true keeps going normally but if it is not true it means if 0 it reverts the transaction and pop up the message
    
//     uint256 senderBalance = balanceOf[msg.sender]; // now we can check the sender balance  // getting the sender balance through the mapping the key is addres so msg.sender would give addres and on that key we will get the balance so we ge the balance
    
//     require(senderBalance >= amount, "Not enough tokens"); //checking if the the balance >= amount then let it be keep going if not revert the transaction and though the message error 

// //now changing things on the state
// //now we will do 

//     balanceOf[msg.sender] = senderBalance - amount; //remove the transfer amount from the sender
    
//     balanceOf[recipient] += amount;   //and add the amount to the recipient
    
//         return true;         //return true at the end becuase everyting was sucessfull and thats what the the erc20 standard requried

//     }

//     //how cool is that with few lines of code we created a contract which allows one to transfer tokens to a new address anyone who owns the token and now able to call the transfer function with a recipient addres and the amount to transfer fundamentally erc20 token are not much more then that but if you remmeber erc20 requried one additonal features and that is transfer token on the behalf of someone else
  



// // 2. transferring tokens on behalf of someone else

// //now to transfer token on behalf of someone else we need tranfrom and approve functions

// // Transferring tokens on behalf of someone else means that a third party (such as a smart contract or a dApp) is authorized to initiate a transfer of tokens from one address to another on behalf of the owner of those tokens.

// // For example, let's say Alice wants to send 100 tokens to Bob, but she is busy and wants her friend Charlie to do it on her behalf. Alice can grant authorization to Charlie to transfer tokens from her account to Bob's account. Charlie would then initiate the transfer using Alice's account details, but the actual transaction would be executed by the smart contract.

// // To allow such transfers on behalf of someone else, the owner of the tokens needs to grant approval to the third party using the approve() function. This allows the third party to transfer a specified amount of tokens from the owner's account to another account using the transferFrom() function.



// }




//transfer token on behalf of someone else we need transferfrom and approve function so if you remmeber approve function you can set allowance  token for someone else to transfer some one else in you really really trust typically  in this case smart contract

// SPDX-License-Identifier: MIT


pragma solidity  ^0.8.11; 

contract ERC20 {


    uint256 public totalSupply;
    string public name;
    string public symbol;


event Transfer(address indexed from , address indexed to , uint256 value);
event Approval(address indexed owner , address indexed spender , uint256 value);  


   
   
    mapping (address => uint256) public balanceOf;


//to implement transferfrom we acutally need a second mapping this is the allowance mapping which maps from the owner address to the spender address to the allowance value this will autmatically create view function we don't need to make a view function public will make it view 
mapping(address => mapping (address => uint256))public allowance; //which map from owner address to the spender address to the allowance value 
//we need this mapping to store which owner address have approved how many funds for which spender address 

    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol =  _symbol;
        
//internal function so we have to use on the contract so we just now do so we mint some token to the person who is deploying the contract
        _mint(msg.sender, 100e18);       //if you remmber contract have 18 decimal so 100e18 is acutally this number //100 , 000 , 000 , 000 , 000 , 000 , 000       // so if we pass this number this would be just 100 token minted to the deployer //i know when i will deploy the contract here the person have 100 token automatically 

    }
    

    function decimals() external pure returns (uint8){
    return 18;
    }




    function transfer(address recipient , uint256 amount) external returns (bool){    
    return _transfer(msg.sender , recipient , amount);        
    }


    function transferFrom( address sender  ,address recipient , uint256 amount) external returns (bool){    
    //before the transfer we have to make sure function call acutally allowed to make  transfer while  we don't want anyone to just else transfer someone token  
    uint256 currentAllowance = allowance[sender][msg.sender];//sender is sender but the spender is msg.sender from allowance mapping to get the amount of value that is approve by the owner to the spender to get the amount okay
    //revering  if the current allowance amount is <= amount if >= amount keep going
    require(currentAllowance >= amount , "ERC20: transfer amount exceeds allowance");
    //if the amount doesn't exceed from the actual approved amount then we updated the allowance mapping
    allowance[sender][msg.sender] =  currentAllowance - amount;      //so we update the allowance amount from the amount that is transfered 
    
emit Approval(sender , msg.sender , allowance[sender][msg.sender]);

    return _transfer(sender , recipient , amount);        
    }


//last thing missing is offcourse owner allow someone addres to spend the token on their behalf and that is appove function that in last we are implementing
    function approve(address spender , uint256 amount) external returns(bool){
    require(spender != address(0), "ERC20: approve to the zero address");
    allowance[msg.sender][spender] = amount;
    
    emit Approval(msg.sender , spender , amount);

    return true;
    }


// >> and that erc20 token was all function eplemented we have a contract now that implements all that required erc 20 function people can transfer the token     approve the tokens to other address and other address can tranfer approved tokens


    function _transfer(address sender , address recipient , uint256 amount) private returns (bool){    //private function is only able to access from this contract not from inherit or other external contract   
    require(recipient != address(0), "ERC20: transfer to the zero address");
    uint256 senderBalance = balanceOf[sender]; 
    require(senderBalance >= amount, "Not enough tokens"); 
    balanceOf[sender] = senderBalance - amount; 
    balanceOf[recipient] += amount;   
       
       emit Transfer(sender , recipient , amount);
       
        return true;     

    }


// >>>>>>> how we done almost one small aspect is still missing to call it a full erc20 token  functionally the contract is already finished you could deploy this to etherum main net and would  have a functioning erc20 token  contract but what still missing here is event 

function _mint(address to , uint256 amount) internal {         // the function mint tokens to an address and the amount
require(to != address(0), "ERC20: mint to the zero address"); 
totalSupply += amount;      //increase the total supply
balanceOf[to] += amount;     // change the balance on the balance of mapping //so off course this is an internal function we are not able to access outside and we have to use on the contract
       emit Transfer(address(0) , to , amount);
}





}

























