// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Oracle {
    mapping(address => bool) public isNode;
    address[] public nodes;

    mapping(bytes32 => uint256) public prices;

    function registerNode() external {
        require(!isNode[msg.sender]);
        isNode[msg.sender] = true;
        nodes.push(msg.sender);
    }

    function unregisterNode() external {
        require(isNode[msg.sender]);
        isNode[msg.sender] = false;
        uint256 length = nodes.length;
        for (uint256 i = 0; i < length; i++) {
            if (nodes[i] == msg.sender) {
                nodes[i] = nodes[length - 1];
                nodes.pop();
                break;
            }
        }
    }

    function setPrice(bytes32 asset, uint256 price) external {
        require(isNode[msg.sender]);
        prices[asset] = price;
    }

    function quorum() public view returns (uint256) {
        uint256 count = nodes.length;
        if (count == 0) {
            return 0;
        }
        return (count * 2) / 3 + 1;
    }
}
