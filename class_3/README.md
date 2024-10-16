@yuuuuuuan ➜ /workspaces/tintinland_solidity/class_3 (main) $ forge build
[⠒] Compiling...
No files changed, compilation skipped
@yuuuuuuan ➜ /workspaces/tintinland_solidity/class_3 (main) $ forge test
[⠊] Compiling...
No files changed, compilation skipped

Ran 4 tests for test/AMMpool.t.sol:AMMPoolTest
[PASS] testAddLiquidity() (gas: 148650)
[PASS] testRemoveLiquidity() (gas: 161552)
[PASS] testSwapTokenForWETH() (gas: 188658)
[PASS] testSwapWETHForToken() (gas: 188600)
Suite result: ok. 4 passed; 0 failed; 0 skipped; finished in 1.58ms (1.03ms CPU time)

Ran 3 tests for test/WETH.t.sol:WETHTest
[PASS] testDeposit() (gas: 67124)
[PASS] testTransfer() (gas: 97764)
[PASS] testWithdraw() (gas: 82040)
Suite result: ok. 3 passed; 0 failed; 0 skipped; finished in 528.74µs (284.14µs CPU time)

Ran 2 tests for test/Counter.t.sol:CounterTest
[PASS] testFuzz_SetNumber(uint256) (runs: 256, μ: 30821, ~: 31288)
[PASS] test_Increment() (gas: 31303)
Suite result: ok. 2 passed; 0 failed; 0 skipped; finished in 10.21ms (10.12ms CPU time)

Ran 3 test suites in 14.48ms (12.32ms CPU time): 9 tests passed, 0 failed, 0 skipped (9 total tests)

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
