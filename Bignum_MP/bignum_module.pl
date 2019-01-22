use bignum;
use Time::HiRes qw/time/;
STDOUT->autoflush(1);
my $t1 = time();

my $num_a = "9"x10000000;
my $num_b = 9;
my $mp = $num_a * $num_b; 
#printf "%s\n", $mp;

my $t2 = time();
printf("Time used: %.2f\n", $t2-$t1);

