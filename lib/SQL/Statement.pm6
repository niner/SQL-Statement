use v6.c;
unit class SQL::Statement:ver<0.0.1>:auth<cpan:nine>;

use SQL::Generator;
use SQL::Statement::Asterisk;
use SQL::Statement::DerivedTable;
use SQL::Statement::FromClause;
use SQL::Statement::Select;
use SQL::Statement::Subquery;
use SQL::Statement::TableExpression;
use SQL::Statement::TableOrQueryName;

multi sub select(Whatever, SQL::Statement::TableExpression :$table-expression) is export {
    SQL::Statement::Select.new(
        :select-list(
            SQL::Statement::Asterisk.new
        ),
        :$table-expression,
    )
}

multi sub select(Whatever, SQL::Statement::FromClause :$from-clause) is export {
    SQL::Statement::Select.new(
        :select-list(
            SQL::Statement::Asterisk.new
        ),
        :table-expression(
            SQL::Statement::TableExpression.new(
                :$from-clause
            )
        )
    )
}

multi sub select(Whatever, SQL::Statement::FromClause $from-clause) is export {
    SQL::Statement::Select.new(
        :select-list(
            SQL::Statement::Asterisk.new
        ),
        :table-expression(
            SQL::Statement::TableExpression.new(
                :$from-clause
            )
        )
    )
}

sub table(Str $name) is export {
    SQL::Statement::TableReference.new(
        :table(SQL::Statement::TableOrQueryName.new(:$name))
    )
}

multi sub from(SQL::Statement::TablePrimary $table) is export {
    SQL::Statement::FromClause.new(
        :table-references(
            SQL::Statement::TableReference.new(
                :$table
            )
        )
    )
}

multi sub from(Str $table) is export {
    SQL::Statement::FromClause.new(
        :table-references(
            table($table),
        )
    )
}

multi sub from(*@table-references) is export {
    SQL::Statement::FromClause.new(
        :@table-references
    )
}

multi sub subquery($query, :$as) is export {
    SQL::Statement::DerivedTable.new(
        :correlation_name($as),
        :subquery(
            SQL::Statement::Subquery.new(
                :$query
            )
        )
    )
}

=begin pod

=head1 NAME

SQL::Statement - blah blah blah

=head1 SYNOPSIS

=begin code :lang<perl6>

use SQL::Statement;

=end code

=head1 DESCRIPTION

SQL::Statement is ...

=head1 AUTHOR

Stefan Seifert <nine@detonation.org>

=head1 COPYRIGHT AND LICENSE

Copyright 2019 Stefan Seifert

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
