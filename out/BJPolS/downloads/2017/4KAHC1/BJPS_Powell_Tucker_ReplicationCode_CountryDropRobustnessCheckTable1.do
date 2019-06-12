clear mata
clear matrix
clear                                                               
version 11.0                                                        
set more off
set memory 200m
capture log close
*cd "~/[Put File Location Here]"
 
* File-Name:       BJPS_Powell_Tucker_ReplicationCode_CountryDropRobustnessCheckTable1.do                              
* Date:            August 20, 2015
* Author:          Joshua Tucker, and Eleanor Powell                                       
* Purpose:         BJPS Replication Files & Country Dropping Robustness Check
* Data Used:       BJPS_Powell_Tucker_Final.dta


* =========================================================================================================================================================
 * Loading the Data 
* =========================================================================================================================================================

 use "BJPS_Powell_Tucker_Final.dta"


* =========================================================================================================================================================
 *  Dropping Western Europe from the Datafile, since it wasn't part of the replication.  
* =========================================================================================================================================================
drop if EEIndicator==0

*==========================================================================================================================================================
* Purpose: Robustness Check: Regressions dropping one country at a time
*==========================================================================================================================================================
* Installing estout to summarize output
 ssc install estout, replace
** Creating numeric version of the Country variable called group
egen group=group(Country)

*** Looping over all the values of Country.  Running the regression dropping the country in that iteration.  
** outreg2 and estimates stores the output
** Must run the su command mean only command each time before running the loop
*==========================================================================================================================================================
* Table 1: Type A Volatility Country By Country
*==========================================================================================================================================================


reg TypeAVol GDPChangeE1E2 GDPChange1989 Enp1 lg_weighted_mag presys mixsys pr Time Time2 EthFrac mis_GDPChangeE1E2 mis_GDPChange1989 mis_weighted_mag if EEIndicator>0, cluster(Country)
outreg2 using PT_TypeA_CountryDropping.tex, label dec(3) sym(***, **, *) ct("All") addt(Standard Errors Clustered by Country) replace

su group, meanonly 
forvalues i = 1/`r(max)' {
reg TypeAVol GDPChangeE1E2 GDPChange1989 Enp1 lg_weighted_mag presys mixsys pr Time Time2 EthFrac mis_GDPChangeE1E2 mis_GDPChange1989 mis_weighted_mag if group != `i' & EEIndicator==1, cluster(Country)
estimates store m`i', title(Dropping `i')
outreg2 using PT_TypeA_CountryDropping.tex, label dec(3) sym(***, **, *) ct("Not" `i') append
local append "append"
}
estout m* using "PT_TypeA_CountryDropping.csv", cells(b(star fmt(3)) se(par fmt(2))) replace 


* Note: To read the results.csv file cleanly, you need to import it as a csv in excel.  
* Note: to have the latex file readable on single very wide page.  Adjust code at the top of .tex file to the following: 
* \setlength{\pdfpagewidth}{32in} \setlength{\pdfpageheight}{11in}



