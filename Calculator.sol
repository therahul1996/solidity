// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Calculator {
    uint256 number = 0;

    function add(uint256 _number) public {
        number += _number;
    }

    function substract(uint256 _number) public {
        number -= _number;
    }

    function multiply(uint256 _number) public {
        number *= _number;
    }

    function devide(uint256 _number) public {
        number /= _number;
    }

    function get() public view returns (uint256) {
        return number;
    }
}
