use final.dta, clear
iis codeprovs

*Table 3:
xtreg  lnbasewageh lnMA lnpop1997 sex  schooly exper age age2 communist ownstate ownlocal ownselfe ownuc ownsinoforegin ownforeign ownallother occupowner-occupunskilled , cluster (codeprovs) fe

xtreg  lnbasewageh lnMA skill_int sex  schooly exper age age2 communist ownstate ownlocal ownselfe ownuc ownsinoforegin ownforeign ownallother occupowner-occupunskilled , cluster (codeprovs) fe

xtreg  lnbasewageh lnMA spat_dec sex  schooly exper age age2 communist ownstate ownlocal ownselfe ownuc ownsinoforegin ownforeign ownallother occupowner-occupunskilled , cluster (codeprovs) fe

xtreg  lnbasewageh lnMA living_cost sex  schooly exper age age2 communist ownstate ownlocal ownselfe ownuc ownsinoforegin ownforeign ownallother occupowner-occupunskilled , cluster (codeprovs) fe

xtreg  lnbasewageh lnMA skill_int lnpop1997 living_cost spat_dec sex  schooly exper age age2 communist ownstate ownlocal ownselfe ownuc ownsinoforegin ownforeign ownallother occupowner-occupunskilled , cluster (codeprovs) fe

