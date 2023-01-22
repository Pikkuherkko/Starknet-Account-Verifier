// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

import "../interfaces/IStarknetCore.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Verifier_L1 is Ownable {
    IStarknetCore private starknetCore;
    uint256 private verifier_L2;
    uint256 private selector;

    event messageSentToStarkNet(uint256 l2_user);

    mapping(address => uint256) public l2_address;

    constructor(address _starknetCore) {
        starknetCore = IStarknetCore(_starknetCore);
    } 

    function setSelector(uint256 _selector) external onlyOwner {
        selector = _selector;
    }

    function setL2Verifier(uint256 _l2_verifier_contract) external onlyOwner {
        verifier_L2 = _l2_verifier_contract;
    }

    function verifyOnL2(uint256 _l2_user) external {
        uint256[] memory payload = new uint256[](2);
        payload[0] = uint256(uint160(msg.sender));
        payload[1] = _l2_user;
        starknetCore.sendMessageToL2(
            verifier_L2,
            selector,
            payload
        );
        l2_address[msg.sender] = _l2_user;
        emit messageSentToStarkNet(_l2_user);
    } 

    function getL2Address(address L1_address) public view returns (uint256) {
        return l2_address[L1_address];
    }
}