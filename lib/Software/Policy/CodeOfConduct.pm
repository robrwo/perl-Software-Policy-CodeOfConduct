package Software::Policy::CodeOfConduct;

use v5.20;

use Moo;

use File::ShareDir qw( module_file );
use Text::Template;
use Text::Wrap    qw( wrap $columns );
use Types::Common qw( InstanceOf Maybe NonEmptyStr NonEmptySimpleStr PositiveInt );

use experimental qw( signatures );

has name => (
    is        => 'ro',
    isa       => Maybe [NonEmptySimpleStr],
    predicate => 1,
);

has contact => (
    is       => 'ro',
    required => 1,
    isa      => NonEmptySimpleStr,
);

has policy => (
    is      => 'ro',
    default => 'Contributor_Covenant_1.4',
);

has template_path => (
    is      => 'lazy',
    isa     => Maybe [NonEmptySimpleStr],
    builder => sub($self) {
        return module_file( __PACKAGE__, $self->policy . ".md.tmpl", );
    },
);

has template => (
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

has text_columns => (
    is      => 'ro',
    isa     => PositiveInt,
    default => 78,
);

has text => (
    is      => 'lazy',
    isa     => NonEmptyStr,
    builder => sub($self) {
        $columns = $self->text_columns;
        my $raw = $self->template->fill_in(
            HASH => {
                contact => $self->contact,
            }
        );
        my @lines = map { wrap( "", $_ =~ /^[\*\-]/ ? "  " : "", $_ ) } split /\n/, ( $raw =~ s/[ ][ ]+/ /gr );
        return join( "\n", @lines );

    }
);

1;
