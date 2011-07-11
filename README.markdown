# watch.rb

This script is meant to allow you to watch a directory, and have the files that you save / modify in there get actively uploaded to a corresponding directory on a remote FTP server. It can easily be adapted to SFTP / WebDav, but this fits my needs in my current development environment.

You need to have a file in your home path named .watch-server (sample is provided) with the following information for this to work:

ftp_user: myusername
ftp_pass: mypassword
ftp_server: ftp.myserver.com

If you have any questions, or comments, feel free to drop me a line.
[Ramiro Jr. Franco](mailto:rjfranco@gmail.com)