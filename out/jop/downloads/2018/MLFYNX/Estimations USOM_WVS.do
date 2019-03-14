use "USOM_WVS.dta", clear
set more off 

**generating variables

*Dependent variable - institutional trust
tab1 trstpar trstgov trstjud trstpolice
alpha trstpar trstgov trstjud trstpolice
 
gen trusind=(trstpar+trstgov+trstjud+trstpolice)/4
tab trusind

*trust items based on dichotomies
gen trusindo2=(trstparo2+trstgovo2+trstjudo2+trstpoliceo2)/4
tab trusindo2

program rescale 
args oldvar newmin newmax
qui sum `oldvar'
local oldmin=r(min)
local rangequota=(`newmax'-`newmin')/(r(max)-r(min))
replace `oldvar'=(`oldvar'-`oldmin')*`rangequota'+`oldmin'+(`newmin'-`oldmin')
end

rescale trusind 0 1

*years abroad
gen ar2=0
recode ar2 (0=1) if rarutomlands>10
tab ar2

gen ar=18
replace ar= rarutomlands if rarutomlands<19
tab ar

tab rarutomlands
gen agex=age if swede==0
egen artot=rowmean(agex rarutomlands)

*Question not asked in survey in Hong Kong
recode barn (.=0) if ccode==344

*Hong Kong not included in QoG - CPI taken from TI 2013.
recode ti_cpi (.=3.5) if ccode==344
recode ti_cpi (0/3.99=1) (4/6.99=2) (7/10.99=3), gen(cpi33)

**imputations

impute occup3 kon alder4 voted VH polintr klarinc civil ar2 if cpi33==1, gen(occupIMP1)
replace occup3=occupIMP1 if occup3==.
impute occup3 kon alder4 voted VH polintr klarinc civil ar2 if cpi33==2, gen(occupIMP2)
replace occup3=occupIMP2 if occup3==.
impute occup3 kon alder4 voted VH polintr klarinc civil ar2 if cpi33==3, gen(occupIMP3)
replace occup3=occupIMP3 if occup3==.

gen occupI=round(occup3)
tab occupI

impute VH occup2 kon alder4 voted VH polintr klarinc civil ar2 if cpi33==1, gen(VHIMP1)
replace VH=VHIMP1 if VH==.
impute VH occup2 kon alder4 voted VH polintr klarinc civil ar2 if cpi33==2, gen(VHIMP2)
replace VH=VHIMP2 if VH==.
impute VH occup2 kon alder4 voted VH polintr klarinc civil ar2 if cpi33==3, gen(VHIMP3)
replace VH=VHIMP3 if VH==.

gen VHI=round(VH)
tab VHI
tab VHI
recode VHI (1/2=1) (3=2) (4/5=3)

order ccode trusind kon alder4 occupI edu4  voted VHI  polintr klarinc civil2 barn gentrst ar2 swede ti_cpi
tab1 ccode trusind kon alder4 occupI edu4  voted VHI  polintr klarinc civil2 barn gentrst ar2 swede ti_cpi

bysort ccode: gen N=_N
bysort ccode: gen n=_n
tab N
keep if N>850

bysort ccode: egen NSS=total(swede) if swede==1
tab NSS
drop if NSS<5
tab NSS

**first cut

xtreg trusind kon i.alder4 i.occupI i.edu4  voted i.VHI  polintr klarinc civil2 barn gentrst ar2 swede ti_cpi, re vce(robust)  
keep if e(sample)

*********************
**Analyses in paper**
*********************

*Figure 1 

xtreg trusind kon i.alder4 i.occupI i.edu4  voted i.VHI  polintr klarinc civil2 barn gentrst ar2 swede##c.ti_cpi, re
margins, at(ti_cpi=(1(1)10)  swede=(0 1)) atmeans
marginsplot, scheme(s1mono)

*Figure 2 

xtreg trusind kon i.alder4 i.occupI i.edu4  voted i.VHI  polintr klarinc civil2 barn gentrst c.artot##i.swede  if cpi33!=3, fe vce(robust)
margins, at(artot=(0(1)50)  swede=(0 1)) atmeans
marginsplot, scheme(s1mono)

*testing VIF in relation to figure 2

reg trusind kon i.alder4 i.occupI i.edu4  voted i.VHI  polintr klarinc civil2 barn gentrst c.artot1##i.swede if cpi33!=3
estat vif
reg trusind kon i.alder4 i.occupI i.edu4  voted i.VHI  polintr klarinc civil2 barn gentrst c.artot1##i.swede##c.cpi33
estat vif

***********************
*******Appendix*******
***********************

**Robustness test using dichotomized items for DV

xtreg trusindo2 kon i.alder4 i.occupI i.edu4  voted i.VHI  polintr klarinc civil2 barn gentrst ar2 swede  if cpi33==1, fe vce(robust)
estimates store m1, title(Model 1)
xtreg trusindo2 kon i.alder4 i.occupI i.edu4  voted i.VHI  polintr klarinc civil2 barn gentrst ar2 swede if cpi33==2, fe vce(robust)
estimates store m2, title(Model 2)
xtreg trusindo2 kon i.alder4 i.occupI i.edu4  voted i.VHI  polintr klarinc civil2 barn gentrst ar2 swede  if cpi33==3, fe vce(robust)
estimates store m3, title(Model 3)

coefplot (m1, label(High Global Corruption)  offset(0.05)) ///
(m2, label(Medium Global Corruption)  offset(0.00)) ///
(m3, label(Low Global Corruption)  offset(-0.05)), ///
 msymbol(0) level(84) mlabel format(%9.2g)mlabposition(12)mlabgap(*2) keep (swede)xline(0) xtitle(Swedish Expatriates)

xtreg trusindo2 kon i.alder4 i.occupI i.edu4  voted i.VHI  polintr klarinc civil2 barn gentrst ar2 swede##c.ti_cpi, re
margins, at(ti_cpi=(1(1)10)  swede=(0 1)) atmeans
marginsplot, scheme(s1mono)

**Applying controls for economic development and type of democracy - using gdp instead of CPI

xtreg trusind kon i.alder4 i.occupI i.edu4  voted i.VHI  polintr klarinc civil2 barn gentrst ar2 swede gle_cgdpc ti_cpi, re vce(robust)
estimates store m1, title(Model 1)
xtreg trusind kon i.alder4 i.occupI i.edu4  voted i.VHI  polintr klarinc civil2 barn gentrst ar2  i.swede##c.ti_cpi gle_cgdpc , re vce(robust)
estimates store m2, title(Model 2)
xtreg trusind kon i.alder4 i.occupI i.edu4  voted i.VHI  polintr klarinc civil2 barn gentrst ar2  i.swede##c.gle_cgdpc ti_cpi, re vce(robust)
estimates store m3, title(Model 3)
xtreg trusind kon i.alder4 i.occupI i.edu4  voted i.VHI  polintr klarinc civil2 barn gentrst ar2  i.swede##c.gle_cgdpc i.swede##c.ti_cpi, re vce(robust)
estimates store m4, title(Model 4)

esttab m1 m2 m3 m4, cells(b(star fmt(%9.3f)) se(par)) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-squared))      ///
legend label collabels(none) varlabels(_cons Constant) ///
substitute("\fonttbl{\f0\fnil Times New Roman" "\fonttbl{\f0\fnil Arial" "\fs24" "\fs16" "\fs20" "\fs16" "\super" "") 

*robustness controlling for majoritarianism and GDP 

tab gol_est
tab gol_est, nolab
recode gol_est (3/max=0), gen(maj)

xtreg trusind kon i.alder4 i.occupI i.edu4  voted i.VHI  polintr klarinc civil2 barn gentrst ar2 swede##c.ti_cpi, re
margins, at(ti_cpi=(1(1)10)  swede=(0 1)) atmeans
marginsplot, scheme(s1mono)

xtreg trusind kon i.alder4 i.occupI i.edu4  voted i.VHI  polintr klarinc civil2 barn gentrst ar2 maj swede##c.ti_cpi, re
margins, at(ti_cpi=(1(1)10)  swede=(0 1)) atmeans
marginsplot, scheme(s1mono)

*Table A1 in online appendix

preserve
gen year=V262
collapse trusind, by(ccode year cpi33 N swede NSS)
drop if trusind==.
drop if swede==0
restore 

*Table A4

xtreg trusind kon i.alder4 i.occupI i.edu4  voted i.VHI  polintr klarinc civil2 barn gentrst ar2 swede ti_cpi, re vce(robust)  
estimates store m1, title(Model 1)
xtreg trusind kon i.alder4 i.occupI i.edu4  voted i.VHI  polintr klarinc civil2 barn gentrst ar2 swede##c.ti_cpi, re vce(robust)  
estimates store m2, title(Model 2)

esttab m1 m2, cells(b(star fmt(%9.3f)) se(par)) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-squared))      ///
legend label collabels(none) varlabels(_cons Constant) ///
substitute("\fonttbl{\f0\fnil Times New Roman" "\fonttbl{\f0\fnil Arial" "\fs24" "\fs16" "\fs20" "\fs16" "\super" "") 

*Table A5

xtreg trusind kon i.alder4 i.occupI i.edu4  voted i.VHI  polintr klarinc civil2 barn gentrst c.artot1##i.swede  if cpi33==1, fe vce(robust)
estimates store m1, title(Model 1)
xtreg trusind kon i.alder4 i.occupI i.edu4  voted i.VHI  polintr klarinc civil2 barn gentrst c.artot1##i.swede  if cpi33==2, fe vce(robust)
estimates store m2, title(Model 2)
xtreg trusind kon i.alder4 i.occupI i.edu4  voted i.VHI  polintr klarinc civil2 barn gentrst c.artot1##i.swede  if cpi33==3, fe vce(robust)
estimates store m3, title(Model 3)

esttab m1 m2 m3, cells(b(star fmt(%9.3f)) se(par)) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-squared))      ///
legend label collabels(none) varlabels(_cons Constant) ///
substitute("\fonttbl{\f0\fnil Times New Roman" "\fonttbl{\f0\fnil Arial" "\fs24" "\fs16" "\fs20" "\fs16" "\super" "") 

*Figure A1
**Constructed from the Quality of Government Standard dataset

*Figure A3. Adjusted predictions of satisfaction with the way democracy works for Swedish expatriates and native residents at different levels of institutional quality

tab icrg_qog
xtreg trusind kon i.alder4 i.occupI i.edu4  voted i.VHI  polintr klarinc civil2 barn gentrst ar2 swede##c.icrg_qog, re
margins, at(icrg_qog=(0 (0.1) 1)  swede=(0 1)) atmeans
marginsplot, scheme(s1mono) 

tab wbgi_gee
xtreg trusind kon i.alder4 i.occupI i.edu4  voted i.VHI  polintr klarinc civil2 barn gentrst ar2 i.swede##c.wbgi_gee, re
margins, at(wbgi_gee=(-2 (.3) 2 )  swede=(0 1)) atmeans
marginsplot, scheme(s1mono) 

tab wbgi_rle
xtreg trusind kon i.alder4 i.occupI i.edu4  voted i.VHI  polintr klarinc civil2 barn gentrst ar2 i.swede##c.wbgi_rle, re
margins, at(wbgi_rle=(-2 (.3) 2 )  swede=(0 1)) atmeans
marginsplot, scheme(s1mono) 

*Figure A5. Adjusted predictions of institutional trust and satisfaction with democracy for Swedish expatriates and native residents at three different levels of corruption (fixed country effects with cluster robust standard errors)

**hausman test
xtreg trusind kon alder4 occup2 edu4  voted VH  polintr klarinc civil gentrst ar2 swede, re  
estimate store re
xtreg trusind kon alder4 occup2 edu4  voted VH  polintr klarinc civil gentrst ar2 swede, fe
estimate store fe
hausman re fe

xtreg trusind kon i.alder4 i.occupI i.edu4  voted i.VHI  polintr klarinc civil2 barn gentrst ar2 swede  if cpi33==1, fe vce(robust)
estimates store m1, title(Model 1)
xtreg trusind kon i.alder4 i.occupI i.edu4  voted i.VHI  polintr klarinc civil2 barn gentrst ar2 swede if cpi33==2, fe vce(robust)
estimates store m2, title(Model 2)
xtreg trusind kon i.alder4 i.occupI i.edu4  voted i.VHI  polintr klarinc civil2 barn gentrst ar2 swede  if cpi33==3, fe vce(robust)
estimates store m3, title(Model 3)

coefplot (m1, label(High Global Corruption)  offset(0.05)) ///
(m2, label(Medium Global Corruption)  offset(0.00)) ///
(m3, label(Low Global Corruption)  offset(-0.05)), ///
 msymbol(0) level(84) mlabel format(%9.2g)mlabposition(12)mlabgap(*2) keep (swede)xline(0) xtitle(Swedish Expatriates)

*Figure A7. Adjusted predictions of satisfaction with the way democracy works and institutional trust among Swedish expatriates and native residents at different levels of institutional quality and different levels of GDP/Capita (under control for each other).

xtreg trusind kon i.alder4 i.occupI i.edu4  voted i.VHI  polintr klarinc civil2 barn gentrst ar2  i.swede##c.gle_cgdpc i.swede##c.ti_cpi, re vce(robust)
margins, at(ti_cpi=(1(1)10)  swede=(0 1)) atmeans
marginsplot, scheme(s1mono)

tab gle_cgdpc
xtreg trusind kon i.alder4 i.occupI i.edu4  voted i.VHI  polintr klarinc civil2 barn gentrst ar2  i.swede##c.gle_cgdpc i.swede##c.ti_cpi, re vce(robust)
margins, at(gle_cgdpc=(3729(1000)49194)  swede=(0 1)) atmeans
marginsplot, scheme(s1mono)


