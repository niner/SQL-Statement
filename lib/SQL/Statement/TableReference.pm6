use SQL::Statement::TablePrimaryOrJoinedTable;

unit role SQL::Statement::TableReference;

has SQL::Statement::TablePrimaryOrJoinedTable $.table is required;
has $.sample-clause;
