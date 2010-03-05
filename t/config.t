
use Test::More tests => 2;

use_ok("PhoneUtils::Dispatcher::Config");
my $config = PhoneUtils::Dispatcher::Config->new(File => "t.dat/empty-config");
ok($config);

