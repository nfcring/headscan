#!/usr/bin/perl -w
use strict;
use WWW::Mechanize;
use Date::Parse;
use DateTime;

my $start_run = time();
my $mech = WWW::Mechanize->new(autocheck => 1,
			       ssl_opts => { verify_hostname => 0 } );
my $filename_working = 'headscan_tmp.html';
my $filename_finished = 'headscan.html';
my $apps_filename = "apps.txt";
my $fh;
my @missing_red;
my @missing_orange;
my @ips;

open($fh, '<:encoding(UTF-8)', $apps_filename)
    or die "Could not open file '$apps_filename' $!";

while (my $row = <$fh>) {
    chomp $row;
    push(@ips,$row);
}

open($fh, '>', $filename_working)
    or die "Could not open file '$filename_working' $!";

my $html_top = << "END";
<html>
    <head>
<style>
    table {
        font-size:30pt;
      width:100%;
      height:100%;
        border-collapse: collapse;
}

td, th {
  border: 1px solid black;
  padding: 3px;
}
</style>
    </head>
    <body>
      <table>
         <tr>
           <th>URL</th></th><th>Grade</th><th>Missing Headers</th>
END

print $fh $html_top;

chmod 0644,$filename_working;

foreach(@ips){
    @missing_red=();
    @missing_orange=();
    my $header_grade="";
    my $header_url = "https://securityheaders.io/?q=https://$_%2F&hide=on&followRedirects=on";
    $mech->get($header_url);
    my $header_page = $mech->content;
    
    if($header_page =~ m/<div class="score_.*"><span>(\w+\+?)<\/span><\/div>/){
        $header_grade = $1;
    } else {
	$header_grade = "error";
    }
    
    while($header_page =~ m/<i class="fa fa-times"><\/i>(.*?)<\/li>/g){
	push(@missing_red,$1);
    } 

    while($header_page =~ m/<li class="headerItem pill pill-orange"><i class="fa fa-question"><\/i>(.*)<\/li>/g){
	push(@missing_orange,$1);
    } 
    
    my $missing_result_red = join(" ",@missing_red);
    my $missing_result_orange = join(" ",@missing_orange);
    my $html_middle = << "END";
    <tr>
        <td>$_</td>
        <td><a href="https://securityheaders.io/?q=https://$_%2F&hide=on&followRedirects=on" target="_blank" rel="nofollow">$header_grade</a></td><td><font size="5pt" color="red">$missing_result_red</font><font size="5" color="orange"> $missing_result_orange</td>
    </tr>
END

print $fh $html_middle;

}
    my $timestamp = localtime(time());
    my $end_run = time();
    my $run_time = sprintf("%.1f",($end_run - $start_run));
    
    
    my $html_bottom = << "END";
    <tr>
	<td colspan="3">Last updated: $timestamp, total runtime: $run_time seconds</td>
     </tr>
    <tr>
       <td colspan="3">Based on securityheaders.io</td>
    </tr>
   </table>
  </body>
</html>
END


print $fh $html_bottom;

close $fh;
    
#Copy working file to prod file
use File::Copy;
move($filename_working,$filename_finished)
	
