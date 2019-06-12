/* This code imports data from the Dataquick assessor files, using the
   specified layout.
   See readdq.do for details.
*/

clear

/* Format file */
global dqfmtfile = "/kellogg/data/dataquick/assessor/RENTRANGE_ASSESSOR_LAYOUT.xls"

/* Cell that says "Field Number", ie. leftmost cell of the names row */
global cellrange = "A2" 

global dqfname = "RENTRANGE_ASSESSOR_0.TXT"    /* File to read */
/* Rows to read; set to empty to read everything */    
global dqrows = "in 1/1000"   /* Read first 1,000 observations */
/* global dqrows = "" */        /* Read all observations */
    
do readdq
    
/* Compress long variables to save space and memory */
/* NOTE: This can result in variable length being different across different files */   
compress
