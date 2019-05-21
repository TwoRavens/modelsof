*Sarah Shair-Rosenfield and Reed M. Wood (2017)*

***Table 1 (Female Representation Rates)***

ttest lag5yr_wmn_leg if count==1, by(peace_c)

ttest wmn_leg if count==1, by(peace_c)

ttest fwd5yr_wmn_leg if count==1, by(peace_c)

ttest fwd10yr_wmn_leg if count==1, by(peace_c)


***Table 2 (Spending and Governance Perception models)***

xtset ConflictEp year

*Model 1
xtpcse lnspend_w lagwmn_leg polity2 lngdp lnpop lnconfldur lnpeace_time aid nat power active if peace_c==1, corr(ar1) hetonly

*Model 2
xtpcse lnspend_w c.lagwmn_leg c.polity2 c.lagwmn_leg#c.polity2 lngdp lnpop lnconfldur lnpeace_time aid nat power active if peace_c==1, corr(ar1) hetonly

*Model 3
xtpcse account_ipo lagwmn_leg polity2 lngdp lnpop lnconfldur lnpeace_time aid nat power active if peace_c==1, corr(ar1) hetonly

*Model 4
xtpcse account_ipo c.lagwmn_leg c.polity2 c.lagwmn_leg#c.polity2 lngdp lnpop lnconfldur lnpeace_time aid nat power active if peace_c==1, corr(ar1) hetonly

*Model 5
xtpcse effect_ipo lagwmn_leg polity2 lngdp lnpop lnconfldur lnpeace_ aid nat power active if peace_c==1, corr(ar1) hetonly

*Model 6
xtpcse effect_ipo c.lagwmn_leg c.polity2 c.lagwmn_leg#c.polity2 lngdp lnpop lnconfldur lnpeace_time aid nat power active if peace_c==1, corr(ar1) hetonly

*Model 7
xtpcse corrupt_ipo lagwmn_leg polity2 lngdp lnpop lnconfldur lnpeace_ aid nat power active if peace_c==1, corr(ar1) hetonly

*Model 8
xtpcse corrupt_ipo c.lagwmn_leg c.polity2 c.lagwmn_leg#c.polity2 lngdp lnpop lnconfldur lnpeace_time aid nat power active if peace_c==1, corr(ar1) hetonly


***Table 3 (Peace Duration models)***

stset date, id(ConflictEp) failure(fail==1) origin(origin2) scale(365.25)

*Model 9
stcox c.lagwmn_leg polity2 dist terr lnpop unoper_ power lnconfldur active if peace_cease==1, cl(ccode) nohr nolog 

*Model 10
stcox c.lagwmn_leg polity2 dist terr lnpop unoper_ power lnconfldur fem active if peace_cease==1, cl(ccode) nohr nolog 

*Model 11
stcox c.lagwmn_leg c.polity2 c.lagwmn_leg#c.polity2 dist terr lnpop unoper_ power lnconfldur fem active if peace_cease==1, cl(ccode) nohr nolog 

*Model 12
stcox c.lagwmn_leg polity2 dist terr lnpop unoper_ power lnconfldur fem active lnspend_w if peace_cease==1, cl(ccode) nohr nolog 

*Model 13
stcox c.lagwmn_leg polity2 dist terr lnpop unoper_ power lnconfldur fem active account_ipo if peace_cease==1, cl(ccode) nohr nolog 

*Model 14
stcox c.lagwmn_leg polity2 dist terr lnpop unoper_ power lnconfldur fem active effect_ipo if peace_cease==1, cl(ccode) nohr nolog 

*Model 15
stcox c.lagwmn_leg polity2 dist terr lnpop unoper_ power lnconfldur fem active corrupt_ipo if peace_cease==1, cl(ccode) nohr nolog 


**Margins for Figure 1 (Model 10)**

stcox c.lagwmn_leg c.polity2 c.lagwmn_leg#c.polity2 dist terr lnpop unoper_ power lnconfldur fem active if peace_cease==1, cl(ccode) nohr nolog 

quietly margins, dydx (lagwmn_leg) at(polity2=(-10(2)10) dist=0 terr=0 unoper_=0 power=0 active=0) predict(xb) noatlegend atmeans
marginsplot

**Survival Curves for Figure 2 (Model 10)**

stcox c.lagwmn_leg c.polity2 c.lagwmn_leg#c.polity2 dist terr lnpop unoper_ power lnconfldur fem active if peace_cease==1, cl(ccode) nohr nolog 

