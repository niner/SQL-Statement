use SQL::Statement::FromClause;
use SQL::Statement::WhereClause;

unit class SQL::Statement::TableExpression;

has SQL::Statement::FromClause $.from-clause is required is rw;
has SQL::Statement::WhereClause $.where-clause is rw;
has $.group-by-clause is rw;
has $.having-clause is rw;
has $.window-clause is rw;
