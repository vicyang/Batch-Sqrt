use strict;
use Time::HiRes qw/time/;
STDOUT->autoflush(1);

my $num_a = "9"x10000000;
my $num_b = 9;
#printf "%d\n", $num_a * $num_b;

#my $mp = mp_single( $num_a, $num_b );
#print $mp;

my $t1 = time();
my $mp = mp_single_opt( $num_a, $num_b );
$mp = mp_single_opt("987654", 2);
printf "%s\n", $mp;
my $t2 = time();
printf("Time used: %.2f\n", $t2-$t1);

sub mp_single
{
    my ($a, $b) = @_;
    my ($la, $lb) = (length($a), length($b));
    my $pool = 0;
    my ($t, $res);
    my @arr = split("", $a);
    $res = "";
    for ( my $ia = $la-1; $ia >= 0; $ia-- ) {
        $t = $arr[$ia] * $b + $pool,
        $res .= $t%10, $pool=int($t/10);
    }
    $res .= $pool if ($pool != 0);
    $res = reverse $res;
    return $res;
}

# opt01 字符串等分
sub mp_single_opt
{
    my ($a, $b) = @_;
    my ($la, $lb) = (length($a), length($b));
    my ($pool, $div, $base);
    my ($t, $res, $part);
    my @buff;
    $pool = 0, $div = 3, $base = 10**$div;
    $res = "";
    for ( my $ia=$div; $ia<=$la+$div; $ia+=$div ) {
        $part = substr($a, -$ia, $div);
        $t = $part * $b + $pool, $pool = int($t/$base);
        push @buff, sprintf("%0${div}d", $t % $base);
    }
    $res = join("", reverse @buff);
    #$res =~s/^0+//;
    return $res;
}
