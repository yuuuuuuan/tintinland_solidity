// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";  // 导入 Foundry 测试库
import {InsertionSort} from "../src/InsertionSort.sol";  // 导入待测试的合约

contract InsertionSortTest is Test {
    InsertionSort public sorter;  // 定义插入排序合约实例

    // 在每次测试开始时运行，初始化排序合约实例
    function setUp() public {
        sorter = new InsertionSort();
    }

    // 测试一个包含无序数字的数组是否正确排序
    function testSortArray() public {
        // 正确的数组初始化
        uint[] memory inputArray = new uint[](4);  // 创建一个长度为4的数组
        inputArray[0] = 2;
        inputArray[1] = 5;
        inputArray[2] = 3;
        inputArray[3] = 1;

        // 调用排序函数
        uint[] memory sortedArray = sorter.insertionSort(inputArray);

        // 验证排序结果
        assertEq(sortedArray[0], 1);
        assertEq(sortedArray[1], 2);
        assertEq(sortedArray[2], 3);
        assertEq(sortedArray[3], 5);
    }

    // 测试空数组
//    function testEmptyArray() public {
//        // 初始化空数组
//        uint[] memory emptyArray = new uint[](0);  // 创建长度为0的数组
//        uint[] memory sortedArray = sorter.insertionSort(emptyArray);

        // 验证空数组排序后依旧为空
//        assertEq(sortedArray.length, 0);
//    }

    // 测试已排序数组
    function testSortedArray() public {
        // 初始化已排序数组
        uint[] memory inputArray = new uint[](4);
        inputArray[0] = 1;
        inputArray[1] = 2;
        inputArray[2] = 3;
        inputArray[3] = 4;

        // 调用排序函数
        uint[] memory sortedArray = sorter.insertionSort(inputArray);

        // 验证排序后是否保持不变
        assertEq(sortedArray[0], 1);
        assertEq(sortedArray[1], 2);
        assertEq(sortedArray[2], 3);
        assertEq(sortedArray[3], 4);
    }

    // 测试逆序数组
    function testReverseSortedArray() public {
        // 初始化逆序数组
        uint[] memory inputArray = new uint[](4);
        inputArray[0] = 5;
        inputArray[1] = 4;
        inputArray[2] = 3;
        inputArray[3] = 2;

        // 调用排序函数
        uint[] memory sortedArray = sorter.insertionSort(inputArray);

        // 验证排序结果
        assertEq(sortedArray[0], 2);
        assertEq(sortedArray[1], 3);
        assertEq(sortedArray[2], 4);
        assertEq(sortedArray[3], 5);
    }
}

