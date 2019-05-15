use v6.c;
use Test;
use SQL::Statement;
use SQL::Statement::DBICAdapter;
use lib:from<Perl5> <lib>;
use Atikon::DB::Timemngt:from<Perl5>;
use DBIx::Class::SQLMaker::Passthrough:from<Perl5>;

my $schema = SQL::Statement::DBICAdapter::Schema.new(
    schema => Atikon::DB::Timemngt.connect("dbi:Pg:database=timemngt")
);
$schema.storage.sql_maker_class("DBIx::Class::SQLMaker::Passthrough");

my $customers = $schema.source('Customer');

my $search = SQL::Generator.search(
    select(
        *,
        from(
            subquery(
                select(*,
                    from($customers.join('country')),
                    where(
                        eq(column('customers.id'), 246),
                    ),
                ),
                :as<c>,
            ),
        ),
    )
);

my $rs = $customers.resultset.search_rs(Any, $search);
ok($rs.first.country);

done-testing;

# ft=perl6
