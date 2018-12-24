STDOUT->autoflush(1);

bignum_plus("999999", "999999999");

srand(2);
grep { bignum_plus( int(rand(100000)), int(rand(100000)) ) } (1..10);

sub bignum_plus 
{
    my ($num_a, $num_b) = @_;
    my $len_a = length($num_a);
    my $len_b = length($num_b);
    my $max_len = $len_a > $len_b ? $len_a : $len_b;

    my @buff;
    my $plus = 0;
    for my $c ( 1 .. $max_len )
    {
        $ea = substr( $num_a, -$c, 1 ) || 0;
        $eb = substr( $num_b, -$c, 1 ) || 0;
        $t = $ea + $eb + $plus,
        $buff[$c-1] = $t % 10,
        $plus = int($t/10);
    }

    $buff[$max_len] = $plus if ($plus != 0);
    printf "%s, %s sum= %s\t", $num_a, $num_b, join("", reverse @buff);
    # check
    use bignum;
    printf "check: %s\n", $num_a+$num_b;
    no bignum;
}