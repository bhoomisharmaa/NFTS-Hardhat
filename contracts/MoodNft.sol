// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.28;
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

error MoodNft__NotOwner();

contract MoofNft is ERC721 {
    enum NftState {
        HAPPY,
        SAD
    }

    uint256 private s_tokenCounter;
    string private s_happySvgImageUri;
    string private s_sadSvgImageUri;

    mapping(uint256 => NftState) s_tokenIdToNftState;

    constructor(
        string memory happySvg,
        string memory sadSvg
    ) ERC721("MoodNft", "MON") {
        s_happySvgImageUri = happySvg;
        s_sadSvgImageUri = sadSvg;
    }

    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenCounter++;
    }

    function flipMood(uint256 tokenId) public {
        if (
            _getApproved(tokenId) != msg.sender &&
            _ownerOf(tokenId) != msg.sender
        ) revert MoodNft__NotOwner();

        if (s_tokenIdToNftState[tokenId] == NftState.HAPPY)
            s_tokenIdToNftState[tokenId] = NftState.SAD;
        else s_tokenIdToNftState[tokenId] = NftState.HAPPY;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(
        uint256 tokenId
    ) public view virtual override returns (string memory) {
        string memory imageURI;
        if (s_tokenIdToNftState[tokenId] == NftState.HAPPY)
            imageURI = s_happySvgImageUri;
        else imageURI = s_sadSvgImageUri;

        return
            string(
                abi.encodePacked(
                    _baseURI(),
                    abi.encodePacked(
                        '{"name":"',
                        name(),
                        '", "description":"An NFT that reflects the mood of the owner, 100% on Chain!"',
                        '"attributes":[{"trait_type": "moodiness", "value": 100}], "image":"',
                        imageURI,
                        '"}'
                    )
                )
            );
    }
}
