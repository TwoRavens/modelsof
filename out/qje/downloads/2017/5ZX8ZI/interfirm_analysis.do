*Interfirm Relationships and Business Performance by Jing Cai and Adam Szeidl
*This do-file produces all tables and figures in the manuscript and in the online appendix.
*To avoid generating excel output tables, comment out lines starting with 'outreg2'.

clear matrix 
clear
set more off
set mem 300m
set matsize 800
set seed 123456789
capture log close

*cd *add directory to folder containing data files here*

*************************************Main Tables and Figures**************************************
use 120617main, replace
*calculate baseline control mean of key variables
tabstat lnwpart5revenue wnet_profit lnwnum_employee lnwfixasset lnwmaterial lnwenergy_cost wTFP_OLS lnwnum_clients lnwnum_supplier bankloan lnsalesdif taxratio innovation if treatment==0

*Figure II
twoway (kdensity lnpart5revenue if treatment==0 & round==1, xtitle("log Sales") ytitle("Density") clpattern("solid") lwidth("medthick") graphregion(color(white))) (kdensity lnpart5revenue if treatment==1 & round==1, clpattern("dash") lwidth("medthick") graphregion(color(white))), legend(order(1 "Control Baseline" 2 "Treatment Baseline"))
twoway (kdensity lnpart5revenue if treatment==0 & round==3, xtitle("log Sales") ytitle("Density") clpattern("solid") lwidth("medthick") graphregion(color(white))) (kdensity lnpart5revenue if treatment==1 & round==3, clpattern("dash") lwidth("medthick")), legend(order(1 "Control Endline" 2 "Treatment Endline"))

*Table I
preserve
keep if round==1
ttest firmage, by(treatment)
ttest ownershipcur_private, by(treatment)
ttest ind_manufacturing, by(treatment)
ttest ind_service, by(treatment)
ttest num_employee, by(treatment)
ttest gender, by(treatment)
ttest age, by(treatment)
ttest educ_college, by(treatment)
ttest workexp_SOEgov, by(treatment)
ttest partymember, by(treatment)

*Table II
ttest num_clients, by(treatment)
ttest num_supplier, by(treatment)
ttest bankloan, by(treatment)
ttest private_loan, by(treatment)
ttest part5revenue, by(treatment)
ttest lnpart5revenue, by(treatment)
ttest net_profit, by(treatment)
restore
ttest certificate if round==2, by(treatment)
ttest certificate if round==3, by(treatment)
use 120617attrshutdown, replace
ttest attrition1, by(treatment)
ttest attrition2, by(treatment)
ttest shutdown, by(treatment)

use 120617main, replace
gen post=0
replace post=1 if round>1
gen intervention1=treatment*after1
gen intervention2=treatment*after2
gen intervention=treatment*post
*Define interactions of county, size, and industry indicators
xi i.round1county
forvalues i=2(1)26{
	gen postinter21`i'=after1*_Iround1cou_`i'
	gen postinter31`i'=after1*round1surveyfirmtype*_Iround1cou_`i'
	gen postinter41`i'=after1*round1ind_manufacturing*_Iround1cou_`i'
	gen postinter51`i'=after1*round1surveyfirmtype*round1ind_manufacturing*_Iround1cou_`i'
	gen postinter22`i'=after2*_Iround1cou_`i'
	gen postinter32`i'=after2*round1surveyfirmtype*_Iround1cou_`i'
	gen postinter42`i'=after2*round1ind_manufacturing*_Iround1cou_`i'
	gen postinter52`i'=after2*round1surveyfirmtype*round1ind_manufacturing*_Iround1cou_`i'
}
gen postinter01=after1*round1surveyfirmtype
gen postinter02=after2*round1surveyfirmtype
gen postinter11=after1*round1ind_manufacturing
gen postinter12=after2*round1ind_manufacturing
gen compinter0=round1surveyfirmtype*round1ind_manufacturing
forvalues i=2(1)26{
	gen compinter1`i'=round1surveyfirmtype*_Iround1cou_`i'
	gen compinter2`i'=round1ind_manufacturing*_Iround1cou_`i'
	gen compinter3`i'=round1surveyfirmtype*round1ind_manufacturing*_Iround1cou_`i'
}

