***************************************************
/* Replication Code Schleiter and Voznaya (2015) */
***************************************************

**************************
/* Comparative Analysis */
**************************

cd "C:\Users\User\Dropbox\PSI and Corruption Paper\Data and Do Files\Replication Files_Data & Code\"
use "Schleiter_Voznaya_Comparative_Replication.dta", clear

/*Table 1: Party System Institutionalization Effects on Corruption Perceptions (avg. 2003-2009)*/
		*M1*
		regress corrwgi lag7lnptyage lag7lnenep lag7prop_ideo decentr prespwr lag7lngdppc lag7polity2 lag7trdopeni fsup mep clap asiap africap if lag7ol!=.
		outreg2 lag7lnptyage lag7lnenep lag7prop_ideo decentr prespwr lag7trdopeni lag7lngdppc lag7polity2 using "Table 1.rtf", nonotes ///
		addtext(Region Dummies,Yes) ///
		addn("Note: The dependent variable is perceptions of corruption control; standard errors in parentheses; *p<.10, **p<.05, ***p<.01 (two-tailed test).") ///
		label coef aster sdec(3) bdec(3) se replace
		*M2*
		regress corrwgi lag7lnptyage lag7lnenep lag7prop_ideo decentr prespwr lag7lngdppc lag7lnage6dem_1 lag7trdopeni fsup mep clap asiap africap if lag7ol!=.
		outreg2 lag7lnptyage lag7lnenep lag7prop_ideo decentr prespwr lag7trdopeni lag7lngdppc lag7polity2 lag7lnage6dem_1 using "Table 1.rtf", ///
		addtext(Region Dummies,Yes) ///
		label coef aster sdec(3) bdec(3) se append
		*M3*
		regress corrwgi lag7lnptyage lag7lnenep lag7prop_ideo elfalesina decentr prespwr lag7lngdppc lag7polity2 lag7trdopeni ///
		lag7pr lag7fptp lag7ol lag7olpr fsup mep clap asiap africap if lag7ol!=.
		outreg2 lag7lnptyage lag7lnenep lag7prop_ideo decentr prespwr lag7trdopeni lag7lngdppc lag7polity2 lag7trdopeni ///
		elfalesina lag7pr lag7fptp lag7ol lag7olpr using "Table 1.rtf", ///
		addtext(Region Dummies,Yes) ///
		title("Table 1: Party System Institutionalization Effects on Corruption Perceptions (averaged 2003-2009)") ///
		label coef aster sdec(3) bdec(3) se append

/*in text interpretation */
		regress corrwgi lag7lnptyage lag7lnenep lag7prop_ideo decentr prespwr lag7lngdppc lag7polity2 lag7trdopeni fsup mep clap asiap africap if lag7ol!=.
		margins, at(lag7lnptyage=(1.439 3.452 4.169)) atmeans post

/*Table 2: Instrumental Variable Analysis*/
		*controlling for quality of democracy (polity score)*
			ivregress 2sls corrwgi lag7lnenep lag7prop_ideo decentr prespwr lag7lngdppc lag7trdopeni fsup mep clap asiap africap lag7polity2 (lag7lnptyage = lnptyage80s), first
			estat endogenous
			estat firststage
			outreg2 lag7lnptyage lag7lnenep lag7prop_ideo decentr prespwr lag7lngdppc lag7trdopeni lag7polity2 using "Table2.rtf", coef aster sdec(3) bdec(3) se label replace ///
			title("Table 2: Instrumental Variable Analysis (Two Stage Least Squares)") ///
			nonotes addn("Note: The dependent variable (stage 2) is perceptions of corruption control; standard errors in parentheses; *p<.10, **p<.05, ***p<.01 (two-tailed test).")
		*controlling for age of democracy*
			ivregress 2sls corrwgi lag7lnenep lag7prop_ideo decentr prespwr lag7lngdppc lag7trdopeni fsup mep clap asiap africap lag7lnage6dem_1 (lag7lnptyage = lnptyage80s), first
			estat endogenous
			estat firststage
			outreg2 lag7lnptyage lag7lnenep lag7prop_ideo decentr prespwr lag7lngdppc lag7trdopeni lag7lnage6dem_1 using "Table2.rtf", coef aster sdec(3) bdec(3) se label append
	
