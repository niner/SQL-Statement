use SQL::Statement::TablePrimaryOrJoinedTable;

unit class SQL::Statement::TableReference;

has SQL::Statement::TablePrimaryOrJoinedTable $.table is required;
has $.sample-clause;
