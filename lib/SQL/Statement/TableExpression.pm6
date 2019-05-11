use SQL::Statement::FromClause;

unit class SQL::Statement::TableExpression;

has SQL::Statement::FromClause $.from-clause is required;
has $.where-clause;
has $.group-by-clause;
has $.having-clause;
has $.window-clause;
