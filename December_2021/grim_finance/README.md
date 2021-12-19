# Issue

Before-after pattern without reentrency guard

Before-after pattern is a section of code that checks the vault alance before and after your deposit to figure out how much was actually received by the vault. This helps with transfer-tax tokens where the amount sent does not equal to the amount received.

What happens IF we can do a second deposit while the first deposit is still ongoing?

Let's say you deposit 10 tokens but before you get to the "after" you do another deposit of 10 tokens.

The second deposit will see an amount of 10 in the before-after as nothing else occured here. However, the first deposit sees the increase of its own 10 tokens but also those 10 tokens of the second deposit. The vault therefore thinks it received another 20 tokens.

# Mistake

No reentrency guard on this kind of pattern
Giving user the privilege to choose the deposit token (this is super fishy)
