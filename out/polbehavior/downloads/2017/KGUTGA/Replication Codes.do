*** Table 1: Ordered Logit Models with Country and Group FEs
set more off
ologit ethnic_identity c.bgi##c.wgi   c1-c33 y1-y5, robust
test c.bgi#c.wgi
ologit ethnic_identity c.bgi##c.wgi abw age educ employment urbrur gender groupsize poor excluded compt polity2 polity2sq loggdp_lag growth_lag  c1-c33 y1-y5, robust
test c.bgi#c.wgi
ologit ethnic_identity c.bgi##c.wgi   g1-g88 y1-y5, robust
test c.bgi#c.wgi
ologit ethnic_identity c.bgi##c.wgi abw age educ employment urbrur gender excluded compt polity2 polity2sq loggdp_lag growth_lag g1-g88 y1-y5, robust
test c.bgi#c.wgi


*** Table 2: Robustness Tests
set more off
ologit ethnic_identity c.bgi##c.wgi abw age educ employment urbrur gender groupsize poor excluded compt polity2 polity2sq loggdp_lag growth_lag interstwar ongoingcw peaceyrs c1-c33 y1-y5, robust
ologit ethnic_identity c.bgi##c.wgi abw age educ employment urbrur gender groupsize poor excluded compt polity2 polity2sq loggdp_lag growth_lag last_conflict c1-c33 y1-y5, robust
ologit ethnic_identity c.bgi##c.wgi abw age educ employment urbrur gender groupsize poor excluded compt polity2 polity2sq loggdp_lag growth_lag mean_conflict c1-c33 y1-y5, robust
ologit ethnic_identity c.bgi##c.wgi abw age educ employment urbrur gender groupsize poor excluded compt polity2 polity2sq loggdp_lag growth_lag regionbased urbanregion c1-c33 y1-y5, robust
ologit ethnic_identity c.bgi##c.wgi abw age educ employment urbrur gender groupsize poor excluded compt polity2 polity2sq loggdp_lag growth_lag urban c1-c33 y1-y5, robust
ologit ethnic_identity c.bgi##c.wgi abw age educ employment urbrur gender groupsize poor excluded compt polity2 polity2sq loggdp_lag growth_lag farmer commerce military c1-c33 y1-y5, robust


*** Figure 1
set more off
set scheme s1mono
ologit ethnic_identity c.bgi##c.wgi abw age educ employment urbrur gender groupsize poor excluded compt polity2 polity2sq loggdp_lag growth_lag  c1-c33 y1-y5, robust
margins, dydx(bgi) at(wgi=(0.2(0.05).55)) predict(outcome(5)) atmeans
marginsplot, xlabel(0.2(0.05).55)  ytitle(Marginal Effect of BGI) xtitle(WGI) yline(0) title("Only Ethnicity") recast(line) level(95) recastci(rarea) name(outcome5, replace) nodraw
margins, dydx(bgi) at(wgi=(0.2(0.05).55)) predict(outcome(4)) atmeans
marginsplot, xlabel(0.2(0.05).55)  ytitle(Marginal Effect of BGI) xtitle(WGI) yline(0) title("Mostly Ethnicity") recast(line) level(95) recastci(rarea) name(outcome4, replace) nodraw
graph combine outcome5 outcome4 , cols(2) 


*** Figure 2
set more off
set scheme s1mono
ologit ethnic_identity c.bgi##c.wgi abw age educ employment urbrur gender groupsize poor excluded compt polity2 polity2sq loggdp_lag growth_lag  c1-c33 y1-y5, robust
margins, at(bgi=(0(0.1)2.5) wgi=.28987) predict(outcome(5)) atmeans
marginsplot, xlabel(0(.5)2.5) ylabel(0.03(.01).12) ytitle(Prob. Identify Only With Ethnicity) xtitle(BGI) title("Low WGI") recast(line) recastci(rarea) level(95) name(low, replace) nodraw
margins, at(bgi=(0(0.1)2.5) wgi=.4923543) predict(outcome(5)) atmeans
marginsplot, xlabel(0(0.5)2.5) ylabel(0.03(.01).12) ytitle(Prob. Identify Only With Ethnicity) xtitle(BGI) title("High WGI") recast(line) recastci(rarea) level(95) name(high, replace) nodraw
graph combine low high, cols(2) 


*** p. 13, discussion on Senegal
*average BGI of Diola (1.747324)
sum bgi if cowcode==433 & groupname=="Diola" & abw!=. & age!=. & educ!=. & employment!=. & urbrur!=. & gender!=. & groupsize!=. & poor!=. & excluded!=. & compt!=. & polity2!=. & polity2sq!=. & loggdp_lag!=. & growth_lag!=. 
centile bgi if abw!=. & age!=. & educ!=. & employment!=. & urbrur!=. & gender!=. & groupsize!=. & poor!=. & excluded!=. & compt!=. & polity2!=. & polity2sq!=. & loggdp_lag!=. & growth_lag!=. , centile(99)
*average BGI of Mandingues (.0567044)
sum bgi if cowcode==433 & groupname=="Mandingue (and other eastern groups)" & abw!=. & age!=. & educ!=. & employment!=. & urbrur!=. & gender!=. & groupsize!=. & poor!=. & excluded!=. & compt!=. & polity2!=. & polity2sq!=. & loggdp_lag!=. & growth_lag!=. 
centile bgi if abw!=. & age!=. & educ!=. & employment!=. & urbrur!=. & gender!=. & groupsize!=. & poor!=. & excluded!=. & compt!=. & polity2!=. & polity2sq!=. & loggdp_lag!=. & growth_lag!=. , centile(34)


*** p. 25, correlation BGI/WGI
corr bgi wgi if abw!=. & age!=. & educ!=. & employment!=. & urbrur!=. & gender!=. & groupsize!=. & poor!=. & excluded!=. & compt!=. & polity2!=. & polity2sq!=. & loggdp_lag!=. & growth_lag!=. 


*** p. 25, VIF
set more off
reg ethnic_identity bgi wgi abw age educ employment urbrur gender groupsize poor excluded compt polity2 polity2sq loggdp_lag growth_lag, robust
vif
