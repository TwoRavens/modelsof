*Replication File for Goenner "From Toys to Warchips" WEB-APPENDIX


*TABLE 1 IMPORT DEMAND ELASTICITY RELATIONS ACROSS COUNTRIES
use "C:\Documents and Settings\CGOENNER\My Documents\Research\New Trade\DATA\Broda\Sigmas73countries_9403_HS3digit.dta", clear
rename ccode cno
rename hs_3digit hscode3
rename sigma Import_Elasticity

gen lnIE = ln(Import_Elasticity)

by hscode3, sort: egen numIE = count(Import_Elasticity)

by hscode3, sort: egen meanlnIE = mean(lnIE)
by hscode3, sort: egen meanIE = mean(Import_Elasticity)

gen meanIE_n = (numIE*meanIE - Import_Elasticity)/(numIE -1)
gen meanlnIE_n = (numIE*meanlnIE - lnIE)/(numIE -1)

egen id = group(cno), missing

local i = 1

while `i' <= 73 {
	regress lnIE meanlnIE_n if id == `i'
	estimates store country`i'
	local i = `i' +1
}

estimates table c*, keep(meanlnIE_n) se t

*TABLE 2 IMPORT DEMAND OVER TIME
use "C:\Documents and Settings\CGOENNER\My Documents\Research\New Trade\DATA\REPLICATE\FINAL\web-appendix\ImportDemand_year.dta", clear
regress lned88 lned01


*TABLE 3 - EXPORT SUPPLY RELATIONS ACROSS COUNTRIES
use "C:\Documents and Settings\CGOENNER\My Documents\Research\New Trade\DATA\REPLICATE\FINAL\web-appendix\ExportS.dta", clear 

gen lnEE = ln(Export_Elasticity)

by hscode4, sort: egen numEE = count(Export_Elasticity)

by hscode4, sort: egen meanlnEE = mean(lnEE)
by hscode4, sort: egen meanEE = mean(Export_Elasticity)

gen meanEE_n = (numEE*meanEE - Export_Elasticity)/(numEE -1)
gen meanlnEE_n = (numEE*meanlnEE - lnEE)/(numEE -1)

egen id = group(cno), missing

local i = 1
while `i' <= 16 {
	regress lnEE meanlnEE_n if id == `i'
	estimates store country`i'
	local i = `i' +1
}

estimates table c*, keep(meanlnEE_n) se t



*TABLE 4 SEQ MODEL - BASE MODEL
*Level
cdsimeq (bitrade_kpr bitrade_kprlag rgdpa rgdpb pop1 pop2 distance jntdem2 allies contigkb)( mzonset jntdem2 allies contigkb distance capratio majdyd lnhighrgdp lowgrowth mzpceyrs mzpyrs1 mzpyrs2 mzpyrs3), suppress1(yes) 
*Zeros dropped
cdsimeq (lnbitradeZ_kpr lnbitradeZ_kprlag lnpop1 lnpop2 lnrgdpa lnrgdpb distance jntdem2 allies contigkb)(mzonset jntdem2 allies contigkb distance capratio majdyd lnhighrgdp lowgrowth mzpceyrs mzpyrs1 mzpyrs2 mzpyrs3), suppress1(yes) 


*TABLE 5 SEQ MODEL - PATTERN OF TRADE ENDOGENOUS
*Levels
cdsimeq (bitrade_kpr bitrade_kprlag rgdpa rgdpb pop1 pop2 distance jntdem2 allies contigkb)( mzonset jntdem2 allies contigkb distance capratio majdyd lnhighrgdp lowgrowth mzpceyrs mzpyrs1 mzpyrs2 mzpyrs3 bitrade1_kpr bitrade2_kpr bitrade3_kpr bitrade4_kpr bitrade5_kpr bitrade6_kpr), suppress1(yes) 
*Zeros dropped
cdsimeq (lnbitradeZ_kpr lnbitradeZ_kprlag lnpop1 lnpop2 lnrgdpa lnrgdpb distance jntdem2 allies contigkb)(mzonset jntdem2 allies contigkb distance capratio majdyd lnhighrgdp lowgrowth mzpceyrs mzpyrs1 mzpyrs2 mzpyrs3 bitrade1_kpr bitrade2_kpr bitrade3_kpr bitrade4_kpr bitrade5_kpr bitrade6_kpr), suppress1(yes) 

*TABLE 6 SEQ MODEL - PATTERN OF STRATEGIC TRADE ENDOGENOUS
*Levels 
cdsimeq (bitrade1_kpr bitrade1_kprlag rgdpa rgdpb pop1 pop2 distance jntdem2 allies contigkb)( mzonset bitrade_kpr jntdem2 allies contigkb distance capratio majdyd lnhighrgdp lowgrowth mzpceyrs mzpyrs1 mzpyrs2 mzpyrs3), suppress1(yes) 
cdsimeq (bitrade2_kpr bitrade2_kprlag rgdpa rgdpb pop1 pop2 distance jntdem2 allies contigkb)( mzonset bitrade_kpr jntdem2 allies contigkb distance capratio majdyd lnhighrgdp lowgrowth mzpceyrs mzpyrs1 mzpyrs2 mzpyrs3), suppress1(yes) 
cdsimeq (bitrade3_kpr bitrade3_kprlag rgdpa rgdpb pop1 pop2 distance jntdem2 allies contigkb)( mzonset bitrade_kpr jntdem2 allies contigkb distance capratio majdyd lnhighrgdp lowgrowth mzpceyrs mzpyrs1 mzpyrs2 mzpyrs3), suppress1(yes) 
cdsimeq (bitrade4_kpr bitrade4_kprlag rgdpa rgdpb pop1 pop2 distance jntdem2 allies contigkb)( mzonset bitrade_kpr jntdem2 allies contigkb distance capratio majdyd lnhighrgdp lowgrowth mzpceyrs mzpyrs1 mzpyrs2 mzpyrs3), suppress1(yes)  
cdsimeq (bitrade5_kpr bitrade5_kprlag rgdpa rgdpb pop1 pop2 distance jntdem2 allies contigkb)( mzonset bitrade_kpr jntdem2 allies contigkb distance capratio majdyd lnhighrgdp lowgrowth mzpceyrs mzpyrs1 mzpyrs2 mzpyrs3), suppress1(yes)  
cdsimeq (bitrade6_kpr bitrade6_kprlag rgdpa rgdpb pop1 pop2 distance jntdem2 allies contigkb)( mzonset bitrade_kpr jntdem2 allies contigkb distance capratio majdyd lnhighrgdp lowgrowth mzpceyrs mzpyrs1 mzpyrs2 mzpyrs3), suppress1(yes) 

