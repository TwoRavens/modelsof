**CRO paper replication - text 

clear
set more off 
cd "C:\Users\murdiea\Dropbox\APSA 2013 Davis Murdie Wilson\CRO project\JPR RR\Replication Files for JPR"

log using CROreplication.smcl, replace




*Table 3
use "C:\Users\murdiea\Dropbox\APSA 2013 Davis Murdie Wilson\CRO project\JPR RR\Replication Files for JPR\monadic.dta", clear
nbreg Fconflictcorrected3maint cropresentincountryrr  ingopercap igocount WB_trade cinc p_polity2 ciri_physint   lnreportcount3 majorpower2 US , robust
nbreg Fconflictcorrected3maint cropercap  ingopercap igocount WB_trade cinc p_polity2 ciri_physint   lnreportcount3 majorpower2 US , robust
nbreg Fconflictcorrected3maint IGCROpresenincountryNEW  ingopercap igocount WB_trade cinc p_polity2 ciri_physint   lnreportcount3 majorpower2 US , robust
nbreg Fconflictcorrected3maint igcropercap  ingopercap igocount WB_trade cinc p_polity2 ciri_physint   lnreportcount3 majorpower2 US , robust
nbreg Fconflictcorrected3maint EigenvectorGCRONEW ingopercap igocount WB_trade cinc p_polity2 ciri_physint   lnreportcount3 majorpower2 US , robust
nbreg Fconflictcorrected3maint eigenvectorrr  ingopercap igocount WB_trade cinc p_polity2 ciri_physint   lnreportcount3 majorpower2 US , robust
quietly margins, atmeans at(eigenvectorrr  =(0(.1)1) )  
marginsplot, xtitle("Eigenvector")  level(90)
nbreg Fconflictcorrected3maint eigenvectorrr EigenvectorGCRONEW ingopercap igocount WB_trade cinc p_polity2 ciri_physint   lnreportcount3 majorpower2 US , robust
nbreg Fconflictcorrected3maint eigenvectorrr EigenvectorGCRONEW ingopercap igocount WB_trade cinc p_polity2 ciri_physint   lnreportcount3 if majorpower!=1 & US!=1 , robust


*Table 4 
use "C:\Users\murdiea\Dropbox\APSA 2013 Davis Murdie Wilson\CRO project\JPR RR\Replication Files for JPR\nondirected dyads.dta", clear
zinb Fdyadconflict3maint sharedcrorr sharedingo distance10 lowestpolity lowestciri cincratio  maxpowerdyad s3un4608i    cwpceyrs   NUMIGO       lntotalflowvolume USdyad, inflate(greatestmedia3 ) robust
zinb Fdyadconflict3maint maxflowcrorr sharedingo distance10 lowestpolity lowestciri cincratio  maxpowerdyad s3un4608i    cwpceyrs   NUMIGO       lntotalflowvolume USdyad, inflate(greatestmedia3 ) robust
quietly margins, atmeans  at(maxflowcrorr=(0(100)731) )
marginsplot, xtitle("MaxFlow") 
graph save Graph "C:\Users\murdiea\Dropbox\APSA 2013 Davis Murdie Wilson\CRO project\JPR RR\newtables\pred maxflowCRO  nondirected dyad trade new.gph", replace 
zinb Fdyadconflict3maint  SharedIGCRORR sharedingo distance10 lowestpolity lowestciri cincratio  maxpowerdyad s3un4608i    cwpceyrs   NUMIGO       lntotalflowvolume USdyad, inflate(greatestmedia3 ) robust
zinb Fdyadconflict3maint MaxFlowIGCRORR sharedingo distance10 lowestpolity lowestciri cincratio  maxpowerdyad s3un4608i    cwpceyrs   NUMIGO       lntotalflowvolume USdyad, inflate(greatestmedia3 ) robust
zinb Fdyadconflict3maint maxflowcrorr MaxFlowIGCRORR sharedingo distance10 lowestpolity lowestciri cincratio  maxpowerdyad s3un4608i    cwpceyrs   NUMIGO       lntotalflowvolume USdyad, inflate(greatestmedia3 ) robust
zinb Fdyadconflict3maint maxflowcrorr MaxFlowIGCRORR sharedingo distance10 lowestpolity lowestciri cincratio  maxpowerdyad s3un4608i    cwpceyrs   NUMIGO       lntotalflowvolume USdyad if pol_rel==1, inflate(greatestmedia3 ) robust


*Table 5
use "C:\Users\murdiea\Dropbox\APSA 2013 Davis Murdie Wilson\CRO project\JPR RR\Replication Files for JPR\directed dyads.dta", clear
zinb  Fconflictdyad3maint  sharedcrorr  distance10 s3un4608i    cwpceyrs  polity21 polity22   ciri_physint1 cinc1 cinc2 sharedingo igocount1 igocount2 lnflow1 lnflow2 USccode1, inflate(lnreport1 lnreport2)
zinb  Fconflictdyad3maint  maxflowcrorr distance10 s3un4608i    cwpceyrs  polity21 polity22   ciri_physint1 cinc1 cinc2 sharedingo igocount1 igocount2 lnflow1 lnflow2 USccode1, inflate(lnreport1 lnreport2)
quietly margins, atmeans  at(maxflowcrorr=(0(100)731) )
marginsplot, xtitle("MaxFlow") 
graph save Graph "C:\Users\murdiea\Dropbox\APSA 2013 Davis Murdie Wilson\CRO project\JPR RR\newtables\pred maxflowCRO dyad trade new.gph", replace 
zinb  Fconflictdyad3maint   SharedIGCRORR distance10 s3un4608i    cwpceyrs  polity21 polity22   ciri_physint1 cinc1 cinc2 sharedingo igocount1 igocount2 lnflow1 lnflow2 USccode1 , inflate(lnreport1 lnreport2)
zinb  Fconflictdyad3maint  MaxFlowIGCRORR distance10 s3un4608i    cwpceyrs  polity21 polity22   ciri_physint1 cinc1 cinc2 sharedingo igocount1 igocount2 lnflow1 lnflow2 USccode1 , inflate(lnreport1 lnreport2)
zinb  Fconflictdyad3maint  maxflowcrorr MaxFlowIGCRORR distance10 s3un4608i    cwpceyrs  polity21 polity22   ciri_physint1 cinc1 cinc2 sharedingo igocount1 igocount2 lnflow1 lnflow2 USccode1 , inflate(lnreport1 lnreport2)
quietly margins, atmeans  at(maxflowcrorr=(0(100)731) )
marginsplot, xtitle("MaxFlow") 
graph save Graph "C:\Users\murdiea\Dropbox\APSA 2013 Davis Murdie Wilson\CRO project\JPR RR\newtables\pred maxflowCRO all together dyad trade new.gph", replace 



 



