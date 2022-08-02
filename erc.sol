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
     /**
     * Internal transfer, only can be called by this contract
     */
    function _transfer(address _from, address _to, uint _value) internal {
        // Prevent transfer to 0x0 address. Use burn() instead
        require(_to != address(0x0));
        // Check if the sender has enough
        require(balanceOf[_from] >= _value);
        // Check for overflows
        require(balanceOf[_to] + _value > balanceOf[_to]);
        // Save this for an assertion in the future
        uint previousBalances = balanceOf[_from] + balanceOf[_to];
        // Subtract from the sender
        balanceOf[_from] -= _value;
        // Add the same to the recipient
        balanceOf[_to] += _value;
        emit Transfer(_from, _to, _value);
        // Asserts are used to use static analysis to find bugs in your code. They should never fail
        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
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

    function transferFrom(address from,address recipient,uint amount) external returns(bool){
      
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
      _transfer(owner,msg.sender,1);
      payable(owner).transfer(msg.value);

      
    
}
}
