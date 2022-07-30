//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract KnowledgeTest {
  string[] public tokens = ["BTC", "ETH"];
  address[] public players;
  address public immutable owner;

  error OnlyOwnerAccess(string reason);

  constructor() {
    owner = msg.sender;
  }

  modifier onlyOwner {
    require(msg.sender == owner, "ONLY_OWNER");
    _;
  }

  receive() external payable {
  }

  function changeTokens() public {
    string[] storage t = tokens;
    t[0] = "VET";
  }

  function getBalance() public view returns (uint) {
    return address(this).balance;
  }

  function transferAll(address payable receiver) public onlyOwner returns(bool, bytes memory) {
    return receiver.call{value: getBalance()}("");
  }

  function start() public {
    players.push(msg.sender);
  }

  function concatenate(string calldata a, string calldata b) public pure returns (string memory) {
    return string(abi.encodePacked(a, b));
  }
}
