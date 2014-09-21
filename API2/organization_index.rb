#!/usr/bin/env ruby
# encoding: ASCII-8BIT
# dependencies
require 'open-uri'
require 'json'
require 'curb'
require 'fileutils'

class DataGouv_Orgnizations_db
	
	def initialize(*)
		  @base_url = "http://www.data.gouv.fr/api/3/action/"
	    @base_url_qa = "http://qa.data.gouv.fr/api/1/"
	    @public_url = "http://www.data.gouv.fr/fr/"
	    @data_dir = File.dirname(__FILE__)+'../dataAPI2/'
	    @files_dir = File.dirname(__FILE__)+'../files/'
	    
	end
	
	def build_full_hierarchy()
	c = 0
	url = @base_url_qa+'organizations'
	orgas = JSON.parse(Curl.get(url).body_str)
	organizations_full = []
	organization_base_set = []
 		orgas['value'].each do |o|
 			
 			orga_url = @base_url_qa+'organizations/'+o
  			# datasets_url = @base_url_qa+'datasets/?organization='
  			orga_metadata = JSON.parse(Curl.get(orga_url).body_str)
 			orga_datasets = orga_metadata['value']['packages']
 			 			
 	
 			datasets =  []
 			
 			# build orgnizations folders 
 			
 			if Dir.exists?(@data_dir+orga_metadata['value']['name'].to_s) != true
 				FileUtils::mkdir_p @data_dir+orga_metadata['value']['name'].to_s
 			end
 			
 			orga_index = {'org' => orga_metadata['value']['name'].to_s, 'packages' => [] }

     		if orga_datasets != nil
	 			orga_datasets.each do |pack|
		 			
		 			resources = [] 
	 				orga_index['packages'].push(pack['name'])
	 				
	 				
	 				url = @base_url_qa+'datasets/'+pack['id']
	 				package_metadata = JSON.parse(Curl.get(url).body_str)
	 			
		 				if !package_metadata['error']
		 					p package_metadata['value']['num_resources']
							if package_metadata['value']['num_resources'].to_i > 0		 					
				 				package_metadata['value']['resources'].each do |r|
					 			
					 				resources.push({'url' => r['url'],'filetype' => r['format'],'name' => r['name'] })
					 				
				 				end
				 			dataset = { 'name' => pack['name'], 'resources' => resources }
				 			datasets.push(dataset)
				 			File.open(@data_dir+orga_metadata['value']['name'].to_s+'/'+pack['name']+'.json', 'w') {|f| f.write dataset.to_json }
				 			end
			 			#		resources.push({'url' => ['url'],'filetype' => r['format'],'name' => r['name'] })
			 					file_url = @data_dir+orga_metadata['value']['name'].to_s+'/'+package_metadata['value']['name']+'.json'
			 			end
			 			
		 			
			 	end
			 	File.open(@data_dir+orga_metadata['value']['name'].to_s+'/index.json','w'){|f| f.write orga_index.to_json }
			 #	File.open(@data_dir+o.to_s+'/index.json','w'){|f| f.write orga_index.to_json }
 			end
 	end
 	end
	
	def run
	 data = build_full_hierarchy()
	end
end
DataGouv_Orgnizations_db.new().run()
