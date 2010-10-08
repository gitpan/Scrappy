
use strict;
use warnings;



use ExtUtils::MakeMaker 6.31;

use File::ShareDir::Install;
install_share "share";


my %WriteMakefileArgs = (
  'ABSTRACT' => 'All Powerful Web Harvester, Spider, Scraper fully automated',
  'AUTHOR' => 'Al Newkirk <awncorp@cpan.org>',
  'BUILD_REQUIRES' => {},
  'CONFIGURE_REQUIRES' => {
    'ExtUtils::MakeMaker' => '6.31',
    'File::ShareDir::Install' => '0.03'
  },
  'DISTNAME' => 'Scrappy',
  'EXE_FILES' => [],
  'LICENSE' => 'perl',
  'NAME' => 'Scrappy',
  'PREREQ_PM' => {
    'Array::Unique' => '0',
    'File::ShareDir' => '0',
    'File::Slurp' => '0',
    'HTML::TreeBuilder' => '0',
    'Test::More' => '0',
    'Try::Tiny' => '0',
    'URI' => '0',
    'WWW::Mechanize' => '0',
    'Web::Scraper' => '0',
    'YAML::Syck' => '0'
  },
  'VERSION' => '0.61',
  'test' => {
    'TESTS' => 't/*.t'
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM}; 
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod}; 
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);

package
MY;
use File::ShareDir::Install qw(postamble);


