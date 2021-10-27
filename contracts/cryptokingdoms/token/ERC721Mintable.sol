// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

interface IERC721Mintable {
    function exists(uint256 _tokenId) external view returns (bool);
    function mint(address _to, uint256 _tokenId) external;
    function totalSupply() external returns (uint256);
}

abstract contract ERC721Mintable is ERC721, IERC721Mintable, AccessControl {

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    uint256 public override totalSupply = 0;

    constructor(string memory name_, string memory symbol_) ERC721(name_, symbol_) {
        _setRoleAdmin(MINTER_ROLE, MINTER_ROLE);
        _setupRole(MINTER_ROLE, _msgSender());
    }

    function exists(uint256 _tokenId) external override view returns (bool) {
        return super._exists(_tokenId);
    }

    function mint(address to, uint256 tokenId)
        public
        virtual
        override
        onlyRole(MINTER_ROLE)
    {
        super._mint(to, tokenId);
    }

    function mint(address[] memory _toList, uint256[] memory _tokenIdList) external
    {
        require(
            _toList.length == _tokenIdList.length,
            "input length must be same"
        );
        for (uint256 i = 0; i < _tokenIdList.length; i++) {
            mint(_toList[i], _tokenIdList[i]);
        }
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(AccessControl, ERC721)
        returns (bool)
    {
        return
            AccessControl.supportsInterface(interfaceId) ||
            ERC721.supportsInterface(interfaceId);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override {
        super._beforeTokenTransfer(from, to, tokenId);

        if (from == address(0)) {
            totalSupply++;
        }
    }

}
