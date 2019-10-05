pragma solidity 0.5.8;
pragma experimental ABIEncoderV2;

library SafeMath {
  /**
  * @dev Multiplies two numbers, reverts on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    // Gas optimization: this ix`s cheaper than requiring 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }
  /**
  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a / b;
    return c;
  }
  /**
  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }
 
  /**
  * @dev Adds two numbers, reverts on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
  /**
  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
  * reverts when dividing by zero.
  */
  function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
    uint256 c = add(a,m);
    uint256 d = sub(c,1);
    return mul(div(d,m),m);
  }
}

contract Factory{
    mapping(address=>Research) research_mapping;
    mapping(address=>Buyer) buyer_mapping;
    
    function newResearch (string memory name,string memory research_name,string memory field) public payable returns(Research){
        Research new_research= new Research(name,research_name,field,msg.sender);
        research_mapping[msg.sender]=new_research;
        return new_research; 
    }
    
}
contract Research {
    using SafeMath for uint256;
    struct data{
        address payable patient_address_;
        string patient_data_;
    }
    address[] _buyerAddress;
    data[] _patientData;
    string _name;
    string _researcherName;
    string _field;
    uint _totalFunds;
    address payable _owner;
    int _totalPatients;
    uint _costPerData;
    modifier onlyOwner {
        require(msg.sender == _owner);
        _;
    }
    
    constructor(string memory name,string memory researcherName,string memory field,address payable owner_address) public payable{
        _name=name;
        _researcherName=researcherName;
        _field=field;
        _owner=owner_address;
        _totalPatients=0;
    }
    
    function getCostPerData()public returns(uint){
        return _costPerData;
    }
    function enterData(address payable patient_address,string memory patient_data)public returns(bool){
        data memory newData=data({
            patient_address_:patient_address,
            patient_data_:patient_data
        });
        _patientData.push(newData);
        _totalPatients++;
    }
    
    function getResearchInfo() public view onlyOwner returns(string memory,string memory,string memory,uint,int){
        return( 
            _name,
            _researcherName,
            _field,
            _totalFunds,
            _totalPatients);
    }
    function getPatientInfo(uint index) public view onlyOwner returns(data memory){
        return(_patientData[index]);
    }
    function getFund() public view onlyOwner returns(uint){
        return address(this).balance;
    }
    
    function getAddress()public returns(address){
        // return this.address;
    }
    
    function splitIncome() public payable returns(address){
        uint _sendFund=_totalFunds/(_patientData.length*2);
        // address(this).transfer(_owner,)
        for (uint i=0; i<_patientData.length; i++) {
            address(_patientData[i].patient_address_).transfer(_sendFund);
        }
        address(_owner).transfer(address(this).balance);
    }
    
    function getCompleteData()public returns(data[] memory){
        return _patientData;
    }
}

contract Buyer{
    using SafeMath for uint256;
    using SafeMath for int256;
    address payable _owner;
    string _name;
    function getData(address research) private returns(Research.data[] memory){
        Research.data[] memory totaldata=Research(research).getCompleteData();
        uint total_cost=Research(research).getCostPerData()*totaldata.length;
        address(_owner).transfer
        return (totaldata);
        
    }
}

contract User{
    
}