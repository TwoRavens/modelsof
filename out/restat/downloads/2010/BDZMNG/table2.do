use final.dta, clear
iis codeprovs

*Table 2:
*line 1 (same as last column of Table 1) 
xtreg  lnbasewageh lnMA sex  schooly exper age age2 communist ownstate ownlocal ownselfe ownuc ownsinoforegin ownforeign ownallother occupowner-occupunskilled , cluster (codeprovs) fe

*line 2
ivreg2 lnbasewageh (lnMA=lnsuminvc lnsuminvR) sex schooly exper age age2 communist ownstate ownlocal ownselfe ownuc ownsinoforegin ownforeign ownallother occupowner-occupunskilled dprovs*, ro
* to obtain Wu-Hausman, repeat ivreg2 without ro:																				
ivreg2 lnbasewageh (lnMA=lnsuminvc lnsuminvR) sex schooly exper age age2 communist ownstate ownlocal ownselfe ownuc ownsinoforegin ownforeign ownallother occupowner-occupunskilled dprovs*	 
ivendog																							
*gives the Wu Hausman statistics

*line 3
xtreg  lnbasewageh lnLcostsMA sex  schooly exper age age2 communist ownstate ownlocal ownselfe ownuc ownsinoforegin ownforeign ownallother occupowner-occupunskilled , cluster (codeprovs) fe

*line 4
xtreg  lnbasewageh lnPopMA sex  schooly exper age age2 communist ownstate ownlocal ownselfe ownuc ownsinoforegin ownforeign ownallother occupowner-occupunskilled , cluster (codeprovs) fe

*line 5
xtreg  lnbasewageh lnharris sex  schooly exper age age2 communist ownstate ownlocal ownselfe ownuc ownsinoforegin ownforeign ownallother occupowner-occupunskilled , cluster (codeprovs) fe

*line 6
xtreg  lnbasewage lnMA sex  schooly exper age age2 communist ownstate ownlocal ownselfe ownuc ownsinoforegin ownforeign ownallother occupowner-occupunskilled , cluster (codeprovs) fe

