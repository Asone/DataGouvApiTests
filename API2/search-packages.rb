#!/usr/bin/env ruby
# encoding: ASCII-8BIT


# dependencies
require 'open-uri'
require 'json'
require 'yaml'
require 'fileutils'
require 'curb'

#configuration
Conf = YAML.load_file("../config.yml")

	#search class
	class DataGouvSearch
	
	def initialize(*args)
	#p args
		@api_url = 'http://qa.data.gouv.fr/api/1/datasets?organization='
		@local_index = '../'+Conf[:dir][:data]
		if !ARGV[2]
		@outputs = '../'+Conf[:dir][:outputs]+'output-'+ARGV[1]+'-'+ARGV[0]+'.json'
		else
		@outputs = ARGV[2] 
		end  
	end
	
	def dispatcher(entity,keyword)
		 output = []
		case entity
			when 'packages'
			
			# search for resources with keyword in description/name 
			
			#get organization dirs
			dirs = Dir[@local_index+'*/'].map { |a| File.basename(a) }
			dirs.each do |d|
				
				#loop into organizations index json files
				File.open(@local_index+d+'/index.json', "r" ) do |org_idx|
				b = {'org' => d, 'packages' => [] }
					JSON.load( org_idx )['packages'].each do |pack|
						#look into fields for keyword
						if pack.include? keyword
						 #if matching store into hash
						 b['packages'].push(pack)
						end
					end
					if b['packages'].length > 0
						output.push(b)
					end 
				end
			end
			
			# search for packages with keyword in name
			when 'organization'
				
				dirs = Dir[@local_index+'*/'].map { |a| File.basename(a) }
				output = []	
				
				dirs.each do |d|
			
				if d.include? keyword
					b = {'org' => d, 'packages' => [] }
					JSON.load( File.open(@local_index+d+'/index.json', "r" ) )['packages'].each do |pack|
						b['packages'].push(pack)
					end
				output.push(b)
				
				end
				end
			
			# search for packages with organization containing keyword
			when 'resources'
			# search for resources with keyword in description/name 
			
			#get organization dirs
				#loop into .json files
				#look into fields for keyword
				
				#if matching store into hash
				#write json output in to output folder
			else
			#other commands
		end
		if output.length > 0
		
		 File.open(@outputs,'w'){|f| f.write output.to_json }

		end
	end
	
	def search_error(type)
	end
	
	def generate_output
	
	#File.open('','w'){|f| f.write orga_index.to_json }
	end
	
	def run(entity,keyword)
		if !entity 
	
			exit
		end
		dispatcher(entity,keyword)
	end

end
#p ARGV
if !ARGV||!ARGV[0]||!ARGV[1]
	puts 'missing parameter value. command is : ruby search-packages.rb <type> <keyword>'
else
	DataGouvSearch.new(*ARGV).run(*ARGV[0],*ARGV[1])
end