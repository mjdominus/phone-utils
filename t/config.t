
use Test::More tests => 3;

use_ok("PhoneUtils::Dispatcher::Config");

{
  my $config = 
    PhoneUtils::Dispatcher::Config->new(File => "t.dat/empty-config");
  ok($config);
  my @e = $config->entries();
  is(@e, 0);
}


