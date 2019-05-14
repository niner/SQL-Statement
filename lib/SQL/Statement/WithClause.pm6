use SQL::Statement::WithListElement;

unit class SQL::Statement::WithClause;

has Bool $.recursive;
has SQL::Statement::WithListElement @.with-list;
