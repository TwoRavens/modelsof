
clear

use "/Users/jonathanmummolo/Dropbox/Interaction Paper/Data/Included/Mummolo_replications/Pelc_IO_2011/accession_pelc/accession_io_pelc.dta"

gen depth1=  AHSpre - BNDpost
gen depth2= MFNpre - BNDpost
gen depth3=  MFNpre - MFNpost 
gen depth4=   AHSpre - AHSpost 
gen overhang= BNDpost-MFNpost
label variable depth1 `"AHSpre - BNDpost"'
label variable depth2 `"MFNpre - BNDpost"'
label variable depth3 `"MFNpre - MFNpost"'
label variable depth4 `"AHSpre - AHSpost"'
label variable overhang `"BNDpost-MFNpost"'


* gen interaction terms
gen polityXimp = logfullimports*polity3
gen polityXexp = logfullexports*polity3
label var polityXimp "Regime X Log Product Imports"
label var polityXexp "Regime X Log Product Exports"


* 4.2
reg depth3 logGDPconst logfullimports logfullexports accessionperiod loggdpcap MFNpre polity3 chinadum membershiptiming polityXimp polityXexp, cluster(reporter)

generate sample = e(sample)

drop if sample!=1

saveold rep_pelc_2011a, replace


drop sample


clear






use "/Users/jonathanmummolo/Dropbox/Interaction Paper/Data/Included/Mummolo_replications/Pelc_IO_2011/accession_pelc/accession_io_pelc.dta"

gen depth1=  AHSpre - BNDpost
gen depth2= MFNpre - BNDpost
gen depth3=  MFNpre - MFNpost 
gen depth4=   AHSpre - AHSpost 
gen overhang= BNDpost-MFNpost
label variable depth1 `"AHSpre - BNDpost"'
label variable depth2 `"MFNpre - BNDpost"'
label variable depth3 `"MFNpre - MFNpost"'
label variable depth4 `"AHSpre - AHSpost"'
label variable overhang `"BNDpost-MFNpost"'


* gen interaction terms
gen polityXimp = logfullimports*polity3
gen polityXexp = logfullexports*polity3
label var polityXimp "Regime X Log Product Imports"
label var polityXexp "Regime X Log Product Exports"



* 4.3
reg overhang logGDPconst logfullimports logfullexports accessionperiod loggdpcap MFNpre polity3 chinadum membershiptiming polityXimp polityXexp, cluster(reporter)

generate sample = e(sample)

drop if sample!=1

saveold rep_pelc_2011b, replace
