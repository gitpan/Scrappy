package Scrappy::Session;

BEGIN {
    $Scrappy::Session::VERSION = '0.9111120';
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
