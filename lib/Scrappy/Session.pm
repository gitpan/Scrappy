# ABSTRACT: Scrappy Session Storage Mechanism
# Dist::Zilla: +PodWeaver
package Scrappy::Session;
BEGIN {
  $Scrappy::Session::VERSION = '0.9111110';
}

# load OO System
use Moose;

# load other libraries
use Carp;
use YAML::Syck;
$YAML::Syck::ImplicitTyping = 1;



sub load {
    my $self = shift;
    my $file = shift;

    if ($file) {

        $self->{file} = $file;

        # load session file
        $self->{stash} = LoadFile($file)
          or
          croak("Session file $file does not exist or is not read/writable");
    }

    return $self->{stash};
}


sub stash {
    my $self = shift;
    $self->{stash} = {} unless defined $self->{stash};

    if (@_) {
        my $stash = @_ > 1 ? {@_} : $_[0];
        if ($stash) {
            if (ref $stash eq 'HASH') {
                for (keys %{$stash}) {
                    if (lc $_ ne ':file') {
                        $self->{stash}->{$_} = $stash->{$_};
                    }
                    else {
                        $self->{file} = $stash->{$_};
                    }
                }
            }
            else {
                return $self->{stash}->{$stash};
            }
        }
    }

    $self->write;
    return $self->{stash};
}


sub write {
    my $self = shift;
    my $file = shift || $self->{file};

    $self->{file} = $file;

    if ($file) {

        # write session file
        DumpFile($file, $self->{stash})
          or
          croak("Session file $file does not exist or is not read/writable");
    }

    return $self->{stash};
}

1;

__END__
=pod

=head1 NAME

Scrappy::Session - Scrappy Session Storage Mechanism

=head1 VERSION

version 0.9111110

=head1 SYNOPSIS

    #!/usr/bin/perl
    use Scrappy;

    my  $session = Scrappy::Session->new;
        $session->load('file.yml');
        $session->stash('foo' => 123); # writes back to file.yml automatically
        $session->write('new_file.yml'); # writes new file based on memory

=head1 DESCRIPTION

Scrappy::Session provides Scrappy with methods for storing stash and cookie data
in a session (YAML) file for sharing important data across executions.

=head1 METHODS

=head2 load

The load method is used to read the specified session file.

    my  $session = Scrappy::Session->new;
    my  $data = $session->load('session.yml');

=head2 stash

The stash method sets a stash (shared) variable or returns a reference to the entire
stash object.

    my  $session = Scrappy::Session->new;
        $session->stash(age => 31);
        
    print 'stash access works'
        if $session->stash('age') == $session->stash->{age};
    
    my @array = (1..20);
    $session->stash(integers => [@array]);

=head2 write

The write method is used to write the specified session file.

    my  $session = Scrappy::Session->new;
        $session->write('file.yml');

=head1 AUTHOR

Al Newkirk <awncorp@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by awncorp.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

