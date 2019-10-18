pragma solidity ^0.4.24;


contract MfObjects {

    struct Deal {
        uint256 dealId;
        address farmerAddr;
        string title;
        string description;
        uint256 desiredBorrowAmount;
        uint256 repayAmount;
    }


    struct Group {
        uint256 groupId;
        address[] groupMemberAddr;
        string title;
        string description;
        uint256 desiredBorrowAmount;
        uint256 repayAmount;
        uint256 repayDeadline;
    }


    struct ExampleObject {
        uint exampleId;
        string exampleName;
        address exampleAddr;
    }

}
