use strict;
STDOUT->autoflush(1);

my $num_a = 999999;
my $num_b = 999999;  #single num
printf "%d\n", $num_a * $num_b;

bignum_mp( $num_a, $num_b );

sub bignum_mp
{
    my ($num_a, $num_b) = @_;
    my @buff;
    my $sid;
    my ($len_a, $len_b) = (length($num_a), length($num_b));

    for my $a ( 1 .. $len_a ) {
        $sid = $a-1;
        for my $b ( 1 .. $len_b ) {
            $buff[$sid++] += substr($num_a,-$a,1) * substr($num_b,-$b,1);
        }
    }

    for my $id ( 0 .. $#buff )
    {
        printf "%s%4s\n", " "x($sid-$id), scalar ( "${buff[$id]}");
    }

    MERGE:
    for my $id ( 0 .. $#buff )
    {
        next if ( $buff[$id] < 10 );
        $buff[$id+1] += int($buff[$id] / 10);
        $buff[$id] = $buff[$id] % 10;
    }

    printf "%s\n", join("", reverse @buff);
}




