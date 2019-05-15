package DBIx::Class::SQLMaker::Passthrough;
use base "DBIx::Class::SQLMaker";
sub select {
    my ($self, $table, $fields, $where, $rs_attrs, $limit, $offset) = @_;
    if ($rs_attrs->{statement}) {
        return $rs_attrs->{statement}, @{ $rs_attrs->{bind_values} // [] }
    }
    else {
        shift->next::method(@_)
    }
}

1;
