use strict;
STDOUT->autoflush(1);

bignum_minus("999999", "999999999");

# srand(2);
# grep { bignum_plus( int(rand(100000)), int(rand(100000)) ) } (1..10);

sub bignum_minus
{
    my ($a, $b) = @_;

    my ($len_a, $len_b) = (length($a), length($b));

    # check
    use bignum;
    printf "check: %s\n", $a-$b;
    no bignum;
}