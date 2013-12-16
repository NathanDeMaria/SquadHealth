################################################################
# Currently assumes there are exactly 8 categories in the form #
# Also, might break if you have too many squads                #
# Can fix this by changing the width % in the td classes       #
# to be based on the # of teams                                #
################################################################


# setwd('C:/Users/Nathan/Dropbox/R Projects/Hudl/Squad Health/appV5/')
# setwd('C:/Users/nathan.demaria/Dropbox/R Projects/Hudl/Squad Health/appV5')

# command to read from Wufoo
# sudo sh -c 'curl -u WUFOO-API-KEY:doesntmatter https://hudl.wufoo.com/api/v3/forms/how-healthy-is-your-squad/entries.xml > /var/shiny-server/www/appV5/entries.xml'
#6Tj8gDj9Mwv5dLJ
#user: hudl
library(shiny)
library(XML)


# Note: to use a package in shiny server, make sure install it in /usr/local/lib/R/site-library/
# default is /home/ubuntu/R/x86_53-pc-linux-gnu-library/3.0/   I think
# just do install.packages(name, lib='/usr/local/lib/R/site-library/')
# There's probably a way to set the default install library - figure it out?

# Make sure you change this to the other path when you put it on the serveR
    # also, it might be a decent idea to have it run the curl command from here, when the page is viewed
    # instead of in a cronjob, but it might not update quickly enough to see the changes on that view
data = xmlToDataFrame('entries.xml')

# column names
names(data) = c('EntryId', 'quarterId', 'squad', 'Product Owner', 'PM', 'Influence work', 'Ease of release', 'Process fit', 'Clarity of mission', 'Org. support', 'Innovate', 'DateCreated', 'CreatedBy', 'DateUpdated', 'UpdatedBy')
# convert from factors to numerics
data[,4:11] = sapply(4:11, function(x) {as.numeric(as.character(data[,x]))})

# puts the quarters in the right order, kinda a gross roundabout way, but they're not alphabetical sooooo yeah
time.to.numeric = function(time.id) {as.numeric(paste0(substr(time.id,4,7),substr(time.id, 2,2)))}
choices=sort(time.to.numeric(as.character(levels(data$quarterId))))
back.to.char = function(time.num) {paste0('Q', substr(as.character(time.num), 5,5), ' ', substr(as.character(time.num),1,4))}
times = sapply(choices, back.to.char)
data$quarterId = factor(data$quarterId, levels = times)
rm(choices, times, time.to.numeric, back.to.char)

choices=levels(data$quarterId)

# gets the average for each question given a squad and a quarter
get.avg = function(squadname, quarterId) {
  
  subset = data[data$squad == squadname & data$quarterId == quarterId,]
  
  apply(subset[,4:11], 2, mean)
}

# the classes of different colors
classes = c('box white', 
            'box red',
            'box orange', 
            'box yellow', 
            'box yellowGreen',             
            'box green')

# Values are the right edge of the range of colors
  # ex.: 2.2 (inclusive) is the highest value that will be red
  # [2.2, 2.9) = orange, etc.
  # The range of ratings is [1, 5]
  # 5.1 is the max of the green box so that 5 is also included (there is no extra credit)
color.edges = c(2.2, 2.9, 3.6, 4.3, 5.1)
  
# takes as input a row from the table, makes a <tr>
    # small chance there could be errors with matchup up current qtr to previous, but I've been trying to make it happen and it hasn't yet sooooo
make.row = function(rowname, row, prevRow) {
  
  paste(
    '<tr>
      <th class="first">',
    rowname,
    '</th>',
    paste0(lapply(1:length(row), function(x) {
      classes = classes[which(color.edges - row[x] > 0)[1] + 1]
            
      # its a - if the change is less than .4 (half a color) in either direction
      if(is.na(prevRow[x]))
      {
        # if there is no data for the previous qtr of this <td>, then it's no change
          # in a separate part from the else b/c it will break if you try to compare to prevRow[x] and it's NaN
        sign = ' -'
      }
      else if(row[x] > prevRow[x] + .4)
      {
        sign = ' &uarr;'
      }
      else if(row[x] < prevRow[x] - .4)
      {
        sign = ' &darr;'
      }
      else
      {
        # change was less than .4
        sign = ' -'
      }
      
      paste0('<td class="', classes, '">', format(row[x], digits=1, nsmall=1), sign, '</td>')

    }), collapse=''),
    '</tr>',
    sep='')
}