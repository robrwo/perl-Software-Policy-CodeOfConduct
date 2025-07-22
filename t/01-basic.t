
use v5.20;
use warnings;

use Test2::V0;
use Path::Tiny 0.119 qw( path tempdir );

use Test::File::ShareDir -share => {
    -dist => {
        "Software-Policy-CodeOfConduct" => "share"
    }
};

use Software::Policy::CodeOfConduct;

ok my $policy = Software::Policy::CodeOfConduct->new( contact => 'bogon@example.com', name => "Bogomip" ), 'constructor';

ok $policy->template_path, "template_path";

ok $policy->text, "text";

note $policy->text;

is $policy->filename, "CODE_OF_CONDUCT.md", "FILENAME";

my $dir = tempdir();
ok my $path = $policy->save($dir), "save";

ok -e $path, "file ${path} exists";

is $path, path($dir, $policy->filename), "expected path";

is $path->slurp_raw, $policy->text, "expected content";

done_testing;
