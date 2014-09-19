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
	    @data_dir = File.dirname(__FILE__)+'../data/'
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
 			 			
 		#	 orga_metadata['value']['name']
 			# p orga_datasets
 			datasets =  []
 			
 			# build orgnizations folders 
 			
 			if Dir.exists?(@data_dir+orga_metadata['value']['name'].to_s) != true
 				FileUtils::mkdir_p @data_dir+o.to_s
 			end
 			
 			orga_index = {'org' => orga_metadata['value']['name'].to_s, 'packages' => [] }
 #			
     		if orga_datasets != nil
	 			orga_datasets.each do |pack|
	 		#	 p pack
	 				orga_index['packages'].push(pack['name'])
	 				
	 				#p pack['id']
	 				
	 				url = @base_url_qa+'datasets/'+pack['id']
	 			#	p url
	 				package_metadata = JSON.parse(Curl.get(url).body_str)
	 				if !package_metadata['error']
	 				p package_metadata['value']['resources']
	 				end
	 			#		p package_metadata
	 			#	if package_metadata['value']['resources'] != nil
	 			#		p package_metadata['value']['resources']
	 			#	end			
	 #				resources = [] 
	 #				
	 #				p pack['name']
	 #				# @data_dir+o.to_s+'/'+pack['name']+'.json'
	 #				#p package_metadata['result']
	 #				package_metadata['result']['resources'].each do |r|
	 #				p r['url']
	 #					resources.push({'url' => r['url'],'filetype' => r['format'],'name' => r['name'] })
	 #					# p  'org : '+o.to_s+' - pack : '+ pack['name']+'  - rsc : '+r['format'].to_s+' count : '+c.to_s
	 #				end
	 #				
	 #				dataset = { 'name' => pack['name'], 'resources' => resources }
	 #				datasets.push(dataset)
	 #				File.open(@data_dir+o.to_s+'/'+pack['name']+'.json', 'w') {|f| f.write dataset.to_json }
	 #				sleep(1.0/3.0)
	 	
 			end
 #				organization = {'name' => o, 'datasets' => datasets }
 #				organizations_full.push(organization)
 #				organization_base_set.push('name' => o.to_s, 'length' => organization.length )
 #				File.open(@data_dir+o.to_s+'/index.json','w'){|f| f.write orga_index.to_json }
 			end
 #			File.open(@data_dir+'/organizations.json','w'){|f| f.write organization_base_set.to_json }
 	end
 	end
	
	def run
	 data = build_full_hierarchy()
	end
end
DataGouv_Orgnizations_db.new().run()
