pragma solidity ^0.4.16;

interface token {
    function transfer(address receiver, uint amount);
}

contract MNT01Crowdsale {
    address public beneficiary;
    uint public fundingGoal;
    uint public amountRaised;
	uint public amountRaisedSat;
	uint public amountRaisedUsdCent;
	uint public amountRaisedThb;
    uint public deadline;
    uint public price;
	uint public priceSat;
	uint public priceUsdCent;
	uint public priceThb;
    token public tokenReward;
    mapping(address => mapping(uint => uint256)) public balanceOf;
    bool fundingGoalReached = false;
    bool crowdsaleClosed = false;

    event GoalReached(address recipient, uint totalAmountRaised, uint totalAmountRaisedSat, uint totalAmountRaisedUseCent, uint totalAmountRaisedThb);
    event FundTransfer(address backer, uint amount, bool isContribution);

    /**
     * Constrctor function
     *
     * Setup the owner
     */
    function MNT01Crowdsale(
        address ifSuccessfulSendTo,
        uint fundingGoalInMnt,
        uint durationInMinutes,
        uint gweiCostOfEachToken,
		uint satCostOfEachToken,
		uint usdCentCostOfEachToken,
		uint thbCostOfEachToken,
        address addressOfTokenUsedAsReward
    ) {
        beneficiary = ifSuccessfulSendTo;
        fundingGoal = fundingGoalInMnt;
        deadline = now + durationInMinutes * 1 minutes;
        price = gweiCostOfEachToken * 1000000000 wei;
		priceSat = satCostOfEachToken;
		priceUsdCent = usdCentCostOfEachToken;
		priceThb = thbCostOfEachToken;
        tokenReward = token(addressOfTokenUsedAsReward);
    }

    /**
     * Fallback function
     *
     * The function without name is the default function that is called whenever anyone sends funds to a contract
     */
	//TODO: token distribution should not be executed until crowd sale end
    function () payable {
        require(!crowdsaleClosed);
        uint amount = msg.value;
        balanceOf[msg.sender][2] += amount;
        amountRaised += amount / price;
        tokenReward.transfer(msg.sender, amount / price);
        FundTransfer(msg.sender, amount, true);
    }

	function depositSat(address ethAddress, string btcAddress, uint amountSat) {
		require(!crowdsaleClosed);
        balanceOf[ethAddress][1] += amountSat;
        amountRaised += amountSat / priceSat;
        tokenReward.transfer(msg.sender, amountSat / priceSat);
        FundTransfer(msg.sender, amountSat, true);
	}

    modifier afterDeadline() { if (now >= deadline) _; }

    /**
     * Check if goal was reached
     *
     * Checks if the goal or time limit has been reached and ends the campaign
     */
    function checkGoalReached() afterDeadline {
		//TODO: check sum of all currencies amount
        if (amountRaised >= fundingGoal){
            fundingGoalReached = true;
            GoalReached(beneficiary, amountRaised, amountRaisedSat, amountRaisedUsdCent, amountRaisedThb);
        }
        crowdsaleClosed = true;
    }


    /**
     * Withdraw the funds
     *
     * Checks to see if goal or time limit has been reached, and if so, and the funding goal was reached,
     * sends the entire amount to the beneficiary. If goal was not reached, each contributor can withdraw
     * the amount they contributed.
     */
    function safeWithdrawal() afterDeadline {
        if (!fundingGoalReached) {
            uint amount = balanceOf[msg.sender][2];
            balanceOf[msg.sender][2] = 0;
            if (amount > 0) {
                if (msg.sender.send(amount)) {
                    FundTransfer(msg.sender, amount, false);
                } else {
                    balanceOf[msg.sender][2] = amount;
                }
            }
        }

        if (fundingGoalReached && beneficiary == msg.sender) {
            if (beneficiary.send(amountRaised)) {
                FundTransfer(beneficiary, amountRaised, false);
            } else {
                //If we fail to send the funds to beneficiary, unlock funders balance
                fundingGoalReached = false;
            }
        }
    }
}
