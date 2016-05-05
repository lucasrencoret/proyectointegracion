require 'net/ftp' 
require 'net/ssh'
require 'net/sftp'
class Ftp < ActiveRecord::Base

def self.conecta()
    host = 'mare.ing.puc.cl'
    port = '22'
    user = 'integra9'
    password = 'cdFybj2t'
    
    
#upload a file or directory to the remote host
    #Rails.logger.info("Creating SFTP connection")
    #session=Net::SSH.start(host,user, :password=>password,:port=>port)
    #sftp=Net::SFTP::Session.new(session).connect!
    
    Net::SFTP.start(host,user, :password=>password) do |sftp|
    sftp.dir.foreach("/pedidos") do |entry|
            puts entry.longname
            if entry.file?()
                sftp.download!("/pedidos/"+entry.name, "/Users/lucasrencoret/Desktop/test/"+entry.name)
                puts "lo baje!"
            end
    end
    
        
  # upload a file or directory to the remote host
        #sftp.upload!("/path/to/local", "/path/to/remote")

  # download a file or directory from the remote host
        #

  # grab data off the remote host directly to a buffer
        #data = sftp.download!("/path/to/remote")

  # open and write to a pseudo-IO for a remote file
        #sftp.file.open("/path/to/remote", "w") do |f|
        #    f.puts "Hello, world!\n"
        #end

  # open and read from a pseudo-IO for a remote file
        #sftp.file.open("/path/to/remote", "r") do |f|
        #    puts f.gets
        #end

  # create a directory
        #sftp.mkdir! "/test"

  # list the entries in a directory
        
    end

end


end
