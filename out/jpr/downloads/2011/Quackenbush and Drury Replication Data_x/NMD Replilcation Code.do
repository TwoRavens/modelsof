** Replication file for: 
** Quackenbush, Stephen L., and A. Cooper Drury. 2011. “National Missile Defense 
** and Satisfaction.” Journal of Peace Research 48(4): 469-80.


**Main Analysis
* use NMD Replication Data.dta

*Table II
sureg (tar_gov L.us_gov L2.tar_gov event_j appropriation date) (us_gov L.tar_gov L2.us_gov date)

*Table III
sureg (tar_gov L.us_gov L2.tar_gov test appropriation date) (us_gov L.tar_gov L2.us_gov date)

*Table IV
sureg (tar_gov L.us_gov L2.tar_gov event_j appropriation date) (us_gov L.tar_gov L2.us_gov date) if ccode==365
sureg (tar_gov L.us_gov L2.tar_gov event_j appropriation date) (us_gov L.tar_gov L2.us_gov date) if ccode==710
sureg (tar_gov L.us_gov L2.tar_gov event_j appropriation date) (us_gov L.tar_gov L2.us_gov date) if ccode==750

*Table V
sureg (tar_gov L.us_gov L2.tar_gov test appropriation date) (us_gov L.tar_gov L2.us_gov date) if ccode==365
sureg (tar_gov L.us_gov L2.tar_gov test appropriation date) (us_gov L.tar_gov L2.us_gov date) if ccode==710
sureg (tar_gov L.us_gov L2.tar_gov test appropriation date) (us_gov L.tar_gov L2.us_gov date) if ccode==750

*Supplemental Analysis
sureg (tar_gov L.us_gov L2.tar_gov event_j appropriation date) (us_gov L.tar_gov L2.us_gov F.event_j F.appropriation date)
sureg (tar_gov L.us_gov L2.tar_gov test appropriation date) (us_gov L.tar_gov L2.us_gov F.event_j F.appropriation date)

** UN Voting analysis
* use unvoting.dta

*Figure 4
twoway (lfit russia2 year) (scatter russia2 year), ytitle(Percent Agreement) yscale(range(0 100)) ylabel(0(25)100) xtitle(Year) scheme(sj)

*Figure 5
twoway (lfit china2 year) (scatter china2 year), ytitle(Percent Agreement) yscale(range(0 100)) ylabel(0(25)100) xtitle(Year) scheme(sj)

*Figure 6
twoway (lfit india2 year) (scatter india2 year), ytitle(Percent Agreement) yscale(range(0 100)) ylabel(0(25)100) xtitle(Year) scheme(sj)
