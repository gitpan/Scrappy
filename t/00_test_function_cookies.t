#!/usr/bin/env perl

use Scrappy;
use FindBin;
use Test::More $ENV{TEST_LIVE} ?
    (tests => 1) : (skip_all => 'env var TEST_LIVE not set, live testing is not enabled');

my  $s = Scrappy->new;
ok  'HTTP::Cookies' eq ref $s->cookies;

