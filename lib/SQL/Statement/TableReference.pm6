use SQL::Statement::TablePrimaryOrJoinedTable;

unit role SQL::Statement::TableReference;

has SQL::Statement::TablePrimaryOrJoinedTable $.table;
has $.sample-clause;
