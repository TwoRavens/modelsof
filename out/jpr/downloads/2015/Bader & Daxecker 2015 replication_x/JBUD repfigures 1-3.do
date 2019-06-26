*Replication do files for Bader and Daxecker, A Chinese resource curse? The human rights effects of oil export dependence on China versus the United States, JPR forthcoming*
*FIgures 1-3*

**Generating descriptive figures 1-3**

*Figure 1, per capita Exports to China and Human Rights*
 **Examine who Chinas biggest per capita suppliers are*
sort ccode
by ccode: egen meanOilcap=mean(Choil_constcap)
gsort meanOilcap
list country ccode meanOilcap if meanOilcap!=. & year==2010

	

*Draw line graphs and combine them*

label var Choil_constcap "Exports to China in US$/c"
label var physint "Physical integrity rights"
twoway (line Choil_constcap year, sort) (line physint year, clpat(dash)  sort yaxis(2)) if country=="Oman" & year>1993, title(Oman)  legend(off) fxsize(45)
gr save ".graphCh1.gph", replace
twoway (line Choil_constcap year, sort) (line physint year, clpat(dash)  sort yaxis(2)) if country=="Equatorial Guinea" & year>1993,  yscale(off)  title(Equatorial Guinea)  legend(off)
gr save ".graphCh2.gph", replace
twoway (line Choil_constcap year, sort) (line physint year, clpat(dash)  sort yaxis(2)) if country=="Kuwait" & year>1993, yscale(off) title(Kuwait)  legend(off)
gr save ".graphCh3.gph", replace
twoway (line Choil_constcap year, sort) (line physint year, clpat(dash)  sort yaxis(2)) if country=="Brunei" & year>1993, yscale(off) title(Brunei)  legend(off)
gr save ".graphCh4.gph", replace
twoway (line Choil_constcap year, sort) (line physint year, clpat(dash)  sort yaxis(2)) if country=="Angola" & year>1993, title(Angola)  legend(off) fxsize(45)
gr save ".graphCh5.gph", replace
twoway (line Choil_constcap year, sort) (line physint year, clpat(dash)  sort yaxis(2)) if country=="Congo, Republic of" & year>1993, yscale(off) title(Congo)  legend(off)
gr save ".graphCh6.gph", replace
twoway (line Choil_constcap year, sort) (line physint year, clpat(dash)  sort yaxis(2)) if country=="Saudi Arabia" & year>1993, yscale(off) title(Saudi Arabia)  legend(off) 
gr save ".graphCh7.gph", replace
twoway (line Choil_constcap year, sort) (line physint year, clpat(dash)  sort yaxis(2)) if country=="Qatar" & year>1993, yscale(off) title(Qatar)  legend(off)
gr save ".graphCh8.gph", replace
twoway (line Choil_constcap year, sort) (line physint year, clpat(dash)  sort yaxis(2)) if country=="United Arab Emirates" & year>1993, title(UAE)  legend(off) fxsize(45)
gr save ".graphCh9.gph", replace
twoway (line Choil_constcap year, sort) (line physint year, clpat(dash)  sort yaxis(2)) if country=="Libya" & year>1993, yscale(off)  title(Libya)  legend(off)
gr save ".graphCh10.gph", replace
twoway (line Choil_constcap year, sort) (line physint year, clpat(dash)  sort yaxis(2)) if country=="Gabon" & year>1993, yscale(off)  title(Gabon)  legend(off)
gr save ".graphCh11.gph", replace
twoway (line Choil_constcap year, sort) (line physint year, clpat(dash)  sort yaxis(2)) if country=="Yemen" & year>1993, yscale(off)  title(Yemen) legend(off)
gr save ".graphCh12.gph", replace

graph combine ".graphCh1.gph" ".graphCh2.gph" ".graphCh3.gph" ".graphCh4.gph" ".graphCh5.gph" ".graphCh6.gph" ".graphCh7.gph" ".graphCh8.gph" ".graphCh9.gph" ".graphCh10.gph" ".graphCh11.gph" ".graphCh12.gph",  ycommon rows(3) imargin(0 0 0 0)

	graph save "combinationCh1.gph", replace
graph export "/biggest suppliers CH.pdf", as(pdf) replace


*Figure 2, Per capita exports to US and Human RIghts*
sort ccode
by ccode: egen meanOilcapUS=mean(USoil_constcap) 
gsort meanOilcapUS
list country ccode meanOilcapUS if meanOilcapUS!=. & year==2010


