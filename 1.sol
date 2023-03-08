// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

interface IERC20Token {

  function transfer(address, uint256) external returns (bool);

  function approve(address, uint256) external returns (bool);

  function transferFrom(address, address, uint256) external returns (bool);

  function totalSupply() external view returns (uint256);

  function balanceOf(address) external view returns (uint256);

  function allowance(address, address) external view returns (uint256);

  event Transfer(address indexed from, address indexed to, uint256 value);

  event Approval(address indexed owner, address indexed spender, uint256 value);

}

contract CharityApp {

    address internal charityAddress;
    address internal tokenAddress = 0x874069Fa1Eb16D44d622F2e0Ca25eeA172369bC1;
    uint public totalDonations = 0;
    uint public totalReviews = 0;

    struct Donation {
        address donor;
        uint amount;
        string message;
    }

    mapping(uint => Donation) public donations;

    struct Review {
        address reviewer;
        string message;
        uint rating;
    }

    mapping(uint => Review) public reviews;

    function donate(uint _amount, string memory _message) public {
        require(_amount > 0, "Donation amount must be greater than 0.");

        require(IERC20Token(tokenAddress).transferFrom(msg.sender, address(this), _amount), "Transfer failed.");

        totalDonations += _amount;

        donations[totalDonations] = Donation(msg.sender, _amount, _message);
    }

    function sendReview(string memory _message, uint _rating) public {
        require(_rating >= 1 && _rating <= 5, "Rating must be between 1 and 5.");

        totalReviews++;

        reviews[totalReviews] = Review(msg.sender, _message, _rating);
    }

    function likeReview(uint _reviewIndex) public {
        reviews[_reviewIndex].rating += 1;
    }

    function dislikeReview(uint _reviewIndex) public {
        reviews[_reviewIndex].rating -= 1;
    }

    function getDonationInfo(uint _donationIndex) public view returns (address, uint, string memory) {
        return (donations[_donationIndex].donor, donations[_donationIndex].amount, donations[_donationIndex].message);
    }

    function getReviewInfo(uint _reviewIndex) public view returns (address, string memory, uint) {
        return (reviews[_reviewIndex].reviewer, reviews[_reviewIndex].message, reviews[_reviewIndex].rating);
    }

    function withdraw() public {
        require(msg.sender == charityAddress, "Only the charity address can withdraw the funds.");

        require(IERC20Token(tokenAddress).transfer(charityAddress, totalDonations), "Transfer failed.");

        totalDonations = 0;
    }

    function setCharityAddress(address _charityAddress) public {
        require(msg.sender == charityAddress, "Only the current charity address can change it.");

        charityAddress = _charityAddress;
    }

}
