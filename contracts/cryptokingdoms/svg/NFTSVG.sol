// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import '@openzeppelin/contracts/utils/Strings.sol';
import './Address.sol';

/// @title NFTSVG
/// @notice Provides a function for generating an SVG associated with a Uniswap NFT
library NFTSVG {
    using Strings for uint256;
    using Address for address;

    struct SVGParams {
        uint256 tokenId;
        uint8 cupType;
        string dragonNameSVG;
        string name;
        uint256 entries;
        string date;
        uint256 rank;
        address userAddress;
        uint256 userId;
        address owner;
    }

    function generateSVG(SVGParams memory params) internal pure returns (string memory) {
        return
            string(
                abi.encodePacked(
                    generateSVGHeader(),
                    '<defs>',
                    generateStyle(params.cupType),
                    generateLinearGradient(),
                    '</defs>',
                    generateSVGPath(params.dragonNameSVG),
                    generateSVGText(params),
                    '</svg>'
                )
            );
    }

    function generateSVGHeader() private pure returns (string memory svg) {
        svg = string(
            abi.encodePacked(
                '<svg width="500" height="736" viewBox="0 0 500 736" xmlns="http://www.w3.org/2000/svg"',
                " xmlns:xlink='http://www.w3.org/1999/xlink'>"
            )
        );
    }

    function getColor(uint8 cupType) private pure returns (string memory, string memory, string memory, string memory) {
        if(cupType == 1){
            return ("1a1a1a","b60b0b","b60b0b","cab96d");
        }else if(cupType == 2){
            return ("aaaeb2","1b1b1b","0c19df","a8a8a8");
        }else if(cupType == 3){
            return ("c5ab66","1b1b1b","008100","c5ac8a");
        }else if(cupType == 4){
            return ("4f2118","f4ba0b","f4ba0b","ca6d85");
        }
        return ("","","","");
    }

    function generateStyle(uint8 cupType) private pure returns (string memory svg) {
        (string memory cardBase, string memory frame, string memory dragon, string memory light)
        = getColor(cupType);

        svg = string(
            abi.encodePacked(
                '<style>',
                '.cardBase{fill: #',
                cardBase,
                ';}.shine{fill-rule: evenodd;mix-blend-mode: overlay; width: 500px; height: 736px;}.frame{stroke: #',
                frame,
                ';}.logo{fill: #',
                frame,
                ';fill-rule; evenodd; font-family: Verdana;}.dragon{stop-color: #',
                dragon,
                ';}.light {fill: #',
                light,
                ';fill-rule: evenodd;mix-blend-mode: overlay;}.text{font-size: 23px;text-anchor: middle;fill: white; font-family: Helvetica;}.text2{font-size: 27px;text-anchor: middle;fill: white; font-family: Helvetica;}',
                '.textAddress{font-size: 14px;text-anchor: middle;fill: url(#address); font-family: Times New Roman;}.addressStop{stop-color: white;stop-opacity: 0;}',
                '</style>'
        )
        );
    }

    function generateSVGText(SVGParams memory params) private pure returns (string memory) {
        string memory svg0 = string(
            abi.encodePacked(
                '<text x="50%" y="76%" class="text">',
                params.name,
                '</text><text x="50%" y="80%" class="text">',
                params.date,
                '</text><text x="50%" y="84%" class="text">',
                params.rank.toString(),
                '/'
            )
        );

        string memory svg1 = string(
            abi.encodePacked(
                params.entries.toString(),
                '</text><text x="50%" y="89%" class="text">User ID : ',
                params.userId.toString(),
                '</text><text x="370" y="-484" textLength="520" class="textAddress" transform="rotate(90)" >',
                params.userAddress.toAsciiString(),
                '</text><text x="-370" y="16" textLength="520" class="textAddress" transform="rotate(-90)" >',
                params.owner.toAsciiString(),
                '</text>'
            )
        );
        
        return string(
            abi.encodePacked(svg0,svg1)
        );
    }

    function generateSVGPath(string memory dragonNameSVG) private pure returns (string memory svg) {
        svg = string(
            abi.encodePacked(
                '<rect class="cardBase" width="500" height="736" rx="53.832" ry="53.832"/>',
                '<rect fill="url(#shine)" class="shine" /><rect fill="url(#shine2)" class="shine" />',
                '<path class="light" d="M53.832,0H446.168A53.691,53.691,0,0,1,486.06,17.688L17.864,722.212A53.688,53.688,0,0,1,0,682.168V53.832A53.832,53.832,0,0,1,53.832,0Z"/>',
                '<path class="logo" d="M46.89,70.138h9.619V23.482H48.964q-1.555,1.613-8.467,5.184v7.142a16.775,16.775,0,0,1,1.613-.749q0.979-.4,1.44-0.576,2.707-1.152,3.341-1.5V70.138Z" />',
                '<path class="frame" fill="none" stroke-width="6px" fill-rule="evenodd" d="M424.516,713H75.832A53.832,53.832,0,0,1,22,659.168V99.438H46.168A53.832,53.832,0,0,0,100,45.606V24H424.516a53.832,53.832,0,0,1,53.832,53.832V659.168A53.831,53.831,0,0,1,424.516,713Z" />',
                dragonNameSVG,
                '<path class="logo" d="M190.563,196.762h7.584l3.12-23.472,3.312,23.472h7.488l4.656-38.88h-7.2l-2.352,22.512L204.1,157.93h-5.712l-2.928,22.608-2.3-22.656h-7.3Zm28.7-32.448h7.872V158.89h-7.872v5.424Zm0.048,32.448h7.824V169.018h-7.824v27.744Zm11.472,0h7.824v-21.7a4.76,4.76,0,0,1,2.448-1.008,1.4,1.4,0,0,1,1.224.5,2.705,2.705,0,0,1,.36,1.56v20.64h7.776V175.018a7.721,7.721,0,0,0-1.32-4.68,4.441,4.441,0,0,0-3.816-1.8q-3.408,0-6.672,3.264v-2.784h-7.824v27.744Zm23.136,0h7.824v-21.7a4.754,4.754,0,0,1,2.448-1.008,1.4,1.4,0,0,1,1.224.5,2.705,2.705,0,0,1,.36,1.56v20.64h7.776V175.018a7.728,7.728,0,0,0-1.32-4.68,4.444,4.444,0,0,0-3.816-1.8q-3.41,0-6.672,3.264v-2.784h-7.824v27.744Zm32.207,0.48a9.863,9.863,0,0,0,6.792-2.16q2.423-2.16,2.424-6.336v-2.688h-7.2v2.928q0,2.688-2.016,2.688-1.92,0-1.92-2.976V183.37h11.136V177.8q0-4.56-2.3-6.912t-6.912-2.352a9.882,9.882,0,0,0-7.1,2.424,8.994,8.994,0,0,0-2.544,6.84v10.176a8.994,8.994,0,0,0,2.544,6.84,9.882,9.882,0,0,0,7.1,2.424h0Zm-1.92-17.52V177.37a4.862,4.862,0,0,1,.48-2.544,1.569,1.569,0,0,1,1.392-.72,1.881,1.881,0,0,1,1.512.648,3.388,3.388,0,0,1,.552,2.184v2.784h-3.936Zm14.3,17.04h7.824V178.714q2.064-2.688,4.608-2.688a6.986,6.986,0,0,1,2.544.576v-7.776a4.852,4.852,0,0,0-4.368,1.056,14.885,14.885,0,0,0-2.784,3.744v-4.608h-7.824v27.744Z" />',
                '<path fill="url(#dragon)" fill-rule="evenodd" d="M169,315v6l-7,10-9-5-3-11,3-9,7-1-3-2-6,1-4,10,4,14,12,7,7-8,3-7v-3l-2-3Zm-15,5-1,1,1,4,4,1,2-3Zm-10,1,2-1,2,7,2,3-5,2-1-4v-7Zm13-14-4,5v6h5v-4l3-2v-2Zm-9-3h2l-4,7-1,6-2-1v-5Zm13-5-1,3,6,10h2l3-1-1-2-2-7h1l-1-2Zm69,29,2,8h3l2-6S231.391,327.268,230,328Zm-5-11,4,9s4.25-6.124,6-6a36.141,36.141,0,0,0-4-4Zm-27,20-1,7h19l3-7h-2l-1,3-5-3-1,3-6,1-3-4h-3Zm-59-15h-9l-1,3,3,3v5l4,1,1,1,6-2S137.092,326.943,139,322Zm10-31-9,2-5,10v2s6.582,1.578,7,4c1.212-2.243,6.886-11.319,11-11C152.449,296.73,149,291,149,291Zm5-2,2,9s14.028-3.1,15-1c0.454-3.079-2-11-2-11S156.135,287.9,154,289Zm18-3s0.669,8.868,1,12c3.048-.491,14,0,14,0s-1.059-11.383-3-13C182.382,285.065,172,286,172,286Zm18,13h8v3l-5,6-5-3Zm15-4-4,5,2,3,4-2v-5Zm-12-3-3,5s10.666-1.592,11,0a44.11,44.11,0,0,0,4-3v-2H193Zm39-70-3,12-3-5-3,3a58.465,58.465,0,0,0,4,6c-1.71,7.6-7,16-7,16s-3.959-8.967-5-8-2,2-2,2l3,12s-0.571,3.76-1,4a11.445,11.445,0,0,1,7,2c0-3.24,6-18,6-18l6-15,1-11h-3Zm-5,34-3,9h3l10-5S232.716,255.456,227,256Zm-24,15h16l1-2s1.128-2.679-6-3A13.5,13.5,0,0,0,203,271Zm-12-1,8,6s-3.841,10.686-5,12a52.881,52.881,0,0,0-5-2l2-3-2-7v-6h2Zm27,2c0.711,2.216-7,12-7,12s0.617,2.391,1,2c5.944-6.076,29-16,29-16l-1-1S219.168,272.474,218,272Zm4-3v1l19-3,3,2v-2l-2-3-4-1Zm45-44,3.966,0.218A98.832,98.832,0,0,1,266,239c3.89-3.4,6-5,6-5l3,4s-7.874,3.158-12,8a110.818,110.818,0,0,0-8,11s-1.531-1.31-4,0-6,5-6,5h-7l1-2,11-8S264.491,239.262,267,225Zm-16,20h4s5.629-6.48,2-6S253.273,244.608,251,245Zm-3,2s-9.976,8.022-13,8a40.88,40.88,0,0,0,4,2s11.8-6.8,13-9C251.574,247.487,248,247,248,247Zm26-16v1l4,4,5-2s2.417-10.364,2-16C282,221.657,274,231,274,231Zm-40,10c0.4,3.232-1.234,9.343-3,11a3.522,3.522,0,0,0,2,1s14.535-6.556,15-8-0.808-2.354,0-3c3.9-3.117,9.718-10.182,12-17a5.416,5.416,0,0,0-1-2l-2-1S241.191,240.354,234,241Zm-6,50s-19.136,8.476-19,9,6,1,6,1l15-6Zm25-5-1,3,13,17,2-1s-1.465-5.214-1-9c-1.332-1.341-2,0-2,0l-2-2s-2.263-10.984,2-13a4.431,4.431,0,0,1-3-1Zm16,26,5,8v-8S268.13,311.739,269,312Zm10-25-3,6,2,9v10h5s9.379-3.643,11-5c-0.275-.246,0-2,0-2l-6,1,1-7,2-4,1-5,4-5s-1.961-2.615-3-2-5,6-5,6l-1,7-5,8-2-4-1-7,2-4-1-2h-1m22,4c-3.245.4-10.912,8.746-11,11s0.3,2.1,2,1,4.3-4.369,12-7C305.459,295.385,304.245,290.6,301,291Zm-26-11s-6.9,7.987-7,10,0.436,9.816,1,11a4.2,4.2,0,0,1,2,0,7.389,7.389,0,0,1,0-5c0.99-2.591,8-11,8-11v-3Zm13-3,4,4s-5.145,5.086-6,7-2,9-2,9l-2,3-1-2,2-12S285,277.845,288,277Zm-42-12,2,3,13-8,1-6-6,4-3,1Zm1,5v6s13.765-3.265,15-2c-0.025-3.251,5-9,5-9l-1-3Zm22-6s-3.164,9.254-2,11c1.5-2.034,8.077-5.7,9-4,0.393-2.411,2.767-8.228,4-9C276.525,261.427,269,264,269,264Zm14-26-1,8s-17.263,3.858-18,5c0.257-.98,1-4,1-4S282.2,237.27,283,238Zm-18,15s4.366,5.573,4,7c2.021-.364,7.369-2.034,10-1a81.28,81.28,0,0,0,2-10S264.934,251.806,265,253Zm18,8-4,8s13.167-3.257,14-2c0.833-.732,3-3,3-3Zm2-25v11s14.612,0.872,15,0,1-8,1-8l-3-4h-9Zm0,13-3,9,15,3s4.288-11.834,3-12S285,249,285,249Zm-7,65-1,6,2,1s9.258,0.171,10-1,0-3,0-3l-3-4S279.139,314.271,278,314Zm20-6-2,2,6,7s3.722-1.54,4-3S298,308,298,308Zm-9,5,2,4v4s9.71-1.172,10-3c-1.716-1.232-7-7-7-7h-2Zm20-14-8,8,8,4,10-10v-2H309Zm-1-12v9l2,1,10,1s1.542-2.566,1-3c-2.291-1.833-3.8-5.451-4-9C315.441,286.029,308,287,308,287Zm10-44h-3l-10,10s13.5,8.314,14,10c1.407-3.133,11-10,11-10Zm-16-8s16.949,2.076,17,5a8.307,8.307,0,0,1,4-4s3.03-13.764,5-14a12.041,12.041,0,0,0-4,0l-5,6S302,231.762,302,235Zm31,20c-2.066.923-10,8-10,8l1,2,9,5,4-11S335.066,254.077,333,255Zm35,28s-3.068,8.157-4,9c1.939,0.014,7.339-.313,7-2S368,283,368,283Zm-4-12s-6.608,23.986-8,29c6.946-4.837,13-25,13-25S367.482,270.565,364,271Zm-38-1c-0.054.006-2.879,13.768-1.976,16.1A12.784,12.784,0,0,0,327,287l-1,11s16.319,2.2,22,4a4.427,4.427,0,0,0,1-3l5-4s5.8-9.965,5-11-8.5,8.932-12,10c0.222-4.863,4-20,4-20s-7.392,17.777-10,18-3,0-3,0,2.065-27.506,2-32a94.044,94.044,0,0,0-4,12Zm-90,29c2.364-.91,10-11,10-11l3-1,25,36-21-8v16l-7-7v-4l-13-14-13,3-2-6s11.982-5.629,13-5C232.092,298.675,235.213,299.3,236,299Zm-76,37-6,6v1l13,5,4-8Zm-9,10h3l12,4,3,4-2,3-19-8Zm146-24,8,16s15.486-1.546,16,0a2.621,2.621,0,0,1,1-2l-20-16Zm-19,1-1,8s6.209,2.408,7,7c3.158,0.221,16,0,16,0l-6-15H278Zm-79,24h17l3,8v3l-13,1Zm-5,6,6,5-1,1h-7l2-6m-16-13-0.374.15L173,342l-2,6s1.428,10.185,3,10,14,0,14,0l3-6-5-6h-2l-3,4m27,10c-0.341,2.487,2,5,2,5l8-3v-2S209.738,360.409,208,360Zm4,7s2.386,5.107,2,7a23.307,23.307,0,0,0,5-2v-8Zm10-5c-0.349.7,0,6,0,6s6,2.072,6,3a74.2,74.2,0,0,1,8-3l-1-2S225.074,364.466,222,362Zm8-22-6,6v10s2.092,3.192,11,6,62.2-2.512,66-3,10-3,10-3l2-7-5-6H290l2,6-2,3-5,1-7-6-2-5-6.784-4L265,343s-4.776,3.816-7,4-10,0-10,0-4.057-3.244-8-7C236.832,339.923,230,340,230,340Zm15,50-3-1-6,10,1,1,8-2v-8Zm12-5,1,4,3,5-14,4v-8S253.415,384.422,257,385Zm29-10c-2.222,2.356-7,5-7,5v3l13,1s9.609,1.406,11,4a83.721,83.721,0,0,0,4-9S288.357,377.154,286,375Zm-6,11-11,10,9,8,15-3,8-12S284,384.889,280,386Zm-62,1c1.344,0.373,25-1,25-1s14.575-6.215,17-5c1.829-.873,9-6,9-6v-7s-21.741-3.734-31,0c-3.192,1.287-13,7-13,7S218.149,383.49,218,387Zm96-45s42.3,0.31,49-8c2.216,1.639,3,9,3,9s-6.439,6.261-8,7c-4.52,2.141-35,1-35,1S314.109,346.92,314,342Zm2,10,6,2h32l6,3-1,5s-9.349,8.459-15,10c-3.529.962-24.062,2.82-31,3s-28.106-2.652-29-10c0.754-.761,3-1,3-1s24.455-2.945,27-5A54.727,54.727,0,0,1,316,352ZM205,416H192l-12,5-1,19-10,14-4,9,12,9s43.268,13.358,46,13,41.567,0.627,47,0c27.769-3.2,66-19,66-19s2.314-4.451,2-5c-3.957-6.926-17.286-23.808-24-29,0.516-2.829,0-22,0-22H300l-1,27s-15.472,5.746-20,6c-0.507-2.963-1-14-1-14l-16,2-1,12H232l-1-10-19,1S203.966,424.847,205,416Zm90-14c0,0.423,3,14,3,14s-7.6,16.611-13,23a5.141,5.141,0,0,0-3,0V426l-25,2,1,11H235l-1-10H214l-6-15s37.8,3.176,49,1S282.4,411.388,295,402ZM171,383l-5,9,0.008,4.479S170.455,398.856,172,400c3.747,2.775,42.41,9.437,51,6,3.789-1.516,8-7,8-7l-2-7s-31.616-.952-34-3a62.454,62.454,0,0,1-5-5Zm-20-18-8-2-6,4s-6.344,11.943,2,15c4.246,1.556,27,4,27,4l3-6,23,1,5,6,3-1,3-4-2-7-17-3-17.575-1.728Zm124,2,8,7-6,4-1,4-5-3,2-10Zm-8,13-7,5,6,11,9-10-8-6m-17,19-1,2,11,11,15-4,1-3s-11.3-7.776-13-9C259.009,397.277,250,399,250,399Zm-16,2-2,4s3.245,7.148,4,7,18-1,18-1v-2l-9-9Zm-3-12,3,8,5-8h-8Zm-2,17-7,4,10,1Zm-20-38-5,3,2,6,5-3Zm-28-3v2s16.389,1.224,18,4c2.009-2.27,7-5,7-5v-2l-3-3H191Zm128-51-4,5,25,18,8-6S305.452,311.537,309,314Zm3-3,28,17,4-4s-15.151-12.808-11-23c-3.507-.433-10-1-10-1Zm24-9s10.854,4.485,12,4,5-6,5-6-2.641,19.54-9,20C340.946,320.221,335.187,301.39,336,302Zm5-49s1.293,28.428,1,34c3.28-4.574,11-31.849,8-35S342.447,250.552,341,253Zm13,9c0.3,3.208-2.729,26.645-4,27,10.2-6.384,13.33-26.617,12-29S353.649,258.223,354,262Zm-49-24-2,1s-0.54,13.791,0,13,10-11,10-11Zm-3,16c0.672,6.184-3,14-3,14l6,5h2l8-9S305.763,256.218,302,254Zm23-12-2,3,15,11v-6S323.6,242,325,242Zm-1,26h-4s-2.284,17.028,1,23c0.9,1.418,2-2,2-2S321.73,272.8,324,268Zm-7-2-10,9v9l2,1,6-1Zm-60,56-1,9,4,3,5-8,8,2v-2l-13-7Zm-26-36-2,2,5,7s4.247,0.131,5-1,4-8,4-8l19-7v-2s-19.346,2.161-22,0c-1.358,4.939-3.7,10.391-5,11S230.815,286.432,231,286Zm-29-13v5s-3.569,9.923-5,10,9,0,9,0l10-15H202Zm-68,34c-0.979,2.105-5.472,11.956-6,11s1,2,1,2h11l-1-10A19.153,19.153,0,0,0,134,307Zm5,30v3l5,7h2s6.305-10.878,10-11c1.024-1.1-1-3-1-3Zm77-17,11,15h3l-7-17Zm5,18,5,2-4,5v5l-2,1-1-6Zm-43-38v2l6,2,3-4h-9Zm-6,1-1,6,5,12,2,1,3,4-1,2-7,13,8-6v11s5.7-3.861,6-8c-0.511,4.019-1,8-1,8s8.633,7.215,14,9a42.257,42.257,0,0,1-6-10c-0.095-1.026,2.3-10.591,4-11,1.568,1.614,8,8,8,8h1s-1-9.433,0-13c2.547,3.984,5.438,7.94,8,10,0.352-3.014,0-17,0-17l-9-5,2-1,7,3h4l12-4,8,8,1,15,10,8s8.252,0.521,10-1,8-10,8-10l9,5,8,12-3-12-14-9-9,11h-7l-9-8-1-12-10-11-14,4-8-4,1-1,7,2-3-7h-6l-8,5-1-5-7,7S173.945,301.729,172,301Zm20,15-3,3h-5v9h8l5-6,7-6h-7l-2,5Zm-15-9,6,11,3-4Zm-11,28,4,3s5.027-5.142,6-8c-1.875-1.538-4-3-4-3S166.9,334.444,166,335Z" />',
                '<path fill="url(#dragoneye)" fill-rule="evenodd" d="M227,280l-20,11,3,5,11-4Zm-38,8,3,2-3,6v-8Z" />'
        )
        );
    }

    function generateLinearGradient() private pure returns (string memory svg) {
        svg = string(
            abi.encodePacked(
                '<linearGradient id="shine" gradientTransform="rotate(320)"><stop offset="0.44" stop-color="white" stop-opacity="0" /><stop offset="0.6" stop-color="white" stop-opacity="0.8" /><stop offset="0.63" stop-color="white" stop-opacity="0" /></linearGradient>',
                '<linearGradient id="shine2" gradientTransform="rotate(40)" x1="0" x2="0" y1="0" y2="1"><stop offset="0.16" stop-color="white" stop-opacity="0" /><stop offset="0.4" stop-color="white" stop-opacity="0.5" /><stop offset="0.66" stop-color="white" stop-opacity="0" /></linearGradient>',
                '<linearGradient id="dragon"><stop offset="0" class="dragon" stop-opacity="0.7" /><stop offset="0.5" class="dragon" stop-opacity="1" /><stop offset="1" class="dragon" stop-opacity="0.7" /></linearGradient>',
                '<linearGradient id="dragoneye"><stop offset="0" stop-color="#fdf6e4" stop-opacity="1"><animate attributeName="stop-opacity" values="0;0;0.8;1;0.8;0" dur="9s" repeatCount="indefinite" /></stop></linearGradient>',
                '<linearGradient id="address"><stop offset="0" class="addressStop">',
                '<animate attributeName="stop-opacity" dur="9s" repeatCount="indefinite" begin="1.6s" values="0.1;0.2;0.4;0.7;1;1;1;1;0.8;0.6;0.3;0.1;0;0;0;0;0" />',
                '</stop><stop offset="0.25" class="addressStop"><animate attributeName="stop-opacity" dur="9s" repeatCount="indefinite" begin="1.6s" values="0;0.1;0.2;0.4;0.7;1;1;1;1;0.8;0.6;0.3;0.1;0;0;0;0" />',
                '</stop><stop offset="0.5" class="addressStop"><animate attributeName="stop-opacity" dur="9s" repeatCount="indefinite" begin="1.6s" values="0;0;0.1;0.2;0.4;0.7;1;1;1;1;0.8;0.6;0.3;0.1;0;0;0" />',
                '</stop><stop offset="0.75" class="addressStop"><animate attributeName="stop-opacity" dur="9s" repeatCount="indefinite" begin="1.6s" values="0;0;0;0.1;0.2;0.4;0.7;1;1;1;1;0.8;0.6;0.3;0.1;0;0" />',
                '</stop><stop offset="1" class="addressStop"><animate attributeName="stop-opacity" dur="9s" repeatCount="indefinite" begin="1.6s" values="0;0;0;0;0.1;0.2;0.4;0.7;1;1;1;1;0.8;0.6;0.3;0.1;0" />',
                '</stop></linearGradient>'
        )
        );
    }
}
