*     ***************************************************************** *;*     ***************************************************************** *;*       File-Name:      replication_file.do					 		    *;*       Date:           11/18/2013	                                    *;*       Author:         Sarah Bush and Amaney Jamal                     *;*       Purpose:        Do-file for analysis in ISQ	Paper			    *;*     ****************************************************************  *;*     ****************************************************************  *;/*Randomization Checks (Appendix Table 2)*/

tabulate treatment gender, chi2 row
tabulate treatment region, chi2 row
tabulate treatment urban, chi2 row
by treatment, sort: summarize age
anova treatment age
tabulate treatment education, chi2 rowtabulate treatment employed, chi2 rowtabulate treatment muslim, chi2 row tabulate treatment readquran, chi2 rowby treatment, sort: summarize monthlyincomeanova treatment monthlyincome
by treatment, sort: summarize polknowledge
anova treatment polknowledge
/*Average Treatment Effect, Using Indexed DV*/
	
	/*ATE*/
	ttest dv_indexstand if treatment==1 | treatment==2, by(treatment) unequalttest dv_indexstand if treatment==1 | treatment==3, by(treatment) unequal	
	/*ATE, Men (Figure 3)*/
	ttest dv_indexstand if gender==0 & (treatment==1 | treatment==2), by(treatment) unequalttest dv_indexstand if gender==0 & (treatment==1 | treatment==3), by(treatment) unequal	/*ATE, Women (Figure 3)*/
	ttest dv_indexstand if gender==1 & (treatment==1 | treatment==2), by(treatment) unequalttest dv_indexstand if gender==1 & (treatment==1 | treatment==3), by(treatment) unequal	/*ATE, Comparing Treatments to Each Other*/
	generate treatment_usimams=.
replace treatment_usimams=0 if treatment==2
replace treatment_usimams=1 if treatment==3
ttest dv_indexstand, by(treatment_usimams)
ttest dv_indexstand if gender==0, by(treatment_usimams)
ttest dv_indexstand if gender==1, by(treatment_usimams)

/*Conditional Average Treatment Effect, Using Trust in the Prime Minister (Figure 4)*/

by regime_supporter, sort: ttest dv_indexstand if gender==1 & (treatment==1 | treatment==2), by(treatment) unequaldisplay .1624231*sqrt(133)display .105208*sqrt(335)ttesti 133 .4834014 1.8731546 335 -.0976643 1.9256226, unequaldisplay 0.0029*4
by regime_supporter, sort: ttest dv_indexstand if gender==1 & (treatment==1 | treatment==3), by(treatment) unequal
display .1480696*sqrt(127)display .0989545*sqrt(380)ttesti 127 .6862507 1.6686596 335 -.0175466 1.9289783, unequal
display 0.0001*4
