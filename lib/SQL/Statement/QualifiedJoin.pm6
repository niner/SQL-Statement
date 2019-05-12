use SQL::Statement::TableReference;
use SQL::Statement::BooleanValueExpression;
use SQL::Statement::JoinedTable;

unit class SQL::Statement::QualifiedJoin does SQL::Statement::JoinedTable;

has $.join-type;
has SQL::Statement::TableReference $.table_reference;
has SQL::Statement::TableReference $.rhs_table_reference;
has SQL::Statement::BooleanValueExpression $.join_specification;
