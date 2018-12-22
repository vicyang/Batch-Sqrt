use bignum 'a'=>80;
our $num = 5;
my $a = 4;

for my $it ( 1 .. 8 ) {
    $a = ($a+$num/$a)/2;
    printf "%s\n", $a;
}

printf "sqrt(%d)\n", $num;
printf "%s\n", sqrt($num);

no bignum;

# Rational Number Solution
{
    use bigint;
    our $num;
    my $x=$num;
    my $a = {n => 6, m => 1};

    grep {
        $a = { 
               n => $a->{n}**2 + $a->{m}**2 * $x,
               m => $a->{m} * $a->{n} * 2
             };
    } (1..9);

    printf "%s\n", $a->{n}/$a->{m};
    printf "%s\n%s\n", $a->{n}, $a->{m};

}

