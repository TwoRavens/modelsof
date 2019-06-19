 *** Fujin Zhou and Remco Oostendorp
 *** Vrije Universiteit Amsterdam
 *** March 2013
 
 
 * this dofile export .csv data for use in OX program
 
 global path D:\Dropbox\FIRSTPAPERDRAFTSANDPROGRAMS\CleanFiles4SubmissionUpload
 use "$path\Data\dataMongolia.dta", clear
 
 global basic id lsale_s lsale_t industryd2 industryd3 industryd4 sized2 sized3 cityd2 cityd3 cityd5
 global xtra lmwage manexp caputi 
   
 egen countmiss = rowmiss($basic $xtra credit bribe lksflow w) 
 keep if countmiss == 0 
 drop countmiss 
 count
 outsheet $basic $xtra lksflow using $path\OXcodes\0IC.csv, comma nolabel replace 
 outsheet $basic $xtra bribe lksflow using $path\OXcodes\1ICa.csv, comma nolabel replace 
 outsheet $basic $xtra credit lksflow using $path\OXcodes\1ICb.csv, comma nolabel replace 
 outsheet $basic $xtra credit bribe lksflow using $path\OXcodes\2IC.csv, comma nolabel replace  
 outsheet $basic $xtra overdraft lksflow using $path\OXcodes\1ICc.csv, comma nolabel replace 		
