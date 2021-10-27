// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { IStaking } from "../Staking.sol";
import "./ITokenDescriptor.sol";
import './NFTSVG.sol';
import '@openzeppelin/contracts/utils/Strings.sol';
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import 'base64-sol/base64.sol';

contract CKTokenDescriptor is ITokenDescriptor, Ownable {
    using Strings for uint256;

    IStaking public staking;

    string description = "You should make the castle bigger and conquer the crypto kingdoms!";

    struct ConstructTokenURIParams {
        uint tokenId;
        uint[] facilities;
    }

    constructor(address staking_) {
        staking = IStaking(staking_);
    }

    function setDescription(string memory description_) public onlyOwner {
        description = description_;
    }

    function generateName(uint256 tokenId) private view returns (string memory) {

        return
            string(
                abi.encodePacked("CryptoKingdoms Castle #", tokenId)
            );
    }

    function generateDescription() private view returns (string memory) {
        return
            string(
                abi.encodePacked(
                    description
                )
            );
    }

    // function generateAttributes(ConstructTokenURIParams memory params) private view returns (string memory) {
    //     return
    //         string(
    //             abi.encodePacked(
    //                 '[{"trait_type": "x","value": "',
    //                 params.x,
    //                 '"},{"trait_type": "y","value": "',
    //                 params.y,
    //                 '"}]'
    //         )
    //         );
    // }


    function generateSVGImage(ConstructTokenURIParams memory params) private pure returns (string memory) {
        // NFTSVG.SVGParams memory svgParams =
        //     NFTSVG.SVGParams({
        //         facilities: params.facilities
        //     });

        // return NFTSVG.generateSVG(svgParams);

        return string(
            bytes.concat(
                getSVGHeader(),
                getSVGBody(params.facilities),
                "</svg>"
            )
        );

    }

    function getSVGHeader() private pure returns (bytes memory) {
        return(
            bytes.concat(
                '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
                '<style>.textClass { fill: #fff; font-size: 12px; text-anchor: middle;}</style>',
                '<rect width="100%" height="100%" fill="#ddd" />'
            )
        );
    }

    function getSVGBody(uint256[] memory facilities) private pure returns (bytes memory b) {
        // TODO yamaura facilities

        for(uint8 i = 0; i < facilities.length; i++){
            b = bytes.concat(b, '<rect x="0" y="0" width="70" height="70" fill="#009900" />');
        }
    }

    function constructTokenURI(ConstructTokenURIParams memory params) private view returns (string memory) {
        string memory image = Base64.encode(bytes(generateSVGImage(params)));

        return
            string(
                abi.encodePacked(
                    'data:application/json;base64,',
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"',
                                generateName(params.tokenId),
                                '", "description":"',
                                generateDescription(),
                                // '", "attributes":"',
                                // generateAttributes(params),
                                '", "image": "data:image/svg+xml;base64,',
                                image,
                                '"}'
                            )
                        )
                    )
                )
            );
    }

    function tokenURI(IERC721 _token, uint256 _tokenId)
        external
        view
        override
        returns (string memory)
    {
        return
            constructTokenURI(
                ConstructTokenURIParams({
                    tokenId: _tokenId,
                    facilities: staking.getStakings(_tokenId)
                })
            );
    }

}
