use SQL::Statement::TableOrQueryName;

unit class SQL::Statement::WithListElement;

has SQL::Statement::TableOrQueryName $.query-name;
has $.query-expression;
