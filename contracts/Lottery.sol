//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.13;
import "hardhat/console.sol";

contract Lottery {
    // declaring the state variables
    address[] public players; //dynamic array of type address payable
    address[] public gameWinners;
    address public immutable owner;

    // declaring the constructor
    constructor() {
        owner = msg.sender;
    }

    // declaring the receive() function that is necessary to receive ETH
    receive() external payable {
        // TODO: require each player to send exactly 0.1 ETH
        // TODO: append the new player to the players array
        require(msg.value == 0.1 ether, 'INACCURATE_VALUE');
        players.push(msg.sender);
    }

    // returning the contract's balance in wei
    function getBalance() public view returns (uint256) {
      require(msg.sender == owner, "ONLY_OWNER");
      return address(this).balance;
    }

    // selecting the winner
    function pickWinner() public {
      require(msg.sender == owner, "ONLY_OWNER");
      require(players.length > 2, "NOT_ENOUGH_PLAYERS");

        uint256 r = random();
        address winner;

        // TODO: compute an unsafe random index of the array and assign it to the winner variable 
        winner = players[r % players.length];

        // TODO: append the winner to the gameWinners array
        gameWinners.push(winner);

        // TODO: reset the lottery for the next round
        delete players;

        // TODO: transfer the entire contract's balance to the winner
        winner.call{value: getBalance()}("");
    }

    // helper function that returns a big random integer
    // UNSAFE! Don't trust random numbers generated on-chain, they can be exploited! This method is used here for simplicity
    // See: https://solidity-by-example.org/hacks/randomness
    function random() internal view returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encodePacked(
                        block.difficulty,
                        block.timestamp,
                        players.length
                    )
                )
            );
    }
}
