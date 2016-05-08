# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
 #every 2.hours do
 #  command "/usr/bin/some_great_command"
 #  runner "MyModel.some_method"
 #  rake "some:great:rake:task"
 #end
#
 every 4.minutes do
   runner "Ftp.conecta()", :environment => "development", :output => 'log/check_status_update.log'
 end
  every 250.minutos do
   runner "Bodega.logicaCacaos", :environment => "development"
 end
 every 90.minutes do
   runner "Bodega.logicaAbastecerChocolate", :environment => "development"
 end
 every 150.minutes do
   runner "Bodega.logicaAbastecerPasta", :environment => "development"
 end
 every 121.minutes do
   runner "Bodega.logicaAbastecerHamb", :environment => "development"
 end
 every 20.minutes do
   runner "Bodega.logicaHacerChocolate", :environment => "development"
 end
  every 20.minutes do
   runner "Bodega.logicaHacerPasta", :environment => "development"
 end
  every 20.minutes do
   runner "Bodega.logicaHacerHamb", :environment => "development"
 end
   every 30.minutes do
   runner "Bodega.vaciarRecepcion", :environment => "development"
 end
# Learn more: http://github.com/javan/whenever
