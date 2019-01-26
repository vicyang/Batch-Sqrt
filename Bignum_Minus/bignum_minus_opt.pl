use strict;
STDOUT->autoflush(1);

my $res = s_minus_opt("111111", "9999");

# srand(2);
# grep { bignum_plus( int(rand(100000)), int(rand(100000)) ) } (1..10);

# 暂时假设 a 长度大于 b
sub s_minus_opt
{
    my ($a, $b) = @_;
    my ($la, $lb) = (length($a), length($b));
    printf "%d\n", $a - $b;
    my ($cut, $div, $base);
    my ($t, $res, $part);
    my @buff;
    $cut = 0, $div = 3, $base = 10**$div;
    $res = "";
    my ($pa, $pb);
    for ( my $ia=$div; $ia<=$la+$div; $ia+=$div ) {
        $pa = substr($a, -$ia, $div), $pb = substr($b, -$ia, $div);
        $t = $pa - $pb - $cut;
        if ( $t < 0 ) {
            $t += $base*10, $cut = 1;
        } else {
            $cut = 0;
        }

        push @buff, sprintf("%0${div}d", $t % $base);
    }
    $res = join("", reverse @buff);
    #$res =~s/^0+//;
    print $res;
    return $res;
}
