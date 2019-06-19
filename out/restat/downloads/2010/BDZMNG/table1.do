
use final.dta, clear

*Table 1:

iis sector
xtreg lnbasewageh sex schooly exper age age2 communist , cluster (sector) fe
xtreg lnbasewageh lnMA sex  schooly exper age age2 communist , cluster (sector) fe

iis codeprovs																					
xtreg  lnbasewageh lnMA sex  schooly exper age age2 communist , cluster (codeprovs) fe
xtreg  lnbasewageh lnMA sex  schooly exper age age2 communist ownstate ownlocal ownselfe ownuc ownsinoforegin ownforeign ownallother , cluster (codeprovs) fe
xtreg  lnbasewageh lnMA sex  schooly exper age age2 communist ownstate ownlocal ownselfe ownuc ownsinoforegin ownforeign ownallother occupowner-occupunskilled , cluster (codeprovs) fe


