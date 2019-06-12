********Explanation of variables********
*In group-level data
incl = inclusion dummy variable
eparty = ethnic party dummy
ecs = ECS variable (ethnic civil society strength)
ecs_avg = historical average version of ECS variable
ecs_count = count variable of ethnic civil society organizations by group year 
umb_count = count of national umbrella organizations
polity = Polity index (country level of democracy)
left = electoral strength of leftist parties
size = relative group size
rgdppc = country GDP per capita
year = calendar year
noinclyrs = count of years that a given indigenous group has not been politically included
noinclyrs2 = quadratic version
noinclyrs3 = cubic version

*In country-level data
ecs_country = country-level ECS variable
prot = ethnic group protest from Minorities at Risk (MAR) dataset (highest group value per year)

*The historical average version of the ECS variable was constructed using the following code:
by cowgroupid: gen ecs_avg=sum(ecs[_n-1])/sum(ecs[_n-1]<.)
*Note that the suffix "_l" always indicates a one-year lag of a given variable.
*The prefex "ln_" indicates that the variable has been logged.
*For information on data sources, see main text.
*Interaction variables:
gen ecs_avg_pol=ecs_avg*polity_l
gen ecs_avg_left=ecs_avg*left_l


********Descriptive statistics********
*Table in Appendix II of the online supplementary material:
estpost tabstat eparty ecs ecs_avg umb_count polity left size rgdppc year, statistics(n mean p50 sd min max) columns(statistics)

sum incl if ecs_avg !=.
pwcorr left_l polity_l if incl_l==0, obs sig

*Table of instances of indigenous inclusion (-> Table 1 in main text):
sort incl cowgroupid year
list country group year epr_status_ad if incl==1

*Indigenous groups with the highest average ECS values (-> Table 2 in main text):
gsort -ecs_avg
list group country ecs_avg if year==2009


********Main analyses********
tsset cowgroupid year

*Model 1
logit incl eparty_l ecs_avg umb_count_l umb_count_l2 polity_l size ln_rgdppc_lag year if incl_l==0, cluster(ccode)
eststo model1
test umb_count_l umb_count_l2

*Model 2 (leftist parties instead of Polity):
logit incl eparty_l ecs_avg umb_count_l umb_count_l2 left_l size ln_rgdppc_lag year if incl_l==0, cluster(ccode)
eststo model2
test umb_count_l umb_count_l2

