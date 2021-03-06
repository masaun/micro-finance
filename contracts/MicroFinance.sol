pragma solidity 0.4.24;

import "chainlink/node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "chainlink/node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";

import "./storage/MfStorage.sol";
import "./modifiers/MfOwnable.sol";


contract MicroFinance is Ownable, MfStorage, MfOwnable {

    using SafeMath for uint256;

    /*+ 
     * @dev Global variable
     */ 
    uint256 _dealId;

    // Repay rate is 8% which is flat rate.
    uint256 repayRate = 8;
    uint256 borrowRate = 100;
    uint256 _repayRate = borrowRate.add(repayRate);  // assume 1.08%


    constructor() public {}

    /*
    * @dev Create deal of micro finance
    */
    function createDeal(
        address _farmerAddr, 
        string _title, 
        string _description, 
        uint256 _desiredBorrowAmount
    ) 
        public 
        returns (uint256, address, string, string, uint256, uint256) 
    {
        _dealId++;  // Counting deal ids are started from 1

        // Calculate repay amount
        uint256 _repayAmount;
        uint256 _borrowAmount;
        _repayAmount = _desiredBorrowAmount + _desiredBorrowAmount.mul(_repayRate);
        _borrowAmount = _desiredBorrowAmount.mul(100);
        
        Deal memory deal = Deal({
            dealId: _dealId,
            farmerAddr: _farmerAddr,
            title: _title,
            description: _description,
            desiredBorrowAmount: _borrowAmount,
            repayAmount: _repayAmount,
            repayFinish: false
        });
        deals.push(deal);

        emit CreateDeal(deal.dealId, 
                        deal.farmerAddr, 
                        deal.title, 
                        deal.description, 
                        deal.desiredBorrowAmount, 
                        deal.repayAmount,
                        deal.repayFinish);

        return (deal.dealId, 
                deal.farmerAddr, 
                deal.title, 
                deal.description, 
                deal.desiredBorrowAmount, 
                deal.repayAmount);
    }


    /*
    * @dev Count deals
    */ 
    function getDealsCount() public view returns (uint256 dealsCount) {
        uint256 _dealsCount;
        _dealsCount = deals.length;
        return _dealsCount;
    }
    

    /** 
     * @dev [Group Lending] automatically by using SmartContract 
     */
    function groupLending(
        uint256 _groupId,
        address[] _groupMendberAddr,  // Addresses of 5 members
        string _title,
        string _description,
        uint256 _desiredBorrowAmount,
        uint256 _repayAmount,
        uint256 _repayDeadline
    ) 
        public 
        returns (uint256, address[]) 
    {
        // Calculate credit score of group
        uint256 _groupCreditScore;
        _groupCreditScore = getCreditScoreOfGroup(_groupId);

        // Save to storage
        Group memory group = Group({
            groupId: _groupId,
            groupMemberAddr: _groupMendberAddr,
            title: _title, 
            description: _description,
            desiredBorrowAmount: _desiredBorrowAmount,
            repayAmount: _repayAmount,
            repayDeadline: _repayDeadline,
            repayFinish: false,
            repaidCountTotal: _groupCreditScore
        });
        groups.push(group);

        emit GroupLending(
            group.groupId,
            group.groupMemberAddr,
            group.title,
            group.description,
            group.desiredBorrowAmount,
            group.repayAmount,
            group.repayDeadline,
            group.repayFinish,
            group.repaidCountTotal
        );

        return (group.groupId, group.groupMemberAddr);
    }
    






    /******************** Function of credit score below *********************/
    
    /**
     * @dev The condition which count up of credit score
     */ 
    function countUpOfCreditScore(uint256 _individualId) public returns (bool) {
        Deal memory deal = deals[_dealId];
        Individual memory individual = individuals[_individualId];

        // [Condition]：If repayAmount of individual is reached to repayAmount of deal, repaidCount of individual is counted up.
        if (deal.repayAmount == individual.repayAmount) {
            individual.repaidCount = individual.repaidCount++;
        }
    }
    

    /*
    * @dev Count groupId
    */ 
    function getGroupCount() public view returns (uint256 groupsCount) {
        uint256 _groupsCount;
        _groupsCount = groups.length;
        return _groupsCount;
    }


    /**
    * @dev Credit Score (of individual) function which is measured by repaid count
    */ 
    function getCreditScore(address _individualAddr) public returns (uint256 repaidCount) {
        uint256 _repaidCount;
        Individual memory individual = individuals[_individualAddr];
        _repaidCount = individual.repaidCount;
        return _repaidCount;
    }


    /**
    * @dev In case of group borrowing, it use group member's total repaid count as credit score  
    */ 
    function getCreditScoreOfGroup(uint256 _groupId) public returns (uint256 groupCreditScore) {
        uint256 _groupCreditScore;

        Group memory group = groups[_groupId];

        for (uint256 i=0; i < group.groupMemberAddr.length; i++) {
            address _individualAddr;
            uint256 _repaidCount;

            _individualAddr = group.groupMemberAddr[i];

            Individual memory individual = individuals[_individualAddr];
            _repaidCount = individual.repaidCount;

            _groupCreditScore.sub(_repaidCount);
        }

        return _groupCreditScore;  // That is total repaidCount (it works as credit score) of all of group members
    }
    

}
