use "USOM_CSES.dta",clear
set more off

**generating variables

tab ti_cpi
recode ti_cpi (0/3.99=1) (4/6.99=2) (7/10.99=3), gen(cpi33)
bysort cpi33: tab swede

recode rarutomlands (0/10=0) (11/max=1), gen(ar)
recode f2 (2005/max=1) (else=0) , gen(ar2)

***Variable coding***

tab edu
recode edu (1/2=1) (3/4=2) (5/6=3) (7/8=4), gen(edu4)

tab age
recode age (16/29=1) (30/49=2) (50/64=3) (65/max=4), gen (age4)
gen agexage=age*age

tab swd

program rescale 
args oldvar newmin newmax
qui sum `oldvar'
local oldmin=r(min)
local rangequota=(`newmax'-`newmin')/(r(max)-r(min))
replace `oldvar'=(`oldvar'-`oldmin')*`rangequota'+`oldmin'+(`newmin'-`oldmin')
end

rescale swd 0 1

**country of birth
tab countryofbirth
tab countryofbirth, nolab
recode countryofbirth (997/max=.)
gen CoB=0 
recode CoB (0=1) if ccode!=countryofbirth & swede==0
tab CoB

**imputations

**occup
impute occup3 kon age agexage edu civil ar2 if cpi33==1 & swede==0, gen(occupIMP1)
replace occup3=occupIMP1 if occup3==.
impute occup3 kon age agexage edu civil ar2 if cpi33==2 & swede==0, gen(occupIMP2)
replace occup3=occupIMP2 if occup3==.
impute occup3 kon age agexage edu civil ar2 if cpi33==3 & swede==0, gen(occupIMP3)
replace occup3=occupIMP3 if occup3==.

gen occupI=round(occup3)
tab occupI

**barn
tab barn
impute barn kon age agexage edu civil ar2 if cpi33==1 & swede==0, gen(barnIMP1)
replace barn=barnIMP1 if barn==.
impute barn kon age agexage edu civil ar2 if cpi33==2 & swede==0, gen(barnIMP2)
replace barn=barnIMP2 if barn==.
impute barn kon age agexage edu civil ar2 if cpi33==3 & swede==0, gen(barnIMP3)
replace barn=barnIMP3 if barn==.

gen barnI=round(barn)
recode barnI (-1=.)
tab barnI

**bor
impute bor kon age agexage edu civil ar2 if cpi33==1 & swede==0, gen(borIMP1)
replace bor=borIMP1 if bor==.
impute bor kon age agexage edu civil ar2 if cpi33==2 & swede==0, gen(borIMP2)
replace bor=borIMP2 if bor==.
impute bor kon age agexage edu civil ar2 if cpi33==3 & swede==0, gen(borIMP3)
replace bor=borIMP3 if bor==.

gen borI=round(bor)
tab borI

**VH
impute VH kon age agexage edu civil ar2 if cpi33==1 & swede==0, gen(vhIMP1)
replace VH=vhIMP1 if VH==.
impute VH kon age agexage edu civil ar2 if cpi33==2 & swede==0, gen(vhIMP2)
replace VH=vhIMP2 if VH==.
impute VH kon age agexage edu civil ar2 if cpi33==3 & swede==0, gen(vhIMP3)
replace VH=vhIMP3 if VH==.

gen VHI=round(VH)
tab VHI

**remove countries with less than 100 resp
bysort ccode: gen N=_N
tab N

keep if N>100

**Drop countries without Swedish expatriates

drop if ccode==100
drop if ccode==208
drop if ccode==352
drop if ccode==372
drop if ccode==404
drop if ccode==410
drop if ccode==499
drop if ccode==604
drop if ccode==703
drop if ccode==705
drop if ccode==752

**remove countries with less than 10 swedes by ccode

bysort ccode: egen NSS=total(swede) if swede==1
tab NSS
drop if NSS<10
tab NSS

*only after 2010
keep if year>2009

**first cut

xtset ccode
xtreg swd kon i.age4 occupI  i.edu4 voted i.VHI i.civil barnI ar2 borI PID  i.swede##c.ti_cpi, re vce(robust)

keep if e(sample)

*********************
**Analyses in paper**
*********************

*Figure 1 

xtreg swd kon i.age4 i.edu4 i.civil ar2 i.occupI borI barnI i.VHI PID voted swede##c.ti_cpi, re
margins, at(ti_cpi=(1(1)10)  swede=(0 1)) atmeans
marginsplot, scheme(s1mono)

**Figure 2

tab rarutomlands
gen agex=age if swede==0
egen artot=rowmean(agex rarutomlands)

xtreg swd kon i.age4 occupI  voted i.VHI i.civil barnI c.artot##i.swede  borI PID if cpi33==1, fe vce(robust)
margins, at(artot=(0(1)60)  swede=(0 1)) atmeans
marginsplot, scheme(s1mono)

*testing VIF in relation to figure 2

reg swd kon i.age4 occupI  i.edu4 voted i.VHI i.civil barnI artot1 borI PID  c.artot1##i.swede if cpi33==1
estat vif
reg swd kon i.age4 occupI  i.edu4 voted i.VHI i.civil barnI artot1 borI PID  c.artot1##i.swede##c.ti_cpi
estat vif

***********************
*******Appendix*******
***********************

**Applying controls for economic development and type of democracy - using gdp instead of CPI

xtreg swd kon i.age4 occupI i.edu4  voted i.VHI i.civil barnI ar2 borI PID swede gle_cgdpc ti_cpi, re vce(robust)
estimates store m1, title(Model 1)
xtreg swd kon i.age4 occupI  i.edu4 voted i.VHI i.civil barnI ar2 borI PID  i.swede##c.ti_cpi gle_cgdpc , re vce(robust)
estimates store m2, title(Model 2)
xtreg swd kon i.age4 occupI  i.edu4 voted i.VHI i.civil barnI ar2 borI PID  i.swede##c.gle_cgdpc ti_cpi, re vce(robust)
estimates store m3, title(Model 3)
xtreg swd kon i.age4 occupI  i.edu4 voted i.VHI i.civil barnI ar2 borI PID  i.swede##c.gle_cgdpc i.swede##c.ti_cpi, re vce(robust)
estimates store m4, title(Model 4)

esttab m1 m2 m3 m4, cells(b(star fmt(%9.3f)) se(par)) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-squared))      ///
legend label collabels(none) varlabels(_cons Constant) ///
substitute("\fonttbl{\f0\fnil Times New Roman" "\fonttbl{\f0\fnil Arial" "\fs24" "\fs16" "\fs20" "\fs16" "\super" "") 


xtreg swd kon i.age4 occupI  i.edu4 voted i.VHI i.civil barnI ar2 borI PID  i.swede##c.gle_cgdpc i.swede##c.ti_cpi, re vce(robust)
margins, at(ti_cpi=(1(1)10)  swede=(0 1)) atmeans
marginsplot, scheme(s1mono)

tab gle_cgdpc
xtreg swd kon i.age4 occupI  i.edu4 voted i.VHI i.civil barnI ar2 borI PID  i.swede##c.gle_cgdpc i.swede##c.ti_cpi, re vce(robust)
margins, at(gle_cgdpc=(3729(1000)61812)  swede=(0 1)) atmeans
marginsplot, scheme(s1mono)

*robustness controlling for majoritarianism and GDP fe - graph

xtreg swd kon i.age4 occupI i.edu4  voted i.VHI i.civil barnI ar2 borI PID swede i.gol_est if cpi33==1, fe vce(robust)
estimate store O
xtreg swd kon i.age4 occupI i.edu4  voted i.VHI i.civil barnI ar2 borI PID swede  i.gol_est if cpi33==2, fe vce(robust)
estimate store N
xtreg swd kon i.age4 occupI i.edu4  voted i.VHI i.civil barnI ar2 borI PID  swede i.gol_est if cpi33==3, fe vce(robust)
estimate store P

 coefplot (O, label(High Global Corruption)  offset(0.05)) ///
(N, label(Medium Global Corruption)  offset(0.00)) ///
(P, label(Low Global Corruption)  offset(-0.05)) ///
,msymbol(0) level(84) mlabel format(%9.2g)mlabposition(12)mlabgap(*2) keep(swede)xline(0) xtitle(Swedish Expatriates)


xtreg swd kon i.age4 occupI i.edu4  voted i.VHI i.civil barnI ar2 borI PID swede  gle_cgdpc if cpi33==1, fe vce(robust)
estimate store O
xtreg swd kon i.age4 occupI i.edu4  voted i.VHI i.civil barnI ar2 borI PID swede  gle_cgdpc if cpi33==2, fe vce(robust)
estimate store N
xtreg swd kon i.age4 occupI i.edu4  voted i.VHI i.civil barnI ar2 borI PID swede  gle_cgdpc if cpi33==3, fe vce(robust)
estimate store P

 coefplot (O, label(High Global Corruption)  offset(0.05)) ///
(N, label(Medium Global Corruption)  offset(0.00)) ///
(P, label(Low Global Corruption)  offset(-0.05)) ///
,msymbol(0) level(84) mlabel format(%9.2g)mlabposition(12)mlabgap(*2) keep(swede)xline(0) xtitle(Swedish Expatriates)

*Table A1 in online appendix

preserve
collapse year N NSS cpi33, by(ccode cname)
sort cpi33
order cname year N NSS
restore 

*Table A4

xtreg swd kon i.age4 occupI i.edu4  voted i.VHI i.civil barnI ar2 borI PID swede ti_cpi, re vce(robust)
estimates store m1, title(Model 1)
xtreg swd kon i.age4 occupI  i.edu4 voted i.VHI i.civil barnI ar2 borI PID  i.swede##c.ti_cpi, re vce(robust)
estimates store m2, title(Model 2)

esttab m1 m2 , cells(b(star fmt(%9.3f)) se(par)) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-squared))      ///
legend label collabels(none) varlabels(_cons Constant) ///
substitute("\fonttbl{\f0\fnil Times New Roman" "\fonttbl{\f0\fnil Arial" "\fs24" "\fs16" "\fs20" "\fs16" "\super" "") 

*Table A5
**hausman test
xtreg swd kon i.age4 occupI i.edu4  voted i.VH i.civil barn ar2 bor PID swede, re  
estimate store re
xtreg swd kon i.age4 occupI i.edu4  voted i.VH i.civil barn ar2 bor PID swede, fe
estimate store fe
hausman re fe

xtreg swd kon i.age4 occupI i.edu4  voted i.VHI i.civil barnI c.artot1##i.swede  borI PID  if cpi33==1, fe vce(robust)
estimates store m1, title(Model 1)
xtreg swd kon i.age4 occupI i.edu4  voted i.VHI i.civil barnI c.artot1##i.swede  borI PID if cpi33==2, fe vce(robust)
estimates store m2, title(Model 2)
xtreg swd kon i.age4 occupI i.edu4  voted i.VHI i.civil barnI c.artot1##i.swede  borI PID  if cpi33==3, fe vce(robust)
estimates store m3, title(Model 3)

esttab m1 m2 m3, cells(b(star fmt(%9.3f)) se(par)) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-squared))      ///
legend label collabels(none) varlabels(_cons Constant) ///
substitute("\fonttbl{\f0\fnil Times New Roman" "\fonttbl{\f0\fnil Arial" "\fs24" "\fs16" "\fs20" "\fs16" "\super" "") 

*Figure A1

*sum wbgi_gee ti_cpi icrg_qog if ccode==752 - needs to include Sweden in the data, which is removed in the beginning
sum wbgi_gee ti_cpi icrg_qog

*Figure A2. Adjusted predictions of satisfaction with the way democracy works for Swedish expatriates and native residents at different levels of institutional quality

tab icrg_qog
xtreg swd kon i.age4 edu civil ar2 i.occupI borI barnI i.VHI PID voted i.swede##c.icrg_qog, re
margins, at(icrg_qog=(0 (0.1) 1)  swede=(0 1)) atmeans
marginsplot, scheme(s1mono)

tab wbgi_gee
xtreg swd kon i.age4 edu civil ar2 i.occupI borI barnI i.VHI PID voted i.swede##c.wbgi_gee, re
margins, at(wbgi_gee=(-2 (.3) 2)  swede=(0 1)) atmeans
marginsplot, scheme(s1mono)

tab wbgi_rle
xtreg swd kon i.age4 edu civil ar2 i.occupI borI barnI i.VHI PID voted i.swede##c.wbgi_rle, re
margins, at(wbgi_rle=(-1 (.3) 2 )  swede=(0 1)) atmeans
marginsplot, scheme(s1mono)

*Figure A4. Predicted probabilities for Swedish expatriates and indigenous populations to be very satisfied, fairly satisfied, not very satisfied or not at all satisfied with the way democracy works from CSES.

gen swd4=swd
rescale swd4 1 4

ologit swd4 kon i.age4 occupI  i.edu4 voted i.VHI i.civil barnI ar2 borI PID  i.swede##c.ti_cpi, vce(robust)

margins swede, at(ti_cpi=(2(1)10)) atmeans noatlegend predict(outcome(1))
marginsplot
margins swede, at(ti_cpi=(2(1)10)) atmeans noatlegend predict(outcome(2))
marginsplot
margins swede, at(ti_cpi=(2(1)10)) atmeans noatlegend predict(outcome(3))
marginsplot
margins swede, at(ti_cpi=(2(1)10)) atmeans noatlegend predict(outcome(4))
marginsplot

*Figure A5. Adjusted predictions of institutional trust and satisfaction with democracy for Swedish expatriates and native residents at three different levels of corruption (fixed country effects with cluster robust standard errors)

xtreg swd kon i.age4 occupI i.edu4  voted i.VHI i.civil barnI ar2 borI PID swede  if cpi33==1, fe vce(robust)
estimate store O
xtreg swd kon i.age4 occupI i.edu4  voted i.VHI i.civil barnI ar2 borI PID swede  if cpi33==2, fe vce(robust)
estimate store N
xtreg swd kon i.age4 occupI i.edu4  voted i.VHI i.civil barnI ar2 borI PID swede  if cpi33==3, fe vce(robust)
estimate store P

 coefplot (O, label(High Global Corruption)  offset(0.05)) ///
(N, label(Medium Global Corruption)  offset(0.00)) ///
(P, label(Low Global Corruption)  offset(-0.05)) ///
,msymbol(0) level(84) mlabel format(%9.2g)mlabposition(12)mlabgap(*2) keep(swede)xline(0) xtitle(Swedish Expatriates)


*Figure A6. Predicted probabilities from an ordered logit of satisfaction with the way democracy works for Swedish expatriates and native residents at different length of residence in highly corrupt countries (fixed effects ordered logit with cluster robust standard errors)

ologit swd4 kon i.age4 occupI  voted i.VHI i.civil barnI c.artot1##i.swede  borI PID i.ccode if cpi33==1, vce(robust)
margins swede, at(artot1=(0(1)60)) atmeans noatlegend predict(outcome(1))
marginsplot
margins swede, at(artot1=(0(1)60)) atmeans noatlegend predict(outcome(2))
marginsplot
margins swede, at(artot1=(0(1)60)) atmeans noatlegend predict(outcome(3))
marginsplot
margins swede, at(artot1=(0(1)60)) atmeans noatlegend predict(outcome(4))
marginsplot

*Figure A7. Adjusted predictions of satisfaction with the way democracy works and institutional trust among Swedish expatriates and native residents at different levels of institutional quality and different levels of GDP/Capita (under control for each other).

xtreg swd kon i.age4 occupI  i.edu4 voted i.VHI i.civil barnI ar2 borI PID  i.swede##c.gle_cgdpc i.swede##c.ti_cpi, re vce(robust)
margins, at(ti_cpi=(1(1)10)  swede=(0 1)) atmeans
marginsplot, scheme(s1mono)

tab gle_cgdpc
xtreg swd kon i.age4 occupI  i.edu4 voted i.VHI i.civil barnI ar2 borI PID  i.swede##c.gle_cgdpc i.swede##c.ti_cpi, re vce(robust)
margins, at(gle_cgdpc=(3729(1000)61812)  swede=(0 1)) atmeans
marginsplot, scheme(s1mono)