*Table III
local outputfile 120617table3.xls
xtreg lnwpart5revenue after1 after2 intervention1 intervention2, fe robust cluster (clusterid) nonest
outreg2 using `outputfile'
xtreg wnet_profit after1 after2 intervention1 intervention2 if net_profit~=., fe robust cluster (clusterid) nonest
outreg2 using `outputfile'
xtreg lnwnum_employee after1 after2 intervention1 intervention2, fe robust cluster (clusterid) nonest
outreg2 using `outputfile'
xtreg lnwfixasset after1 after2 intervention1 intervention2, fe robust cluster (clusterid) nonest
outreg2 using `outputfile'
xtreg lnwmaterial after1 after2 intervention1 intervention2, fe robust cluster (clusterid) nonest
outreg2 using `outputfile'
xtreg lnwenergy_cost after1 after2 intervention1 intervention2, fe robust cluster (clusterid) nonest
outreg2 using `outputfile'
xtreg wTFP_OLS after1 after2 intervention1 intervention2, fe robust cluster (clusterid) nonest
outreg2 using `outputfile'

*Table IV
local outputfile 120617table4.xls
xtreg lnwnum_clients after1 after2 intervention1 intervention2, fe robust cluster (clusterid) nonest
outreg2 using `outputfile'
xtreg lnwnum_supplier after1 after2 intervention1 intervention2, fe robust cluster (clusterid) nonest
outreg2 using `outputfile'
xtreg bankloan after1 after2 intervention1 intervention2, fe robust cluster (clusterid) nonest
outreg2 using `outputfile'
reg innovation treatment round1surveyfirmtype round1ind_manufacturing _Iround1cou* compinter* if round==3, robust cluster(clusterid)
outreg2 using `outputfile'
xtreg lnsalesdif after1 after2 intervention1 intervention2, fe robust cluster (clusterid) nonest
outreg2 using `outputfile'
xtreg taxratio after1 after2 intervention1 intervention2, fe robust cluster (clusterid) nonest
outreg2 using `outputfile'

*Table V
local outputfile 120617table5.xls
reg manage_z after2 intervention1 intervention2 if round>1, robust cluster (clusterid)
outreg2 using `outputfile'
reg zmanage_eval after2 intervention1 intervention2 if round>1, robust cluster (clusterid)
outreg2 using `outputfile'
reg zmanage_target after2 intervention1 intervention2 if round>1, robust cluster (clusterid)
outreg2 using `outputfile'
reg zmanage_incentive after2 intervention1 intervention2 if round>1, robust cluster (clusterid)
outreg2 using `outputfile'
reg zmanage_operation after2 intervention1 intervention2 if round>1, robust cluster (clusterid)
outreg2 using `outputfile'
reg zmanage_delegation after2 intervention1 intervention2 if round>1, robust cluster (clusterid)
outreg2 using `outputfile'

*Table VI
*Define management score with HR areas only
egen manage_zcheck=rowmean(zmanage_eval zmanage_incentive zmanage_delegation) 
egen sdmanage_zcheck=sd(manage_zcheck)
replace manage_zcheck=manage_zcheck/sdmanage_zcheck
local outputfile 120617table6.xls
reg manage_worker treatment if round==3, robust cluster(clusterid)
outreg2 using `outputfile'
reg manage_worker manage_zcheck round1surveyfirmtype round1ind_manufacturing _Iround1cou_* compinter* if round==3, robust cluster(clusterid)
outreg2 using `outputfile'
reg manage_worker manage_zcheck lnfixasset lnnum_employee lnmaterial round1surveyfirmtype round1ind_manufacturing _Iround1cou_* compinter* if round==3, robust cluster(clusterid)
outreg2 using `outputfile'
xtreg lnwpart5revenue lnfixasset lnnum_employee lnmaterial manage_z, fe robust cluster (clusterid) 
outreg2 using `outputfile'

*Table VII
gen interpeer3=post*lngroupemployee
local outputfile 120617table7.xls
xtreg lnwpart5revenue post interpeer3 postinter* if treatment==1, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg wnet_profit post interpeer3 postinter* if treatment==1, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg lnwnum_employee post interpeer3 postinter* if treatment==1, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg lnwfixasset post interpeer3 postinter* if treatment==1, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg lnmaterial post interpeer3 postinter* if treatment==1, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg lnwenergy_cost post interpeer3 postinter* if treatment==1, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg wTFP_OLS post interpeer3 postinter* if treatment==1, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg lnwnum_clients post interpeer3 postinter* if treatment==1, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg lnwnum_supplier post interpeer3 postinter* if treatment==1, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg bankloan post interpeer3 postinter* if treatment==1, fe robust cluster (clusterid)
outreg2 using `outputfile'
reg manage_z interpeer3 round1surveyfirmtype round1ind_manufacturing _Iround1cou* compinter* postinter* if treatment==1 & round>1, robust cluster (clusterid)
outreg2 using `outputfile'
reg innovation interpeer3 round1surveyfirmtype round1ind_manufacturing _Iround1cou* compinter* postinter* if treatment==1 & round>2, robust cluster (clusterid)
outreg2 using `outputfile'
xtreg lnsalesdif post interpeer3 postinter* if treatment==1, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg taxratio post interpeer3 postinter* if treatment==1, fe robust cluster (clusterid)
outreg2 using `outputfile'

*Table VIII
gen infoyes=1
replace infoyes=0 if infofundtreatment==0 & treatment==0
bysort rawnewgroupID: egen infogroup=sum(infofundtreatment)
replace infoyes=0 if infogroup==0 & treatment==1
tab infoyes
gen interinfoyes1=after1*infoyes
gen interinfoyes2=after2*infoyes
local outputfile 120617table8.xls
xtreg lnwpart5revenue after1 after2 intervention1 intervention2 interinfoyes1 interinfoyes2, fe robust cluster (clusterid) nonest
outreg2 using `outputfile'
xtreg wnet_profit after1 after2 intervention1 intervention2 interinfoyes1 interinfoyes2 if net_profit~=., fe robust cluster (clusterid) nonest
outreg2 using `outputfile'
xtreg lnwnum_employee after1 after2 intervention1 intervention2 interinfoyes1 interinfoyes2, fe robust cluster (clusterid) nonest
outreg2 using `outputfile'
xtreg lnwfixasset after1 after2 intervention1 intervention2 interinfoyes1 interinfoyes2, fe robust cluster (clusterid) nonest
outreg2 using `outputfile'
xtreg lnwenergy_cost after1 after2 intervention1 intervention2 interinfoyes1 interinfoyes2, fe robust cluster (clusterid) nonest
outreg2 using `outputfile'
xtreg lnwnum_clients after1 after2 intervention1 intervention2 interinfoyes1 interinfoyes2, fe robust cluster (clusterid) nonest
outreg2 using `outputfile'
reg manage_z after2 intervention1 intervention2 interinfoyes1 interinfoyes2 if round>1, robust cluster (clusterid)
outreg2 using `outputfile'


