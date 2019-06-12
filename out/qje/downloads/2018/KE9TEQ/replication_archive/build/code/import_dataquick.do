/*
** last changes: August 2017  by: J. Spenkuch (j-spenkuch@kellogg.northwestern.edu)
*/
if c(os) == "Unix" {
	global PATH "/projects/p30061"
	global PATHdata "/projects/p30061/data"
	global PATHcode "/projects/p30061/code"
	global PATHlogs "/projects/p30061/logs"
	
	cd $PATH
}
else if c(os) == "Windows" {
	global PATH "R:/Dropbox/research/advertising_paper/analysis"
	global PATHdata "R:/Dropbox/research/advertising_paper/analysis/input"
	global PATHcode "R:/Dropbox/research/advertising_paper/analysis/code"
	global PATHlogs "R:/Dropbox/research/advertising_paper/output"
	
	cd $PATH
}
else {
    display "unable to recognize OS -> abort!"
    exit
}

include code/preamble_clean.do


/**********************************************************
***
***		import home value data
***
**********************************************************/

cd $PATHcode


log using $PATHlogs/import_dataquick.txt, replace


global STATES "AK AL AR AZ CA CO CT DE FL GA HI IA ID IL IN KS KY LA MA MD ME MI MN MO MT MS NC ND NE NJ NH NM NV NY OH OK OR PA RI SD SC TN TX UT VA VT WV WA WI WY DC"


forvalues v=1(1)9 {
    clear
    
    
    tempfile assessor`v'
    
    /* Format file */
    global dqfmtfile = "$PATHdata/dataquick/assessor/RENTRANGE_ASSESSOR_LAYOUT.xls"

    /* Cell that says "Field Number", ie. leftmost cell of the names row */
    global cellrange = "A2" 

    global dqfname = "$PATHdata/dataquick/assessor/RENTRANGE_ASSESSOR_`v'.TXT"    /* File to read */
    /* Rows to read; set to empty to read everything */    
    *global dqrows = "in 1/100000"   /* Read first 100,000 observations */
    global dqrows = ""       /* Read all observations */
        
    do readdq
    
    * keep only variables that are needed later on
    keep sa_property_id mm_state_code assr_year sa_val_assd sa_val_market sa_y_coord sa_x_coord
    
    replace sa_x_coord = min(sa_x_coord,-sa_x_coord)
     
    /* Compress long variables to save space and memory */  
    compress
    
    *by mm_state_code, sort: keep if _n<=1000
    
    save `assessor`v''
}
clear


forvalues v=1(1)9 {
 
    append using `assessor`v''
    
}

destring assr_year, replace force
drop if mi(assr_year) | assr_year==0

foreach s in $STATES {

    export delimited sa_property_id sa_y_coord sa_x_coord using "$PATHdata/GIS/input/`s'_dataquick_latlong.csv" if mm_state_code=="`s'", quote replace

}

keep sa_property_id mm_state_code assr_year sa_val_assd sa_val_market

save $PATHdata/temp/dataquick_values, replace
