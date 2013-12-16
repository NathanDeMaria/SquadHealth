library(shiny)

# change to hover over rows/cols? :)


shinyUI(bootstrapPage(
  
# title
  HTML(paste0('
<style type="text/css">
         .header {
           background-color:#f87620;
           padding-left:10px;
           color:white;
           font-family:"Helvetica Neue", sans-serif;
           width:100%;
           position:relative;
           margin-top:0px;
           border-top:0px;
           padding-top:10px;
           padding-bottom:10px;
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
  div(class='header', img(src='hudl-logo-white.png', class='headerRow'), h2(class='headerRow', '    '), h2("Squad Health", class='headerRow')),
  
        sidebarPanel(selectInput(inputId="time.period", label="Time Period:", choices)),
        htmlOutput('style'),
        htmlOutput('table')

))