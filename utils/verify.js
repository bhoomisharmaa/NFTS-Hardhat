const { run } = require("hardhat");

const verify = async (address, args) => {
  console.log("Verifying Contract...");
  try {
    await run("verify:verify", {
      address,
      ConstructorArgument: args,
    });
  } catch (error) {
    if (error.message.includes("already been verfied"))
      console.log("Already Verified!");
    else console.log(error.message);
  }
};

module.exports = { verify };
