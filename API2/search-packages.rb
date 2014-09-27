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
		outputs = Conf[:dir][:outputs]
	end
	
	def dispatcher(entity,keyword)
	
		if !keyword
			puts 'missing keyword value. command is : ruby search-packages.rb <type> <keyword>'
			exit 
		end
		 output = []
		case entity
			when 'packages'
			
			# search for resources with keyword in description/name 
			
			#get organization dirs
			dirs = Dir[@local_index+'*/'].map { |a| File.basename(a) }
				
				dirs.each do |d|
					File.open(@local_index+d+'/index.json', "r" ) do |org_idx|
						JSON.load( org_idx )['packages'].each do |pack|
						if pack.include? keyword
						p pack
						end
					end
					
					
				end
				end
				
				#loop into organization index json file
				#look into fields for keyword
				
				#if matching store into hash
				#write json output in to output folder
			# search for packages with keyword in name
			when 'organization'
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
	end
	
	def search_error(type)
	end
	
	def generate_output
	
	#File.open(@data_dir+orga_metadata['value']['name'].to_s+'/index.json','w'){|f| f.write orga_index.to_json }
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