// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CrowdFunding {
    // Campaign is the user defined data structure used for storing a particular campaign's info into 1 variable
    struct Campaign {
        address owner; // wallet address the owner of the campaign
        string title; // title of the campaign
        string description; // description of the campaign
        uint256 target; // target amount to be achieved
        uint256 deadline; // deadline of campaign
        uint256 amountCollected; // amount collected from donations
        string image; // url of the campaign image
        address[] donators; // donators array
        uint256[] donations; // donations made by the donators
    }

    // mappping the campaign to a specific number
    mapping(uint256 => Campaign) public campaigns;

    uint256 public numberOfCampaigns = 0;

    function createCampaign(
        address _owner,
        string memory _title,
        string memory _description,
        uint256 _target,
        uint256 _deadline,
        string memory _image
    ) public returns (uint256 _id) {
        Campaign storage campaign = campaigns[numberOfCampaigns];

        // is everything ok ?
        require(
            campaign.deadline < block.timestamp,
            "The deadline should be a date in the future"
        );

        campaign.owner = _owner;
        campaign.title = _title;
        campaign.description = _description;
        campaign.target = _target;
        campaign.deadline = _deadline;
        campaign.amountCollected = 0;
        campaign.image = _image;

        numberOfCampaigns++;

        return numberOfCampaigns - 1; // index of newly created campaign
    }

    // payable -> the user will send some amount;
    function donateToCampaign(uint256 _id) public payable {
        uint256 amount = msg.value;
        Campaign storage campaign = campaigns[_id];

        campaign.donators.push(msg.sender);
        campaign.donations.push(amount);

        (bool sent, ) = payable(campaign.owner).call{value: amount}("");

        if (sent) {
            campaign.amountCollected = campaign.amountCollected + amount;
        }
    }

    function getDonators(
        uint256 _id
    )
        public
        view
        returns (address[] memory _donators, uint256[] memory _donations)
    {
        return (campaigns[_id].donators, campaigns[_id].donations);
    }

    function getCampaigns() public view returns (Campaign[] memory) {
        Campaign[] memory allCampaigns = new Campaign[](numberOfCampaigns);

        for (uint i = 0; i < numberOfCampaigns; i++) {
            Campaign storage item = campaigns[i];
            allCampaigns[i] = item;
        }

        return allCampaigns;
    }
}