label var USoil_constcap "Exports to US in US$/c"
label var physint "Physical integrity rights"


twoway (line USoil_constcap year, sort) (line physint year, clpat(dash)  sort yaxis(2)) if country=="Trinidad and Tobago" & year>1993, title(Trinidad and Tobago)  legend(off) fxsize(45)
gr save ".graphUS1.gph", replace
twoway (line USoil_constcap year, sort) (line physint year, clpat(dash)  sort yaxis(2)) if country=="Gabon" & year>1993,  yscale(off)  title(Gabon)  legend(off)
gr save ".graphUS2.gph", replace
twoway (line USoil_constcap year, sort) (line physint year, clpat(dash)  sort yaxis(2)) if country=="Kuwait" & year>1993, yscale(off) title(Kuwait)  legend(off)
gr save ".graphUS3.gph", replace
twoway (line USoil_constcap year, sort) (line physint year, clpat(dash)  sort yaxis(2)) if country=="Canada" & year>1993, yscale(off) title(Canada)  legend(off)
gr save ".graphUS4.gph", replace
twoway (line USoil_constcap year, sort) (line physint year, clpat(dash)  sort yaxis(2)) if country=="Equatorial Guinea" & year>1993, title(Equatorial Guinea)  legend(off) fxsize(45)
gr save ".graphUS5.gph", replace
twoway (line USoil_constcap year, sort) (line physint year, clpat(dash)  sort yaxis(2)) if country=="Saudi Arabia" & year>1993, yscale(off) title(Saudi Arabia)  legend(off)
gr save ".graphUS6.gph", replace
twoway (line USoil_constcap year, sort) (line physint year, clpat(dash)  sort yaxis(2)) if country=="Venezuela" & year>1993, yscale(off) title(Venezuela)  legend(off) 
gr save ".graphUS7.gph", replace
twoway (line USoil_constcap year, sort) (line physint year, clpat(dash)  sort yaxis(2)) if country=="Norway" & year>1993, yscale(off) title(Norway)  legend(off)
gr save ".graphUS8.gph", replace
twoway (line USoil_constcap year, sort) (line physint year, clpat(dash)  sort yaxis(2)) if country=="Bahamas" & year>1993, title(Bahamas)  legend(off) fxsize(45)
gr save ".graphUS9.gph", replace
twoway (line USoil_constcap year, sort) (line physint year, clpat(dash)  sort yaxis(2)) if country=="Angola" & year>1993, yscale(off)  title(Angola)  legend(off)
gr save ".graphUS10.gph", replace
twoway (line USoil_constcap year, sort) (line physint year, clpat(dash)  sort yaxis(2)) if country=="Brunei" & year>1993, yscale(off)  title(Brunei)  legend(off)
gr save ".graphUS11.gph", replace
twoway (line USoil_constcap year, sort) (line physint year, clpat(dash)  sort yaxis(2)) if country=="Congo, Republic of" & year>1993, yscale(off)  title(Congo) legend(off)
gr save ".graphUS12.gph", replace


graph combine ".graphUS1.gph" ".graphUS2.gph" ".graphUS3.gph" ".graphUS4.gph" ".graphUS5.gph" ".graphUS6.gph" ".graphUS7.gph" ".graphUS8.gph" ".graphUS9.gph" ".graphUS10.gph" ".graphUS11.gph" ".graphUS12.gph",  ycommon rows(3) imargin(0 0 0 0)

	graph save "combinationUS1.gph", replace
graph export "/biggest per capita suppliers US.pdf", as(pdf) replace


*Figure 3, marginal effects model 1 table 1"
xi: ologit  physint physintlag   lnChoil_constcaplag lnUSoil_constcaplag demodummylag     lngdplag lnpoplag incidencev412 i.year if year>1991, cluster(ccode)
margins , at(lnUSoil_constcaplag=(0 (0.5) 8.5) )  atmeans pr(outcome(7)) 
marginsplot, x(lnUSoil_constcaplag ) xlab(0 (2) 8) plotopts(msymbol(none)) ciopts(lpattern(-)) recastci(rline) title("") saving(marg1, replace)
margins  , at(lnChoil_constcaplag=(0 (0.5) 8.5) ) atmeans pr(outcome(7)) 
marginsplot, x(lnChoil_constcaplag ) xlab(0 (2) 8) plotopts(msymbol(none)) ciopts(lpattern(-)) title("") recastci(rline) saving(marg2, replace)
gr combine marg1.gph marg2.gph, ycommon
