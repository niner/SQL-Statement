use SQL::Statement::BooleanFactor;
use SQL::Statement::BooleanPrimary;

unit role SQL::Statement::BooleanTest does SQL::Statement::BooleanFactor;

has SQL::Statement::BooleanPrimary $.boolean-primary;
has Bool $.negated;
has $.truth-value;

