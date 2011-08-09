use strict;
use warnings;
use 5.8.1;
our $VERSION = '0.01';

use utf8;

package Amon2::Setup::Flavor::Teng;
use parent qw(Amon2::Setup::Flavor::Basic);

sub run {
    my $self = shift;

    $self->SUPER::run();

    $self->write_file('lib/<<PATH>>.pm', <<'...');
package <% $module %>;
use strict;
use warnings;
use parent qw/Amon2/;
our $VERSION='0.01';
use 5.008001;

__PACKAGE__->load_plugin(qw/DBI/);

use Teng;
use Teng::Schema::Loader;
sub db {
    my $self = shift;
    if (!defined $self->{db}) {
        my $dbh = $self->dbh;
        my $schema = Teng::Schema::Loader->load(
            dbh => $dbh,
            namespace => '<% $module %>::DB',
        );
        $self->{db} = Teng->new(
            dbh => $dbh,
            schema => $schema,
        );
    }
    return $self->{db};
}

1;
...

    $self->write_file('lib/<<PATH>>/DB.pm', <<'...');
package <% $module %>::DB;
use parent 'Teng';
1;
...

    $self->write_file('lib/<<PATH>>/DB/Schema.pm', '');

    $self->write_file('script/make_schema.pl', <<'...');
use strict;
use warnings;
use File::Spec;
use File::Basename;
use lib File::Spec->catdir(dirname(__FILE__), '..', 'extlib', 'lib', 'perl5');
use lib File::Spec->catdir(dirname(__FILE__), '..', 'lib');
use <% $module %>;
use Teng::Schema::Dumper;

my $c = <% $module %>->bootstrap;
my $schema = Teng::Schema::Dumper->dump(
    dbh => $c->dbh,
    namespace => '<% $module %>::DB',
);

my $dest = File::Spec->catfile(dirname(__FILE__), '..', 'lib', '<% $module %>', 'DB', 'Schema.pm');
open my $fh, '>', $dest or die "Cannot open file: $dest: $!";
print {$fh} $schema;
close $fh;
...
}

1;

__END__

=encoding utf-8

=for stopwords

=head1 NAME

Amon2::Setup::Flavor::Teng -

=head1 SYNOPSIS

  use Amon2::Setup::Flavor::Teng;

=head1 DESCRIPTION

Amon2::Setup::Flavor::Teng is

=head1 AUTHOR

ywatase E<lt>ywatase@gmail.comE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
