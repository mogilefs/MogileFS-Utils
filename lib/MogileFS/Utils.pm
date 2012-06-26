#!/usr/bin/perl
package MogileFS::Utils;

our $VERSION = '2.25';

use Getopt::Long;
use MogileFS::Client;

use fields (
            'config'
           );

# Helper object for the individual utilities.
sub new {
    my MogileFS::Utils $self = shift;
    $self = fields::new($self) unless ref $self;
    $self->_init(@_);

    return $self;
}

# Predefine some options via configuration.
sub _init {
    my MogileFS::Utils $self = shift;

    $self->{config} = {};
}

sub _readconf {
    my MogileFS::Utils $self = shift;
    my $args = shift;

    # Liftedish from mogadm, but we can refactor mogadm to use this instead.
    my @configs = ($args->{conf}, $ENV{MOGUTILSCONF},
        "$ENV{HOME}/.mogilefs.conf",
        "/etc/mogilefs/mogilefs.conf");
    my %opts = ();
    for my $fn (reverse @configs) {
        next unless $fn && -e $fn;
        open my $file, "<$fn"
            or die "unable to open $fn: $!";
        while (<$file>) {
            s/\#.*//;
            next unless m/^\s*(\w+)\s*=\s*(.+?)\s*$/;
            $opts{$1} = $2 unless ( defined $opts{$1} );
        }
        close $file;
    }

    return \%opts;
}

sub config {
    my MogileFS::Utils $self = shift;
    return $self->{config};
}

sub getopts {
    my MogileFS::Utils $self = shift;
    my $usage = shift;
    my @want  = @_;

    my %opts = ();
    $self->abort_usage($usage) unless @ARGV;
    GetOptions(\%opts, @want, qw/help trackers=s domain=s conf=s/)
        or $self->abort_usage($usage);
    my $config = $self->_readconf(\%opts);

    $self->{config} = {%$config, %opts};
    $self->_verify_config;
    $self->abort_usage($usage) if $self->{config}->{help};
    
    return $self->{config};
}

sub _verify_config {
    my MogileFS::Utils $self = shift;
    my $conf = $self->{config};

    while (my ($k, $v) = each %$conf) {
        if ($k =~ m/^trackers/) {
            my @tr = split /,/, $v;
            for (@tr) {
                # Client is obnoxious about requiring a port.
                if ($_ !~ m/:\d+/) {
                    $_ = $_ . ':7001';
                }
            }
            $conf->{$k} = \@tr;
        } elsif ($k =~ m/class/) {
            # "" means "default". Might have to remove this if people have
            # been adding "default" classes, which I don't think is possible?
            if ($v eq 'default') {
                $conf->{$k} = '';
            }
        }
    }
}

# Do we want to be fancier here?
sub abort_usage {
    my MogileFS::Utils $self = shift;
    my $usage = shift;
    print "Usage: $0 $usage\n";
    exit;
}

sub client {
    my MogileFS::Utils $self = shift;
    my $c = $self->{config};
    return MogileFS::Client->new(domain => $c->{domain},
        hosts => $c->{trackers});
}

=head1 NAME

MogileFS::Utils - Command line utilities for the MogileFS distributed file system.

=head1 SYNOPSIS

L<mogadm>

L<mogstats>

L<mogupload>

L<mogfetch>

L<mogdelete>

L<mogfileinfo>

L<moglistkeys>

L<moglistfids>

L<mogfiledebug>

L<mogtool> (DEPRECATED: Do not use!)

=head1 SUMMARY

Please refer to the documentation for the tools included in this distribution.

=head1 CONFIGURATION FILE

Most of the utilities in this package support a configuration file. Common
options can be pushed into the config file, such as trackers, domain, or
class. The file is in B</etc/mogilefs/mogilefs.conf> and B<~/.mogilefs.conf>
by default. You may also specify a configuration via B<--conf=filename>

Example:

    trackers = 10.0.0.1:7001,10.0.0.3:7001
    domain = foo

=head1 AUTHOR

Brad Fitzpatrick E<lt>L<brad@danga.com>E<gt>

Dormando E<lt>L<dormando@rydia.net>E<gt>

=head1 BUGS

Please report any on the MogileFS mailing list: L<http://groups.google.com/group/mogile/>.

=head1 LICENSE

Licensed for use and redistribution under the same terms as Perl itself.

=cut

1;
