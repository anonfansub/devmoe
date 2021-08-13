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
my @hexa = (0,0,0,0,0,0,0,0,0,0,0);
my @mods =  (0, 5008, 5005, 5007, 5002, 5003, 5001);
my @styles = (0, 8000, 8100, 8200, 8400, 8300);
my @sums = (0, 0, 13, 27, 39, 51);
my @mock = (8400,8439,8401,8473,8242,8345,8347,5007,5002,5003,8300);
my $runepage  = '{"autoModifiedSelections":[],"current":false,"id":1219755005,
"isActive":false,"isDeletable":true,"isEditable":true,"isValid":true,"lastModified":1628301854132,
"name":"mock","order":0,"primaryStyleId":8400,"selectedPerkIds":[8439,8401,8473,8242,8345,8347,5007,5002,5003],"subStyleId":8300}';
my $xname = "mock";
my $ram = int(rand(1000));
my $rem = int(rand(157));

#start
print "champ riot code: ";
my $xamp = <>;
chomp($xamp);
if ($xamp < 1){
    open(FH, '<', "xamps.txt") or die $!;
    while(<FH>){ 
        $aux++;
        if ($rem == $aux){chomp; $xamp = $_; last;}
    }
    close(FH);
}
remock();   
clientset('lol-perks/v1/pages','lpset: ');
#end

sub remock{
    my $rex;
    while( my( $idx, $elem ) = each( @{$text} ) ){
        if( $elem->{'cid'} eq $xamp ){
            $rex = $elem->{'rsetup'};
            $xname = $elem->{'cname'};
            @hexa = split //, $rex;
            last;
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
    $runepage = "{
    \"autoModifiedSelections\": [],\"current\": false,\"id\": $ram,
    \"isActive\": false,\"isDeletable\": true,\"isEditable\": true,\"isValid\": true,
    \"lastModified\": 1628301854132,\"name\": \"devmoe $xname\",\"order\": 1,
    \"primaryStyleId\": ".$mock[0].",
    \"selectedPerkIds\": [".$mock[1].",".$mock[2].",".$mock[3].",".$mock[4].",".$mock[5].",".$mock[6].",".$mock[7].",".$mock[8].",".$mock[9]."],
    \"subStyleId\": ".$mock[10]."}"; 
}
sub getriot{
    my $param = $_[0] + $_[1];
    my $result = 'invalid';
    while( my ( $key, $obj ) = each( @{$text2} ) ){
        if( $key eq $param-1){
            $result =  $obj->{'riotid'};
            last;
        }
    }
    return $result;
}
sub clientset{    
    my ($auth,$port) = @{auth()};
    my $ua = LWP::UserAgent->new( ssl_opts => { verify_hostname => 0 }, protocols_allowed => ['https'] );
    my $uri = "https://127.0.0.1:$port/$_[0]";
    my $header = ['Accept' => 'application/json','Content-Type' => 'application/json','Authorization' => "Basic $auth"];
    my $req = HTTP::Request->new('POST', $uri, $header, $runepage);
    my $response = $ua->request($req);
    print $_[1];
    if ($response->is_success) {
        print $response->code, "\n";
    } else {
        print STDERR $response->status_line, "\n";
        die "rune add failed";
    }
}
sub auth{
    my $proc = `WMIC path win32_process get Caption,Commandline | find "--remoting-auth-token="`;
    if ($proc =~ /--remoting-auth-token=(\S+)".*?--app-port=(\d+)/) {
        return [ encode_base64(qq(\x72\x69\x6f\x74:$1)), $2 ]
    }
} 