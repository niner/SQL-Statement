use SQL::Statement::TableReference;

unit class SQL::Statement::FromClause;

has SQL::Statement::TableReference @.table-references is required;
