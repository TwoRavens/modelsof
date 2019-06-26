*online appendix 
set more off 
cd "C:\Users\murdiea\Dropbox\APSA 2013 Davis Murdie Wilson\CRO project\JPR RR\Replication Files for JPR"
log using CROreplicationappendix.smcl, replace

*INGO variables
use "C:\Users\murdiea\Dropbox\APSA 2013 Davis Murdie Wilson\CRO project\JPR RR\Replication Files for JPR\monadic.dta"
nbreg Fconflictcorrected3maint eigenvectoringo ingopercap igocount WB_trade cinc p_polity2 ciri_physint   lnreportcount3 majorpower2 US , robust

use "C:\Users\murdiea\Dropbox\APSA 2013 Davis Murdie Wilson\CRO project\JPR RR\Replication Files for JPR\nondirected dyads.dta", clear
zinb Fdyadconflict3maint maxflowingorr sharedingo distance10 lowestpolity lowestciri cincratio  maxpowerdyad s3un4608i    cwpceyrs   NUMIGO       lntotalflowvolume USdyad, inflate(greatestmedia3 ) robust

use "C:\Users\murdiea\Dropbox\APSA 2013 Davis Murdie Wilson\CRO project\JPR RR\Replication Files for JPR\directed dyads.dta", replace
zinb  Fconflictdyad3maint  maxflowingorr distance10 s3un4608i    cwpceyrs  polity21 polity22   ciri_physint1 cinc1 cinc2 sharedingo igocount1 igocount2 lnflow1 lnflow2 USccode1, inflate(lnreport1 lnreport2)


*correlations and summary statistics
use "C:\Users\murdiea\Dropbox\APSA 2013 Davis Murdie Wilson\CRO project\JPR RR\Replication Files for JPR\monadic.dta", clear
nbreg Fconflictcorrected3maint eigenvectorrr ingopercap igocount WB_trade cinc p_polity2 ciri_physint   lnreportcount3 majorpower2 US
mkcorr Fconflictcorrected3maint eigenvectorrr EigenvectorGCRONEW cropresentincountryrr  cropercap IGCROpresenincountryNEW igcropercap ingopercap  igocount WB_trade cinc p_polity2 ciri_physint   lnreportcount3 majorpower2 US  if e(sample),replace log(corr1monadic) label  mdec(4) cdec(4) sig 

sum Fconflictcorrected3maint eigenvectorrr EigenvectorGCRONEW cropresentincountryrr  cropercap IGCROpresenincountryNEW igcropercap ingopercap  igocount WB_trade cinc p_polity2 ciri_physint   lnreportcount3 majorpower2 US  if e(sample)

use "C:\Users\murdiea\Dropbox\APSA 2013 Davis Murdie Wilson\CRO project\JPR RR\Replication Files for JPR\nondirected dyads.dta", clear
zinb Fdyadconflict3maint maxflowcrorr sharedingo distance10 lowestpolity lowestciri cincratio  maxpowerdyad s3un4608i    cwpceyrs   NUMIGO       lntotalflowvolume USdyad, inflate(greatestmedia3 ) robust
mkcorr maxflowcrorr SharedIGCRORR  MaxFlowIGCRORR  sharedcrorr  maxflowingorr sharedingo distance lowestpolity lowestciri cincratio  maxpowerdyad s3un4608i    cwpceyrs   NUMIGO       lntotalflowvolume USdyad greatestmedia3 if e(sample),replace log(corr2dyadic) label  mdec(4) cdec(4)sig 

sum maxflowcrorr SharedIGCRORR  MaxFlowIGCRORR  sharedcrorr  maxflowingorr sharedingo distance lowestpolity lowestciri cincratio  maxpowerdyad s3un4608i    cwpceyrs   NUMIGO       lntotalflowvolume USdyad greatestmedia3 if e(sample)

use "C:\Users\murdiea\Dropbox\APSA 2013 Davis Murdie Wilson\CRO project\JPR RR\Replication Files for JPR\directed dyads.dta", replace
zinb  Fconflictdyad3maint  maxflowcrorr distance10 s3un4608i    cwpceyrs  polity21 polity22   ciri_physint1 cinc1 cinc2 sharedingo igocount1 igocount2 lnflow1 lnflow2 USccode1, inflate(lnreport1 lnreport2)
mkcorr maxflowcrorr SharedIGCRORR  MaxFlowIGCRORR  sharedcrorr  maxflowingorr sharedingo distance s3un4608i    cwpceyrs  polity21 polity22   ciri_physint1 cinc1 cinc2 sharedingo igocount1 igocount2 lnflow1 lnflow2 USccode1    lnreport1 lnreport2  if e(sample),replace log(corr2directedyadic) label  mdec(4) cdec(4)sig 

