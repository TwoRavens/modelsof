********************************************************************************************************************************************
********************************************************************************************************************************************
*
* Replication File: Economic Responsiveness and the Political Conditioning of the Electoral Cycle
*
* Sergi Pardos-Prado (sergi.pardos@merton.ox.ac.uk) Merton College - University of Oxford
* Iñaki Sagarzazu (inaki.sagarzazu@ttu.edu) Texas Tech University
*
********************************************************************************************************************************************
********************************************************************************************************************************************


cd "~/Dropbox/PardosSagarzazu/SECOND PAPER - Economy Attention/JOP Submission/Replication/final files"
*use "C:\Users\Sergi\Dropbox\PardosSagarzazu\SECOND PAPER - Economy Attention\new data in wide format.dta", clear

log using "PargosSagarzazu_JOP.smcl", replace
use "PardosSagarzazu_JOP.dta", clear


sort timereal
tsset timereal


***************************************************************************************************
*FIGURE 3: Attention to the Economy by party
***************************************************************************************************

gen x = ano + (mesNum -1)/12

line p_popular x || line p_socialista x, lpattern("--..") /*
*/ scheme(lean2) legend(label(1 "PP") label(2 "PSOE") pos(6) cols(2)) /*
*/ xlabel(1996(4)2011) xline(2000 2004 2008) ylabel(, nogrid)/*
*/ text(.5 1998 "VI") text(.5 2002 "VII")  text(.5 2006 "VIII")  text(.5 2010 "IX") /*
*/ ytitle("Attention to the Economy") xtitle("Time (months)") 


graph export "figure3.pdf", as(pdf) replace



***************************************************************************************************
*TABLE 2: ADL models predicting government and opposition economic attention 
***************************************************************************************************



reg gov_saliency  l.gov_saliency unemp l.unemp gdp_growth l.gdp_growth mip_imputed  l.mip_imputed  econcurrent_agr l.econcurrent_agr ///
opp_mainparty l.opp_mainparty media l.media timereal

est store direct1


reg opp_mainparty  l.opp_mainparty  unemp l.unemp gdp_growth l.gdp_growth mip_imputed  l.mip_imputed econcurrent_agr l.econcurrent_agr ///
gov_saliency l.gov_saliency media l.media timereal

est store direct2


estout direct1 direct2, cells(b(star fmt(4)) se(par fmt(3)))   ///
   legend label varlabels(_cons constant) starlevels(* 0.1 ** 0.05 *** 0.01)               ///
   stats(N F r2 ll bic, fmt(3 0 3) label(N F R-sqr LogLik BIC)) style(tex)
   
   
   
   
***************************************************************************************************
*TABLE 3: ADL models with electoral cycle interactions
***************************************************************************************************


reg gov_saliency   l.opp_mainparty l.elecycle l.oppmain_cycle l.gov_saliency opp_mainparty unemp l.unemp gdp_growth l.gdp_growth  ///
mip_imputed l.mip_imputed econcurrent_agr l.econcurrent_agr  media l.media timereal  /*this works!*/
 
est store gov_cycle1

reg gov_saliency l.mip_imputed l.elecycle l.mipimput_cycle l.gov_saliency mip_imputed opp_mainparty l.opp_mainparty unemp l.unemp gdp_growth l.gdp_growth  ///
econcurrent_agr l.econcurrent_agr  media l.media timereal


est store gov_cycle2


reg opp_mainparty  l.gov_saliency l.elecycle l.gov_cycle gov_saliency l.opp_mainparty unemp l.unemp gdp_growth l.gdp_growth  ///
mip_imputed l.mip_imputed econcurrent_agr l.econcurrent_agr  media l.media timereal  
 
est store opp_cycle1


reg opp_mainparty l.mip_imputed l.elecycle l.mipimput_cycle l.gov_saliency gov_saliency mip_imputed  l.opp_mainparty unemp l.unemp gdp_growth l.gdp_growth  ///
econcurrent_agr l.econcurrent_agr  media l.media timereal


est store opp_cycle2


   
estout gov_cycle1 gov_cycle2 opp_cycle1 opp_cycle2, cells(b(star fmt(4)) se(par fmt(3)))   ///
   legend label varlabels(_cons constant) starlevels(* 0.1 ** 0.05 *** 0.01)               ///
   stats(N F r2 ll bic, fmt(3 0 3) label(N F R-sqr LogLik BIC)) style(tex)

   
   
   
   
***************************************************************************************************
*FIGURE 4: Marginal effects on government economic attention
***************************************************************************************************

   

*Interaction graphs

est restore gov_cycle1 // opo

capture drop MV conb conse a upper lower
generate MV=timereal

replace MV=. if timereal >33


matrix b=e(b)
matrix V=e(V)
scalar b1=b[1,1]
scalar b2=b[1,2]
scalar b3=b[1,3]
scalar varb1=V[1,1]
scalar varb2=V[2,2]
scalar varb3=V[3,3]
scalar covb1b3=V[1,3]
scalar covb2b3=V[2,3]

gen conb=b1+b3*MV if timereal <34

gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV)

gen a=1.96*conse
gen upper=conb+a
gen lower=conb-a

graph twoway line conb MV, clwidth(medium) clcolor(blue) clcolor(black) || line upper MV, clpattern(dash) clwidth(thin) clcolor(black) || /*
*/ line lower MV, clpattern(dash) clwidth(thin) clcolor(black) ||, xlabel(0(1)33, labsize(2.5)) ylabel(-0.5 0 0.5, labsize(2.5)) /*
*/ yscale(noline) xscale(noline) yline(0, lcolor(black)) legend (off)/*
*/ xtitle(Electoral cycle (N of months since inauguration), size(3) ) xsca(titlegap(2)) ysca(titlegap(2)) ytitle(Marginal effect of opposition attention, size(3)) scheme(s2mono) graphregion(fcolor(white)) 

graph export opp1.pdf, as(pdf) replace

est restore gov_cycle2 // mip


capture drop MV conb conse a upper lower
generate MV=timereal

replace MV=. if timereal >33


matrix b=e(b)
matrix V=e(V)
scalar b1=b[1,1]
scalar b2=b[1,2]
scalar b3=b[1,3]
scalar varb1=V[1,1]
scalar varb2=V[2,2]
scalar varb3=V[3,3]
scalar covb1b3=V[1,3]
scalar covb2b3=V[2,3]

gen conb=b1+b3*MV if timereal <34

gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV)

gen a=1.96*conse
gen upper=conb+a
gen lower=conb-a


graph twoway line conb MV, clwidth(medium) clcolor(blue) clcolor(black) || line upper MV, clpattern(dash) clwidth(thin) clcolor(black) || /*
*/ line lower MV, clpattern(dash) clwidth(thin) clcolor(black) ||, xlabel(0(1)33, labsize(2.5)) ylabel(-0.5 0 0.5, labsize(2.5)) /*
*/ yscale(noline) xscale(noline) yline(0, lcolor(black)) legend (off)/*
*/ xtitle(Electoral cycle (N of months since inauguration), size(3) ) xsca(titlegap(2)) ysca(titlegap(2)) ytitle(Marginal effect of MIP, size(3)) scheme(s2mono) graphregion(fcolor(white)) 

graph export mip1.pdf, as(pdf) replace

log close
