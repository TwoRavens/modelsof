
*preliminaries
cd "C:\Users\Chris\Dropbox\Research\Dangerous Lessons - JPR - 2016\Data\"
log using altanalysis, text replace


*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* DANGEROUS LESSONS --- alternate analyses in tables 8--10 of appendix.
*
* Christopher Linebarger
*
* Journal of Peace Research
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------


use jpr-alternate-data2.dta, clear

set more off


*Table 8.  Models 15-16. Models using Colgan variant of rev regimes.
*cultural and political similarity

	
*M15 ; respecification of model 5
set more off
logit binaryformation   l_beaconongoing_sim_contig1 l_beaconongoing_sim_contig6 l_beaconongoing_dissim_contig1 l_beaconongoing_dissim_contig6 allinc3 ncivwar   demo demo3000prop neighlgdp lgdp96l lnpop group1 group2 group3 i.year if year >1967 , robust cl(ccode)
	
	
*M16; respecification of model 6
logit binaryformation l_beaconsimcontig1regime l_beacondissimcontig1regime l_beaconsimcontig6regime l_beacondissimcontig6regime allinc3 ncivwar  demo demo3000prop neighlgdp lgdp96l lnpop group1 group2 group3 i.year if year > 1967, robust cl(ccode)
	


	
	
* Table 9	
*Models using minimum distance

*M17
set more off
*nearest rev regimes (cultrual sim)		
logit binaryformation l_beaconsimmindist  l_beacondissimmindist allinc3 ncivwar demo demo3000prop neighlgdp lgdp96l lnpop group1 group2 group3 i.year if year > 1967 , robust cl(ccode)

*M18
logit binaryformation l_beaconregimesimmindist l_beaconregimedissimmindist  ncivwar  allinc3  demo demo3000prop neighlgdp lgdp96l lnpop group1 group2 group3 i.year if year > 1967 , robust cl(ccode)


	
	
*Table 10	
*Models with Young and Dugan / Aksoy and Carter dependent variable
*M19
logit groupst l_beaconongoing_sim_contig1 l_beaconongoing_sim_contig6 l_beaconongoing_dissim_contig1  l_beaconongoing_dissim_contig6 allinc3 ncivwar  demo demo3000prop neighlgdp lgdp96l lnpop emergeyrs emergeyrs2 emergeyrs3 i.year if year >1967 , robust cl(ccode)

*M20
logit groupst l_beaconsimcontig1regime l_beaconsimcontig6regime l_beacondissimcontig1regime l_beacondissimcontig6regime allinc3 ncivwar  demo demo3000prop neighlgdp lgdp96l lnpop emergeyrs emergeyrs2 emergeyrs3 i.year if year > 1967, robust cl(ccode)	

	
clear
log close
