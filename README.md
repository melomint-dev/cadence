# Cadence

- Contracts:

  - [MeloMint](./contracts/MeloMint.cdc)

- Transactions:

  - [Transactions](./transactions/)

- Scripts:
  - [Scripts](./scripts/)

NOTE: Rest of Scripts and Transactions were updated in Frontend and Backend as per the need.

## Installation

1. Clone the repository
   ```
   git clone git@github.com:melomint-dev/cadence.git
   ```
2. Install the Flow CLI [Link](https://developers.flow.com/tooling/flow-cli/install)

3. Initialize Flow Project

   ```
   flow init
   ```

4. Create a testnet account via CLI

   ```
   flow accounts create
   ```

   - Select Testnet and give your designed name
   - Your account address with name will be added in flow.json along with .pkey (private key) will be generated

5. Add Smart Contract Path in flow.json

   ```
   {
     "contracts": {
       "MeloMint": "./contracts/MeloMint.cdc"
     },
     "networks": {
       ...
     },
     ...
     "deployments": {
       "testnet": {
         "<account name>": [
           "MeloMint"
         ]
       }
     }
   }
   ```

6. Deploy the Smart contract in the testnet account created

   ```
   flow project deploy
   ```

7. To run scripts and transactions, refer these documents
   - [Execute Scripts with CLI](https://developers.flow.com/tooling/flow-cli/execute-scripts)
   - [Send transactions with CLI](https://developers.flow.com/tooling/flow-cli/transactions/send-transactions)
   - NOTE: Dont' forget to add `-n testnet --signer <account-name>` as arguments while running these scripts