*Define variables for estimations of information diffusion
use 120617main, replace
keep if round==2
bysort rawnewgroupID: egen numfundinginfo=sum(infofundtreatment)
bysort rawnewgroupID: egen numbankinfo=sum(infobanktreatment)
bysort rawnewgroupID: gen groupsize=_N
gen fundinginforatio=numfundinginfo/groupsize
gen savinginforatio=numbankinfo/groupsize
gen noinfofundtreatment=1-infofundtreatment
gen noinfobanktreatment=1-infobanktreatment
gen yesloaninformed=0
replace yesloaninformed=1 if fundinginforatio>0
gen yessavinginformed=0
replace yessavinginformed=1 if savinginforatio>0
gen interinfo1=infofundtreatment*treatment
gen interinfo2=noinfofundtreatment*treatment
gen interinfo3=yesloaninformed*groupcomp
gen interinfo4=infobanktreatment*treatment
gen interinfo5=noinfobanktreatment*treatment
gen interinfo6=yessavinginformed*groupcomp
xi i.round1county
gen compinter0=round1surveyfirmtype*round1ind_manufacturing
forvalues i=2(1)26{
	gen compinter1`i'=round1surveyfirmtype*_Iround1cou_`i'
	gen compinter2`i'=round1ind_manufacturing*_Iround1cou_`i'
	gen compinter3`i'=round1surveyfirmtype*round1ind_manufacturing*_Iround1cou_`i'
}

