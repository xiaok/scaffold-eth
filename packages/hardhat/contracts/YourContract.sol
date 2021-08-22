pragma solidity >=0.6.0 <0.9.0;
//SPDX-License-Identifier: MIT

// import "hardhat/console.sol";
import "./hashVerifier.sol";
//import "@openzeppelin/contracts/access/Ownable.sol"; //https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol

contract YourContract is Verifier {

  event SetPurpose(address sender, string purpose);

  string public purpose = "Testing ZK Proofs!!";
  uint256 public playerBet;
  uint256 public playerSeed;
  uint256 public playerCommit;
  uint256 public threshold;
  uint256 public verifiedHash;
  uint256 public verifiedGreater;

  constructor() public {
    // what should we do on deploy?
  }
  
  function placeBet(uint bet, uint seedHash) public {
      require(playerCommit == 0, "You have already played.");
      playerBet = bet;
      playerSeed = seedHash;
      //TODO: Combine block hash with secret seed hash
      uint user_block_hash = uint(
          keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp))
      );
      playerCommit = user_block_hash % 13 + 1;
  }
  function dealCard() public {
        uint threshold_block_hash = uint(
            keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp))
        );
        threshold = threshold_block_hash % 13 + 1;
  }

  function testVerifyProof(
          uint[2] memory a,
          uint[2][2] memory b,
          uint[2] memory c,
          uint[4] memory input
      ) public {
      require(verifyProof(a, b, c, input), "Invalid Proof");
      verifiedHash = input[0];
      verifiedGreater = input[1];
  }
}
