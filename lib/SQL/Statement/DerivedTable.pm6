use SQL::Statement::Subquery;
use SQL::Statement::TablePrimary;

unit class SQL::Statement::DerivedTable does SQL::Statement::TablePrimary;

has SQL::Statement::Subquery $.subquery;
has $.correlation_name;
