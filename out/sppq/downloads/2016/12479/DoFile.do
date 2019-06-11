clear
set more off

***ACCESSING DATA***
use "OrgData.dta"

**IMPORTANT NOTE: Population is in millions, Square Area is in millions of square kilometers, Spending is in hundreds of millions**
**PLEASE SEE DataSources.pdf for more information about the source of each variable, along with any changes made to the original data**

***PREPARING DATA FOR TIME SERIES ANALYSIS***
xtset id year

********************************************************************************
********************************************************************************

**********REPRODUCING TABLES**********

	*****REPRODUCING THE SUMMARY STATISTICS TABLE (TABLE 1)*****
		sum forenf_vio penaltyfac NR unified numfacilities sierraclub pop sqa spending airqual nat_dep man_grade LCVavg PoorHealthDys change_GDP laws noprimacy


	*****REPRODUCING TABLE 3 (DV= Number of formal enforcements issued per the number of facilities with alleged violations*****

		**Baseline Model**
		xtreg forenf_vio l.forenf_vio NR numfacilities pop sqa spend airqual l.airqual man_grade PoorHealthDys change_GDP laws noprimacy, cluster(state)

		**Full Model**
		xtreg forenf_vio l.forenf_vio NR unified sierraclub LCVavg nat_dep numfacilities pop sqa spend airqual l.airqual man_grade PoorHealthDys change_GDP laws noprimacy, cluster(state)


	*****REPRODUCING TABLE 4 (DV= Dollar penalty amounts per the number of inspectable facilities*****

		**Baseline Model**
		xtreg penaltyfac l.penaltyfac NR numfacilities pop sqa spend airqual l.airqual man_grade PoorHealthDys change_GDP laws noprimacy, cluster(state)

		**Full Model**
		xtreg penaltyfac l.penaltyfac NR unified sierraclub LCVavg nat_dep numfacilities pop sqa spend airqual l.airqual man_grade PoorHealthDys change_GDP laws noprimacy, cluster(state)


********************************************************************************
********************************************************************************

**********REPRODUCING SUPPLEMENTARY TABLES/ROBUSTNESS CHECKS**********

	***REPRODUCING SUPPLEMENTAL TABLE 1: FORMAL ENFORCEMENTS MODEL w/ ALTERNATIVE MEASURE OF POLITICAL CONTROL***
		xtreg forenf_vio l.forenf_vio NR perrep gov_pty sierraclub LCVavg nat_dep numfacilities pop sqa spend airqual l.airqual man_grade PoorHealthDys change_GDP laws noprimacy, cluster(state)

	***REPRODUCING SUPPLEMENTAL TABLE 2: PENALTIES MODEL w/ ALTERNATIVE MEASURE OF POLITICAL CONTROL***
		xtreg penaltyfac l.penaltyfac NR perrep gov_pty sierraclub LCVavg nat_dep numfacilities pop sqa spend airqual l.airqual man_grade PoorHealthDys change_GDP laws noprimacy, cluster(state)
	
	***REPRODUCING SUPPLEMENTAL TABLE 3: FORMAL ENFORCEMENTS MODEL, POPULATION AVERAGED***
		xtreg forenf_vio l.forenf_vio NR unified sierraclub LCVavg nat_dep numfacilities pop sqa spend airqual l.airqual man_grade PoorHealthDys change_GDP laws noprimacy, pa

	***REPRODUCING SUPPLEMENTAL TABLE 4: PENALTIES MODEL, POPULATION AVERAGED***
		xtreg penaltyfac l.penaltyfac NR unified sierraclub LCVavg nat_dep numfacilities pop sqa spend airqual l.airqual man_grade PoorHealthDys change_GDP laws noprimacy, pa

	***REPRODUCING SUPPLEMENTAL TABLE 5: FORMAL ENFORCEMENTS MODEL, MIXED MODEL***
		xtmixed forenf_vio lagforenf NR unified sierraclub LCVavg nat_dep numfacilities pop sqa spend airqual lagairqual man_grade PoorHealthDys change_GDP laws noprimacy || state:, vce(cluster state) var
		
	***REPRODUCING SUPPLEMENTAL TABLE 6: PENALTIES MODEL, MIXED MODEL***
		xtmixed penaltyfac lagpenaltyfac NR unified sierraclub LCVavg nat_dep numfacilities pop sqa spend airqual lagairqual man_grade PoorHealthDys change_GDP laws noprimacy || state:, vce(cluster state) var
		
	***REPRODUCING SUPPLEMENTAL TABLE 7: FORMAL ENFORCEMENTS MODEL w/ STANDARDIZED BETA COEFFICIENTS***
		reg forenf_vio l.forenf_vio NR unified sierraclub LCVavg nat_dep numfacilities pop sqa spend airqual l.airqual man_grade PoorHealthDys change_GDP laws noprimacy, beta

	***REPRODUCING SUPPLEMENTAL TABLE 8: PENALTIES MODEL w/ STANDARDIZED BETA COEFFICIENTS***
		reg penaltyfac l.penaltyfac NR unified sierraclub LCVavg nat_dep numfacilities pop sqa spend airqual l.airqual man_grade PoorHealthDys change_GDP laws noprimacy, beta

********************************************************************************
********************************************************************************

**Please send any additional questions about replication to the author, JoyAnna Hopper, at jshopper@sewanee.edu**
