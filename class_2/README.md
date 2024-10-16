@yuuuuuuan ➜ /workspaces/tintinland_solidity/class_2 (main) $ forge build
[⠆] Compiling...
No files changed, compilation skipped
@yuuuuuuan ➜ /workspaces/tintinland_solidity/class_2 (main) $ forge test
[⠊] Compiling...
No files changed, compilation skipped

Ran 3 tests for test/InsertionSort.t.sol:InsertionSortTest
[PASS] testReverseSortedArray() (gas: 15789)
[PASS] testSortArray() (gas: 15180)
[PASS] testSortedArray() (gas: 13519)
Suite result: ok. 3 passed; 0 failed; 0 skipped; finished in 4.92ms (729.93µs CPU time)

Ran 4 tests for test/NftSwap.t.sol:NFTSwapTest
[PASS] testListNFT() (gas: 94987)
[PASS] testPurchaseNFT() (gas: 123644)
[PASS] testRevokeOrder() (gas: 74719)
[PASS] testUpdateOrder() (gas: 98736)
Suite result: ok. 4 passed; 0 failed; 0 skipped; finished in 1.20ms (553.64µs CPU time)

Ran 2 tests for test/Counter.t.sol:CounterTest
[PASS] testFuzz_SetNumber(uint256) (runs: 256, μ: 30821, ~: 31288)
[PASS] test_Increment() (gas: 31303)
Suite result: ok. 2 passed; 0 failed; 0 skipped; finished in 14.90ms (10.59ms CPU time)

Ran 3 test suites in 81.05ms (21.01ms CPU time): 9 tests passed, 0 failed, 0 skipped (9 total tests)

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
