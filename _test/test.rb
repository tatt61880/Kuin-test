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
		out, err, status = Open3.capture3("cmd.exe /Q /C \"kuincl -i #{fpath} -e exe -s ../../KuinInKuin/build/deploy_exe/sys/ -q > #{tempFilepath}")
		if status == 0
			out, err, status = Open3.capture3("#{knDir}/out.exe > #{tempFilepath}")
			if FileUtils.cmp(tempFilepath, "#{knDir}/output.txt")
				countOk += 1
			else
				countUnexpected += 1
				puts "\nError: [#{fpath.sub(dir, "")}]"
			end
		else
			countUnexpected += 1
			puts "\nError: [#{fpath.sub(dir, "")}] status:[#{status}]"
			f = File.open(tempFilepath)
			s = f.read
			f.close
			print s
		end
	end
}
if File.exist?(tempFilepath)
	File.unlink tempFilepath
end

puts "#{countOk}/#{countOk + countUnexpected}"
if countUnexpected == 0
	puts "Congratulations!"
else
	puts "Count for unexpected result = #{countUnexpected}."
end

system("pause")
