---------------------------------------------
//deployer.sol
---------------------------------------------
//SPDX-License_Identifier: MIT
pragma solidity ^0.8.7;

import "./wrapper.sol";

contract deployer {

	mapping (uint => address) public wrappedTokenAddresses;
	uint currentWrapId;

	constructor (){
		currentWrapId = 0;
	}
	
	function WrapToken (
		address _tokenAddress,
		string memory _name,
		string memory _symbol
		) public returns(uint) {
			currentWrapId++;
			wrappedTokenAddresses[currentWrapId] = address(new WrappedToken (
				_tokenAddress,
				_name,
				_symbol
				));

			emit NewWrappedToken(
				_tokenAddress,
				wrappedTokenAddresses[currentWrapId],
				_name,
				_symbol
				);

			return currentWrapId;
	}

	event NewWrappedToken (
		address unwrappedTokenAddress,
		address wrappedTokenAddress,
		string name,
		string symbol);


}



---------------------------------------------
//wrapper.sol
---------------------------------------------

//SPDX-License_Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract WrappedToken is ERC2- {
	
	address public tokenToBeWrapped;
	SafeERC20 token = ERC20(tokenToBeWrapped);

	constructor(
		address _toBeWrapped,
		string memory _name,
		string memory _symbol
		) ERC20 (_name, _symbol){
			tokenToBeWrapped = _toBeWrapped;
		}

	function mint() external payable {
		emit Wrap(msg.sender, msg.value);
		token.transferFrom(msg.sender, address(this), msg.value);
		_mint(msg.sender, msg.value);
	}

	function burn(uint _amount) external {
		emit Unwrap(msg.sender, _amount);
		token.transfer(msg.sender, _amount);
		_burn(msg.sender, _amount);		
	}

	event Wrap(address to, uint amount);
	event Unwrap(address to, uint amount);

}