//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/fundMe.sol";
import {HelperConfig} from "./helperConfig.s.sol";

contract deployFundMe is Script {
    function run() external returns (FundMe) {
        HelperConfig helperConfig = new HelperConfig(); // new instance of HelperConfig contract
        address ethUsdPricefeed = helperConfig.activeNetworkConfig(); // returns  struct with pricefeed address
        vm.startBroadcast();

        FundMe fundMe = new FundMe(ethUsdPricefeed);

        vm.stopBroadcast();
        return fundMe;
    }
}
