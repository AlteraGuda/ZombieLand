// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./ZombieAttack.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

abstract contract ZombieOwnership is ZombieAttack, ERC721 {

  using SafeMath for uint256;

  mapping (uint => address) zombieApprovals;

    function balanceOf(address tokenOwner) public override view returns (uint256 balance) {
    return ownerZombieCount[tokenOwner];
  }
 
function ownerOf(uint256 tokenId) public view virtual override returns (address) {
        return zombieToOwner[tokenId];
  }

 function _transfer(address from, address to, uint256 tokenId) internal virtual override {
    ownerZombieCount[to] = ownerZombieCount[to].add(1);
    ownerZombieCount[msg.sender] = ownerZombieCount[msg.sender].sub(1);
    zombieToOwner[tokenId] = to;
    emit Transfer(from, to, tokenId);
  }

function transferFrom(address from, address to, uint256 tokenId) public virtual override {
          require (zombieToOwner[tokenId] == msg.sender || zombieApprovals[tokenId] == msg.sender);
      _transfer(from, to, tokenId);
    }

    function approve(address to, uint256 tokenId) public virtual override {
      zombieApprovals[tokenId] = to;
      emit Approval(msg.sender, to, tokenId);
    }

}
