package Software::Policy::CodeOfConduct;

# ABSTRACT: generate a Code of Conduct policy

use v5.20;

use Moo;

use File::ShareDir qw( dist_file );
use Path::Tiny 0.018 qw( cwd path );
use Text::Template 1.48;
use Text::Wrap    qw( wrap $columns );
use Types::Common qw( InstanceOf Maybe NonEmptyStr NonEmptySimpleStr PositiveInt );

use experimental qw( lexical_subs signatures );

use namespace::autoclean;

our $VERSION = 'v0.3.2';

=head1 SYNOPSIS

    my $policy = Software::Policy::CodeOfConduct->new(
        policy   => 'Contributor_Covenant_1.4',
        name     => 'Foo',
        contact  => 'team-foo@example.com',
        filename => 'CODE_OF_CONDUCT.md',
    );

    $policy->save($dir); # create CODE-OF-CONDUCT.md in $dir

=head1 DESCRIPTION

This distribution generates code of conduct policies from a template.

=attr policy

This is the policy filename without the extension. It defaults to "Contributor_Covenant_1.4"
.

Available policies include

=over

=item *

L<Contributor_Covenant_1.4|https://www.contributor-covenant.org/version/1/4/code-of-conduct.html>

=item *

L<Contributor_Covenant_2.0|https://www.contributor-covenant.org/version/2/0/code-of-conduct.html>

=item *

L<Contributor_Covenant_2.1|https://www.contributor-covenant.org/version/2/1/code-of-conduct.html>

=back

If you want to use a custom policy, specify the L</template_path>.

=cut

has policy => (
    is      => 'ro',
    default => 'Contributor_Covenant_1.4',
);

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

=attr entity

A generating name for the project. It defaults to "project" but the original templates used "community".

=cut

has entity => (
    is      => 'ro',
    isa     => NonEmptySimpleStr,
    default => 'project',
);

=attr Entity

A sentence-case (ucfirst) form of L</entity>.

=cut

has Entity => (
    is      => 'lazy',
    isa     => NonEmptySimpleStr,
    builder => sub($self) {
        return ucfirst( $self->entity );
    },
);

=attr template_path

This is the path to the template file. If omitted, it will assume it is an included file from L</policy>.

This should be a L<Text::Template> template file.

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

=method text

This is the text generated from the template.

=cut

has text => (
    is      => 'lazy',
    isa     => NonEmptyStr,
    init_arg => undef,
    builder => sub($self) {
        state $c = 1;
        my $pkg = __PACKAGE__ . "::Run_" . $c++;
        my $raw = $self->_template->fill_in(
            PACKAGE => $pkg,
            STRICT  => 1,
            BROKEN  => sub(%args) { die $args{error} },
            HASH    => {
                name    => $self->name,
                contact => $self->contact,
                entity  => $self->entity,
                Entity  => $self->Entity,
            },
        );

        $columns = $self->text_columns;
        my sub _wrap($line) {
            return $line if $line =~ /^[ ]{4}/; # ignore preformatted code
            return wrap( "", $line =~ /^[\*\-](?![\*\-]) ?/ ? "  " : "", $line =~ s/[ ][ ]+/ /gr );
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

sub save($self, $dir = undef) {

=method save

    my $path = $policy->save( $dir );

This saves a file named L</filename> in directory C<$dir>.

If C<$dir> is omitted, then it will save the file in the current directory.

=cut

    my $path = path( $dir // cwd, $self->filename );
    $path->spew_raw( $self->text );
    return $path;
}

=head1 prepend:SUPPORT

Only the latest version of this module will be supported.

This module requires Perl v5.20 or later.  Future releases may only support Perl versions released in the last ten
years.

=head2 Reporting Bugs and Submitting Feature Requests

=head1 append:SUPPORT

If the bug you are reporting has security implications which make it inappropriate to send to a public issue tracker,
then see F<SECURITY.md> for instructions how to report security vulnerabilities.

=cut

1;
