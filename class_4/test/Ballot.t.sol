// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Ballot.sol";

contract BallotTest is Test {
    Ballot ballot;
    bytes32[] proposalNames;

    function setUp() public {
        proposalNames.push("Proposal 1");
        proposalNames.push("Proposal 2");

        // 假设开始时间为当前时间 + 10 秒，结束时间为当前时间 + 100 秒
        uint256 startTime = block.timestamp + 10;
        uint256 endTime = block.timestamp + 100;

        ballot = new Ballot(proposalNames, startTime, endTime);
    }

    /* 测试在投票开始时间前投票，应该失败
    function testVoteBeforeStartTime() public {
        vm.warp(block.timestamp + 5); // 模拟当前时间为开始时间前
        ballot.giveRightToVote(address(this));
        vm.expectRevert("Voting has not started yet.");
        ballot.vote(0);
    }*/
    //[FAIL: EvmError: Revert] testVoteBeforeStartTime() (gas: 14978)
    function testVoteBeforeStartTime() public {
        // Simulate time passing, but ensure it's still before the voting start time
        vm.warp(block.timestamp + 5); // This moves time forward by 5 seconds
        
        // Give the current address the right to vote
        ballot.giveRightToVote(address(this));
        
        // Expect a revert when trying to vote before the start time
        vm.expectRevert("Voting has not started yet.");
        ballot.vote(0);
    }
    
    // 测试在投票时间窗口内投票，应该成功
    function testVoteDuringVotingPeriod() public {
        vm.warp(block.timestamp + 20); // 模拟当前时间为投票窗口内
        ballot.giveRightToVote(address(this));
        ballot.vote(0);

        uint256 winningProposal = ballot.winningProposal();
        assertEq(winningProposal, 0);
    }

    // 测试在投票结束时间后投票，应该失败
    function testVoteAfterEndTime() public {
        vm.warp(block.timestamp + 110); // 模拟当前时间为投票结束后
        ballot.giveRightToVote(address(this));
        vm.expectRevert("Voting has already ended.");
        ballot.vote(0);
    }
}

