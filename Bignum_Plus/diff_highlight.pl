use List::MoreUtils qw/pairwise mesh/;
use File::Slurp;

my ($f1, $f2) = ("hongrk2.bat", "hongrk3.bat");

my @s1 = `$f1`;
my @s2 = `$f2`;

my @foo = unpack("(A60)*", $s1[1]);
my @bar = unpack("(A60)*", $s2[1]);

for my $id ( 0 .. $#foo )
{
    mark( $foo[$id], $bar[$id] );
}

sub mark
{
    my @foo = (split("", $_[0]) , " ");
    my @bar = (split("", $_[1]) , " ");

    my $prev = 1;
    my $buf1 = "";
    my $buf2 = "";
    my $insert;
    for my $id ( 0 .. $#foo )
    {
        if ($foo[$id] ne $bar[$id]) {
            $buf1 .= ($prev == 1 ? "[color=blue]" : "") .$foo[$id];
            $buf2 .= ($prev == 1 ? "[color=red]" : "") .$bar[$id];
            $prev = 0;
        } else {
            $buf1 .= $foo[$id]. ($prev == 0 ? "[/color]" : "");
            $buf2 .= $bar[$id]. ($prev == 0 ? "[/color]" : "");
            $prev = 1;
        }
    }

    printf "%s  %s\n", $buf1, $buf2;
}