
# Headscan
Headscan is a proof of concept program which uses securityheaders.io. It scrapes the results from the
website. The owner of securityheaders.io has accepted the scraping of
data. When an API is made, this program will be rewritten. The program was made to make developers and non technical people to be more interested in http security headers. After putting the resulting html on an info screen at workm people, technical and non-technical people got interested...quick. The use of the grading system makes it easier to understand.

This program gets apps.txt as input. Apps.txt is a plain text file
with a url to a web application, one web application on each line.

# Ubuntu installation
sudo apt-get install libwww-mechanize-perl libdatetime-perl

# Edit the apps.txt file
You need to edit the apps.txt file with the url's to your web
applications. One url on each line.

# Run the program
perl headscan.pl
Open headscan.html in a browser in the headscan directory and see the results.

# Written by
Asbjørn Reglund Thorsen
