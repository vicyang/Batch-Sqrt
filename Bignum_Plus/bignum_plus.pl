use strict;
STDOUT->autoflush(1);

bignum_plus("999999", "999999999");

srand(2);
grep { bignum_plus( int(rand(100000)), int(rand(100000)) ) } (1..10);

sub bignum_plus 
{
    my ($a, $b) = @_;
    my $max_len = length($a);
    $max_len = length($b) if length($b) > $max_len;

    my (@buff, $ea, $eb, $t);
    my $plus = 0;
    for my $c ( 1 .. $max_len )
    {
        $ea = substr( $a, -$c, 1 ) || 0;
        $eb = substr( $b, -$c, 1 ) || 0;
        $t = $ea + $eb + $plus,
            $buff[$c-1] = $t % 10,
            $plus = int($t/10);
    }

    $buff[$max_len] = $plus if ($plus != 0);
    printf "%s, %s sum= %s\t", $a, $b, join("", reverse @buff);

    # check
    use bignum;
    printf "check: %s\n", $a+$b;
    no bignum;
}