#
pg_name = 'merge_all.rb'
my_name = 'Gary Dohmeier'
puts "Begin: #{pg_name}."
#
# using rrd merging script and this wrapper to merge old rrd data and new rrd data
# into a new file and leave that in place of the new rrd file
#
#
# use this os command to build a list of dirs in file dir.txt
# since i have a naming convention, its easier for the merge all
#
#   locate value.rrd | grep selenium%3 > dirs.txt
#
# naming convention
#  older data
#   /usr/local/nagios/var/rrd/th%2Dselenium/selenium_passive_check%3A%20test_merge/ExecTime/value.rrd
#  newer data
#   /usr/local/nagios/var/rrd/th%2Dselenium/selenium%3A%20test_merge/ExecTime/value.rrd
#
# the magical command
# ./rrdtool-merge.pl -oldrrd=./value.rrd --newrrd=./value1.rrd --mergedrrd=./new.rrd -rrdtool=/usr/bin/rrdtool
#  
#  you need the following to run the above
#  you need to test it on single files first too... befor you unleash this, as there is no error checking in this
#  link 
#  link
#
# 3 steps  w exaples
#  1. cp existing 'newer data' file to backup
#	cp /path-new/ExecTime/value.rrd /path-new/ExecTime/value.rrd.backup
#  2. run command to merge files
#	./rrdtool-merge.pl -oldrrd=/path-old/ExecTime/value.rrd --newrrd=/path-new/ExecTime/value.rrd --mergedrrd=/pathnew/ExecTime/merged.rrd -rrdtool=/usr/bin/rrdtool
#  3. rename merged file to orig nam
#	mv -f /path-new/ExecTime/merged.rrd /path-new/ExecTime/value.rrd
#
#
#
print "Type the filename: "
file_again = $stdin.gets.chomp

line_num=0
text = open(file_again).read
text.gsub!(/\r\n?/, "\n")
text.each_line do |line|
	s = "#{line}"

	#print "#{line_num += 1}"
	#puts
	#print "input line = #{line} "

	puts
	cmd_bkupfile=s.sub('value.rrd', 'value.rrd.bkup')
	#print "bkupfile   = #{cmd_bkupfile.strip}"
	#puts
	cmd_oldfile=s.sub('/selenium%3A', '/selenium_passive_check%3A')
	#print "oldfile    = #{cmd_oldfile.strip}"
	#puts
	cmd_newfile = "#{line.strip}"
	#print "newfile    = #{cmd_newfile.strip}" 
	#puts
	cmd_mergedfile=s.sub('value.rrd', 'merged.rrd')
	#print "mergedfile = #{cmd_mergedfile.strip}" 
	#puts

	print "run command: cp #{cmd_newfile.strip} #{cmd_bkupfile.strip}" 
	output = `cp #{cmd_newfile.strip} #{cmd_bkupfile.strip}` 
	puts output
	puts

	print "run command: ./rrdtool-merge.pl -oldrrd=#{cmd_oldfile.strip} --newrrd=#{cmd_newfile.strip} --mergedrrd=#{cmd_mergedfile.strip} -rrdtool=/usr/bin/rrdtool"
	output = `./rrdtool-merge.pl -oldrrd=#{cmd_oldfile.strip} --newrrd=#{cmd_newfile.strip} --mergedrrd=#{cmd_mergedfile.strip} -rrdtool=/usr/bin/rrdtool`
	puts output
	puts

	print "run command: mv -f #{cmd_mergedfile.strip} #{cmd_newfile.strip}" 
	output = `mv -f #{cmd_mergedfile.strip} #{cmd_newfile.strip}`
	puts output
	puts
	puts "Hit control-c to quit..."
	puts
	sleep 2

end

puts 
puts ".End: #{pg_name}."
puts ".Written by: #{my_name}."
puts

exit
