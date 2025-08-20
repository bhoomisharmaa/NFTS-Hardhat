//SPDX-License-Identifier: MIT
pragma solidity 0.8.28;
import {Test} from "forge-std/Test.sol";
import {MoodNft, MoodNft__NotAuthorized, MoodNft__NonExistentToken} from "./MoodNft.sol";

contract MoodNftTest is Test {
    MoodNft private moodNft;
    address private constant ALICE = address(0x123);
    string private constant HAPPY_SVG_URI =
        "PHN2ZyB2aWV3Qm94PSIwIDAgMjAwIDIwMCIgd2lkdGg9IjQwMCIgIGhlaWdodD0iNDAwIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPg0KICA8Y2lyY2xlIGN4PSIxMDAiIGN5PSIxMDAiIGZpbGw9InllbGxvdyIgcj0iNzgiIHN0cm9rZT0iYmxhY2siIHN0cm9rZS13aWR0aD0iMyIvPg0KICA8ZyBjbGFzcz0iZXllcyI+DQogICAgPGNpcmNsZSBjeD0iNzAiIGN5PSI4MiIgcj0iMTIiLz4NCiAgICA8Y2lyY2xlIGN4PSIxMjciIGN5PSI4MiIgcj0iMTIiLz4NCiAgPC9nPg0KICA8cGF0aCBkPSJtMTM2LjgxIDExNi41M2MuNjkgMjYuMTctNjQuMTEgNDItODEuNTItLjczIiBzdHlsZT0iZmlsbDpub25lOyBzdHJva2U6IGJsYWNrOyBzdHJva2Utd2lkdGg6IDM7Ii8+DQo8L3N2Zz4=";
    string private constant SAD_SVG_URI =
        "PHN2ZyB3aWR0aD0iMTAyNHB4IiBoZWlnaHQ9IjEwMjRweCIgdmlld0JveD0iMCAwIDEwMjQgMTAyNCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4NCiAgPHBhdGggZmlsbD0iIzMzMyIgZD0iTTUxMiA2NEMyNjQuNiA2NCA2NCAyNjQuNiA2NCA1MTJzMjAwLjYgNDQ4IDQ0OCA0NDggNDQ4LTIwMC42IDQ0OC00NDhTNzU5LjQgNjQgNTEyIDY0em0wIDgyMGMtMjA1LjQgMC0zNzItMTY2LjYtMzcyLTM3MnMxNjYuNi0zNzIgMzcyLTM3MiAzNzIgMTY2LjYgMzcyIDM3Mi0xNjYuNiAzNzItMzcyIDM3MnoiLz4NCiAgPHBhdGggZmlsbD0iI0U2RTZFNiIgZD0iTTUxMiAxNDBjLTIwNS40IDAtMzcyIDE2Ni42LTM3MiAzNzJzMTY2LjYgMzcyIDM3MiAzNzIgMzcyLTE2Ni42IDM3Mi0zNzItMTY2LjYtMzcyLTM3Mi0zNzJ6TTI4OCA0MjFhNDguMDEgNDguMDEgMCAwIDEgOTYgMCA0OC4wMSA0OC4wMSAwIDAgMS05NiAwem0zNzYgMjcyaC00OC4xYy00LjIgMC03LjgtMy4yLTguMS03LjRDNjA0IDYzNi4xIDU2Mi41IDU5NyA1MTIgNTk3cy05Mi4xIDM5LjEtOTUuOCA4OC42Yy0uMyA0LjItMy45IDcuNC04LjEgNy40SDM2MGE4IDggMCAwIDEtOC04LjRjNC40LTg0LjMgNzQuNS0xNTEuNiAxNjAtMTUxLjZzMTU1LjYgNjcuMyAxNjAgMTUxLjZhOCA4IDAgMCAxLTggOC40em0yNC0yMjRhNDguMDEgNDguMDEgMCAwIDEgMC05NiA0OC4wMSA0OC4wMSAwIDAgMSAwIDk2eiIvPg0KICA8cGF0aCBmaWxsPSIjMzMzIiBkPSJNMjg4IDQyMWE0OCA0OCAwIDEgMCA5NiAwIDQ4IDQ4IDAgMSAwLTk2IDB6bTIyNCAxMTJjLTg1LjUgMC0xNTUuNiA2Ny4zLTE2MCAxNTEuNmE4IDggMCAwIDAgOCA4LjRoNDguMWM0LjIgMCA3LjgtMy4yIDguMS03LjQgMy43LTQ5LjUgNDUuMy04OC42IDk1LjgtODguNnM5MiAzOS4xIDk1LjggODguNmMuMyA0LjIgMy45IDcuNCA4LjEgNy40SDY2NGE4IDggMCAwIDAgOC04LjRDNjY3LjYgNjAwLjMgNTk3LjUgNTMzIDUxMiA1MzN6bTEyOC0xMTJhNDggNDggMCAxIDAgOTYgMCA0OCA0OCAwIDEgMC05NiAweiIvPg0KPC9zdmc+";

    function setUp() public {
        moodNft = new MoodNft(HAPPY_SVG_URI, SAD_SVG_URI);
    }

    // === mintNft() tests ===
    function mintForALICE() private {
        vm.prank(ALICE);
        moodNft.mintNft();
    }

    function testConstructorInitializesValue() public view {
        assertEq(
            moodNft.happySvgImageUri(),
            HAPPY_SVG_URI,
            "Svg URI should match the input"
        );
        assertEq(
            moodNft.sadSvgImageUri(),
            SAD_SVG_URI,
            "Svg URI should match the input"
        );
    }

    function testOwnerOfMintedNftIsAlice() public {
        mintForALICE();
        assertEq(
            moodNft.ownerOf(0),
            ALICE,
            "Owner of minted NFT should be ALICE"
        );
    }

    function testCanMintAndHaveBalance() public {
        mintForALICE();
        assertEq(moodNft.balanceOf(ALICE), 1, "ALICE's balacnce should be 1");
    }

    function testNftStateIsSetToHappy() public {
        mintForALICE();
        assertEq(
            uint(moodNft.currentNftState(0)),
            uint(MoodNft.NftState.HAPPY),
            "Current NFT state should be HAPPY (0)"
        );
    }

    function testTokenCounterIsIncremented() public {
        mintForALICE();
        assertEq(
            moodNft.tokenCounter(),
            1,
            "Token count should increment after mint"
        );
    }

    function testMintNftEmitsEvent() public {
        vm.prank(ALICE);
        vm.expectEmit(address(moodNft));
        emit MoodNft.NftMinted(ALICE, 0);
        moodNft.mintNft();
    }

    // === flipMood() tests ===
    function testRevertsWhenTokenIdIsInvalid() public {
        vm.expectRevert(MoodNft__NonExistentToken.selector);
        moodNft.flipMood(9999);
    }

    function testRevertsWhenOwnerIsNotTheCaller() public {
        address Bob = address(0x246);
        mintForALICE();

        vm.expectRevert(MoodNft__NotAuthorized.selector);
        vm.prank(Bob);

        moodNft.flipMood(0);
    }

    function testFlipsTheMood() public {
        mintForALICE();
        uint256 prevState = uint256(moodNft.currentNftState(0));
        vm.prank(ALICE);
        moodNft.flipMood(0);
        uint256 currentState = uint256(moodNft.currentNftState(0));

        assertNotEq(
            prevState,
            currentState,
            "Previous state should not be equal to current state after flipping"
        );
    }

    function testFlipMoodEmitsEvent() public {
        mintForALICE();
        vm.prank(ALICE);
        vm.expectEmit(address(moodNft));
        emit MoodNft.MoodFlipped(MoodNft.NftState.SAD, 0);
        moodNft.flipMood(0);
    }
}
