use v6.c;
unit class SQL::Statement:ver<0.0.1>:auth<cpan:nine>;

use SQL::Generator;
use SQL::Statement::Asterisk;
use SQL::Statement::BooleanTest;
use SQL::Statement::ColumnReference;
use SQL::Statement::ComparisonPredicate;
use SQL::Statement::DerivedTable;
use SQL::Statement::FromClause;
use SQL::Statement::QualifiedJoin;
use SQL::Statement::QuerySpecification;
use SQL::Statement::ScalarSubquery;
use SQL::Statement::Subquery;
use SQL::Statement::TableExpression;
use SQL::Statement::TableOrQueryName;
use SQL::Statement::WhereClause;

multi sub select(Whatever, SQL::Statement::TableExpression :$table-expression) is export {
    SQL::Statement::QuerySpecification.new(
        :select-list(
            SQL::Statement::Asterisk.new
        ),
        :$table-expression,
    )
}

multi sub select(Whatever, SQL::Statement::FromClause :$from-clause) is export {
    SQL::Statement::QuerySpecification.new(
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

multi sub select(Whatever, SQL::Statement::FromClause $from-clause, SQL::Statement::WhereClause $where-clause?) is export {
    SQL::Statement::QuerySpecification.new(
        :select-list(
            SQL::Statement::Asterisk.new
        ),
        :table-expression(
            SQL::Statement::TableExpression.new(
                :$from-clause,
                :$where-clause,
            )
        )
    )
}

multi sub select(SQL::Statement::SelectSublist $select-list, SQL::Statement::FromClause $from-clause, SQL::Statement::WhereClause $where-clause?) is export {
    SQL::Statement::QuerySpecification.new(
        :$select-list,
        :table-expression(
            SQL::Statement::TableExpression.new(
                :$from-clause,
                :$where-clause,
            )
        )
    )
}

multi sub select(*@sublist, SQL::Statement::FromClause :$from, SQL::Statement::WhereClause :$where) is export {
    SQL::Statement::QuerySpecification.new(
        :select-list(SQL::Statement::SelectList.new(:sublist(@sublist.map: {column($_)}))),
        :table-expression(
            SQL::Statement::TableExpression.new(
                :from-clause($from),
                :where-clause($where),
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

multi sub join(SQL::Statement::TableReference $table, SQL::Statement::TableReference $rhs_table, :$type, SQL::Statement::BooleanValueExpression :$on) is export {
    SQL::Statement::TableReference.new(
        :table(
            SQL::Statement::QualifiedJoin.new(
                :join-type($type),
                :table_reference($table),
                :rhs_table_reference($rhs_table),
                :join_specification($on),
            )
        )
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

multi sub scalar_subquery($query) is export {
    SQL::Statement::ScalarSubquery.new(
        :subquery(
            SQL::Statement::Subquery.new(
                :$query
            )
        )
    )
}

multi sub where(SQL::Statement::BooleanValueExpression $search-condition) is export {
    SQL::Statement::WhereClause.new(
        :$search-condition
    )
}

multi sub boolean_test(SQL::Statement::BooleanPrimary $boolean-primary, :$negated = False, :$truth-value) is export {
    SQL::Statement::BooleanTest.new(
        :$boolean-primary,
        :$negated,
        :$truth-value,
    )
}

multi sub where(SQL::Statement::BooleanPrimary $boolean-primary) is export {
    where(boolean_test($boolean-primary))
}

multi sub comparison($a, $op, $b) is export {
    SQL::Statement::ComparisonPredicate.new(:row_value_predicand($a), :comp_op($op), :rhs_row_value_predicand($b))
}

multi sub eq($a, $b) is export {
    SQL::Statement::BooleanTest.new(
        :boolean-primary(
            comparison($a, '=', $b)
        ),
    )
}

multi sub column(SQL::Statement::ColumnReference $column) {
    $column
}

multi sub column(Str $identifier) is export {
    SQL::Statement::ColumnReference.new(
        :$identifier
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
