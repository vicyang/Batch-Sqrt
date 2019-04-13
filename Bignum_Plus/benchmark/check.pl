use bigint 'a'=>9000;
STDOUT->autoflush(1);

srand(2);
for (1..50) { check() }

sub check
{
    my $a = int(rand(9))+1 .join "", map { int(rand(10)) } ( 1 .. rand(4000) );
    my $b = int(rand(9))+1 .join "", map { int(rand(10)) } ( 1 .. rand(4000) );

    my $res = `hongrk3.bat $a $b`;
    my $check = (0+$a)+$b;
    $res =~s/\r?\n$//;
    if ( $res eq $check ) {
        printf "%4d, %4d, correct\n", length($a), length($b);
    } else {
        printf "%4d, %4d, wrong\n", length($a), length($b);
    }
}