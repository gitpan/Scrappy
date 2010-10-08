# ABSTRACT: Selected Element Object Instance

use strict;
use warnings;

package Scrappy::Element;
BEGIN {
  $Scrappy::Element::VERSION = '0.61';
}

sub new {
    bless {}, shift;
}

1;
__END__
=pod

=head1 NAME

Scrappy::Element - Selected Element Object Instance

=head1 VERSION

version 0.61

=head1 AUTHOR

  Al Newkirk <awncorp@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by awncorp.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

