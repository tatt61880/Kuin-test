require 'find'
require 'open3'
require 'fileutils'

curDir = Dir.pwd
Dir::chdir("..")
dir = Dir.pwd

countOk = 0
countUnexpected = 0
Find.find(dir) {|fpath|
	Find.prune if(fpath == curDir)
	if fpath =~ /main.kn$/
		outputFile = curDir + "/output.txt"
		knDir = File::dirname(fpath)
		out, err, status = Open3.capture3("cmd.exe /Q /C \"kuincl -i #{fpath} -e cui -q > #{outputFile}\"")
		if FileUtils.cmp(outputFile, "#{knDir}/output.txt")
			countOk += 1
		else
			puts "Error: #{fpath}"
			countUnexpected += 1
		end
	end
}

puts "#{countOk}/#{countOk + countUnexpected}"
if countUnexpected == 0
	puts "Congratulations!"
else
	puts "Count for unexpected result = #{countUnexpected}."
end
