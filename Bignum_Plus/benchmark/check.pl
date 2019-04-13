use Time::HiRes qw/time/;
use bigint 'a'=>9000;
STDOUT->autoflush(1);

srand(1);
for (1..50) { check() }

sub check
{
    my $a = int(rand(9))+1 .join "", map { int(rand(10)) } ( 1 .. rand(4100) );
    my $b = int(rand(9))+1 .join "", map { int(rand(10)) } ( 1 .. rand(4100) );

    if ( length($b) > length($a) ) { ($a, $b) = ($b, $a); }
    my $ta = time();
    my $res = `plus_vec4.bat $a $b`;
    #my $res = `hongrk3.bat $a $b`;
    my $dt = time()-$ta;
    my $check = (0+$a)+$b;
    $res =~s/\r?\n$//;
    if ( $res eq $check ) {
        printf "%4d, %4d, correct, %.2fs\n", length($a), length($b), $dt;
    } else {
        printf "%4d, %4d, wrong, %.2fs\n", length($a), length($b), $dt;
    }
}
