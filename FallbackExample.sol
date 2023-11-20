// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract FallbackExample {
    uint256 public result;

    receive() external payable {
        result = 1;
    }

    fallback() external payable {
        result = 2;
    }

//Which function is called, fallback() or receive()?

//            send Ether
//                |
//          msg.data is empty?
//               / \
//             yes  no
//             /     \
// receive() exists?  fallback()
//          /   \
//         yes   no
//         /      \
//     receive()   fallback()
//     */
}