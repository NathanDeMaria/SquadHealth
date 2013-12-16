################################################################
# Currently assumes there are exactly 8 categories in the form #
################################################################

# command to read from Wufoo
# sudo sh -c 'curl -u WUFOO-API-KEY:doesntmatter https://hudl.wufoo.com/api/v3/forms/how-healthy-is-your-squad/entries.xml > /var/shiny-server/www/shinyApp/entries.xml'
library(shiny)
library(XML)

data = xmlToDataFrame('entries.xml')

# column names
names(data) = c('EntryId', 'quarterId', 'squad', 'Product Owner', 'PM', 'Influence work', 'Ease of release', 'Process fit', 'Clarity of mission', 'Org. support', 'Innovate', 'DateCreated', 'CreatedBy', 'DateUpdated', 'UpdatedBy')
# convert from factors to numerics
data[,4:11] = sapply(4:11, function(x) {as.numeric(as.character(data[,x]))})

# puts the quarters in the right order
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
          # this is in a separate part from the else b/c it will break if you try to compare to prevRow[x] and it's NaN
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