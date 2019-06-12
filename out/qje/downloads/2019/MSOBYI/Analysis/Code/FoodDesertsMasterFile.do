/* FoodDesertsMasterFile.do */

*******************************************************************************
/* SETUP */
clear matrix
clear mata
clear all
set more off
clear programs
set matsize 10000
set maxvar 8000


/* FILE PATHS */
* If you plan to run files on your local computer, add an if statement here including your username and the relevant file paths on your local computer.
if "`c(username)'"=="Hunt"|"`c(username)'"=="hallcott" {
	capture noisily cd "C:/Users/`c(username)'/Documents/GitHub/FoodDeserts" // This is your GitHub/FoodDeserts/ folder
	if _rc != 170 {
		global Externals = "C:/Users/`c(username)'/Dropbox/FoodDeserts/Externals" // This is your dropbox/FoodDeserts/Externals/ folder
		global Nielsen = "C:/Users/`c(username)'/Dropbox/Nielsen" // This is the location of raw HMS tsv files on your local machine, if any
	}
}

if "`c(username)'"=="diamondr" {
	cd "C:\Users\diamondr\GitHub\FoodDeserts" // This is your GitHub/FoodDeserts/ folder
	global Externals = "D:/Dropbox (Diamond)/FoodDeserts/Externals" // This is your dropbox/FoodDeserts/Data/ folder
	global Nielsen = "F:\Darchive\nielsen"
}


/* GLOBAL VARIABLES */
include Code/SetGlobals.do



/* PROGRAMS */
/* Data Prep */
include Code/DataPrep/DataPrepMasterFile.do


/* Analysis */
include Code/Analysis/AnalysisMasterFile.do 


*
