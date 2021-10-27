// SPDX-License-Identifier: MIT

pragma solidity 0.8.6;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

interface IStaking {

    function getStakings(
        uint tokenId
    ) external view returns(uint[] calldata facilities);

    // function stake(
    //     uint tokenId,
    //     StakingLand memory stakingLand
    // ) external;

    // function withdraw(
    //     uint tokenId,
    //     uint8 index
    // ) external view returns(StakingLand memory);
}

contract Staking is AccessControl, Ownable {

    //TODO yamaura stakingのロジックをまじめに考える

    // struct StakingLand {
    //     address contractAddr;
    //     uint tokenId;
    // }

    // mapping(address => StakingLand[]) public staking;

    // constructor() {}

    function getStakings(
        uint tokenId
    ) external view returns(uint[] memory) {
        // TODO yamaura
        return [1];
    }

    // function stake(
    //     uint tokenId,
    //     StakingLand
    // ) external {
    //     StakingLand[] arr = staking[tokenId];
    //     arr.push();
    // }


}
