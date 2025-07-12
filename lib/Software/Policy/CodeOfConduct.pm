package Software::Policy::CodeOfConduct;

use v5.20;

use Moo;

use File::ShareDir qw( module_file );
use Text::Template;

use experimental qw( signatures );

has name => (
    is => 'ro',
);

has contact => (
    is       => 'ro',
    required => 1,
);

has policy => (
    is      => 'ro',
    default => 'Contributor_Covenant',
);

has template_path => (
    is      => 'lazy',
    builder => sub($self) {
        return module_file( __PACKAGE__, $self->policy . ".md.tmpl", );
    },
);

has template => (
    is      => 'lazy',
    builder => sub($self) {
        return Text::Template->new(
            TYPE   => "FILE",
            SOURCE => $self->template_path,
        );
    }

);

has text => (
    is      => 'lazy',
    builder => sub($self) {
        return $self->template->fill_in(
            HASH => {
                contact => $self->contact,
            }
        );

    }
);

1;
