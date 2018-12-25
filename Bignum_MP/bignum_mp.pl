use Encode;
use List::Util qw/max/;
STDOUT->autoflush(1);

my $num_a = 123456;
my $num_b = 9999;  #single num
printf "%d\n", $num_a * $num_b;

bignum_mp( $num_a, $num_b );

sub bignum_mp
{
    my ($num_a, $num_b) = @_;
    my @buff;
    my $sid;

    for my $ia ( 1 .. length($num_a) ) {
        $sid = $ia-1;
        for my $ib ( 1 .. length($num_b) ) {
            $buff[$sid++] += substr($num_a, -$ia, 1) * substr($num_b, -$ib, 1);
        }
    }


    # for my $eb ( @ele_b )
    # {
    #     $sid = $id;
    #     for my $ea ( @ele_a )
    #     {
    #         $buff[$sid] += $ea * $eb;
    #         $sid++;
    #     }
    #     $id++;
    # }

    for my $id ( 0 .. $#buff )
    {
        printf "%s%s\n", " "x$id, scalar reverse( "${buff[$id]}");
    }

    MERGE: #合并
    for my $id ( 0 .. $#buff )
    {
        if ( $buff[$id] >= 10 )
        {
            $buff[$id+1] += int($buff[$id] / 10);
            $buff[$id] = $buff[$id] % 10;
        }
    }

    printf "%s\n", join("", @buff);
}