sum maxflowcrorr SharedIGCRORR  MaxFlowIGCRORR  sharedcrorr  maxflowingorr sharedingo distance s3un4608i    cwpceyrs  polity21 polity22   ciri_physint1 cinc1 cinc2 sharedingo igocount1 igocount2 lnflow1 lnflow2 USccode1    lnreport1 lnreport2  if e(sample)

*boostrap 
*monadic
clear
version 13.0
set more off 
set seed 100
use "C:\Users\murdiea\Dropbox\APSA 2013 Davis Murdie Wilson\CRO project\JPR RR\Replication Files for JPR\monadic.dta", clear
nbreg Fconflictcorrected3maint eigenvectorrr ingopercap igocount WB_trade cinc p_polity2 ciri_physint   lnreportcount3 majorpower2 US , vce(bootstrap)

*nondirected dyadic 
use "C:\Users\murdiea\Dropbox\APSA 2013 Davis Murdie Wilson\CRO project\JPR RR\Replication Files for JPR\nondirected dyads.dta", clear
bootstrap: zinb Fdyadconflict3maint maxflowcrorr sharedingo distance10 lowestpolity lowestciri cincratio  maxpowerdyad s3un4608i    cwpceyrs   NUMIGO       lntotalflowvolume USdyad, inflate(greatestmedia3 ) robust

*directed dyadic 
use "C:\Users\murdiea\Dropbox\APSA 2013 Davis Murdie Wilson\CRO project\JPR RR\Replication Files for JPR\directed dyads.dta", replace
bootstrap: zinb  Fconflictdyad3maint  maxflowcrorr distance10 s3un4608i    cwpceyrs  polity21 polity22   ciri_physint1 cinc1 cinc2 sharedingo igocount1 igocount2 lnflow1 lnflow2 USccode1, inflate(lnreport1 lnreport2)


***politically relevant dyads 


*nondirected dyad
use "C:\Users\murdiea\Dropbox\APSA 2013 Davis Murdie Wilson\CRO project\JPR RR\Replication Files for JPR\nondirected dyads.dta", clear 
zinb Fdyadconflict3maint sharedcrorr sharedingo distance10 lowestpolity lowestciri cincratio  maxpowerdyad s3un4608i    cwpceyrs   NUMIGO       lntotalflowvolume USdyad if pol_rel==1, inflate(greatestmedia3 )
zinb Fdyadconflict3maint maxflowcrorr sharedingo distance10 lowestpolity lowestciri cincratio  maxpowerdyad s3un4608i    cwpceyrs   NUMIGO       lntotalflowvolume USdyad if pol_rel==1, inflate(greatestmedia3 ) robust
zinb Fdyadconflict3maint SharedIGCRORR sharedingo distance10 lowestpolity lowestciri cincratio  maxpowerdyad s3un4608i    cwpceyrs   NUMIGO       lntotalflowvolume USdyad if pol_rel==1, inflate(greatestmedia3 ) robust
zinb Fdyadconflict3maint MaxFlowIGCRORR sharedingo distance10 lowestpolity lowestciri cincratio  maxpowerdyad s3un4608i    cwpceyrs   NUMIGO       lntotalflowvolume USdyad if pol_rel==1, inflate(greatestmedia3 ) robust
zinb Fdyadconflict3maint maxflowcrorr MaxFlowIGCRORR sharedingo distance10 lowestpolity lowestciri cincratio  maxpowerdyad s3un4608i    cwpceyrs   NUMIGO       lntotalflowvolume USdyad if pol_rel==1, inflate(greatestmedia3 ) robust



*dyadic 
use "C:\Users\murdiea\Dropbox\APSA 2013 Davis Murdie Wilson\CRO project\JPR RR\Replication Files for JPR\directed dyads.dta", clear
zinb  Fconflictdyad3maint  sharedcrorr distance10 s3un4608i    cwpceyrs  polity21 polity22   ciri_physint1 cinc1 cinc2 sharedingo igocount1 igocount2 lnflow1 lnflow2 USccode1 if pol_rel==1, inflate(lnreport1 lnreport2)
zinb  Fconflictdyad3maint  maxflowcrorr distance10 s3un4608i    cwpceyrs  polity21 polity22   ciri_physint1 cinc1 cinc2 sharedingo igocount1 igocount2 lnflow1 lnflow2 USccode1 if pol_rel==1, inflate(lnreport1 lnreport2)
zinb  Fconflictdyad3maint  MaxFlowIGCRORR distance10 s3un4608i    cwpceyrs  polity21 polity22   ciri_physint1 cinc1 cinc2 sharedingo igocount1 igocount2 lnflow1 lnflow2 USccode1 if pol_rel==1, inflate(lnreport1 lnreport2)
zinb  Fconflictdyad3maint  maxflowcrorr MaxFlowIGCRORR distance10 s3un4608i    cwpceyrs  polity21 polity22   ciri_physint1 cinc1 cinc2 sharedingo igocount1 igocount2 lnflow1 lnflow2 USccode1 if pol_rel==1 , inflate(lnreport1 lnreport2)

