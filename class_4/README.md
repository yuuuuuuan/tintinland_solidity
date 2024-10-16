@yuuuuuuan ➜ /workspaces/tintinland_solidity/class_4 (main) $ forge build
[⠢] Compiling...
No files changed, compilation skipped
@yuuuuuuan ➜ /workspaces/tintinland_solidity/class_4 (main) $ forge test
[⠊] Compiling...
No files changed, compilation skipped

Ran 3 tests for test/Ballot.t.sol:BallotTest
[FAIL: EvmError: Revert] testVoteAfterEndTime() (gas: 15001)
[FAIL: EvmError: Revert] testVoteBeforeStartTime() (gas: 14978)
[FAIL: EvmError: Revert] testVoteDuringVotingPeriod() (gas: 15024)
Suite result: FAILED. 0 passed; 3 failed; 0 skipped; finished in 508.60µs (138.44µs CPU time)

Ran 5 tests for test/Ballot_2.t.sol:BallotTest
[PASS] testDefaultVoterWeight() (gas: 40981)
[PASS] testOnlyChairpersonCanSetWeight() (gas: 13369)
[PASS] testSetInvalidWeight() (gas: 15785)
[PASS] testSetVoterWeight() (gas: 43543)
[PASS] testVoteWithDifferentWeights() (gas: 151377)
Suite result: ok. 5 passed; 0 failed; 0 skipped; finished in 569.32µs (314.25µs CPU time)

Ran 2 tests for test/Counter.t.sol:CounterTest
[PASS] testFuzz_SetNumber(uint256) (runs: 256, μ: 30899, ~: 31288)
[PASS] test_Increment() (gas: 31303)
Suite result: ok. 2 passed; 0 failed; 0 skipped; finished in 9.42ms (9.37ms CPU time)

Ran 3 test suites in 15.06ms (10.49ms CPU time): 7 tests passed, 3 failed, 0 skipped (10 total tests)

Failing tests:
Encountered 3 failing tests in test/Ballot.t.sol:BallotTest
[FAIL: EvmError: Revert] testVoteAfterEndTime() (gas: 15001)
[FAIL: EvmError: Revert] testVoteBeforeStartTime() (gas: 14978)
[FAIL: EvmError: Revert] testVoteDuringVotingPeriod() (gas: 15024)

Encountered a total of 3 failing tests, 7 tests succeeded

## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
