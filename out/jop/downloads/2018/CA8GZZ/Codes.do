** Table 1: Effect of the Structure of Ethnic Inequality on Ethnic Voting 

set more off

* All Regimes
reg GV  c.bgi##c.wgi groupsize poor excluded lngdppc polity2 c1-c77  lb wvs afro, cluster(ccode)
reg GV  c.bgi##c.wgi groupsize poor excluded lngdppc polity2 EF_EPR federalism pr pres semi lb wvs afro, cluster(ccode)

* Partial and Full Democracies
reg GV  c.bgi##c.wgi groupsize poor excluded lngdppc polity2 c1-c77 lb wvs afro if polity2>=1, cluster(ccode)
reg GV  c.bgi##c.wgi groupsize poor excluded lngdppc polity2 EF_EPR federalism pr pres semi  lb wvs afro if polity2>=1, cluster(ccode)

***********************************************************

** Figure 1: Marginal Effects and Predicted Values

set scheme s1mono
set more off
reg GV  c.bgi##c.wgi groupsize poor excluded lngdppc polity2 c1-c77  lb wvs afro, cluster(ccode)
margins , at(bgi=(0(1)15) wgi=(.189856))
marginsplot, xlabel(0(5)15) ylabel(0.05(0.2)0.7) ytitle(Ethnic Voting) xtitle(BGI) title("Low WGI") recast(line) recastci(rarea)  name(low, replace) $sq nodraw
reg GV  c.bgi##c.wgi groupsize poor excluded lngdppc polity2 c1-c77  lb wvs afro, cluster(ccode)
margins , at(bgi=(0(1)15) wgi=(.4427582))
marginsplot, xlabel(0(5)15) ylabel(0.05(0.2)0.7) ytitle(Ethnic Voting) xtitle(BGI) title("High WGI") recast(line) recastci(rarea)  name(high, replace) $sq nodraw
graph combine low high , cols(2) title("Panel B: Predicted Ethnic Voting Values") name(predicted, replace) $sq nodraw
reg GV  c.bgi##c.wgi groupsize poor excluded lngdppc polity2 c1-c77  lb wvs afro, cluster(ccode)
margins, dydx(bgi) at(wgi=(0(0.1).8)) atmeans
marginsplot, xlabel(0(0.1).8) ylabel(-0.06(0.03).06) ytitle(Marginal Effect of BGI) xtitle(WGI) yline(0) title("Panel A: Marginal Effect of BGI Across WGI Levels") recast(line) level(95) recastci(rarea) name(marginal, replace) $sq nodraw
graph combine marginal predicted, cols(1) 

***********************************************************

** Additional results

* p.14 correlation between BGI and WGI
corr bgi wgi if GV!=. &  bgi!=. & wgi!=. &  groupsize!=. & poor!=. & lngdppc!=. & polity2!=. & EF_EPR!=. & federalism!=. & pr!=. 

* p. 27 VIF
reg GV  bgi wgi groupsize poor excluded lngdppc polity2 EF_EPR federalism pr pres semi lb wvs afro, cluster(ccode)
vif
