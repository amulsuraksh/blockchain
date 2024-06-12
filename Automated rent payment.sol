// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RentPayment {
    address public landlord;
    address public tenant;
    address public arbitrator;
    uint public rentAmount;
    uint public securityDeposit;
    uint public leaseEndDate;
    uint public nextPaymentDate;
    bool public isDispute;
    bool public isLeaseActive;

    mapping(address => uint) public balances;

    event RentPaid(address indexed tenant, uint amount, uint date);
    event SecurityDepositPaid(address indexed tenant, uint amount);
    event SecurityDepositReleased(address indexed landlord, uint amount);
    event DisputeRaised(address indexed tenant, string reason);
    event DisputeResolved(address indexed arbitrator, bool inFavorOfTenant);
    event LeaseTerminated(address indexed landlord);

    modifier onlyLandlord() {
        require(msg.sender == landlord, "Only landlord can call this function");
        _;
    }

    modifier onlyTenant() {
        require(msg.sender == tenant, "Only tenant can call this function");
        _;
    }

    modifier onlyArbitrator() {
        require(msg.sender == arbitrator, "Only arbitrator can call this function");
        _;
    }

    modifier onlyDuringActiveLease() {
        require(isLeaseActive, "Lease is not active");
        _;
    }

    constructor(address _tenant, address _arbitrator, uint _rentAmount, uint _securityDeposit, uint _leaseDuration) {
        landlord = msg.sender;
        tenant = _tenant;
        arbitrator = _arbitrator;
        rentAmount = _rentAmount;
        securityDeposit = _securityDeposit;
        leaseEndDate = block.timestamp + _leaseDuration;
        nextPaymentDate = block.timestamp + 30 days; // Assuming monthly payments
        isLeaseActive = true;
    }

    function payRent() public payable onlyTenant onlyDuringActiveLease {
        require(msg.value == rentAmount, "Incorrect rent amount");
        require(block.timestamp >= nextPaymentDate, "Too early to pay rent");

        balances[landlord] += msg.value;
        nextPaymentDate += 30 days;

        emit RentPaid(tenant, msg.value, block.timestamp);
    }

    function paySecurityDeposit() public payable onlyTenant {
        require(msg.value == securityDeposit, "Incorrect security deposit amount");
        require(balances[address(this)] == 0, "Security deposit already paid");

        balances[address(this)] += msg.value;

        emit SecurityDepositPaid(tenant, msg.value);
    }

    function releaseSecurityDeposit() public onlyLandlord {
        require(block.timestamp >= leaseEndDate, "Lease has not ended yet");
        require(!isDispute, "Cannot release deposit during a dispute");

        uint amount = balances[address(this)];
        balances[address(this)] = 0;

        payable(tenant).transfer(amount);

        emit SecurityDepositReleased(landlord, amount);
    }

    function raiseDispute(string memory reason) public onlyTenant onlyDuringActiveLease {
        isDispute = true;

        emit DisputeRaised(tenant, reason);
    }

    function resolveDispute(bool inFavorOfTenant) public onlyArbitrator {
        require(isDispute, "No dispute to resolve");

        if (inFavorOfTenant) {
            uint amount = balances[address(this)];
            balances[address(this)] = 0;
            payable(tenant).transfer(amount);
        }

        isDispute = false;

        emit DisputeResolved(arbitrator, inFavorOfTenant);
    }

    function terminateLease() public onlyLandlord {
        require(block.timestamp >= leaseEndDate, "Cannot terminate lease before end date");
        require(!isDispute, "Cannot terminate lease during a dispute");

        isLeaseActive = false;

        emit LeaseTerminated(landlord);
    }
}