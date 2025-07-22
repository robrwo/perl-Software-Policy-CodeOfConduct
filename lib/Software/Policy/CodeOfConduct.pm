package Software::Policy::CodeOfConduct;

# ABSTRACT: generate a Code of Conduct policy

use v5.20;

use Moo;

use File::ShareDir qw( dist_file );
use Path::Tiny 0.018 qw( cwd path );
use Text::Template;
use Text::Wrap    qw( wrap $columns );
use Types::Common qw( InstanceOf Maybe NonEmptyStr NonEmptySimpleStr PositiveInt );

use experimental qw( lexical_subs signatures );

use namespace::autoclean;

our $VERSION = 'v0.2.0';

=head1 SYNOPSIS

    my $policy = Software::Policy::CodeOfConduct->new(
        name     => 'Foo',
        contact  => 'team-foo@example.com',
        policy   => 'Contributor_Covenant_1.4',
        filename => 'CODE-OF-CONDUCT.md',
    );

    $policy->save($dir); # create CODE-OF-CONDUCT.md in $dir

=head1 DESCRIPTION

This distribution generates code of conduct policies from a template.

=attr name

This is the (optional) name of the project that the code of conduct is for,

=attr has_name

True if there is a name.

=cut

has name => (
    is        => 'ro',
    isa       => Maybe [NonEmptySimpleStr],
    predicate => 1,
);

=attr contact

The is the contact for the project team about the code of conduct. It should be an email address or a URL.

It is required.

=cut

has contact => (
    is       => 'ro',
    required => 1,
    isa      => NonEmptySimpleStr,
);

=attr policy

This is the policy filename. It defaults to F<Contributor_Covenant_1.4> which is based on
L<https://www.contributor-covenant.org/version/1/4/code-of-conduct.html>.

=cut

has policy => (
    is      => 'ro',
    default => 'Contributor_Covenant_1.4',
);

=attr template_path

This is the path to the template file. If omitted, it will assume it is an included file from L</policy>.

This should be a L<Text::Template> file.

=cut

has template_path => (
    is      => 'lazy',
    isa     => InstanceOf ['Path::Tiny'],
    coerce  => \&path,
    builder => sub($self) {
        return path( dist_file( __PACKAGE__ =~ s/::/-/gr , $self->policy . ".md.tmpl" ) );
    },
);

has _template => (
    is       => 'lazy',
    isa      => InstanceOf ['Text::Template'],
    init_arg => undef,
    builder  => sub($self) {
        return Text::Template->new(
            TYPE   => "FILE",
            SOURCE => $self->template_path,
        );
    }

);

=attr text_columns

This is the number of text columns for word-wrapping the L</text>.

The default is C<78>.

=cut

has text_columns => (
    is      => 'ro',
    isa     => PositiveInt,
    default => 78,
);

=attr text

This is the text generated from the template.

=cut

has text => (
    is      => 'lazy',
    isa     => NonEmptyStr,
    builder => sub($self) {
        my $raw = $self->_template->fill_in(
            HASH => {
                contact => $self->contact,
            }
        );

        $columns = $self->text_columns;
        my sub _wrap($line) {
            return $line if $line =~ /^[ ]{4}/; # ignore preformatted code
            return wrap( "", $line =~ /^[\*\-]/ ? "  " : "", $line =~ s/[ ][ ]+/ /gr );
        }

        my @lines = map { _wrap($_) } split /\n/, $raw;
        return join( "\n", @lines );

    }
);

=attr filename

This is the file to be generated.

This defaults to F<CODE_OF_CONDUCT.md>.

=cut

has filename => (
    is      => 'ro',
    isa     => NonEmptySimpleStr,
    coerce  => sub($name) { return path($name)->basename },
    default => 'CODE_OF_CONDUCT.md',
);

=method save

    my $path = $policy->save( $dir );

This saves a file named L</filename> in directory C<$dir>.

If C<$dir> is omitted, then it will save the file in the current directory.

=cut

sub save($self, $dir = undef) {
    my $path = path( $dir // cwd, $self->filename );
    $path->spew_raw( $self->text );
    return $path;
}

=head1 prepend:SUPPORT

Only the latest version of this module will be supported.

This module requires Perl v5.20 or later.  Future releases may only support Perl versions released in the last ten
years.

=head2 Reporting Bugs

=head1 append:SUPPORT

If the bug you are reporting has security implications which make it inappropriate to send to a public issue tracker,
then see F<SECURITY.md> for instructions how to report security vulnerabilities

=cut

1;
