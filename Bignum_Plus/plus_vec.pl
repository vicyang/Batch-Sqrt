# 2019-04-12 not finish yet
use strict;
STDOUT->autoflush(1);

our $BASE=10**9;
our $LEN = 9;
our $MASK=substr($BASE, 1);

my $num_a="456456521000210000000000000000874112115674511111111111111110019999999";
my $num_b="923451344221111111111111111000000000001";
grep {  $num_a = $num_a .$num_a; $num_b = $num_b .$num_b  } (1..6);
plus($num_a, $num_b);

sub plus
{
    my ($va, $vb) = @_;
    my $sum = "";
    my ($t, $carry, $head);
    while (1) {
        $a = substr($va, -$LEN), $b = substr($vb, -$LEN) ;
        $va = substr($va, 0, -$LEN), $vb = substr($vb, 0, -$LEN);
        $t = $a + $b + $carry, $carry = int($t/$BASE), $head = $t, $t = substr($MASK .$t, -$LEN);
        last if ( $va eq "" and $vb eq "" );
        $sum = $t . $sum;
    }
    print $head .$sum;
}
