library(shiny)

shinyUI(bootstrapPage(
  
# Style
  HTML(paste0('
<style type="text/css">
         .header {
           background-color:#f87620;
           padding-left:35px;
           color:white;
           font-family:"Helvetica Neue", sans-serif;
           width: 100%;
           position:relative;
           margin-top:0px;
           border-top:0px;
           padding-top:5px;
           padding-bottom:5px;
           margin-bottom: 28px;
         }
         .headerRow {
           display:inline;
           vertical-align:middle;
         }
         .first {
          height:50px; 
           display:inline-block; 
           margin-right:10px;
           margin-top:10px;
           text-align:center;
           vertical-align:middle;
           padding-top:16px;   
           box-sizing: border-box;   
           width:15%;
         }
         .white {
          background-color:white;
           color:black;
         }
         .yellow {
          background-color:#FFFFBF;
          color:black;
         }
         .green {
          background-color:#1A9641;
          color:black;
         }
         .red {
          background-color:#D7191C;
          color:white;
         }
          .yellowGreen {
          background-color:#A6D96A;
          color:black;
         }
         .orange {
          background-color:#FDAE61;
          color:black;
         }
</style>')),
  
  # top bar
        div(class='header', img(src='hudl-logo-white.png', class='headerRow'), h3(style='margin-left: 20px', "Squad Health", class='headerRow')),
  # quarter selector    
        sidebarPanel(selectInput(inputId="time.period", label="Time Period:", choices)),
  # lets the style of a box depend on how many there are      
        htmlOutput('style'),
  # the table
        htmlOutput('table')

))