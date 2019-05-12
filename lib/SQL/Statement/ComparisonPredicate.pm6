use SQL::Statement::Predicate;

unit class SQL::Statement::ComparisonPredicate does SQL::Statement::Predicate;

has $.row_value_predicand;
has $.comp_op;
has $.rhs_row_value_predicand;
