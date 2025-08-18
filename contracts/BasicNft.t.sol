// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;
import {Test} from "forge-std/Test.sol";
import {BasicNft} from "./BasicNft.sol";

contract BasicNftTest is Test {
    BasicNft private s_basicNft;
    address private constant ALICE = address(0x123);

    function setUp() public {
        s_basicNft = new BasicNft("Doggie", "DOG");
    }

    function testConstructorInitializesValue() public view {
        assertEq(
            s_basicNft.tokenCount(),
            0,
            "tokenCount should initialize to 0"
        );

        assertEq(
            s_basicNft.name(),
            "Doggie",
            "Token name should match the input"
        );
        assertEq(
            s_basicNft.symbol(),
            "DOG",
            "Token symbol should match the input"
        );
    }

    function testMintNft(string memory tokenUri) public {
        vm.assume(bytes(tokenUri).length > 0);
        vm.prank(ALICE);
        s_basicNft.mintNft(tokenUri);

        assertEq(s_basicNft.ownerOf(0), ALICE, "Owner should be ALICE");
        assertEq(
            s_basicNft.tokenUri(0),
            tokenUri,
            "Token URI should match the input"
        );
        assertEq(
            s_basicNft.tokenCount(),
            1,
            "Token count should increment after mint"
        );
    }
}