*Table IX
local outputfile 120617table9.xls
reg knowloan_applied infofundtreatment, robust cluster (clusterid)
outreg2 using `outputfile'
reg knowloan_applied infofundtreatment interinfo1 interinfo2, robust cluster (clusterid)
outreg2 using `outputfile'
reg knowloan_applied yesloaninformed round1surveyfirmtype round1ind_manufacturing _Iround1cou_* compinter* if infofundtreatment==0 & treatment==1, robust cluster (clusterid)
outreg2 using `outputfile'
reg knowloan_applied groupcomp round1surveyfirmtype round1ind_manufacturing _Iround1cou_* compinter* if infofundtreatment==0 & treatment==1, robust cluster (clusterid)
outreg2 using `outputfile'
reg knowloan_applied yesloaninformed groupcomp interinfo3 round1surveyfirmtype round1ind_manufacturing _Iround1cou_* compinter* if infofundtreatment==0 & treatment==1, robust cluster (clusterid)
outreg2 using `outputfile'

*Table X
local outputfile 120617table10.xls
reg knowsaving_applied infobanktreatment, robust cluster (clusterid)
outreg2 using `outputfile'
reg knowsaving_applied infobanktreatment interinfo4 interinfo5, robust cluster (clusterid)
outreg2 using `outputfile'
reg knowsaving_applied yessavinginformed round1surveyfirmtype round1ind_manufacturing _Iround1cou_* compinter* if infobanktreatment==0 & treatment==1, robust cluster (clusterid)
outreg2 using `outputfile'
reg knowsaving_applied groupcomp round1surveyfirmtype round1ind_manufacturing _Iround1cou_* compinter* if infobanktreatment==0 & treatment==1, robust cluster (clusterid)
outreg2 using `outputfile'
reg knowsaving_applied yessavinginformed groupcomp interinfo6 round1surveyfirmtype round1ind_manufacturing _Iround1cou_* compinter* if infobanktreatment==0 & treatment==1, robust cluster (clusterid)
outreg2 using `outputfile'

*Table XI
use 120617partner, replace
gen midline=0
gen endline=0
replace midline=1 if round==2
replace endline=1 if round==3
gen type1=type*midline
gen type2=type*endline
local outputfile 120617table11.xls
xtreg numrefer type1 type2 peerlarge peerind, fe robust cluster (firmid)
outreg2 using `outputfile'
xtreg numcop type1 type2 peerlarge peerind, fe robust cluster (firmid)
outreg2 using `outputfile'
xtreg trust type1 type2 peerlarge peerind, fe robust cluster (firmid)
outreg2 using `outputfile'
tabstat numrefer numcop trust if type==0 


******************************************************************************************************
*******************************************Appendix Tables********************************************
*Table A1
use 120617attrition, replace
ttest firmage, by(treatment)
ttest ind_manufacturing, by(treatment)
ttest num_employee, by(treatment)
ttest bankloan, by(treatment)
ttest lnpart5revenue, by(treatment)
ttest gender, by(treatment)
ttest age, by(treatment)
ttest educ_college, by(treatment)
ttest workexp_SOEgov, by(treatment)

*Table A2
use 120617outofsample, replace
codebook firmid
tab outofsample
ttest num_employee, by(outofsample)
ttest part5revenue, by(outofsample)
ttest net_profit, by(outofsample)
ttest bankloan, by(outofsample)
ttest gender, by(outofsample)
ttest age, by(outofsample)
ttest partymember, by(outofsample)

*Table A3
use 120617main, replace
gen post=0
replace post=1 if round>1
gen intervention=treatment*post
gen interpeer3=post*lngroupemployee
gen interpeer9=post*lngroupexpsize2
*Define interactions of county, size, and industry indicators
xi i.round1county
forvalues i=2(1)26{
	gen postinter21`i'=after1*_Iround1cou_`i'
	gen postinter31`i'=after1*round1surveyfirmtype*_Iround1cou_`i'
	gen postinter41`i'=after1*round1ind_manufacturing*_Iround1cou_`i'
	gen postinter51`i'=after1*round1surveyfirmtype*round1ind_manufacturing*_Iround1cou_`i'
	gen postinter22`i'=after2*_Iround1cou_`i'
	gen postinter32`i'=after2*round1surveyfirmtype*_Iround1cou_`i'
	gen postinter42`i'=after2*round1ind_manufacturing*_Iround1cou_`i'
	gen postinter52`i'=after2*round1surveyfirmtype*round1ind_manufacturing*_Iround1cou_`i'
}
gen postinter01=after1*round1surveyfirmtype
gen postinter02=after2*round1surveyfirmtype
gen postinter11=after1*round1ind_manufacturing
gen postinter12=after2*round1ind_manufacturing
gen compinter0=round1surveyfirmtype*round1ind_manufacturing
forvalues i=2(1)26{
	gen compinter1`i'=round1surveyfirmtype*_Iround1cou_`i'
	gen compinter2`i'=round1ind_manufacturing*_Iround1cou_`i'
	gen compinter3`i'=round1surveyfirmtype*round1ind_manufacturing*_Iround1cou_`i'
}
local outputfile 120617tableA3.xls
xtreg lnwpart5revenue post interpeer3 interpeer9 if treatment==1, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg wnet_profit post interpeer3 interpeer9 if treatment==1, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg lnwnum_employee post interpeer3 interpeer9 if treatment==1, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg lnwfixasset post interpeer3 interpeer9 if treatment==1, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg lnmaterial post interpeer3 interpeer9 if treatment==1, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg lnwenergy_cost post interpeer3 interpeer9 if treatment==1, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg wTFP_OLS post interpeer3 interpeer9 if treatment==1, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg lnwnum_clients post interpeer3 interpeer9 if treatment==1, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg lnwnum_supplier post interpeer3 interpeer9 if treatment==1, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg bankloan post interpeer3 interpeer9 if treatment==1, fe robust cluster (clusterid)
outreg2 using `outputfile'
reg manage_z interpeer3 interpeer9 round1surveyfirmtype round1ind_manufacturing _Iround1cou* compinter* postinter* if treatment==1 & round>1, robust cluster (clusterid)
outreg2 using `outputfile'
reg innovation interpeer3 interpeer9 round1surveyfirmtype round1ind_manufacturing _Iround1cou* compinter* postinter* if treatment==1 & round>2, robust cluster (clusterid)
outreg2 using `outputfile'
xtreg lnsalesdif post interpeer3 interpeer9 if treatment==1, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg taxratio post interpeer3 interpeer9 if treatment==1, fe robust cluster (clusterid)
outreg2 using `outputfile'

