//SPDX-License-Identifier:GPL-3.0
pragma solidity >=0.5.0<0.9.0;

//This contract allows the users to send ethers and one among them is declared as winner and get the total amount of LuckyDraw.

contract LuckyDraw{
    address  payable[] public  participants;
    address public manager;      
    address payable public  winner;

    //In the constructor, the deployer of the contract is declared as the manager.

    constructor(){
         manager = msg.sender;
    }
    
    // This function is made to receive ethers from users and ether value must be 2.

    function receiveEther() external payable {
        require(msg.value==2 ether,"Less than minimum Ethers");
        participants.push(payable(msg.sender));
    }

   //This function gives the balance ethers of the contarct account.

    function getBalance() public view returns(uint){
        require(msg.sender==manager,"No Access");
        return address(this).balance;
    }

    //This function gives us the random value. Keccak256 is a cryptographic function built into solidity. This function takes in any amount of inputs and converts it to a unique 32 byte hash.

    function random() public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.prevrandao,block.timestamp,participants.length)));
    }

    //This function selects the winner among the participants. To declare winner, the minimum number of participants must be 3. Once the winner is selected, the balance amount of the contract is transffered to the winner. 

    function selectWinner() public  {
        require(msg.sender==manager,"No access");
        require(participants.length>=3);
        uint r = random();
        uint index = r % participants.length;
        winner = participants[index];
        winner.transfer(getBalance());
        participants = new address payable[](0);  
    }       

    //This function gives the address of the winner.

    function getWinner() public view returns(address){ 
        return winner;
    }      
}