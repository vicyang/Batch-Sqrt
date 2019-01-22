use strict;
STDOUT->autoflush(1);

my $num_a = "9"x1000000;
my $num_b = 9;
#printf "%d\n", $num_a * $num_b;

#my $mp = mp_single( $num_a, $num_b );
#print $mp;


my $mp = mp_single_opt( $num_a, $num_b );
$mp = mp_single_opt("1230007", 9);
print $mp;


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
    my $pool = 0;
    my ($t, $res, $part);
    my @buff;
    $res = "";
    for ( my $ia=3; $ia<$la+3; $ia+=3 ) {
        $part = substr($a, -$ia, 3);
        $t = $part * $b + $pool,
        push @buff, sprintf("%03d", $t%1000);
        $pool=int($t/1000);
    }
    $res = join("", reverse @buff);
    return $res;
}
