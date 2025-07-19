package Software::Policy::CodeOfConduct;

use v5.20;

use Moo;

use File::ShareDir qw( module_file );
use Text::Template;
use Text::Wrap    qw( wrap $columns );
use Types::Common qw( InstanceOf Maybe NonEmptyStr NonEmptySimpleStr PositiveInt );

use experimental qw( signatures );

=head1 SYNOPSIS

    my $policy = Software::Policy::CodeOfConduct->new(
        name    => 'Foo',
        contact => 'team-foo@example.com',
        policy  => 'Contributor_Covenant_1.4',
    );

    open my $fh, '>', "CODE-OF-CONDUCT.md" or die $!;
    print {$fh} $policy->text;
    close $fh;

=head1 DESCRIPTION

This distribution generates code of conduct policies from a template.

=attr name

This is the (optional) name of the project that the code of conduct is for,

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

=attr

This is the policy filename. It defaults to F<Contributor_Covenant_1.4> which is based on
L<https://www.contributor-covenant.org/version/1/4/code-of-conduct.html>.

=cut

has policy => (
    is      => 'ro',
    default => 'Contributor_Covenant_1.4',
);

=attr

This is the path to the template file. If omitted, it will assume it is an included file from L</policy>.

This should be a L<Text::Template> file.

=cut

has template_path => (
    is      => 'lazy',
    isa     => Maybe [NonEmptySimpleStr],
    builder => sub($self) {
        return module_file( __PACKAGE__, $self->policy . ".md.tmpl", );
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
        $columns = $self->text_columns;
        my $raw = $self->_template->fill_in(
            HASH => {
                contact => $self->contact,
            }
        );
        my @lines = map { wrap( "", $_ =~ /^[\*\-]/ ? "  " : "", $_ ) } split /\n/, ( $raw =~ s/[ ][ ]+/ /gr );
        return join( "\n", @lines );

    }
);

1;
