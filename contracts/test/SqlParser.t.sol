// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {stdJson} from "forge-std/StdJson.sol";
import {SqlParser} from "../src/SqlParser.sol";
import {SP1VerifierGateway} from "@sp1-contracts/SP1VerifierGateway.sol";

struct SP1ProofFixtureJson {
    bytes sql;
    bytes ast;
    bytes proof;
    bytes publicValues;
    bytes32 vkey;
}

contract SqlParserTest is Test {
    using stdJson for string;

    address verifier;
    SqlParser public sqlparser;

    function loadFixture() public view returns (SP1ProofFixtureJson memory) {
        string memory root = vm.projectRoot();
        string memory path = string.concat(root, "/src/fixtures/fixture.json");
        string memory json = vm.readFile(path);
        bytes memory jsonBytes = json.parseRaw(".");
        return abi.decode(jsonBytes, (SP1ProofFixtureJson));
    }

    function setUp() public {
        SP1ProofFixtureJson memory fixture = loadFixture();

        verifier = address(new SP1VerifierGateway(address(1)));
        sqlparser = new SqlParser(verifier, fixture.vkey);
    }

    function test_ValidSqlParserProof() public {
        SP1ProofFixtureJson memory fixture = loadFixture();

        vm.mockCall(verifier, abi.encodeWithSelector(SP1VerifierGateway.verifyProof.selector), abi.encode(true));

        (bytes sql, bytes ast) = fibonacci.verifySqlParserProof(fixture.publicValues, fixture.proof);
        assert(sql == fixture.sql);
        assert(ast == fixture.ast);
    }

    function testFail_InvalidSqlParserProof() public view {
        SP1ProofFixtureJson memory fixture = loadFixture();

        // Create a fake proof.
        bytes memory fakeProof = new bytes(fixture.proof.length);

        sqlparser.verifySqlParserProof(fixture.publicValues, fakeProof);
    }
}
