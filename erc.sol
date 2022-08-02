// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.13;


contract Token  {


    address public owner;
    uint public totalSupply;
    mapping(address => uint) public balanceOf;
    mapping(address => mapping(address => uint)) public allowance;
    string public name = "IEC-Token";
    string public symbol = "IT";
    uint public InitialPrice = 1 ether;
    event Transfer(address from , address to , uint value);
    event Approve(address owner,address spender,uint value);
  
    constructor () {
      owner = msg.sender;
    }
    modifier onlyme() {
        require(owner==msg.sender, "Unauthorized User");
        _;
    }
    
    function transfer(address recipient, uint amount) external onlyme returns(bool){
      
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;

        emit Transfer(msg.sender,recipient,amount);
        return true;   
    }
  
    address public spender;
    function approve(address _spender, uint amount) public onlyme returns (bool){
      
      spender=_spender;
      allowance[msg.sender][_spender] = amount;
    
      emit Approve(msg.sender, _spender , amount);
      return true;
    }

    function transferFrom(address from,address recipient,uint amount) internal returns(bool){
      
      require(msg.sender==spender,"only spender allowed");
      allowance[owner][from] = amount;
      balanceOf[from] -= amount;
      balanceOf[recipient] += amount;

      emit Transfer(from, recipient, amount);
      return true;
    }
    
    function mint(uint amount)  onlyme external {
      
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
    }
 
    function burn(uint amount) onlyme external {
      
        balanceOf[msg.sender] -= amount; 
        totalSupply -= amount;

    }
    function setPrices(uint256 newPrice) onlyme  public  {
      
         InitialPrice=newPrice;
      
    }
      function buy() public  payable {
      require (msg.sender != owner, "owner not allowed");
      require(msg.value == InitialPrice, "Please send more ether");
      transferFrom(owner,msg.sender,1);
      payable(owner).transfer(msg.value); 
}
}
