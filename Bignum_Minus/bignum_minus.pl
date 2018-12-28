use strict;
STDOUT->autoflush(1);

bignum_minus("99999", "999999999");

# srand(2);
# grep { bignum_plus( int(rand(100000)), int(rand(100000)) ) } (1..10);

sub bignum_minus
{
    my ($a, $b) = @_;
    my ($len_a, $len_b) = (length($a), length($b));

    my @buff;
    my $max = $len_a > $len_b ? $len_a : $len_b;
    my ($dt, $minus);
    for my $id ( 1 .. $max )
    {
        if ( $id <= $len_b )
        {
            $dt = substr($a, -$id, 1) - substr($b, -$id, 1) - $minus;
        } else {
            $dt = substr($a, -$id, 1) - $minus;
        }

        if ($dt < 0)
        {
            $buff[$id] = $dt+10, $minus = 1
        } else {
            $buff[$id] = $dt, $minus = 0
        }
    }

    printf "%s\n", join("", @buff);


    # check
    use bignum;
    printf "check: %s\n", $a-$b;
    no bignum;
}