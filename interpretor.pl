use strict;
use warnings;
use JSON;
use Data::Dumper;
use Switch;
use MIME::Base64;
use LWP::Simple;
use LWP::UserAgent;

my $json = "";
my $json2 = "";

open(FH, '<', "runes.json") or die $!;
while(<FH>){ $json = $json.$_;}
close(FH);
open(FH, '<', "runemap.json") or die $!;
while(<FH>){ $json2 = $json2.$_;}
close(FH);

my $text = decode_json($json);
my $text2 = decode_json($json2);
my $aux = 0;
my @xamps = (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,48,50,51,53,54,55,56,57,58,59,60,61,62,63,64,67,68,69,72,74,75,76,77,78,79,80,81,82,83,84,85,86,89,90,91,92,96,98,99,101,102,103,104,105,106,107,110,111,112,113,114,115,117,119,120,121,122,126,127,131,133,134,136,141,142,143,145,150,154,157,161,163,164,166,166,166,166,166,166,166,201,202,203,222,223,235,236,238,240,245,246,254,266,267,268,350,412,420,421,427,429,432,497,498,516,517,518,523,555,777,875,876);
my @hexa = (0,0,0,0,0,0,0,0,0,0,0);
my @mods =  ("", "adp dmg", "atk sp", "cdr", "armor", "mr", "health");
my @styles = (0, 8000, 8100, 8200, 8400, 8300);
my @sums = (0, 0, 13, 27, 39, 51);
my @mock = (8400,8439,8401,8473,8242,8345,8347,5007,5002,5003,8300);
my $runepage  = '{"autoModifiedSelections":[],"current":false,"id":1219755005,
"isActive":false,"isDeletable":true,"isEditable":true,"isValid":true,"lastModified":1628301854132,
"name":"mock","order":0,"primaryStyleId":8400,"selectedPerkIds":[8439,8401,8473,8242,8345,8347,5007,5002,5003],"subStyleId":8300}';
my $xname = "mock";
my $ram = 0;
my $filename = 'xamps.txt';
#start
open(FH, '>', $filename) or die $!;
for my $i (0 .. $#xamps) {
    remock($xamps[$i]);
}
close(FH);
print "Writing to file successfully!\n";
#end

sub remock{
    my $rex;
    my $iter = $text;
    $ram++;
    while( my( $idx, $elem ) = each( @{$iter} ) ){
        if( $elem->{'cid'} eq $_[0] ){
            $rex = $elem->{'rsetup'};
            $xname = $elem->{'cname'};
            @hexa = split //, $rex;
        }
    }        
    my $mod = $sums[$hexa[0]];
    my $mod2 = $sums[$hexa[5]];
    $mock[0] = $styles[$hexa[0]];
    $mock[1] = getriot($hexa[1],$mod);
    $mock[2] = getriot($hexa[2],$mod);
    $mock[3] = getriot(hex $hexa[3],$mod);
    $mock[4] = getriot(hex $hexa[4],$mod);
    $mock[5] = getriot(hex $hexa[6],$mod2);
    if ($mock[5] eq 'invalid'){ $mock[5] = getriot(hex $hexa[6],$mod2); } #force each loop to reset
    $mock[6] = getriot(hex $hexa[7],$mod2);
    $mock[7] = $mods[$hexa[8]];
    $mock[8] = $mods[$hexa[9]];
    $mock[9] = $mods[$hexa[10]];
    $mock[10] = $styles[$hexa[5]];
    $runepage = "$ram $xname"
    ."\n".$mock[1]." / ".$mock[2]." / ".$mock[3]." / ".$mock[4]
    ."\n".$mock[5]." / ".$mock[6]
    ."\n".$mock[7]." / ".$mock[8]." / ".$mock[9]."\n\n"; 
    print FH $runepage;
}
sub getriot{
    my $iter2 = $text2;
    my $param = $_[0] + $_[1];
    my $result = 'invalid';
    while( my ( $key, $obj ) = each( @{$iter2} ) ){
        if( $key eq $param-1){
            $result =  $obj->{'eng'};
        }
    }
    return $result;
}