unit class SQL::Generator;

use SQL::Statement::Asterisk;
use SQL::Statement::BooleanTest;
use SQL::Statement::ColumnReference;
use SQL::Statement::ComparisonPredicate;
use SQL::Statement::DerivedTable;
use SQL::Statement::FromClause;
use SQL::Statement::QualifiedJoin;
use SQL::Statement::QueryExpression;
use SQL::Statement::QuerySpecification;
use SQL::Statement::ScalarSubquery;
use SQL::Statement::Subquery;
use SQL::Statement::TableExpression;
use SQL::Statement::TableOrQueryName;
use SQL::Statement::WhereClause;

method search(SQL::Statement::QuerySpecification $select) {
    my @*BINDVALUES;
    my $statement = self.generate($select);
    return (:$statement, bind_values => @*BINDVALUES).hash
}

multi method generate(SQL::Statement::QueryExpression $query-expression) {
    ($query-expression.with-clause ?? $.generate($query-expression.with-clause) ~ ' ' !! '')
    ~ $.generate($query-expression.query-expression-body)
}
multi method generate(SQL::Statement::SelectList $select-list) {
    $select-list.sublist.map({$.generate($_)}).join: ', '
}
multi method generate(SQL::Statement::QuerySpecification $select) {
    my $table-expression = $.generate($select.table-expression);
    "SELECT $.generate($select.select-list)" ~ ($table-expression ?? " $table-expression" !! '')
}
multi method generate(SQL::Statement::Asterisk $asterisk) {
    '*'
}
multi method generate(SQL::Statement::TableExpression $e) {
    ($e.from-clause, $e.where-clause, $e.group-by-clause, $e.having-clause, $e.window-clause).grep(*.defined).map({self.generate($_)}).join(' ')
}
multi method generate(SQL::Statement::FromClause $from) {
    'FROM ' ~ $from.table-references.map({self.generate($_)}).join(', ');
}
multi method generate(SQL::Statement::TableReference $table) {
    $.generate($table.table) ~ ($table.sample-clause ?? ' ' ~ self.generate($table.sample-clause) !! '')
}
multi method generate(SQL::Statement::DerivedTable $table) {
    $.generate($table.subquery) ~ ($table.correlation_name ?? " AS $table.correlation_name()" !! '')
}
multi method generate(SQL::Statement::TableOrQueryName $name) {
    $name.name
}
multi method generate(SQL::Statement::Subquery $table) {
    '(' ~ self.generate($table.query) ~ ')'
}
multi method generate(SQL::Statement::WhereClause $where) {
    "WHERE $.generate($where.search-condition)";
}
multi method generate(SQL::Statement::BooleanTest $test) {
    $.generate($test.boolean-primary)
}
multi method generate(SQL::Statement::ComparisonPredicate $test) {
    "$.generate($test.row_value_predicand()) $test.comp_op() $.generate($test.rhs_row_value_predicand())"
}
multi method generate(SQL::Statement::ScalarSubquery $subquery) {
    $.generate($subquery.subquery)
}
multi method generate(SQL::Statement::ColumnReference $column) {
    $column.identifier
}
multi method generate(SQL::Statement::QualifiedJoin $join) {
    my $sql = $.generate($join.table_reference);
    $sql ~= " $join.join-type.uc()" if $join.join-type;
    $sql ~= " JOIN $.generate($join.rhs_table_reference) ON $.generate($join.join_specification)";
    $sql
}
multi method generate(SQL::Statement::WithListElement $with-list-element) {
    $.generate($with-list-element.query-name) ~ ' AS (' ~ $.generate($with-list-element.query-expression) ~ ')'
}
multi method generate(SQL::Statement::WithClause $with-clause) {
    'WITH ' ~ ($with-clause.recursive ?? 'RECURSIVE ' !! '') ~ $with-clause.with-list.map({$.generate($_)}).join(', ')
}
multi method generate(Str $value) {
    @*BINDVALUES.push: $value if defined @*BINDVALUES;
    '?'
}
multi method generate(Int $value) {
    @*BINDVALUES.push: $value if defined @*BINDVALUES;
    '?'
}
