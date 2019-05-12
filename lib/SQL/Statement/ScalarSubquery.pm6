use SQL::Statement::NonParenthesizedValueExpressionPrimary;

unit class SQL::Statement::ScalarSubquery does SQL::Statement::NonParenthesizedValueExpressionPrimary;

has $.subquery;