*Table A4
use 120617controlgroup, replace
local outputfile 120617tableA4.xls
xtreg lnwpart5revenue post interpeer3 postinter*, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg net_profit post interpeer3 postinter*, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg lnwnum_employee post interpeer3 postinter*, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg lnwfixasset post interpeer3 postinter*, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg lnmaterial post interpeer3 postinter*, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg lnwenergy_cost post interpeer3 postinter*, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg wTFP_OLS post interpeer3 postinter*, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg lnwnum_clients post interpeer3 postinter*, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg lnwnum_supplier post interpeer3 postinter*, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg bankloan post interpeer3 postinter*, fe robust cluster (clusterid)
outreg2 using `outputfile'
reg manage_z post interpeer3 postinter* round1surveyfirmtype round1ind_manufacturing _Iround1cou* postinter* if round>1, robust cluster (clusterid)
outreg2 using `outputfile'
reg innovation interpeer3 postinter* round1surveyfirmtype round1ind_manufacturing _Iround1cou* postinter* if round>2, robust cluster (clusterid)
outreg2 using `outputfile'
xtreg lnsalesdif post interpeer3 postinter*, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg taxratio post interpeer3 postinter*, fe robust cluster (clusterid)
outreg2 using `outputfile'


******************************************************************************************************
*******************************************Online Appendix Tables*************************************
use 120617main, replace
gen post=0
replace post=1 if round>1
gen intervention1=treatment*after1
gen intervention2=treatment*after2
gen intervention=treatment*post

*Define interactions of county, size, and industry indicators
xi i.round1county
forvalues i=2(1)26{
	gen postinter21`i'=after1*_Iround1cou_`i'
	gen postinter31`i'=after1*round1surveyfirmtype*_Iround1cou_`i'
	gen postinter41`i'=after1*round1ind_manufacturing*_Iround1cou_`i'
	gen postinter51`i'=after1*round1surveyfirmtype*round1ind_manufacturing*_Iround1cou_`i'
	gen postinter22`i'=after2*_Iround1cou_`i'
	gen postinter32`i'=after2*round1surveyfirmtype*_Iround1cou_`i'
	gen postinter42`i'=after2*round1ind_manufacturing*_Iround1cou_`i'
	gen postinter52`i'=after2*round1surveyfirmtype*round1ind_manufacturing*_Iround1cou_`i'
}
gen postinter01=after1*round1surveyfirmtype
gen postinter02=after2*round1surveyfirmtype
gen postinter11=after1*round1ind_manufacturing
gen postinter12=after2*round1ind_manufacturing
forvalues i=2(1)26{
	gen compinter1`i'=round1surveyfirmtype*_Iround1cou_`i'
	gen compinter2`i'=round1ind_manufacturing*_Iround1cou_`i'
	gen compinter3`i'=round1surveyfirmtype*round1ind_manufacturing*_Iround1cou_`i'
}

