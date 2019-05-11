use SQL::Statement::SelectList;
use SQL::Statement::TableExpression;

unit class SQL::Statement::Select;

has SQL::Statement::SelectList $.select-list is required;
has SQL::Statement::TableExpression $.table-expression is required;
