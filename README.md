# coding-interview

## Assignment Description

This project contains an automation script to convert the move type to TypeScript types for further processing in Maven-SDK. The script converts the following move type:

```
// move type
struct CreateSigner {
    address: address,
}
```

into the following TypeScript type:

```
// TS type
type CreateSigner {
    address: SuiAddress,
}
```

### Scope

The data conversion works for all data types in ./move/operations/*.move. A generic data conversion for move types is not within the scope of this project.

### How to get ABI

The ABI of the move structure can be obtained from deployed smart contracts on chain. Please refer to `src/index.ts` for details.


## Getting Started
### Prerequisites
Before running the script, make sure you have Node.js and Yarn installed on your system.

### Installation
To install the dependencies, run the following command:

```
yarn install
```

### Usage 

To run the script, execute the following command:

```
yarn start
```

This will convert all move types in the ./move/operations/*.move directory to TypeScript types.

### License
This project is licensed under the MIT License.
