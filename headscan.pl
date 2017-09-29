#!/usr/bin/perl -w
use strict;
use WWW::Mechanize;
use Date::Parse;
use DateTime;

my $start_run = time();
my $mech = WWW::Mechanize->new(autocheck => 1,
			       ssl_opts => { verify_hostname => 0 } );
my $filename_working = '/uio/kant/div-ceres-u1/asbjornt/www_docs/headscan_tmp.html';
my $filename_finished = '/uio/kant/div-ceres-u1/asbjornt/www_docs/headscan.html';
my $apps_filename = "apps.txt";
my $fh;
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
    <head><link rel='stylesheet' type='text/css' href='sslscan.css'></head>
    <body>
      <table>
         <tr>
           <th>URL</th></th><th>Header grade</th>
END

print $fh $html_top;

chmod 0644,$filename_working;

foreach(@ips){
    my $header_grade="";
    my $header_url = "https://securityheaders.io/?q=https://$_%2F&hide=on&followRedirects=on";
    $mech->get($header_url);
    my $header_page = $mech->content;
    
    if($header_page =~ m/<div class="score_.*"><span>(\w{1})<\/span><\/div>/){
        $header_grade=$1;
    } else {
	die("No header grade, something is wrong!");
    }
    
    my $html_middle = << "END";
    <tr>
        <td>$_</td>
        <td><a href="https://securityheaders.io/?q=https://$_%2F&hide=on&followRedirects=on" target="_blank" rel="nofollow">$header_grade</a></td>
    </tr>
END

print $fh $html_middle;

}
    my $timestamp = localtime(time());
    my $end_run = time();
    my $run_time = sprintf("%.1f",($end_run - $start_run));
    
    
    my $html_bottom = << "END";
    <tr>
	<td colspan="2">Last updated: $timestamp, total runtime: $run_time seconds</td>
     </tr>
    <tr>
       <td colspan="2">Based on securityheaders.io</td>
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
	
