// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Ballot_2.sol";

contract BallotTest is Test {
    Ballot ballot;
    bytes32[] proposalNames;
    address chairperson;
    address voter1;
    address voter2;

    function setUp() public {
        proposalNames.push("Proposal 1");
        proposalNames.push("Proposal 2");

        uint256 startTime = block.timestamp + 10;
        uint256 endTime = block.timestamp + 100;

        ballot = new Ballot(proposalNames, startTime, endTime);
        chairperson = ballot.chairperson();
        voter1 = address(0x1);
        voter2 = address(0x2);
    }

    // 测试默认投票权重为 1
    function testDefaultVoterWeight() public {
        ballot.giveRightToVote(voter1);

        (uint256 weight, , , ) = ballot.voters(voter1);
        
        assertEq(weight, 1);
    }

    // 测试合约拥有者设置投票权重
    function testSetVoterWeight() public {
        vm.startPrank(chairperson);
        ballot.setVoterWeight(voter1, 5);
        (uint256 weight, , , ) = ballot.voters(voter1);
        assertEq(weight, 5);
        vm.stopPrank();
    }

    /* 测试只有合约拥有者能设置投票权重
    function testOnlyChairpersonCanSetWeight() public {
        vm.expectRevert("Only chairperson can set voter weight.");
        ballot.setVoterWeight(voter1, 5); 
    }*/
    function testOnlyChairpersonCanSetWeight() public {
        // Ensure the test is not called by the chairperson
        vm.prank(voter1);
        
        // Expect a revert with the specific error message
        vm.expectRevert("Only chairperson can set voter weight.");
        ballot.setVoterWeight(voter1, 5); 
    }

    // 测试设置无效的投票权重
    function testSetInvalidWeight() public {
        vm.startPrank(chairperson);
        vm.expectRevert("Weight must be greater than zero.");
        ballot.setVoterWeight(voter1, 0);
        vm.stopPrank();
    }

    // 测试在投票时使用不同权重
    function testVoteWithDifferentWeights() public {
        vm.startPrank(chairperson);
        ballot.giveRightToVote(voter1);
        ballot.giveRightToVote(voter2);

        ballot.setVoterWeight(voter1, 5);
        ballot.setVoterWeight(voter2, 3);
        vm.stopPrank();

        // 模拟投票窗口内
        vm.warp(block.timestamp + 20);

        vm.prank(voter1);
        ballot.vote(0); // voter1 投给 Proposal 1

        vm.prank(voter2);
        ballot.vote(0); // voter2 也投给 Proposal 1

        // 解构提案以获取投票数量
        ( , uint256 voteCount) = ballot.proposals(0); // 仅解构出 voteCount

        // 检查 Proposal 1 的投票数
        assertEq(voteCount, 8); // 5 (voter1) + 3 (voter2)
    }
}