*All cases (not in manuscript)

stcurve, survival at1(lagwmn_leg=2.5) at2(lagwmn_leg=10.5) at3(lagwmn_leg=18.5) range(0 25)

*Democracies

stcurve, survival at1(lagwmn_leg=2.5 polity2=6) at2(lagwmn_leg=10.5 polity2=6) at3(lagwmn_leg=18.5 polity2=6) range(0 25)

*Non-democracies

stcurve, survival at1(lagwmn_leg=2.5 polity2=0) at2(lagwmn_leg=10.5 polity2=0) at3(lagwmn_leg=18.5 polity2=0) range(0 25)


*************************

****Online Appendix****

***Table A2 (Robustness Check #1: Instrumental Variable model)***

*Model A1
ivprobit fail2 polity2 dist terr lnpop unoper_ power lnconfldur fem active count count2 count3 (lagwmn_leg=quota lagwmn_region_mean2) if peace_cease==1, nolog first vce(cl ccode)


***Table A3 (Robustness Check #2: Early Female Representation)***

*Model A2
stcox c.wmn_leg_first5 polity2 dist terr lnpop unoper_ power lnconfldur fem active if peace_cease==1, cl(ccode) nohr nolog 

*Model A3
stcox c.wmn_leg_first5 c.polity2 c.wmn_leg_first5#c.polity2 dist terr lnpop unoper_ power lnconfldur fem active if peace_cease==1, cl(ccode) nohr nolog 


***Table A4 (Robustness Check #3: Left Party & Gender Quotas)***

*Model A4
stcox c.lagwmn_leg polity2 dist terr lnpop unoper power lnconfldur fem active leftparty if peace_cease==1, cl(ccode) nohr nolog 

*Model A5
stcox c.lagwmn_leg c.polity2 c.lagwmn_leg#c.polity2 dist terr lnpop unoper power lnconfldur fem active leftparty if peace_cease==1, cl(ccode) nohr nolog 

*Model A6
stcox c.lagwmn_leg polity2 dist terr lnpop unoper power lnconfldur fem active quota if peace_cease==1, cl(ccode) nohr nolog 

*Model A7
stcox c.lagwmn_leg c.polity2 c.lagwmn_leg#c.polity2 dist terr lnpop unoper power lnconfldur fem active quota if peace_cease==1, cl(ccode) nohr nolog 


***Table A5 (Robustness Check #4: Missing Legislatures)

*Model A8
stcox c.lagwmn_legfill polity2 dist terr lnpop unoper_ power lnconfldur fem active if peace_cease==1, cl(ccode) nohr nolog 

*Model A9
stcox c.lagwmn_legfill c.polity2 c.lagwmn_legfill#c.polity2 dist terr lnpop unoper_ power lnconfldur fem active if peace_cease==1, cl(ccode) nohr nolog 

*Model A10
stcox c.lagwmn_legfill c.polity2fill legislature dist terr lnpop unoper_ power lnconfldur fem active if peace_cease==1, cl(ccode) nohr nolog 

*Model A11
stcox c.lagwmn_legfill c.polity2fill c.lagwmn_legfill#c.polity2fill legislature dist terr lnpop unoper_ power lnconfldur fem active if peace_cease==1, cl(ccode) nohr nolog 


***Table A6 (Robustness Check #5: Institutional Measures of Rule of Law and Good Governance)***

*Model A12
stcox c.lagwmn_leg law dist terr lnpop unoper_ power lnconfldur fem active if peace_cease==1, cl(ccode) nohr nolog 

*Model A13
stcox c.lagwmn_leg polrights dist terr lnpop unoper_ power lnconfldur fem active if peace_cease==1, cl(ccode) nohr nolog 

*Model A14
stcox c.lagwmn_leg press_status dist terr lnpop unoper_ power lnconfldur fem active if peace_cease==1, cl(ccode) nohr nolog 

*Model A15
stcox c.lagwmn_leg FH_combine dist terr lnpop unoper_ power lnconfldur fem active if peace_cease==1, cl(ccode) nohr nolog 

*Model A16
stcox c.lagwmn_leg dist terr lnpop unoper_ power lnconfldur fem active writconstit2 if peace_cease==1, cl(ccode) nohr nolog 

*Model A17
stcox c.lagwmn_leg dist terr polright lnpop unoper_ power lnconfldur fem active i.writconstit2 c.polrights#i.writconstit2 if peace_cease==1, cl(ccode) nohr nolog 
