import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("BasicNftModule", (m) => {
  const basicNft = m.contract("BasicNft", ["Doggie", "DOG"]);

  m.call(basicNft, "mintNft", [
    "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json",
  ]);
  return { basicNft };
});
