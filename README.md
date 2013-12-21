Change color ranges in color.edges of global.R ~=line 63

Installing shiny server: http://www.rstudio.com/shiny/server/install-opensource

R packages used: shiny, XML
	to install (in R):
		install.packages('shiny', lib='/usr/local/lib/R/site-library/')
		install.packages('XML', lib='/usr/local/lib/R/site-library/')
		
To update the data, the following commands need to be run (more changes need to be made if there are more than 200 entries):
		sudo sh -c 'curl -u WUFOO-API-KEY:doesntmatter -o /var/shiny-server/www/squadHealth/entries.xml https://hudl.wufoo.com/api/v3/forms/how-healthy-is-your-squad/entries.xml?pageStart=0&pageSize=100'
		sudo sh -c 'curl -u WUFOO-API-KEY:doesntmatter -o /var/shiny-server/www/squadHealth/entries2.xml https://hudl.wufoo.com/api/v3/forms/how-healthy-is-your-squad/entries.xml?pageStart=100&pageSize=100'
		sudo touch /var/shiny-server/www/squadHealth/restart.txt