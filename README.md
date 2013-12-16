Change color ranges in color.edges of global.R ~=line 63

Installing shiny server: http://www.rstudio.com/shiny/server/install-opensource

R packages used: shiny, XML
	to install (in R):
		install.packages('shiny', lib='/usr/local/lib/R/site-library/')
		install.packages('XML', lib='/usr/local/lib/R/site-library/')
		
To update the data, two commands need to be run:
		sudo sh -c 'curl -u WUFOO-API-KEY:doesntmatter https://hudl.wufoo.com/api/v3/forms/how-healthy-is-your-squad/entries.xml > /var/shiny-server/www/shinyApp/entries.xml'
		sudo touch /var/shiny-server/www/shinyHudl/restart.txt