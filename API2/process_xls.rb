#!/usr/bin/env ruby
# encoding: ASCII-8BIT
# dependencies

require 'json'
require 'yaml'
require 'open-uri'
require 'fileutils'
require 'curb'

class XLS_processor
	def initialize(*)
	@root_data_dir = File.dirname(__FILE__)+'/data/'
	@root_tmp_dir = File.dirname(__FILE__)+'/.tmp/'
	end
	
	def scrap_xml()
		opendata = nonopendata = 0
		dirs = Dir[@root_data_dir+'*'].map { |a| File.basename(a) }
		# p dirs
		dirs.each do |d|
			files =	Dir[@root_data_dir+d+'/*.json']
			
			files.each do |f|
				 File.open(f, "r" ) do |ds|
					 dataset = JSON.load( ds )
					 # p dataset
					 # p dataset['has_xls']
					 
					 if (dataset['has_xls']&&(dataset['has_csv']||dataset['has_xml']||dataset['has_json']))
						 p dataset['name'] + ' has open data ' 
						 opendata = opendata+1
					 elsif dataset['has_xls']
						nonopendata = nonopendata+1
					 end
				end
			end
			
		
		end
		p 'opendata counter : '+opendata.to_s
		p 'non opendata counter : '+nonopendata.to_s 
	 end
	
	def run
	scrap_xml()
	end

end
end
XLS_processor.new().run()