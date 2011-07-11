#!/usr/bin/env ruby
# watch.rb by Ramiro Jr. Franco
# This is specifically designed for my work environment, but might prove useful to others
# This depends on 3 key pieces of information in a file in your home path called .watch-server
# which should look like this.
# wd_user = 'myusername'
# wd_pass = 'mypass'
# wd_server = 'ftp.myserver.com'
# obviously, you should make sure that your home path is safe and not shared
# I like putting the file in /usr/bin/ as just "watch" so I can call it anywhere, but you know, to each thier own.

require 'yaml'
require 'uri'
require 'net/ftp'

trap("SIGINT") { exit }
 
if ARGV.length < 2
  puts "Usage: #{$0} watchfolder path"
  puts "Example: #{$0} . /templates/columbian (no trailing slash)"
  exit
end

auth = YAML.load_file(ENV['HOME']+'/.watch-server')
ftp_user = auth['ftp_user']
ftp_pass = auth['ftp_pass']
ftp_server = auth['ftp_server']

dev_extension = 'dev'
filetypes = ['css','html','htm','php','rb','erb','js', 'scss', 'sass', 'py']
watchfolder = ARGV[0]
ftp_path = ARGV[1]
puts "Watching #{watchfolder} and subfolders for changes in project files..."
 
while true do
  files = []
  filetypes.each {|type|
    files += Dir.glob( File.join( watchfolder, "**", "*.#{type}" ) )
  }
  new_hash = files.collect {|f| [ f, File.stat(f).mtime.to_i ] }
  hash ||= new_hash
  diff_hash = new_hash - hash
 
  unless diff_hash.empty?
    hash = new_hash
    diff_hash.each do |df|
      puts "Detected change in #{df[0]}, uploading"
      # Upload the files to the specified webserver
      # df[0] contains an object with ["relative/path/from/where/script/was/run/the.file", timestamp]
      ftp = Net::FTP.open(ftp_server, ftp_user, ftp_pass)
      ftp.passive = true
      remotefilename = df[0].sub(watchfolder, ftp_path)
      puts "Uploading #{df[0]} to #{remotefilename}"
      ftp.putbinaryfile(df[0], remotefilename)
      ftp.close
      puts "Uploaded Succesfully."
    end
  end
 
  sleep 1
end