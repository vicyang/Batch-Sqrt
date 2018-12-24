STDOUT->autoflush(1);


sub bignum_plus 
{
    my ($num_a, $num_b) = @_;
    my $len_a = length($num_a);
    my $len_b = length($num_b);

    if ($len_b > $len_a) {
        ($num_a, $num_b) = ($num_b, $num_a);
        $len_a = $len_b;
    }

    

}