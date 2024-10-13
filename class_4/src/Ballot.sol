// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ballot {
    struct Voter {
        uint weight; // 权重
        bool voted;  // 是否已经投票
        address delegate; // 被委托人
        uint vote;   // 投给谁
    }

    struct Proposal {
        bytes32 name;   // 简称
        uint voteCount; // 得票数
    }

    address public chairperson;

    mapping(address => Voter) public voters;

    Proposal[] public proposals;

    // 添加时间限制的状态变量
    uint256 public startTime;
    uint256 public endTime;

    /// 创建投票，包含 proposalNames 中的提案
    constructor(bytes32[] memory proposalNames, uint256 _startTime, uint256 _endTime) {
        chairperson = msg.sender;
        voters[chairperson].weight = 1;

        // 设置投票时间窗口
        require(_startTime < _endTime, "Start time must be before end time");
        startTime = _startTime;
        endTime = _endTime;

        for (uint i = 0; i < proposalNames.length; i++) {
            // 提案数组中增加提案对象
            proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
        }
    }

    // 授权 voter 投票
    function giveRightToVote(address voter) external {
        require(msg.sender == chairperson, "Only chairperson can give right to vote.");
        require(!voters[voter].voted, "The voter already voted.");
        require(voters[voter].weight == 0);
        voters[voter].weight = 1;
    }

    // 将投票委托给代理
    function delegate(address to) external {
        Voter storage sender = voters[msg.sender];
        require(!sender.voted, "You already voted.");
        require(to != msg.sender, "Self-delegation is disallowed.");

        while (voters[to].delegate != address(0)) {
            to = voters[to].delegate;

            require(to != msg.sender, "Found loop in delegation.");
        }

        sender.voted = true;
        sender.delegate = to;
        Voter storage delegate_ = voters[to];

        if (delegate_.voted) {
            proposals[delegate_.vote].voteCount += sender.weight;
        } else {
            delegate_.weight += sender.weight;
        }
    }

    // 投票
    function vote(uint proposal) external {
        // 检查当前时间是否在投票时间窗口内
        require(block.timestamp >= startTime, "Voting has not started yet.");
        require(block.timestamp <= endTime, "Voting has already ended.");

        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0, "Has no right to vote.");
        require(!sender.voted, "Already voted.");
        sender.voted = true;
        sender.vote = proposal;

        proposals[proposal].voteCount += sender.weight;
    }

    // 计算获胜提案
    function winningProposal() public view returns (uint winningProposal_) {
        uint winningVoteCount = 0;
        for (uint p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                winningProposal_ = p;
            }
        }
    }

    // 获取获胜提案的名称
    function winnerName() external view returns (bytes32 winnerName_) {
        winnerName_ = proposals[winningProposal()].name;
    }
}

