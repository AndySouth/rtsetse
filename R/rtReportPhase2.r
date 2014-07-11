#' produces a report on outputs of one run of phase2 using selected parameter values
#'
#' \code{rtReportPhase2} creates a pdf of text and graphical output for this run.  
#' *later this may need to include all the arguments that are passed to rtPhase2Test2

#' @param aRecord output from phase2 a multi-dimensional array for adults [day,x,y,sex,ages] *later it may need to include pupae*
#' @param lNamedArgs a list of the arguments and their values passed to rtPhase2Test2
#' @param filename a name for the report file
#' 
#' @return ?nothing maybe
#' @examples
#' #tst <- rtPhase2Test2()
#' #rtReportPhase2(tst, filename="myoutput.pdf")
#' @export
#' 
rtReportPhase2 <- function( aRecord,
                            lNamedArgs,
                            filename = "phase2Report.pdf" ) 
{
  
#   #this whole option had poor formatting
#   pdf(filename)
#   #trying out gplots::textplot
#   library(gplots)
#   gplots::textplot("First go at creating rtsetse report\n")
#   rtPlotPopGrid( aRecord, title="Population over the whole grid")
#   dev.off()
  
  ###############################
  #trying using rmarkdown instead
  #library(rmarkdown)
  #rmarkdown::render('rtReportPhase2.Rmd',"pdf_document")
  #rmarkdown::render('rtReportPhase2.Rmd', envir=.GlobalEnv)
  #rmarkdown::render('rtReportPhase2.Rmd')
  #rmarkdown::render('inst//rmarkdown//rtReportPhase2.Rmd')
  #looks for the Rmd file in inst/rmarkdown
  filePath <- system.file("rmarkdown", "rtReportPhase2.Rmd", package = "rtsetse")
  rmarkdown::render(filePath, output_file=filename)
  
}