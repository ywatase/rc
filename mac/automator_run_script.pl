#!/usr/bin/env perl 
use utf8;
use strict;
use warnings;

package Automator::RunScript;
use English qw( -no_match_vars ) ;  # Avoids regex performance penalty
use Carp;
use User::pwent;
use IPC::Open3;

my $ent = getpwuid $UID;
my $can_run = {
    zsh => {
        cmd => [qw(zsh -s)],
    },
    bash => 1,
    sh => 1,
    perl => 1,
    python => 1,
    ruby => {
        cmd => [qw(ruby -Ku)],
    },
    _default => {
        cmd => $ent->shell,
    },
    # command_name => {
    #     cmd => coderef,
    # },
};
sub new {
    my $class = shift;
    $class = ref $class if ref $class;
    my $self = bless {
        _setting => {
            bin => '_default',
            user => 'nobody',
            pwent => $ent,
            home => $ent->dir,
        },
    }, $class;
    return $self;
}

sub setting {
    $_[0]->{_setting} = $_[1] if $_[1];
    return $_[0]->{_setting}
}
sub script {
    $_[0]->{_script} = $_[1] if $_[1];
    return $_[0]->{_script}
}

sub run {
    my ($self) = @_;
    if (not $self->setting->{cmd}) {
        $self->run_cmd ($self->setting->{bin});
    }
    elsif (ref $self->setting->{cmd} eq 'CODE'){
        $self->setting->{cmd}->($self);
    }
    elsif (ref $self->setting->{cmd} eq 'ARRAY'){
        $self->run_cmd (@{$self->setting->{cmd}});
    }
    elsif (ref $self->setting->{cmd}){
        Carp::confess sprintf "somthing wrong : ref \$self->setting->{cmd} : %s", ref $self->setting->{cmd};
    }
    else {
        $self->run_cmd ($self->setting->{cmd});
    }
}

sub preprocess_perl {
    my ($self) = @_;
    my $script = 'use utf8; use Data::Dumper;sub p {print Dumper \@_;};' . $self->script;
    $self->script($script);
}

#sub _preprocess_sh {
#    my ($self) = @_;
#}
#sub preprocess_zsh { $_[0]->_preprocess_sh; }
#sub preprocess_bash { $_[0]->_preprocess_sh; }

sub run_cmd {
    my ($self, @cmd) = @_;;
    use Data::Dumper; warn Dumper $self if $ENV{DEBUG};
    unshift @cmd, 'sudo', '-u', $self->setting->{user}, '-H';
    warn Dumper \@cmd if $ENV{DEBUG};
    my $preprocess_method = 'preprocess_' . $self->setting->{bin};
    if ($self->can($preprocess_method)) {
        $self->$preprocess_method;
    }
    my ($wtr, $rdr);
    my $pid = open3($wtr, $rdr, 0, @cmd);
    print $wtr $self->script;
    close $wtr;
    while (my $line = <$rdr>) {
        print $line;
    };
    waitpid($pid, 0);
    close $rdr;
}

sub parse {
    my ($self, $str) = @_;
    $str =~ s/\A(?:!([^\s\@]+))?([\@]+)?\s*//msx;
    my ($bin, $flags) = ($1, $2);
    if ($bin) {
        if ( $can_run->{$bin} ){
            $self->setting->{bin} = $bin;
        }
        else {
            die "Can't run $bin";
        }
    }
    if (ref $can_run->{$self->setting->{bin}} eq 'HASH') {
        $self->setting->{cmd} = $can_run->{$self->setting->{bin}}->{cmd};
    }
    if ($flags) {
        if ($flags =~ /\@/) {
            $self->setting->{user} = $self->setting->{pwent}->name;
        }
    }
    $self->script($str);
    return $self;
}

1;

package main;
use Pod::Usage;
use Getopt::Long qw(:config posix_default no_ignore_case gnu_compat bundling auto_version auto_help);

our $VERSION = '0.001';



my %args;

eval { main() };
if ($@) {
    print $@;
}


sub main {
    if ( not GetOptions ( \%args)) {pod2usage(2); exit 0; }
    my $stdin = join "\n", <>;
    my $rs = Automator::RunScript->new;
    $rs->parse($stdin);
    $rs->run;
}

=pod

=head1 NAME

automator_run_script.pl - for automater script

=head1 SYNOPSIS

  echo '[!bash|zsh|perl|ruby][@] cmd' | automator_run_script.pl

  usually call from automater


=head1 DESCRIPTION

=over 4

=item B<![bash|zsh|perl|ruby]>

set which script you want to run.

default : your shell in /etc/passwd

=item B<@>

run as yourself.

if not set (default), run as I<nobody> user avoid to incident. cf) rm -rf /

=item B<%>

when run bash or zsh, load .rc file in your home directory. 

=back

=head1 PREREQUISITES

This script requires the C<Getopt::Long>, C<Pod::Usage>

=head1 Author

 Yusuke Wtase <ywatase@gmail.com>
  
=cut

