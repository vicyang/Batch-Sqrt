use Encode;
use List::Util qw/max/;
STDOUT->autoflush(1);

my $num_a = 123456;
my $num_b = 9999;  #single num
printf "%d\n", $num_a * $num_b;

my @ele_a = reverse split("", $num_a );
my @ele_b = reverse split("", $num_b );

my @buff;
my ($foo, $bar, $mp);
my ( $id, $sid ) = (0, 0);
my $t;

for my $eb ( @ele_b )
{
    $sid = $id;
    for my $ea (@ele_a)
    {
        $mp = $ea * $eb;
        $foo = int( $mp/10 );
        $bar = $mp % 10;

        if (defined $buff[$sid]) { $buff[$sid] += $bar; }
        else  { $buff[$sid] = $bar; }

        if (defined $buff[$sid+1]) { $buff[$sid+1] += $foo; }
        else  { $buff[$sid+1] = $foo; }

        $sid++;
    }
    $id++;
}

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

printf "%s\n", join("", reverse @buff);




