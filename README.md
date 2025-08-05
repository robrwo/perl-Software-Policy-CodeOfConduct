# NAME

Software::Policy::CodeOfConduct - generate a Code of Conduct policy

# SYNOPSIS

```perl
my $policy = Software::Policy::CodeOfConduct->new(
    policy   => 'Contributor_Covenant_1.4',
    name     => 'Foo',
    contact  => 'team-foo@example.com',
    filename => 'CODE_OF_CONDUCT.md',
);

$policy->save($dir); # create CODE-OF-CONDUCT.md in $dir
```

# DESCRIPTION

This distribution generates code of conduct policies from a template.

# RECENT CHANGES

Changes for version v0.5.1 (2025-08-05)

- Documentation
    - README is generated using Dist::Zilla::Plugin::UsefulReadmme.
    - Remove separate INSTALL file.
- Toolchain
    - Improve Dist::Zilla configuration.

See the `Changes` file for more details.

# REQUIREMENTS

This module lists the following modules as runtime dependencies:

- [File::ShareDir](https://metacpan.org/pod/File%3A%3AShareDir)
- [Moo](https://metacpan.org/pod/Moo) version 1.006000 or later
- [Path::Tiny](https://metacpan.org/pod/Path%3A%3ATiny) version 0.119 or later
- [Text::Template](https://metacpan.org/pod/Text%3A%3ATemplate) version 1.48 or later
- [Text::Wrap](https://metacpan.org/pod/Text%3A%3AWrap)
- [Types::Common](https://metacpan.org/pod/Types%3A%3ACommon)
- [experimental](https://metacpan.org/pod/experimental)
- [namespace::autoclean](https://metacpan.org/pod/namespace%3A%3Aautoclean)
- [perl](https://metacpan.org/pod/perl) version v5.20.0 or later

See the `cpanfile` file for the full list of prerequisites.

# INSTALLATION

The latest version of this module (along with any dependencies) can be installed from [CPAN](https://www.cpan.org) with the `cpan` tool that is included with Perl:

```
cpan Software::Policy::CodeOfConduct
```

You can also extract the distribution archive and install this module (along with any dependencies):

```
cpan .
```

You can also install this module manually using the following commands:

```
perl Makefile.PL
make
make test
make install
```

If you are working with the source repository, then it may not have a `Makefile.PL` file.  But you can use the [Dist::Zilla](https://dzil.org/) tool in anger to build and install this module:

```
dzil build
dzil test
dzil install --install-command="cpan ."
```

For more information, see [How to install CPAN modules](https://www.cpan.org/modules/INSTALL.html).

# SUPPORT

Only the latest version of this module will be supported.

This module requires Perl v5.20 or later.  Future releases may only support Perl versions released in the last ten
years.

## Reporting Bugs and Submitting Feature Requests

Please report any bugs or feature requests on the bugtracker website
[https://github.com/robrwo/perl-Software-Policy-CodeOfConduct/issues](https://github.com/robrwo/perl-Software-Policy-CodeOfConduct/issues)

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

If the bug you are reporting has security implications which make it inappropriate to send to a public issue tracker,
then see `SECURITY.md` for instructions how to report security vulnerabilities.

# SOURCE

The development version is on github at [https://github.com/robrwo/perl-Software-Policy-CodeOfConduct](https://github.com/robrwo/perl-Software-Policy-CodeOfConduct)
and may be cloned from [git://github.com/robrwo/perl-Software-Policy-CodeOfConduct.git](git://github.com/robrwo/perl-Software-Policy-CodeOfConduct.git)

# AUTHOR

Robert Rothenberg <rrwo@cpan.org>

# CONTRIBUTOR

# COPYRIGHT AND LICENSE

This software is Copyright (c) 2025 by Robert Rothenberg.

This is free software, licensed under:

```
The Artistic License 2.0 (GPL Compatible)
```
