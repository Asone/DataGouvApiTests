require 'open-uri'
require 'json'
require 'yaml'
require 'fileutils'
require 'curb'

class Files_Scrapper
	
	def initialize(*args)
		if args[0]&&(args[0]=='all'||'open'||'crappy')
			@status_filter = args[0]
		else
			@status_filter = 'all'
		end
		if args[1] 
			@format_filter = args[1]
		else
			@format_filter= 'xls'
		end
		
		@root_data_dir = File.dirname(__FILE__)+'/data/'
		@root_tmp_dir = File.dirname(__FILE__)+'/.tmp/'
		@root_files_dir = File.dirname(__FILE__)+'/files/'
	end

	def download_files()
		dirs = Dir[@root_data_dir+'*'].map { |a| File.basename(a) }
		dirs.each do |d|
			files =	Dir[@root_data_dir+d+'/*.json']
			files.each do |f|
				 File.open(f, "r" ) do |ds|
					 dataset = JSON.load( ds )
					 
					  if(dataset['resources'])
					  case @status_filter
					  when 'all'
					  
					 # p 'process all formats files scrapping...'
					  when 'open'
					  
					  p 'process open format files scrapping...'
					  when 'crappy'
					  has_proprietary_format = dataset['resources'].find_index{|r| r['filetype'] == ('XLS'||'xls') }
					  has_open_format = dataset['resources'].find_index{|r| r['filetype'] == ('csv'||'CSV'||'json'||'JSON'||'xml'||'XML')}
					 # puts has_format
					  if(has_proprietary_format != nil)&&(has_open_format == nil)
					 	p dataset['resources'][has_proprietary_format]['url']
					  end
					 if (dataset['resources'].length > 0)
					#	p dataset['resources'].find_index{|r| r['filetype'] == 'CSV'||'csv' } 
						if Dir.exists?(@root_files_dir+d.to_s) != true
							 #	FileUtils::mkdir_p @data_dir+o.to_s
						end
					 end
				 end
			end
		end
	end
	end
	end
	def run
		download_files()
	end
end

Files_Scrapper.new(*ARGV).run()