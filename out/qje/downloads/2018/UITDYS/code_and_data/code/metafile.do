* 2018-11-8

/* 

This do-file is a metafile for the do-files tabs_main.do, figs_main.do, 
tabs_appendix.do and figs_appendix.do, which create the figures 
in the main text and appendix of

  - Bell, A., Chetty, R., Jaravel, X., Petkova, N. & Van Reenen, J. (2018). 
		Who Becomes an Inventor in America?
		The Importance of Exposure to Innovation
		
It defines several globals for file directories and must be run first.		
*/

* Choose figure file type
global image_suffix "wmf"  // change to wmf or pdf if desired

*************************************************************
* Define convenient globals

* Make sure extra title is included in Power point figs
if "${image_suffix}" == "wmf" global title "title(" ")"
else global title

adopath ++ 	 	  "${dropbox}/ado"
global root 	  "${dropbox}/outside/patents/final_submission_QJE"
global code 	  "${root}/code"
global data 	  "${root}/data"
global recordings "${data}/recordings"
global output 	  "${dropbox}/outside/patents/figs_and_tabs/final_submission_check"
global logs 	  "${output}"
global figs 	  "${output}/figures/${image_suffix}"  
global tabs 	  "${output}/tables"  

/* Requires maptile state and CZ geography, if not already installed
ssc install maptile
ssc install spmap
maptile_install using "http://files.michaelstepner.com/geo_state.zip", replace
maptile_install using "http://files.michaelstepner.com/geo_cz1990.zip", replace
*/
**************************************************************

* Create main text tables
include "${code}/tabs_main.do"
* Create main text figures
include "${code}/figs_main.do"
* Create appendix tables
include "${code}/tabs_appendix.do"
* Create appendix figures
include "${code}/figs_appendix.do"
