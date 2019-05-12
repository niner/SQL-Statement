use SQL::Statement::NonParenthesizedValueExpressionPrimary;

unit class SQL::Statement::ColumnReference does SQL::Statement::NonParenthesizedValueExpressionPrimary;

has Str $.identifier;
