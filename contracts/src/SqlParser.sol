// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ISP1Verifier} from "@sp1-contracts/ISP1Verifier.sol";

struct PublicValuesStruct {
    bytes sql;
    bytes ast;
}

/// @title Fibonacci.
/// @author Succinct Labs
/// @notice This contract implements a simple example of verifying the proof of a parsing a
///         query.
contract SqlParser {
    /// @notice The address of the SP1 verifier contract.
    /// @dev This can either be a specific SP1Verifier for a specific version, or the
    ///      SP1VerifierGateway which can be used to verify proofs for any version of SP1.
    ///      For the list of supported verifiers on each chain, see:
    ///      https://github.com/succinctlabs/sp1-contracts/tree/main/contracts/deployments
    address public verifier;

    /// @notice The verification key for the sqlparser program.
    bytes32 public sqlParserProgramVKey;

    constructor(address _verifier, bytes32 _sqlParserProgramVKey) {
        verifier = _verifier;
        sqlParserProgramVKey = _sqlParserProgramVKey;
    }

    /// @notice The entrypoint for verifying the proof of a SQL query.
    /// @param _proofBytes The encoded proof.
    /// @param _publicValues The encoded public values.
    function verifySqlParserProof(bytes calldata _publicValues, bytes calldata _proofBytes)
        public
        view
        returns (bytes, bytes)
    {
        ISP1Verifier(verifier).verifyProof(fibonacciProgramVKey, _publicValues, _proofBytes);
        PublicValuesStruct memory publicValues = abi.decode(_publicValues, (PublicValuesStruct));
        return (publicValues.sql, publicValues.ast);
    }
}
