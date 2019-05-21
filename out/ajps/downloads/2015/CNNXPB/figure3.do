* Date: May 23, 2013
* Apply to: figure3.dta
* Description:	Replicate percent of Democrats and Republicans
*				who support or oppose Props. 25 and 26 in Figure 3
*
*				Replicate t-tests for these initiatives

clear
clear matrix

set matsize 1000

set more off


use "\figure3.dta", clear


*PROPOSITION 26, Figure 3(a)

*Democrats, Percent Support

ttest i26_yes if (treat==1 | treat==2) & democrat==1, by(treat)
ttest i26_yes if (treat==1 | treat==3) & democrat==1, by(treat)
ttest i26_yes if (treat==1 | treat==4) & democrat==1, by(treat)

ttest i26_yes if (treat==2 | treat==4) & democrat==1, by(treat)


*Democrats, Percent Oppose

ttest i26_no if (treat==1 | treat==2) & democrat==1, by(treat)
ttest i26_no if (treat==1 | treat==3) & democrat==1, by(treat)
ttest i26_no if (treat==1 | treat==4) & democrat==1, by(treat)

ttest i26_no if (treat==2 | treat==4) & democrat==1, by(treat)


*PROPOSITION 26, Figure 3(b)

*Republicans, Percent Support

ttest i26_yes if (treat==1 | treat==2) & democrat==0, by(treat)
ttest i26_yes if (treat==1 | treat==3) & democrat==0, by(treat)
ttest i26_yes if (treat==1 | treat==4) & democrat==0, by(treat)

ttest i26_yes if (treat==2 | treat==4) & democrat==0, by(treat)


*Republicans, Percent Oppose

ttest i26_no if (treat==1 | treat==2) & democrat==0, by(treat)
ttest i26_no if (treat==1 | treat==3) & democrat==0, by(treat)
ttest i26_no if (treat==1 | treat==4) & democrat==0, by(treat)

ttest i26_no if (treat==2 | treat==4) & democrat==0, by(treat)


*PROPOSITION 25, Figure 3(c)

*Democrats, Percent Support

ttest i25_yes if (treat==1 | treat==2) & democrat==1, by(treat)
ttest i25_yes if (treat==1 | treat==3) & democrat==1, by(treat)
ttest i25_yes if (treat==1 | treat==4) & democrat==1, by(treat)

ttest i25_yes if (treat==2 | treat==4) & democrat==1, by(treat)


*Democrats, Percent Oppose

ttest i25_no if (treat==1 | treat==2) & democrat==1, by(treat)
ttest i25_no if (treat==1 | treat==3) & democrat==1, by(treat)
ttest i25_no if (treat==1 | treat==4) & democrat==1, by(treat)

ttest i25_no if (treat==2 | treat==4) & democrat==1, by(treat)



*PROPOSITION 25, Figure 3(d)

*Republicans, Percent Support

ttest i25_yes if (treat==1 | treat==2) & democrat==0, by(treat)
ttest i25_yes if (treat==1 | treat==3) & democrat==0, by(treat)
ttest i25_yes if (treat==1 | treat==4) & democrat==0, by(treat)

ttest i25_yes if (treat==2 | treat==4) & democrat==0, by(treat)


*Republicans, Percent Oppose

ttest i25_no if (treat==1 | treat==2) & democrat==0, by(treat)
ttest i25_no if (treat==1 | treat==3) & democrat==0, by(treat)
ttest i25_no if (treat==1 | treat==4) & democrat==0, by(treat)

ttest i25_no if (treat==2 | treat==4) & democrat==0, by(treat)


*Estimate means, standard errors for Figure 3

mean i25_yes, over(treat dem) l(95)
mean i25_no, over(treat dem) l(95)

mean i26_yes, over(treat dem) l(95)
mean i26_no, over(treat dem) l(95)


* End
