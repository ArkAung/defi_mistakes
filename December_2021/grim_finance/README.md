# Issue

Before-after pattern without reentrency guard.

Before-after pattern is a section of code that checks the vault balance before and after your deposit to figure out how much was actually received by the vault. This helps with transfer-tax tokens where the amount sent does not equal to the amount received.

What happens IF we can do a second deposit while the first deposit is still ongoing?

Let's say you deposit 10 tokens but before you get to the "after" you do another deposit of 10 tokens.

The second deposit will see an amount of 10 in the before-after as nothing else occured here. However, the first deposit sees the increase of its own 10 tokens but also those 10 tokens of the second deposit. The vault therefore thinks it received another 20 tokens.

# Mistake

* No reentrency guard on this kind of pattern
* Giving user the privilege to choose the deposit token (this is super fishy)


# Attack

* Attacker address: 0xDefC385D7038f391Eb0063C2f7C238cFb55b206C
* One of the attacking transactions: [0x19315e5b150d0a83e797203bb9c957ec1fa8a6f404f4f761d970cb29a74a5dd6](https://ftmscan.com/tx/0x19315e5b150d0a83e797203bb9c957ec1fa8a6f404f4f761d970cb29a74a5dd6)

# Steps

1) Grab a Flashloan for XXX & YYY tokens (WBTC-FTM e.g.)
2) Add liquidity on SpiritSwap
3) Mint SPIRIT-LPs
4) call depositFor() in GrimBoostVault with token==ATTACKER, user==ATTACKER
5) Leverage token.safeTransferFrom for re-entrancy
6) goto (4)
7) In the last step on re-entrancy call depositFor() with token==SPIRIT-LP, user==ATTACKER
8) Amount of minted GB-XXX-YYY tokens is increased in every level of re-entrancy
9) Attacker ends up holding huge amount of GB-XXX-YYY tokens
10) Withdraw GB tokens and get more SPIRIT-LP tokens back
11) Remove liquidity and get more XXX and YYY tokens
12) Repay Flashloan
