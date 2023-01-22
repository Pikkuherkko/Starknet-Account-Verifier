# Starknet-Account-Verifier
Connecting user's L1 address to L2 address on Starknet with messaging bridge.

## Idea

On Ethereum, you can claim that a certain Starknet account belongs to your L1 account. On Starknet, you can verify the claim so that indeed, that L1 account is the owner of your Starknet account.

After this, you can check corresponding Starknet account on L1 and corresponding L1 account on Starknet.

## Flow: 
1. Call ```VerifyOnL2``` on Verifier_L1 on Ethereum 
2. Wait a minute
3. Check ```claimed_l2_address``` on Verifier_L2 on Starknet
4. Call ```confirm_verification```on Verifier_L2 on Starknet
