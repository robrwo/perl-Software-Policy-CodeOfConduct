# This file was automatically generated by Dist::Zilla::Plugin::MakeMaker v6.032.
use strict;
use warnings;

use 5.020000;

use ExtUtils::MakeMaker;

use File::ShareDir::Install;
$File::ShareDir::Install::INCLUDE_DOTFILES = 1;
$File::ShareDir::Install::INCLUDE_DOTDIRS = 1;
install_share dist => "share";


my %WriteMakefileArgs = (
  "ABSTRACT" => "generate a Code of Conduct policy",
  "AUTHOR" => "Robert Rothenberg <rrwo\@cpan.org>",
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => 0,
    "File::ShareDir::Install" => "0.06"
  },
  "DISTNAME" => "Software-Policy-CodeOfConduct",
  "LICENSE" => "artistic_2",
  "MIN_PERL_VERSION" => "5.020000",
  "NAME" => "Software::Policy::CodeOfConduct",
  "PREREQ_PM" => {
    "File::ShareDir" => 0,
    "Moo" => "1.006000",
    "Path::Tiny" => "0.119",
    "Text::Template" => "1.48",
    "Text::Wrap" => 0,
    "Types::Common" => 0,
    "experimental" => 0,
    "namespace::autoclean" => 0
  },
  "TEST_REQUIRES" => {
    "File::Spec" => 0,
    "Module::Metadata" => 0,
    "Path::Tiny" => "0.119",
    "Test2::V0" => 0,
    "Test::File::ShareDir" => 0,
    "Test::More" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "VERSION" => "v0.5.0",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


my %FallbackPrereqs = (
  "File::ShareDir" => 0,
  "File::Spec" => 0,
  "Module::Metadata" => 0,
  "Moo" => "1.006000",
  "Path::Tiny" => "0.119",
  "Test2::V0" => 0,
  "Test::File::ShareDir" => 0,
  "Test::More" => 0,
  "Text::Template" => "1.48",
  "Text::Wrap" => 0,
  "Types::Common" => 0,
  "experimental" => 0,
  "namespace::autoclean" => 0,
  "strict" => 0,
  "warnings" => 0
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  delete $WriteMakefileArgs{TEST_REQUIRES};
  delete $WriteMakefileArgs{BUILD_REQUIRES};
  $WriteMakefileArgs{PREREQ_PM} = \%FallbackPrereqs;
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);

{
package
MY;
use File::ShareDir::Install qw(postamble);
}
