use SQL::Statement;
use SQL::Statement::TableReference;

role SQL::Statement::DBICAdapter::Table does SQL::Statement::TableReference {
    method table() {
        SQL::Statement::TableOrQueryName.new: :name(self.name)
    }

    method join(Str $attribute) {
        my $info = self.relationship_info($attribute);
        my $rhs_source = self.schema.source($info<source>);
        my @cond = $info<cond>.kv;
        $_ .= subst(/^foreign\./, $rhs_source.name ~ '.') .= subst(/^'self.'/, self.name ~ '.') for @cond;
        SQL::Statement::TableReference.new(
            :table(
                SQL::Statement::QualifiedJoin.new(
                    :table_reference(self),
                    :rhs_table_reference($rhs_source but SQL::Statement::DBICAdapter::Table),
                    :join_specification(
                        eq(|@cond.map: {column($_)})
                    ),
                )
            )
        )
    }
}

class SQL::Statement::DBICAdapter::Schema {
    has $.schema handles <storage>;
    method source(Str $name) {
        $!schema.source($name) but SQL::Statement::DBICAdapter::Table;
    }
}
