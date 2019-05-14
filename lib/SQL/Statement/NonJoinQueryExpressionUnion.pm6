use SQL::Statement::NonJoinQueryExpression;
use SQL::Statement::QueryExpressionBody;
use SQL::Statement::QueryTerm;

unit class SQL::Statement::NonJoinQueryExpressionUnion does SQL::Statement::NonJoinQueryExpression;

has SQL::Statement::QueryExpressionBody $.query-expression-body;
has SQL::Statement::QueryTerm $.query-term;
