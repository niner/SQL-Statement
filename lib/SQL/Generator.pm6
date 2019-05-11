unit class SQL::Generator;

use SQL::Statement::Asterisk;
use SQL::Statement::DerivedTable;
use SQL::Statement::FromClause;
use SQL::Statement::Select;
use SQL::Statement::Subquery;
use SQL::Statement::TableExpression;
use SQL::Statement::TableOrQueryName;

multi method generate(SQL::Statement::Select $select) {
    "SELECT $.generate($select.select-list) $.generate($select.table-expression)"
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
    "$.generate($table.table) {$table.sample-clause ?? self.generate($table.sample-clause) !! ''}"
}
multi method generate(SQL::Statement::DerivedTable $table) {
    "$.generate($table.subquery) AS $table.correlation_name()"
}
multi method generate(SQL::Statement::TableOrQueryName $name) {
    $name.name
}
multi method generate(SQL::Statement::Subquery $table) {
    '(' ~ self.generate($table.query) ~ ')'
}
