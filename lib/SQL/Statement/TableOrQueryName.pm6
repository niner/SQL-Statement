use SQL::Statement::TablePrimary;

unit class SQL::Statement::TableOrQueryName does SQL::Statement::TablePrimary;

has $.name is required;
