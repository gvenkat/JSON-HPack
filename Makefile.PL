#!/usr/bin/env perl

use 5.008007;

use strict;
use warnings;

# "Son, when you participate in sporting events,
#  it's not whether you win or lose, it's how drunk you get."
use ExtUtils::MakeMaker;

my ($mm) = $ExtUtils::MakeMaker::VERSION =~ /^([^_]+)/;

# We only use core modules, so you shouldn't have to install anything besides
# Perl 5.8.7!
WriteMakefile(
  NAME         => 'JSON-HPack',
  VERSION_FROM => 'lib/JSON/HPack.pm',
  ABSTRACT     => 'A simple and fast JSON Packer',
  AUTHOR       => 'Venkatakrishnan Ganesh <gvenkat@cpan.org>',

  ( $mm < 6.46
    ? ()
    : (
      META_MERGE => {
        requires  => {perl => '5.008007'},
        no_index => {directory => [qw/t/]}
      },
      META_ADD => {
        build_requires     => {
          'JSON::Any' => 0,
          'common::sense' => 0
        },

        test_requires => {
          'Test::More' => 0,   
          'Test::Deep' => 0
        },

        configure_requires => {}
      },
    )
  ),

  test => {TESTS => 't/*.t t/*/*.t'}
);

