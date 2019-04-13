use List::MoreUtils qw/pairwise mesh/;
use File::Slurp;

#my ($f1, $f2) = ("hongrk2.bat", "hongrk3.bat");
my ($f1, $f2) = ("hongrk2.bat", "plus_vec2_fo1.bat");

my @s1 = `$f1`;
my @s2 = `$f2`;

my @foo = unpack("(A40)*", $s1[1]);
my @bar = unpack("(A40)*", $s2[1]);

printf "%40s   %40s\n", $f1, $f2;
pairwise { printf "%s %s %s\n", $a, $a eq $b?" ":"!", $b } @foo, @bar;

