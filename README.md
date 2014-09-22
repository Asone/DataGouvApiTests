DataGouvAPITests
=== 

This repo contains scripts for scrapping [data.gouv.fr](http://www.data.gouv.fr) [API](http://wiki.data.gouv.fr/wiki/API_et_donn%C3%A9es_Data.gouv.fr)

For now there's not much to say about.

about APIs
---

data.gouv.fr provides 2 APIs. Scripts in both folders do the exact same thing, the only difference being into that organization_index.rb calls the different APIs.

scripts
---

- organization_index.rb : Builds a local hierarchy of the datasets accessible through API. organization folder is created in data/ if it does not exists and a json file is generated for each dataset containing the URL to the resource and its format
- process_xls.rb ( to be renamed ) : a useless script for now that will categorize datasets with availability of formats. 
- scrap_files.rb ( to be renamed ) : a script that for now just compares availability of different formats. Will evolve to a selective file scrapper. 




That's all for now, folks ! :)


