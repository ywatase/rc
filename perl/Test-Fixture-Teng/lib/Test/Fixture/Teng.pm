package Test::Fixture::Teng;
use strict;
use 5.8.1;
our $VERSION = '0.01';
use base 'Exporter';
our @EXPORT = qw/construct_fixture/;
use Params::Validate ':all';
use Carp ();
use Kwalify ();

sub construct_fixture {
    my %args = validate(
        @_ => +{
            db      => 1,
            fixture => 1,
        }
    );

    my $fixture = _validate_fixture(_load_fixture($args{fixture}));
    _delete_all($args{db});
    return _insert($args{db}, $fixture);
}

sub _load_fixture {
    my $stuff = shift;

    if (ref $stuff) {
        if (ref $stuff eq 'ARRAY') {
            return $stuff;
        } else {
            Carp::croak "invalid fixture stuff. should be ARRAY: $stuff";
        }
    } else {
        require YAML::Syck;
        return YAML::Syck::LoadFile($stuff);
    }
}

sub _validate_fixture {
    my $stuff = shift;

    Kwalify::validate(
        {
            type     => 'seq',
            sequence => [
                {
                    type    => 'map',
                    mapping => {
                        schema => { type => 'str', required => 1 },
                        name   => { type => 'str', required => 1 },
                        data   => { type => 'any', required => 1 },
                    },
                }
            ]
        },
        $stuff
    );

    $stuff;
}

sub _delete_all {
    my $db = shift;
    $db->delete($_) for
        keys %{$db->schema->tables};
}

sub _insert {
    my ($db, $fixture) = @_;

    my $result = {};
    for my $row ( @{ $fixture } ) {
        $result->{ $row->{name} } = $db->insert($row->{schema}, $row->{data});
    }
    return $result;
}

1;

__END__

=encoding utf-8

=for stopwords

=head1 NAME

Test::Fixture::Teng -

=head1 SYNOPSIS

  use Test::Fixture::Teng;

=head1 DESCRIPTION

Test::Fixture::Teng is fixture data loader for Teng

=head1 METHODS

=head2 construct_fixture

  my $data = construct_fixture(
      db      => 
      fixture => 'fixture.yaml',
  );

=head1 AUTHOR

ywatase E<lt>ywatase@gmail.comE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
