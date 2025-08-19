// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.28;
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

error MoodNft__NotAuthorized();
error MoodNft__NonExistentToken();

contract MoodNft is ERC721 {
    enum NftState {
        HAPPY,
        SAD
    }

    uint256 private s_tokenCounter;
    string private s_happySvgImageUri;
    string private s_sadSvgImageUri;

    mapping(uint256 => NftState) s_tokenIdToNftState;

    event NftMinted(address owner, uint256 tokenId);
    event MoodFlipped(NftState currentMood, uint256 tokenId);

    modifier validTokenId(uint256 tokenId) {
        if (tokenId >= s_tokenCounter) revert MoodNft__NonExistentToken();
        _;
    }

    constructor(
        string memory happySvg,
        string memory sadSvg
    ) ERC721("MoodNft", "MON") {
        s_happySvgImageUri = happySvg;
        s_sadSvgImageUri = sadSvg;
    }

    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToNftState[s_tokenCounter] = NftState.HAPPY;
        s_tokenCounter++;
        emit NftMinted(msg.sender, s_tokenCounter - 1);
    }

    function flipMood(uint256 tokenId) public validTokenId(tokenId) {
        address owner = _ownerOf(tokenId);
        if (!_isAuthorized(owner, msg.sender, tokenId))
            revert MoodNft__NotAuthorized();

        s_tokenIdToNftState[tokenId] = s_tokenIdToNftState[tokenId] ==
            NftState.HAPPY
            ? NftState.SAD
            : NftState.HAPPY;

        emit MoodFlipped(s_tokenIdToNftState[tokenId], tokenId);
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(
        uint256 tokenId
    )
        public
        view
        virtual
        override
        validTokenId(tokenId)
        returns (string memory)
    {
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
                        '", "description":"An NFT that reflects the mood of the owner, 100% on Chain!", ',
                        '"attributes":[{"trait_type": "moodiness", "value": 100}], "image":"',
                        imageURI,
                        '"}'
                    )
                )
            );
    }
}