*Table O1
local outputfile 120617tableO1.xls
xtreg lnpart5revenue after1 after2 intervention1 intervention2, fe robust cluster (clusterid) nonest
outreg2 using `outputfile'
xtreg net_profit after1 after2 intervention1 intervention2 if net_profit~=., fe robust cluster (clusterid) nonest
outreg2 using `outputfile'
xtreg lnnum_employee after1 after2 intervention1 intervention2, fe robust cluster (clusterid) nonest
outreg2 using `outputfile'
xtreg lnfixasset after1 after2 intervention1 intervention2, fe robust cluster (clusterid) nonest
outreg2 using `outputfile'
xtreg lnmaterial after1 after2 intervention1 intervention2, fe robust cluster (clusterid) nonest
outreg2 using `outputfile'
xtreg lnenergy_cost after1 after2 intervention1 intervention2, fe robust cluster (clusterid) nonest
outreg2 using `outputfile'
xtreg TFP_OLS after1 after2 intervention1 intervention2, fe robust cluster (clusterid) nonest
outreg2 using `outputfile'
xtreg lnnum_clients after1 after2 intervention1 intervention2, fe robust cluster (clusterid) nonest
outreg2 using `outputfile'
xtreg lnnum_supplier after1 after2 intervention1 intervention2, fe robust cluster (clusterid) nonest
outreg2 using `outputfile'

*Table O2
gen interheter11=post*round1lnemployee
gen interheter12=post*treatment*round1lnemployee
gen interheter21=post*round1age
gen interheter22=post*treatment*round1age
gen interheter31=post*round1educ
gen interheter32=post*treatment*round1educ
gen interheter41=post*round1con
gen interheter42=post*treatment*round1con
gen interheter13=post*treatment*peersizedif
local outputfile 120617tableO2.xls
xtreg lnwpart5revenue post intervention interheter11 interheter12 interheter13, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg wnet_profit post intervention interheter11 interheter12 interheter13, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg lnwnum_employee post intervention interheter11 interheter12 interheter13, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg lnwfixasset post intervention interheter11 interheter12 interheter13, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg lnwmaterial post intervention interheter11 interheter12 interheter13, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg lnwenergy_cost post intervention interheter11 interheter12 interheter13, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg wTFP_OLS post intervention interheter11 interheter12 interheter13, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg lnwpart5revenue post intervention interheter21 interheter22 interheter13, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg wnet_profit post intervention interheter21 interheter22 interheter13, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg lnwnum_employee post intervention interheter21 interheter22 interheter13, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg lnwfixasset post intervention interheter21 interheter22 interheter13, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg lnwmaterial post intervention interheter21 interheter22 interheter13, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg lnwenergy_cost post intervention interheter21 interheter22 interheter13, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg wTFP_OLS post intervention interheter21 interheter22 interheter13, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg lnwpart5revenue post intervention interheter31 interheter32 interheter13, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg wnet_profit post intervention interheter31 interheter32 interheter13, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg lnwnum_employee post intervention interheter31 interheter32 interheter13, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg lnwfixasset post intervention interheter31 interheter32 interheter13, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg lnwmaterial post intervention interheter31 interheter32 interheter13, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg lnwenergy_cost post intervention interheter31 interheter32 interheter13, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg wTFP_OLS post intervention interheter31 interheter32 interheter13, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg lnwpart5revenue post intervention interheter41 interheter42 interheter13, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg wnet_profit post intervention interheter41 interheter42 interheter13, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg lnwnum_employee post intervention interheter41 interheter42 interheter13, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg lnwfixasset post intervention interheter41 interheter42 interheter13, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg lnwmaterial post intervention interheter41 interheter42 interheter13, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg lnwenergy_cost post intervention interheter41 interheter42 interheter13, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg wTFP_OLS post intervention interheter41 interheter42 interheter13, fe robust cluster (clusterid)
outreg2 using `outputfile'

