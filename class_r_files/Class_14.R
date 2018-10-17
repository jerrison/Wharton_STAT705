## ----setup, include=FALSE------------------------------------------------
library(knitr)
opts_chunk$set(fig.path='C:/Users/richardw/Dropbox (Penn)/Teaching/705s2017/Notes//Images/beamer-',fig.align='center',fig.show='hold',size='footnotesize')
#opts_chunk$set(fig.path='C:/Users/waterman/Dropbox (Penn)/Teaching/705s16/Notes//Images/beamer-',fig.align='center',fig.show='hold',size='footnotesize')

## ----echo=TRUE,eval=FALSE------------------------------------------------
## my.location <- "C:\\Users\\richardw\\Dropbox (Penn)\\Teaching\\705f2018\\Notes\\"
## my.infile <- "example_01.Rhtml"  # INFILE
## my.outfile <- "example_01.html"  # OUTFILE
## 
## library(knitr) # Read in the knitr package
## knit(input = paste(my.location,my.infile,sep=""), # Input file
##      output = paste(my.location,my.outfile,sep="") # output file
##      )

## ----echo=FALSE,eval=TRUE------------------------------------------------
my.location <- "/Users/jerrison/Wharton_MBA/Wharton_STAT_705/class_html_files/"
my.infile <- "example_01.Rhtml"  # INFILE 
my.outfile <- "example_01.html"  # OUTFILE

knit(input = paste(my.location,my.infile,sep=""), # Input file
     output = paste(my.location,my.outfile,sep=""),
	 quiet=TRUE) # output file

## ----echo=TRUE,eval=FALSE------------------------------------------------
## my.location <- "C:\\Users\\richardw\\Dropbox (Penn)\\Teaching\\705f2018\\Notes\\"
## my.infile <- "example_01.Rhtml"  # INFILE
## my.outfile <- "example_01.R"     # OUTFILE
## 
## purl(input = paste(my.location,my.infile,sep=""), # infile
##      output = paste(my.location,my.outfile,sep=""), #outfile
##      documentation = 1) # Control documentation level

## ----echo=FALSE,eval=TRUE------------------------------------------------
my.location <- "/Users/jerrison/Wharton_MBA/Wharton_STAT_705/class_html_files/"
my.infile <- "example_01.Rhtml"  # INFILE 
my.outfile <- "example_01.R"     # OUTFILE 

purl(input = paste(my.location,my.infile,sep=""), # infile
     output = paste(my.location,my.outfile,sep=""), #outfile
	 documentation = 1,
	 quiet=TRUE) # Control documentation level 

