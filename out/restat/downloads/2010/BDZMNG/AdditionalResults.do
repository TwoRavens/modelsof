********Additional results**********


****Additional results (available on the corresponding author's website -http://ces.univ-paris1.fr/membre/Poncet/)***

use final.dta, clear
iis codeprovs 

*Table 1:
xtreg  lnwageh_alt1 lnMA sex  schooly exper age age2 communist ownstate ownlocal ownselfe ownuc ownsinoforegin ownforeign ownallother occupowner-occupunskilled , cluster (codeprovs) fe
xtreg  lnwageh_alt2 lnMA sex  schooly exper age age2 communist ownstate ownlocal ownselfe ownuc ownsinoforegin ownforeign ownallother occupowner-occupunskilled , cluster (codeprovs) fe
xtreg  lnwageh_alt3 lnMA sex  schooly exper age age2 communist ownstate ownlocal ownselfe ownuc ownsinoforegin ownforeign ownallother occupowner-occupunskilled , cluster (codeprovs) fe

*Table 2:
heckman lnbasewageh lnMA sex  schooly  exper age age2 communist dprovs*  ownstate ownlocal ownucoll ownsinoforegin ownforeign ownallother occupowner-occupunskilled, select (lnMA exper age2 communist sex schooly age dprovs*   ownstate ownlocal ownucoll ownsinoforegin ownforeign ownallother occupowner-occupunskilled noworkin hhwealth married_male married_female hhmembers) cluster (codeprovs)

*Table 3:
heckman lnbasewageh lnMA sex  schooly  exper age age2 communist dprovs*  ownstate ownlocal ownucoll ownsinoforegin ownforeign ownallother occupowner-occupunskilled, select (lnMA exper age2 communist sex schooly age dprovs*   ownstate ownlocal ownucoll ownsinoforegin ownforeign ownallother occupowner-occupunskilled noworkin hhwealth married_male married_female hhmembers) twostep