*Table O3
bysort firmid (round): replace rawgrouptype=rawgrouptype[_cons] if treatment==1
xi i.rawgrouptype
gen _Irawgroupt_1=0
replace _Irawgroupt_1=1 if rawgrouptype=="1"
forvalues i=1(1)4{
	replace _Irawgroupt_`i'=0 if treatment==0
	gen grouppostinter`i'=post*_Irawgroupt_`i'
}
local outputfile 120617tableO3.xls
xtreg lnwpart5revenue post grouppostinter* postinter*, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg wnet_profit post grouppostinter* postinter*, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg lnwnum_employee post grouppostinter*, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg lnwfixasset post grouppostinter* postinter*, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg lnwmaterial post grouppostinter* postinter*, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg lnwenergy_cost post grouppostinter* postinter*, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg wTFP_OLS post grouppostinter* postinter*, fe robust cluster (clusterid)
outreg2 using `outputfile'

*Table O4
*peer connection
gen interpeer3=post*lngroupemployee
gen interpeer7=post*grouppol
local outputfile 120617tableO4.xls
xtreg lnwpart5revenue post interpeer3 interpeer7 postinter* if treatment==1, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg wnet_profit post interpeer3 interpeer7 postinter* if treatment==1, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg lnwnum_employee post interpeer3 interpeer7 postinter* if treatment==1, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg wTFP_OLS post interpeer3 interpeer7 postinter* if treatment==1, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg lnwnum_clients post interpeer3 interpeer7 postinter* if treatment==1, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg lnwnum_supplier post interpeer3 interpeer7 postinter* if treatment==1, fe robust cluster (clusterid)
outreg2 using `outputfile'
reg manage_z interpeer3 interpeer7 postinter* if treatment==1 & round>1, robust cluster (clusterid)
outreg2 using `outputfile'

*Table O5
*cash grant
gen intercash1=after1*cashgrant
gen intercash2=after2*cashgrant
local outputfile 120617tableO5.xls
xtreg lnwpart5revenue after1 after2 intervention1 intervention2 intercash1 intercash2, fe robust cluster (clusterid) nonest
outreg2 using `outputfile'
xtreg wnet_profit after1 after2 intervention1 intervention2 intercash1 intercash2 if net_profit~=., fe robust cluster (clusterid) nonest
outreg2 using `outputfile'
xtreg lnwnum_employee after1 after2 intervention1 intervention2 intercash1 intercash2, fe robust cluster (clusterid) nonest
outreg2 using `outputfile'
xtreg lnwfixasset after1 after2 intervention1 intervention2 intercash1 intercash2, fe robust cluster (clusterid) nonest
outreg2 using `outputfile'
xtreg lnwenergy_cost after1 after2 intervention1 intervention2 intercash1 intercash2, fe robust cluster (clusterid) nonest
outreg2 using `outputfile'
xtreg lnwnum_clients after1 after2 intervention1 intervention2 intercash1 intercash2, fe robust cluster (clusterid) nonest
outreg2 using `outputfile'
reg manage_z after2 intervention1 intervention2 intercash1 intercash2, robust cluster (clusterid)
outreg2 using `outputfile'

