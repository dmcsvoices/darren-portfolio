//pragma solidity 0.7.5;
//pragma solidity 0.8.0;
pragma solidity >=0.4.22 <0.9.0;

//import "./Ownable.sol";

contract Wallet {
    address[] public owner;
    mapping(address => uint) balance;
    mapping(address => bool) ownerMap;
    uint approvalThreshold;
    
 
    transactionRequest[] transactionQ;
    
    struct transactionRequest {
        address from;
        address to;
        uint amount;
        uint numApprovals;
        bool    approved;
        uint txId;
    }


    
    
    constructor(address[] memory _owners, uint _approvalsrequired){
        //set owner addresses, and required number of approvals.
        owner = _owners;
        balance[owner[0]] = 0;
        balance[owner[1]] = 0;
        balance[owner[2]] = 0;
        ownerMap[owner[0]] = true;
        ownerMap[owner[1]] = true;
        ownerMap[owner[2]] = true;
        approvalThreshold = _approvalsrequired;
        
    }
    
    
    function addUser(address _newUserAddress) public {
        
        //this function is used by the contract owner to add addresses (ie other owners) to the "ownsers" mapping
        balance[_newUserAddress] = 0;
        ownerMap[_newUserAddress] = true;
        
    }
    
    
    function requestTx(address recipient, uint amount) public {
        //this function is used by any owner to create a transaction request and add it to the Transaction Queue
        
        
        /* 
        the function will take the following arguments: to address, amount.Each request will have their approved flag set to false.
        
        the function will create a new request object and push it onto the reqest queue. 
    
        */
        
        transactionRequest memory newTx = transactionRequest(msg.sender, recipient, amount, 0, false, transactionQ.length);
        transactionQ.push(newTx);
        
    }


    function getTransaction(uint _index) public view returns(uint, address, address, uint, uint, bool) {
        return (transactionQ[_index].txId, transactionQ[_index].from, transactionQ[_index].to, transactionQ[_index].amount, transactionQ[_index].numApprovals, transactionQ[_index].approved);
    }

/*
    function listTxQ() public view {
        
        //this function is used by any anyone to show the transaction q 
        //return txID, amount, numberofapprovals, approved
        for (uint i=0; i<transactionQ.length; i++) {
            getTransaction(i);
        }
        
        
    }
*/
    function approveTransaction(uint txId) public returns(bool) {
        //this function is used by ownsers to approve a specific transaction in the Transaction Queue
        require(ownerMap[msg.sender] == true);
        /*  
        this function will accept the following arguments: txId
        when this is invoked, the function will check whether the caller is in the owners mapping, it will check the account balance, 
        and if there's enough balance, and it will increment the approvalCount for the transaction.
        If the appvovalCount is greater than or equal to the approvalThreshold, then the transfer function will be invoked
        */
        
        
        transactionQ[txId].numApprovals += 1;
        if (transactionQ[txId].numApprovals >= approvalThreshold) {
            //here we execute the trasfer function
            transactionQ[txId].approved = true;
            transfer(txId);
        }
 
    }

   function transfer(uint txId) public {
        //need error handling checks
        
        address _from = transactionQ[txId].from;
        address _to = transactionQ[txId].to;
        uint _amount = transactionQ[txId].amount;
        
        require(balance[_from] >= _amount);
        require(_from != _to);
        
        uint previousSenderBalance = balance[_from];

        _transfer(_from,_to,_amount);
        
        
        //GoverenmentInstance.addTransaction{value: 1 ether}(msg.sender,recipient,amount);
        //emit tranferAdded(amount, recipient);
        
        assert(balance[_from] == previousSenderBalance - _amount);
        
        //event logs and further checks
        
    
    }
    
    function _transfer(address from, address to, uint amount) private {
        balance[from] -= amount;
        balance[to] += amount;
    }
   

    function deposit() public payable returns (uint){
        
        balance[msg.sender] += msg.value;
        //emit depositDone(msg.value, msg.sender);
        return balance[msg.sender];
    }
    
    
    function getBalance() public view returns(uint) {
        return balance[msg.sender];
    }
}