/*Table 3: Panama compared to sample mean*/
		*M2 - predicted and observed corruption control scores for Panama*
		regress corrwgi lag7lnptyage lag7lnenep lag7prop_ideo decentr prespwr lag7lngdppc lag7lnage6dem_1 lag7trdopeni fsup mep clap asiap africap if lag7ol!=.
		predict xb
		list corrwgi xb if countryn==66

		*Panama compared to sample mean*
		tabstat corrwgi lag7lnptyage lag7lnenep lag7prop_ideo decentr prespwr lag7lngdppc lag7trdopeni lag7lnage6dem_1 if lag7ol!=., ///
		stat(mean sd min max) col(stat) long
		tabstat corrwgi lag7lnptyage lag7lnenep lag7prop_ideo decentr prespwr lag7lngdppc lag7trdopeni lag7lnage6dem_1 if countryn==66 & lag7ol!=., ///
		long
			
************************
/*Case study of Panama*/
************************

use "Schleiter_Voznaya_Panama_Replication.dta", clear


/*Table 5: Models Panama*/
			regress diff_pct corr2all c.corr2all#i.low_transppa low_transppa urban distcands senior term cgovpty1 mptyopp_el un0409 i_age, cluster(year04)
			outreg2 using "Table 5.rtf", coef aster sdec(3) bdec(3) se label replace ctitle(DV = Vote share change) ///
			title("Table 5: Effects of Corruption Allegations on Vote for the Incumbent") ///
			nonotes addn("Note: The dependent variables are vote share change (models 1 & 2) and vote share of incumbent (models 3 & 4), robust standard errors clustered on election year in parentheses, *** p<0.01, ** p<0.05, * p<0.1; the Wald tests report the p-value for the corruption allegations variable plus its interaction with party/alliance change.")
			regress diff_pct corr2alli c.corr2alli#i.low_transppa low_transppa urban distcands senior term cgovpty1 mptyopp_el un0409 i_age, cluster(year04)
			outreg2 using "Table 5.rtf", coef aster sdec(3) bdec(3) se label append ctitle(DV = Vote share change)
			regress relpct corr2all c.corr2all#i.low_transppa low_transppa voteshare urban distcands senior term cgovpty1 mptyopp_el un0409 i_age, cluster(year04)
			outreg2 using "Table 5.rtf", coef aster sdec(3) bdec(3) se label append ctitle(DV = Vote share)
			regress relpct corr2alli c.corr2alli#i.low_transppa low_transppa voteshare urban distcands senior term cgovpty1 mptyopp_el un0409 i_age, cluster(year04)
			outreg2 using "Table 5.rtf", coef aster sdec(3) bdec(3) se label append ctitle(DV = Vote share)

/*Table 5: Wald tests*/
			regress diff_pct corr2all c.corr2all#i.low_transppa i.low_transppa i.urban c.distcands i.senior term i.cgovpty1 i.mptyopp_el un0409 i_age, cluster(year04)
			test corr2all+c.corr2all#1.low_transppa=0
			regress diff_pct corr2alli c.corr2alli#i.low_transppa i.low_transppa i.urban c.distcands i.senior term i.cgovpty1 i.mptyopp_el un0409 i_age, cluster(year04)
			test corr2alli+c.corr2alli#1.low_transppa=0
			regress relpct corr2all c.corr2all#i.low_transppa i.low_transppa voteshare i.urban c.distcands i.senior term i.cgovpty1 i.mptyopp_el un0409 i_age, cluster(year04)
			test corr2all+c.corr2all#1.low_transppa=0
			regress relpct corr2alli c.corr2alli#i.low_transppa i.low_transppa voteshare i.urban c.distcands i.senior term i.cgovpty1 i.mptyopp_el un0409 i_age, cluster(year04)
			test corr2alli+c.corr2alli#1.low_transppa=0

/*Figure 1: Interpretation of interaction effect (model 1, table 5)*/
			regress diff_pct corr2all c.corr2all#i.low_transppa i.low_transppa i.urban c.distcands i.senior term i.cgovpty1 i.mptyopp_el un0409 i_age, cluster(year04)
			margins, dydx(corr2all) at(low_transppa = (0 1))
			marginsplot, title("") yline(0) legend(off)

/*Results reported in text*/
			/*in text result FN22*/
						gen corrdum = 0
						replace corrdum = 1 if corr2all > 0
						ttest corrdum if diff_pct!=., by(low_transppa)

			/*Discussion of Figure 1*/
						regress diff_pct corr2all c.corr2all#i.low_transppa i.low_transppa i.urban c.distcands i.senior term i.cgovpty1 i.mptyopp_el un0409 i_age, cluster(year04)
						margins low_transppa, at(c.corr2all=(20 40 65)) vsquish
			
			/*Correlation of between corruption allegations and party/alliance change*/			
						pwcorr low_transppa corrdum if diff_pct!=., sig

*****************************
/*Supplementary Information*/
*****************************