*Table O6
gen interinfo1=after1*infobanktreatment
gen interinfo2=after2*infobanktreatment
local outputfile 120617tableO6.xls
xtreg lnwpart5revenue after1 after2 interinfo1 interinfo2 if treatment==0, fe robust cluster (clusterid) nonest
outreg2 using `outputfile'
xtreg wnet_profit after1 after2 interinfo1 interinfo2 if net_profit~=. & treatment==0, fe robust cluster (clusterid) nonest
outreg2 using `outputfile'
xtreg lnwnum_employee after1 after2 interinfo1 interinfo2 if treatment==0, fe robust cluster (clusterid) nonest
outreg2 using `outputfile'
xtreg lnwfixasset after1 after2 interinfo1 interinfo2 if treatment==0, fe robust cluster (clusterid) nonest
outreg2 using `outputfile'
xtreg lnwmaterial after1 after2 interinfo1 interinfo2 if treatment==0, fe robust cluster (clusterid) nonest
outreg2 using `outputfile'
xtreg lnwenergy_cost after1 after2 interinfo1 interinfo2 if treatment==0, fe robust cluster (clusterid) nonest
outreg2 using `outputfile'
xtreg wTFP_OLS after1 after2 interinfo1 interinfo2 if treatment==0, fe robust cluster (clusterid) nonest
outreg2 using `outputfile'

*Table O7
use 120617main, replace
keep if round==2
bysort rawnewgroupID: egen numfundinginfo=sum(infofundtreatment)
bysort rawnewgroupID: egen numbankinfo=sum(infobanktreatment)
bysort rawnewgroupID: gen groupsize=_N
gen fundinginforatio=numfundinginfo/groupsize
gen savinginforatio=numbankinfo/groupsize
gen noinfofundtreatment=1-infofundtreatment
gen noinfobanktreatment=1-infobanktreatment
gen yesloaninformed=0
replace yesloaninformed=1 if fundinginforatio>0
gen yessavinginformed=0
replace yessavinginformed=1 if savinginforatio>0

gen funding50=0
gen funding80=0
gen saving50=0
gen saving80=0
replace funding50=1 if fundinginforatio~=0 & fundinginforatio<0.66
replace funding80=1 if fundinginforatio~=0 & fundinginforatio>0.65
replace saving50=1 if savinginforatio~=0 & savinginforatio<0.6
replace saving80=1 if savinginforatio~=0 & savinginforatio>0.599
xi i.round1county
gen compinter0=round1surveyfirmtype*round1ind_manufacturing
forvalues i=2(1)26{
	gen compinter1`i'=round1surveyfirmtype*_Iround1cou_`i'
	gen compinter2`i'=round1ind_manufacturing*_Iround1cou_`i'
	gen compinter3`i'=round1surveyfirmtype*round1ind_manufacturing*_Iround1cou_`i'
}
local outputfile 120617tableO7.xls
reg knowloan_applied funding50 funding80 round1surveyfirmtype round1ind_manufacturing _Iround1cou_* compinter* if infofundtreatment==0 & treatment==1, robust cluster (clusterid)
outreg2 using `outputfile'
reg knowsaving_applied saving50 saving80 round1surveyfirmtype round1ind_manufacturing _Iround1cou_* compinter* if infobanktreatment==0 & treatment==1, robust cluster (clusterid)
outreg2 using `outputfile'

*Table O8
use 120617main, replace
gen post=0
replace post=1 if round>1
gen intervention1=treatment*after1
gen intervention2=treatment*after2
gen intervention=treatment*post
xi i.round1county
forvalues i=2(1)26{
	gen postinter21`i'=after1*_Iround1cou_`i'
	gen postinter31`i'=after1*round1surveyfirmtype*_Iround1cou_`i'
	gen postinter41`i'=after1*round1ind_manufacturing*_Iround1cou_`i'
	gen postinter51`i'=after1*round1surveyfirmtype*round1ind_manufacturing*_Iround1cou_`i'
	gen postinter22`i'=after2*_Iround1cou_`i'
	gen postinter32`i'=after2*round1surveyfirmtype*_Iround1cou_`i'
	gen postinter42`i'=after2*round1ind_manufacturing*_Iround1cou_`i'
	gen postinter52`i'=after2*round1surveyfirmtype*round1ind_manufacturing*_Iround1cou_`i'
}
gen postinter01=after1*round1surveyfirmtype
gen postinter02=after2*round1surveyfirmtype
gen postinter11=after1*round1ind_manufacturing
gen postinter12=after2*round1ind_manufacturing
forvalues i=2(1)26{
	gen compinter1`i'=round1surveyfirmtype*_Iround1cou_`i'
	gen compinter2`i'=round1ind_manufacturing*_Iround1cou_`i'
	gen compinter3`i'=round1surveyfirmtype*round1ind_manufacturing*_Iround1cou_`i'
}
gen interpeer2=post*groupcomp
local outputfile 120617tableO8.xls
xtreg lnwpart5revenue post interpeer2 postinter* if treatment==1, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg wnet_profit post interpeer2 postinter* if treatment==1, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg lnwnum_employee post interpeer2 postinter* if treatment==1, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg wTFP_OLS post interpeer2 postinter* if treatment==1, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg lnwnum_clients post interpeer2 postinter* if treatment==1, fe robust cluster (clusterid)
outreg2 using `outputfile'
xtreg lnwnum_supplier post interpeer2 postinter* if treatment==1, fe robust cluster (clusterid)
outreg2 using `outputfile'
reg manage_z interpeer2 postinter* if treatment==1 & round>1, robust cluster (clusterid)
outreg2 using `outputfile'
xtreg salesprofit post interpeer2 postinter* if treatment==1, fe robust cluster (clusterid)
outreg2 using `outputfile'
