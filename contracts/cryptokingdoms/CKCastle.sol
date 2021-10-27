// SPDX-License-Identifier: MIT

pragma solidity 0.8.6;

// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "./token/ERC721Mintable.sol";
import "./svg/ITokenDescriptor.sol";

contract CKCastle is ERC721Mintable, Ownable {

    address public _tokenDescriptor;

    constructor(address tokenDescriptor_) ERC721Mintable("CryptoKingdoms:Castle", "CKCastle") {
        setTokenDescriptor(tokenDescriptor_);
    }

    function setTokenDescriptor(address tokenDescriptor_) public onlyOwner {
        _tokenDescriptor = tokenDescriptor_;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), 'nonexistent token');
        return ITokenDescriptor(_tokenDescriptor).tokenURI(this, tokenId);
    }

}
