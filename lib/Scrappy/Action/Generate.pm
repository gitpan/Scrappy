package Scrappy::Action::Generate;

BEGIN {
    $Scrappy::Action::Generate::VERSION = '0.92111230';
}

use File::Util;
use Moose::Role;
use String::TT qw/tt strip/;
with 'Scrappy::Action::Help';

sub script {
    my ($self, @options) = @_;
    my $script_name = $options[0] || "myapp.pl";
    $script_name =~ s/\.pl$//;

    File::Util->new->write_file(
        'file'    => "$script_name.pl",
        'bitmask' => 644,
        'content' => strip tt q{
        #!/usr/bin/perl
        
        use strict;
        use warnings;
        use Scrappy;
        
        my  $scraper  = Scrappy->new;
        my  $datetime = $scraper->logger->timestamp;
            $datetime =~ s/\D//g;
            
            # report warning, errors and other information
            $scraper->debug(0);
            
            # report detailed event logs
            $scraper->logger->verbose(0);
            
            # create a new log file with each execution
            $scraper->logger->write("[% script_name %]_logs/$datetime.log")
                if $scraper->debug;
            
            # load session file for persistent storage between executions
            -f '[% script_name %].sess' ?
                $scraper->session->load('[% script_name %].sess') :
                $scraper->session->write('[% script_name %].sess');
                
            # crawl something ...
            $scraper->crawl('http://localhost/',
                '/' => {
                    'body' => sub {
                        my ($self, $item, $params) = @_;
                        # ...
                    }
                }
            );
            
    }
    );

    return "\n... successfully created script $script_name.pl\n";
}

sub class {
    my ($self, @options) = @_;

    my $project = $options[0] || "MyApp";
    my $path = $project;
    $path =~ s/::/\//g;

    File::Util->new->write_file(
        'file'    => "lib/$path.pm",
        'bitmask' => 644,
        'content' => strip tt q{
        package [% project %];

        use Moose;
        with 'Scrappy::Project::Document';
        
        sub title {
            return
                shift->scraper->select('title')
                ->data->[0]->{text};
        }
        
        1;
    }
    );

    return "\n... successfully created project class $project\n";
}

sub project {
    my ($self, @options) = @_;

    my $project = $options[0] || "MyApp";
    my $object = $project;
    $object =~ s/::/\-/g;
    my $path = $project;
    $path =~ s/::/\//g;

    File::Util->new->write_file(
        'file'    => "$object/" . lc $object,
        'bitmask' => 644,
        'content' => strip tt q{
        #!/usr/bin/perl
        
        use strict;
        use warnings;
        use lib 'lib';
        use [% project %];
        
        my  $starting_url = '...';
        
        [% project %]->crawl($starting_url) ; # ... and away we go ...
    }
    );

    File::Util->new->write_file(
        'file'    => "$object/lib/$path.pm",
        'bitmask' => 644,
        'content' => strip tt q{
        package [% project %];

        use  Moose;
        use  Scrappy;
        with 'Scrappy::Project';
        
        sub setup {
            
            my  $self     = shift;
            my  $scraper  = $self->scraper;
            my  $datetime = $scraper->logger->timestamp;
                $datetime =~ s/\D//g;
                
                # report warning, errors and other information
                $scraper->debug(0);
                
                # report detailed event logs
                $scraper->logger->verbose(0);
                
                # create a new log file with each execution
                $scraper->logger->write("logs/$datetime.log")
                    if $scraper->debug;
                
                # load session file for persistent storage between executions
                -f '[% object FILTER lower %].sess' ?
                    $scraper->session->load('[% object FILTER lower %].sess') :
                    $scraper->session->write('[% object FILTER lower %].sess');
                    
                # define route(s) - route web pages to parsers
                $self->route('/' => 'root');
                
                # return your configured app instance
                $self;
        
        }
        
        1;
    }
    );

    File::Util->new->write_file(
        'file'    => "$object/lib/$path/Root.pm",
        'bitmask' => 644,
        'content' => strip tt q{
        package [% project %]::Root;

        use Moose;
        with 'Scrappy::Project::Document';
        
        # ... maybe for parsing /index.html
        
        sub title {
            return
                shift->scraper->select('title')
                ->data->[0]->{text};
        }
        
        1;
    }
    );

    File::Util->new->write_file(
        'file'    => "$object/lib/$path/List.pm",
        'bitmask' => 644,
        'content' => strip tt q{
        package [% project %]::List;

        use Moose;
        with 'Scrappy::Project::Document';
        
        # ... maybe for parsing /search.html
        
        sub title {
            return
                shift->scraper->select('title')
                ->data->[0]->{text};
        }
        
        1;
    }
    );

    File::Util->new->write_file(
        'file'    => "$object/lib/$path/Page.pm",
        'bitmask' => 644,
        'content' => strip tt q{
        package [% project %]::Page;

        use Moose;
        with 'Scrappy::Project::Document';
        
        # ... maybe for parsing /:page.html
        
        sub title {
            return
                shift->scraper->select('title')
                ->data->[0]->{text};
        }
        
        1;
    }
    );

    return "\n... successfully created project $project\n";
}

1;

__DATA__

The generate action is use to generate various scaffolding (or boiler-plate code)
to reduce the tedium, get you up and running quicker and with more efficiency.

* Generate a Scrappy script

USAGE: scrappy generate script [FILENAME]
EXAMPLE: scrappy generate script eg/web_crawler.pl

* Generate a Scrappy project

USAGE: scrappy generate project [PACKAGE]
EXAMPLE: scrappy generate project MyApp

* Generate a Scrappy project class

USAGE: scrappy generate class [CLASS]
EXAMPLE: scrappy generate class MyApp::SearchPage
