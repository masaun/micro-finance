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
            repayAmount: _repayAmount
        });
        deals.push(deal);

        emit CreateDeal(deal.dealId, 
                        deal.farmerAddr, 
                        deal.title, 
                        deal.description, 
                        deal.desiredBorrowAmount, 
                        deal.repayAmount);

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
    * @dev Micro Finance function（Reputation is for collecting Credit Score）
    */ 
    function CreditScoreReputation() public returns (bool) {}

}
