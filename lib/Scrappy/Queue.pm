# ABSTRACT: Scrappy Request Scheduler and Queue System
# Dist::Zilla: +PodWeaver
package Scrappy::Queue;
BEGIN {
  $Scrappy::Queue::VERSION = '0.9111110';
}

# load OO System
use Moose;

# load other libraries
use Array::Unique;
use URI;

# queue and cursor variables for navigation
our @_queue = ();
tie @_queue, 'Array::Unique';
our $_cursor = -1;



sub list {
    return @_queue;
}


sub add {
    my $self = shift;
    my @urls = @_;

    # validate and formulate proper URLs
    for (my $i = 0; $i < @urls; $i++) {
        my $u = URI->new($urls[$i]);
        if ('URI::_generic' ne ref $u) {
            $urls[$i] = $u->as_string;
        }
        else {
            unless ($urls[$i] =~ /\w{2,}\.\w{2,}/) {
                delete $urls[$i];
            }
        }
    }

    push @_queue, @urls;
    return $self;
}


sub clear {
    my $self = shift;

    @_queue  = ();
    $_cursor = -1;

    return $self;
}


sub reset {
    my $self = shift;

    $_cursor = -1;

    return $self;
}


sub current {
    my $self = shift;

    return $_queue[$_cursor];
}


sub next {
    my $self = shift;

    return $_queue[++$_cursor];
}


sub previous {
    my $self = shift;

    return $_queue[--$_cursor];
}


sub first {
    my $self = shift;
    $_cursor = 0;

    return $_queue[$_cursor];
}


sub last {
    my $self = shift;
    $_cursor = scalar(@_queue) - 1;

    return $_queue[$_cursor];
}


sub index {
    my $self = shift;
    $_cursor = shift || 0;

    return $_queue[$_cursor];
}


sub cursor {
    return $_cursor;
}

1;

__END__
=pod

=head1 NAME

Scrappy::Queue - Scrappy Request Scheduler and Queue System

=head1 VERSION

version 0.9111110

=head1 SYNOPSIS

    #!/usr/bin/perl
    use Scrappy;

    my  $surl = ... # starting url
    my  $scraper = Scrappy->new;
        
        while (my $url = $scraper->queue($surl)->next) {
            if ($scraper->get($url)) {
                ...
            }
        }

=head1 DESCRIPTION

Scrappy::Queue provides Scrappy with methods for navigating a list of stored URLs.

=head1 METHODS

=head2 list

The list method is used to return the ordered list queued URLs.

    my  $queue = Scrappy::Queue->new;
    my  @urls = $queue->list;

=head2 add

The add method is used to add URLs to the queue.

    my  $queue = Scrappy::Queue->new;
        $queue->add('http://search.cpan.org', 'http://google.com');

=head2 clear

The clear method empties the URLs queue and resets the queue cursor.

    my  $queue = Scrappy::Queue->new;
        $queue->clear;

=head2 reset

The reset method resets the queue cursor only.

    my  $queue = Scrappy::Queue->new;
        $queue->add(...);
    my  $url = $queue->next;
        $queue->reset;

=head2 current

The current method returns the value of the current position in the queue.

    my  $queue = Scrappy::Queue->new;
        print $queue->current;

=head2 next

The next method returns the next value from the current position of the queue.

    my  $queue = Scrappy::Queue->new;
        print $queue->next;

=head2 previous

The previous method returns the previous value from the current position in the queue.

    my  $queue = Scrappy::Queue->new;
        print $queue->previous;

=head2 first

The first method returns the first value in the queue.

    my  $queue = Scrappy::Queue->new;
        print $queue->first;

=head2 last

The last method returns the last value in the queue.

    my  $queue = Scrappy::Queue->new;
        print $queue->last;

=head2 index

The index method returns the value of the specified position in the queue.

    my  $queue = Scrappy::Queue->new;
    my  $index = 0; # first position (same as array)
        print $queue->index($index);

=head2 cursor

The cursor method returns the value (index position) of the cursor.

    my  $queue = Scrappy::Queue->new;
        print $queue->cursor;

=head1 AUTHOR

Al Newkirk <awncorp@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by awncorp.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

