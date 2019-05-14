use SQL::Statement::SelectList;
use SQL::Statement::SimpleTable;
use SQL::Statement::TableExpression;
use SQL::Statement::WhereClause;

unit class SQL::Statement::QuerySpecification does SQL::Statement::SimpleTable;

has SQL::Statement::SelectList $.select-list is required;
has SQL::Statement::TableExpression $.table-expression is required;

multi method where(SQL::Statement::WhereClause $where-clause) {
    self.clone(:table-expression($!table-expression.clone(:$where-clause)))
}

multi method where(SQL::Statement::BooleanValueExpression $search-condition) {
    self.clone(
        :table-expression(
            $!table-expression.clone(
                :where-clause(
                    SQL::Statement::WhereClause.new(:$search-condition)
                )
            )
        )
    )
}
