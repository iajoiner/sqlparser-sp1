//! A simple program that takes a sql query as input and parses it using the sqlparser crate.

// These two lines are necessary for the program to properly compile.
//
// Under the hood, we wrap your main function with some extra code so that it behaves properly
// inside the zkVM.
#![no_main]
sp1_zkvm::entrypoint!(main);

use alloy_sol_types::SolType;
use sqlparser_sp1_lib::{parse, PublicValuesStruct};

pub fn main() {
    // Read an input to the program.
    //
    // Behind the scenes, this compiles down to a custom system call which handles reading inputs
    // from the prover.
    let sql = sp1_zkvm::io::read::<String>();

    // Parse the query using a function from the workspace lib crate.
    let ast = parse(&sql);

    // Encode the public values of the program.
    let bytes = PublicValuesStruct::abi_encode(&PublicValuesStruct { sql: sql.into(), ast: ast.into() });

    // Commit to the public values of the program. The final proof will have a commitment to all the
    // bytes that were committed to.
    sp1_zkvm::io::commit_slice(&bytes);
}
