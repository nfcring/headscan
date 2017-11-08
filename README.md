
# Headscan
Headscan uses securityheaders.io and scrapes the results from the
website. The owner of securityheaders.io has accepted the scraping of
data. When an API is made, this program will be rewritten.

This program gets apps.txt as input. Apps.txt is a plain text file
with a url to a web application, one web application on each line.

# Ubuntu installation
sudo apt-get install libwww-mechanize-perl libdatetime-perl

#Edit the apps.txt file
You need to edit the apps.txt file with the url's to your web
applications. One url on each line.

# Run the program
perl headscan.pl
Open the headscan.html in the headscan directory and see the results.

# Written by
Asbjørn Reglund Thorsen
