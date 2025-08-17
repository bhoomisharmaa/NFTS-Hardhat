// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.27;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract BasicNft is ERC721 {
    uint256 private s_tokenCount;
    mapping(uint256 => string) s_tokenIdToUri;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
        s_tokenCount = 0;
    }

    function mintNft(string memory tokenUri) public {
        s_tokenIdToUri[s_tokenCount] = tokenUri;
        _safeMint(msg.sender, s_tokenCount);
        s_tokenCount++;
    }

    function tokenUri(uint256 tokenId) public returns (string memory) {
        return s_tokenIdToUri[tokenId];
    }

    function tokenCount() public view returns (uint256) {
        return s_tokenCount;
    }
}
