#!/usr/bin/env ruby
# encoding: ASCII-8BIT
# dependencies
require 'open-uri'
require 'json'
require 'curb'
require 'fileutils'

class DataGouv_Formats
	
	def initialize(*)
		@data_root_dir = File.dirname(__FILE__)+'/data/'
		
	end

	def Build_formats_index()
	dirs = Dir[@data_root_dir+'*'].map { |a| File.basename(a) }
		dirs.each do |d|
		
	 	files =	Dir[@data_root_dir+d+'/*.json']
		
		files.each do |f|
			 File.open(f, "r" ) do |ds|
				 dataset = JSON.load( ds )
				 if dataset['resources']
					a = dataset['resources'].find_index{|r| r['filetype'] == 'CSV'||'JSON' }
					b = dataset['resources'].find_index{ |r| r['filetype'] == 'XLS'||'xls' }
					if b != nil 
						dataset['has_xls'] = true 
						p dataset
					end
				 end
				 File.open(f, 'w') {|nf| nf.write dataset.to_json } 
			 end
		end
		
		end
	
	end
	
	def run
	Build_formats_index()
	end

end
DataGouv_Formats.new().run()