use SQL::Statement::QueryExpressionBody;
use SQL::Statement::WithClause;

unit class SQL::Statement::QueryExpression;

has SQL::Statement::WithClause $.with-clause;
has SQL::Statement::QueryExpressionBody $.query-expression-body;
