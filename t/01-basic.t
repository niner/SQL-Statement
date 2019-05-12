use v6.c;
use Test;
use SQL::Statement;

use SQL::Generator;
use SQL::Statement::Asterisk;
use SQL::Statement::DerivedTable;
use SQL::Statement::FromClause;
use SQL::Statement::Select;
use SQL::Statement::Subquery;
use SQL::Statement::TableExpression;
use SQL::Statement::TableOrQueryName;

is(
    SQL::Generator.new.generate(
        select(
            *,
            from(
                subquery(
                    select(*, from(table('customers'))),
                    :as<c>
                )
            )
        )
    ),
    'SELECT * FROM (SELECT * FROM customers) AS c'
);

done-testing;

# vim: ft=perl6
