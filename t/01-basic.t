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

# simple predicate
is(
    SQL::Generator.new.generate(
        select(
            *,
            from('customers'),
            where(boolean_test(comparison(column('id'), '=', '1'))),
        )
    ),
    'SELECT * FROM customers WHERE id = ?'
);

# subquery in comparison
is(
    SQL::Generator.new.generate(
        select(
            *,
            from('customers'),
            where(
                boolean_test(
                    comparison(
                        column('id'),
                        '=',
                        scalar_subquery(
                            select(*, from(table('customers'))),
                        )
                    )
                )
            ),
        )
    ),
    'SELECT * FROM customers WHERE id = (SELECT * FROM customers)',
);

# composing queries:
{
    my ($query, $subquery) = select(*, from(table('customers'))) xx 2;
    $query .= where(eq(column('id'), scalar_subquery($subquery)));
    is(
        SQL::Generator.new.generate($query),
        'SELECT * FROM customers WHERE id = (SELECT * FROM customers)',
    );
}

{
    my ($query, $subquery) = select(column('id'), from(table('customers'))) xx 2;
    $query .= where(eq(column('id'), scalar_subquery($subquery)));
    is(
        SQL::Generator.new.generate($query),
        'SELECT id FROM customers WHERE id = (SELECT id FROM customers)',
    );
}

{
    is(
        SQL::Generator.new.generate(
            select(
                *,
                from(
                    join(
                        :type<left>,
                        table('customers'),
                        table('countries'),
                        :on(
                            eq(column('customers.country_id'), column('countries.id'))
                        )
                    ),
                )
            )
        ),
        'SELECT * FROM customers LEFT JOIN countries ON customers.country_id = countries.id',
    );
}

role SQL::Statement::Reference {
    has $.references;
}

role SQL::Table[Str $name] does SQL::Statement::TableReference {
    method table() {
        SQL::Statement::TableOrQueryName.new: :$name
    }

    method sample-clause() {
    }

    method join(Str $attribute) {
        SQL::Statement::TableReference.new(
            :table(
                SQL::Statement::QualifiedJoin.new(
                    :table_reference(self),
                    :rhs_table_reference(self.^get_attribute_for_usage('$!' ~ $attribute).references),
                    :join_specification(
                        eq(column('customers.country_id'), column('countries.id'))
                    ),
                )
            )
        )
    }
}

multi trait_mod:<is>(Attribute $attr, SQL::Statement::TableReference :$references!) is export {
    $attr does SQL::Statement::Reference(:$references)
}

class Country does SQL::Table['countries'] {
    has $.id;
}

class Customer does SQL::Table['customers'] {
    has $.country is references(Country);
}

{
    is(
        SQL::Generator.new.generate(
            select(
                *,
                from(
                    Customer.join('country')
                )
            )
        ),
        'SELECT * FROM customers JOIN countries ON customers.country_id = countries.id',
    );
}

{
    is(
        SQL::Generator.new.generate(
            select(
                column('id'),
                column('name'),
                :from(from(
                    Customer.join('country')
                ))
            )
        ),
        'SELECT id, name FROM customers JOIN countries ON customers.country_id = countries.id',
    );
}

{
    is(
        SQL::Generator.new.generate(
            select(
                'id',
                'name',
                :from(from(
                    Customer.join('country')
                ))
            )
        ),
        'SELECT id, name FROM customers JOIN countries ON customers.country_id = countries.id',
    );
}

done-testing;

# vim: ft=perl6