/*Comparative Analysis*/
	use "Schleiter_Voznaya_Comparative_Replication.dta", clear

	/*Table SI1: Descriptives comparative analysis*/
		tabstat corrwgi lag7lnptyage lag7lnenep lag7prop_ideo elfalesina decentr prespwr lag7lngdppc lag7polity2 lag7trdopeni lag7pr lag7fptp ///
		lag7ol lag7olpr lag7lnage6dem_1 lnptyage80s ///
		fsup mep clap asiap africap if lag7ol!=., stat(mean sd min max) col(stat) long

	/*Table SI 2: Robustness to Alternative Specifications*/
		/*M1: Alternative operationalization of party system instutitionalization: Volatility*/
				label var vol9002 "Party System Institutionalization (volatility)"
			regress corrwgi vol9002 lag7lnenep lag7prop_ideo decentr prespwr lag7lngdppc lag7lnage6dem_1 lag7trdopeni fsup mep clap asiap africap if lag7ol!=.
			outreg2 vol9002 lag7lnenep lag7prop_ideo decentr prespwr lag7lngdppc lag7lnage6dem_1 lag7trdopeni ///			
			using "tableSI2.rtf", coef aster sdec(3) bdec(3) se label replace ctitle(Volatility) ///
			addtext(Region Dummies,Yes) ///
			title("Table SI 2: Robustness to Alternative Specifications") ///
			nonotes addn("Note: The dependent variable is perceptions of corruption control; standard errors in parentheses; *** p<0.01, ** p<0.05, * p<0.1 (two-tailed tests)")
		/*M2 Orthogonalizing PSI, age of democracy and wealth*/
			orthog lag7lngdppc lag7lnage6dem_1 lag7lnptyage, gen(olag7lngdppc olag7lnage6dem_1 olag7lnptyage)
				label var olag7lnptyage "Party System Inst'zn (ln party age, orthog.)"
				label var olag7lngdppc "GDP per capita (ln, orthog.)"
				label var olag7lnage6dem "Democarcy (ln, age, orthog.)"
			regress corrwgi olag7lnptyage lag7lnenep lag7prop_ideo decentr prespwr olag7lngdppc olag7lnage6dem_1 lag7trdopeni fsup mep clap asiap africap if lag7ol!=.
			outreg2 olag7lnptyage lag7lnenep lag7prop_ideo decentr prespwr olag7lngdppc olag7lnage6dem_1 lag7trdopeni ///
			using "tableSI2.rtf", coef aster sdec(3) bdec(3) se label append ctitle(Party Age orthog.) ///
			addtext(Region Dummies,Yes)
		/*M3&4: Changing the definition of democracy*/
			**Sample polity average 7+*
			regress corrwgi lag7lnptyage lag7lnenep lag7prop_ideo decentr prespwr lag7lngdppc lag7lnage6dem_1 lag7trdopeni fsup mep clap asiap africap if lag7ol!=. & lag7polity2>=7
			outreg2 lag7lnptyage lag7lnenep lag7prop_ideo decentr prespwr lag7lngdppc lag7lnage6dem_1 lag7trdopeni ///
			using "tableSI2.rtf", coef aster sdec(3) bdec(3) se label append ctitle(Sample: Polity 7) ///
			addtext(Region Dummies,Yes)
			**Sample polity average 8+*
			regress corrwgi lag7lnptyage lag7lnenep lag7prop_ideo decentr prespwr lag7lngdppc  lag7lnage6dem_1 lag7trdopeni fsup mep clap asiap africap if lag7ol!=. & lag7polity2>=8
			outreg2 lag7lnptyage lag7lnenep lag7prop_ideo decentr prespwr lag7lngdppc  lag7lnage6dem_1 lag7trdopeni ///
			using "tableSI2.rtf", coef aster sdec(3) bdec(3) se label append ctitle(Sample: Polity 8) ///
			addtext(Region Dummies,Yes)


/*Panama Case Study*/
	use "Schleiter_Voznaya_Panama_Replication.dta", clear

	/*Table SI 3: Panama Case Descriptives*/
			tabstat diff_pct relpct corr2all corr2alli low_transppa urban distcands cgovpty1 mptyopp_el senior term i_age un0409  voteshare, ///
			stat(mean sd min max) col(stat) long
			
	/*Figure SI 4: Marginal effect of party/alliance change (model 1, table 5)*/			
			regress diff_pct corr2all c.corr2all#i.low_transppa i.low_transppa urban distcands senior term cgovpty1 mptyopp_el un0409 i_age, cluster(year04)
			margins, dydx(low_transppa) at(corr2all = (0(5)65))
			marginsplot, title("") yline(0) legend(off) 

			
