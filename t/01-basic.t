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
        SQL::Statement::Select.new(
            :select-list(
                SQL::Statement::Asterisk.new
            ),
            :table-expression(
                SQL::Statement::TableExpression.new(
                    :from-clause(
                        SQL::Statement::FromClause.new(
                            :table-references(
                                SQL::Statement::TableReference.new(
                                    :table(
                                        SQL::Statement::DerivedTable.new(
                                            :correlation_name<c>,
                                            :subquery(
                                                SQL::Statement::Subquery.new(
                                                    :query(
                                                        SQL::Statement::Select.new(
                                                            :select-list(
                                                                SQL::Statement::Asterisk.new
                                                            ),
                                                            :table-expression(
                                                                SQL::Statement::TableExpression.new(
                                                                    :from-clause(
                                                                        SQL::Statement::FromClause.new(
                                                                            :table-references(
                                                                                SQL::Statement::TableReference.new(
                                                                                    :table(SQL::Statement::TableOrQueryName.new(:name<customers>)),
                                                                                ),
                                                                            )
                                                                        )
                                                                    )
                                                                )
                                                            )
                                                        )
                                                    )
                                                )
                                            )
                                        )
                                    )
                                ),
                            ),
                        )
                    ),
                )
            ),
        )
    ),
    'SELECT * FROM (SELECT * FROM customers) AS c'
);

done-testing;