*Plotting effect of factionalism on likelihood of political inclusion (-> Figure 2 in main text)
estsimp logit incl eparty_l ecs_avg umb_count_l umb_count_l2 left_l size ln_rgdppc_lag year if incl_l==0, cluster(ccode)
setx mean
setx eparty_l 0
setx ecs_avg max
gen mobaxis= _n-1 in 1/6
gen pr_mean=.
gen pr_low=.
gen pr_high=.
forvalues v = 0(1)5 {

setx umb_count_l `v'
setx umb_count_l2 `v'*`v'

simqi, prval(1) genpr(pr)
sum pr, meanonly
replace pr_mean=r(mean) if mobaxis==`v'
_pctile pr, p(2.5 97.5)
replace pr_low=r(r1) if mobaxis==`v'
replace pr_high=r(r2) if mobaxis==`v'
drop pr
}
twoway (rarea pr_low pr_high mobaxis, fcolor(gs13) lcolor(gs13)) (line pr_mean mobaxis, lcolor(black)), ytitle(Probability of political inclusion) xtitle(N of national umbrella organizations) xlabel(0(1)5) ylabel(0(.05).25, gmax) legend(order(1 "95% CI" 2 "Predicted probability") nobox region(fcolor(white) lcolor(white))) graphregion(fcolor(white))
graph export "C:\D - DRIVE\ETH\Artikel Latin America equality\Final files\Figure2.tif", width(2600) height(1890)

*Model 3:
logit incl polity_l ecs_avg ecs_avg_pol eparty_l umb_count_l umb_count_l2 size ln_rgdppc_lag year if incl_l==0, cluster(ccode)
eststo model3
test ecs_avg ecs_avg_pol

*Plotting effect of civil society mobilization on political inclusion, conditional on democracy (-> Figure 3 in main text)
estsimp logit incl polity_l ecs_avg ecs_avg_pol eparty_l umb_count_l umb_count_l2 size ln_rgdppc_lag year if incl_l==0, cluster(ccode)
gen pr_mean=.
gen pr_low=.
gen pr_high=.
gen polaxis = _n-10 in 1/20
setx mean
setx eparty_l 1
setx umb_count_l 0
setx umb_count_l2 0
forvalues v = -9(1)10 {
setx polity_l `v'
simqi, fd(prval(1) genpr(pr)) changex(ecs_avg p25 p75 ecs_avg_pol 0 `v'*.0706676)
sum pr, meanonly
replace pr_mean=r(mean) if polaxis==`v'
_pctile pr, p(2.5 97.5)
replace pr_low=r(r1) if polaxis==`v'
replace pr_high=r(r2) if polaxis==`v'
drop pr
}
twoway (rarea pr_low pr_high polaxis, fcolor(gs15) lcolor(gs15)) (line pr_mean polaxis, lcolor(black)) (histogram polity_l, yaxis(2) color(black)), yline(0, lcolor(black)) ylabel(0(0.25)0.75, axis(2)) xlabel(-9(1)10) xtitle("Polity index") ytitle("First difference in probability of inclusion", size(small)) ytitle("Density Polity index", size(small) axis(2)) legend(order(2 "Mean" 1 "95% CI" 3 "Histogram Polity index") nobox region(fcolor(white) lcolor(white)))graphregion(fcolor(white))
graph export "C:\D - DRIVE\ETH\Artikel Latin America equality\Final files\Figure3.tif", width(2600) height(1890)

*Model 4
logit incl left_l ecs_avg ecs_avg_left eparty_l umb_count_l umb_count_l2 size ln_rgdppc_lag year if incl_l==0, cluster(ccode)
eststo model4

*Plotting effect of civil society mobilization on political inclusion, conditional on the strength of leftist parties (-> Figure 4 in main text)
gen left_l_c=left_l*100
gen ecs_avg_left_c=ecs_avg*left_l_c
sum left_l left_l_c
sum ecs_avg_left ecs_avg_left_c

estsimp logit incl left_l_c ecs_avg ecs_avg_left_c eparty_l umb_count_l umb_count_l2 size ln_rgdppc_lag year if incl_l==0, cluster(ccode)
gen pr_mean=.
gen pr_low=.
gen pr_high=.
gen leftaxis = _n-1 in 1/97
setx mean
setx eparty_l 1
setx umb_count_l 0
setx umb_count_l2 0
forvalues v = 0(1)96 {
setx left_l_c `v'
simqi, fd(prval(1) genpr(pr)) changex(ecs_avg p25 p75 ecs_avg_left_c 0 `v'*.0706676)
sum pr, meanonly
replace pr_mean=r(mean) if leftaxis==`v'
_pctile pr, p(2.5 97.5)
replace pr_low=r(r1) if leftaxis==`v'
replace pr_high=r(r2) if leftaxis==`v'
drop pr
}
replace leftaxis=leftaxis/100
twoway (rarea pr_low pr_high leftaxis, fcolor(gs15) lcolor(gs15)) (line pr_mean leftaxis, lcolor(black)) (histogram left_l, yaxis(2) color(black)), yline(0, lcolor(black)) ylabel(0(20)60, axis(2)) xlabel(0(0.1)1) xtitle("Seat share of leftist parties") ytitle("First difference in probability of inclusion", size(small)) ytitle("Density leftist party variable", size(small) axis(2)) legend(order(2 "Mean" 1 "95% CI" 3 "Histogram leftist party variable") nobox region(fcolor(white) lcolor(white)))graphregion(fcolor(white))
graph export "C:\D - DRIVE\ETH\Artikel Latin America equality\Final files\Figure4.tif", width(2600) height(1890)

*Summary table of all models (-> Table 3 in main text)
esttab model1 model2 model3 model4 using "C:\Users\vogtma\Desktop\table.rtf", scalars("ll Log likelihood") onecell b(2) se(2) rtf


********Robustness tests********
*Model A1 (Appendix III in the online supplementary material)
gen incl_eparty=incl_l*eparty_l
gen incl_ecs_avg=incl_l*ecs_avg
gen incl_size=incl_l*size
gen incl_pol=incl_l*polity_l
gen incl_umb_c=incl_l*umb_count_l
gen incl_umb_c2=incl_l*umb_count_l2
gen incl_year=incl_l*year
*Note that incl_eparty !=0 and umb_count_l !=0 predict success perfectly. Thus, the ethnic party-inclusion and umbrella count-inclusion interaction variables need to be dropped in the dynamic model.
logit incl incl_l eparty_l ecs_avg umb_count_l umb_count_l2 polity_l size year incl_ecs_avg incl_pol incl_size incl_year, cluster(ccode)
estsimp logit incl incl_l eparty_l ecs_avg umb_count_l umb_count_l2 polity_l size year incl_ecs_avg incl_pol incl_size incl_year, cluster(ccode)
gen b_ecs=b3+b9
gen b_pol=b6+b10
gen b_size=b7+b11
gen b_year=b8+b12
gen b_constant=b13+b1
sum b_ecs, detail
sum b_pol, detail
sum b_size, detail
sum b_year, detail
sum b_constant, detail
centile b_pol, centile (0.5 99.5)
centile b_pol, centile (0.05 99.95)
*Robustness: dropping eparty and umbrella org variables not only in interaction terms but also as constitutive terms:
logit incl incl_l ecs_avg polity_l size year incl_ecs_avg incl_pol incl_size incl_year, cluster(ccode)

*Model A2
logit incl eparty_l ecs_l umb_count_l umb_count_l2 polity_l size ln_rgdppc_lag year if incl_l==0, cluster(ccode)
eststo model5

*Model A3
logit incl eparty_l ecs_count_l ecs_count_l2 umb_count_l umb_count_l2 polity_l size ln_rgdppc_lag year if incl_l==0, cluster(ccode)
eststo model6

*Model A4
logit incl eparty_l ecs_avg umb_count_l umb_count_l2 polity_l size ln_rgdppc_lag noinclyrs noinclyrs2 noinclyrs3 if incl_l==0, cluster(ccode)
eststo model7

*Model A5
*Adopting changes from new EPR 2014 version (see explanations in Appendix IV of the online supplementary material)
replace incl=0 if cowgroupid==13501000 & year<2003
replace incl=0 if cowgroupid==13503000 & year<2003
replace incl_l=0 if cowgroupid==13501000 & year<2004
replace incl_l=0 if cowgroupid==13503000 & year<2004
replace incl=1 if country=="Bolivia" & group=="Aymara" & year>=1993
replace incl_l=1 if country=="Bolivia" & group=="Aymara" & year>=1994
*Almost all organizations representing the Aymara and Quechua people in Peru represent BOTH groups. The only exception is one Ayamara organization.
*Thus, since the ECS variable is defined as the N of organizations representing a group divided by the country population, the ECS value for the Aymara is equivalent to the ECS value for the whole Andes indigenous population.
list group year ecs_avg if cowgroupid==13503000 | cowgroupid==13501000
replace group="Indigenous peoples of the Andes" if cowgroupid==13503000
replace size=0.361 if cowgroupid==13503000
drop if cowgroupid==13501000
list group year ecs_avg if cowgroupid==13503000
replace incl=0 if country=="Panama" & group=="Choco (Embera-Wounan)" & year<1984 & incl !=.
replace incl_l=0 if country=="Panama" & group=="Choco (Embera-Wounan)" & year<1985 & incl_l !=.
replace incl=0 if country=="Panama" & group=="Ngobe-Bugle" & year<1998 & incl !=.
replace incl_l=0 if country=="Panama" & group=="Ngobe-Bugle" & year<1999 & incl_l !=.
replace incl=0 if cowgroupid==13004000 & year<2001
replace incl_l=0 if cowgroupid==13004000 & year<2002
logit incl eparty_l ecs_avg umb_count_l umb_count_l2 polity_l size ln_rgdppc_lag year if incl_l==0, cluster(ccode)
eststo model8

*Summary table of all robustness models (-> Appendix IV in the online supplementary material)
esttab model5 model6 model7 model8 using "C:\Users\vogtma\Desktop\table_app.rtf", scalars("ll Log likelihood") onecell b(2) se(2) rtf


********Endogeneity tests********
*Model A6
regres ecs ecs_l eparty_l polity_l size ln_rgdppc_lag year incl_l, cluster(ccode)
eststo model9
*Model A7
tobit ecs ecs_l eparty_l polity_l size ln_rgdppc_lag year incl_l, cluster(ccode) ll(0)
eststo model10
*Summary table of endogeneity models (-> Appendix V in the online supplementary material)
esttab model9 model10 using "C:\Users\vogtma\Desktop\table_app2.rtf", scalars("ll Log likelihood") onecell b(2) se(2) rtf


********Additional material********
*Scatter plot of ECS and N of umbrella organizations, highlighting observations of indigenous peoples in Ecuador (-> Appendix VII in the online supplementary material)
twoway (scatter umb_count ecs if cowgroupid !=13004000, mcolor(gs13) jitter(7)) (scatter umb_count ecs if cowgroupid==13004000, mcolor(black) jitter(7)), xtitle("ECS value") ytitle("N of national umbrella organizations") legend(order(2 "Indigenous peoples in Ecuador" 1 "Other observations") nobox region(fcolor(white) lcolor(white))) graphregion(fcolor(white))

*Ecuador plot (-> Figure 5 in main text)
twoway (tsline ecs if cowgroupid==13004000, lcolor(black) lpattern(solid)) (tsline epr_status_ad if cowgroupid==13004000, yaxis(2) lcolor(black) lpattern(dash)), ytitle(ECS value) ytitle(EPR-ETH power status, axis(2)) ylabel(,gmax) ylabel(1(1)4, labels labsize(small) angle(vertical) valuelabel axis(2)) tlabel(1950(5)2010, labsize(small)) legend(order(1 "Ethnic mobilization" 2 "Power status") nobox region(fcolor(white) lcolor(white))) graphregion(fcolor(white))
graph export "C:\D - DRIVE\ETH\Artikel Latin America equality\Final files\Figure5.tif", width(2600) height(1890)

*Using country-level data: Comparison of country-aggregated ECS and MAR protest values (-> Appendix VI in the online supplementary material)
twoway (scatter prot ecs_country, mcolor(black)) (lfitci prot ecs_country, clcolor(black)), ytitle(Max. protest value in country (MAR)) xtitle(Country-level ECS value) legend(order(3 "Fitted values" 2 "95% CI") nobox region(fcolor(white) lcolor(white))) graphregion(color(white))
pwcorr prot ecs_country, obs sig
