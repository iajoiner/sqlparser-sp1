use alloy_sol_types::sol;
use sqlparser::{dialect::GenericDialect, parser::Parser};

sol! {
    /// The public values encoded as a struct that can be easily deserialized inside Solidity.
    struct PublicValuesStruct {
        bytes sql;
        bytes ast;
    }
}

/// Parse SQL using normal Rust code.
pub fn parse(sql: &str) -> String {
    let dialect = GenericDialect {}; // or AnsiDialect, or your own dialect ...
    let ast = Parser::parse_sql(&dialect, sql).unwrap();
    format!("{:?}", ast)
}
