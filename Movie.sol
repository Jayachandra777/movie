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

contract MovieBookingPlatform {

    uint internal showsLength = 0;

    address internal cUsdTokenAddress = 0x874069Fa1Eb16D44d622F2e0Ca25eeA172369bC1;

    struct Show {

        string name;

        string image;

        string description;

        string location;

        uint price;

        uint capacity;

        uint sold;

    }

    mapping (uint => Show) internal shows;

    function addShow(

        string memory _name,

        string memory _image,

        string memory _description, 

        string memory _location, 

        uint _price,

        uint _capacity

    ) public {

        uint _sold = 0;

        shows[showsLength] = Show(

            _name,

            _image,

            _description,

            _location,

            _price,

            _capacity,

            _sold

        );

        showsLength++;

    }

    function updateShowDetails(

        uint _index,

        string memory _name,

        string memory _image,

        string memory _description, 

        string memory _location, 

        uint _price,

        uint _capacity

    ) public {

        shows[_index] = Show(

            _name,

            _image,

            _description,

            _location,

            _price,

            _capacity,

            shows[_index].sold

        );

    }

    function getShowInfo(uint _index) public view returns (

        string memory, 

        string memory, 

        string memory, 

        string memory, 

        uint, 

        uint, 

        uint

    ) {

        return (

            shows[_index].name, 

            shows[_index].image, 

            shows[_index].description, 

            shows[_index].location, 

            shows[_index].price,

            shows[_index].capacity,

            shows[_index].sold

        );

    }

    function buyTicket(uint _index, uint _quantity) public payable {

        require(_quantity > 0, "Quantity must be greater than 0.");

        require(_quantity <= shows[_index].capacity - shows[_index].sold, "Not enough tickets available.");

        require(

          IERC20Token(cUsdTokenAddress).transferFrom(

            msg.sender,

            address(this),

            shows[_index].price * _quantity

          ),

          "Transfer failed."

        );

        shows[_index].sold += _quantity;

    }

    function cancelBooking(uint _index, uint _quantity) public {

        require(_quantity > 0, "Quantity must be greater than 0.");

        require(_quantity <= shows[_index].sold, "No tickets to cancel.");

        shows[_index].sold -= _quantity;

        require(

          IERC20Token(cUsdTokenAddress).transfer(

            msg.sender,

            shows[_index].price * _quantity

          ),

          "Transfer failed."

        );
     }
  }
