
use Cwd;
use File::Basename;

use Test::More tests => 8;
require_ok('Blosxom::Include');

my $test = '';
$test = "t/" if -d "t/plugins";
die "missing plugins dir '${test}plugins'" unless -d "${test}plugins";

$ENV{BLOSXOM_CONFIG_FILE} = getcwd . "/${test}config/blosxom.conf";

ok(eval { require "${test}plugins/testplugin" }, "require testplugin ok");
is($testplugin::package, 'package1', "\$testplugin::package is $testplugin::package");
is(testplugin::get_lexical(), 'lexical1', "\$lexical is " . testplugin::get_lexical());

# Handle lexical mask warning
my $my_warning = 0;
local $SIG{'__WARN__'} = sub { 
  if ($_[0] =~ m/"my" variable \$lexical masks earlier declaration/) {
    $my_warning = 1;
  } else {
    warn $_[0];
  }
};

ok(eval { require "${test}plugins/testplugin2" }, "require testplugin2 ok");
is($testplugin2::package, 'package2', "\$testplugin2::package is $testplugin2::package");
is(testplugin2::get_lexical(), 'lexical2', "\$lexical is " . testplugin2::get_lexical());
is($my_warning, 1, "'my' variable mask warning issued");

