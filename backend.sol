// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/*
    ListOfFunds
    CroudFunding
   
*/

contract ListOfFunds{
   
    uint public NoOfFundingSession;
    mapping(uint=>CroudFunding) public AllFundRaisinSession;
   
    function createFundingSession(
            address manager,
            uint minimumContribution,
            uint deadline,
            uint target,
            uint raisedAmount,
            string calldata _description,
            address payable _recipient
        ) public {
       
    //   console.log(AllFundRaisinSession[NoOfFundingSession]);
       
        // require( AllFundRaisinSession[NoOfFundingSession].s,"This Funding session ID already Exists!!!" );
       
        AllFundRaisinSession[NoOfFundingSession] = CrowdFunding(
            deadline,
            target,
            "ABC",
            _recipient
        );
       
        NoOfFundingSession += 1;
       
    }
   
    function voteRequest(
        uint _requestNo
    ) public {
       
        AllFundRaisinSession[_requestNo].setVoter(msg.sender,0);
   
    }
   
}


contract CrowdFunding {
   
    mapping(address=>uint) public contributors;
    address public manager;
    uint public minimumContribution;
    uint public deadline;
    uint public target;
    uint public raisedAmount;
    uint public NoOfContributors;
    uint public numRequests;
    mapping(address=>uint) voters;
    uint noOfVoters;
   
    constructor(
            uint _deadline,
            uint _target,
            string memory _description,
            address payable _recipient
    ){
       
        target=_target;
        deadline=_deadline+block.timestamp;
        minimumContribution = 100 wei;
        manager = msg.sender;
    }
   
    function setVoter(address sender,uint z) public {
        voters[sender]=z;
        noOfVoters+=1;
    }
   
    function SendingEtherium() public payable {
        require(msg.value>=minimumContribution,"Your sender should have minimum amount of 100");
        require(block.timestamp<deadline,"Deadline has passed");
       
        if ( contributors[msg.sender]==0 ){
            NoOfContributors+=1;
        }
        contributors[msg.sender] = contributors[msg.sender]+msg.value;
        raisedAmount += msg.value;
    }
   
    function getContractBalance() public view returns(uint){
        return address(this).balance;
    }
   
    function refund() public payable {
        require(block.timestamp>deadline && raisedAmount<target,"You are not eligible for this refund!");
        require(contributors[msg.sender]>0);
        address payable user = payable(msg.sender);
        user.transfer(msg.value);
        contributors[msg.sender]=0;
    }
   
    modifier onlyManager(){
        require(msg.sender==manager,"Only manager can call this function");
        _;
    }
   
    function makePayment(uint _requestNo) public onlyManager{
        require(raisedAmount>=target);
        // Request storage thisRequest = requests[_requestNo];
        // require(thisRequest.completed==false,"The request has been completed");
        // require(thisRequest.noOfVoters > NoOfContributors/2,"Majority does not support");
        // thisRequest.recipient.transfer(thisRequest.value);
    }
}





