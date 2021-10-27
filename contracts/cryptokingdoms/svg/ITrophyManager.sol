// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface ITrophyManager {

    function trophyDatas(uint256 tokenId) external view returns (
        string memory name, 
        uint entries, 
        string memory date, 
        uint rank, 
        address userAddress, 
        uint256 userId,
        address owner 
    );

}
