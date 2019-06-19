use final.dta, clear
iis codeprovs

*Table 4: effect of education

*col 1 & 2
xtreg  lnbasewageh lnMA sex  schooly exper age age2 communist ownstate ownlocal ownselfe ownuc ownsinoforegin ownforeign ownallother occupowner-occupunskilled if dnq==0 , cluster (codeprovs) fe
xtreg  lnbasewageh lnMA sex  schooly exper age age2 communist ownstate ownlocal ownselfe ownuc ownsinoforegin ownforeign ownallother occupowner-occupunskilled if dnq==1 , cluster (codeprovs) fe

*col 3 & 4
xtreg  lnbasewageh lnMA living_costs sex  schooly exper age age2 communist ownstate ownlocal ownselfe ownuc ownsinoforegin ownforeign ownallother occupowner-occupunskilled if dnq==0 , cluster (codeprovs) fe
xtreg  lnbasewageh lnMA living_costs sex  schooly exper age age2 communist ownstate ownlocal ownselfe ownuc ownsinoforegin ownforeign ownallother occupowner-occupunskilled if dnq==1 , cluster (codeprovs) fe

*col 5 & 6
xtreg  lnbasewageh lnMA living_costs skill_int sex  schooly exper age age2 communist ownstate ownlocal ownselfe ownuc ownsinoforegin ownforeign ownallother occupowner-occupunskilled if dnq==0 , cluster (codeprovs) fe
xtreg  lnbasewageh lnMA living_costs skill_int sex  schooly exper age age2 communist ownstate ownlocal ownselfe ownuc ownsinoforegin ownforeign ownallother occupowner-occupunskilled if dnq==1 , cluster (codeprovs) fe
