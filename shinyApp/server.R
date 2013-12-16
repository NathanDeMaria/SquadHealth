library(shiny)

shinyServer(function(input, output) {
  
  time.period = reactive({input$time.period})
  
  num.cols = reactive({length(unique(data$squad[data$quarterId == input$time.period]))})
  
  output$style = renderText({
    paste0('
<style type="text/css">
  .box {
    height:50px; 
    border-radius:5px; 
    display:inline-block; 
    margin-right:10px;
    margin-top:10px;
    text-align:center;
    vertical-align:middle;
    padding-top:16px;   
    box-sizing: border-box;
    width:', min(70 / num.cols(), 15), '%
  }
}
</style>               
                  ')
  })
  
  output$table = renderText({
  
    # calculates ratings for this quarter
    ratings = sapply(levels(data$squad[data$quarterId == time.period()]), function(x) {get.avg(x, time.period())})

    # choices is now in order, so this actually does represent the previous quarter's index
    prev.time = which(choices==time.period())-1
    
    # if the previous quarter doesn't exist, then it says that prevRatings are the current ratings
      # so there will all be marked with -'s
    if(prev.time > 0)
    {
      prevRatings = sapply(levels(data$squad), function(x) {get.avg(x, choices[prev.time] )})
    }
    else
    {
      prevRatings=ratings
    }
    
    # hard coded in because the XML just says Field 4, etc.
      # When changing names of questions, change my R code here and in global.R
    rownames(ratings) = c('Tribe Leader', 'PM', 'Influence Work', 'Easy Release', 'Process', 'Mission', 'Take Risks', 'Org. Support')

    # to handle adding/removing squads
    valid.cols = which(colnames(ratings) %in% colnames(ratings)[!is.na(ratings[1,])])
    
    headrow = paste0('<tr><th class="first"></th>', paste0(lapply(colnames(ratings)[valid.cols], function(name) {paste0('<th class="box">', name, '</th>',collapse='')}), collapse=''), '</tr>', collapse='')
    
    rows = paste0(lapply(1:dim(ratings)[1], function(rowNum) {make.row(rownames(ratings)[rowNum], ratings[rowNum,valid.cols], prevRatings[rowNum,valid.cols])}),collapse='')
      
    paste0('<table width=1600px><thead>', headrow, '</thead><tbody>', rows, '</tbody></table>')
  })

})