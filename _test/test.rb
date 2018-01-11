require 'find'
require 'open3'
require 'fileutils'

curDir = Dir.pwd
Dir::chdir("..")
dir = Dir.pwd

tempFilename = "__temp__.txt"
tempFilepath = "#{curDir}/#{tempFilename}"

countOk = 0
countUnexpected = 0
Find.find(dir) {|fpath|
	Find.prune if(fpath == curDir)
	if fpath =~ /main.kn$/
		knDir = File::dirname(fpath)
		out, err, status = Open3.capture3("cmd.exe /Q /C \"kuincl -i #{fpath} -e cui -q")
		if status == 0
			out, err, status = Open3.capture3("#{knDir}/out.exe > #{tempFilepath}")
			if FileUtils.cmp(tempFilepath, "#{knDir}/output.txt")
				countOk += 1
			else
				puts "Error: [#{fpath.sub(dir, "")}]"
				countUnexpected += 1
			end
		else
			puts "Error: [#{fpath.sub(dir, "")}] status:[#{status}]"
			countUnexpected += 1
		end
	end
}
File.unlink tempFilepath

puts "#{countOk}/#{countOk + countUnexpected}"
if countUnexpected == 0
	puts "Congratulations!"
else
	puts "Count for unexpected result = #{countUnexpected}."
end

system("pause")
