log using replication_walter, replace
	

/* ======================================================================
REPLICATION DO-FILE

 Globalization and the Demand-Side of Politics
 How globalization shapes labor market risk perceptions and policy preferences

* Replication for paper conditionally accepted by Political Science Research & Methods (PSRM)

======================================================================
13 November 2014
Stefanie Walter, University of Zurich

 Table of Contents
* ---------------------	

1. Recoding of Variables
		1.1 Dependent Variables
			1.1.1 Labor Market Risk
			1.1.2 Redistribution Preference
		1.2	Independent Variables
			1.2.1 Tradeables Sector (Dummy)
				1.2.1.1 Recoding: Inclusion of OECD Industries' Comparative adv. Data
			1.2.2 Offshoreability
			1.2.3 Export-Oriented and Import-Competing Industries
		1.3 Control Variables
			1.3.1 Skill Specificity
			1.3.2 Gender
			1.3.3 Union Membership
			1.3.4 Church Attendance
			1.3.5 Deindustrialization
			1.3.6 Wave Dummy
			1.3.7 Country Dummies
			1.3.8 Weights

2. Analysis (Main Text)
		2.1 The Effect of Globalization-Exposure on Individual Perceptions of Labor Market Risk.
			2.1.1 Figure 3: Histograms
			2.1.2 Determinants of Labor Market Risk Perceptions
				2.1.2.1 Table 1: Determinants of Labor Market Risk Perceptions
				2.1.2.2 Ppredicted Probabilities of Risk Perceptions
			2.1.3 Figure 3a: Trade Dummy (Model 1 and 4)
			2.1.4 Comparison with a Non-Interactive Model
			2.1.5 Discussion of Implications of Hiscox (2002) Argument
		2.2 The Effect of Globalization-Exposure on Social Policy Preferences.
			2.2.1 Determinants of Preferences for Redistribution
				2.2.1.1 Table 2: Determinants of Preferences for Redistribution
				2.2.1.2 Predicted Probabilities of Redistribution Preferences
			2.2.2 Figure 3b: Trade Dummy (Model 8)
			2.2.3 Comparison with a Non-Interactive Model
			2.2.4 Discussion of Implications of Hiscox (2002) Argument
			2.2.5 Correlation Globalization and Deindustrialization
			2.2.6 Restricting Sample to Type of Sector
			2.2.7 Adding an Interaction Term between Manufacturing and Skills
			
3. Robustness Checks
			3.1 Using Multi-Level Specifications
			3.2 Reestimating all Models without Country Dummies
			3.3 Using Education Levels
			3.4 Restricting the Sample to Respondents in the Active Work Force 				
			3.5 Employing a Wider Definition of Unemployment
			3.6 Controlling for Respondents` Labor Market Status
			3.7 Controlling for Employment in the Public Sector
			3.8 Replication of Rehm analysis (table 2, model 7, in Rehm 2009)
				3.8.1 Cramérs V
				3.8.2 AIC / BIC
				3.8.3 Table 3: Replication of Rehm analysis
			3.9 Robustness to including ideology
				3.9.1 Table 4: Robustness to including ideology
4. Appendix: Descriptive Statistics

5. Footnotes

*/		
	
use Data.Glob_PSRM.Oct14.dta, clear


* ======================================================================
* ======================================================================
* 1. RECODING of Variables
* ======================================================================
* ======================================================================


* =====================================================================================
* 1.1	DEPENDENT VARIABLES
* =====================================================================================

* --------------------------------------
* 1.1.1 Labor Market Risk
* --------------------------------------
gen laborrisk=(smbtjob*(-1))+10
replace laborrisk=(smbtjoba*(-1))+10 if laborrisk==.
label var laborrisk "Labor Market Risk (Difficulty of getting smilar/better job)"
label define laborrisk 0 "low ('extremely easy')" 10 "high ('extremely difficult')"
label var laborrisk laborrisk

gen lmrisk=.
replace lmrisk=2 if laborrisk<.
replace lmrisk=1 if laborrisk<8
replace lmrisk=0 if laborrisk<3
label define lmrisk 0 "low" 1 "intermediate" 2 "high"
label val lmrisk lmrisk
label var lmrisk "Labor Market Risk Perception"

gen binlmrisk=laborrisk>7
replace binlmrisk=. if laborrisk==.


* --------------------------------------
* 1.1.2 Redistribution
* --------------------------------------

gen redistribution= gincdif
recode redistribution (1=5) (2=4) (4=2) (5=1)
label var redistribution "Redistribution Preference ('State should reduce income differences in income levels')
label define redistribution 1 "Disagree strongly" 10 "Agree strongly)"
label var redistribution redistribution


* ======================================================================
* 1.2 INDEPENDENT VARIABLES
* ======================================================================

* -----------------------------------------------------------------------
* 1.2.1 Tradeables Sector (Dummy)
* -----------------------------------------------------------------------
* This Do-File adds data on industry-specific trade exposure
* Data Source: OECD STAN Database
* Industry- and year-specific (2002 and 2004) (Exports+Imports)/Output
* ================================================================================

gen nace_both=nacer1
replace nace_both=nacer11 if essround==2

* Wave 2002
gen tradexp=.
replace	tradexp=	.	if	cntry==	"AT"	&	essround==	1	&	nace_both==	1

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	1	&	nace_both==	2

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	1	&	nace_both==	5

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	1	&	nace_both==	10

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	1	&	nace_both==	11

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	1	&	nace_both==	12

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	1	&	nace_both==	13

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	1	&	nace_both==	14

replace	tradexp=	0.621523284	if	cntry==	"AT"	&	essround==	1	&	nace_both==	15

replace	tradexp=	0.580192188	if	cntry==	"AT"	&	essround==	1	&	nace_both==	16

replace	tradexp=	1.539696132	if	cntry==	"AT"	&	essround==	1	&	nace_both==	17

replace	tradexp=	3.035232827	if	cntry==	"AT"	&	essround==	1	&	nace_both==	18

replace	tradexp=	2.315857313	if	cntry==	"AT"	&	essround==	1	&	nace_both==	19

replace	tradexp=	0.586690954	if	cntry==	"AT"	&	essround==	1	&	nace_both==	20

replace	tradexp=	1.057097545	if	cntry==	"AT"	&	essround==	1	&	nace_both==	21

replace	tradexp=	0.526080518	if	cntry==	"AT"	&	essround==	1	&	nace_both==	22

replace	tradexp=	0.740891656	if	cntry==	"AT"	&	essround==	1	&	nace_both==	23

replace	tradexp=	2.184801852	if	cntry==	"AT"	&	essround==	1	&	nace_both==	24

replace	tradexp=	1.3013898	if	cntry==	"AT"	&	essround==	1	&	nace_both==	25

replace	tradexp=	0.52816561	if	cntry==	"AT"	&	essround==	1	&	nace_both==	26

replace	tradexp=	1.156841264	if	cntry==	"AT"	&	essround==	1	&	nace_both==	27

replace	tradexp=	0.716721291	if	cntry==	"AT"	&	essround==	1	&	nace_both==	28

replace	tradexp=	1.425507466	if	cntry==	"AT"	&	essround==	1	&	nace_both==	29

replace	tradexp=	4.946301847	if	cntry==	"AT"	&	essround==	1	&	nace_both==	30

replace	tradexp=	1.703427494	if	cntry==	"AT"	&	essround==	1	&	nace_both==	31

replace	tradexp=	1.666548787	if	cntry==	"AT"	&	essround==	1	&	nace_both==	32

replace	tradexp=	2.392579792	if	cntry==	"AT"	&	essround==	1	&	nace_both==	33

replace	tradexp=	1.982143951	if	cntry==	"AT"	&	essround==	1	&	nace_both==	34

replace	tradexp=	2.026620115	if	cntry==	"AT"	&	essround==	1	&	nace_both==	35

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	1	&	nace_both==	36

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	1	&	nace_both==	37

replace	tradexp=	0.23454191	if	cntry==	"AT"	&	essround==	1	&	nace_both==	40

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	1	&	nace_both==	41

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	1	&	nace_both==	45

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	1	&	nace_both==	50

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	1	&	nace_both==	51

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	1	&	nace_both==	52

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	1	&	nace_both==	55

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	1	&	nace_both==	60

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	1	&	nace_both==	61

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	1	&	nace_both==	62

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	1	&	nace_both==	63

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	1	&	nace_both==	64

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	1	&	nace_both==	65

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	1	&	nace_both==	66

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	1	&	nace_both==	67

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	1	&	nace_both==	70

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	1	&	nace_both==	71

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	1	&	nace_both==	72

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	1	&	nace_both==	73

replace	tradexp=	0.001318985	if	cntry==	"AT"	&	essround==	1	&	nace_both==	74

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	1	&	nace_both==	75

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	1	&	nace_both==	80

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	1	&	nace_both==	85

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	1	&	nace_both==	90

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	1	&	nace_both==	91

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	1	&	nace_both==	92

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	1	&	nace_both==	93

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	1	&	nace_both==	95

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	1	&	nace_both==	98

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	1	&	nace_both==	99

replace	tradexp=	1.376159133	if	cntry==	"BE"	&	essround==	1	&	nace_both==	1

replace	tradexp=	2.009366238	if	cntry==	"BE"	&	essround==	1	&	nace_both==	2

replace	tradexp=	2.913897509	if	cntry==	"BE"	&	essround==	1	&	nace_both==	5

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	1	&	nace_both==	10

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	1	&	nace_both==	11

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	1	&	nace_both==	12

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	1	&	nace_both==	13

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	1	&	nace_both==	14

replace	tradexp=	1.104122295	if	cntry==	"BE"	&	essround==	1	&	nace_both==	15

replace	tradexp=	1.064038746	if	cntry==	"BE"	&	essround==	1	&	nace_both==	16

replace	tradexp=	1.861379774	if	cntry==	"BE"	&	essround==	1	&	nace_both==	17

replace	tradexp=	4.109999275	if	cntry==	"BE"	&	essround==	1	&	nace_both==	18

replace	tradexp=	15.41085637	if	cntry==	"BE"	&	essround==	1	&	nace_both==	19

replace	tradexp=	1.237674592	if	cntry==	"BE"	&	essround==	1	&	nace_both==	20

replace	tradexp=	2.268057057	if	cntry==	"BE"	&	essround==	1	&	nace_both==	21

replace	tradexp=	0.492831468	if	cntry==	"BE"	&	essround==	1	&	nace_both==	22

replace	tradexp=	1.096479513	if	cntry==	"BE"	&	essround==	1	&	nace_both==	23

replace	tradexp=	3.881358039	if	cntry==	"BE"	&	essround==	1	&	nace_both==	24

replace	tradexp=	2.345413851	if	cntry==	"BE"	&	essround==	1	&	nace_both==	25

replace	tradexp=	0.871817698	if	cntry==	"BE"	&	essround==	1	&	nace_both==	26

replace	tradexp=	1.497302411	if	cntry==	"BE"	&	essround==	1	&	nace_both==	27

replace	tradexp=	0.85505478	if	cntry==	"BE"	&	essround==	1	&	nace_both==	28

replace	tradexp=	3.477080677	if	cntry==	"BE"	&	essround==	1	&	nace_both==	29

replace	tradexp=	59.95993782	if	cntry==	"BE"	&	essround==	1	&	nace_both==	30

replace	tradexp=	2.283054997	if	cntry==	"BE"	&	essround==	1	&	nace_both==	31

replace	tradexp=	3.324728618	if	cntry==	"BE"	&	essround==	1	&	nace_both==	32

replace	tradexp=	6.437251964	if	cntry==	"BE"	&	essround==	1	&	nace_both==	33

replace	tradexp=	2.891405856	if	cntry==	"BE"	&	essround==	1	&	nace_both==	34

replace	tradexp=	2.165288053	if	cntry==	"BE"	&	essround==	1	&	nace_both==	35

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	1	&	nace_both==	36

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	1	&	nace_both==	37

replace	tradexp=	0.070227837	if	cntry==	"BE"	&	essround==	1	&	nace_both==	40

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	1	&	nace_both==	41

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	1	&	nace_both==	45

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	1	&	nace_both==	50

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	1	&	nace_both==	51

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	1	&	nace_both==	52

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	1	&	nace_both==	55

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	1	&	nace_both==	60

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	1	&	nace_both==	61

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	1	&	nace_both==	62

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	1	&	nace_both==	63

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	1	&	nace_both==	64

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	1	&	nace_both==	65

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	1	&	nace_both==	66

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	1	&	nace_both==	67

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	1	&	nace_both==	70

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	1	&	nace_both==	71

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	1	&	nace_both==	72

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	1	&	nace_both==	73

replace	tradexp=	0.000774817	if	cntry==	"BE"	&	essround==	1	&	nace_both==	74

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	1	&	nace_both==	75

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	1	&	nace_both==	80

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	1	&	nace_both==	85

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	1	&	nace_both==	90

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	1	&	nace_both==	91

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	1	&	nace_both==	92

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	1	&	nace_both==	93

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	1	&	nace_both==	95

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	1	&	nace_both==	98

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	1	&	nace_both==	99

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	1	&	nace_both==	1

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	1	&	nace_both==	2

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	1	&	nace_both==	5

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	1	&	nace_both==	10

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	1	&	nace_both==	11

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	1	&	nace_both==	12

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	1	&	nace_both==	13

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	1	&	nace_both==	14

replace	tradexp=	0.332705489	if	cntry==	"CH"	&	essround==	1	&	nace_both==	15

replace	tradexp=	0.183449818	if	cntry==	"CH"	&	essround==	1	&	nace_both==	16

replace	tradexp=	2.005982764	if	cntry==	"CH"	&	essround==	1	&	nace_both==	17

replace	tradexp=	3.148828624	if	cntry==	"CH"	&	essround==	1	&	nace_both==	18

replace	tradexp=	6.626310022	if	cntry==	"CH"	&	essround==	1	&	nace_both==	19

replace	tradexp=	0.259383737	if	cntry==	"CH"	&	essround==	1	&	nace_both==	20

replace	tradexp=	1.118628617	if	cntry==	"CH"	&	essround==	1	&	nace_both==	21

replace	tradexp=	0.389016651	if	cntry==	"CH"	&	essround==	1	&	nace_both==	22

replace	tradexp=	6.30351707	if	cntry==	"CH"	&	essround==	1	&	nace_both==	23

replace	tradexp=	1.495057172	if	cntry==	"CH"	&	essround==	1	&	nace_both==	24

replace	tradexp=	1.129878319	if	cntry==	"CH"	&	essround==	1	&	nace_both==	25

replace	tradexp=	0.645449885	if	cntry==	"CH"	&	essround==	1	&	nace_both==	26

replace	tradexp=	3.360697564	if	cntry==	"CH"	&	essround==	1	&	nace_both==	27

replace	tradexp=	0.511244872	if	cntry==	"CH"	&	essround==	1	&	nace_both==	28

replace	tradexp=	1.131866217	if	cntry==	"CH"	&	essround==	1	&	nace_both==	29

replace	tradexp=	5.548413876	if	cntry==	"CH"	&	essround==	1	&	nace_both==	30

replace	tradexp=	0.845936969	if	cntry==	"CH"	&	essround==	1	&	nace_both==	31

replace	tradexp=	0.960887736	if	cntry==	"CH"	&	essround==	1	&	nace_both==	32

replace	tradexp=	0.985986488	if	cntry==	"CH"	&	essround==	1	&	nace_both==	33

replace	tradexp=	8.837404326	if	cntry==	"CH"	&	essround==	1	&	nace_both==	34

replace	tradexp=	1.469742933	if	cntry==	"CH"	&	essround==	1	&	nace_both==	35

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	1	&	nace_both==	36

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	1	&	nace_both==	37

replace	tradexp=	2.71455E-05	if	cntry==	"CH"	&	essround==	1	&	nace_both==	40

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	1	&	nace_both==	41

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	1	&	nace_both==	45

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	1	&	nace_both==	50

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	1	&	nace_both==	51

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	1	&	nace_both==	52

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	1	&	nace_both==	55

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	1	&	nace_both==	60

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	1	&	nace_both==	61

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	1	&	nace_both==	62

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	1	&	nace_both==	63

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	1	&	nace_both==	64

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	1	&	nace_both==	65

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	1	&	nace_both==	66

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	1	&	nace_both==	67

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	1	&	nace_both==	70

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	1	&	nace_both==	71

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	1	&	nace_both==	72

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	1	&	nace_both==	73

replace	tradexp=	0.000924868	if	cntry==	"CH"	&	essround==	1	&	nace_both==	74

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	1	&	nace_both==	75

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	1	&	nace_both==	80

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	1	&	nace_both==	85

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	1	&	nace_both==	90

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	1	&	nace_both==	91

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	1	&	nace_both==	92

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	1	&	nace_both==	93

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	1	&	nace_both==	95

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	1	&	nace_both==	98

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	1	&	nace_both==	99

replace	tradexp=	0.249227366	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	1

replace	tradexp=	0.155450807	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	2

replace	tradexp=	0.701905769	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	5

replace	tradexp=	0.239805763	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	10

replace	tradexp=	24.87243894	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	11

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	12

replace	tradexp=	7642.86529	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	13

replace	tradexp=	0.430134206	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	14

replace	tradexp=	0.266624503	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	15

replace	tradexp=	0.225778391	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	16

replace	tradexp=	1.433170781	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	17

replace	tradexp=	1.06417762	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	18

replace	tradexp=	2.142721205	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	19

replace	tradexp=	0.417783024	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	20

replace	tradexp=	1.19840651	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	21

replace	tradexp=	0.48530654	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	22

replace	tradexp=	0.897253529	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	23

replace	tradexp=	1.744566824	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	24

replace	tradexp=	1.130184303	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	25

replace	tradexp=	0.660974365	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	26

replace	tradexp=	1.100946956	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	27

replace	tradexp=	0.774866663	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	28

replace	tradexp=	1.631336419	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	29

replace	tradexp=	2.041683317	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	30

replace	tradexp=	1.273421715	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	31

replace	tradexp=	1.644224376	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	32

replace	tradexp=	1.324315836	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	33

replace	tradexp=	1.046502325	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	34

replace	tradexp=	0.937980147	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	35

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	36

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	37

replace	tradexp=	0.047269532	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	40

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	41

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	45

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	50

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	51

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	52

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	55

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	60

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	61

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	62

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	63

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	64

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	65

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	66

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	67

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	70

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	71

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	72

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	73

replace	tradexp=	0.002000366	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	74

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	75

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	80

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	85

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	90

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	91

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	92

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	93

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	95

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	98

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	1	&	nace_both==	99

replace	tradexp=	0.462257842	if	cntry==	"DE"	&	essround==	1	&	nace_both==	1

replace	tradexp=	0.254331273	if	cntry==	"DE"	&	essround==	1	&	nace_both==	2

replace	tradexp=	1.46182159	if	cntry==	"DE"	&	essround==	1	&	nace_both==	5

replace	tradexp=	0.433926098	if	cntry==	"DE"	&	essround==	1	&	nace_both==	10

replace	tradexp=	10.59603559	if	cntry==	"DE"	&	essround==	1	&	nace_both==	11

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	1	&	nace_both==	12

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	1	&	nace_both==	13

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	1	&	nace_both==	14

replace	tradexp=	0.403782538	if	cntry==	"DE"	&	essround==	1	&	nace_both==	15

replace	tradexp=	0.547739505	if	cntry==	"DE"	&	essround==	1	&	nace_both==	16

replace	tradexp=	1.987966714	if	cntry==	"DE"	&	essround==	1	&	nace_both==	17

replace	tradexp=	2.174090958	if	cntry==	"DE"	&	essround==	1	&	nace_both==	18

replace	tradexp=	2.577137491	if	cntry==	"DE"	&	essround==	1	&	nace_both==	19

replace	tradexp=	0.381189087	if	cntry==	"DE"	&	essround==	1	&	nace_both==	20

replace	tradexp=	0.879669717	if	cntry==	"DE"	&	essround==	1	&	nace_both==	21

replace	tradexp=	0.212477773	if	cntry==	"DE"	&	essround==	1	&	nace_both==	22

replace	tradexp=	0.472901052	if	cntry==	"DE"	&	essround==	1	&	nace_both==	23

replace	tradexp=	1.135243702	if	cntry==	"DE"	&	essround==	1	&	nace_both==	24

replace	tradexp=	0.683897006	if	cntry==	"DE"	&	essround==	1	&	nace_both==	25

replace	tradexp=	0.433163806	if	cntry==	"DE"	&	essround==	1	&	nace_both==	26

replace	tradexp=	0.864050926	if	cntry==	"DE"	&	essround==	1	&	nace_both==	27

replace	tradexp=	0.391554259	if	cntry==	"DE"	&	essround==	1	&	nace_both==	28

replace	tradexp=	0.859598085	if	cntry==	"DE"	&	essround==	1	&	nace_both==	29

replace	tradexp=	3.424806198	if	cntry==	"DE"	&	essround==	1	&	nace_both==	30

replace	tradexp=	0.701343517	if	cntry==	"DE"	&	essround==	1	&	nace_both==	31

replace	tradexp=	2.238955873	if	cntry==	"DE"	&	essround==	1	&	nace_both==	32

replace	tradexp=	1.23310792	if	cntry==	"DE"	&	essround==	1	&	nace_both==	33

replace	tradexp=	0.827932799	if	cntry==	"DE"	&	essround==	1	&	nace_both==	34

replace	tradexp=	1.817845922	if	cntry==	"DE"	&	essround==	1	&	nace_both==	35

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	1	&	nace_both==	36

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	1	&	nace_both==	37

replace	tradexp=	0.022901906	if	cntry==	"DE"	&	essround==	1	&	nace_both==	40

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	1	&	nace_both==	41

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	1	&	nace_both==	45

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	1	&	nace_both==	50

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	1	&	nace_both==	51

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	1	&	nace_both==	52

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	1	&	nace_both==	55

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	1	&	nace_both==	60

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	1	&	nace_both==	61

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	1	&	nace_both==	62

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	1	&	nace_both==	63

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	1	&	nace_both==	64

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	1	&	nace_both==	65

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	1	&	nace_both==	66

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	1	&	nace_both==	67

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	1	&	nace_both==	70

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	1	&	nace_both==	71

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	1	&	nace_both==	72

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	1	&	nace_both==	73

replace	tradexp=	0.000821949	if	cntry==	"DE"	&	essround==	1	&	nace_both==	74

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	1	&	nace_both==	75

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	1	&	nace_both==	80

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	1	&	nace_both==	85

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	1	&	nace_both==	90

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	1	&	nace_both==	91

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	1	&	nace_both==	92

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	1	&	nace_both==	93

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	1	&	nace_both==	95

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	1	&	nace_both==	98

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	1	&	nace_both==	99

replace	tradexp=	0.362407959	if	cntry==	"DK"	&	essround==	1	&	nace_both==	1

replace	tradexp=	0.463507067	if	cntry==	"DK"	&	essround==	1	&	nace_both==	2

replace	tradexp=	1.493521344	if	cntry==	"DK"	&	essround==	1	&	nace_both==	5

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	1	&	nace_both==	10

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	1	&	nace_both==	11

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	1	&	nace_both==	12

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	1	&	nace_both==	13

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	1	&	nace_both==	14

replace	tradexp=	0.925377828	if	cntry==	"DK"	&	essround==	1	&	nace_both==	15

replace	tradexp=	0.444256175	if	cntry==	"DK"	&	essround==	1	&	nace_both==	16

replace	tradexp=	3.046746044	if	cntry==	"DK"	&	essround==	1	&	nace_both==	17

replace	tradexp=	5.361340998	if	cntry==	"DK"	&	essround==	1	&	nace_both==	18

replace	tradexp=	10.06334636	if	cntry==	"DK"	&	essround==	1	&	nace_both==	19

replace	tradexp=	1.050238268	if	cntry==	"DK"	&	essround==	1	&	nace_both==	20

replace	tradexp=	1.486749948	if	cntry==	"DK"	&	essround==	1	&	nace_both==	21

replace	tradexp=	0.264331929	if	cntry==	"DK"	&	essround==	1	&	nace_both==	22

replace	tradexp=	0.93059455	if	cntry==	"DK"	&	essround==	1	&	nace_both==	23

replace	tradexp=	1.650519676	if	cntry==	"DK"	&	essround==	1	&	nace_both==	24

replace	tradexp=	1.198166994	if	cntry==	"DK"	&	essround==	1	&	nace_both==	25

replace	tradexp=	0.668507956	if	cntry==	"DK"	&	essround==	1	&	nace_both==	26

replace	tradexp=	3.031427562	if	cntry==	"DK"	&	essround==	1	&	nace_both==	27

replace	tradexp=	0.672514829	if	cntry==	"DK"	&	essround==	1	&	nace_both==	28

replace	tradexp=	1.349939455	if	cntry==	"DK"	&	essround==	1	&	nace_both==	29

replace	tradexp=	13.75941191	if	cntry==	"DK"	&	essround==	1	&	nace_both==	30

replace	tradexp=	1.110242879	if	cntry==	"DK"	&	essround==	1	&	nace_both==	31

replace	tradexp=	3.769625798	if	cntry==	"DK"	&	essround==	1	&	nace_both==	32

replace	tradexp=	1.580785919	if	cntry==	"DK"	&	essround==	1	&	nace_both==	33

replace	tradexp=	5.710109941	if	cntry==	"DK"	&	essround==	1	&	nace_both==	34

replace	tradexp=	2.568224461	if	cntry==	"DK"	&	essround==	1	&	nace_both==	35

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	1	&	nace_both==	36

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	1	&	nace_both==	37

replace	tradexp=	0.115912215	if	cntry==	"DK"	&	essround==	1	&	nace_both==	40

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	1	&	nace_both==	41

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	1	&	nace_both==	45

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	1	&	nace_both==	50

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	1	&	nace_both==	51

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	1	&	nace_both==	52

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	1	&	nace_both==	55

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	1	&	nace_both==	60

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	1	&	nace_both==	61

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	1	&	nace_both==	62

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	1	&	nace_both==	63

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	1	&	nace_both==	64

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	1	&	nace_both==	65

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	1	&	nace_both==	66

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	1	&	nace_both==	67

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	1	&	nace_both==	70

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	1	&	nace_both==	71

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	1	&	nace_both==	72

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	1	&	nace_both==	73

replace	tradexp=	0.000967583	if	cntry==	"DK"	&	essround==	1	&	nace_both==	74

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	1	&	nace_both==	75

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	1	&	nace_both==	80

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	1	&	nace_both==	85

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	1	&	nace_both==	90

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	1	&	nace_both==	91

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	1	&	nace_both==	92

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	1	&	nace_both==	93

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	1	&	nace_both==	95

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	1	&	nace_both==	98

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	1	&	nace_both==	99

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	1	&	nace_both==	1

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	1	&	nace_both==	2

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	1	&	nace_both==	5

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	1	&	nace_both==	10

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	1	&	nace_both==	11

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	1	&	nace_both==	12

replace	tradexp=	6.746619178	if	cntry==	"ES"	&	essround==	1	&	nace_both==	13

replace	tradexp=	0.287392976	if	cntry==	"ES"	&	essround==	1	&	nace_both==	14

replace	tradexp=	0.318752073	if	cntry==	"ES"	&	essround==	1	&	nace_both==	15

replace	tradexp=	0.78783775	if	cntry==	"ES"	&	essround==	1	&	nace_both==	16

replace	tradexp=	0.867637999	if	cntry==	"ES"	&	essround==	1	&	nace_both==	17

replace	tradexp=	0.76287476	if	cntry==	"ES"	&	essround==	1	&	nace_both==	18

replace	tradexp=	0.756923105	if	cntry==	"ES"	&	essround==	1	&	nace_both==	19

replace	tradexp=	0.285896886	if	cntry==	"ES"	&	essround==	1	&	nace_both==	20

replace	tradexp=	0.586116924	if	cntry==	"ES"	&	essround==	1	&	nace_both==	21

replace	tradexp=	0.147867837	if	cntry==	"ES"	&	essround==	1	&	nace_both==	22

replace	tradexp=	0.406235709	if	cntry==	"ES"	&	essround==	1	&	nace_both==	23

replace	tradexp=	1.046995643	if	cntry==	"ES"	&	essround==	1	&	nace_both==	24

replace	tradexp=	0.576801185	if	cntry==	"ES"	&	essround==	1	&	nace_both==	25

replace	tradexp=	0.257974209	if	cntry==	"ES"	&	essround==	1	&	nace_both==	26

replace	tradexp=	0.596487064	if	cntry==	"ES"	&	essround==	1	&	nace_both==	27

replace	tradexp=	0.254715917	if	cntry==	"ES"	&	essround==	1	&	nace_both==	28

replace	tradexp=	1.061570863	if	cntry==	"ES"	&	essround==	1	&	nace_both==	29

replace	tradexp=	4.163545971	if	cntry==	"ES"	&	essround==	1	&	nace_both==	30

replace	tradexp=	0.760750075	if	cntry==	"ES"	&	essround==	1	&	nace_both==	31

replace	tradexp=	1.865437545	if	cntry==	"ES"	&	essround==	1	&	nace_both==	32

replace	tradexp=	1.817948804	if	cntry==	"ES"	&	essround==	1	&	nace_both==	33

replace	tradexp=	1.218112455	if	cntry==	"ES"	&	essround==	1	&	nace_both==	34

replace	tradexp=	0.849957148	if	cntry==	"ES"	&	essround==	1	&	nace_both==	35

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	1	&	nace_both==	36

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	1	&	nace_both==	37

replace	tradexp=	0.013154446	if	cntry==	"ES"	&	essround==	1	&	nace_both==	40

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	1	&	nace_both==	41

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	1	&	nace_both==	45

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	1	&	nace_both==	50

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	1	&	nace_both==	51

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	1	&	nace_both==	52

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	1	&	nace_both==	55

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	1	&	nace_both==	60

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	1	&	nace_both==	61

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	1	&	nace_both==	62

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	1	&	nace_both==	63

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	1	&	nace_both==	64

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	1	&	nace_both==	65

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	1	&	nace_both==	66

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	1	&	nace_both==	67

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	1	&	nace_both==	70

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	1	&	nace_both==	71

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	1	&	nace_both==	72

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	1	&	nace_both==	73

replace	tradexp=	0.00028628	if	cntry==	"ES"	&	essround==	1	&	nace_both==	74

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	1	&	nace_both==	75

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	1	&	nace_both==	80

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	1	&	nace_both==	85

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	1	&	nace_both==	90

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	1	&	nace_both==	91

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	1	&	nace_both==	92

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	1	&	nace_both==	93

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	1	&	nace_both==	95

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	1	&	nace_both==	98

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	1	&	nace_both==	99

replace	tradexp=	0.259405336	if	cntry==	"FI"	&	essround==	1	&	nace_both==	1

replace	tradexp=	0.170889809	if	cntry==	"FI"	&	essround==	1	&	nace_both==	2

replace	tradexp=	0.333875234	if	cntry==	"FI"	&	essround==	1	&	nace_both==	5

replace	tradexp=	0.866955696	if	cntry==	"FI"	&	essround==	1	&	nace_both==	10

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	1	&	nace_both==	11

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	1	&	nace_both==	12

replace	tradexp=	5.84824711	if	cntry==	"FI"	&	essround==	1	&	nace_both==	13

replace	tradexp=	0.579129528	if	cntry==	"FI"	&	essround==	1	&	nace_both==	14

replace	tradexp=	0.279187185	if	cntry==	"FI"	&	essround==	1	&	nace_both==	15

replace	tradexp=	0.701079612	if	cntry==	"FI"	&	essround==	1	&	nace_both==	16

replace	tradexp=	1.636754445	if	cntry==	"FI"	&	essround==	1	&	nace_both==	17

replace	tradexp=	1.811228981	if	cntry==	"FI"	&	essround==	1	&	nace_both==	18

replace	tradexp=	1.733141471	if	cntry==	"FI"	&	essround==	1	&	nace_both==	19

replace	tradexp=	0.502618908	if	cntry==	"FI"	&	essround==	1	&	nace_both==	20

replace	tradexp=	0.714833978	if	cntry==	"FI"	&	essround==	1	&	nace_both==	21

replace	tradexp=	0.170811868	if	cntry==	"FI"	&	essround==	1	&	nace_both==	22

replace	tradexp=	0.626859033	if	cntry==	"FI"	&	essround==	1	&	nace_both==	23

replace	tradexp=	1.275104766	if	cntry==	"FI"	&	essround==	1	&	nace_both==	24

replace	tradexp=	0.745684635	if	cntry==	"FI"	&	essround==	1	&	nace_both==	25

replace	tradexp=	0.444064178	if	cntry==	"FI"	&	essround==	1	&	nace_both==	26

replace	tradexp=	0.893509708	if	cntry==	"FI"	&	essround==	1	&	nace_both==	27

replace	tradexp=	0.353890807	if	cntry==	"FI"	&	essround==	1	&	nace_both==	28

replace	tradexp=	0.809457439	if	cntry==	"FI"	&	essround==	1	&	nace_both==	29

replace	tradexp=	22.20260814	if	cntry==	"FI"	&	essround==	1	&	nace_both==	30

replace	tradexp=	1.499695531	if	cntry==	"FI"	&	essround==	1	&	nace_both==	31

replace	tradexp=	0.831851958	if	cntry==	"FI"	&	essround==	1	&	nace_both==	32

replace	tradexp=	1.104056113	if	cntry==	"FI"	&	essround==	1	&	nace_both==	33

replace	tradexp=	4.941258619	if	cntry==	"FI"	&	essround==	1	&	nace_both==	34

replace	tradexp=	0.807227554	if	cntry==	"FI"	&	essround==	1	&	nace_both==	35

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	1	&	nace_both==	36

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	1	&	nace_both==	37

replace	tradexp=	0.071685191	if	cntry==	"FI"	&	essround==	1	&	nace_both==	40

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	1	&	nace_both==	41

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	1	&	nace_both==	45

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	1	&	nace_both==	50

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	1	&	nace_both==	51

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	1	&	nace_both==	52

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	1	&	nace_both==	55

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	1	&	nace_both==	60

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	1	&	nace_both==	61

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	1	&	nace_both==	62

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	1	&	nace_both==	63

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	1	&	nace_both==	64

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	1	&	nace_both==	65

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	1	&	nace_both==	66

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	1	&	nace_both==	67

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	1	&	nace_both==	70

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	1	&	nace_both==	71

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	1	&	nace_both==	72

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	1	&	nace_both==	73

replace	tradexp=	0.001269069	if	cntry==	"FI"	&	essround==	1	&	nace_both==	74

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	1	&	nace_both==	75

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	1	&	nace_both==	80

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	1	&	nace_both==	85

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	1	&	nace_both==	90

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	1	&	nace_both==	91

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	1	&	nace_both==	92

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	1	&	nace_both==	93

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	1	&	nace_both==	95

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	1	&	nace_both==	98

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	1	&	nace_both==	99

replace	tradexp=	0.235790297	if	cntry==	"FR"	&	essround==	1	&	nace_both==	1

replace	tradexp=	0.088447046	if	cntry==	"FR"	&	essround==	1	&	nace_both==	2

replace	tradexp=	0.686530723	if	cntry==	"FR"	&	essround==	1	&	nace_both==	5

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	1	&	nace_both==	10

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	1	&	nace_both==	11

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	1	&	nace_both==	12

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	1	&	nace_both==	13

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	1	&	nace_both==	14

replace	tradexp=	0.414590313	if	cntry==	"FR"	&	essround==	1	&	nace_both==	15

replace	tradexp=	2.282278769	if	cntry==	"FR"	&	essround==	1	&	nace_both==	16

replace	tradexp=	1.174888057	if	cntry==	"FR"	&	essround==	1	&	nace_both==	17

replace	tradexp=	1.278723491	if	cntry==	"FR"	&	essround==	1	&	nace_both==	18

replace	tradexp=	2.442082869	if	cntry==	"FR"	&	essround==	1	&	nace_both==	19

replace	tradexp=	0.380615452	if	cntry==	"FR"	&	essround==	1	&	nace_both==	20

replace	tradexp=	0.752070403	if	cntry==	"FR"	&	essround==	1	&	nace_both==	21

replace	tradexp=	0.184856011	if	cntry==	"FR"	&	essround==	1	&	nace_both==	22

replace	tradexp=	0.402775069	if	cntry==	"FR"	&	essround==	1	&	nace_both==	23

replace	tradexp=	1.078456114	if	cntry==	"FR"	&	essround==	1	&	nace_both==	24

replace	tradexp=	0.608162614	if	cntry==	"FR"	&	essround==	1	&	nace_both==	25

replace	tradexp=	0.379968978	if	cntry==	"FR"	&	essround==	1	&	nace_both==	26

replace	tradexp=	0.916238629	if	cntry==	"FR"	&	essround==	1	&	nace_both==	27

replace	tradexp=	0.283136262	if	cntry==	"FR"	&	essround==	1	&	nace_both==	28

replace	tradexp=	1.093524598	if	cntry==	"FR"	&	essround==	1	&	nace_both==	29

replace	tradexp=	3.318238092	if	cntry==	"FR"	&	essround==	1	&	nace_both==	30

replace	tradexp=	1.019505042	if	cntry==	"FR"	&	essround==	1	&	nace_both==	31

replace	tradexp=	1.22945875	if	cntry==	"FR"	&	essround==	1	&	nace_both==	32

replace	tradexp=	0.885053995	if	cntry==	"FR"	&	essround==	1	&	nace_both==	33

replace	tradexp=	0.903920013	if	cntry==	"FR"	&	essround==	1	&	nace_both==	34

replace	tradexp=	0.918630246	if	cntry==	"FR"	&	essround==	1	&	nace_both==	35

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	1	&	nace_both==	36

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	1	&	nace_both==	37

replace	tradexp=	0.06943937	if	cntry==	"FR"	&	essround==	1	&	nace_both==	40

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	1	&	nace_both==	41

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	1	&	nace_both==	45

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	1	&	nace_both==	50

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	1	&	nace_both==	51

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	1	&	nace_both==	52

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	1	&	nace_both==	55

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	1	&	nace_both==	60

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	1	&	nace_both==	61

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	1	&	nace_both==	62

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	1	&	nace_both==	63

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	1	&	nace_both==	64

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	1	&	nace_both==	65

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	1	&	nace_both==	66

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	1	&	nace_both==	67

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	1	&	nace_both==	70

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	1	&	nace_both==	71

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	1	&	nace_both==	72

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	1	&	nace_both==	73

replace	tradexp=	0.000516983	if	cntry==	"FR"	&	essround==	1	&	nace_both==	74

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	1	&	nace_both==	75

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	1	&	nace_both==	80

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	1	&	nace_both==	85

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	1	&	nace_both==	90

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	1	&	nace_both==	91

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	1	&	nace_both==	92

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	1	&	nace_both==	93

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	1	&	nace_both==	95

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	1	&	nace_both==	98

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	1	&	nace_both==	99

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	1

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	2

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	5

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	10

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	11

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	12

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	13

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	14

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	15

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	16

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	17

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	18

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	19

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	20

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	21

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	22

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	23

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	24

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	25

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	26

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	27

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	28

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	29

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	30

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	31

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	32

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	33

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	34

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	35

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	36

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	37

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	40

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	41

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	45

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	50

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	51

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	52

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	55

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	60

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	61

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	62

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	63

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	64

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	65

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	66

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	67

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	70

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	71

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	72

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	73

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	74

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	75

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	80

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	85

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	90

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	91

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	92

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	93

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	95

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	98

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	1	&	nace_both==	99

replace	tradexp=	0.19260709	if	cntry==	"GR"	&	essround==	1	&	nace_both==	1

replace	tradexp=	0.39286526	if	cntry==	"GR"	&	essround==	1	&	nace_both==	2

replace	tradexp=	0.273379487	if	cntry==	"GR"	&	essround==	1	&	nace_both==	5

replace	tradexp=	0.042907789	if	cntry==	"GR"	&	essround==	1	&	nace_both==	10

replace	tradexp=	104.7164351	if	cntry==	"GR"	&	essround==	1	&	nace_both==	11

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	1	&	nace_both==	12

replace	tradexp=	0.108634311	if	cntry==	"GR"	&	essround==	1	&	nace_both==	13

replace	tradexp=	0.290115046	if	cntry==	"GR"	&	essround==	1	&	nace_both==	14

replace	tradexp=	0.325198244	if	cntry==	"GR"	&	essround==	1	&	nace_both==	15

replace	tradexp=	0.8033177	if	cntry==	"GR"	&	essround==	1	&	nace_both==	16

replace	tradexp=	1.023551983	if	cntry==	"GR"	&	essround==	1	&	nace_both==	17

replace	tradexp=	0.767814202	if	cntry==	"GR"	&	essround==	1	&	nace_both==	18

replace	tradexp=	1.252927552	if	cntry==	"GR"	&	essround==	1	&	nace_both==	19

replace	tradexp=	0.446094662	if	cntry==	"GR"	&	essround==	1	&	nace_both==	20

replace	tradexp=	0.677912579	if	cntry==	"GR"	&	essround==	1	&	nace_both==	21

replace	tradexp=	0.154694483	if	cntry==	"GR"	&	essround==	1	&	nace_both==	22

replace	tradexp=	0.291011971	if	cntry==	"GR"	&	essround==	1	&	nace_both==	23

replace	tradexp=	1.646149866	if	cntry==	"GR"	&	essround==	1	&	nace_both==	24

replace	tradexp=	0.8075507	if	cntry==	"GR"	&	essround==	1	&	nace_both==	25

replace	tradexp=	0.204041284	if	cntry==	"GR"	&	essround==	1	&	nace_both==	26

replace	tradexp=	0.815968094	if	cntry==	"GR"	&	essround==	1	&	nace_both==	27

replace	tradexp=	0.494348025	if	cntry==	"GR"	&	essround==	1	&	nace_both==	28

replace	tradexp=	1.999568245	if	cntry==	"GR"	&	essround==	1	&	nace_both==	29

replace	tradexp=	73.23070475	if	cntry==	"GR"	&	essround==	1	&	nace_both==	30

replace	tradexp=	1.110315563	if	cntry==	"GR"	&	essround==	1	&	nace_both==	31

replace	tradexp=	1.543616323	if	cntry==	"GR"	&	essround==	1	&	nace_both==	32

replace	tradexp=	11.56063382	if	cntry==	"GR"	&	essround==	1	&	nace_both==	33

replace	tradexp=	7.702125978	if	cntry==	"GR"	&	essround==	1	&	nace_both==	34

replace	tradexp=	3.059501027	if	cntry==	"GR"	&	essround==	1	&	nace_both==	35

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	1	&	nace_both==	36

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	1	&	nace_both==	37

replace	tradexp=	0.023670344	if	cntry==	"GR"	&	essround==	1	&	nace_both==	40

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	1	&	nace_both==	41

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	1	&	nace_both==	45

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	1	&	nace_both==	50

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	1	&	nace_both==	51

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	1	&	nace_both==	52

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	1	&	nace_both==	55

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	1	&	nace_both==	60

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	1	&	nace_both==	61

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	1	&	nace_both==	62

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	1	&	nace_both==	63

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	1	&	nace_both==	64

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	1	&	nace_both==	65

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	1	&	nace_both==	66

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	1	&	nace_both==	67

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	1	&	nace_both==	70

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	1	&	nace_both==	71

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	1	&	nace_both==	72

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	1	&	nace_both==	73

replace	tradexp=	0.000131689	if	cntry==	"GR"	&	essround==	1	&	nace_both==	74

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	1	&	nace_both==	75

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	1	&	nace_both==	80

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	1	&	nace_both==	85

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	1	&	nace_both==	90

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	1	&	nace_both==	91

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	1	&	nace_both==	92

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	1	&	nace_both==	93

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	1	&	nace_both==	95

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	1	&	nace_both==	98

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	1	&	nace_both==	99

replace	tradexp=	0.183298473	if	cntry==	"HU"	&	essround==	1	&	nace_both==	1

replace	tradexp=	0.28424424	if	cntry==	"HU"	&	essround==	1	&	nace_both==	2

replace	tradexp=	0.218300723	if	cntry==	"HU"	&	essround==	1	&	nace_both==	5

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	1	&	nace_both==	10

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	1	&	nace_both==	11

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	1	&	nace_both==	12

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	1	&	nace_both==	13

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	1	&	nace_both==	14

replace	tradexp=	0.341356703	if	cntry==	"HU"	&	essround==	1	&	nace_both==	15

replace	tradexp=	0.036406599	if	cntry==	"HU"	&	essround==	1	&	nace_both==	16

replace	tradexp=	2.289601552	if	cntry==	"HU"	&	essround==	1	&	nace_both==	17

replace	tradexp=	0.994194668	if	cntry==	"HU"	&	essround==	1	&	nace_both==	18

replace	tradexp=	1.99067308	if	cntry==	"HU"	&	essround==	1	&	nace_both==	19

replace	tradexp=	0.881282369	if	cntry==	"HU"	&	essround==	1	&	nace_both==	20

replace	tradexp=	1.479495741	if	cntry==	"HU"	&	essround==	1	&	nace_both==	21

replace	tradexp=	0.205973622	if	cntry==	"HU"	&	essround==	1	&	nace_both==	22

replace	tradexp=	0.419002299	if	cntry==	"HU"	&	essround==	1	&	nace_both==	23

replace	tradexp=	1.632784214	if	cntry==	"HU"	&	essround==	1	&	nace_both==	24

replace	tradexp=	1.207368129	if	cntry==	"HU"	&	essround==	1	&	nace_both==	25

replace	tradexp=	0.694568053	if	cntry==	"HU"	&	essround==	1	&	nace_both==	26

replace	tradexp=	1.379087836	if	cntry==	"HU"	&	essround==	1	&	nace_both==	27

replace	tradexp=	0.924735257	if	cntry==	"HU"	&	essround==	1	&	nace_both==	28

replace	tradexp=	2.138165929	if	cntry==	"HU"	&	essround==	1	&	nace_both==	29

replace	tradexp=	2.613121978	if	cntry==	"HU"	&	essround==	1	&	nace_both==	30

replace	tradexp=	1.051920736	if	cntry==	"HU"	&	essround==	1	&	nace_both==	31

replace	tradexp=	2.116689836	if	cntry==	"HU"	&	essround==	1	&	nace_both==	32

replace	tradexp=	2.352249373	if	cntry==	"HU"	&	essround==	1	&	nace_both==	33

replace	tradexp=	1.640381308	if	cntry==	"HU"	&	essround==	1	&	nace_both==	34

replace	tradexp=	1.062262665	if	cntry==	"HU"	&	essround==	1	&	nace_both==	35

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	1	&	nace_both==	36

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	1	&	nace_both==	37

replace	tradexp=	0.041421646	if	cntry==	"HU"	&	essround==	1	&	nace_both==	40

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	1	&	nace_both==	41

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	1	&	nace_both==	45

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	1	&	nace_both==	50

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	1	&	nace_both==	51

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	1	&	nace_both==	52

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	1	&	nace_both==	55

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	1	&	nace_both==	60

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	1	&	nace_both==	61

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	1	&	nace_both==	62

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	1	&	nace_both==	63

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	1	&	nace_both==	64

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	1	&	nace_both==	65

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	1	&	nace_both==	66

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	1	&	nace_both==	67

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	1	&	nace_both==	70

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	1	&	nace_both==	71

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	1	&	nace_both==	72

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	1	&	nace_both==	73

replace	tradexp=	0.000514714	if	cntry==	"HU"	&	essround==	1	&	nace_both==	74

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	1	&	nace_both==	75

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	1	&	nace_both==	80

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	1	&	nace_both==	85

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	1	&	nace_both==	90

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	1	&	nace_both==	91

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	1	&	nace_both==	92

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	1	&	nace_both==	93

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	1	&	nace_both==	95

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	1	&	nace_both==	98

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	1	&	nace_both==	99

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	1

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	2

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	5

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	10

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	11

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	12

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	13

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	14

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	15

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	16

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	17

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	18

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	19

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	20

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	21

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	22

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	23

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	24

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	25

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	26

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	27

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	28

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	29

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	30

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	31

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	32

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	33

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	34

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	35

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	36

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	37

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	40

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	41

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	45

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	50

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	51

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	52

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	55

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	60

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	61

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	62

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	63

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	64

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	65

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	66

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	67

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	70

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	71

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	72

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	73

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	74

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	75

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	80

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	85

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	90

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	91

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	92

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	93

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	95

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	98

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	1	&	nace_both==	99

replace	tradexp=	0.184406708	if	cntry==	"IS"	&	essround==	1	&	nace_both==	1

replace	tradexp=	0.420847067	if	cntry==	"IS"	&	essround==	1	&	nace_both==	2

replace	tradexp=	0.072797579	if	cntry==	"IS"	&	essround==	1	&	nace_both==	5

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	1	&	nace_both==	10

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	1	&	nace_both==	11

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	1	&	nace_both==	12

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	1	&	nace_both==	13

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	1	&	nace_both==	14

replace	tradexp=	0.954833629	if	cntry==	"IS"	&	essround==	1	&	nace_both==	15

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	1	&	nace_both==	16

replace	tradexp=	1.424679206	if	cntry==	"IS"	&	essround==	1	&	nace_both==	17

replace	tradexp=	3.752217704	if	cntry==	"IS"	&	essround==	1	&	nace_both==	18

replace	tradexp=	13.37947538	if	cntry==	"IS"	&	essround==	1	&	nace_both==	19

replace	tradexp=	1.126674744	if	cntry==	"IS"	&	essround==	1	&	nace_both==	20

replace	tradexp=	2.24987926	if	cntry==	"IS"	&	essround==	1	&	nace_both==	21

replace	tradexp=	0.165850184	if	cntry==	"IS"	&	essround==	1	&	nace_both==	22

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	1	&	nace_both==	23

replace	tradexp=	2.446329831	if	cntry==	"IS"	&	essround==	1	&	nace_both==	24

replace	tradexp=	1.264035509	if	cntry==	"IS"	&	essround==	1	&	nace_both==	25

replace	tradexp=	0.307283141	if	cntry==	"IS"	&	essround==	1	&	nace_both==	26

replace	tradexp=	1.329289483	if	cntry==	"IS"	&	essround==	1	&	nace_both==	27

replace	tradexp=	0.673803986	if	cntry==	"IS"	&	essround==	1	&	nace_both==	28

replace	tradexp=	2.138191001	if	cntry==	"IS"	&	essround==	1	&	nace_both==	29

replace	tradexp=	703.1591078	if	cntry==	"IS"	&	essround==	1	&	nace_both==	30

replace	tradexp=	5.682900974	if	cntry==	"IS"	&	essround==	1	&	nace_both==	31

replace	tradexp=	33.67735143	if	cntry==	"IS"	&	essround==	1	&	nace_both==	32

replace	tradexp=	2.325799698	if	cntry==	"IS"	&	essround==	1	&	nace_both==	33

replace	tradexp=	21.1259918	if	cntry==	"IS"	&	essround==	1	&	nace_both==	34

replace	tradexp=	1.895041942	if	cntry==	"IS"	&	essround==	1	&	nace_both==	35

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	1	&	nace_both==	36

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	1	&	nace_both==	37

replace	tradexp=	4.54789E-05	if	cntry==	"IS"	&	essround==	1	&	nace_both==	40

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	1	&	nace_both==	41

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	1	&	nace_both==	45

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	1	&	nace_both==	50

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	1	&	nace_both==	51

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	1	&	nace_both==	52

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	1	&	nace_both==	55

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	1	&	nace_both==	60

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	1	&	nace_both==	61

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	1	&	nace_both==	62

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	1	&	nace_both==	63

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	1	&	nace_both==	64

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	1	&	nace_both==	65

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	1	&	nace_both==	66

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	1	&	nace_both==	67

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	1	&	nace_both==	70

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	1	&	nace_both==	71

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	1	&	nace_both==	72

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	1	&	nace_both==	73

replace	tradexp=	0.000134557	if	cntry==	"IS"	&	essround==	1	&	nace_both==	74

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	1	&	nace_both==	75

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	1	&	nace_both==	80

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	1	&	nace_both==	85

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	1	&	nace_both==	90

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	1	&	nace_both==	91

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	1	&	nace_both==	92

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	1	&	nace_both==	93

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	1	&	nace_both==	95

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	1	&	nace_both==	98

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	1	&	nace_both==	99

replace	tradexp=	0.252667548	if	cntry==	"IT"	&	essround==	1	&	nace_both==	1

replace	tradexp=	1.3731585	if	cntry==	"IT"	&	essround==	1	&	nace_both==	2

replace	tradexp=	0.403151391	if	cntry==	"IT"	&	essround==	1	&	nace_both==	5

replace	tradexp=	63.91055666	if	cntry==	"IT"	&	essround==	1	&	nace_both==	10

replace	tradexp=	4.199867591	if	cntry==	"IT"	&	essround==	1	&	nace_both==	11

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	1	&	nace_both==	12

replace	tradexp=	43.90179478	if	cntry==	"IT"	&	essround==	1	&	nace_both==	13

replace	tradexp=	0.311543689	if	cntry==	"IT"	&	essround==	1	&	nace_both==	14

replace	tradexp=	0.313592413	if	cntry==	"IT"	&	essround==	1	&	nace_both==	15

replace	tradexp=	0.667644325	if	cntry==	"IT"	&	essround==	1	&	nace_both==	16

replace	tradexp=	0.56546082	if	cntry==	"IT"	&	essround==	1	&	nace_both==	17

replace	tradexp=	0.544543184	if	cntry==	"IT"	&	essround==	1	&	nace_both==	18

replace	tradexp=	0.66550876	if	cntry==	"IT"	&	essround==	1	&	nace_both==	19

replace	tradexp=	0.24227205	if	cntry==	"IT"	&	essround==	1	&	nace_both==	20

replace	tradexp=	0.529715727	if	cntry==	"IT"	&	essround==	1	&	nace_both==	21

replace	tradexp=	0.137477167	if	cntry==	"IT"	&	essround==	1	&	nace_both==	22

replace	tradexp=	0.358368377	if	cntry==	"IT"	&	essround==	1	&	nace_both==	23

replace	tradexp=	0.859135875	if	cntry==	"IT"	&	essround==	1	&	nace_both==	24

replace	tradexp=	0.412730553	if	cntry==	"IT"	&	essround==	1	&	nace_both==	25

replace	tradexp=	0.296613384	if	cntry==	"IT"	&	essround==	1	&	nace_both==	26

replace	tradexp=	0.852250432	if	cntry==	"IT"	&	essround==	1	&	nace_both==	27

replace	tradexp=	0.187968754	if	cntry==	"IT"	&	essround==	1	&	nace_both==	28

replace	tradexp=	0.752362839	if	cntry==	"IT"	&	essround==	1	&	nace_both==	29

replace	tradexp=	2.012343417	if	cntry==	"IT"	&	essround==	1	&	nace_both==	30

replace	tradexp=	0.530241691	if	cntry==	"IT"	&	essround==	1	&	nace_both==	31

replace	tradexp=	1.11601398	if	cntry==	"IT"	&	essround==	1	&	nace_both==	32

replace	tradexp=	0.873880036	if	cntry==	"IT"	&	essround==	1	&	nace_both==	33

replace	tradexp=	1.262351244	if	cntry==	"IT"	&	essround==	1	&	nace_both==	34

replace	tradexp=	0.940181337	if	cntry==	"IT"	&	essround==	1	&	nace_both==	35

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	1	&	nace_both==	36

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	1	&	nace_both==	37

replace	tradexp=	0.035603211	if	cntry==	"IT"	&	essround==	1	&	nace_both==	40

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	1	&	nace_both==	41

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	1	&	nace_both==	45

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	1	&	nace_both==	50

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	1	&	nace_both==	51

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	1	&	nace_both==	52

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	1	&	nace_both==	55

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	1	&	nace_both==	60

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	1	&	nace_both==	61

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	1	&	nace_both==	62

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	1	&	nace_both==	63

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	1	&	nace_both==	64

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	1	&	nace_both==	65

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	1	&	nace_both==	66

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	1	&	nace_both==	67

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	1	&	nace_both==	70

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	1	&	nace_both==	71

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	1	&	nace_both==	72

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	1	&	nace_both==	73

replace	tradexp=	0.000264156	if	cntry==	"IT"	&	essround==	1	&	nace_both==	74

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	1	&	nace_both==	75

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	1	&	nace_both==	80

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	1	&	nace_both==	85

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	1	&	nace_both==	90

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	1	&	nace_both==	91

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	1	&	nace_both==	92

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	1	&	nace_both==	93

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	1	&	nace_both==	95

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	1	&	nace_both==	98

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	1	&	nace_both==	99

replace	tradexp=	1.330120193	if	cntry==	"LU"	&	essround==	1	&	nace_both==	1

replace	tradexp=	1.707121015	if	cntry==	"LU"	&	essround==	1	&	nace_both==	2

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	1	&	nace_both==	5

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	1	&	nace_both==	10

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	1	&	nace_both==	11

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	1	&	nace_both==	12

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	1	&	nace_both==	13

replace	tradexp=	0.837030285	if	cntry==	"LU"	&	essround==	1	&	nace_both==	14

replace	tradexp=	2.352690101	if	cntry==	"LU"	&	essround==	1	&	nace_both==	15

replace	tradexp=	3.063491383	if	cntry==	"LU"	&	essround==	1	&	nace_both==	16

replace	tradexp=	0.976289522	if	cntry==	"LU"	&	essround==	1	&	nace_both==	17

replace	tradexp=	122.8471696	if	cntry==	"LU"	&	essround==	1	&	nace_both==	18

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	1	&	nace_both==	19

replace	tradexp=	1.695676755	if	cntry==	"LU"	&	essround==	1	&	nace_both==	20

replace	tradexp=	3.46649295	if	cntry==	"LU"	&	essround==	1	&	nace_both==	21

replace	tradexp=	1.01779369	if	cntry==	"LU"	&	essround==	1	&	nace_both==	22

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	1	&	nace_both==	23

replace	tradexp=	4.228355425	if	cntry==	"LU"	&	essround==	1	&	nace_both==	24

replace	tradexp=	1.673809207	if	cntry==	"LU"	&	essround==	1	&	nace_both==	25

replace	tradexp=	1.093795117	if	cntry==	"LU"	&	essround==	1	&	nace_both==	26

replace	tradexp=	2.020762016	if	cntry==	"LU"	&	essround==	1	&	nace_both==	27

replace	tradexp=	0.652834278	if	cntry==	"LU"	&	essround==	1	&	nace_both==	28

replace	tradexp=	2.838981425	if	cntry==	"LU"	&	essround==	1	&	nace_both==	29

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	1	&	nace_both==	30

replace	tradexp=	12.88442402	if	cntry==	"LU"	&	essround==	1	&	nace_both==	31

replace	tradexp=	275.4420033	if	cntry==	"LU"	&	essround==	1	&	nace_both==	32

replace	tradexp=	1.627067984	if	cntry==	"LU"	&	essround==	1	&	nace_both==	33

replace	tradexp=	68.03783435	if	cntry==	"LU"	&	essround==	1	&	nace_both==	34

replace	tradexp=	124.895251	if	cntry==	"LU"	&	essround==	1	&	nace_both==	35

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	1	&	nace_both==	36

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	1	&	nace_both==	37

replace	tradexp=	0.070721948	if	cntry==	"LU"	&	essround==	1	&	nace_both==	40

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	1	&	nace_both==	41

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	1	&	nace_both==	45

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	1	&	nace_both==	50

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	1	&	nace_both==	51

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	1	&	nace_both==	52

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	1	&	nace_both==	55

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	1	&	nace_both==	60

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	1	&	nace_both==	61

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	1	&	nace_both==	62

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	1	&	nace_both==	63

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	1	&	nace_both==	64

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	1	&	nace_both==	65

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	1	&	nace_both==	66

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	1	&	nace_both==	67

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	1	&	nace_both==	70

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	1	&	nace_both==	71

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	1	&	nace_both==	72

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	1	&	nace_both==	73

replace	tradexp=	0.000763605	if	cntry==	"LU"	&	essround==	1	&	nace_both==	74

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	1	&	nace_both==	75

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	1	&	nace_both==	80

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	1	&	nace_both==	85

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	1	&	nace_both==	90

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	1	&	nace_both==	91

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	1	&	nace_both==	92

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	1	&	nace_both==	93

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	1	&	nace_both==	95

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	1	&	nace_both==	98

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	1	&	nace_both==	99

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	1	&	nace_both==	1

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	1	&	nace_both==	2

replace	tradexp=	1.356946238	if	cntry==	"NL"	&	essround==	1	&	nace_both==	5

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	1	&	nace_both==	10

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	1	&	nace_both==	11

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	1	&	nace_both==	12

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	1	&	nace_both==	13

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	1	&	nace_both==	14

replace	tradexp=	0.872742792	if	cntry==	"NL"	&	essround==	1	&	nace_both==	15

replace	tradexp=	0.763171771	if	cntry==	"NL"	&	essround==	1	&	nace_both==	16

replace	tradexp=	2.172966463	if	cntry==	"NL"	&	essround==	1	&	nace_both==	17

replace	tradexp=	8.038053887	if	cntry==	"NL"	&	essround==	1	&	nace_both==	18

replace	tradexp=	8.182260507	if	cntry==	"NL"	&	essround==	1	&	nace_both==	19

replace	tradexp=	0.915277523	if	cntry==	"NL"	&	essround==	1	&	nace_both==	20

replace	tradexp=	1.480844682	if	cntry==	"NL"	&	essround==	1	&	nace_both==	21

replace	tradexp=	0.242716185	if	cntry==	"NL"	&	essround==	1	&	nace_both==	22

replace	tradexp=	1.202092261	if	cntry==	"NL"	&	essround==	1	&	nace_both==	23

replace	tradexp=	1.548295229	if	cntry==	"NL"	&	essround==	1	&	nace_both==	24

replace	tradexp=	1.559349046	if	cntry==	"NL"	&	essround==	1	&	nace_both==	25

replace	tradexp=	0.541759614	if	cntry==	"NL"	&	essround==	1	&	nace_both==	26

replace	tradexp=	2.204565858	if	cntry==	"NL"	&	essround==	1	&	nace_both==	27

replace	tradexp=	0.502665316	if	cntry==	"NL"	&	essround==	1	&	nace_both==	28

replace	tradexp=	1.32617135	if	cntry==	"NL"	&	essround==	1	&	nace_both==	29

replace	tradexp=	24.97658704	if	cntry==	"NL"	&	essround==	1	&	nace_both==	30

replace	tradexp=	2.544271058	if	cntry==	"NL"	&	essround==	1	&	nace_both==	31

replace	tradexp=	1.682989461	if	cntry==	"NL"	&	essround==	1	&	nace_both==	32

replace	tradexp=	4.288519319	if	cntry==	"NL"	&	essround==	1	&	nace_both==	33

replace	tradexp=	2.819092396	if	cntry==	"NL"	&	essround==	1	&	nace_both==	34

replace	tradexp=	1.062728547	if	cntry==	"NL"	&	essround==	1	&	nace_both==	35

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	1	&	nace_both==	36

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	1	&	nace_both==	37

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	1	&	nace_both==	40

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	1	&	nace_both==	41

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	1	&	nace_both==	45

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	1	&	nace_both==	50

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	1	&	nace_both==	51

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	1	&	nace_both==	52

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	1	&	nace_both==	55

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	1	&	nace_both==	60

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	1	&	nace_both==	61

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	1	&	nace_both==	62

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	1	&	nace_both==	63

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	1	&	nace_both==	64

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	1	&	nace_both==	65

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	1	&	nace_both==	66

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	1	&	nace_both==	67

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	1	&	nace_both==	70

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	1	&	nace_both==	71

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	1	&	nace_both==	72

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	1	&	nace_both==	73

replace	tradexp=	0.000203031	if	cntry==	"NL"	&	essround==	1	&	nace_both==	74

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	1	&	nace_both==	75

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	1	&	nace_both==	80

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	1	&	nace_both==	85

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	1	&	nace_both==	90

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	1	&	nace_both==	91

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	1	&	nace_both==	92

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	1	&	nace_both==	93

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	1	&	nace_both==	95

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	1	&	nace_both==	98

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	1	&	nace_both==	99

replace	tradexp=	0.272880056	if	cntry==	"NO"	&	essround==	1	&	nace_both==	1

replace	tradexp=	0.188416178	if	cntry==	"NO"	&	essround==	1	&	nace_both==	2

replace	tradexp=	0.422350837	if	cntry==	"NO"	&	essround==	1	&	nace_both==	5

replace	tradexp=	0.658863022	if	cntry==	"NO"	&	essround==	1	&	nace_both==	10

replace	tradexp=	0.839803559	if	cntry==	"NO"	&	essround==	1	&	nace_both==	11

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	1	&	nace_both==	12

replace	tradexp=	1.506745826	if	cntry==	"NO"	&	essround==	1	&	nace_both==	13

replace	tradexp=	0.591237846	if	cntry==	"NO"	&	essround==	1	&	nace_both==	14

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	1	&	nace_both==	15

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	1	&	nace_both==	16

replace	tradexp=	2.139760499	if	cntry==	"NO"	&	essround==	1	&	nace_both==	17

replace	tradexp=	6.733396976	if	cntry==	"NO"	&	essround==	1	&	nace_both==	18

replace	tradexp=	8.206761563	if	cntry==	"NO"	&	essround==	1	&	nace_both==	19

replace	tradexp=	0.432471244	if	cntry==	"NO"	&	essround==	1	&	nace_both==	20

replace	tradexp=	1.031990411	if	cntry==	"NO"	&	essround==	1	&	nace_both==	21

replace	tradexp=	0.156905844	if	cntry==	"NO"	&	essround==	1	&	nace_both==	22

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	1	&	nace_both==	23

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	1	&	nace_both==	24

replace	tradexp=	1.486686605	if	cntry==	"NO"	&	essround==	1	&	nace_both==	25

replace	tradexp=	0.409481756	if	cntry==	"NO"	&	essround==	1	&	nace_both==	26

replace	tradexp=	1.348360286	if	cntry==	"NO"	&	essround==	1	&	nace_both==	27

replace	tradexp=	0.650692815	if	cntry==	"NO"	&	essround==	1	&	nace_both==	28

replace	tradexp=	1.398617356	if	cntry==	"NO"	&	essround==	1	&	nace_both==	29

replace	tradexp=	19.41670313	if	cntry==	"NO"	&	essround==	1	&	nace_both==	30

replace	tradexp=	1.472115496	if	cntry==	"NO"	&	essround==	1	&	nace_both==	31

replace	tradexp=	1.802481652	if	cntry==	"NO"	&	essround==	1	&	nace_both==	32

replace	tradexp=	1.300304108	if	cntry==	"NO"	&	essround==	1	&	nace_both==	33

replace	tradexp=	4.287337068	if	cntry==	"NO"	&	essround==	1	&	nace_both==	34

replace	tradexp=	0.705697159	if	cntry==	"NO"	&	essround==	1	&	nace_both==	35

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	1	&	nace_both==	36

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	1	&	nace_both==	37

replace	tradexp=	0.092360412	if	cntry==	"NO"	&	essround==	1	&	nace_both==	40

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	1	&	nace_both==	41

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	1	&	nace_both==	45

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	1	&	nace_both==	50

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	1	&	nace_both==	51

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	1	&	nace_both==	52

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	1	&	nace_both==	55

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	1	&	nace_both==	60

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	1	&	nace_both==	61

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	1	&	nace_both==	62

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	1	&	nace_both==	63

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	1	&	nace_both==	64

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	1	&	nace_both==	65

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	1	&	nace_both==	66

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	1	&	nace_both==	67

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	1	&	nace_both==	70

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	1	&	nace_both==	71

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	1	&	nace_both==	72

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	1	&	nace_both==	73

replace	tradexp=	0.000933766	if	cntry==	"NO"	&	essround==	1	&	nace_both==	74

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	1	&	nace_both==	75

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	1	&	nace_both==	80

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	1	&	nace_both==	85

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	1	&	nace_both==	90

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	1	&	nace_both==	91

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	1	&	nace_both==	92

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	1	&	nace_both==	93

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	1	&	nace_both==	95

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	1	&	nace_both==	98

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	1	&	nace_both==	99

replace	tradexp=	1.151098532	if	cntry==	"PL"	&	essround==	1	&	nace_both==	1

replace	tradexp=	3.58535569	if	cntry==	"PL"	&	essround==	1	&	nace_both==	2

replace	tradexp=	0.455459981	if	cntry==	"PL"	&	essround==	1	&	nace_both==	5

replace	tradexp=	18.09609413	if	cntry==	"PL"	&	essround==	1	&	nace_both==	10

replace	tradexp=	0.033178598	if	cntry==	"PL"	&	essround==	1	&	nace_both==	11

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	1	&	nace_both==	12

replace	tradexp=	0.375632361	if	cntry==	"PL"	&	essround==	1	&	nace_both==	13

replace	tradexp=	0.77087981	if	cntry==	"PL"	&	essround==	1	&	nace_both==	14

replace	tradexp=	3.107552853	if	cntry==	"PL"	&	essround==	1	&	nace_both==	15

replace	tradexp=	15.15912638	if	cntry==	"PL"	&	essround==	1	&	nace_both==	16

replace	tradexp=	0.961216825	if	cntry==	"PL"	&	essround==	1	&	nace_both==	17

replace	tradexp=	5.829980593	if	cntry==	"PL"	&	essround==	1	&	nace_both==	18

replace	tradexp=	1.316658829	if	cntry==	"PL"	&	essround==	1	&	nace_both==	19

replace	tradexp=	6.827955688	if	cntry==	"PL"	&	essround==	1	&	nace_both==	20

replace	tradexp=	1.716034329	if	cntry==	"PL"	&	essround==	1	&	nace_both==	21

replace	tradexp=	2.244728885	if	cntry==	"PL"	&	essround==	1	&	nace_both==	22

replace	tradexp=	2.71343639	if	cntry==	"PL"	&	essround==	1	&	nace_both==	23

replace	tradexp=	0.812208624	if	cntry==	"PL"	&	essround==	1	&	nace_both==	24

replace	tradexp=	1.825720353	if	cntry==	"PL"	&	essround==	1	&	nace_both==	25

replace	tradexp=	2.250713829	if	cntry==	"PL"	&	essround==	1	&	nace_both==	26

replace	tradexp=	2.492736442	if	cntry==	"PL"	&	essround==	1	&	nace_both==	27

replace	tradexp=	2.680487164	if	cntry==	"PL"	&	essround==	1	&	nace_both==	28

replace	tradexp=	1.237202154	if	cntry==	"PL"	&	essround==	1	&	nace_both==	29

replace	tradexp=	0.201782229	if	cntry==	"PL"	&	essround==	1	&	nace_both==	30

replace	tradexp=	2.879171958	if	cntry==	"PL"	&	essround==	1	&	nace_both==	31

replace	tradexp=	1.33843319	if	cntry==	"PL"	&	essround==	1	&	nace_both==	32

replace	tradexp=	0.910058582	if	cntry==	"PL"	&	essround==	1	&	nace_both==	33

replace	tradexp=	2.914542166	if	cntry==	"PL"	&	essround==	1	&	nace_both==	34

replace	tradexp=	3.153544635	if	cntry==	"PL"	&	essround==	1	&	nace_both==	35

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	1	&	nace_both==	36

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	1	&	nace_both==	37

replace	tradexp=	7.506837412	if	cntry==	"PL"	&	essround==	1	&	nace_both==	40

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	1	&	nace_both==	41

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	1	&	nace_both==	45

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	1	&	nace_both==	50

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	1	&	nace_both==	51

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	1	&	nace_both==	52

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	1	&	nace_both==	55

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	1	&	nace_both==	60

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	1	&	nace_both==	61

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	1	&	nace_both==	62

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	1	&	nace_both==	63

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	1	&	nace_both==	64

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	1	&	nace_both==	65

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	1	&	nace_both==	66

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	1	&	nace_both==	67

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	1	&	nace_both==	70

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	1	&	nace_both==	71

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	1	&	nace_both==	72

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	1	&	nace_both==	73

replace	tradexp=	0.329584343	if	cntry==	"PL"	&	essround==	1	&	nace_both==	74

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	1	&	nace_both==	75

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	1	&	nace_both==	80

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	1	&	nace_both==	85

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	1	&	nace_both==	90

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	1	&	nace_both==	91

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	1	&	nace_both==	92

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	1	&	nace_both==	93

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	1	&	nace_both==	95

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	1	&	nace_both==	98

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	1	&	nace_both==	99

replace	tradexp=	0.337806685	if	cntry==	"PT"	&	essround==	1	&	nace_both==	1

replace	tradexp=	0.276072574	if	cntry==	"PT"	&	essround==	1	&	nace_both==	2

replace	tradexp=	0.432729542	if	cntry==	"PT"	&	essround==	1	&	nace_both==	5

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	1	&	nace_both==	10

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	1	&	nace_both==	11

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	1	&	nace_both==	12

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	1	&	nace_both==	13

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	1	&	nace_both==	14

replace	tradexp=	0.449641038	if	cntry==	"PT"	&	essround==	1	&	nace_both==	15

replace	tradexp=	0.377334184	if	cntry==	"PT"	&	essround==	1	&	nace_both==	16

replace	tradexp=	1.013981942	if	cntry==	"PT"	&	essround==	1	&	nace_both==	17

replace	tradexp=	0.580961839	if	cntry==	"PT"	&	essround==	1	&	nace_both==	18

replace	tradexp=	0.938295565	if	cntry==	"PT"	&	essround==	1	&	nace_both==	19

replace	tradexp=	0.527328865	if	cntry==	"PT"	&	essround==	1	&	nace_both==	20

replace	tradexp=	1.001639861	if	cntry==	"PT"	&	essround==	1	&	nace_both==	21

replace	tradexp=	0.17779495	if	cntry==	"PT"	&	essround==	1	&	nace_both==	22

replace	tradexp=	0.585949319	if	cntry==	"PT"	&	essround==	1	&	nace_both==	23

replace	tradexp=	1.625517912	if	cntry==	"PT"	&	essround==	1	&	nace_both==	24

replace	tradexp=	1.085798585	if	cntry==	"PT"	&	essround==	1	&	nace_both==	25

replace	tradexp=	0.292664242	if	cntry==	"PT"	&	essround==	1	&	nace_both==	26

replace	tradexp=	2.082489942	if	cntry==	"PT"	&	essround==	1	&	nace_both==	27

replace	tradexp=	0.477812748	if	cntry==	"PT"	&	essround==	1	&	nace_both==	28

replace	tradexp=	1.587899826	if	cntry==	"PT"	&	essround==	1	&	nace_both==	29

replace	tradexp=	9.919327197	if	cntry==	"PT"	&	essround==	1	&	nace_both==	30

replace	tradexp=	1.352212716	if	cntry==	"PT"	&	essround==	1	&	nace_both==	31

replace	tradexp=	1.756449104	if	cntry==	"PT"	&	essround==	1	&	nace_both==	32

replace	tradexp=	2.362676174	if	cntry==	"PT"	&	essround==	1	&	nace_both==	33

replace	tradexp=	2.049109088	if	cntry==	"PT"	&	essround==	1	&	nace_both==	34

replace	tradexp=	0.989944485	if	cntry==	"PT"	&	essround==	1	&	nace_both==	35

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	1	&	nace_both==	36

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	1	&	nace_both==	37

replace	tradexp=	0.012834972	if	cntry==	"PT"	&	essround==	1	&	nace_both==	40

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	1	&	nace_both==	41

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	1	&	nace_both==	45

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	1	&	nace_both==	50

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	1	&	nace_both==	51

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	1	&	nace_both==	52

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	1	&	nace_both==	55

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	1	&	nace_both==	60

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	1	&	nace_both==	61

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	1	&	nace_both==	62

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	1	&	nace_both==	63

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	1	&	nace_both==	64

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	1	&	nace_both==	65

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	1	&	nace_both==	66

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	1	&	nace_both==	67

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	1	&	nace_both==	70

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	1	&	nace_both==	71

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	1	&	nace_both==	72

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	1	&	nace_both==	73

replace	tradexp=	0.00024572	if	cntry==	"PT"	&	essround==	1	&	nace_both==	74

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	1	&	nace_both==	75

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	1	&	nace_both==	80

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	1	&	nace_both==	85

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	1	&	nace_both==	90

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	1	&	nace_both==	91

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	1	&	nace_both==	92

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	1	&	nace_both==	93

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	1	&	nace_both==	95

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	1	&	nace_both==	98

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	1	&	nace_both==	99

replace	tradexp=	0.364051611	if	cntry==	"SE"	&	essround==	1	&	nace_both==	1

replace	tradexp=	0.174075881	if	cntry==	"SE"	&	essround==	1	&	nace_both==	2

replace	tradexp=	3.629540174	if	cntry==	"SE"	&	essround==	1	&	nace_both==	5

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	1	&	nace_both==	10

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	1	&	nace_both==	11

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	1	&	nace_both==	12

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	1	&	nace_both==	13

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	1	&	nace_both==	14

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	1	&	nace_both==	15

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	1	&	nace_both==	16

replace	tradexp=	2.542460888	if	cntry==	"SE"	&	essround==	1	&	nace_both==	17

replace	tradexp=	6.052606909	if	cntry==	"SE"	&	essround==	1	&	nace_both==	18

replace	tradexp=	5.198225636	if	cntry==	"SE"	&	essround==	1	&	nace_both==	19

replace	tradexp=	0.515657012	if	cntry==	"SE"	&	essround==	1	&	nace_both==	20

replace	tradexp=	0.823207602	if	cntry==	"SE"	&	essround==	1	&	nace_both==	21

replace	tradexp=	0.251628542	if	cntry==	"SE"	&	essround==	1	&	nace_both==	22

replace	tradexp=	0.945189903	if	cntry==	"SE"	&	essround==	1	&	nace_both==	23

replace	tradexp=	1.213221297	if	cntry==	"SE"	&	essround==	1	&	nace_both==	24

replace	tradexp=	1.202111951	if	cntry==	"SE"	&	essround==	1	&	nace_both==	25

replace	tradexp=	0.58820057	if	cntry==	"SE"	&	essround==	1	&	nace_both==	26

replace	tradexp=	1.001836336	if	cntry==	"SE"	&	essround==	1	&	nace_both==	27

replace	tradexp=	0.494976752	if	cntry==	"SE"	&	essround==	1	&	nace_both==	28

replace	tradexp=	1.043888122	if	cntry==	"SE"	&	essround==	1	&	nace_both==	29

replace	tradexp=	6.802489702	if	cntry==	"SE"	&	essround==	1	&	nace_both==	30

replace	tradexp=	1.381613565	if	cntry==	"SE"	&	essround==	1	&	nace_both==	31

replace	tradexp=	1.149522378	if	cntry==	"SE"	&	essround==	1	&	nace_both==	32

replace	tradexp=	1.234430885	if	cntry==	"SE"	&	essround==	1	&	nace_both==	33

replace	tradexp=	0.836636219	if	cntry==	"SE"	&	essround==	1	&	nace_both==	34

replace	tradexp=	1.225975749	if	cntry==	"SE"	&	essround==	1	&	nace_both==	35

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	1	&	nace_both==	36

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	1	&	nace_both==	37

replace	tradexp=	0.073584116	if	cntry==	"SE"	&	essround==	1	&	nace_both==	40

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	1	&	nace_both==	41

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	1	&	nace_both==	45

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	1	&	nace_both==	50

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	1	&	nace_both==	51

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	1	&	nace_both==	52

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	1	&	nace_both==	55

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	1	&	nace_both==	60

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	1	&	nace_both==	61

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	1	&	nace_both==	62

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	1	&	nace_both==	63

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	1	&	nace_both==	64

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	1	&	nace_both==	65

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	1	&	nace_both==	66

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	1	&	nace_both==	67

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	1	&	nace_both==	70

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	1	&	nace_both==	71

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	1	&	nace_both==	72

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	1	&	nace_both==	73

replace	tradexp=	0.000445368	if	cntry==	"SE"	&	essround==	1	&	nace_both==	74

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	1	&	nace_both==	75

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	1	&	nace_both==	80

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	1	&	nace_both==	85

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	1	&	nace_both==	90

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	1	&	nace_both==	91

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	1	&	nace_both==	92

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	1	&	nace_both==	93

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	1	&	nace_both==	95

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	1	&	nace_both==	98

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	1	&	nace_both==	99

replace	tradexp=	0.189818537	if	cntry==	"SK"	&	essround==	1	&	nace_both==	1

replace	tradexp=	0.183642687	if	cntry==	"SK"	&	essround==	1	&	nace_both==	2

replace	tradexp=	1.760638787	if	cntry==	"SK"	&	essround==	1	&	nace_both==	5

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	1	&	nace_both==	10

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	1	&	nace_both==	11

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	1	&	nace_both==	12

replace	tradexp=	11.53209828	if	cntry==	"SK"	&	essround==	1	&	nace_both==	13

replace	tradexp=	1.84439641	if	cntry==	"SK"	&	essround==	1	&	nace_both==	14

replace	tradexp=	0.430178959	if	cntry==	"SK"	&	essround==	1	&	nace_both==	15

replace	tradexp=	0.998545845	if	cntry==	"SK"	&	essround==	1	&	nace_both==	16

replace	tradexp=	2.400556477	if	cntry==	"SK"	&	essround==	1	&	nace_both==	17

replace	tradexp=	1.414966369	if	cntry==	"SK"	&	essround==	1	&	nace_both==	18

replace	tradexp=	1.186470343	if	cntry==	"SK"	&	essround==	1	&	nace_both==	19

replace	tradexp=	0.67986392	if	cntry==	"SK"	&	essround==	1	&	nace_both==	20

replace	tradexp=	1.220837316	if	cntry==	"SK"	&	essround==	1	&	nace_both==	21

replace	tradexp=	0.502404742	if	cntry==	"SK"	&	essround==	1	&	nace_both==	22

replace	tradexp=	0.702565906	if	cntry==	"SK"	&	essround==	1	&	nace_both==	23

replace	tradexp=	2.132217349	if	cntry==	"SK"	&	essround==	1	&	nace_both==	24

replace	tradexp=	1.611233824	if	cntry==	"SK"	&	essround==	1	&	nace_both==	25

replace	tradexp=	0.80676802	if	cntry==	"SK"	&	essround==	1	&	nace_both==	26

replace	tradexp=	1.043219786	if	cntry==	"SK"	&	essround==	1	&	nace_both==	27

replace	tradexp=	1.163394602	if	cntry==	"SK"	&	essround==	1	&	nace_both==	28

replace	tradexp=	2.159068086	if	cntry==	"SK"	&	essround==	1	&	nace_both==	29

replace	tradexp=	4.319346988	if	cntry==	"SK"	&	essround==	1	&	nace_both==	30

replace	tradexp=	1.619382507	if	cntry==	"SK"	&	essround==	1	&	nace_both==	31

replace	tradexp=	2.546924989	if	cntry==	"SK"	&	essround==	1	&	nace_both==	32

replace	tradexp=	2.019600096	if	cntry==	"SK"	&	essround==	1	&	nace_both==	33

replace	tradexp=	1.799964716	if	cntry==	"SK"	&	essround==	1	&	nace_both==	34

replace	tradexp=	1.054903757	if	cntry==	"SK"	&	essround==	1	&	nace_both==	35

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	1	&	nace_both==	36

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	1	&	nace_both==	37

replace	tradexp=	0.033453114	if	cntry==	"SK"	&	essround==	1	&	nace_both==	40

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	1	&	nace_both==	41

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	1	&	nace_both==	45

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	1	&	nace_both==	50

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	1	&	nace_both==	51

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	1	&	nace_both==	52

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	1	&	nace_both==	55

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	1	&	nace_both==	60

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	1	&	nace_both==	61

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	1	&	nace_both==	62

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	1	&	nace_both==	63

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	1	&	nace_both==	64

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	1	&	nace_both==	65

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	1	&	nace_both==	66

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	1	&	nace_both==	67

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	1	&	nace_both==	70

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	1	&	nace_both==	71

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	1	&	nace_both==	72

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	1	&	nace_both==	73

replace	tradexp=	0.003202956	if	cntry==	"SK"	&	essround==	1	&	nace_both==	74

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	1	&	nace_both==	75

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	1	&	nace_both==	80

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	1	&	nace_both==	85

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	1	&	nace_both==	90

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	1	&	nace_both==	91

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	1	&	nace_both==	92

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	1	&	nace_both==	93

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	1	&	nace_both==	95

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	1	&	nace_both==	98

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	1	&	nace_both==	99

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	1

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	2

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	5

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	10

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	11

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	12

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	13

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	14

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	15

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	16

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	17

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	18

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	19

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	20

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	21

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	22

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	23

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	24

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	25

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	26

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	27

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	28

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	29

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	30

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	31

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	32

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	33

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	34

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	35

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	36

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	37

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	40

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	41

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	45

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	50

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	51

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	52

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	55

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	60

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	61

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	62

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	63

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	64

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	65

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	66

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	67

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	70

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	71

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	72

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	73

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	74

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	75

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	80

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	85

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	90

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	91

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	92

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	93

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	95

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	98

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	1	&	nace_both==	99


* Wave 2004
* ------------

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	2	&	nace_both==	1

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	2	&	nace_both==	2

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	2	&	nace_both==	5

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	2	&	nace_both==	10

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	2	&	nace_both==	11

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	2	&	nace_both==	12

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	2	&	nace_both==	13

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	2	&	nace_both==	14

replace	tradexp=	0.713602797	if	cntry==	"AT"	&	essround==	2	&	nace_both==	15

replace	tradexp=	1.142555964	if	cntry==	"AT"	&	essround==	2	&	nace_both==	16

replace	tradexp=	1.84846045	if	cntry==	"AT"	&	essround==	2	&	nace_both==	17

replace	tradexp=	3.596543124	if	cntry==	"AT"	&	essround==	2	&	nace_both==	18

replace	tradexp=	2.447208101	if	cntry==	"AT"	&	essround==	2	&	nace_both==	19

replace	tradexp=	0.57482782	if	cntry==	"AT"	&	essround==	2	&	nace_both==	20

replace	tradexp=	1.15270521	if	cntry==	"AT"	&	essround==	2	&	nace_both==	21

replace	tradexp=	0.517383678	if	cntry==	"AT"	&	essround==	2	&	nace_both==	22

replace	tradexp=	1.091039155	if	cntry==	"AT"	&	essround==	2	&	nace_both==	23

replace	tradexp=	2.183101872	if	cntry==	"AT"	&	essround==	2	&	nace_both==	24

replace	tradexp=	1.35044854	if	cntry==	"AT"	&	essround==	2	&	nace_both==	25

replace	tradexp=	0.529346863	if	cntry==	"AT"	&	essround==	2	&	nace_both==	26

replace	tradexp=	1.15263888	if	cntry==	"AT"	&	essround==	2	&	nace_both==	27

replace	tradexp=	0.739954966	if	cntry==	"AT"	&	essround==	2	&	nace_both==	28

replace	tradexp=	1.468954679	if	cntry==	"AT"	&	essround==	2	&	nace_both==	29

replace	tradexp=	7.27217738	if	cntry==	"AT"	&	essround==	2	&	nace_both==	30

replace	tradexp=	1.86021367	if	cntry==	"AT"	&	essround==	2	&	nace_both==	31

replace	tradexp=	1.61805897	if	cntry==	"AT"	&	essround==	2	&	nace_both==	32

replace	tradexp=	2.272371739	if	cntry==	"AT"	&	essround==	2	&	nace_both==	33

replace	tradexp=	1.930437237	if	cntry==	"AT"	&	essround==	2	&	nace_both==	34

replace	tradexp=	3.744816906	if	cntry==	"AT"	&	essround==	2	&	nace_both==	35

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	2	&	nace_both==	36

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	2	&	nace_both==	37

replace	tradexp=	0.261985337	if	cntry==	"AT"	&	essround==	2	&	nace_both==	40

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	2	&	nace_both==	41

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	2	&	nace_both==	45

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	2	&	nace_both==	50

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	2	&	nace_both==	51

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	2	&	nace_both==	52

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	2	&	nace_both==	55

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	2	&	nace_both==	60

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	2	&	nace_both==	61

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	2	&	nace_both==	62

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	2	&	nace_both==	63

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	2	&	nace_both==	64

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	2	&	nace_both==	65

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	2	&	nace_both==	66

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	2	&	nace_both==	67

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	2	&	nace_both==	70

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	2	&	nace_both==	71

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	2	&	nace_both==	72

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	2	&	nace_both==	73

replace	tradexp=	0.000628224	if	cntry==	"AT"	&	essround==	2	&	nace_both==	74

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	2	&	nace_both==	75

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	2	&	nace_both==	80

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	2	&	nace_both==	85

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	2	&	nace_both==	90

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	2	&	nace_both==	91

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	2	&	nace_both==	92

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	2	&	nace_both==	93

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	2	&	nace_both==	95

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	2	&	nace_both==	98

replace	tradexp=	.	if	cntry==	"AT"	&	essround==	2	&	nace_both==	99

replace	tradexp=	1.532287209	if	cntry==	"BE"	&	essround==	2	&	nace_both==	1

replace	tradexp=	2.035019259	if	cntry==	"BE"	&	essround==	2	&	nace_both==	2

replace	tradexp=	2.903189452	if	cntry==	"BE"	&	essround==	2	&	nace_both==	5

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	2	&	nace_both==	10

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	2	&	nace_both==	11

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	2	&	nace_both==	12

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	2	&	nace_both==	13

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	2	&	nace_both==	14

replace	tradexp=	1.12908438	if	cntry==	"BE"	&	essround==	2	&	nace_both==	15

replace	tradexp=	1.012138258	if	cntry==	"BE"	&	essround==	2	&	nace_both==	16

replace	tradexp=	1.939511976	if	cntry==	"BE"	&	essround==	2	&	nace_both==	17

replace	tradexp=	4.889367646	if	cntry==	"BE"	&	essround==	2	&	nace_both==	18

replace	tradexp=	14.39531107	if	cntry==	"BE"	&	essround==	2	&	nace_both==	19

replace	tradexp=	1.226294239	if	cntry==	"BE"	&	essround==	2	&	nace_both==	20

replace	tradexp=	2.324219803	if	cntry==	"BE"	&	essround==	2	&	nace_both==	21

replace	tradexp=	0.495546955	if	cntry==	"BE"	&	essround==	2	&	nace_both==	22

replace	tradexp=	0.82420712	if	cntry==	"BE"	&	essround==	2	&	nace_both==	23

replace	tradexp=	3.926208245	if	cntry==	"BE"	&	essround==	2	&	nace_both==	24

replace	tradexp=	2.320352743	if	cntry==	"BE"	&	essround==	2	&	nace_both==	25

replace	tradexp=	0.933787698	if	cntry==	"BE"	&	essround==	2	&	nace_both==	26

replace	tradexp=	1.59071432	if	cntry==	"BE"	&	essround==	2	&	nace_both==	27

replace	tradexp=	0.84113478	if	cntry==	"BE"	&	essround==	2	&	nace_both==	28

replace	tradexp=	3.314216228	if	cntry==	"BE"	&	essround==	2	&	nace_both==	29

replace	tradexp=	43.45746629	if	cntry==	"BE"	&	essround==	2	&	nace_both==	30

replace	tradexp=	2.327778998	if	cntry==	"BE"	&	essround==	2	&	nace_both==	31

replace	tradexp=	3.280219055	if	cntry==	"BE"	&	essround==	2	&	nace_both==	32

replace	tradexp=	6.966141061	if	cntry==	"BE"	&	essround==	2	&	nace_both==	33

replace	tradexp=	3.024176191	if	cntry==	"BE"	&	essround==	2	&	nace_both==	34

replace	tradexp=	2.589302237	if	cntry==	"BE"	&	essround==	2	&	nace_both==	35

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	2	&	nace_both==	36

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	2	&	nace_both==	37

replace	tradexp=	0.08160676	if	cntry==	"BE"	&	essround==	2	&	nace_both==	40

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	2	&	nace_both==	41

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	2	&	nace_both==	45

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	2	&	nace_both==	50

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	2	&	nace_both==	51

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	2	&	nace_both==	52

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	2	&	nace_both==	55

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	2	&	nace_both==	60

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	2	&	nace_both==	61

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	2	&	nace_both==	62

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	2	&	nace_both==	63

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	2	&	nace_both==	64

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	2	&	nace_both==	65

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	2	&	nace_both==	66

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	2	&	nace_both==	67

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	2	&	nace_both==	70

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	2	&	nace_both==	71

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	2	&	nace_both==	72

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	2	&	nace_both==	73

replace	tradexp=	0.000667818	if	cntry==	"BE"	&	essround==	2	&	nace_both==	74

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	2	&	nace_both==	75

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	2	&	nace_both==	80

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	2	&	nace_both==	85

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	2	&	nace_both==	90

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	2	&	nace_both==	91

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	2	&	nace_both==	92

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	2	&	nace_both==	93

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	2	&	nace_both==	95

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	2	&	nace_both==	98

replace	tradexp=	.	if	cntry==	"BE"	&	essround==	2	&	nace_both==	99

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	2	&	nace_both==	1

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	2	&	nace_both==	2

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	2	&	nace_both==	5

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	2	&	nace_both==	10

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	2	&	nace_both==	11

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	2	&	nace_both==	12

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	2	&	nace_both==	13

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	2	&	nace_both==	14

replace	tradexp=	0.348190176	if	cntry==	"CH"	&	essround==	2	&	nace_both==	15

replace	tradexp=	0.169256645	if	cntry==	"CH"	&	essround==	2	&	nace_both==	16

replace	tradexp=	2.018671381	if	cntry==	"CH"	&	essround==	2	&	nace_both==	17

replace	tradexp=	4.570149445	if	cntry==	"CH"	&	essround==	2	&	nace_both==	18

replace	tradexp=	6.331137587	if	cntry==	"CH"	&	essround==	2	&	nace_both==	19

replace	tradexp=	0.277441477	if	cntry==	"CH"	&	essround==	2	&	nace_both==	20

replace	tradexp=	1.164335535	if	cntry==	"CH"	&	essround==	2	&	nace_both==	21

replace	tradexp=	0.410399075	if	cntry==	"CH"	&	essround==	2	&	nace_both==	22

replace	tradexp=	3.03209213	if	cntry==	"CH"	&	essround==	2	&	nace_both==	23

replace	tradexp=	1.529445048	if	cntry==	"CH"	&	essround==	2	&	nace_both==	24

replace	tradexp=	1.152448818	if	cntry==	"CH"	&	essround==	2	&	nace_both==	25

replace	tradexp=	0.732734235	if	cntry==	"CH"	&	essround==	2	&	nace_both==	26

replace	tradexp=	2.98206269	if	cntry==	"CH"	&	essround==	2	&	nace_both==	27

replace	tradexp=	0.537584283	if	cntry==	"CH"	&	essround==	2	&	nace_both==	28

replace	tradexp=	1.174215989	if	cntry==	"CH"	&	essround==	2	&	nace_both==	29

replace	tradexp=	5.137129276	if	cntry==	"CH"	&	essround==	2	&	nace_both==	30

replace	tradexp=	0.931632721	if	cntry==	"CH"	&	essround==	2	&	nace_both==	31

replace	tradexp=	0.963595419	if	cntry==	"CH"	&	essround==	2	&	nace_both==	32

replace	tradexp=	0.971456322	if	cntry==	"CH"	&	essround==	2	&	nace_both==	33

replace	tradexp=	8.655201355	if	cntry==	"CH"	&	essround==	2	&	nace_both==	34

replace	tradexp=	1.679384723	if	cntry==	"CH"	&	essround==	2	&	nace_both==	35

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	2	&	nace_both==	36

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	2	&	nace_both==	37

replace	tradexp=	2.25449E-05	if	cntry==	"CH"	&	essround==	2	&	nace_both==	40

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	2	&	nace_both==	41

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	2	&	nace_both==	45

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	2	&	nace_both==	50

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	2	&	nace_both==	51

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	2	&	nace_both==	52

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	2	&	nace_both==	55

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	2	&	nace_both==	60

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	2	&	nace_both==	61

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	2	&	nace_both==	62

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	2	&	nace_both==	63

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	2	&	nace_both==	64

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	2	&	nace_both==	65

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	2	&	nace_both==	66

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	2	&	nace_both==	67

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	2	&	nace_both==	70

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	2	&	nace_both==	71

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	2	&	nace_both==	72

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	2	&	nace_both==	73

replace	tradexp=	0.000845363	if	cntry==	"CH"	&	essround==	2	&	nace_both==	74

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	2	&	nace_both==	75

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	2	&	nace_both==	80

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	2	&	nace_both==	85

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	2	&	nace_both==	90

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	2	&	nace_both==	91

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	2	&	nace_both==	92

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	2	&	nace_both==	93

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	2	&	nace_both==	95

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	2	&	nace_both==	98

replace	tradexp=	.	if	cntry==	"CH"	&	essround==	2	&	nace_both==	99

replace	tradexp=	0.268535877	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	1

replace	tradexp=	0.182972643	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	2

replace	tradexp=	0.676937474	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	5

replace	tradexp=	0.306114137	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	10

replace	tradexp=	20.84772374	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	11

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	12

replace	tradexp=	2320.028547	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	13

replace	tradexp=	0.57897532	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	14

replace	tradexp=	0.354438781	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	15

replace	tradexp=	0.31080071	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	16

replace	tradexp=	1.570453863	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	17

replace	tradexp=	1.388410513	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	18

replace	tradexp=	2.64822767	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	19

replace	tradexp=	0.475597083	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	20

replace	tradexp=	1.229853902	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	21

replace	tradexp=	0.655087342	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	22

replace	tradexp=	0.878813406	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	23

replace	tradexp=	1.808036981	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	24

replace	tradexp=	1.078159235	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	25

replace	tradexp=	0.696307648	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	26

replace	tradexp=	1.045062074	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	27

replace	tradexp=	0.830066584	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	28

replace	tradexp=	1.833711789	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	29

replace	tradexp=	1.87450555	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	30

replace	tradexp=	1.415804822	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	31

replace	tradexp=	1.911531037	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	32

replace	tradexp=	1.517365198	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	33

replace	tradexp=	1.14178358	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	34

replace	tradexp=	1.202305559	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	35

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	36

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	37

replace	tradexp=	0.064919691	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	40

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	41

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	45

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	50

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	51

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	52

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	55

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	60

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	61

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	62

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	63

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	64

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	65

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	66

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	67

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	70

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	71

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	72

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	73

replace	tradexp=	0.000581942	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	74

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	75

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	80

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	85

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	90

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	91

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	92

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	93

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	95

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	98

replace	tradexp=	.	if	cntry==	"CZ"	&	essround==	2	&	nace_both==	99

replace	tradexp=	0.426168155	if	cntry==	"DE"	&	essround==	2	&	nace_both==	1

replace	tradexp=	0.208504517	if	cntry==	"DE"	&	essround==	2	&	nace_both==	2

replace	tradexp=	1.257446229	if	cntry==	"DE"	&	essround==	2	&	nace_both==	5

replace	tradexp=	0.521423743	if	cntry==	"DE"	&	essround==	2	&	nace_both==	10

replace	tradexp=	11.5025451	if	cntry==	"DE"	&	essround==	2	&	nace_both==	11

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	2	&	nace_both==	12

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	2	&	nace_both==	13

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	2	&	nace_both==	14

replace	tradexp=	0.38935319	if	cntry==	"DE"	&	essround==	2	&	nace_both==	15

replace	tradexp=	0.572880498	if	cntry==	"DE"	&	essround==	2	&	nace_both==	16

replace	tradexp=	2.006439835	if	cntry==	"DE"	&	essround==	2	&	nace_both==	17

replace	tradexp=	2.108771161	if	cntry==	"DE"	&	essround==	2	&	nace_both==	18

replace	tradexp=	2.720776048	if	cntry==	"DE"	&	essround==	2	&	nace_both==	19

replace	tradexp=	0.380943229	if	cntry==	"DE"	&	essround==	2	&	nace_both==	20

replace	tradexp=	0.861491451	if	cntry==	"DE"	&	essround==	2	&	nace_both==	21

replace	tradexp=	0.215669372	if	cntry==	"DE"	&	essround==	2	&	nace_both==	22

replace	tradexp=	0.47698394	if	cntry==	"DE"	&	essround==	2	&	nace_both==	23

replace	tradexp=	1.216407108	if	cntry==	"DE"	&	essround==	2	&	nace_both==	24

replace	tradexp=	0.670159551	if	cntry==	"DE"	&	essround==	2	&	nace_both==	25

replace	tradexp=	0.427554396	if	cntry==	"DE"	&	essround==	2	&	nace_both==	26

replace	tradexp=	0.867071681	if	cntry==	"DE"	&	essround==	2	&	nace_both==	27

replace	tradexp=	0.378385824	if	cntry==	"DE"	&	essround==	2	&	nace_both==	28

replace	tradexp=	0.839321243	if	cntry==	"DE"	&	essround==	2	&	nace_both==	29

replace	tradexp=	3.656568108	if	cntry==	"DE"	&	essround==	2	&	nace_both==	30

replace	tradexp=	0.695194084	if	cntry==	"DE"	&	essround==	2	&	nace_both==	31

replace	tradexp=	2.198811154	if	cntry==	"DE"	&	essround==	2	&	nace_both==	32

replace	tradexp=	1.204179804	if	cntry==	"DE"	&	essround==	2	&	nace_both==	33

replace	tradexp=	0.810374125	if	cntry==	"DE"	&	essround==	2	&	nace_both==	34

replace	tradexp=	1.731777013	if	cntry==	"DE"	&	essround==	2	&	nace_both==	35

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	2	&	nace_both==	36

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	2	&	nace_both==	37

replace	tradexp=	0.022603564	if	cntry==	"DE"	&	essround==	2	&	nace_both==	40

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	2	&	nace_both==	41

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	2	&	nace_both==	45

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	2	&	nace_both==	50

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	2	&	nace_both==	51

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	2	&	nace_both==	52

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	2	&	nace_both==	55

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	2	&	nace_both==	60

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	2	&	nace_both==	61

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	2	&	nace_both==	62

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	2	&	nace_both==	63

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	2	&	nace_both==	64

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	2	&	nace_both==	65

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	2	&	nace_both==	66

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	2	&	nace_both==	67

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	2	&	nace_both==	70

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	2	&	nace_both==	71

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	2	&	nace_both==	72

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	2	&	nace_both==	73

replace	tradexp=	0.000969513	if	cntry==	"DE"	&	essround==	2	&	nace_both==	74

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	2	&	nace_both==	75

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	2	&	nace_both==	80

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	2	&	nace_both==	85

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	2	&	nace_both==	90

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	2	&	nace_both==	91

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	2	&	nace_both==	92

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	2	&	nace_both==	93

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	2	&	nace_both==	95

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	2	&	nace_both==	98

replace	tradexp=	.	if	cntry==	"DE"	&	essround==	2	&	nace_both==	99

replace	tradexp=	0.362225414	if	cntry==	"DK"	&	essround==	2	&	nace_both==	1

replace	tradexp=	0.398553921	if	cntry==	"DK"	&	essround==	2	&	nace_both==	2

replace	tradexp=	1.663678837	if	cntry==	"DK"	&	essround==	2	&	nace_both==	5

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	2	&	nace_both==	10

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	2	&	nace_both==	11

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	2	&	nace_both==	12

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	2	&	nace_both==	13

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	2	&	nace_both==	14

replace	tradexp=	0.926310061	if	cntry==	"DK"	&	essround==	2	&	nace_both==	15

replace	tradexp=	0.374076579	if	cntry==	"DK"	&	essround==	2	&	nace_both==	16

replace	tradexp=	3.085549809	if	cntry==	"DK"	&	essround==	2	&	nace_both==	17

replace	tradexp=	7.175197983	if	cntry==	"DK"	&	essround==	2	&	nace_both==	18

replace	tradexp=	15.48568373	if	cntry==	"DK"	&	essround==	2	&	nace_both==	19

replace	tradexp=	1.03016949	if	cntry==	"DK"	&	essround==	2	&	nace_both==	20

replace	tradexp=	1.626246851	if	cntry==	"DK"	&	essround==	2	&	nace_both==	21

replace	tradexp=	0.213554806	if	cntry==	"DK"	&	essround==	2	&	nace_both==	22

replace	tradexp=	1.12066023	if	cntry==	"DK"	&	essround==	2	&	nace_both==	23

replace	tradexp=	1.674513913	if	cntry==	"DK"	&	essround==	2	&	nace_both==	24

replace	tradexp=	1.232738863	if	cntry==	"DK"	&	essround==	2	&	nace_both==	25

replace	tradexp=	0.703554094	if	cntry==	"DK"	&	essround==	2	&	nace_both==	26

replace	tradexp=	3.207939112	if	cntry==	"DK"	&	essround==	2	&	nace_both==	27

replace	tradexp=	0.694447942	if	cntry==	"DK"	&	essround==	2	&	nace_both==	28

replace	tradexp=	1.383613729	if	cntry==	"DK"	&	essround==	2	&	nace_both==	29

replace	tradexp=	13.65008651	if	cntry==	"DK"	&	essround==	2	&	nace_both==	30

replace	tradexp=	1.095350381	if	cntry==	"DK"	&	essround==	2	&	nace_both==	31

replace	tradexp=	5.15930952	if	cntry==	"DK"	&	essround==	2	&	nace_both==	32

replace	tradexp=	1.64256268	if	cntry==	"DK"	&	essround==	2	&	nace_both==	33

replace	tradexp=	6.162817397	if	cntry==	"DK"	&	essround==	2	&	nace_both==	34

replace	tradexp=	2.578898538	if	cntry==	"DK"	&	essround==	2	&	nace_both==	35

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	2	&	nace_both==	36

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	2	&	nace_both==	37

replace	tradexp=	0.088549412	if	cntry==	"DK"	&	essround==	2	&	nace_both==	40

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	2	&	nace_both==	41

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	2	&	nace_both==	45

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	2	&	nace_both==	50

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	2	&	nace_both==	51

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	2	&	nace_both==	52

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	2	&	nace_both==	55

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	2	&	nace_both==	60

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	2	&	nace_both==	61

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	2	&	nace_both==	62

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	2	&	nace_both==	63

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	2	&	nace_both==	64

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	2	&	nace_both==	65

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	2	&	nace_both==	66

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	2	&	nace_both==	67

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	2	&	nace_both==	70

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	2	&	nace_both==	71

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	2	&	nace_both==	72

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	2	&	nace_both==	73

replace	tradexp=	0.000672501	if	cntry==	"DK"	&	essround==	2	&	nace_both==	74

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	2	&	nace_both==	75

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	2	&	nace_both==	80

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	2	&	nace_both==	85

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	2	&	nace_both==	90

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	2	&	nace_both==	91

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	2	&	nace_both==	92

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	2	&	nace_both==	93

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	2	&	nace_both==	95

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	2	&	nace_both==	98

replace	tradexp=	.	if	cntry==	"DK"	&	essround==	2	&	nace_both==	99

replace	tradexp=	0.339692842	if	cntry==	"ES"	&	essround==	2	&	nace_both==	1

replace	tradexp=	0.18272969	if	cntry==	"ES"	&	essround==	2	&	nace_both==	2

replace	tradexp=	0.532396591	if	cntry==	"ES"	&	essround==	2	&	nace_both==	5

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	2	&	nace_both==	10

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	2	&	nace_both==	11

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	2	&	nace_both==	12

replace	tradexp=	10.09344919	if	cntry==	"ES"	&	essround==	2	&	nace_both==	13

replace	tradexp=	0.257423905	if	cntry==	"ES"	&	essround==	2	&	nace_both==	14

replace	tradexp=	0.310780861	if	cntry==	"ES"	&	essround==	2	&	nace_both==	15

replace	tradexp=	1.136192918	if	cntry==	"ES"	&	essround==	2	&	nace_both==	16

replace	tradexp=	0.949709086	if	cntry==	"ES"	&	essround==	2	&	nace_both==	17

replace	tradexp=	0.938367761	if	cntry==	"ES"	&	essround==	2	&	nace_both==	18

replace	tradexp=	0.816613663	if	cntry==	"ES"	&	essround==	2	&	nace_both==	19

replace	tradexp=	0.296646454	if	cntry==	"ES"	&	essround==	2	&	nace_both==	20

replace	tradexp=	0.617376968	if	cntry==	"ES"	&	essround==	2	&	nace_both==	21

replace	tradexp=	0.136645536	if	cntry==	"ES"	&	essround==	2	&	nace_both==	22

replace	tradexp=	0.470622236	if	cntry==	"ES"	&	essround==	2	&	nace_both==	23

replace	tradexp=	1.049707769	if	cntry==	"ES"	&	essround==	2	&	nace_both==	24

replace	tradexp=	0.602274408	if	cntry==	"ES"	&	essround==	2	&	nace_both==	25

replace	tradexp=	0.244859869	if	cntry==	"ES"	&	essround==	2	&	nace_both==	26

replace	tradexp=	0.644604562	if	cntry==	"ES"	&	essround==	2	&	nace_both==	27

replace	tradexp=	0.251001328	if	cntry==	"ES"	&	essround==	2	&	nace_both==	28

replace	tradexp=	1.069739372	if	cntry==	"ES"	&	essround==	2	&	nace_both==	29

replace	tradexp=	3.029633535	if	cntry==	"ES"	&	essround==	2	&	nace_both==	30

replace	tradexp=	0.77915853	if	cntry==	"ES"	&	essround==	2	&	nace_both==	31

replace	tradexp=	2.719847393	if	cntry==	"ES"	&	essround==	2	&	nace_both==	32

replace	tradexp=	1.961233876	if	cntry==	"ES"	&	essround==	2	&	nace_both==	33

replace	tradexp=	1.295080446	if	cntry==	"ES"	&	essround==	2	&	nace_both==	34

replace	tradexp=	1.143980442	if	cntry==	"ES"	&	essround==	2	&	nace_both==	35

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	2	&	nace_both==	36

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	2	&	nace_both==	37

replace	tradexp=	0.027685592	if	cntry==	"ES"	&	essround==	2	&	nace_both==	40

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	2	&	nace_both==	41

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	2	&	nace_both==	45

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	2	&	nace_both==	50

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	2	&	nace_both==	51

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	2	&	nace_both==	52

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	2	&	nace_both==	55

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	2	&	nace_both==	60

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	2	&	nace_both==	61

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	2	&	nace_both==	62

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	2	&	nace_both==	63

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	2	&	nace_both==	64

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	2	&	nace_both==	65

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	2	&	nace_both==	66

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	2	&	nace_both==	67

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	2	&	nace_both==	70

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	2	&	nace_both==	71

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	2	&	nace_both==	72

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	2	&	nace_both==	73

replace	tradexp=	0.000213691	if	cntry==	"ES"	&	essround==	2	&	nace_both==	74

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	2	&	nace_both==	75

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	2	&	nace_both==	80

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	2	&	nace_both==	85

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	2	&	nace_both==	90

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	2	&	nace_both==	91

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	2	&	nace_both==	92

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	2	&	nace_both==	93

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	2	&	nace_both==	95

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	2	&	nace_both==	98

replace	tradexp=	.	if	cntry==	"ES"	&	essround==	2	&	nace_both==	99

replace	tradexp=	0.249986328	if	cntry==	"FI"	&	essround==	2	&	nace_both==	1

replace	tradexp=	0.183865972	if	cntry==	"FI"	&	essround==	2	&	nace_both==	2

replace	tradexp=	0.525147202	if	cntry==	"FI"	&	essround==	2	&	nace_both==	5

replace	tradexp=	1.532544234	if	cntry==	"FI"	&	essround==	2	&	nace_both==	10

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	2	&	nace_both==	11

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	2	&	nace_both==	12

replace	tradexp=	7.825398075	if	cntry==	"FI"	&	essround==	2	&	nace_both==	13

replace	tradexp=	0.474068696	if	cntry==	"FI"	&	essround==	2	&	nace_both==	14

replace	tradexp=	0.304943969	if	cntry==	"FI"	&	essround==	2	&	nace_both==	15

replace	tradexp=	4.796511545	if	cntry==	"FI"	&	essround==	2	&	nace_both==	16

replace	tradexp=	1.670234251	if	cntry==	"FI"	&	essround==	2	&	nace_both==	17

replace	tradexp=	2.235297416	if	cntry==	"FI"	&	essround==	2	&	nace_both==	18

replace	tradexp=	1.800163203	if	cntry==	"FI"	&	essround==	2	&	nace_both==	19

replace	tradexp=	0.477681411	if	cntry==	"FI"	&	essround==	2	&	nace_both==	20

replace	tradexp=	0.710886854	if	cntry==	"FI"	&	essround==	2	&	nace_both==	21

replace	tradexp=	0.172601989	if	cntry==	"FI"	&	essround==	2	&	nace_both==	22

replace	tradexp=	0.626807703	if	cntry==	"FI"	&	essround==	2	&	nace_both==	23

replace	tradexp=	1.227974108	if	cntry==	"FI"	&	essround==	2	&	nace_both==	24

replace	tradexp=	0.790168029	if	cntry==	"FI"	&	essround==	2	&	nace_both==	25

replace	tradexp=	0.426864623	if	cntry==	"FI"	&	essround==	2	&	nace_both==	26

replace	tradexp=	0.930270222	if	cntry==	"FI"	&	essround==	2	&	nace_both==	27

replace	tradexp=	0.358022631	if	cntry==	"FI"	&	essround==	2	&	nace_both==	28

replace	tradexp=	0.81386373	if	cntry==	"FI"	&	essround==	2	&	nace_both==	29

replace	tradexp=	22.04237291	if	cntry==	"FI"	&	essround==	2	&	nace_both==	30

replace	tradexp=	1.477451723	if	cntry==	"FI"	&	essround==	2	&	nace_both==	31

replace	tradexp=	0.793515799	if	cntry==	"FI"	&	essround==	2	&	nace_both==	32

replace	tradexp=	1.290401487	if	cntry==	"FI"	&	essround==	2	&	nace_both==	33

replace	tradexp=	4.462002944	if	cntry==	"FI"	&	essround==	2	&	nace_both==	34

replace	tradexp=	0.920655153	if	cntry==	"FI"	&	essround==	2	&	nace_both==	35

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	2	&	nace_both==	36

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	2	&	nace_both==	37

replace	tradexp=	0.087131228	if	cntry==	"FI"	&	essround==	2	&	nace_both==	40

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	2	&	nace_both==	41

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	2	&	nace_both==	45

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	2	&	nace_both==	50

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	2	&	nace_both==	51

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	2	&	nace_both==	52

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	2	&	nace_both==	55

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	2	&	nace_both==	60

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	2	&	nace_both==	61

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	2	&	nace_both==	62

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	2	&	nace_both==	63

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	2	&	nace_both==	64

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	2	&	nace_both==	65

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	2	&	nace_both==	66

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	2	&	nace_both==	67

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	2	&	nace_both==	70

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	2	&	nace_both==	71

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	2	&	nace_both==	72

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	2	&	nace_both==	73

replace	tradexp=	0.001026811	if	cntry==	"FI"	&	essround==	2	&	nace_both==	74

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	2	&	nace_both==	75

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	2	&	nace_both==	80

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	2	&	nace_both==	85

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	2	&	nace_both==	90

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	2	&	nace_both==	91

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	2	&	nace_both==	92

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	2	&	nace_both==	93

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	2	&	nace_both==	95

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	2	&	nace_both==	98

replace	tradexp=	.	if	cntry==	"FI"	&	essround==	2	&	nace_both==	99

replace	tradexp=	0.233674105	if	cntry==	"FR"	&	essround==	2	&	nace_both==	1

replace	tradexp=	0.100188553	if	cntry==	"FR"	&	essround==	2	&	nace_both==	2

replace	tradexp=	0.691040714	if	cntry==	"FR"	&	essround==	2	&	nace_both==	5

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	2	&	nace_both==	10

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	2	&	nace_both==	11

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	2	&	nace_both==	12

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	2	&	nace_both==	13

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	2	&	nace_both==	14

replace	tradexp=	0.421574863	if	cntry==	"FR"	&	essround==	2	&	nace_both==	15

replace	tradexp=	2.118791781	if	cntry==	"FR"	&	essround==	2	&	nace_both==	16

replace	tradexp=	1.249033545	if	cntry==	"FR"	&	essround==	2	&	nace_both==	17

replace	tradexp=	1.442330556	if	cntry==	"FR"	&	essround==	2	&	nace_both==	18

replace	tradexp=	2.818745416	if	cntry==	"FR"	&	essround==	2	&	nace_both==	19

replace	tradexp=	0.401556429	if	cntry==	"FR"	&	essround==	2	&	nace_both==	20

replace	tradexp=	0.765158574	if	cntry==	"FR"	&	essround==	2	&	nace_both==	21

replace	tradexp=	0.185442521	if	cntry==	"FR"	&	essround==	2	&	nace_both==	22

replace	tradexp=	0.436414891	if	cntry==	"FR"	&	essround==	2	&	nace_both==	23

replace	tradexp=	1.09648484	if	cntry==	"FR"	&	essround==	2	&	nace_both==	24

replace	tradexp=	0.616942825	if	cntry==	"FR"	&	essround==	2	&	nace_both==	25

replace	tradexp=	0.363329626	if	cntry==	"FR"	&	essround==	2	&	nace_both==	26

replace	tradexp=	1.009684356	if	cntry==	"FR"	&	essround==	2	&	nace_both==	27

replace	tradexp=	0.294081665	if	cntry==	"FR"	&	essround==	2	&	nace_both==	28

replace	tradexp=	1.083715259	if	cntry==	"FR"	&	essround==	2	&	nace_both==	29

replace	tradexp=	5.110004911	if	cntry==	"FR"	&	essround==	2	&	nace_both==	30

replace	tradexp=	1.028641807	if	cntry==	"FR"	&	essround==	2	&	nace_both==	31

replace	tradexp=	1.423124426	if	cntry==	"FR"	&	essround==	2	&	nace_both==	32

replace	tradexp=	1.06680755	if	cntry==	"FR"	&	essround==	2	&	nace_both==	33

replace	tradexp=	1.013818903	if	cntry==	"FR"	&	essround==	2	&	nace_both==	34

replace	tradexp=	0.871490196	if	cntry==	"FR"	&	essround==	2	&	nace_both==	35

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	2	&	nace_both==	36

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	2	&	nace_both==	37

replace	tradexp=	0.068491236	if	cntry==	"FR"	&	essround==	2	&	nace_both==	40

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	2	&	nace_both==	41

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	2	&	nace_both==	45

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	2	&	nace_both==	50

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	2	&	nace_both==	51

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	2	&	nace_both==	52

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	2	&	nace_both==	55

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	2	&	nace_both==	60

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	2	&	nace_both==	61

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	2	&	nace_both==	62

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	2	&	nace_both==	63

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	2	&	nace_both==	64

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	2	&	nace_both==	65

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	2	&	nace_both==	66

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	2	&	nace_both==	67

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	2	&	nace_both==	70

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	2	&	nace_both==	71

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	2	&	nace_both==	72

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	2	&	nace_both==	73

replace	tradexp=	0.000545655	if	cntry==	"FR"	&	essround==	2	&	nace_both==	74

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	2	&	nace_both==	75

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	2	&	nace_both==	80

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	2	&	nace_both==	85

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	2	&	nace_both==	90

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	2	&	nace_both==	91

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	2	&	nace_both==	92

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	2	&	nace_both==	93

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	2	&	nace_both==	95

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	2	&	nace_both==	98

replace	tradexp=	.	if	cntry==	"FR"	&	essround==	2	&	nace_both==	99

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	1

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	2

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	5

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	10

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	11

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	12

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	13

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	14

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	15

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	16

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	17

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	18

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	19

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	20

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	21

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	22

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	23

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	24

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	25

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	26

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	27

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	28

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	29

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	30

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	31

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	32

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	33

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	34

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	35

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	36

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	37

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	40

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	41

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	45

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	50

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	51

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	52

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	55

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	60

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	61

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	62

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	63

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	64

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	65

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	66

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	67

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	70

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	71

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	72

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	73

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	74

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	75

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	80

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	85

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	90

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	91

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	92

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	93

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	95

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	98

replace	tradexp=	.	if	cntry==	"GB"	&	essround==	2	&	nace_both==	99

replace	tradexp=	0.176461452	if	cntry==	"GR"	&	essround==	2	&	nace_both==	1

replace	tradexp=	0.518032464	if	cntry==	"GR"	&	essround==	2	&	nace_both==	2

replace	tradexp=	0.331690997	if	cntry==	"GR"	&	essround==	2	&	nace_both==	5

replace	tradexp=	0.096799551	if	cntry==	"GR"	&	essround==	2	&	nace_both==	10

replace	tradexp=	123.4694075	if	cntry==	"GR"	&	essround==	2	&	nace_both==	11

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	2	&	nace_both==	12

replace	tradexp=	0.108121262	if	cntry==	"GR"	&	essround==	2	&	nace_both==	13

replace	tradexp=	0.261360885	if	cntry==	"GR"	&	essround==	2	&	nace_both==	14

replace	tradexp=	0.273682074	if	cntry==	"GR"	&	essround==	2	&	nace_both==	15

replace	tradexp=	0.654657324	if	cntry==	"GR"	&	essround==	2	&	nace_both==	16

replace	tradexp=	0.984561667	if	cntry==	"GR"	&	essround==	2	&	nace_both==	17

replace	tradexp=	0.861116825	if	cntry==	"GR"	&	essround==	2	&	nace_both==	18

replace	tradexp=	1.528090129	if	cntry==	"GR"	&	essround==	2	&	nace_both==	19

replace	tradexp=	0.44423581	if	cntry==	"GR"	&	essround==	2	&	nace_both==	20

replace	tradexp=	0.832047452	if	cntry==	"GR"	&	essround==	2	&	nace_both==	21

replace	tradexp=	0.174571478	if	cntry==	"GR"	&	essround==	2	&	nace_both==	22

replace	tradexp=	0.303547176	if	cntry==	"GR"	&	essround==	2	&	nace_both==	23

replace	tradexp=	2.130011409	if	cntry==	"GR"	&	essround==	2	&	nace_both==	24

replace	tradexp=	0.969334775	if	cntry==	"GR"	&	essround==	2	&	nace_both==	25

replace	tradexp=	0.205133878	if	cntry==	"GR"	&	essround==	2	&	nace_both==	26

replace	tradexp=	0.966996592	if	cntry==	"GR"	&	essround==	2	&	nace_both==	27

replace	tradexp=	0.514233274	if	cntry==	"GR"	&	essround==	2	&	nace_both==	28

replace	tradexp=	2.348586332	if	cntry==	"GR"	&	essround==	2	&	nace_both==	29

replace	tradexp=	74.81786458	if	cntry==	"GR"	&	essround==	2	&	nace_both==	30

replace	tradexp=	1.179654257	if	cntry==	"GR"	&	essround==	2	&	nace_both==	31

replace	tradexp=	2.226036226	if	cntry==	"GR"	&	essround==	2	&	nace_both==	32

replace	tradexp=	8.816812631	if	cntry==	"GR"	&	essround==	2	&	nace_both==	33

replace	tradexp=	8.800436202	if	cntry==	"GR"	&	essround==	2	&	nace_both==	34

replace	tradexp=	3.944003212	if	cntry==	"GR"	&	essround==	2	&	nace_both==	35

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	2	&	nace_both==	36

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	2	&	nace_both==	37

replace	tradexp=	0.02254435	if	cntry==	"GR"	&	essround==	2	&	nace_both==	40

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	2	&	nace_both==	41

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	2	&	nace_both==	45

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	2	&	nace_both==	50

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	2	&	nace_both==	51

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	2	&	nace_both==	52

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	2	&	nace_both==	55

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	2	&	nace_both==	60

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	2	&	nace_both==	61

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	2	&	nace_both==	62

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	2	&	nace_both==	63

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	2	&	nace_both==	64

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	2	&	nace_both==	65

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	2	&	nace_both==	66

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	2	&	nace_both==	67

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	2	&	nace_both==	70

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	2	&	nace_both==	71

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	2	&	nace_both==	72

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	2	&	nace_both==	73

replace	tradexp=	0.000315418	if	cntry==	"GR"	&	essround==	2	&	nace_both==	74

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	2	&	nace_both==	75

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	2	&	nace_both==	80

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	2	&	nace_both==	85

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	2	&	nace_both==	90

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	2	&	nace_both==	91

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	2	&	nace_both==	92

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	2	&	nace_both==	93

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	2	&	nace_both==	95

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	2	&	nace_both==	98

replace	tradexp=	.	if	cntry==	"GR"	&	essround==	2	&	nace_both==	99

replace	tradexp=	0.207049678	if	cntry==	"HU"	&	essround==	2	&	nace_both==	1

replace	tradexp=	0.345072472	if	cntry==	"HU"	&	essround==	2	&	nace_both==	2

replace	tradexp=	0.213112748	if	cntry==	"HU"	&	essround==	2	&	nace_both==	5

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	2	&	nace_both==	10

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	2	&	nace_both==	11

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	2	&	nace_both==	12

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	2	&	nace_both==	13

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	2	&	nace_both==	14

replace	tradexp=	0.41150119	if	cntry==	"HU"	&	essround==	2	&	nace_both==	15

replace	tradexp=	0.164972083	if	cntry==	"HU"	&	essround==	2	&	nace_both==	16

replace	tradexp=	2.77756615	if	cntry==	"HU"	&	essround==	2	&	nace_both==	17

replace	tradexp=	1.04439599	if	cntry==	"HU"	&	essround==	2	&	nace_both==	18

replace	tradexp=	2.442237828	if	cntry==	"HU"	&	essround==	2	&	nace_both==	19

replace	tradexp=	0.873951167	if	cntry==	"HU"	&	essround==	2	&	nace_both==	20

replace	tradexp=	1.597619328	if	cntry==	"HU"	&	essround==	2	&	nace_both==	21

replace	tradexp=	0.21789004	if	cntry==	"HU"	&	essround==	2	&	nace_both==	22

replace	tradexp=	0.472351098	if	cntry==	"HU"	&	essround==	2	&	nace_both==	23

replace	tradexp=	1.739897078	if	cntry==	"HU"	&	essround==	2	&	nace_both==	24

replace	tradexp=	1.341926395	if	cntry==	"HU"	&	essround==	2	&	nace_both==	25

replace	tradexp=	0.760868594	if	cntry==	"HU"	&	essround==	2	&	nace_both==	26

replace	tradexp=	1.398566035	if	cntry==	"HU"	&	essround==	2	&	nace_both==	27

replace	tradexp=	0.938328004	if	cntry==	"HU"	&	essround==	2	&	nace_both==	28

replace	tradexp=	2.253735779	if	cntry==	"HU"	&	essround==	2	&	nace_both==	29

replace	tradexp=	2.276471803	if	cntry==	"HU"	&	essround==	2	&	nace_both==	30

replace	tradexp=	1.49763547	if	cntry==	"HU"	&	essround==	2	&	nace_both==	31

replace	tradexp=	1.704891699	if	cntry==	"HU"	&	essround==	2	&	nace_both==	32

replace	tradexp=	2.498272705	if	cntry==	"HU"	&	essround==	2	&	nace_both==	33

replace	tradexp=	1.692662373	if	cntry==	"HU"	&	essround==	2	&	nace_both==	34

replace	tradexp=	0.976305509	if	cntry==	"HU"	&	essround==	2	&	nace_both==	35

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	2	&	nace_both==	36

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	2	&	nace_both==	37

replace	tradexp=	0.052687571	if	cntry==	"HU"	&	essround==	2	&	nace_both==	40

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	2	&	nace_both==	41

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	2	&	nace_both==	45

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	2	&	nace_both==	50

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	2	&	nace_both==	51

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	2	&	nace_both==	52

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	2	&	nace_both==	55

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	2	&	nace_both==	60

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	2	&	nace_both==	61

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	2	&	nace_both==	62

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	2	&	nace_both==	63

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	2	&	nace_both==	64

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	2	&	nace_both==	65

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	2	&	nace_both==	66

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	2	&	nace_both==	67

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	2	&	nace_both==	70

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	2	&	nace_both==	71

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	2	&	nace_both==	72

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	2	&	nace_both==	73

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	2	&	nace_both==	74

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	2	&	nace_both==	75

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	2	&	nace_both==	80

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	2	&	nace_both==	85

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	2	&	nace_both==	90

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	2	&	nace_both==	91

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	2	&	nace_both==	92

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	2	&	nace_both==	93

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	2	&	nace_both==	95

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	2	&	nace_both==	98

replace	tradexp=	.	if	cntry==	"HU"	&	essround==	2	&	nace_both==	99

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	1

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	2

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	5

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	10

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	11

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	12

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	13

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	14

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	15

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	16

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	17

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	18

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	19

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	20

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	21

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	22

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	23

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	24

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	25

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	26

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	27

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	28

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	29

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	30

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	31

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	32

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	33

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	34

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	35

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	36

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	37

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	40

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	41

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	45

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	50

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	51

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	52

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	55

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	60

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	61

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	62

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	63

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	64

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	65

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	66

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	67

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	70

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	71

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	72

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	73

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	74

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	75

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	80

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	85

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	90

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	91

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	92

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	93

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	95

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	98

replace	tradexp=	.	if	cntry==	"IE"	&	essround==	2	&	nace_both==	99

replace	tradexp=	0.210738733	if	cntry==	"IS"	&	essround==	2	&	nace_both==	1

replace	tradexp=	0.795897601	if	cntry==	"IS"	&	essround==	2	&	nace_both==	2

replace	tradexp=	0.120605014	if	cntry==	"IS"	&	essround==	2	&	nace_both==	5

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	2	&	nace_both==	10

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	2	&	nace_both==	11

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	2	&	nace_both==	12

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	2	&	nace_both==	13

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	2	&	nace_both==	14

replace	tradexp=	0.891872929	if	cntry==	"IS"	&	essround==	2	&	nace_both==	15

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	2	&	nace_both==	16

replace	tradexp=	1.584273712	if	cntry==	"IS"	&	essround==	2	&	nace_both==	17

replace	tradexp=	3.031457215	if	cntry==	"IS"	&	essround==	2	&	nace_both==	18

replace	tradexp=	14.21421628	if	cntry==	"IS"	&	essround==	2	&	nace_both==	19

replace	tradexp=	1.240986201	if	cntry==	"IS"	&	essround==	2	&	nace_both==	20

replace	tradexp=	2.403300167	if	cntry==	"IS"	&	essround==	2	&	nace_both==	21

replace	tradexp=	0.126753161	if	cntry==	"IS"	&	essround==	2	&	nace_both==	22

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	2	&	nace_both==	23

replace	tradexp=	1.737130609	if	cntry==	"IS"	&	essround==	2	&	nace_both==	24

replace	tradexp=	1.223884867	if	cntry==	"IS"	&	essround==	2	&	nace_both==	25

replace	tradexp=	0.283051137	if	cntry==	"IS"	&	essround==	2	&	nace_both==	26

replace	tradexp=	1.344182019	if	cntry==	"IS"	&	essround==	2	&	nace_both==	27

replace	tradexp=	0.897065421	if	cntry==	"IS"	&	essround==	2	&	nace_both==	28

replace	tradexp=	3.072731486	if	cntry==	"IS"	&	essround==	2	&	nace_both==	29

replace	tradexp=	1230.607623	if	cntry==	"IS"	&	essround==	2	&	nace_both==	30

replace	tradexp=	6.896021253	if	cntry==	"IS"	&	essround==	2	&	nace_both==	31

replace	tradexp=	78.59024184	if	cntry==	"IS"	&	essround==	2	&	nace_both==	32

replace	tradexp=	2.028115664	if	cntry==	"IS"	&	essround==	2	&	nace_both==	33

replace	tradexp=	40.57158016	if	cntry==	"IS"	&	essround==	2	&	nace_both==	34

replace	tradexp=	1.616342751	if	cntry==	"IS"	&	essround==	2	&	nace_both==	35

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	2	&	nace_both==	36

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	2	&	nace_both==	37

replace	tradexp=	0.000533225	if	cntry==	"IS"	&	essround==	2	&	nace_both==	40

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	2	&	nace_both==	41

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	2	&	nace_both==	45

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	2	&	nace_both==	50

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	2	&	nace_both==	51

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	2	&	nace_both==	52

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	2	&	nace_both==	55

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	2	&	nace_both==	60

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	2	&	nace_both==	61

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	2	&	nace_both==	62

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	2	&	nace_both==	63

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	2	&	nace_both==	64

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	2	&	nace_both==	65

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	2	&	nace_both==	66

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	2	&	nace_both==	67

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	2	&	nace_both==	70

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	2	&	nace_both==	71

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	2	&	nace_both==	72

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	2	&	nace_both==	73

replace	tradexp=	7.96207E-05	if	cntry==	"IS"	&	essround==	2	&	nace_both==	74

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	2	&	nace_both==	75

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	2	&	nace_both==	80

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	2	&	nace_both==	85

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	2	&	nace_both==	90

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	2	&	nace_both==	91

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	2	&	nace_both==	92

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	2	&	nace_both==	93

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	2	&	nace_both==	95

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	2	&	nace_both==	98

replace	tradexp=	.	if	cntry==	"IS"	&	essround==	2	&	nace_both==	99

replace	tradexp=	0.238338926	if	cntry==	"IT"	&	essround==	2	&	nace_both==	1

replace	tradexp=	1.242175187	if	cntry==	"IT"	&	essround==	2	&	nace_both==	2

replace	tradexp=	0.416490202	if	cntry==	"IT"	&	essround==	2	&	nace_both==	5

replace	tradexp=	162.7036908	if	cntry==	"IT"	&	essround==	2	&	nace_both==	10

replace	tradexp=	6.050882542	if	cntry==	"IT"	&	essround==	2	&	nace_both==	11

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	2	&	nace_both==	12

replace	tradexp=	39.15257169	if	cntry==	"IT"	&	essround==	2	&	nace_both==	13

replace	tradexp=	0.305798704	if	cntry==	"IT"	&	essround==	2	&	nace_both==	14

replace	tradexp=	0.317824018	if	cntry==	"IT"	&	essround==	2	&	nace_both==	15

replace	tradexp=	0.988948092	if	cntry==	"IT"	&	essround==	2	&	nace_both==	16

replace	tradexp=	0.626724746	if	cntry==	"IT"	&	essround==	2	&	nace_both==	17

replace	tradexp=	0.553386656	if	cntry==	"IT"	&	essround==	2	&	nace_both==	18

replace	tradexp=	0.673750428	if	cntry==	"IT"	&	essround==	2	&	nace_both==	19

replace	tradexp=	0.235828618	if	cntry==	"IT"	&	essround==	2	&	nace_both==	20

replace	tradexp=	0.50682289	if	cntry==	"IT"	&	essround==	2	&	nace_both==	21

replace	tradexp=	0.132782469	if	cntry==	"IT"	&	essround==	2	&	nace_both==	22

replace	tradexp=	0.336963211	if	cntry==	"IT"	&	essround==	2	&	nace_both==	23

replace	tradexp=	0.902499094	if	cntry==	"IT"	&	essround==	2	&	nace_both==	24

replace	tradexp=	0.438995554	if	cntry==	"IT"	&	essround==	2	&	nace_both==	25

replace	tradexp=	0.292877895	if	cntry==	"IT"	&	essround==	2	&	nace_both==	26

replace	tradexp=	0.919598512	if	cntry==	"IT"	&	essround==	2	&	nace_both==	27

replace	tradexp=	0.194051015	if	cntry==	"IT"	&	essround==	2	&	nace_both==	28

replace	tradexp=	0.740318506	if	cntry==	"IT"	&	essround==	2	&	nace_both==	29

replace	tradexp=	2.008766466	if	cntry==	"IT"	&	essround==	2	&	nace_both==	30

replace	tradexp=	0.520212382	if	cntry==	"IT"	&	essround==	2	&	nace_both==	31

replace	tradexp=	1.273779488	if	cntry==	"IT"	&	essround==	2	&	nace_both==	32

replace	tradexp=	1.00001663	if	cntry==	"IT"	&	essround==	2	&	nace_both==	33

replace	tradexp=	1.344666761	if	cntry==	"IT"	&	essround==	2	&	nace_both==	34

replace	tradexp=	0.780565756	if	cntry==	"IT"	&	essround==	2	&	nace_both==	35

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	2	&	nace_both==	36

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	2	&	nace_both==	37

replace	tradexp=	0.032078711	if	cntry==	"IT"	&	essround==	2	&	nace_both==	40

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	2	&	nace_both==	41

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	2	&	nace_both==	45

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	2	&	nace_both==	50

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	2	&	nace_both==	51

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	2	&	nace_both==	52

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	2	&	nace_both==	55

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	2	&	nace_both==	60

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	2	&	nace_both==	61

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	2	&	nace_both==	62

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	2	&	nace_both==	63

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	2	&	nace_both==	64

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	2	&	nace_both==	65

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	2	&	nace_both==	66

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	2	&	nace_both==	67

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	2	&	nace_both==	70

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	2	&	nace_both==	71

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	2	&	nace_both==	72

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	2	&	nace_both==	73

replace	tradexp=	0.000189588	if	cntry==	"IT"	&	essround==	2	&	nace_both==	74

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	2	&	nace_both==	75

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	2	&	nace_both==	80

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	2	&	nace_both==	85

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	2	&	nace_both==	90

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	2	&	nace_both==	91

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	2	&	nace_both==	92

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	2	&	nace_both==	93

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	2	&	nace_both==	95

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	2	&	nace_both==	98

replace	tradexp=	.	if	cntry==	"IT"	&	essround==	2	&	nace_both==	99

replace	tradexp=	1.448226004	if	cntry==	"LU"	&	essround==	2	&	nace_both==	1

replace	tradexp=	2.56097994	if	cntry==	"LU"	&	essround==	2	&	nace_both==	2

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	2	&	nace_both==	5

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	2	&	nace_both==	10

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	2	&	nace_both==	11

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	2	&	nace_both==	12

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	2	&	nace_both==	13

replace	tradexp=	0.993333697	if	cntry==	"LU"	&	essround==	2	&	nace_both==	14

replace	tradexp=	2.527215841	if	cntry==	"LU"	&	essround==	2	&	nace_both==	15

replace	tradexp=	2.314307498	if	cntry==	"LU"	&	essround==	2	&	nace_both==	16

replace	tradexp=	0.910222702	if	cntry==	"LU"	&	essround==	2	&	nace_both==	17

replace	tradexp=	126.126438	if	cntry==	"LU"	&	essround==	2	&	nace_both==	18

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	2	&	nace_both==	19

replace	tradexp=	1.543411808	if	cntry==	"LU"	&	essround==	2	&	nace_both==	20

replace	tradexp=	2.476610116	if	cntry==	"LU"	&	essround==	2	&	nace_both==	21

replace	tradexp=	1.015361502	if	cntry==	"LU"	&	essround==	2	&	nace_both==	22

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	2	&	nace_both==	23

replace	tradexp=	4.746759055	if	cntry==	"LU"	&	essround==	2	&	nace_both==	24

replace	tradexp=	1.532643332	if	cntry==	"LU"	&	essround==	2	&	nace_both==	25

replace	tradexp=	1.075784172	if	cntry==	"LU"	&	essround==	2	&	nace_both==	26

replace	tradexp=	1.939175908	if	cntry==	"LU"	&	essround==	2	&	nace_both==	27

replace	tradexp=	0.637075295	if	cntry==	"LU"	&	essround==	2	&	nace_both==	28

replace	tradexp=	2.98208811	if	cntry==	"LU"	&	essround==	2	&	nace_both==	29

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	2	&	nace_both==	30

replace	tradexp=	11.35553882	if	cntry==	"LU"	&	essround==	2	&	nace_both==	31

replace	tradexp=	373.4996254	if	cntry==	"LU"	&	essround==	2	&	nace_both==	32

replace	tradexp=	1.69501387	if	cntry==	"LU"	&	essround==	2	&	nace_both==	33

replace	tradexp=	41.41344776	if	cntry==	"LU"	&	essround==	2	&	nace_both==	34

replace	tradexp=	78.5138646	if	cntry==	"LU"	&	essround==	2	&	nace_both==	35

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	2	&	nace_both==	36

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	2	&	nace_both==	37

replace	tradexp=	0.065657249	if	cntry==	"LU"	&	essround==	2	&	nace_both==	40

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	2	&	nace_both==	41

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	2	&	nace_both==	45

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	2	&	nace_both==	50

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	2	&	nace_both==	51

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	2	&	nace_both==	52

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	2	&	nace_both==	55

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	2	&	nace_both==	60

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	2	&	nace_both==	61

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	2	&	nace_both==	62

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	2	&	nace_both==	63

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	2	&	nace_both==	64

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	2	&	nace_both==	65

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	2	&	nace_both==	66

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	2	&	nace_both==	67

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	2	&	nace_both==	70

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	2	&	nace_both==	71

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	2	&	nace_both==	72

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	2	&	nace_both==	73

replace	tradexp=	0.000645587	if	cntry==	"LU"	&	essround==	2	&	nace_both==	74

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	2	&	nace_both==	75

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	2	&	nace_both==	80

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	2	&	nace_both==	85

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	2	&	nace_both==	90

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	2	&	nace_both==	91

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	2	&	nace_both==	92

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	2	&	nace_both==	93

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	2	&	nace_both==	95

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	2	&	nace_both==	98

replace	tradexp=	.	if	cntry==	"LU"	&	essround==	2	&	nace_both==	99

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	2	&	nace_both==	1

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	2	&	nace_both==	2

replace	tradexp=	1.55412828	if	cntry==	"NL"	&	essround==	2	&	nace_both==	5

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	2	&	nace_both==	10

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	2	&	nace_both==	11

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	2	&	nace_both==	12

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	2	&	nace_both==	13

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	2	&	nace_both==	14

replace	tradexp=	0.912705327	if	cntry==	"NL"	&	essround==	2	&	nace_both==	15

replace	tradexp=	0.707191336	if	cntry==	"NL"	&	essround==	2	&	nace_both==	16

replace	tradexp=	2.363588586	if	cntry==	"NL"	&	essround==	2	&	nace_both==	17

replace	tradexp=	10.76307244	if	cntry==	"NL"	&	essround==	2	&	nace_both==	18

replace	tradexp=	9.072271588	if	cntry==	"NL"	&	essround==	2	&	nace_both==	19

replace	tradexp=	1.011882401	if	cntry==	"NL"	&	essround==	2	&	nace_both==	20

replace	tradexp=	1.478362023	if	cntry==	"NL"	&	essround==	2	&	nace_both==	21

replace	tradexp=	0.314569268	if	cntry==	"NL"	&	essround==	2	&	nace_both==	22

replace	tradexp=	1.167522338	if	cntry==	"NL"	&	essround==	2	&	nace_both==	23

replace	tradexp=	1.610856647	if	cntry==	"NL"	&	essround==	2	&	nace_both==	24

replace	tradexp=	1.668382644	if	cntry==	"NL"	&	essround==	2	&	nace_both==	25

replace	tradexp=	0.612307878	if	cntry==	"NL"	&	essround==	2	&	nace_both==	26

replace	tradexp=	2.268699734	if	cntry==	"NL"	&	essround==	2	&	nace_both==	27

replace	tradexp=	0.534095315	if	cntry==	"NL"	&	essround==	2	&	nace_both==	28

replace	tradexp=	1.480031246	if	cntry==	"NL"	&	essround==	2	&	nace_both==	29

replace	tradexp=	31.02853682	if	cntry==	"NL"	&	essround==	2	&	nace_both==	30

replace	tradexp=	3.083233321	if	cntry==	"NL"	&	essround==	2	&	nace_both==	31

replace	tradexp=	4.07627274	if	cntry==	"NL"	&	essround==	2	&	nace_both==	32

replace	tradexp=	4.856389735	if	cntry==	"NL"	&	essround==	2	&	nace_both==	33

replace	tradexp=	2.552081152	if	cntry==	"NL"	&	essround==	2	&	nace_both==	34

replace	tradexp=	1.38233351	if	cntry==	"NL"	&	essround==	2	&	nace_both==	35

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	2	&	nace_both==	36

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	2	&	nace_both==	37

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	2	&	nace_both==	40

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	2	&	nace_both==	41

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	2	&	nace_both==	45

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	2	&	nace_both==	50

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	2	&	nace_both==	51

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	2	&	nace_both==	52

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	2	&	nace_both==	55

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	2	&	nace_both==	60

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	2	&	nace_both==	61

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	2	&	nace_both==	62

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	2	&	nace_both==	63

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	2	&	nace_both==	64

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	2	&	nace_both==	65

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	2	&	nace_both==	66

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	2	&	nace_both==	67

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	2	&	nace_both==	70

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	2	&	nace_both==	71

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	2	&	nace_both==	72

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	2	&	nace_both==	73

replace	tradexp=	0.000173444	if	cntry==	"NL"	&	essround==	2	&	nace_both==	74

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	2	&	nace_both==	75

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	2	&	nace_both==	80

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	2	&	nace_both==	85

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	2	&	nace_both==	90

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	2	&	nace_both==	91

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	2	&	nace_both==	92

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	2	&	nace_both==	93

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	2	&	nace_both==	95

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	2	&	nace_both==	98

replace	tradexp=	.	if	cntry==	"NL"	&	essround==	2	&	nace_both==	99

replace	tradexp=	0.292836753	if	cntry==	"NO"	&	essround==	2	&	nace_both==	1

replace	tradexp=	0.219368707	if	cntry==	"NO"	&	essround==	2	&	nace_both==	2

replace	tradexp=	0.444303014	if	cntry==	"NO"	&	essround==	2	&	nace_both==	5

replace	tradexp=	0.473756934	if	cntry==	"NO"	&	essround==	2	&	nace_both==	10

replace	tradexp=	0.795666059	if	cntry==	"NO"	&	essround==	2	&	nace_both==	11

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	2	&	nace_both==	12

replace	tradexp=	2.282014369	if	cntry==	"NO"	&	essround==	2	&	nace_both==	13

replace	tradexp=	0.589955593	if	cntry==	"NO"	&	essround==	2	&	nace_both==	14

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	2	&	nace_both==	15

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	2	&	nace_both==	16

replace	tradexp=	2.34813213	if	cntry==	"NO"	&	essround==	2	&	nace_both==	17

replace	tradexp=	7.306730155	if	cntry==	"NO"	&	essround==	2	&	nace_both==	18

replace	tradexp=	11.69403521	if	cntry==	"NO"	&	essround==	2	&	nace_both==	19

replace	tradexp=	0.413911431	if	cntry==	"NO"	&	essround==	2	&	nace_both==	20

replace	tradexp=	0.924739572	if	cntry==	"NO"	&	essround==	2	&	nace_both==	21

replace	tradexp=	0.160849797	if	cntry==	"NO"	&	essround==	2	&	nace_both==	22

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	2	&	nace_both==	23

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	2	&	nace_both==	24

replace	tradexp=	1.620209837	if	cntry==	"NO"	&	essround==	2	&	nace_both==	25

replace	tradexp=	0.422145133	if	cntry==	"NO"	&	essround==	2	&	nace_both==	26

replace	tradexp=	1.436374104	if	cntry==	"NO"	&	essround==	2	&	nace_both==	27

replace	tradexp=	0.877897562	if	cntry==	"NO"	&	essround==	2	&	nace_both==	28

replace	tradexp=	1.593523542	if	cntry==	"NO"	&	essround==	2	&	nace_both==	29

replace	tradexp=	44.25208758	if	cntry==	"NO"	&	essround==	2	&	nace_both==	30

replace	tradexp=	1.502699083	if	cntry==	"NO"	&	essround==	2	&	nace_both==	31

replace	tradexp=	2.585744497	if	cntry==	"NO"	&	essround==	2	&	nace_both==	32

replace	tradexp=	1.381523512	if	cntry==	"NO"	&	essround==	2	&	nace_both==	33

replace	tradexp=	5.465404084	if	cntry==	"NO"	&	essround==	2	&	nace_both==	34

replace	tradexp=	0.497705691	if	cntry==	"NO"	&	essround==	2	&	nace_both==	35

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	2	&	nace_both==	36

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	2	&	nace_both==	37

replace	tradexp=	0.097831954	if	cntry==	"NO"	&	essround==	2	&	nace_both==	40

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	2	&	nace_both==	41

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	2	&	nace_both==	45

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	2	&	nace_both==	50

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	2	&	nace_both==	51

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	2	&	nace_both==	52

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	2	&	nace_both==	55

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	2	&	nace_both==	60

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	2	&	nace_both==	61

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	2	&	nace_both==	62

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	2	&	nace_both==	63

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	2	&	nace_both==	64

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	2	&	nace_both==	65

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	2	&	nace_both==	66

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	2	&	nace_both==	67

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	2	&	nace_both==	70

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	2	&	nace_both==	71

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	2	&	nace_both==	72

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	2	&	nace_both==	73

replace	tradexp=	0.000840768	if	cntry==	"NO"	&	essround==	2	&	nace_both==	74

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	2	&	nace_both==	75

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	2	&	nace_both==	80

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	2	&	nace_both==	85

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	2	&	nace_both==	90

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	2	&	nace_both==	91

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	2	&	nace_both==	92

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	2	&	nace_both==	93

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	2	&	nace_both==	95

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	2	&	nace_both==	98

replace	tradexp=	.	if	cntry==	"NO"	&	essround==	2	&	nace_both==	99

replace	tradexp=	0.915316253	if	cntry==	"PL"	&	essround==	2	&	nace_both==	1

replace	tradexp=	0.934156418	if	cntry==	"PL"	&	essround==	2	&	nace_both==	2

replace	tradexp=	1.761320658	if	cntry==	"PL"	&	essround==	2	&	nace_both==	5

replace	tradexp=	0.840145876	if	cntry==	"PL"	&	essround==	2	&	nace_both==	10

replace	tradexp=	52.23381937	if	cntry==	"PL"	&	essround==	2	&	nace_both==	11

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	2	&	nace_both==	12

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	2	&	nace_both==	13

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	2	&	nace_both==	14

replace	tradexp=	0.938555275	if	cntry==	"PL"	&	essround==	2	&	nace_both==	15

replace	tradexp=	0.975886715	if	cntry==	"PL"	&	essround==	2	&	nace_both==	16

replace	tradexp=	2.053319035	if	cntry==	"PL"	&	essround==	2	&	nace_both==	17

replace	tradexp=	1.229872746	if	cntry==	"PL"	&	essround==	2	&	nace_both==	18

replace	tradexp=	2.097974122	if	cntry==	"PL"	&	essround==	2	&	nace_both==	19

replace	tradexp=	0.882416415	if	cntry==	"PL"	&	essround==	2	&	nace_both==	20

replace	tradexp=	1.439616035	if	cntry==	"PL"	&	essround==	2	&	nace_both==	21

replace	tradexp=	1.057338903	if	cntry==	"PL"	&	essround==	2	&	nace_both==	22

replace	tradexp=	0.777877644	if	cntry==	"PL"	&	essround==	2	&	nace_both==	23

replace	tradexp=	1.716559673	if	cntry==	"PL"	&	essround==	2	&	nace_both==	24

replace	tradexp=	1.187628556	if	cntry==	"PL"	&	essround==	2	&	nace_both==	25

replace	tradexp=	1.025519405	if	cntry==	"PL"	&	essround==	2	&	nace_both==	26

replace	tradexp=	1.161349303	if	cntry==	"PL"	&	essround==	2	&	nace_both==	27

replace	tradexp=	0.998657103	if	cntry==	"PL"	&	essround==	2	&	nace_both==	28

replace	tradexp=	1.851307191	if	cntry==	"PL"	&	essround==	2	&	nace_both==	29

replace	tradexp=	6.764421125	if	cntry==	"PL"	&	essround==	2	&	nace_both==	30

replace	tradexp=	1.332622206	if	cntry==	"PL"	&	essround==	2	&	nace_both==	31

replace	tradexp=	2.038583671	if	cntry==	"PL"	&	essround==	2	&	nace_both==	32

replace	tradexp=	1.87072972	if	cntry==	"PL"	&	essround==	2	&	nace_both==	33

replace	tradexp=	1.095856726	if	cntry==	"PL"	&	essround==	2	&	nace_both==	34

replace	tradexp=	1.83266608	if	cntry==	"PL"	&	essround==	2	&	nace_both==	35

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	2	&	nace_both==	36

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	2	&	nace_both==	37

replace	tradexp=	0.936657047	if	cntry==	"PL"	&	essround==	2	&	nace_both==	40

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	2	&	nace_both==	41

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	2	&	nace_both==	45

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	2	&	nace_both==	50

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	2	&	nace_both==	51

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	2	&	nace_both==	52

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	2	&	nace_both==	55

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	2	&	nace_both==	60

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	2	&	nace_both==	61

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	2	&	nace_both==	62

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	2	&	nace_both==	63

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	2	&	nace_both==	64

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	2	&	nace_both==	65

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	2	&	nace_both==	66

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	2	&	nace_both==	67

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	2	&	nace_both==	70

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	2	&	nace_both==	71

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	2	&	nace_both==	72

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	2	&	nace_both==	73

replace	tradexp=	0.870379229	if	cntry==	"PL"	&	essround==	2	&	nace_both==	74

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	2	&	nace_both==	75

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	2	&	nace_both==	80

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	2	&	nace_both==	85

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	2	&	nace_both==	90

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	2	&	nace_both==	91

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	2	&	nace_both==	92

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	2	&	nace_both==	93

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	2	&	nace_both==	95

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	2	&	nace_both==	98

replace	tradexp=	.	if	cntry==	"PL"	&	essround==	2	&	nace_both==	99

replace	tradexp=	0.307715577	if	cntry==	"PT"	&	essround==	2	&	nace_both==	1

replace	tradexp=	0.269264319	if	cntry==	"PT"	&	essround==	2	&	nace_both==	2

replace	tradexp=	0.419742789	if	cntry==	"PT"	&	essround==	2	&	nace_both==	5

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	2	&	nace_both==	10

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	2	&	nace_both==	11

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	2	&	nace_both==	12

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	2	&	nace_both==	13

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	2	&	nace_both==	14

replace	tradexp=	0.451828896	if	cntry==	"PT"	&	essround==	2	&	nace_both==	15

replace	tradexp=	0.404792321	if	cntry==	"PT"	&	essround==	2	&	nace_both==	16

replace	tradexp=	0.983357182	if	cntry==	"PT"	&	essround==	2	&	nace_both==	17

replace	tradexp=	0.574284567	if	cntry==	"PT"	&	essround==	2	&	nace_both==	18

replace	tradexp=	0.930510744	if	cntry==	"PT"	&	essround==	2	&	nace_both==	19

replace	tradexp=	0.524183627	if	cntry==	"PT"	&	essround==	2	&	nace_both==	20

replace	tradexp=	0.978181305	if	cntry==	"PT"	&	essround==	2	&	nace_both==	21

replace	tradexp=	0.174895702	if	cntry==	"PT"	&	essround==	2	&	nace_both==	22

replace	tradexp=	0.472704586	if	cntry==	"PT"	&	essround==	2	&	nace_both==	23

replace	tradexp=	1.628944669	if	cntry==	"PT"	&	essround==	2	&	nace_both==	24

replace	tradexp=	1.032306559	if	cntry==	"PT"	&	essround==	2	&	nace_both==	25

replace	tradexp=	0.31726699	if	cntry==	"PT"	&	essround==	2	&	nace_both==	26

replace	tradexp=	1.919380621	if	cntry==	"PT"	&	essround==	2	&	nace_both==	27

replace	tradexp=	0.464800185	if	cntry==	"PT"	&	essround==	2	&	nace_both==	28

replace	tradexp=	1.580788065	if	cntry==	"PT"	&	essround==	2	&	nace_both==	29

replace	tradexp=	11.59011929	if	cntry==	"PT"	&	essround==	2	&	nace_both==	30

replace	tradexp=	1.277542464	if	cntry==	"PT"	&	essround==	2	&	nace_both==	31

replace	tradexp=	1.663122942	if	cntry==	"PT"	&	essround==	2	&	nace_both==	32

replace	tradexp=	2.133298684	if	cntry==	"PT"	&	essround==	2	&	nace_both==	33

replace	tradexp=	2.158241242	if	cntry==	"PT"	&	essround==	2	&	nace_both==	34

replace	tradexp=	2.089635729	if	cntry==	"PT"	&	essround==	2	&	nace_both==	35

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	2	&	nace_both==	36

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	2	&	nace_both==	37

replace	tradexp=	0.026629284	if	cntry==	"PT"	&	essround==	2	&	nace_both==	40

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	2	&	nace_both==	41

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	2	&	nace_both==	45

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	2	&	nace_both==	50

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	2	&	nace_both==	51

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	2	&	nace_both==	52

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	2	&	nace_both==	55

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	2	&	nace_both==	60

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	2	&	nace_both==	61

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	2	&	nace_both==	62

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	2	&	nace_both==	63

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	2	&	nace_both==	64

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	2	&	nace_both==	65

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	2	&	nace_both==	66

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	2	&	nace_both==	67

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	2	&	nace_both==	70

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	2	&	nace_both==	71

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	2	&	nace_both==	72

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	2	&	nace_both==	73

replace	tradexp=	0.000119204	if	cntry==	"PT"	&	essround==	2	&	nace_both==	74

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	2	&	nace_both==	75

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	2	&	nace_both==	80

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	2	&	nace_both==	85

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	2	&	nace_both==	90

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	2	&	nace_both==	91

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	2	&	nace_both==	92

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	2	&	nace_both==	93

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	2	&	nace_both==	95

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	2	&	nace_both==	98

replace	tradexp=	.	if	cntry==	"PT"	&	essround==	2	&	nace_both==	99

replace	tradexp=	0.372054295	if	cntry==	"SE"	&	essround==	2	&	nace_both==	1

replace	tradexp=	0.149964031	if	cntry==	"SE"	&	essround==	2	&	nace_both==	2

replace	tradexp=	6.149285528	if	cntry==	"SE"	&	essround==	2	&	nace_both==	5

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	2	&	nace_both==	10

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	2	&	nace_both==	11

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	2	&	nace_both==	12

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	2	&	nace_both==	13

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	2	&	nace_both==	14

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	2	&	nace_both==	15

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	2	&	nace_both==	16

replace	tradexp=	2.732909504	if	cntry==	"SE"	&	essround==	2	&	nace_both==	17

replace	tradexp=	6.378938504	if	cntry==	"SE"	&	essround==	2	&	nace_both==	18

replace	tradexp=	4.939978301	if	cntry==	"SE"	&	essround==	2	&	nace_both==	19

replace	tradexp=	0.482878988	if	cntry==	"SE"	&	essround==	2	&	nace_both==	20

replace	tradexp=	0.837237329	if	cntry==	"SE"	&	essround==	2	&	nace_both==	21

replace	tradexp=	0.218610701	if	cntry==	"SE"	&	essround==	2	&	nace_both==	22

replace	tradexp=	1.188715813	if	cntry==	"SE"	&	essround==	2	&	nace_both==	23

replace	tradexp=	1.327999584	if	cntry==	"SE"	&	essround==	2	&	nace_both==	24

replace	tradexp=	1.229254373	if	cntry==	"SE"	&	essround==	2	&	nace_both==	25

replace	tradexp=	0.643105169	if	cntry==	"SE"	&	essround==	2	&	nace_both==	26

replace	tradexp=	1.056984367	if	cntry==	"SE"	&	essround==	2	&	nace_both==	27

replace	tradexp=	0.516692778	if	cntry==	"SE"	&	essround==	2	&	nace_both==	28

replace	tradexp=	1.064518713	if	cntry==	"SE"	&	essround==	2	&	nace_both==	29

replace	tradexp=	6.855142658	if	cntry==	"SE"	&	essround==	2	&	nace_both==	30

replace	tradexp=	1.630119167	if	cntry==	"SE"	&	essround==	2	&	nace_both==	31

replace	tradexp=	1.425167076	if	cntry==	"SE"	&	essround==	2	&	nace_both==	32

replace	tradexp=	1.197532243	if	cntry==	"SE"	&	essround==	2	&	nace_both==	33

replace	tradexp=	0.868219008	if	cntry==	"SE"	&	essround==	2	&	nace_both==	34

replace	tradexp=	1.015693745	if	cntry==	"SE"	&	essround==	2	&	nace_both==	35

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	2	&	nace_both==	36

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	2	&	nace_both==	37

replace	tradexp=	0.078352783	if	cntry==	"SE"	&	essround==	2	&	nace_both==	40

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	2	&	nace_both==	41

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	2	&	nace_both==	45

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	2	&	nace_both==	50

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	2	&	nace_both==	51

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	2	&	nace_both==	52

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	2	&	nace_both==	55

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	2	&	nace_both==	60

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	2	&	nace_both==	61

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	2	&	nace_both==	62

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	2	&	nace_both==	63

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	2	&	nace_both==	64

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	2	&	nace_both==	65

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	2	&	nace_both==	66

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	2	&	nace_both==	67

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	2	&	nace_both==	70

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	2	&	nace_both==	71

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	2	&	nace_both==	72

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	2	&	nace_both==	73

replace	tradexp=	0.000397101	if	cntry==	"SE"	&	essround==	2	&	nace_both==	74

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	2	&	nace_both==	75

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	2	&	nace_both==	80

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	2	&	nace_both==	85

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	2	&	nace_both==	90

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	2	&	nace_both==	91

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	2	&	nace_both==	92

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	2	&	nace_both==	93

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	2	&	nace_both==	95

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	2	&	nace_both==	98

replace	tradexp=	.	if	cntry==	"SE"	&	essround==	2	&	nace_both==	99

replace	tradexp=	0.228151516	if	cntry==	"SK"	&	essround==	2	&	nace_both==	1

replace	tradexp=	0.189989902	if	cntry==	"SK"	&	essround==	2	&	nace_both==	2

replace	tradexp=	1.775598678	if	cntry==	"SK"	&	essround==	2	&	nace_both==	5

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	2	&	nace_both==	10

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	2	&	nace_both==	11

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	2	&	nace_both==	12

replace	tradexp=	18.85444554	if	cntry==	"SK"	&	essround==	2	&	nace_both==	13

replace	tradexp=	1.441336744	if	cntry==	"SK"	&	essround==	2	&	nace_both==	14

replace	tradexp=	0.523179382	if	cntry==	"SK"	&	essround==	2	&	nace_both==	15

replace	tradexp=	2.389001886	if	cntry==	"SK"	&	essround==	2	&	nace_both==	16

replace	tradexp=	3.096743529	if	cntry==	"SK"	&	essround==	2	&	nace_both==	17

replace	tradexp=	1.503358273	if	cntry==	"SK"	&	essround==	2	&	nace_both==	18

replace	tradexp=	1.609668156	if	cntry==	"SK"	&	essround==	2	&	nace_both==	19

replace	tradexp=	0.613298797	if	cntry==	"SK"	&	essround==	2	&	nace_both==	20

replace	tradexp=	1.424999482	if	cntry==	"SK"	&	essround==	2	&	nace_both==	21

replace	tradexp=	0.423249466	if	cntry==	"SK"	&	essround==	2	&	nace_both==	22

replace	tradexp=	0.784750417	if	cntry==	"SK"	&	essround==	2	&	nace_both==	23

replace	tradexp=	2.87221079	if	cntry==	"SK"	&	essround==	2	&	nace_both==	24

replace	tradexp=	1.6557413	if	cntry==	"SK"	&	essround==	2	&	nace_both==	25

replace	tradexp=	0.768384252	if	cntry==	"SK"	&	essround==	2	&	nace_both==	26

replace	tradexp=	1.231257186	if	cntry==	"SK"	&	essround==	2	&	nace_both==	27

replace	tradexp=	1.06014492	if	cntry==	"SK"	&	essround==	2	&	nace_both==	28

replace	tradexp=	1.988809292	if	cntry==	"SK"	&	essround==	2	&	nace_both==	29

replace	tradexp=	1.449402536	if	cntry==	"SK"	&	essround==	2	&	nace_both==	30

replace	tradexp=	1.790323438	if	cntry==	"SK"	&	essround==	2	&	nace_both==	31

replace	tradexp=	3.306901081	if	cntry==	"SK"	&	essround==	2	&	nace_both==	32

replace	tradexp=	3.355722846	if	cntry==	"SK"	&	essround==	2	&	nace_both==	33

replace	tradexp=	1.585555311	if	cntry==	"SK"	&	essround==	2	&	nace_both==	34

replace	tradexp=	1.141286231	if	cntry==	"SK"	&	essround==	2	&	nace_both==	35

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	2	&	nace_both==	36

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	2	&	nace_both==	37

replace	tradexp=	0.078877241	if	cntry==	"SK"	&	essround==	2	&	nace_both==	40

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	2	&	nace_both==	41

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	2	&	nace_both==	45

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	2	&	nace_both==	50

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	2	&	nace_both==	51

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	2	&	nace_both==	52

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	2	&	nace_both==	55

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	2	&	nace_both==	60

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	2	&	nace_both==	61

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	2	&	nace_both==	62

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	2	&	nace_both==	63

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	2	&	nace_both==	64

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	2	&	nace_both==	65

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	2	&	nace_both==	66

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	2	&	nace_both==	67

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	2	&	nace_both==	70

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	2	&	nace_both==	71

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	2	&	nace_both==	72

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	2	&	nace_both==	73

replace	tradexp=	0.002794694	if	cntry==	"SK"	&	essround==	2	&	nace_both==	74

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	2	&	nace_both==	75

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	2	&	nace_both==	80

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	2	&	nace_both==	85

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	2	&	nace_both==	90

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	2	&	nace_both==	91

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	2	&	nace_both==	92

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	2	&	nace_both==	93

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	2	&	nace_both==	95

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	2	&	nace_both==	98

replace	tradexp=	.	if	cntry==	"SK"	&	essround==	2	&	nace_both==	99

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	1

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	2

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	5

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	10

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	11

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	12

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	13

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	14

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	15

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	16

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	17

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	18

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	19

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	20

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	21

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	22

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	23

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	24

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	25

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	26

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	27

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	28

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	29

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	30

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	31

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	32

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	33

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	34

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	35

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	36

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	37

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	40

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	41

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	45

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	50

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	51

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	52

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	55

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	60

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	61

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	62

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	63

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	64

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	65

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	66

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	67

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	70

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	71

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	72

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	73

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	74

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	75

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	80

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	85

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	90

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	91

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	92

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	93

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	95

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	98

replace	tradexp=	.	if	cntry==	"TR"	&	essround==	2	&	nace_both==	99



* --------------------------------------------------------------------------------
* 1.2.1.1 Recoding: Inclusion of OECD industries' comparative adv. data 
* --------------------------------------------------------------------------------

gen c_adv=.

replace	c_adv=	0 if cntry== "AT" & essround== 1 & nace_both== 1

replace	c_adv=	0 if cntry== "BE" & essround== 1 & nace_both== 1

replace	c_adv=	0 if cntry== "CZ" & essround== 1 & nace_both== 1

replace	c_adv=	1 if cntry== "DK" & essround== 1 & nace_both== 1

replace	c_adv=	0 if cntry== "FI" & essround== 1 & nace_both== 1

replace	c_adv=	1 if cntry== "FR" & essround== 1 & nace_both== 1

replace	c_adv=	0 if cntry== "DE" & essround== 1 & nace_both== 1

replace	c_adv=	1 if cntry== "GR" & essround== 1 & nace_both== 1

replace	c_adv=	1 if cntry== "HU" & essround== 1 & nace_both== 1

replace	c_adv=	-1 if cntry== "IS" & essround== 1 & nace_both== 1

replace	c_adv=	-1 if cntry== "IE" & essround== 1 & nace_both== 1

replace	c_adv=	-1 if cntry== "IT" & essround== 1 & nace_both== 1

replace	c_adv=	-1 if cntry== "LU" & essround== 1 & nace_both== 1

replace	c_adv=	1 if cntry== "NL" & essround== 1 & nace_both== 1

replace	c_adv=	0 if cntry== "NO" & essround== 1 & nace_both== 1

replace	c_adv=	-1 if cntry== "PL" & essround== 1 & nace_both== 1

replace	c_adv=	-1 if cntry== "PT" & essround== 1 & nace_both== 1

replace	c_adv=	-1 if cntry== "SK" & essround== 1 & nace_both== 1

replace	c_adv=	1 if cntry== "ES" & essround== 1 & nace_both== 1

replace	c_adv=	-1 if cntry== "SE" & essround== 1 & nace_both== 1

replace	c_adv=	0 if cntry== "CH" & essround== 1 & nace_both== 1

replace	c_adv=	1 if cntry== "TR" & essround== 1 & nace_both== 1

replace	c_adv=	-1 if cntry== "GB" & essround== 1 & nace_both== 1

replace	c_adv=	1 if cntry== "AT" & essround== 1 & nace_both== 2

replace	c_adv=	-1 if cntry== "BE" & essround== 1 & nace_both== 2

replace	c_adv=	1 if cntry== "CZ" & essround== 1 & nace_both== 2

replace	c_adv=	1 if cntry== "DK" & essround== 1 & nace_both== 2

replace	c_adv=	-1 if cntry== "FI" & essround== 1 & nace_both== 2

replace	c_adv=	1 if cntry== "FR" & essround== 1 & nace_both== 2

replace	c_adv=	-1 if cntry== "DE" & essround== 1 & nace_both== 2

replace	c_adv=	-1 if cntry== "GR" & essround== 1 & nace_both== 2

replace	c_adv=	1 if cntry== "HU" & essround== 1 & nace_both== 2

replace	c_adv=	0 if cntry== "IS" & essround== 1 & nace_both== 2

replace	c_adv=	-1 if cntry== "IE" & essround== 1 & nace_both== 2

replace	c_adv=	-1 if cntry== "IT" & essround== 1 & nace_both== 2

replace	c_adv=	1 if cntry== "LU" & essround== 1 & nace_both== 2

replace	c_adv=	-1 if cntry== "NL" & essround== 1 & nace_both== 2

replace	c_adv=	-1 if cntry== "NO" & essround== 1 & nace_both== 2

replace	c_adv=	1 if cntry== "PL" & essround== 1 & nace_both== 2

replace	c_adv=	1 if cntry== "PT" & essround== 1 & nace_both== 2

replace	c_adv=	1 if cntry== "SK" & essround== 1 & nace_both== 2

replace	c_adv=	-1 if cntry== "ES" & essround== 1 & nace_both== 2

replace	c_adv=	1 if cntry== "SE" & essround== 1 & nace_both== 2

replace	c_adv=	1 if cntry== "CH" & essround== 1 & nace_both== 2

replace	c_adv=	-1 if cntry== "TR" & essround== 1 & nace_both== 2

replace	c_adv=	-1 if cntry== "GB" & essround== 1 & nace_both== 2

replace	c_adv=	0 if cntry== "AT" & essround== 1 & nace_both== 5

replace	c_adv=	-1 if cntry== "BE" & essround== 1 & nace_both== 5

replace	c_adv=	-1 if cntry== "CZ" & essround== 1 & nace_both== 5

replace	c_adv=	1 if cntry== "DK" & essround== 1 & nace_both== 5

replace	c_adv=	0 if cntry== "FI" & essround== 1 & nace_both== 5

replace	c_adv=	1 if cntry== "FR" & essround== 1 & nace_both== 5

replace	c_adv=	-1 if cntry== "DE" & essround== 1 & nace_both== 5

replace	c_adv=	1 if cntry== "GR" & essround== 1 & nace_both== 5

replace	c_adv=	-1 if cntry== "HU" & essround== 1 & nace_both== 5

replace	c_adv=	1 if cntry== "IS" & essround== 1 & nace_both== 5

replace	c_adv=	1 if cntry== "IE" & essround== 1 & nace_both== 5

replace	c_adv=	-1 if cntry== "IT" & essround== 1 & nace_both== 5

replace	c_adv=	-1 if cntry== "LU" & essround== 1 & nace_both== 5

replace	c_adv=	1 if cntry== "NL" & essround== 1 & nace_both== 5

replace	c_adv=	1 if cntry== "NO" & essround== 1 & nace_both== 5

replace	c_adv=	-1 if cntry== "PL" & essround== 1 & nace_both== 5

replace	c_adv=	1 if cntry== "PT" & essround== 1 & nace_both== 5

replace	c_adv=	-1 if cntry== "SK" & essround== 1 & nace_both== 5

replace	c_adv=	1 if cntry== "ES" & essround== 1 & nace_both== 5

replace	c_adv=	1 if cntry== "SE" & essround== 1 & nace_both== 5

replace	c_adv=	-1 if cntry== "CH" & essround== 1 & nace_both== 5

replace	c_adv=	-1 if cntry== "TR" & essround== 1 & nace_both== 5

replace	c_adv=	1 if cntry== "GB" & essround== 1 & nace_both== 5

replace	c_adv=	0 if cntry== "AT" & essround== 1 & nace_both== 10

replace	c_adv=	-1 if cntry== "BE" & essround== 1 & nace_both== 10

replace	c_adv=	1 if cntry== "CZ" & essround== 1 & nace_both== 10

replace	c_adv=	-1 if cntry== "DK" & essround== 1 & nace_both== 10

replace	c_adv=	-1 if cntry== "FI" & essround== 1 & nace_both== 10

replace	c_adv=	0 if cntry== "FR" & essround== 1 & nace_both== 10

replace	c_adv=	-1 if cntry== "DE" & essround== 1 & nace_both== 10

replace	c_adv=	-1 if cntry== "GR" & essround== 1 & nace_both== 10

replace	c_adv=	0 if cntry== "HU" & essround== 1 & nace_both== 10

replace	c_adv=	0 if cntry== "IS" & essround== 1 & nace_both== 10

replace	c_adv=	-1 if cntry== "IE" & essround== 1 & nace_both== 10

replace	c_adv=	0 if cntry== "IT" & essround== 1 & nace_both== 10

replace	c_adv=	0 if cntry== "LU" & essround== 1 & nace_both== 10

replace	c_adv=	-1 if cntry== "NL" & essround== 1 & nace_both== 10

replace	c_adv=	0 if cntry== "NO" & essround== 1 & nace_both== 10

replace	c_adv=	1 if cntry== "PL" & essround== 1 & nace_both== 10

replace	c_adv=	0 if cntry== "PT" & essround== 1 & nace_both== 10

replace	c_adv=	0 if cntry== "SK" & essround== 1 & nace_both== 10

replace	c_adv=	0 if cntry== "ES" & essround== 1 & nace_both== 10

replace	c_adv=	0 if cntry== "SE" & essround== 1 & nace_both== 10

replace	c_adv=	0 if cntry== "CH" & essround== 1 & nace_both== 10

replace	c_adv=	0 if cntry== "TR" & essround== 1 & nace_both== 10

replace	c_adv=	-1 if cntry== "GB" & essround== 1 & nace_both== 10

replace	c_adv=	0 if cntry== "AT" & essround== 1 & nace_both== 11

replace	c_adv=	-1 if cntry== "BE" & essround== 1 & nace_both== 11

replace	c_adv=	0 if cntry== "CZ" & essround== 1 & nace_both== 11

replace	c_adv=	1 if cntry== "DK" & essround== 1 & nace_both== 11

replace	c_adv=	0 if cntry== "FI" & essround== 1 & nace_both== 11

replace	c_adv=	0 if cntry== "FR" & essround== 1 & nace_both== 11

replace	c_adv=	0 if cntry== "DE" & essround== 1 & nace_both== 11

replace	c_adv=	0 if cntry== "GR" & essround== 1 & nace_both== 11

replace	c_adv=	0 if cntry== "HU" & essround== 1 & nace_both== 11

replace	c_adv=	0 if cntry== "IS" & essround== 1 & nace_both== 11

replace	c_adv=	0 if cntry== "IE" & essround== 1 & nace_both== 11

replace	c_adv=	0 if cntry== "IT" & essround== 1 & nace_both== 11

replace	c_adv=	0 if cntry== "LU" & essround== 1 & nace_both== 11

replace	c_adv=	0 if cntry== "NL" & essround== 1 & nace_both== 11

replace	c_adv=	1 if cntry== "NO" & essround== 1 & nace_both== 11

replace	c_adv=	-1 if cntry== "PL" & essround== 1 & nace_both== 11

replace	c_adv=	0 if cntry== "PT" & essround== 1 & nace_both== 11

replace	c_adv=	0 if cntry== "SK" & essround== 1 & nace_both== 11

replace	c_adv=	-1 if cntry== "ES" & essround== 1 & nace_both== 11

replace	c_adv=	0 if cntry== "SE" & essround== 1 & nace_both== 11

replace	c_adv=	0 if cntry== "CH" & essround== 1 & nace_both== 11

replace	c_adv=	0 if cntry== "TR" & essround== 1 & nace_both== 11

replace	c_adv=	1 if cntry== "GB" & essround== 1 & nace_both== 11

replace	c_adv=	0 if cntry== "AT" & essround== 1 & nace_both== 12

replace	c_adv=	-1 if cntry== "BE" & essround== 1 & nace_both== 12

replace	c_adv=	0 if cntry== "CZ" & essround== 1 & nace_both== 12

replace	c_adv=	0 if cntry== "DK" & essround== 1 & nace_both== 12

replace	c_adv=	0 if cntry== "FI" & essround== 1 & nace_both== 12

replace	c_adv=	0 if cntry== "FR" & essround== 1 & nace_both== 12

replace	c_adv=	0 if cntry== "DE" & essround== 1 & nace_both== 12

replace	c_adv=	0 if cntry== "GR" & essround== 1 & nace_both== 12

replace	c_adv=	0 if cntry== "HU" & essround== 1 & nace_both== 12

replace	c_adv=	0 if cntry== "IS" & essround== 1 & nace_both== 12

replace	c_adv=	0 if cntry== "IE" & essround== 1 & nace_both== 12

replace	c_adv=	-1 if cntry== "IT" & essround== 1 & nace_both== 12

replace	c_adv=	0 if cntry== "LU" & essround== 1 & nace_both== 12

replace	c_adv=	0 if cntry== "NL" & essround== 1 & nace_both== 12

replace	c_adv=	0 if cntry== "NO" & essround== 1 & nace_both== 12

replace	c_adv=	0 if cntry== "PL" & essround== 1 & nace_both== 12

replace	c_adv=	0 if cntry== "PT" & essround== 1 & nace_both== 12

replace	c_adv=	0 if cntry== "SK" & essround== 1 & nace_both== 12

replace	c_adv=	0 if cntry== "ES" & essround== 1 & nace_both== 12

replace	c_adv=	0 if cntry== "SE" & essround== 1 & nace_both== 12

replace	c_adv=	0 if cntry== "CH" & essround== 1 & nace_both== 12

replace	c_adv=	0 if cntry== "TR" & essround== 1 & nace_both== 12

replace	c_adv=	0 if cntry== "GB" & essround== 1 & nace_both== 12

replace	c_adv=	0 if cntry== "AT" & essround== 1 & nace_both== 13

replace	c_adv=	-1 if cntry== "BE" & essround== 1 & nace_both== 13

replace	c_adv=	0 if cntry== "CZ" & essround== 1 & nace_both== 13

replace	c_adv=	0 if cntry== "DK" & essround== 1 & nace_both== 13

replace	c_adv=	-1 if cntry== "FI" & essround== 1 & nace_both== 13

replace	c_adv=	-1 if cntry== "FR" & essround== 1 & nace_both== 13

replace	c_adv=	-1 if cntry== "DE" & essround== 1 & nace_both== 13

replace	c_adv=	1 if cntry== "GR" & essround== 1 & nace_both== 13

replace	c_adv=	0 if cntry== "HU" & essround== 1 & nace_both== 13

replace	c_adv=	0 if cntry== "IS" & essround== 1 & nace_both== 13

replace	c_adv=	-1 if cntry== "IE" & essround== 1 & nace_both== 13

replace	c_adv=	-1 if cntry== "IT" & essround== 1 & nace_both== 13

replace	c_adv=	-1 if cntry== "LU" & essround== 1 & nace_both== 13

replace	c_adv=	-1 if cntry== "NL" & essround== 1 & nace_both== 13

replace	c_adv=	-1 if cntry== "NO" & essround== 1 & nace_both== 13

replace	c_adv=	-1 if cntry== "PL" & essround== 1 & nace_both== 13

replace	c_adv=	1 if cntry== "PT" & essround== 1 & nace_both== 13

replace	c_adv=	-1 if cntry== "SK" & essround== 1 & nace_both== 13

replace	c_adv=	-1 if cntry== "ES" & essround== 1 & nace_both== 13

replace	c_adv=	1 if cntry== "SE" & essround== 1 & nace_both== 13

replace	c_adv=	0 if cntry== "CH" & essround== 1 & nace_both== 13

replace	c_adv=	1 if cntry== "TR" & essround== 1 & nace_both== 13

replace	c_adv=	0 if cntry== "GB" & essround== 1 & nace_both== 13

replace	c_adv=	-1 if cntry== "AT" & essround== 1 & nace_both== 14

replace	c_adv=	1 if cntry== "BE" & essround== 1 & nace_both== 14

replace	c_adv=	-1 if cntry== "CZ" & essround== 1 & nace_both== 14

replace	c_adv=	-1 if cntry== "DK" & essround== 1 & nace_both== 14

replace	c_adv=	-1 if cntry== "FI" & essround== 1 & nace_both== 14

replace	c_adv=	-1 if cntry== "FR" & essround== 1 & nace_both== 14

replace	c_adv=	-1 if cntry== "DE" & essround== 1 & nace_both== 14

replace	c_adv=	1 if cntry== "GR" & essround== 1 & nace_both== 14

replace	c_adv=	-1 if cntry== "HU" & essround== 1 & nace_both== 14

replace	c_adv=	-1 if cntry== "IS" & essround== 1 & nace_both== 14

replace	c_adv=	-1 if cntry== "IE" & essround== 1 & nace_both== 14

replace	c_adv=	-1 if cntry== "IT" & essround== 1 & nace_both== 14

replace	c_adv=	-1 if cntry== "LU" & essround== 1 & nace_both== 14

replace	c_adv=	-1 if cntry== "NL" & essround== 1 & nace_both== 14

replace	c_adv=	-1 if cntry== "NO" & essround== 1 & nace_both== 14

replace	c_adv=	-1 if cntry== "PL" & essround== 1 & nace_both== 14

replace	c_adv=	-1 if cntry== "PT" & essround== 1 & nace_both== 14

replace	c_adv=	-1 if cntry== "SK" & essround== 1 & nace_both== 14

replace	c_adv=	-1 if cntry== "ES" & essround== 1 & nace_both== 14

replace	c_adv=	-1 if cntry== "SE" & essround== 1 & nace_both== 14

replace	c_adv=	-1 if cntry== "CH" & essround== 1 & nace_both== 14

replace	c_adv=	1 if cntry== "TR" & essround== 1 & nace_both== 14

replace	c_adv=	1 if cntry== "GB" & essround== 1 & nace_both== 14

replace	c_adv=	-1 if cntry== "AT" & essround== 1 & nace_both== 15

replace	c_adv=	1 if cntry== "BE" & essround== 1 & nace_both== 15

replace	c_adv=	-1 if cntry== "CZ" & essround== 1 & nace_both== 15

replace	c_adv=	1 if cntry== "DK" & essround== 1 & nace_both== 15

replace	c_adv=	-1 if cntry== "FI" & essround== 1 & nace_both== 15

replace	c_adv=	1 if cntry== "FR" & essround== 1 & nace_both== 15

replace	c_adv=	-1 if cntry== "DE" & essround== 1 & nace_both== 15

replace	c_adv=	1 if cntry== "GR" & essround== 1 & nace_both== 15

replace	c_adv=	1 if cntry== "HU" & essround== 1 & nace_both== 15

replace	c_adv=	1 if cntry== "IS" & essround== 1 & nace_both== 15

replace	c_adv=	1 if cntry== "IE" & essround== 1 & nace_both== 15

replace	c_adv=	1 if cntry== "IT" & essround== 1 & nace_both== 15

replace	c_adv=	-1 if cntry== "LU" & essround== 1 & nace_both== 15

replace	c_adv=	1 if cntry== "NL" & essround== 1 & nace_both== 15

replace	c_adv=	1 if cntry== "NO" & essround== 1 & nace_both== 15

replace	c_adv=	1 if cntry== "PL" & essround== 1 & nace_both== 15

replace	c_adv=	1 if cntry== "PT" & essround== 1 & nace_both== 15

replace	c_adv=	-1 if cntry== "SK" & essround== 1 & nace_both== 15

replace	c_adv=	1 if cntry== "ES" & essround== 1 & nace_both== 15

replace	c_adv=	-1 if cntry== "SE" & essround== 1 & nace_both== 15

replace	c_adv=	-1 if cntry== "CH" & essround== 1 & nace_both== 15

replace	c_adv=	1 if cntry== "TR" & essround== 1 & nace_both== 15

replace	c_adv=	-1 if cntry== "GB" & essround== 1 & nace_both== 15

replace	c_adv=	-1 if cntry== "AT" & essround== 1 & nace_both== 16

replace	c_adv=	-1 if cntry== "BE" & essround== 1 & nace_both== 16

replace	c_adv=	-1 if cntry== "CZ" & essround== 1 & nace_both== 16

replace	c_adv=	1 if cntry== "DK" & essround== 1 & nace_both== 16

replace	c_adv=	-1 if cntry== "FI" & essround== 1 & nace_both== 16

replace	c_adv=	-1 if cntry== "FR" & essround== 1 & nace_both== 16

replace	c_adv=	1 if cntry== "DE" & essround== 1 & nace_both== 16

replace	c_adv=	1 if cntry== "GR" & essround== 1 & nace_both== 16

replace	c_adv=	0 if cntry== "HU" & essround== 1 & nace_both== 16

replace	c_adv=	0 if cntry== "IS" & essround== 1 & nace_both== 16

replace	c_adv=	-1 if cntry== "IE" & essround== 1 & nace_both== 16

replace	c_adv=	0 if cntry== "IT" & essround== 1 & nace_both== 16

replace	c_adv=	1 if cntry== "LU" & essround== 1 & nace_both== 16

replace	c_adv=	1 if cntry== "NL" & essround== 1 & nace_both== 16

replace	c_adv=	0 if cntry== "NO" & essround== 1 & nace_both== 16

replace	c_adv=	-1 if cntry== "PL" & essround== 1 & nace_both== 16

replace	c_adv=	1 if cntry== "PT" & essround== 1 & nace_both== 16

replace	c_adv=	-1 if cntry== "SK" & essround== 1 & nace_both== 16

replace	c_adv=	-1 if cntry== "ES" & essround== 1 & nace_both== 16

replace	c_adv=	-1 if cntry== "SE" & essround== 1 & nace_both== 16

replace	c_adv=	1 if cntry== "CH" & essround== 1 & nace_both== 16

replace	c_adv=	1 if cntry== "TR" & essround== 1 & nace_both== 16

replace	c_adv=	1 if cntry== "GB" & essround== 1 & nace_both== 16

replace	c_adv=	1 if cntry== "AT" & essround== 1 & nace_both== 17

replace	c_adv=	1 if cntry== "BE" & essround== 1 & nace_both== 17

replace	c_adv=	1 if cntry== "CZ" & essround== 1 & nace_both== 17

replace	c_adv=	1 if cntry== "DK" & essround== 1 & nace_both== 17

replace	c_adv=	-1 if cntry== "FI" & essround== 1 & nace_both== 17

replace	c_adv=	1 if cntry== "FR" & essround== 1 & nace_both== 17

replace	c_adv=	-1 if cntry== "DE" & essround== 1 & nace_both== 17

replace	c_adv=	1 if cntry== "GR" & essround== 1 & nace_both== 17

replace	c_adv=	-1 if cntry== "HU" & essround== 1 & nace_both== 17

replace	c_adv=	-1 if cntry== "IS" & essround== 1 & nace_both== 17

replace	c_adv=	-1 if cntry== "IE" & essround== 1 & nace_both== 17

replace	c_adv=	1 if cntry== "IT" & essround== 1 & nace_both== 17

replace	c_adv=	1 if cntry== "LU" & essround== 1 & nace_both== 17

replace	c_adv=	-1 if cntry== "NL" & essround== 1 & nace_both== 17

replace	c_adv=	-1 if cntry== "NO" & essround== 1 & nace_both== 17

replace	c_adv=	1 if cntry== "PL" & essround== 1 & nace_both== 17

replace	c_adv=	1 if cntry== "PT" & essround== 1 & nace_both== 17

replace	c_adv=	-1 if cntry== "SK" & essround== 1 & nace_both== 17

replace	c_adv=	1 if cntry== "ES" & essround== 1 & nace_both== 17

replace	c_adv=	-1 if cntry== "SE" & essround== 1 & nace_both== 17

replace	c_adv=	-1 if cntry== "CH" & essround== 1 & nace_both== 17

replace	c_adv=	1 if cntry== "TR" & essround== 1 & nace_both== 17

replace	c_adv=	-1 if cntry== "GB" & essround== 1 & nace_both== 17

replace	c_adv=	-1 if cntry== "AT" & essround== 1 & nace_both== 18

replace	c_adv=	1 if cntry== "BE" & essround== 1 & nace_both== 18

replace	c_adv=	1 if cntry== "CZ" & essround== 1 & nace_both== 18

replace	c_adv=	1 if cntry== "DK" & essround== 1 & nace_both== 18

replace	c_adv=	-1 if cntry== "FI" & essround== 1 & nace_both== 18

replace	c_adv=	1 if cntry== "FR" & essround== 1 & nace_both== 18

replace	c_adv=	-1 if cntry== "DE" & essround== 1 & nace_both== 18

replace	c_adv=	1 if cntry== "GR" & essround== 1 & nace_both== 18

replace	c_adv=	1 if cntry== "HU" & essround== 1 & nace_both== 18

replace	c_adv=	-1 if cntry== "IS" & essround== 1 & nace_both== 18

replace	c_adv=	-1 if cntry== "IE" & essround== 1 & nace_both== 18

replace	c_adv=	1 if cntry== "IT" & essround== 1 & nace_both== 18

replace	c_adv=	-1 if cntry== "LU" & essround== 1 & nace_both== 18

replace	c_adv=	-1 if cntry== "NL" & essround== 1 & nace_both== 18

replace	c_adv=	-1 if cntry== "NO" & essround== 1 & nace_both== 18

replace	c_adv=	1 if cntry== "PL" & essround== 1 & nace_both== 18

replace	c_adv=	1 if cntry== "PT" & essround== 1 & nace_both== 18

replace	c_adv=	1 if cntry== "SK" & essround== 1 & nace_both== 18

replace	c_adv=	1 if cntry== "ES" & essround== 1 & nace_both== 18

replace	c_adv=	-1 if cntry== "SE" & essround== 1 & nace_both== 18

replace	c_adv=	-1 if cntry== "CH" & essround== 1 & nace_both== 18

replace	c_adv=	1 if cntry== "TR" & essround== 1 & nace_both== 18

replace	c_adv=	-1 if cntry== "GB" & essround== 1 & nace_both== 18

replace	c_adv=	1 if cntry== "AT" & essround== 1 & nace_both== 19

replace	c_adv=	1 if cntry== "BE" & essround== 1 & nace_both== 19

replace	c_adv=	-1 if cntry== "CZ" & essround== 1 & nace_both== 19

replace	c_adv=	-1 if cntry== "DK" & essround== 1 & nace_both== 19

replace	c_adv=	-1 if cntry== "FI" & essround== 1 & nace_both== 19

replace	c_adv=	1 if cntry== "FR" & essround== 1 & nace_both== 19

replace	c_adv=	-1 if cntry== "DE" & essround== 1 & nace_both== 19

replace	c_adv=	-1 if cntry== "GR" & essround== 1 & nace_both== 19

replace	c_adv=	1 if cntry== "HU" & essround== 1 & nace_both== 19

replace	c_adv=	-1 if cntry== "IS" & essround== 1 & nace_both== 19

replace	c_adv=	-1 if cntry== "IE" & essround== 1 & nace_both== 19

replace	c_adv=	1 if cntry== "IT" & essround== 1 & nace_both== 19

replace	c_adv=	-1 if cntry== "LU" & essround== 1 & nace_both== 19

replace	c_adv=	-1 if cntry== "NL" & essround== 1 & nace_both== 19

replace	c_adv=	-1 if cntry== "NO" & essround== 1 & nace_both== 19

replace	c_adv=	1 if cntry== "PL" & essround== 1 & nace_both== 19

replace	c_adv=	1 if cntry== "PT" & essround== 1 & nace_both== 19

replace	c_adv=	1 if cntry== "SK" & essround== 1 & nace_both== 19

replace	c_adv=	1 if cntry== "ES" & essround== 1 & nace_both== 19

replace	c_adv=	-1 if cntry== "SE" & essround== 1 & nace_both== 19

replace	c_adv=	-1 if cntry== "CH" & essround== 1 & nace_both== 19

replace	c_adv=	-1 if cntry== "TR" & essround== 1 & nace_both== 19

replace	c_adv=	-1 if cntry== "GB" & essround== 1 & nace_both== 19

replace	c_adv=	1 if cntry== "AT" & essround== 1 & nace_both== 20

replace	c_adv=	-1 if cntry== "BE" & essround== 1 & nace_both== 20

replace	c_adv=	1 if cntry== "CZ" & essround== 1 & nace_both== 20

replace	c_adv=	1 if cntry== "DK" & essround== 1 & nace_both== 20

replace	c_adv=	1 if cntry== "FI" & essround== 1 & nace_both== 20

replace	c_adv=	-1 if cntry== "FR" & essround== 1 & nace_both== 20

replace	c_adv=	-1 if cntry== "DE" & essround== 1 & nace_both== 20

replace	c_adv=	-1 if cntry== "GR" & essround== 1 & nace_both== 20

replace	c_adv=	1 if cntry== "HU" & essround== 1 & nace_both== 20

replace	c_adv=	0 if cntry== "IS" & essround== 1 & nace_both== 20

replace	c_adv=	-1 if cntry== "IE" & essround== 1 & nace_both== 20

replace	c_adv=	-1 if cntry== "IT" & essround== 1 & nace_both== 20

replace	c_adv=	1 if cntry== "LU" & essround== 1 & nace_both== 20

replace	c_adv=	-1 if cntry== "NL" & essround== 1 & nace_both== 20

replace	c_adv=	-1 if cntry== "NO" & essround== 1 & nace_both== 20

replace	c_adv=	1 if cntry== "PL" & essround== 1 & nace_both== 20

replace	c_adv=	1 if cntry== "PT" & essround== 1 & nace_both== 20

replace	c_adv=	1 if cntry== "SK" & essround== 1 & nace_both== 20

replace	c_adv=	-1 if cntry== "ES" & essround== 1 & nace_both== 20

replace	c_adv=	1 if cntry== "SE" & essround== 1 & nace_both== 20

replace	c_adv=	-1 if cntry== "CH" & essround== 1 & nace_both== 20

replace	c_adv=	-1 if cntry== "TR" & essround== 1 & nace_both== 20

replace	c_adv=	-1 if cntry== "GB" & essround== 1 & nace_both== 20

replace	c_adv=	1 if cntry== "AT" & essround== 1 & nace_both== 21

replace	c_adv=	-1 if cntry== "BE" & essround== 1 & nace_both== 21

replace	c_adv=	-1 if cntry== "CZ" & essround== 1 & nace_both== 21

replace	c_adv=	-1 if cntry== "DK" & essround== 1 & nace_both== 21

replace	c_adv=	1 if cntry== "FI" & essround== 1 & nace_both== 21

replace	c_adv=	-1 if cntry== "FR" & essround== 1 & nace_both== 21

replace	c_adv=	1 if cntry== "DE" & essround== 1 & nace_both== 21

replace	c_adv=	-1 if cntry== "GR" & essround== 1 & nace_both== 21

replace	c_adv=	-1 if cntry== "HU" & essround== 1 & nace_both== 21

replace	c_adv=	-1 if cntry== "IS" & essround== 1 & nace_both== 21

replace	c_adv=	-1 if cntry== "IE" & essround== 1 & nace_both== 21

replace	c_adv=	-1 if cntry== "IT" & essround== 1 & nace_both== 21

replace	c_adv=	1 if cntry== "LU" & essround== 1 & nace_both== 21

replace	c_adv=	-1 if cntry== "NL" & essround== 1 & nace_both== 21

replace	c_adv=	-1 if cntry== "NO" & essround== 1 & nace_both== 21

replace	c_adv=	1 if cntry== "PL" & essround== 1 & nace_both== 21

replace	c_adv=	1 if cntry== "PT" & essround== 1 & nace_both== 21

replace	c_adv=	1 if cntry== "SK" & essround== 1 & nace_both== 21

replace	c_adv=	-1 if cntry== "ES" & essround== 1 & nace_both== 21

replace	c_adv=	1 if cntry== "SE" & essround== 1 & nace_both== 21

replace	c_adv=	-1 if cntry== "CH" & essround== 1 & nace_both== 21

replace	c_adv=	-1 if cntry== "TR" & essround== 1 & nace_both== 21

replace	c_adv=	-1 if cntry== "GB" & essround== 1 & nace_both== 21

replace	c_adv=	1 if cntry== "AT" & essround== 1 & nace_both== 22

replace	c_adv=	-1 if cntry== "BE" & essround== 1 & nace_both== 22

replace	c_adv=	1 if cntry== "CZ" & essround== 1 & nace_both== 22

replace	c_adv=	1 if cntry== "DK" & essround== 1 & nace_both== 22

replace	c_adv=	-1 if cntry== "FI" & essround== 1 & nace_both== 22

replace	c_adv=	-1 if cntry== "FR" & essround== 1 & nace_both== 22

replace	c_adv=	1 if cntry== "DE" & essround== 1 & nace_both== 22

replace	c_adv=	-1 if cntry== "GR" & essround== 1 & nace_both== 22

replace	c_adv=	-1 if cntry== "HU" & essround== 1 & nace_both== 22

replace	c_adv=	-1 if cntry== "IS" & essround== 1 & nace_both== 22

replace	c_adv=	1 if cntry== "IE" & essround== 1 & nace_both== 22

replace	c_adv=	-1 if cntry== "IT" & essround== 1 & nace_both== 22

replace	c_adv=	1 if cntry== "LU" & essround== 1 & nace_both== 22

replace	c_adv=	1 if cntry== "NL" & essround== 1 & nace_both== 22

replace	c_adv=	-1 if cntry== "NO" & essround== 1 & nace_both== 22

replace	c_adv=	-1 if cntry== "PL" & essround== 1 & nace_both== 22

replace	c_adv=	-1 if cntry== "PT" & essround== 1 & nace_both== 22

replace	c_adv=	1 if cntry== "SK" & essround== 1 & nace_both== 22

replace	c_adv=	1 if cntry== "ES" & essround== 1 & nace_both== 22

replace	c_adv=	1 if cntry== "SE" & essround== 1 & nace_both== 22

replace	c_adv=	-1 if cntry== "CH" & essround== 1 & nace_both== 22

replace	c_adv=	-1 if cntry== "TR" & essround== 1 & nace_both== 22

replace	c_adv=	1 if cntry== "GB" & essround== 1 & nace_both== 22

replace	c_adv=	-1 if cntry== "AT" & essround== 1 & nace_both== 23

replace	c_adv=	1 if cntry== "BE" & essround== 1 & nace_both== 23

replace	c_adv=	-1 if cntry== "CZ" & essround== 1 & nace_both== 23

replace	c_adv=	-1 if cntry== "DK" & essround== 1 & nace_both== 23

replace	c_adv=	1 if cntry== "FI" & essround== 1 & nace_both== 23

replace	c_adv=	-1 if cntry== "FR" & essround== 1 & nace_both== 23

replace	c_adv=	-1 if cntry== "DE" & essround== 1 & nace_both== 23

replace	c_adv=	1 if cntry== "GR" & essround== 1 & nace_both== 23

replace	c_adv=	-1 if cntry== "HU" & essround== 1 & nace_both== 23

replace	c_adv=	-1 if cntry== "IS" & essround== 1 & nace_both== 23

replace	c_adv=	-1 if cntry== "IE" & essround== 1 & nace_both== 23

replace	c_adv=	-1 if cntry== "IT" & essround== 1 & nace_both== 23

replace	c_adv=	-1 if cntry== "LU" & essround== 1 & nace_both== 23

replace	c_adv=	1 if cntry== "NL" & essround== 1 & nace_both== 23

replace	c_adv=	1 if cntry== "NO" & essround== 1 & nace_both== 23

replace	c_adv=	1 if cntry== "PL" & essround== 1 & nace_both== 23

replace	c_adv=	-1 if cntry== "PT" & essround== 1 & nace_both== 23

replace	c_adv=	1 if cntry== "SK" & essround== 1 & nace_both== 23

replace	c_adv=	1 if cntry== "ES" & essround== 1 & nace_both== 23

replace	c_adv=	1 if cntry== "SE" & essround== 1 & nace_both== 23

replace	c_adv=	-1 if cntry== "CH" & essround== 1 & nace_both== 23

replace	c_adv=	1 if cntry== "TR" & essround== 1 & nace_both== 23

replace	c_adv=	1 if cntry== "GB" & essround== 1 & nace_both== 23

replace	c_adv=	-1 if cntry== "AT" & essround== 1 & nace_both== 24

replace	c_adv=	1 if cntry== "BE" & essround== 1 & nace_both== 24

replace	c_adv=	-1 if cntry== "CZ" & essround== 1 & nace_both== 24

replace	c_adv=	-1 if cntry== "DK" & essround== 1 & nace_both== 24

replace	c_adv=	-1 if cntry== "FI" & essround== 1 & nace_both== 24

replace	c_adv=	1 if cntry== "FR" & essround== 1 & nace_both== 24

replace	c_adv=	1 if cntry== "DE" & essround== 1 & nace_both== 24

replace	c_adv=	-1 if cntry== "GR" & essround== 1 & nace_both== 24

replace	c_adv=	-1 if cntry== "HU" & essround== 1 & nace_both== 24

replace	c_adv=	-1 if cntry== "IS" & essround== 1 & nace_both== 24

replace	c_adv=	1 if cntry== "IE" & essround== 1 & nace_both== 24

replace	c_adv=	-1 if cntry== "IT" & essround== 1 & nace_both== 24

replace	c_adv=	-1 if cntry== "LU" & essround== 1 & nace_both== 24

replace	c_adv=	1 if cntry== "NL" & essround== 1 & nace_both== 24

replace	c_adv=	-1 if cntry== "NO" & essround== 1 & nace_both== 24

replace	c_adv=	-1 if cntry== "PL" & essround== 1 & nace_both== 24

replace	c_adv=	-1 if cntry== "PT" & essround== 1 & nace_both== 24

replace	c_adv=	-1 if cntry== "SK" & essround== 1 & nace_both== 24

replace	c_adv=	-1 if cntry== "ES" & essround== 1 & nace_both== 24

replace	c_adv=	-1 if cntry== "SE" & essround== 1 & nace_both== 24

replace	c_adv=	1 if cntry== "CH" & essround== 1 & nace_both== 24

replace	c_adv=	-1 if cntry== "TR" & essround== 1 & nace_both== 24

replace	c_adv=	1 if cntry== "GB" & essround== 1 & nace_both== 24

replace	c_adv=	1 if cntry== "AT" & essround== 1 & nace_both== 25

replace	c_adv=	1 if cntry== "BE" & essround== 1 & nace_both== 25

replace	c_adv=	1 if cntry== "CZ" & essround== 1 & nace_both== 25

replace	c_adv=	1 if cntry== "DK" & essround== 1 & nace_both== 25

replace	c_adv=	-1 if cntry== "FI" & essround== 1 & nace_both== 25

replace	c_adv=	1 if cntry== "FR" & essround== 1 & nace_both== 25

replace	c_adv=	1 if cntry== "DE" & essround== 1 & nace_both== 25

replace	c_adv=	1 if cntry== "GR" & essround== 1 & nace_both== 25

replace	c_adv=	-1 if cntry== "HU" & essround== 1 & nace_both== 25

replace	c_adv=	-1 if cntry== "IS" & essround== 1 & nace_both== 25

replace	c_adv=	-1 if cntry== "IE" & essround== 1 & nace_both== 25

replace	c_adv=	1 if cntry== "IT" & essround== 1 & nace_both== 25

replace	c_adv=	1 if cntry== "LU" & essround== 1 & nace_both== 25

replace	c_adv=	-1 if cntry== "NL" & essround== 1 & nace_both== 25

replace	c_adv=	-1 if cntry== "NO" & essround== 1 & nace_both== 25

replace	c_adv=	1 if cntry== "PL" & essround== 1 & nace_both== 25

replace	c_adv=	1 if cntry== "PT" & essround== 1 & nace_both== 25

replace	c_adv=	1 if cntry== "SK" & essround== 1 & nace_both== 25

replace	c_adv=	1 if cntry== "ES" & essround== 1 & nace_both== 25

replace	c_adv=	-1 if cntry== "SE" & essround== 1 & nace_both== 25

replace	c_adv=	1 if cntry== "CH" & essround== 1 & nace_both== 25

replace	c_adv=	1 if cntry== "TR" & essround== 1 & nace_both== 25

replace	c_adv=	-1 if cntry== "GB" & essround== 1 & nace_both== 25

replace	c_adv=	1 if cntry== "AT" & essround== 1 & nace_both== 26

replace	c_adv=	1 if cntry== "BE" & essround== 1 & nace_both== 26

replace	c_adv=	1 if cntry== "CZ" & essround== 1 & nace_both== 26

replace	c_adv=	-1 if cntry== "DK" & essround== 1 & nace_both== 26

replace	c_adv=	-1 if cntry== "FI" & essround== 1 & nace_both== 26

replace	c_adv=	1 if cntry== "FR" & essround== 1 & nace_both== 26

replace	c_adv=	1 if cntry== "DE" & essround== 1 & nace_both== 26

replace	c_adv=	1 if cntry== "GR" & essround== 1 & nace_both== 26

replace	c_adv=	-1 if cntry== "HU" & essround== 1 & nace_both== 26

replace	c_adv=	-1 if cntry== "IS" & essround== 1 & nace_both== 26

replace	c_adv=	-1 if cntry== "IE" & essround== 1 & nace_both== 26

replace	c_adv=	1 if cntry== "IT" & essround== 1 & nace_both== 26

replace	c_adv=	1 if cntry== "LU" & essround== 1 & nace_both== 26

replace	c_adv=	-1 if cntry== "NL" & essround== 1 & nace_both== 26

replace	c_adv=	-1 if cntry== "NO" & essround== 1 & nace_both== 26

replace	c_adv=	1 if cntry== "PL" & essround== 1 & nace_both== 26

replace	c_adv=	1 if cntry== "PT" & essround== 1 & nace_both== 26

replace	c_adv=	1 if cntry== "SK" & essround== 1 & nace_both== 26

replace	c_adv=	1 if cntry== "ES" & essround== 1 & nace_both== 26

replace	c_adv=	-1 if cntry== "SE" & essround== 1 & nace_both== 26

replace	c_adv=	-1 if cntry== "CH" & essround== 1 & nace_both== 26

replace	c_adv=	1 if cntry== "TR" & essround== 1 & nace_both== 26

replace	c_adv=	-1 if cntry== "GB" & essround== 1 & nace_both== 26

replace	c_adv=	1 if cntry== "AT" & essround== 1 & nace_both== 27

replace	c_adv=	1 if cntry== "BE" & essround== 1 & nace_both== 27

replace	c_adv=	1 if cntry== "CZ" & essround== 1 & nace_both== 27

replace	c_adv=	-1 if cntry== "DK" & essround== 1 & nace_both== 27

replace	c_adv=	1 if cntry== "FI" & essround== 1 & nace_both== 27

replace	c_adv=	1 if cntry== "FR" & essround== 1 & nace_both== 27

replace	c_adv=	1 if cntry== "DE" & essround== 1 & nace_both== 27

replace	c_adv=	1 if cntry== "GR" & essround== 1 & nace_both== 27

replace	c_adv=	-1 if cntry== "HU" & essround== 1 & nace_both== 27

replace	c_adv=	1 if cntry== "IS" & essround== 1 & nace_both== 27

replace	c_adv=	-1 if cntry== "IE" & essround== 1 & nace_both== 27

replace	c_adv=	-1 if cntry== "IT" & essround== 1 & nace_both== 27

replace	c_adv=	1 if cntry== "LU" & essround== 1 & nace_both== 27

replace	c_adv=	-1 if cntry== "NL" & essround== 1 & nace_both== 27

replace	c_adv=	1 if cntry== "NO" & essround== 1 & nace_both== 27

replace	c_adv=	1 if cntry== "PL" & essround== 1 & nace_both== 27

replace	c_adv=	-1 if cntry== "PT" & essround== 1 & nace_both== 27

replace	c_adv=	1 if cntry== "SK" & essround== 1 & nace_both== 27

replace	c_adv=	1 if cntry== "ES" & essround== 1 & nace_both== 27

replace	c_adv=	1 if cntry== "SE" & essround== 1 & nace_both== 27

replace	c_adv=	1 if cntry== "CH" & essround== 1 & nace_both== 27

replace	c_adv=	1 if cntry== "TR" & essround== 1 & nace_both== 27

replace	c_adv=	-1 if cntry== "GB" & essround== 1 & nace_both== 27

replace	c_adv=	1 if cntry== "AT" & essround== 1 & nace_both== 28

replace	c_adv=	-1 if cntry== "BE" & essround== 1 & nace_both== 28

replace	c_adv=	1 if cntry== "CZ" & essround== 1 & nace_both== 28

replace	c_adv=	1 if cntry== "DK" & essround== 1 & nace_both== 28

replace	c_adv=	-1 if cntry== "FI" & essround== 1 & nace_both== 28

replace	c_adv=	1 if cntry== "FR" & essround== 1 & nace_both== 28

replace	c_adv=	1 if cntry== "DE" & essround== 1 & nace_both== 28

replace	c_adv=	1 if cntry== "GR" & essround== 1 & nace_both== 28

replace	c_adv=	1 if cntry== "HU" & essround== 1 & nace_both== 28

replace	c_adv=	-1 if cntry== "IS" & essround== 1 & nace_both== 28

replace	c_adv=	-1 if cntry== "IE" & essround== 1 & nace_both== 28

replace	c_adv=	1 if cntry== "IT" & essround== 1 & nace_both== 28

replace	c_adv=	1 if cntry== "LU" & essround== 1 & nace_both== 28

replace	c_adv=	-1 if cntry== "NL" & essround== 1 & nace_both== 28

replace	c_adv=	-1 if cntry== "NO" & essround== 1 & nace_both== 28

replace	c_adv=	1 if cntry== "PL" & essround== 1 & nace_both== 28

replace	c_adv=	1 if cntry== "PT" & essround== 1 & nace_both== 28

replace	c_adv=	1 if cntry== "SK" & essround== 1 & nace_both== 28

replace	c_adv=	1 if cntry== "ES" & essround== 1 & nace_both== 28

replace	c_adv=	1 if cntry== "SE" & essround== 1 & nace_both== 28

replace	c_adv=	1 if cntry== "CH" & essround== 1 & nace_both== 28

replace	c_adv=	1 if cntry== "TR" & essround== 1 & nace_both== 28

replace	c_adv=	-1 if cntry== "GB" & essround== 1 & nace_both== 28

replace	c_adv=	1 if cntry== "AT" & essround== 1 & nace_both== 29

replace	c_adv=	-1 if cntry== "BE" & essround== 1 & nace_both== 29

replace	c_adv=	1 if cntry== "CZ" & essround== 1 & nace_both== 29

replace	c_adv=	1 if cntry== "DK" & essround== 1 & nace_both== 29

replace	c_adv=	1 if cntry== "FI" & essround== 1 & nace_both== 29

replace	c_adv=	-1 if cntry== "FR" & essround== 1 & nace_both== 29

replace	c_adv=	1 if cntry== "DE" & essround== 1 & nace_both== 29

replace	c_adv=	-1 if cntry== "GR" & essround== 1 & nace_both== 29

replace	c_adv=	-1 if cntry== "HU" & essround== 1 & nace_both== 29

replace	c_adv=	-1 if cntry== "IS" & essround== 1 & nace_both== 29

replace	c_adv=	-1 if cntry== "IE" & essround== 1 & nace_both== 29

replace	c_adv=	1 if cntry== "IT" & essround== 1 & nace_both== 29

replace	c_adv=	-1 if cntry== "LU" & essround== 1 & nace_both== 29

replace	c_adv=	-1 if cntry== "NL" & essround== 1 & nace_both== 29

replace	c_adv=	-1 if cntry== "NO" & essround== 1 & nace_both== 29

replace	c_adv=	-1 if cntry== "PL" & essround== 1 & nace_both== 29

replace	c_adv=	-1 if cntry== "PT" & essround== 1 & nace_both== 29

replace	c_adv=	-1 if cntry== "SK" & essround== 1 & nace_both== 29

replace	c_adv=	-1 if cntry== "ES" & essround== 1 & nace_both== 29

replace	c_adv=	1 if cntry== "SE" & essround== 1 & nace_both== 29

replace	c_adv=	1 if cntry== "CH" & essround== 1 & nace_both== 29

replace	c_adv=	-1 if cntry== "TR" & essround== 1 & nace_both== 29

replace	c_adv=	-1 if cntry== "GB" & essround== 1 & nace_both== 29

replace	c_adv=	-1 if cntry== "AT" & essround== 1 & nace_both== 30

replace	c_adv=	-1 if cntry== "BE" & essround== 1 & nace_both== 30

replace	c_adv=	1 if cntry== "CZ" & essround== 1 & nace_both== 30

replace	c_adv=	-1 if cntry== "DK" & essround== 1 & nace_both== 30

replace	c_adv=	-1 if cntry== "FI" & essround== 1 & nace_both== 30

replace	c_adv=	-1 if cntry== "FR" & essround== 1 & nace_both== 30

replace	c_adv=	-1 if cntry== "DE" & essround== 1 & nace_both== 30

replace	c_adv=	-1 if cntry== "GR" & essround== 1 & nace_both== 30

replace	c_adv=	1 if cntry== "HU" & essround== 1 & nace_both== 30

replace	c_adv=	0 if cntry== "IS" & essround== 1 & nace_both== 30

replace	c_adv=	1 if cntry== "IE" & essround== 1 & nace_both== 30

replace	c_adv=	-1 if cntry== "IT" & essround== 1 & nace_both== 30

replace	c_adv=	-1 if cntry== "LU" & essround== 1 & nace_both== 30

replace	c_adv=	1 if cntry== "NL" & essround== 1 & nace_both== 30

replace	c_adv=	-1 if cntry== "NO" & essround== 1 & nace_both== 30

replace	c_adv=	-1 if cntry== "PL" & essround== 1 & nace_both== 30

replace	c_adv=	-1 if cntry== "PT" & essround== 1 & nace_both== 30

replace	c_adv=	-1 if cntry== "SK" & essround== 1 & nace_both== 30

replace	c_adv=	-1 if cntry== "ES" & essround== 1 & nace_both== 30

replace	c_adv=	-1 if cntry== "SE" & essround== 1 & nace_both== 30

replace	c_adv=	-1 if cntry== "CH" & essround== 1 & nace_both== 30

replace	c_adv=	0 if cntry== "TR" & essround== 1 & nace_both== 30

replace	c_adv=	1 if cntry== "GB" & essround== 1 & nace_both== 30

replace	c_adv=	1 if cntry== "AT" & essround== 1 & nace_both== 31

replace	c_adv=	-1 if cntry== "BE" & essround== 1 & nace_both== 31

replace	c_adv=	1 if cntry== "CZ" & essround== 1 & nace_both== 31

replace	c_adv=	1 if cntry== "DK" & essround== 1 & nace_both== 31

replace	c_adv=	1 if cntry== "FI" & essround== 1 & nace_both== 31

replace	c_adv=	1 if cntry== "FR" & essround== 1 & nace_both== 31

replace	c_adv=	1 if cntry== "DE" & essround== 1 & nace_both== 31

replace	c_adv=	-1 if cntry== "GR" & essround== 1 & nace_both== 31

replace	c_adv=	1 if cntry== "HU" & essround== 1 & nace_both== 31

replace	c_adv=	0 if cntry== "IS" & essround== 1 & nace_both== 31

replace	c_adv=	-1 if cntry== "IE" & essround== 1 & nace_both== 31

replace	c_adv=	-1 if cntry== "IT" & essround== 1 & nace_both== 31

replace	c_adv=	-1 if cntry== "LU" & essround== 1 & nace_both== 31

replace	c_adv=	-1 if cntry== "NL" & essround== 1 & nace_both== 31

replace	c_adv=	-1 if cntry== "NO" & essround== 1 & nace_both== 31

replace	c_adv=	1 if cntry== "PL" & essround== 1 & nace_both== 31

replace	c_adv=	1 if cntry== "PT" & essround== 1 & nace_both== 31

replace	c_adv=	1 if cntry== "SK" & essround== 1 & nace_both== 31

replace	c_adv=	-1 if cntry== "ES" & essround== 1 & nace_both== 31

replace	c_adv=	-1 if cntry== "SE" & essround== 1 & nace_both== 31

replace	c_adv=	1 if cntry== "CH" & essround== 1 & nace_both== 31

replace	c_adv=	-1 if cntry== "TR" & essround== 1 & nace_both== 31

replace	c_adv=	-1 if cntry== "GB" & essround== 1 & nace_both== 31

replace	c_adv=	-1 if cntry== "AT" & essround== 1 & nace_both== 32

replace	c_adv=	-1 if cntry== "BE" & essround== 1 & nace_both== 32

replace	c_adv=	-1 if cntry== "CZ" & essround== 1 & nace_both== 32

replace	c_adv=	-1 if cntry== "DK" & essround== 1 & nace_both== 32

replace	c_adv=	1 if cntry== "FI" & essround== 1 & nace_both== 32

replace	c_adv=	-1 if cntry== "FR" & essround== 1 & nace_both== 32

replace	c_adv=	-1 if cntry== "DE" & essround== 1 & nace_both== 32

replace	c_adv=	-1 if cntry== "GR" & essround== 1 & nace_both== 32

replace	c_adv=	1 if cntry== "HU" & essround== 1 & nace_both== 32

replace	c_adv=	0 if cntry== "IS" & essround== 1 & nace_both== 32

replace	c_adv=	1 if cntry== "IE" & essround== 1 & nace_both== 32

replace	c_adv=	-1 if cntry== "IT" & essround== 1 & nace_both== 32

replace	c_adv=	1 if cntry== "LU" & essround== 1 & nace_both== 32

replace	c_adv=	-1 if cntry== "NL" & essround== 1 & nace_both== 32

replace	c_adv=	-1 if cntry== "NO" & essround== 1 & nace_both== 32

replace	c_adv=	-1 if cntry== "PL" & essround== 1 & nace_both== 32

replace	c_adv=	-1 if cntry== "PT" & essround== 1 & nace_both== 32

replace	c_adv=	-1 if cntry== "SK" & essround== 1 & nace_both== 32

replace	c_adv=	-1 if cntry== "ES" & essround== 1 & nace_both== 32

replace	c_adv=	1 if cntry== "SE" & essround== 1 & nace_both== 32

replace	c_adv=	-1 if cntry== "CH" & essround== 1 & nace_both== 32

replace	c_adv=	-1 if cntry== "TR" & essround== 1 & nace_both== 32

replace	c_adv=	1 if cntry== "GB" & essround== 1 & nace_both== 32

replace	c_adv=	-1 if cntry== "AT" & essround== 1 & nace_both== 33

replace	c_adv=	-1 if cntry== "BE" & essround== 1 & nace_both== 33

replace	c_adv=	-1 if cntry== "CZ" & essround== 1 & nace_both== 33

replace	c_adv=	1 if cntry== "DK" & essround== 1 & nace_both== 33

replace	c_adv=	-1 if cntry== "FI" & essround== 1 & nace_both== 33

replace	c_adv=	-1 if cntry== "FR" & essround== 1 & nace_both== 33

replace	c_adv=	1 if cntry== "DE" & essround== 1 & nace_both== 33

replace	c_adv=	-1 if cntry== "GR" & essround== 1 & nace_both== 33

replace	c_adv=	-1 if cntry== "HU" & essround== 1 & nace_both== 33

replace	c_adv=	-1 if cntry== "IS" & essround== 1 & nace_both== 33

replace	c_adv=	1 if cntry== "IE" & essround== 1 & nace_both== 33

replace	c_adv=	-1 if cntry== "IT" & essround== 1 & nace_both== 33

replace	c_adv=	-1 if cntry== "LU" & essround== 1 & nace_both== 33

replace	c_adv=	1 if cntry== "NL" & essround== 1 & nace_both== 33

replace	c_adv=	-1 if cntry== "NO" & essround== 1 & nace_both== 33

replace	c_adv=	-1 if cntry== "PL" & essround== 1 & nace_both== 33

replace	c_adv=	-1 if cntry== "PT" & essround== 1 & nace_both== 33

replace	c_adv=	-1 if cntry== "SK" & essround== 1 & nace_both== 33

replace	c_adv=	-1 if cntry== "ES" & essround== 1 & nace_both== 33

replace	c_adv=	-1 if cntry== "SE" & essround== 1 & nace_both== 33

replace	c_adv=	1 if cntry== "CH" & essround== 1 & nace_both== 33

replace	c_adv=	-1 if cntry== "TR" & essround== 1 & nace_both== 33

replace	c_adv=	1 if cntry== "GB" & essround== 1 & nace_both== 33

replace	c_adv=	1 if cntry== "AT" & essround== 1 & nace_both== 34

replace	c_adv=	1 if cntry== "BE" & essround== 1 & nace_both== 34

replace	c_adv=	1 if cntry== "CZ" & essround== 1 & nace_both== 34

replace	c_adv=	-1 if cntry== "DK" & essround== 1 & nace_both== 34

replace	c_adv=	-1 if cntry== "FI" & essround== 1 & nace_both== 34

replace	c_adv=	1 if cntry== "FR" & essround== 1 & nace_both== 34

replace	c_adv=	1 if cntry== "DE" & essround== 1 & nace_both== 34

replace	c_adv=	-1 if cntry== "GR" & essround== 1 & nace_both== 34

replace	c_adv=	1 if cntry== "HU" & essround== 1 & nace_both== 34

replace	c_adv=	0 if cntry== "IS" & essround== 1 & nace_both== 34

replace	c_adv=	0 if cntry== "IE" & essround== 1 & nace_both== 34

replace	c_adv=	-1 if cntry== "IT" & essround== 1 & nace_both== 34

replace	c_adv=	-1 if cntry== "LU" & essround== 1 & nace_both== 34

replace	c_adv=	-1 if cntry== "NL" & essround== 1 & nace_both== 34

replace	c_adv=	-1 if cntry== "NO" & essround== 1 & nace_both== 34

replace	c_adv=	1 if cntry== "PL" & essround== 1 & nace_both== 34

replace	c_adv=	1 if cntry== "PT" & essround== 1 & nace_both== 34

replace	c_adv=	1 if cntry== "SK" & essround== 1 & nace_both== 34

replace	c_adv=	1 if cntry== "ES" & essround== 1 & nace_both== 34

replace	c_adv=	-1 if cntry== "SE" & essround== 1 & nace_both== 34

replace	c_adv=	-1 if cntry== "CH" & essround== 1 & nace_both== 34

replace	c_adv=	-1 if cntry== "TR" & essround== 1 & nace_both== 34

replace	c_adv=	-1 if cntry== "GB" & essround== 1 & nace_both== 34

replace	c_adv=	-1 if cntry== "AT" & essround== 1 & nace_both== 35

replace	c_adv=	-1 if cntry== "BE" & essround== 1 & nace_both== 35

replace	c_adv=	-1 if cntry== "CZ" & essround== 1 & nace_both== 35

replace	c_adv=	-1 if cntry== "DK" & essround== 1 & nace_both== 35

replace	c_adv=	-1 if cntry== "FI" & essround== 1 & nace_both== 35

replace	c_adv=	1 if cntry== "FR" & essround== 1 & nace_both== 35

replace	c_adv=	1 if cntry== "DE" & essround== 1 & nace_both== 35

replace	c_adv=	-1 if cntry== "GR" & essround== 1 & nace_both== 35

replace	c_adv=	-1 if cntry== "HU" & essround== 1 & nace_both== 35

replace	c_adv=	-1 if cntry== "IS" & essround== 1 & nace_both== 35

replace	c_adv=	-1 if cntry== "IE" & essround== 1 & nace_both== 35

replace	c_adv=	-1 if cntry== "IT" & essround== 1 & nace_both== 35

replace	c_adv=	-1 if cntry== "LU" & essround== 1 & nace_both== 35

replace	c_adv=	-1 if cntry== "NL" & essround== 1 & nace_both== 35

replace	c_adv=	-1 if cntry== "NO" & essround== 1 & nace_both== 35

replace	c_adv=	1 if cntry== "PL" & essround== 1 & nace_both== 35

replace	c_adv=	-1 if cntry== "PT" & essround== 1 & nace_both== 35

replace	c_adv=	-1 if cntry== "SK" & essround== 1 & nace_both== 35

replace	c_adv=	-1 if cntry== "ES" & essround== 1 & nace_both== 35

replace	c_adv=	-1 if cntry== "SE" & essround== 1 & nace_both== 35

replace	c_adv=	-1 if cntry== "CH" & essround== 1 & nace_both== 35

replace	c_adv=	-1 if cntry== "TR" & essround== 1 & nace_both== 35

replace	c_adv=	1 if cntry== "GB" & essround== 1 & nace_both== 35

replace	c_adv=	1 if cntry== "AT" & essround== 1 & nace_both== 36

replace	c_adv=	1 if cntry== "BE" & essround== 1 & nace_both== 36

replace	c_adv=	1 if cntry== "CZ" & essround== 1 & nace_both== 36

replace	c_adv=	1 if cntry== "DK" & essround== 1 & nace_both== 36

replace	c_adv=	-1 if cntry== "FI" & essround== 1 & nace_both== 36

replace	c_adv=	-1 if cntry== "FR" & essround== 1 & nace_both== 36

replace	c_adv=	-1 if cntry== "DE" & essround== 1 & nace_both== 36

replace	c_adv=	-1 if cntry== "GR" & essround== 1 & nace_both== 36

replace	c_adv=	1 if cntry== "HU" & essround== 1 & nace_both== 36

replace	c_adv=	0 if cntry== "IS" & essround== 1 & nace_both== 36

replace	c_adv=	-1 if cntry== "IE" & essround== 1 & nace_both== 36

replace	c_adv=	1 if cntry== "IT" & essround== 1 & nace_both== 36

replace	c_adv=	-1 if cntry== "LU" & essround== 1 & nace_both== 36

replace	c_adv=	-1 if cntry== "NL" & essround== 1 & nace_both== 36

replace	c_adv=	-1 if cntry== "NO" & essround== 1 & nace_both== 36

replace	c_adv=	1 if cntry== "PL" & essround== 1 & nace_both== 36

replace	c_adv=	1 if cntry== "PT" & essround== 1 & nace_both== 36

replace	c_adv=	1 if cntry== "SK" & essround== 1 & nace_both== 36

replace	c_adv=	-1 if cntry== "ES" & essround== 1 & nace_both== 36

replace	c_adv=	-1 if cntry== "SE" & essround== 1 & nace_both== 36

replace	c_adv=	1 if cntry== "CH" & essround== 1 & nace_both== 36

replace	c_adv=	1 if cntry== "TR" & essround== 1 & nace_both== 36

replace	c_adv=	-1 if cntry== "GB" & essround== 1 & nace_both== 36

replace	c_adv=	0 if cntry== "AT" & essround== 1 & nace_both== 37

replace	c_adv=	0 if cntry== "BE" & essround== 1 & nace_both== 37

replace	c_adv=	0 if cntry== "CZ" & essround== 1 & nace_both== 37

replace	c_adv=	0 if cntry== "DK" & essround== 1 & nace_both== 37

replace	c_adv=	0 if cntry== "FI" & essround== 1 & nace_both== 37

replace	c_adv=	0 if cntry== "FR" & essround== 1 & nace_both== 37

replace	c_adv=	0 if cntry== "DE" & essround== 1 & nace_both== 37

replace	c_adv=	0 if cntry== "GR" & essround== 1 & nace_both== 37

replace	c_adv=	0 if cntry== "HU" & essround== 1 & nace_both== 37

replace	c_adv=	0 if cntry== "IS" & essround== 1 & nace_both== 37

replace	c_adv=	0 if cntry== "IE" & essround== 1 & nace_both== 37

replace	c_adv=	0 if cntry== "IT" & essround== 1 & nace_both== 37

replace	c_adv=	0 if cntry== "LU" & essround== 1 & nace_both== 37

replace	c_adv=	0 if cntry== "NL" & essround== 1 & nace_both== 37

replace	c_adv=	0 if cntry== "NO" & essround== 1 & nace_both== 37

replace	c_adv=	0 if cntry== "PL" & essround== 1 & nace_both== 37

replace	c_adv=	0 if cntry== "PT" & essround== 1 & nace_both== 37

replace	c_adv=	0 if cntry== "SK" & essround== 1 & nace_both== 37

replace	c_adv=	0 if cntry== "ES" & essround== 1 & nace_both== 37

replace	c_adv=	0 if cntry== "SE" & essround== 1 & nace_both== 37

replace	c_adv=	0 if cntry== "CH" & essround== 1 & nace_both== 37

replace	c_adv=	0 if cntry== "TR" & essround== 1 & nace_both== 37

replace	c_adv=	0 if cntry== "GB" & essround== 1 & nace_both== 37

replace	c_adv=	1 if cntry== "AT" & essround== 1 & nace_both== 40

replace	c_adv=	-1 if cntry== "BE" & essround== 1 & nace_both== 40

replace	c_adv=	1 if cntry== "CZ" & essround== 1 & nace_both== 40

replace	c_adv=	1 if cntry== "DK" & essround== 1 & nace_both== 40

replace	c_adv=	-1 if cntry== "FI" & essround== 1 & nace_both== 40

replace	c_adv=	1 if cntry== "FR" & essround== 1 & nace_both== 40

replace	c_adv=	-1 if cntry== "DE" & essround== 1 & nace_both== 40

replace	c_adv=	0 if cntry== "GR" & essround== 1 & nace_both== 40

replace	c_adv=	0 if cntry== "HU" & essround== 1 & nace_both== 40

replace	c_adv=	0 if cntry== "IS" & essround== 1 & nace_both== 40

replace	c_adv=	0 if cntry== "IE" & essround== 1 & nace_both== 40

replace	c_adv=	-1 if cntry== "IT" & essround== 1 & nace_both== 40

replace	c_adv=	1 if cntry== "LU" & essround== 1 & nace_both== 40

replace	c_adv=	-1 if cntry== "NL" & essround== 1 & nace_both== 40

replace	c_adv=	1 if cntry== "NO" & essround== 1 & nace_both== 40

replace	c_adv=	1 if cntry== "PL" & essround== 1 & nace_both== 40

replace	c_adv=	-1 if cntry== "PT" & essround== 1 & nace_both== 40

replace	c_adv=	1 if cntry== "SK" & essround== 1 & nace_both== 40

replace	c_adv=	-1 if cntry== "ES" & essround== 1 & nace_both== 40

replace	c_adv=	1 if cntry== "SE" & essround== 1 & nace_both== 40

replace	c_adv=	0 if cntry== "CH" & essround== 1 & nace_both== 40

replace	c_adv=	-1 if cntry== "TR" & essround== 1 & nace_both== 40

replace	c_adv=	-1 if cntry== "GB" & essround== 1 & nace_both== 40

replace	c_adv=	0 if cntry== "AT" & essround== 1 & nace_both== 41

replace	c_adv=	0 if cntry== "BE" & essround== 1 & nace_both== 41

replace	c_adv=	0 if cntry== "CZ" & essround== 1 & nace_both== 41

replace	c_adv=	0 if cntry== "DK" & essround== 1 & nace_both== 41

replace	c_adv=	0 if cntry== "FI" & essround== 1 & nace_both== 41

replace	c_adv=	0 if cntry== "FR" & essround== 1 & nace_both== 41

replace	c_adv=	0 if cntry== "DE" & essround== 1 & nace_both== 41

replace	c_adv=	0 if cntry== "GR" & essround== 1 & nace_both== 41

replace	c_adv=	0 if cntry== "HU" & essround== 1 & nace_both== 41

replace	c_adv=	0 if cntry== "IS" & essround== 1 & nace_both== 41

replace	c_adv=	0 if cntry== "IE" & essround== 1 & nace_both== 41

replace	c_adv=	0 if cntry== "IT" & essround== 1 & nace_both== 41

replace	c_adv=	0 if cntry== "LU" & essround== 1 & nace_both== 41

replace	c_adv=	0 if cntry== "NL" & essround== 1 & nace_both== 41

replace	c_adv=	0 if cntry== "NO" & essround== 1 & nace_both== 41

replace	c_adv=	0 if cntry== "PL" & essround== 1 & nace_both== 41

replace	c_adv=	0 if cntry== "PT" & essround== 1 & nace_both== 41

replace	c_adv=	0 if cntry== "SK" & essround== 1 & nace_both== 41

replace	c_adv=	0 if cntry== "ES" & essround== 1 & nace_both== 41

replace	c_adv=	0 if cntry== "SE" & essround== 1 & nace_both== 41

replace	c_adv=	0 if cntry== "CH" & essround== 1 & nace_both== 41

replace	c_adv=	0 if cntry== "TR" & essround== 1 & nace_both== 41

replace	c_adv=	0 if cntry== "GB" & essround== 1 & nace_both== 41

replace	c_adv=	0 if cntry== "AT" & essround== 1 & nace_both== 45

replace	c_adv=	0 if cntry== "BE" & essround== 1 & nace_both== 45

replace	c_adv=	0 if cntry== "CZ" & essround== 1 & nace_both== 45

replace	c_adv=	0 if cntry== "DK" & essround== 1 & nace_both== 45

replace	c_adv=	0 if cntry== "FI" & essround== 1 & nace_both== 45

replace	c_adv=	0 if cntry== "FR" & essround== 1 & nace_both== 45

replace	c_adv=	0 if cntry== "DE" & essround== 1 & nace_both== 45

replace	c_adv=	0 if cntry== "GR" & essround== 1 & nace_both== 45

replace	c_adv=	0 if cntry== "HU" & essround== 1 & nace_both== 45

replace	c_adv=	0 if cntry== "IS" & essround== 1 & nace_both== 45

replace	c_adv=	0 if cntry== "IE" & essround== 1 & nace_both== 45

replace	c_adv=	0 if cntry== "IT" & essround== 1 & nace_both== 45

replace	c_adv=	0 if cntry== "LU" & essround== 1 & nace_both== 45

replace	c_adv=	0 if cntry== "NL" & essround== 1 & nace_both== 45

replace	c_adv=	0 if cntry== "NO" & essround== 1 & nace_both== 45

replace	c_adv=	0 if cntry== "PL" & essround== 1 & nace_both== 45

replace	c_adv=	0 if cntry== "PT" & essround== 1 & nace_both== 45

replace	c_adv=	0 if cntry== "SK" & essround== 1 & nace_both== 45

replace	c_adv=	0 if cntry== "ES" & essround== 1 & nace_both== 45

replace	c_adv=	0 if cntry== "SE" & essround== 1 & nace_both== 45

replace	c_adv=	0 if cntry== "CH" & essround== 1 & nace_both== 45

replace	c_adv=	0 if cntry== "TR" & essround== 1 & nace_both== 45

replace	c_adv=	0 if cntry== "GB" & essround== 1 & nace_both== 45

replace	c_adv=	0 if cntry== "AT" & essround== 1 & nace_both== 50

replace	c_adv=	0 if cntry== "BE" & essround== 1 & nace_both== 50

replace	c_adv=	0 if cntry== "CZ" & essround== 1 & nace_both== 50

replace	c_adv=	0 if cntry== "DK" & essround== 1 & nace_both== 50

replace	c_adv=	0 if cntry== "FI" & essround== 1 & nace_both== 50

replace	c_adv=	0 if cntry== "FR" & essround== 1 & nace_both== 50

replace	c_adv=	0 if cntry== "DE" & essround== 1 & nace_both== 50

replace	c_adv=	0 if cntry== "GR" & essround== 1 & nace_both== 50

replace	c_adv=	0 if cntry== "HU" & essround== 1 & nace_both== 50

replace	c_adv=	0 if cntry== "IS" & essround== 1 & nace_both== 50

replace	c_adv=	0 if cntry== "IE" & essround== 1 & nace_both== 50

replace	c_adv=	0 if cntry== "IT" & essround== 1 & nace_both== 50

replace	c_adv=	0 if cntry== "LU" & essround== 1 & nace_both== 50

replace	c_adv=	0 if cntry== "NL" & essround== 1 & nace_both== 50

replace	c_adv=	0 if cntry== "NO" & essround== 1 & nace_both== 50

replace	c_adv=	0 if cntry== "PL" & essround== 1 & nace_both== 50

replace	c_adv=	0 if cntry== "PT" & essround== 1 & nace_both== 50

replace	c_adv=	0 if cntry== "SK" & essround== 1 & nace_both== 50

replace	c_adv=	0 if cntry== "ES" & essround== 1 & nace_both== 50

replace	c_adv=	0 if cntry== "SE" & essround== 1 & nace_both== 50

replace	c_adv=	0 if cntry== "CH" & essround== 1 & nace_both== 50

replace	c_adv=	0 if cntry== "TR" & essround== 1 & nace_both== 50

replace	c_adv=	0 if cntry== "GB" & essround== 1 & nace_both== 50

replace	c_adv=	0 if cntry== "AT" & essround== 1 & nace_both== 51

replace	c_adv=	0 if cntry== "BE" & essround== 1 & nace_both== 51

replace	c_adv=	0 if cntry== "CZ" & essround== 1 & nace_both== 51

replace	c_adv=	0 if cntry== "DK" & essround== 1 & nace_both== 51

replace	c_adv=	0 if cntry== "FI" & essround== 1 & nace_both== 51

replace	c_adv=	0 if cntry== "FR" & essround== 1 & nace_both== 51

replace	c_adv=	0 if cntry== "DE" & essround== 1 & nace_both== 51

replace	c_adv=	0 if cntry== "GR" & essround== 1 & nace_both== 51

replace	c_adv=	0 if cntry== "HU" & essround== 1 & nace_both== 51

replace	c_adv=	0 if cntry== "IS" & essround== 1 & nace_both== 51

replace	c_adv=	0 if cntry== "IE" & essround== 1 & nace_both== 51

replace	c_adv=	0 if cntry== "IT" & essround== 1 & nace_both== 51

replace	c_adv=	0 if cntry== "LU" & essround== 1 & nace_both== 51

replace	c_adv=	0 if cntry== "NL" & essround== 1 & nace_both== 51

replace	c_adv=	0 if cntry== "NO" & essround== 1 & nace_both== 51

replace	c_adv=	0 if cntry== "PL" & essround== 1 & nace_both== 51

replace	c_adv=	0 if cntry== "PT" & essround== 1 & nace_both== 51

replace	c_adv=	0 if cntry== "SK" & essround== 1 & nace_both== 51

replace	c_adv=	0 if cntry== "ES" & essround== 1 & nace_both== 51

replace	c_adv=	0 if cntry== "SE" & essround== 1 & nace_both== 51

replace	c_adv=	0 if cntry== "CH" & essround== 1 & nace_both== 51

replace	c_adv=	0 if cntry== "TR" & essround== 1 & nace_both== 51

replace	c_adv=	0 if cntry== "GB" & essround== 1 & nace_both== 51

replace	c_adv=	0 if cntry== "AT" & essround== 1 & nace_both== 52

replace	c_adv=	0 if cntry== "BE" & essround== 1 & nace_both== 52

replace	c_adv=	0 if cntry== "CZ" & essround== 1 & nace_both== 52

replace	c_adv=	0 if cntry== "DK" & essround== 1 & nace_both== 52

replace	c_adv=	0 if cntry== "FI" & essround== 1 & nace_both== 52

replace	c_adv=	0 if cntry== "FR" & essround== 1 & nace_both== 52

replace	c_adv=	0 if cntry== "DE" & essround== 1 & nace_both== 52

replace	c_adv=	0 if cntry== "GR" & essround== 1 & nace_both== 52

replace	c_adv=	0 if cntry== "HU" & essround== 1 & nace_both== 52

replace	c_adv=	0 if cntry== "IS" & essround== 1 & nace_both== 52

replace	c_adv=	0 if cntry== "IE" & essround== 1 & nace_both== 52

replace	c_adv=	0 if cntry== "IT" & essround== 1 & nace_both== 52

replace	c_adv=	0 if cntry== "LU" & essround== 1 & nace_both== 52

replace	c_adv=	0 if cntry== "NL" & essround== 1 & nace_both== 52

replace	c_adv=	0 if cntry== "NO" & essround== 1 & nace_both== 52

replace	c_adv=	0 if cntry== "PL" & essround== 1 & nace_both== 52

replace	c_adv=	0 if cntry== "PT" & essround== 1 & nace_both== 52

replace	c_adv=	0 if cntry== "SK" & essround== 1 & nace_both== 52

replace	c_adv=	0 if cntry== "ES" & essround== 1 & nace_both== 52

replace	c_adv=	0 if cntry== "SE" & essround== 1 & nace_both== 52

replace	c_adv=	0 if cntry== "CH" & essround== 1 & nace_both== 52

replace	c_adv=	0 if cntry== "TR" & essround== 1 & nace_both== 52

replace	c_adv=	0 if cntry== "GB" & essround== 1 & nace_both== 52

replace	c_adv=	0 if cntry== "AT" & essround== 1 & nace_both== 55

replace	c_adv=	0 if cntry== "BE" & essround== 1 & nace_both== 55

replace	c_adv=	0 if cntry== "CZ" & essround== 1 & nace_both== 55

replace	c_adv=	0 if cntry== "DK" & essround== 1 & nace_both== 55

replace	c_adv=	0 if cntry== "FI" & essround== 1 & nace_both== 55

replace	c_adv=	0 if cntry== "FR" & essround== 1 & nace_both== 55

replace	c_adv=	0 if cntry== "DE" & essround== 1 & nace_both== 55

replace	c_adv=	0 if cntry== "GR" & essround== 1 & nace_both== 55

replace	c_adv=	0 if cntry== "HU" & essround== 1 & nace_both== 55

replace	c_adv=	0 if cntry== "IS" & essround== 1 & nace_both== 55

replace	c_adv=	0 if cntry== "IE" & essround== 1 & nace_both== 55

replace	c_adv=	0 if cntry== "IT" & essround== 1 & nace_both== 55

replace	c_adv=	0 if cntry== "LU" & essround== 1 & nace_both== 55

replace	c_adv=	0 if cntry== "NL" & essround== 1 & nace_both== 55

replace	c_adv=	0 if cntry== "NO" & essround== 1 & nace_both== 55

replace	c_adv=	0 if cntry== "PL" & essround== 1 & nace_both== 55

replace	c_adv=	0 if cntry== "PT" & essround== 1 & nace_both== 55

replace	c_adv=	0 if cntry== "SK" & essround== 1 & nace_both== 55

replace	c_adv=	0 if cntry== "ES" & essround== 1 & nace_both== 55

replace	c_adv=	0 if cntry== "SE" & essround== 1 & nace_both== 55

replace	c_adv=	0 if cntry== "CH" & essround== 1 & nace_both== 55

replace	c_adv=	0 if cntry== "TR" & essround== 1 & nace_both== 55

replace	c_adv=	0 if cntry== "GB" & essround== 1 & nace_both== 55

replace	c_adv=	0 if cntry== "AT" & essround== 1 & nace_both== 60

replace	c_adv=	0 if cntry== "BE" & essround== 1 & nace_both== 60

replace	c_adv=	0 if cntry== "CZ" & essround== 1 & nace_both== 60

replace	c_adv=	0 if cntry== "DK" & essround== 1 & nace_both== 60

replace	c_adv=	0 if cntry== "FI" & essround== 1 & nace_both== 60

replace	c_adv=	0 if cntry== "FR" & essround== 1 & nace_both== 60

replace	c_adv=	0 if cntry== "DE" & essround== 1 & nace_both== 60

replace	c_adv=	0 if cntry== "GR" & essround== 1 & nace_both== 60

replace	c_adv=	0 if cntry== "HU" & essround== 1 & nace_both== 60

replace	c_adv=	0 if cntry== "IS" & essround== 1 & nace_both== 60

replace	c_adv=	0 if cntry== "IE" & essround== 1 & nace_both== 60

replace	c_adv=	0 if cntry== "IT" & essround== 1 & nace_both== 60

replace	c_adv=	0 if cntry== "LU" & essround== 1 & nace_both== 60

replace	c_adv=	0 if cntry== "NL" & essround== 1 & nace_both== 60

replace	c_adv=	0 if cntry== "NO" & essround== 1 & nace_both== 60

replace	c_adv=	0 if cntry== "PL" & essround== 1 & nace_both== 60

replace	c_adv=	0 if cntry== "PT" & essround== 1 & nace_both== 60

replace	c_adv=	0 if cntry== "SK" & essround== 1 & nace_both== 60

replace	c_adv=	0 if cntry== "ES" & essround== 1 & nace_both== 60

replace	c_adv=	0 if cntry== "SE" & essround== 1 & nace_both== 60

replace	c_adv=	0 if cntry== "CH" & essround== 1 & nace_both== 60

replace	c_adv=	0 if cntry== "TR" & essround== 1 & nace_both== 60

replace	c_adv=	0 if cntry== "GB" & essround== 1 & nace_both== 60

replace	c_adv=	0 if cntry== "AT" & essround== 1 & nace_both== 61

replace	c_adv=	0 if cntry== "BE" & essround== 1 & nace_both== 61

replace	c_adv=	0 if cntry== "CZ" & essround== 1 & nace_both== 61

replace	c_adv=	0 if cntry== "DK" & essround== 1 & nace_both== 61

replace	c_adv=	0 if cntry== "FI" & essround== 1 & nace_both== 61

replace	c_adv=	0 if cntry== "FR" & essround== 1 & nace_both== 61

replace	c_adv=	0 if cntry== "DE" & essround== 1 & nace_both== 61

replace	c_adv=	0 if cntry== "GR" & essround== 1 & nace_both== 61

replace	c_adv=	0 if cntry== "HU" & essround== 1 & nace_both== 61

replace	c_adv=	0 if cntry== "IS" & essround== 1 & nace_both== 61

replace	c_adv=	0 if cntry== "IE" & essround== 1 & nace_both== 61

replace	c_adv=	0 if cntry== "IT" & essround== 1 & nace_both== 61

replace	c_adv=	0 if cntry== "LU" & essround== 1 & nace_both== 61

replace	c_adv=	0 if cntry== "NL" & essround== 1 & nace_both== 61

replace	c_adv=	0 if cntry== "NO" & essround== 1 & nace_both== 61

replace	c_adv=	0 if cntry== "PL" & essround== 1 & nace_both== 61

replace	c_adv=	0 if cntry== "PT" & essround== 1 & nace_both== 61

replace	c_adv=	0 if cntry== "SK" & essround== 1 & nace_both== 61

replace	c_adv=	0 if cntry== "ES" & essround== 1 & nace_both== 61

replace	c_adv=	0 if cntry== "SE" & essround== 1 & nace_both== 61

replace	c_adv=	0 if cntry== "CH" & essround== 1 & nace_both== 61

replace	c_adv=	0 if cntry== "TR" & essround== 1 & nace_both== 61

replace	c_adv=	0 if cntry== "GB" & essround== 1 & nace_both== 61

replace	c_adv=	0 if cntry== "AT" & essround== 1 & nace_both== 62

replace	c_adv=	0 if cntry== "BE" & essround== 1 & nace_both== 62

replace	c_adv=	0 if cntry== "CZ" & essround== 1 & nace_both== 62

replace	c_adv=	0 if cntry== "DK" & essround== 1 & nace_both== 62

replace	c_adv=	0 if cntry== "FI" & essround== 1 & nace_both== 62

replace	c_adv=	0 if cntry== "FR" & essround== 1 & nace_both== 62

replace	c_adv=	0 if cntry== "DE" & essround== 1 & nace_both== 62

replace	c_adv=	0 if cntry== "GR" & essround== 1 & nace_both== 62

replace	c_adv=	0 if cntry== "HU" & essround== 1 & nace_both== 62

replace	c_adv=	0 if cntry== "IS" & essround== 1 & nace_both== 62

replace	c_adv=	0 if cntry== "IE" & essround== 1 & nace_both== 62

replace	c_adv=	0 if cntry== "IT" & essround== 1 & nace_both== 62

replace	c_adv=	0 if cntry== "LU" & essround== 1 & nace_both== 62

replace	c_adv=	0 if cntry== "NL" & essround== 1 & nace_both== 62

replace	c_adv=	0 if cntry== "NO" & essround== 1 & nace_both== 62

replace	c_adv=	0 if cntry== "PL" & essround== 1 & nace_both== 62

replace	c_adv=	0 if cntry== "PT" & essround== 1 & nace_both== 62

replace	c_adv=	0 if cntry== "SK" & essround== 1 & nace_both== 62

replace	c_adv=	0 if cntry== "ES" & essround== 1 & nace_both== 62

replace	c_adv=	0 if cntry== "SE" & essround== 1 & nace_both== 62

replace	c_adv=	0 if cntry== "CH" & essround== 1 & nace_both== 62

replace	c_adv=	0 if cntry== "TR" & essround== 1 & nace_both== 62

replace	c_adv=	0 if cntry== "GB" & essround== 1 & nace_both== 62

replace	c_adv=	0 if cntry== "AT" & essround== 1 & nace_both== 63

replace	c_adv=	0 if cntry== "BE" & essround== 1 & nace_both== 63

replace	c_adv=	0 if cntry== "CZ" & essround== 1 & nace_both== 63

replace	c_adv=	0 if cntry== "DK" & essround== 1 & nace_both== 63

replace	c_adv=	0 if cntry== "FI" & essround== 1 & nace_both== 63

replace	c_adv=	0 if cntry== "FR" & essround== 1 & nace_both== 63

replace	c_adv=	0 if cntry== "DE" & essround== 1 & nace_both== 63

replace	c_adv=	0 if cntry== "GR" & essround== 1 & nace_both== 63

replace	c_adv=	0 if cntry== "HU" & essround== 1 & nace_both== 63

replace	c_adv=	0 if cntry== "IS" & essround== 1 & nace_both== 63

replace	c_adv=	0 if cntry== "IE" & essround== 1 & nace_both== 63

replace	c_adv=	0 if cntry== "IT" & essround== 1 & nace_both== 63

replace	c_adv=	0 if cntry== "LU" & essround== 1 & nace_both== 63

replace	c_adv=	0 if cntry== "NL" & essround== 1 & nace_both== 63

replace	c_adv=	0 if cntry== "NO" & essround== 1 & nace_both== 63

replace	c_adv=	0 if cntry== "PL" & essround== 1 & nace_both== 63

replace	c_adv=	0 if cntry== "PT" & essround== 1 & nace_both== 63

replace	c_adv=	0 if cntry== "SK" & essround== 1 & nace_both== 63

replace	c_adv=	0 if cntry== "ES" & essround== 1 & nace_both== 63

replace	c_adv=	0 if cntry== "SE" & essround== 1 & nace_both== 63

replace	c_adv=	0 if cntry== "CH" & essround== 1 & nace_both== 63

replace	c_adv=	0 if cntry== "TR" & essround== 1 & nace_both== 63

replace	c_adv=	0 if cntry== "GB" & essround== 1 & nace_both== 63

replace	c_adv=	0 if cntry== "AT" & essround== 1 & nace_both== 64

replace	c_adv=	0 if cntry== "BE" & essround== 1 & nace_both== 64

replace	c_adv=	0 if cntry== "CZ" & essround== 1 & nace_both== 64

replace	c_adv=	0 if cntry== "DK" & essround== 1 & nace_both== 64

replace	c_adv=	0 if cntry== "FI" & essround== 1 & nace_both== 64

replace	c_adv=	0 if cntry== "FR" & essround== 1 & nace_both== 64

replace	c_adv=	0 if cntry== "DE" & essround== 1 & nace_both== 64

replace	c_adv=	0 if cntry== "GR" & essround== 1 & nace_both== 64

replace	c_adv=	0 if cntry== "HU" & essround== 1 & nace_both== 64

replace	c_adv=	0 if cntry== "IS" & essround== 1 & nace_both== 64

replace	c_adv=	0 if cntry== "IE" & essround== 1 & nace_both== 64

replace	c_adv=	0 if cntry== "IT" & essround== 1 & nace_both== 64

replace	c_adv=	0 if cntry== "LU" & essround== 1 & nace_both== 64

replace	c_adv=	0 if cntry== "NL" & essround== 1 & nace_both== 64

replace	c_adv=	0 if cntry== "NO" & essround== 1 & nace_both== 64

replace	c_adv=	0 if cntry== "PL" & essround== 1 & nace_both== 64

replace	c_adv=	0 if cntry== "PT" & essround== 1 & nace_both== 64

replace	c_adv=	0 if cntry== "SK" & essround== 1 & nace_both== 64

replace	c_adv=	0 if cntry== "ES" & essround== 1 & nace_both== 64

replace	c_adv=	0 if cntry== "SE" & essround== 1 & nace_both== 64

replace	c_adv=	0 if cntry== "CH" & essround== 1 & nace_both== 64

replace	c_adv=	0 if cntry== "TR" & essround== 1 & nace_both== 64

replace	c_adv=	0 if cntry== "GB" & essround== 1 & nace_both== 64

replace	c_adv=	0 if cntry== "AT" & essround== 1 & nace_both== 65

replace	c_adv=	0 if cntry== "BE" & essround== 1 & nace_both== 65

replace	c_adv=	0 if cntry== "CZ" & essround== 1 & nace_both== 65

replace	c_adv=	0 if cntry== "DK" & essround== 1 & nace_both== 65

replace	c_adv=	0 if cntry== "FI" & essround== 1 & nace_both== 65

replace	c_adv=	0 if cntry== "FR" & essround== 1 & nace_both== 65

replace	c_adv=	0 if cntry== "DE" & essround== 1 & nace_both== 65

replace	c_adv=	0 if cntry== "GR" & essround== 1 & nace_both== 65

replace	c_adv=	0 if cntry== "HU" & essround== 1 & nace_both== 65

replace	c_adv=	0 if cntry== "IS" & essround== 1 & nace_both== 65

replace	c_adv=	0 if cntry== "IE" & essround== 1 & nace_both== 65

replace	c_adv=	0 if cntry== "IT" & essround== 1 & nace_both== 65

replace	c_adv=	0 if cntry== "LU" & essround== 1 & nace_both== 65

replace	c_adv=	0 if cntry== "NL" & essround== 1 & nace_both== 65

replace	c_adv=	0 if cntry== "NO" & essround== 1 & nace_both== 65

replace	c_adv=	0 if cntry== "PL" & essround== 1 & nace_both== 65

replace	c_adv=	0 if cntry== "PT" & essround== 1 & nace_both== 65

replace	c_adv=	0 if cntry== "SK" & essround== 1 & nace_both== 65

replace	c_adv=	0 if cntry== "ES" & essround== 1 & nace_both== 65

replace	c_adv=	0 if cntry== "SE" & essround== 1 & nace_both== 65

replace	c_adv=	0 if cntry== "CH" & essround== 1 & nace_both== 65

replace	c_adv=	0 if cntry== "TR" & essround== 1 & nace_both== 65

replace	c_adv=	0 if cntry== "GB" & essround== 1 & nace_both== 65

replace	c_adv=	0 if cntry== "AT" & essround== 1 & nace_both== 66

replace	c_adv=	0 if cntry== "BE" & essround== 1 & nace_both== 66

replace	c_adv=	0 if cntry== "CZ" & essround== 1 & nace_both== 66

replace	c_adv=	0 if cntry== "DK" & essround== 1 & nace_both== 66

replace	c_adv=	0 if cntry== "FI" & essround== 1 & nace_both== 66

replace	c_adv=	0 if cntry== "FR" & essround== 1 & nace_both== 66

replace	c_adv=	0 if cntry== "DE" & essround== 1 & nace_both== 66

replace	c_adv=	0 if cntry== "GR" & essround== 1 & nace_both== 66

replace	c_adv=	0 if cntry== "HU" & essround== 1 & nace_both== 66

replace	c_adv=	0 if cntry== "IS" & essround== 1 & nace_both== 66

replace	c_adv=	0 if cntry== "IE" & essround== 1 & nace_both== 66

replace	c_adv=	0 if cntry== "IT" & essround== 1 & nace_both== 66

replace	c_adv=	0 if cntry== "LU" & essround== 1 & nace_both== 66

replace	c_adv=	0 if cntry== "NL" & essround== 1 & nace_both== 66

replace	c_adv=	0 if cntry== "NO" & essround== 1 & nace_both== 66

replace	c_adv=	0 if cntry== "PL" & essround== 1 & nace_both== 66

replace	c_adv=	0 if cntry== "PT" & essround== 1 & nace_both== 66

replace	c_adv=	0 if cntry== "SK" & essround== 1 & nace_both== 66

replace	c_adv=	0 if cntry== "ES" & essround== 1 & nace_both== 66

replace	c_adv=	0 if cntry== "SE" & essround== 1 & nace_both== 66

replace	c_adv=	0 if cntry== "CH" & essround== 1 & nace_both== 66

replace	c_adv=	0 if cntry== "TR" & essround== 1 & nace_both== 66

replace	c_adv=	0 if cntry== "GB" & essround== 1 & nace_both== 66

replace	c_adv=	0 if cntry== "AT" & essround== 1 & nace_both== 67

replace	c_adv=	0 if cntry== "BE" & essround== 1 & nace_both== 67

replace	c_adv=	0 if cntry== "CZ" & essround== 1 & nace_both== 67

replace	c_adv=	0 if cntry== "DK" & essround== 1 & nace_both== 67

replace	c_adv=	0 if cntry== "FI" & essround== 1 & nace_both== 67

replace	c_adv=	0 if cntry== "FR" & essround== 1 & nace_both== 67

replace	c_adv=	0 if cntry== "DE" & essround== 1 & nace_both== 67

replace	c_adv=	0 if cntry== "GR" & essround== 1 & nace_both== 67

replace	c_adv=	0 if cntry== "HU" & essround== 1 & nace_both== 67

replace	c_adv=	0 if cntry== "IS" & essround== 1 & nace_both== 67

replace	c_adv=	0 if cntry== "IE" & essround== 1 & nace_both== 67

replace	c_adv=	0 if cntry== "IT" & essround== 1 & nace_both== 67

replace	c_adv=	0 if cntry== "LU" & essround== 1 & nace_both== 67

replace	c_adv=	0 if cntry== "NL" & essround== 1 & nace_both== 67

replace	c_adv=	0 if cntry== "NO" & essround== 1 & nace_both== 67

replace	c_adv=	0 if cntry== "PL" & essround== 1 & nace_both== 67

replace	c_adv=	0 if cntry== "PT" & essround== 1 & nace_both== 67

replace	c_adv=	0 if cntry== "SK" & essround== 1 & nace_both== 67

replace	c_adv=	0 if cntry== "ES" & essround== 1 & nace_both== 67

replace	c_adv=	0 if cntry== "SE" & essround== 1 & nace_both== 67

replace	c_adv=	0 if cntry== "CH" & essround== 1 & nace_both== 67

replace	c_adv=	0 if cntry== "TR" & essround== 1 & nace_both== 67

replace	c_adv=	0 if cntry== "GB" & essround== 1 & nace_both== 67

replace	c_adv=	0 if cntry== "AT" & essround== 1 & nace_both== 70

replace	c_adv=	0 if cntry== "BE" & essround== 1 & nace_both== 70

replace	c_adv=	0 if cntry== "CZ" & essround== 1 & nace_both== 70

replace	c_adv=	0 if cntry== "DK" & essround== 1 & nace_both== 70

replace	c_adv=	0 if cntry== "FI" & essround== 1 & nace_both== 70

replace	c_adv=	0 if cntry== "FR" & essround== 1 & nace_both== 70

replace	c_adv=	0 if cntry== "DE" & essround== 1 & nace_both== 70

replace	c_adv=	0 if cntry== "GR" & essround== 1 & nace_both== 70

replace	c_adv=	0 if cntry== "HU" & essround== 1 & nace_both== 70

replace	c_adv=	0 if cntry== "IS" & essround== 1 & nace_both== 70

replace	c_adv=	0 if cntry== "IE" & essround== 1 & nace_both== 70

replace	c_adv=	0 if cntry== "IT" & essround== 1 & nace_both== 70

replace	c_adv=	0 if cntry== "LU" & essround== 1 & nace_both== 70

replace	c_adv=	0 if cntry== "NL" & essround== 1 & nace_both== 70

replace	c_adv=	0 if cntry== "NO" & essround== 1 & nace_both== 70

replace	c_adv=	0 if cntry== "PL" & essround== 1 & nace_both== 70

replace	c_adv=	0 if cntry== "PT" & essround== 1 & nace_both== 70

replace	c_adv=	0 if cntry== "SK" & essround== 1 & nace_both== 70

replace	c_adv=	0 if cntry== "ES" & essround== 1 & nace_both== 70

replace	c_adv=	0 if cntry== "SE" & essround== 1 & nace_both== 70

replace	c_adv=	0 if cntry== "CH" & essround== 1 & nace_both== 70

replace	c_adv=	0 if cntry== "TR" & essround== 1 & nace_both== 70

replace	c_adv=	0 if cntry== "GB" & essround== 1 & nace_both== 70

replace	c_adv=	0 if cntry== "AT" & essround== 1 & nace_both== 71

replace	c_adv=	0 if cntry== "BE" & essround== 1 & nace_both== 71

replace	c_adv=	0 if cntry== "CZ" & essround== 1 & nace_both== 71

replace	c_adv=	0 if cntry== "DK" & essround== 1 & nace_both== 71

replace	c_adv=	0 if cntry== "FI" & essround== 1 & nace_both== 71

replace	c_adv=	0 if cntry== "FR" & essround== 1 & nace_both== 71

replace	c_adv=	0 if cntry== "DE" & essround== 1 & nace_both== 71

replace	c_adv=	0 if cntry== "GR" & essround== 1 & nace_both== 71

replace	c_adv=	0 if cntry== "HU" & essround== 1 & nace_both== 71

replace	c_adv=	0 if cntry== "IS" & essround== 1 & nace_both== 71

replace	c_adv=	0 if cntry== "IE" & essround== 1 & nace_both== 71

replace	c_adv=	0 if cntry== "IT" & essround== 1 & nace_both== 71

replace	c_adv=	0 if cntry== "LU" & essround== 1 & nace_both== 71

replace	c_adv=	0 if cntry== "NL" & essround== 1 & nace_both== 71

replace	c_adv=	0 if cntry== "NO" & essround== 1 & nace_both== 71

replace	c_adv=	0 if cntry== "PL" & essround== 1 & nace_both== 71

replace	c_adv=	0 if cntry== "PT" & essround== 1 & nace_both== 71

replace	c_adv=	0 if cntry== "SK" & essround== 1 & nace_both== 71

replace	c_adv=	0 if cntry== "ES" & essround== 1 & nace_both== 71

replace	c_adv=	0 if cntry== "SE" & essround== 1 & nace_both== 71

replace	c_adv=	0 if cntry== "CH" & essround== 1 & nace_both== 71

replace	c_adv=	0 if cntry== "TR" & essround== 1 & nace_both== 71

replace	c_adv=	0 if cntry== "GB" & essround== 1 & nace_both== 71

replace	c_adv=	0 if cntry== "AT" & essround== 1 & nace_both== 72

replace	c_adv=	0 if cntry== "BE" & essround== 1 & nace_both== 72

replace	c_adv=	0 if cntry== "CZ" & essround== 1 & nace_both== 72

replace	c_adv=	0 if cntry== "DK" & essround== 1 & nace_both== 72

replace	c_adv=	0 if cntry== "FI" & essround== 1 & nace_both== 72

replace	c_adv=	0 if cntry== "FR" & essround== 1 & nace_both== 72

replace	c_adv=	0 if cntry== "DE" & essround== 1 & nace_both== 72

replace	c_adv=	0 if cntry== "GR" & essround== 1 & nace_both== 72

replace	c_adv=	0 if cntry== "HU" & essround== 1 & nace_both== 72

replace	c_adv=	0 if cntry== "IS" & essround== 1 & nace_both== 72

replace	c_adv=	0 if cntry== "IE" & essround== 1 & nace_both== 72

replace	c_adv=	0 if cntry== "IT" & essround== 1 & nace_both== 72

replace	c_adv=	0 if cntry== "LU" & essround== 1 & nace_both== 72

replace	c_adv=	0 if cntry== "NL" & essround== 1 & nace_both== 72

replace	c_adv=	0 if cntry== "NO" & essround== 1 & nace_both== 72

replace	c_adv=	0 if cntry== "PL" & essround== 1 & nace_both== 72

replace	c_adv=	0 if cntry== "PT" & essround== 1 & nace_both== 72

replace	c_adv=	0 if cntry== "SK" & essround== 1 & nace_both== 72

replace	c_adv=	0 if cntry== "ES" & essround== 1 & nace_both== 72

replace	c_adv=	0 if cntry== "SE" & essround== 1 & nace_both== 72

replace	c_adv=	0 if cntry== "CH" & essround== 1 & nace_both== 72

replace	c_adv=	0 if cntry== "TR" & essround== 1 & nace_both== 72

replace	c_adv=	0 if cntry== "GB" & essround== 1 & nace_both== 72

replace	c_adv=	0 if cntry== "AT" & essround== 1 & nace_both== 73

replace	c_adv=	0 if cntry== "BE" & essround== 1 & nace_both== 73

replace	c_adv=	0 if cntry== "CZ" & essround== 1 & nace_both== 73

replace	c_adv=	0 if cntry== "DK" & essround== 1 & nace_both== 73

replace	c_adv=	0 if cntry== "FI" & essround== 1 & nace_both== 73

replace	c_adv=	0 if cntry== "FR" & essround== 1 & nace_both== 73

replace	c_adv=	0 if cntry== "DE" & essround== 1 & nace_both== 73

replace	c_adv=	0 if cntry== "GR" & essround== 1 & nace_both== 73

replace	c_adv=	0 if cntry== "HU" & essround== 1 & nace_both== 73

replace	c_adv=	0 if cntry== "IS" & essround== 1 & nace_both== 73

replace	c_adv=	0 if cntry== "IE" & essround== 1 & nace_both== 73

replace	c_adv=	0 if cntry== "IT" & essround== 1 & nace_both== 73

replace	c_adv=	0 if cntry== "LU" & essround== 1 & nace_both== 73

replace	c_adv=	0 if cntry== "NL" & essround== 1 & nace_both== 73

replace	c_adv=	0 if cntry== "NO" & essround== 1 & nace_both== 73

replace	c_adv=	0 if cntry== "PL" & essround== 1 & nace_both== 73

replace	c_adv=	0 if cntry== "PT" & essround== 1 & nace_both== 73

replace	c_adv=	0 if cntry== "SK" & essround== 1 & nace_both== 73

replace	c_adv=	0 if cntry== "ES" & essround== 1 & nace_both== 73

replace	c_adv=	0 if cntry== "SE" & essround== 1 & nace_both== 73

replace	c_adv=	0 if cntry== "CH" & essround== 1 & nace_both== 73

replace	c_adv=	0 if cntry== "TR" & essround== 1 & nace_both== 73

replace	c_adv=	0 if cntry== "GB" & essround== 1 & nace_both== 73

replace	c_adv=	1 if cntry== "AT" & essround== 1 & nace_both== 74

replace	c_adv=	-1 if cntry== "BE" & essround== 1 & nace_both== 74

replace	c_adv=	1 if cntry== "CZ" & essround== 1 & nace_both== 74

replace	c_adv=	-1 if cntry== "DK" & essround== 1 & nace_both== 74

replace	c_adv=	-1 if cntry== "FI" & essround== 1 & nace_both== 74

replace	c_adv=	-1 if cntry== "FR" & essround== 1 & nace_both== 74

replace	c_adv=	1 if cntry== "DE" & essround== 1 & nace_both== 74

replace	c_adv=	-1 if cntry== "GR" & essround== 1 & nace_both== 74

replace	c_adv=	-1 if cntry== "HU" & essround== 1 & nace_both== 74

replace	c_adv=	0 if cntry== "IS" & essround== 1 & nace_both== 74

replace	c_adv=	-1 if cntry== "IE" & essround== 1 & nace_both== 74

replace	c_adv=	-1 if cntry== "IT" & essround== 1 & nace_both== 74

replace	c_adv=	-1 if cntry== "LU" & essround== 1 & nace_both== 74

replace	c_adv=	-1 if cntry== "NL" & essround== 1 & nace_both== 74

replace	c_adv=	-1 if cntry== "NO" & essround== 1 & nace_both== 74

replace	c_adv=	-1 if cntry== "PL" & essround== 1 & nace_both== 74

replace	c_adv=	-1 if cntry== "PT" & essround== 1 & nace_both== 74

replace	c_adv=	-1 if cntry== "SK" & essround== 1 & nace_both== 74

replace	c_adv=	-1 if cntry== "ES" & essround== 1 & nace_both== 74

replace	c_adv=	-1 if cntry== "SE" & essround== 1 & nace_both== 74

replace	c_adv=	1 if cntry== "CH" & essround== 1 & nace_both== 74

replace	c_adv=	0 if cntry== "TR" & essround== 1 & nace_both== 74

replace	c_adv=	1 if cntry== "GB" & essround== 1 & nace_both== 74

replace	c_adv=	0 if cntry== "AT" & essround== 1 & nace_both== 75

replace	c_adv=	0 if cntry== "BE" & essround== 1 & nace_both== 75

replace	c_adv=	0 if cntry== "CZ" & essround== 1 & nace_both== 75

replace	c_adv=	0 if cntry== "DK" & essround== 1 & nace_both== 75

replace	c_adv=	0 if cntry== "FI" & essround== 1 & nace_both== 75

replace	c_adv=	0 if cntry== "FR" & essround== 1 & nace_both== 75

replace	c_adv=	0 if cntry== "DE" & essround== 1 & nace_both== 75

replace	c_adv=	0 if cntry== "GR" & essround== 1 & nace_both== 75

replace	c_adv=	0 if cntry== "HU" & essround== 1 & nace_both== 75

replace	c_adv=	0 if cntry== "IS" & essround== 1 & nace_both== 75

replace	c_adv=	0 if cntry== "IE" & essround== 1 & nace_both== 75

replace	c_adv=	0 if cntry== "IT" & essround== 1 & nace_both== 75

replace	c_adv=	0 if cntry== "LU" & essround== 1 & nace_both== 75

replace	c_adv=	0 if cntry== "NL" & essround== 1 & nace_both== 75

replace	c_adv=	0 if cntry== "NO" & essround== 1 & nace_both== 75

replace	c_adv=	0 if cntry== "PL" & essround== 1 & nace_both== 75

replace	c_adv=	0 if cntry== "PT" & essround== 1 & nace_both== 75

replace	c_adv=	0 if cntry== "SK" & essround== 1 & nace_both== 75

replace	c_adv=	0 if cntry== "ES" & essround== 1 & nace_both== 75

replace	c_adv=	0 if cntry== "SE" & essround== 1 & nace_both== 75

replace	c_adv=	0 if cntry== "CH" & essround== 1 & nace_both== 75

replace	c_adv=	0 if cntry== "TR" & essround== 1 & nace_both== 75

replace	c_adv=	0 if cntry== "GB" & essround== 1 & nace_both== 75

replace	c_adv=	0 if cntry== "AT" & essround== 1 & nace_both== 80

replace	c_adv=	0 if cntry== "BE" & essround== 1 & nace_both== 80

replace	c_adv=	0 if cntry== "CZ" & essround== 1 & nace_both== 80

replace	c_adv=	0 if cntry== "DK" & essround== 1 & nace_both== 80

replace	c_adv=	0 if cntry== "FI" & essround== 1 & nace_both== 80

replace	c_adv=	0 if cntry== "FR" & essround== 1 & nace_both== 80

replace	c_adv=	0 if cntry== "DE" & essround== 1 & nace_both== 80

replace	c_adv=	0 if cntry== "GR" & essround== 1 & nace_both== 80

replace	c_adv=	0 if cntry== "HU" & essround== 1 & nace_both== 80

replace	c_adv=	0 if cntry== "IS" & essround== 1 & nace_both== 80

replace	c_adv=	0 if cntry== "IE" & essround== 1 & nace_both== 80

replace	c_adv=	0 if cntry== "IT" & essround== 1 & nace_both== 80

replace	c_adv=	0 if cntry== "LU" & essround== 1 & nace_both== 80

replace	c_adv=	0 if cntry== "NL" & essround== 1 & nace_both== 80

replace	c_adv=	0 if cntry== "NO" & essround== 1 & nace_both== 80

replace	c_adv=	0 if cntry== "PL" & essround== 1 & nace_both== 80

replace	c_adv=	0 if cntry== "PT" & essround== 1 & nace_both== 80

replace	c_adv=	0 if cntry== "SK" & essround== 1 & nace_both== 80

replace	c_adv=	0 if cntry== "ES" & essround== 1 & nace_both== 80

replace	c_adv=	0 if cntry== "SE" & essround== 1 & nace_both== 80

replace	c_adv=	0 if cntry== "CH" & essround== 1 & nace_both== 80

replace	c_adv=	0 if cntry== "TR" & essround== 1 & nace_both== 80

replace	c_adv=	0 if cntry== "GB" & essround== 1 & nace_both== 80

replace	c_adv=	0 if cntry== "AT" & essround== 1 & nace_both== 85

replace	c_adv=	0 if cntry== "BE" & essround== 1 & nace_both== 85

replace	c_adv=	0 if cntry== "CZ" & essround== 1 & nace_both== 85

replace	c_adv=	0 if cntry== "DK" & essround== 1 & nace_both== 85

replace	c_adv=	0 if cntry== "FI" & essround== 1 & nace_both== 85

replace	c_adv=	0 if cntry== "FR" & essround== 1 & nace_both== 85

replace	c_adv=	0 if cntry== "DE" & essround== 1 & nace_both== 85

replace	c_adv=	0 if cntry== "GR" & essround== 1 & nace_both== 85

replace	c_adv=	0 if cntry== "HU" & essround== 1 & nace_both== 85

replace	c_adv=	0 if cntry== "IS" & essround== 1 & nace_both== 85

replace	c_adv=	0 if cntry== "IE" & essround== 1 & nace_both== 85

replace	c_adv=	0 if cntry== "IT" & essround== 1 & nace_both== 85

replace	c_adv=	0 if cntry== "LU" & essround== 1 & nace_both== 85

replace	c_adv=	0 if cntry== "NL" & essround== 1 & nace_both== 85

replace	c_adv=	0 if cntry== "NO" & essround== 1 & nace_both== 85

replace	c_adv=	0 if cntry== "PL" & essround== 1 & nace_both== 85

replace	c_adv=	0 if cntry== "PT" & essround== 1 & nace_both== 85

replace	c_adv=	0 if cntry== "SK" & essround== 1 & nace_both== 85

replace	c_adv=	0 if cntry== "ES" & essround== 1 & nace_both== 85

replace	c_adv=	0 if cntry== "SE" & essround== 1 & nace_both== 85

replace	c_adv=	0 if cntry== "CH" & essround== 1 & nace_both== 85

replace	c_adv=	0 if cntry== "TR" & essround== 1 & nace_both== 85

replace	c_adv=	0 if cntry== "GB" & essround== 1 & nace_both== 85

replace	c_adv=	0 if cntry== "AT" & essround== 1 & nace_both== 90

replace	c_adv=	0 if cntry== "BE" & essround== 1 & nace_both== 90

replace	c_adv=	0 if cntry== "CZ" & essround== 1 & nace_both== 90

replace	c_adv=	0 if cntry== "DK" & essround== 1 & nace_both== 90

replace	c_adv=	0 if cntry== "FI" & essround== 1 & nace_both== 90

replace	c_adv=	0 if cntry== "FR" & essround== 1 & nace_both== 90

replace	c_adv=	0 if cntry== "DE" & essround== 1 & nace_both== 90

replace	c_adv=	0 if cntry== "GR" & essround== 1 & nace_both== 90

replace	c_adv=	0 if cntry== "HU" & essround== 1 & nace_both== 90

replace	c_adv=	0 if cntry== "IS" & essround== 1 & nace_both== 90

replace	c_adv=	0 if cntry== "IE" & essround== 1 & nace_both== 90

replace	c_adv=	0 if cntry== "IT" & essround== 1 & nace_both== 90

replace	c_adv=	0 if cntry== "LU" & essround== 1 & nace_both== 90

replace	c_adv=	0 if cntry== "NL" & essround== 1 & nace_both== 90

replace	c_adv=	0 if cntry== "NO" & essround== 1 & nace_both== 90

replace	c_adv=	0 if cntry== "PL" & essround== 1 & nace_both== 90

replace	c_adv=	0 if cntry== "PT" & essround== 1 & nace_both== 90

replace	c_adv=	0 if cntry== "SK" & essround== 1 & nace_both== 90

replace	c_adv=	0 if cntry== "ES" & essround== 1 & nace_both== 90

replace	c_adv=	0 if cntry== "SE" & essround== 1 & nace_both== 90

replace	c_adv=	0 if cntry== "CH" & essround== 1 & nace_both== 90

replace	c_adv=	0 if cntry== "TR" & essround== 1 & nace_both== 90

replace	c_adv=	0 if cntry== "GB" & essround== 1 & nace_both== 90

replace	c_adv=	0 if cntry== "AT" & essround== 1 & nace_both== 91

replace	c_adv=	0 if cntry== "BE" & essround== 1 & nace_both== 91

replace	c_adv=	0 if cntry== "CZ" & essround== 1 & nace_both== 91

replace	c_adv=	0 if cntry== "DK" & essround== 1 & nace_both== 91

replace	c_adv=	0 if cntry== "FI" & essround== 1 & nace_both== 91

replace	c_adv=	0 if cntry== "FR" & essround== 1 & nace_both== 91

replace	c_adv=	0 if cntry== "DE" & essround== 1 & nace_both== 91

replace	c_adv=	0 if cntry== "GR" & essround== 1 & nace_both== 91

replace	c_adv=	0 if cntry== "HU" & essround== 1 & nace_both== 91

replace	c_adv=	0 if cntry== "IS" & essround== 1 & nace_both== 91

replace	c_adv=	0 if cntry== "IE" & essround== 1 & nace_both== 91

replace	c_adv=	0 if cntry== "IT" & essround== 1 & nace_both== 91

replace	c_adv=	0 if cntry== "LU" & essround== 1 & nace_both== 91

replace	c_adv=	0 if cntry== "NL" & essround== 1 & nace_both== 91

replace	c_adv=	0 if cntry== "NO" & essround== 1 & nace_both== 91

replace	c_adv=	0 if cntry== "PL" & essround== 1 & nace_both== 91

replace	c_adv=	0 if cntry== "PT" & essround== 1 & nace_both== 91

replace	c_adv=	0 if cntry== "SK" & essround== 1 & nace_both== 91

replace	c_adv=	0 if cntry== "ES" & essround== 1 & nace_both== 91

replace	c_adv=	0 if cntry== "SE" & essround== 1 & nace_both== 91

replace	c_adv=	0 if cntry== "CH" & essround== 1 & nace_both== 91

replace	c_adv=	0 if cntry== "TR" & essround== 1 & nace_both== 91

replace	c_adv=	0 if cntry== "GB" & essround== 1 & nace_both== 91

replace	c_adv=	-1 if cntry== "AT" & essround== 1 & nace_both== 92

replace	c_adv=	-1 if cntry== "BE" & essround== 1 & nace_both== 92

replace	c_adv=	-1 if cntry== "CZ" & essround== 1 & nace_both== 92

replace	c_adv=	-1 if cntry== "DK" & essround== 1 & nace_both== 92

replace	c_adv=	0 if cntry== "FI" & essround== 1 & nace_both== 92

replace	c_adv=	1 if cntry== "FR" & essround== 1 & nace_both== 92

replace	c_adv=	-1 if cntry== "DE" & essround== 1 & nace_both== 92

replace	c_adv=	-1 if cntry== "GR" & essround== 1 & nace_both== 92

replace	c_adv=	-1 if cntry== "HU" & essround== 1 & nace_both== 92

replace	c_adv=	-1 if cntry== "IS" & essround== 1 & nace_both== 92

replace	c_adv=	-1 if cntry== "IE" & essround== 1 & nace_both== 92

replace	c_adv=	-1 if cntry== "IT" & essround== 1 & nace_both== 92

replace	c_adv=	-1 if cntry== "LU" & essround== 1 & nace_both== 92

replace	c_adv=	-1 if cntry== "NL" & essround== 1 & nace_both== 92

replace	c_adv=	-1 if cntry== "NO" & essround== 1 & nace_both== 92

replace	c_adv=	-1 if cntry== "PL" & essround== 1 & nace_both== 92

replace	c_adv=	-1 if cntry== "PT" & essround== 1 & nace_both== 92

replace	c_adv=	-1 if cntry== "SK" & essround== 1 & nace_both== 92

replace	c_adv=	-1 if cntry== "ES" & essround== 1 & nace_both== 92

replace	c_adv=	-1 if cntry== "SE" & essround== 1 & nace_both== 92

replace	c_adv=	1 if cntry== "CH" & essround== 1 & nace_both== 92

replace	c_adv=	0 if cntry== "TR" & essround== 1 & nace_both== 92

replace	c_adv=	1 if cntry== "GB" & essround== 1 & nace_both== 92

replace	c_adv=	0 if cntry== "AT" & essround== 1 & nace_both== 93

replace	c_adv=	0 if cntry== "BE" & essround== 1 & nace_both== 93

replace	c_adv=	0 if cntry== "CZ" & essround== 1 & nace_both== 93

replace	c_adv=	0 if cntry== "DK" & essround== 1 & nace_both== 93

replace	c_adv=	0 if cntry== "FI" & essround== 1 & nace_both== 93

replace	c_adv=	0 if cntry== "FR" & essround== 1 & nace_both== 93

replace	c_adv=	0 if cntry== "DE" & essround== 1 & nace_both== 93

replace	c_adv=	0 if cntry== "GR" & essround== 1 & nace_both== 93

replace	c_adv=	0 if cntry== "HU" & essround== 1 & nace_both== 93

replace	c_adv=	0 if cntry== "IS" & essround== 1 & nace_both== 93

replace	c_adv=	0 if cntry== "IE" & essround== 1 & nace_both== 93

replace	c_adv=	0 if cntry== "IT" & essround== 1 & nace_both== 93

replace	c_adv=	0 if cntry== "LU" & essround== 1 & nace_both== 93

replace	c_adv=	0 if cntry== "NL" & essround== 1 & nace_both== 93

replace	c_adv=	0 if cntry== "NO" & essround== 1 & nace_both== 93

replace	c_adv=	0 if cntry== "PL" & essround== 1 & nace_both== 93

replace	c_adv=	0 if cntry== "PT" & essround== 1 & nace_both== 93

replace	c_adv=	0 if cntry== "SK" & essround== 1 & nace_both== 93

replace	c_adv=	0 if cntry== "ES" & essround== 1 & nace_both== 93

replace	c_adv=	0 if cntry== "SE" & essround== 1 & nace_both== 93

replace	c_adv=	0 if cntry== "CH" & essround== 1 & nace_both== 93

replace	c_adv=	0 if cntry== "TR" & essround== 1 & nace_both== 93

replace	c_adv=	0 if cntry== "GB" & essround== 1 & nace_both== 93

replace	c_adv=	0 if cntry== "AT" & essround== 1 & nace_both== 95

replace	c_adv=	0 if cntry== "BE" & essround== 1 & nace_both== 95

replace	c_adv=	0 if cntry== "CZ" & essround== 1 & nace_both== 95

replace	c_adv=	0 if cntry== "DK" & essround== 1 & nace_both== 95

replace	c_adv=	0 if cntry== "FI" & essround== 1 & nace_both== 95

replace	c_adv=	0 if cntry== "FR" & essround== 1 & nace_both== 95

replace	c_adv=	0 if cntry== "DE" & essround== 1 & nace_both== 95

replace	c_adv=	0 if cntry== "GR" & essround== 1 & nace_both== 95

replace	c_adv=	0 if cntry== "HU" & essround== 1 & nace_both== 95

replace	c_adv=	0 if cntry== "IS" & essround== 1 & nace_both== 95

replace	c_adv=	0 if cntry== "IE" & essround== 1 & nace_both== 95

replace	c_adv=	0 if cntry== "IT" & essround== 1 & nace_both== 95

replace	c_adv=	0 if cntry== "LU" & essround== 1 & nace_both== 95

replace	c_adv=	0 if cntry== "NL" & essround== 1 & nace_both== 95

replace	c_adv=	0 if cntry== "NO" & essround== 1 & nace_both== 95

replace	c_adv=	0 if cntry== "PL" & essround== 1 & nace_both== 95

replace	c_adv=	0 if cntry== "PT" & essround== 1 & nace_both== 95

replace	c_adv=	0 if cntry== "SK" & essround== 1 & nace_both== 95

replace	c_adv=	0 if cntry== "ES" & essround== 1 & nace_both== 95

replace	c_adv=	0 if cntry== "SE" & essround== 1 & nace_both== 95

replace	c_adv=	0 if cntry== "CH" & essround== 1 & nace_both== 95

replace	c_adv=	0 if cntry== "TR" & essround== 1 & nace_both== 95

replace	c_adv=	0 if cntry== "GB" & essround== 1 & nace_both== 95

replace	c_adv=	-1 if cntry== "AT" & essround== 1 & nace_both== 98

replace	c_adv=	0 if cntry== "BE" & essround== 1 & nace_both== 98

replace	c_adv=	0 if cntry== "CZ" & essround== 1 & nace_both== 98

replace	c_adv=	1 if cntry== "DK" & essround== 1 & nace_both== 98

replace	c_adv=	-1 if cntry== "FI" & essround== 1 & nace_both== 98

replace	c_adv=	0 if cntry== "FR" & essround== 1 & nace_both== 98

replace	c_adv=	-1 if cntry== "DE" & essround== 1 & nace_both== 98

replace	c_adv=	-1 if cntry== "GR" & essround== 1 & nace_both== 98

replace	c_adv=	-1 if cntry== "HU" & essround== 1 & nace_both== 98

replace	c_adv=	-1 if cntry== "IS" & essround== 1 & nace_both== 98

replace	c_adv=	1 if cntry== "IE" & essround== 1 & nace_both== 98

replace	c_adv=	0 if cntry== "IT" & essround== 1 & nace_both== 98

replace	c_adv=	-1 if cntry== "LU" & essround== 1 & nace_both== 98

replace	c_adv=	-1 if cntry== "NL" & essround== 1 & nace_both== 98

replace	c_adv=	1 if cntry== "NO" & essround== 1 & nace_both== 98

replace	c_adv=	0 if cntry== "PL" & essround== 1 & nace_both== 98

replace	c_adv=	0 if cntry== "PT" & essround== 1 & nace_both== 98

replace	c_adv=	0 if cntry== "SK" & essround== 1 & nace_both== 98

replace	c_adv=	-1 if cntry== "ES" & essround== 1 & nace_both== 98

replace	c_adv=	1 if cntry== "SE" & essround== 1 & nace_both== 98

replace	c_adv=	0 if cntry== "CH" & essround== 1 & nace_both== 98

replace	c_adv=	0 if cntry== "TR" & essround== 1 & nace_both== 98

replace	c_adv=	0 if cntry== "GB" & essround== 1 & nace_both== 98

replace	c_adv=	0 if cntry== "AT" & essround== 1 & nace_both== 99

replace	c_adv=	0 if cntry== "BE" & essround== 1 & nace_both== 99

replace	c_adv=	0 if cntry== "CZ" & essround== 1 & nace_both== 99

replace	c_adv=	0 if cntry== "DK" & essround== 1 & nace_both== 99

replace	c_adv=	0 if cntry== "FI" & essround== 1 & nace_both== 99

replace	c_adv=	0 if cntry== "FR" & essround== 1 & nace_both== 99

replace	c_adv=	0 if cntry== "DE" & essround== 1 & nace_both== 99

replace	c_adv=	0 if cntry== "GR" & essround== 1 & nace_both== 99

replace	c_adv=	0 if cntry== "HU" & essround== 1 & nace_both== 99

replace	c_adv=	0 if cntry== "IS" & essround== 1 & nace_both== 99

replace	c_adv=	0 if cntry== "IE" & essround== 1 & nace_both== 99

replace	c_adv=	0 if cntry== "IT" & essround== 1 & nace_both== 99

replace	c_adv=	0 if cntry== "LU" & essround== 1 & nace_both== 99

replace	c_adv=	0 if cntry== "NL" & essround== 1 & nace_both== 99

replace	c_adv=	0 if cntry== "NO" & essround== 1 & nace_both== 99

replace	c_adv=	0 if cntry== "PL" & essround== 1 & nace_both== 99

replace	c_adv=	0 if cntry== "PT" & essround== 1 & nace_both== 99

replace	c_adv=	0 if cntry== "SK" & essround== 1 & nace_both== 99

replace	c_adv=	0 if cntry== "ES" & essround== 1 & nace_both== 99

replace	c_adv=	0 if cntry== "SE" & essround== 1 & nace_both== 99

replace	c_adv=	0 if cntry== "CH" & essround== 1 & nace_both== 99

replace	c_adv=	0 if cntry== "TR" & essround== 1 & nace_both== 99

replace	c_adv=	0 if cntry== "GB" & essround== 1 & nace_both== 99

* EES Round 2004


replace	c_adv=	-1 if cntry== "AT" & essround== 2 & nace_both== 1

replace	c_adv=	-1 if cntry== "BE" & essround== 2 & nace_both== 1

replace	c_adv=	-1 if cntry== "CZ" & essround== 2 & nace_both== 1

replace	c_adv=	1 if cntry== "DK" & essround== 2 & nace_both== 1

replace	c_adv=	-1 if cntry== "FI" & essround== 2 & nace_both== 1

replace	c_adv=	1 if cntry== "FR" & essround== 2 & nace_both== 1

replace	c_adv=	-1 if cntry== "DE" & essround== 2 & nace_both== 1

replace	c_adv=	1 if cntry== "GR" & essround== 2 & nace_both== 1

replace	c_adv=	1 if cntry== "HU" & essround== 2 & nace_both== 1

replace	c_adv=	-1 if cntry== "IS" & essround== 2 & nace_both== 1

replace	c_adv=	-1 if cntry== "IE" & essround== 2 & nace_both== 1

replace	c_adv=	-1 if cntry== "IT" & essround== 2 & nace_both== 1

replace	c_adv=	-1 if cntry== "LU" & essround== 2 & nace_both== 1

replace	c_adv=	1 if cntry== "NL" & essround== 2 & nace_both== 1

replace	c_adv=	0 if cntry== "NO" & essround== 2 & nace_both== 1

replace	c_adv=	-1 if cntry== "PL" & essround== 2 & nace_both== 1

replace	c_adv=	-1 if cntry== "PT" & essround== 2 & nace_both== 1

replace	c_adv=	-1 if cntry== "SK" & essround== 2 & nace_both== 1

replace	c_adv=	1 if cntry== "ES" & essround== 2 & nace_both== 1

replace	c_adv=	-1 if cntry== "SE" & essround== 2 & nace_both== 1

replace	c_adv=	0 if cntry== "CH" & essround== 2 & nace_both== 1

replace	c_adv=	1 if cntry== "TR" & essround== 2 & nace_both== 1

replace	c_adv=	-1 if cntry== "GB" & essround== 2 & nace_both== 1

replace	c_adv=	1 if cntry== "AT" & essround== 2 & nace_both== 2

replace	c_adv=	-1 if cntry== "BE" & essround== 2 & nace_both== 2

replace	c_adv=	1 if cntry== "CZ" & essround== 2 & nace_both== 2

replace	c_adv=	1 if cntry== "DK" & essround== 2 & nace_both== 2

replace	c_adv=	1 if cntry== "FI" & essround== 2 & nace_both== 2

replace	c_adv=	1 if cntry== "FR" & essround== 2 & nace_both== 2

replace	c_adv=	-1 if cntry== "DE" & essround== 2 & nace_both== 2

replace	c_adv=	-1 if cntry== "GR" & essround== 2 & nace_both== 2

replace	c_adv=	1 if cntry== "HU" & essround== 2 & nace_both== 2

replace	c_adv=	0 if cntry== "IS" & essround== 2 & nace_both== 2

replace	c_adv=	-1 if cntry== "IE" & essround== 2 & nace_both== 2

replace	c_adv=	-1 if cntry== "IT" & essround== 2 & nace_both== 2

replace	c_adv=	1 if cntry== "LU" & essround== 2 & nace_both== 2

replace	c_adv=	-1 if cntry== "NL" & essround== 2 & nace_both== 2

replace	c_adv=	-1 if cntry== "NO" & essround== 2 & nace_both== 2

replace	c_adv=	1 if cntry== "PL" & essround== 2 & nace_both== 2

replace	c_adv=	1 if cntry== "PT" & essround== 2 & nace_both== 2

replace	c_adv=	1 if cntry== "SK" & essround== 2 & nace_both== 2

replace	c_adv=	-1 if cntry== "ES" & essround== 2 & nace_both== 2

replace	c_adv=	-1 if cntry== "SE" & essround== 2 & nace_both== 2

replace	c_adv=	1 if cntry== "CH" & essround== 2 & nace_both== 2

replace	c_adv=	-1 if cntry== "TR" & essround== 2 & nace_both== 2

replace	c_adv=	-1 if cntry== "GB" & essround== 2 & nace_both== 2

replace	c_adv=	0 if cntry== "AT" & essround== 2 & nace_both== 5

replace	c_adv=	-1 if cntry== "BE" & essround== 2 & nace_both== 5

replace	c_adv=	-1 if cntry== "CZ" & essround== 2 & nace_both== 5

replace	c_adv=	1 if cntry== "DK" & essround== 2 & nace_both== 5

replace	c_adv=	0 if cntry== "FI" & essround== 2 & nace_both== 5

replace	c_adv=	-1 if cntry== "FR" & essround== 2 & nace_both== 5

replace	c_adv=	-1 if cntry== "DE" & essround== 2 & nace_both== 5

replace	c_adv=	1 if cntry== "GR" & essround== 2 & nace_both== 5

replace	c_adv=	-1 if cntry== "HU" & essround== 2 & nace_both== 5

replace	c_adv=	1 if cntry== "IS" & essround== 2 & nace_both== 5

replace	c_adv=	1 if cntry== "IE" & essround== 2 & nace_both== 5

replace	c_adv=	-1 if cntry== "IT" & essround== 2 & nace_both== 5

replace	c_adv=	-1 if cntry== "LU" & essround== 2 & nace_both== 5

replace	c_adv=	1 if cntry== "NL" & essround== 2 & nace_both== 5

replace	c_adv=	1 if cntry== "NO" & essround== 2 & nace_both== 5

replace	c_adv=	-1 if cntry== "PL" & essround== 2 & nace_both== 5

replace	c_adv=	1 if cntry== "PT" & essround== 2 & nace_both== 5

replace	c_adv=	0 if cntry== "SK" & essround== 2 & nace_both== 5

replace	c_adv=	1 if cntry== "ES" & essround== 2 & nace_both== 5

replace	c_adv=	1 if cntry== "SE" & essround== 2 & nace_both== 5

replace	c_adv=	-1 if cntry== "CH" & essround== 2 & nace_both== 5

replace	c_adv=	1 if cntry== "TR" & essround== 2 & nace_both== 5

replace	c_adv=	1 if cntry== "GB" & essround== 2 & nace_both== 5

replace	c_adv=	0 if cntry== "AT" & essround== 2 & nace_both== 10

replace	c_adv=	-1 if cntry== "BE" & essround== 2 & nace_both== 10

replace	c_adv=	1 if cntry== "CZ" & essround== 2 & nace_both== 10

replace	c_adv=	0 if cntry== "DK" & essround== 2 & nace_both== 10

replace	c_adv=	-1 if cntry== "FI" & essround== 2 & nace_both== 10

replace	c_adv=	0 if cntry== "FR" & essround== 2 & nace_both== 10

replace	c_adv=	-1 if cntry== "DE" & essround== 2 & nace_both== 10

replace	c_adv=	-1 if cntry== "GR" & essround== 2 & nace_both== 10

replace	c_adv=	0 if cntry== "HU" & essround== 2 & nace_both== 10

replace	c_adv=	0 if cntry== "IS" & essround== 2 & nace_both== 10

replace	c_adv=	-1 if cntry== "IE" & essround== 2 & nace_both== 10

replace	c_adv=	0 if cntry== "IT" & essround== 2 & nace_both== 10

replace	c_adv=	0 if cntry== "LU" & essround== 2 & nace_both== 10

replace	c_adv=	-1 if cntry== "NL" & essround== 2 & nace_both== 10

replace	c_adv=	0 if cntry== "NO" & essround== 2 & nace_both== 10

replace	c_adv=	1 if cntry== "PL" & essround== 2 & nace_both== 10

replace	c_adv=	0 if cntry== "PT" & essround== 2 & nace_both== 10

replace	c_adv=	-1 if cntry== "SK" & essround== 2 & nace_both== 10

replace	c_adv=	0 if cntry== "ES" & essround== 2 & nace_both== 10

replace	c_adv=	-1 if cntry== "SE" & essround== 2 & nace_both== 10

replace	c_adv=	0 if cntry== "CH" & essround== 2 & nace_both== 10

replace	c_adv=	0 if cntry== "TR" & essround== 2 & nace_both== 10

replace	c_adv=	-1 if cntry== "GB" & essround== 2 & nace_both== 10

replace	c_adv=	-1 if cntry== "AT" & essround== 2 & nace_both== 11

replace	c_adv=	-1 if cntry== "BE" & essround== 2 & nace_both== 11

replace	c_adv=	0 if cntry== "CZ" & essround== 2 & nace_both== 11

replace	c_adv=	1 if cntry== "DK" & essround== 2 & nace_both== 11

replace	c_adv=	0 if cntry== "FI" & essround== 2 & nace_both== 11

replace	c_adv=	-1 if cntry== "FR" & essround== 2 & nace_both== 11

replace	c_adv=	0 if cntry== "DE" & essround== 2 & nace_both== 11

replace	c_adv=	0 if cntry== "GR" & essround== 2 & nace_both== 11

replace	c_adv=	0 if cntry== "HU" & essround== 2 & nace_both== 11

replace	c_adv=	0 if cntry== "IS" & essround== 2 & nace_both== 11

replace	c_adv=	0 if cntry== "IE" & essround== 2 & nace_both== 11

replace	c_adv=	0 if cntry== "IT" & essround== 2 & nace_both== 11

replace	c_adv=	0 if cntry== "LU" & essround== 2 & nace_both== 11

replace	c_adv=	0 if cntry== "NL" & essround== 2 & nace_both== 11

replace	c_adv=	1 if cntry== "NO" & essround== 2 & nace_both== 11

replace	c_adv=	0 if cntry== "PL" & essround== 2 & nace_both== 11

replace	c_adv=	0 if cntry== "PT" & essround== 2 & nace_both== 11

replace	c_adv=	0 if cntry== "SK" & essround== 2 & nace_both== 11

replace	c_adv=	-1 if cntry== "ES" & essround== 2 & nace_both== 11

replace	c_adv=	0 if cntry== "SE" & essround== 2 & nace_both== 11

replace	c_adv=	0 if cntry== "CH" & essround== 2 & nace_both== 11

replace	c_adv=	0 if cntry== "TR" & essround== 2 & nace_both== 11

replace	c_adv=	1 if cntry== "GB" & essround== 2 & nace_both== 11

replace	c_adv=	0 if cntry== "AT" & essround== 2 & nace_both== 12

replace	c_adv=	0 if cntry== "BE" & essround== 2 & nace_both== 12

replace	c_adv=	0 if cntry== "CZ" & essround== 2 & nace_both== 12

replace	c_adv=	0 if cntry== "DK" & essround== 2 & nace_both== 12

replace	c_adv=	0 if cntry== "FI" & essround== 2 & nace_both== 12

replace	c_adv=	0 if cntry== "FR" & essround== 2 & nace_both== 12

replace	c_adv=	0 if cntry== "DE" & essround== 2 & nace_both== 12

replace	c_adv=	-1 if cntry== "GR" & essround== 2 & nace_both== 12

replace	c_adv=	0 if cntry== "HU" & essround== 2 & nace_both== 12

replace	c_adv=	0 if cntry== "IS" & essround== 2 & nace_both== 12

replace	c_adv=	0 if cntry== "IE" & essround== 2 & nace_both== 12

replace	c_adv=	0 if cntry== "IT" & essround== 2 & nace_both== 12

replace	c_adv=	0 if cntry== "LU" & essround== 2 & nace_both== 12

replace	c_adv=	0 if cntry== "NL" & essround== 2 & nace_both== 12

replace	c_adv=	0 if cntry== "NO" & essround== 2 & nace_both== 12

replace	c_adv=	0 if cntry== "PL" & essround== 2 & nace_both== 12

replace	c_adv=	-1 if cntry== "PT" & essround== 2 & nace_both== 12

replace	c_adv=	0 if cntry== "SK" & essround== 2 & nace_both== 12

replace	c_adv=	0 if cntry== "ES" & essround== 2 & nace_both== 12

replace	c_adv=	0 if cntry== "SE" & essround== 2 & nace_both== 12

replace	c_adv=	0 if cntry== "CH" & essround== 2 & nace_both== 12

replace	c_adv=	0 if cntry== "TR" & essround== 2 & nace_both== 12

replace	c_adv=	0 if cntry== "GB" & essround== 2 & nace_both== 12

replace	c_adv=	0 if cntry== "AT" & essround== 2 & nace_both== 13

replace	c_adv=	-1 if cntry== "BE" & essround== 2 & nace_both== 13

replace	c_adv=	0 if cntry== "CZ" & essround== 2 & nace_both== 13

replace	c_adv=	0 if cntry== "DK" & essround== 2 & nace_both== 13

replace	c_adv=	-1 if cntry== "FI" & essround== 2 & nace_both== 13

replace	c_adv=	0 if cntry== "FR" & essround== 2 & nace_both== 13

replace	c_adv=	0 if cntry== "DE" & essround== 2 & nace_both== 13

replace	c_adv=	-1 if cntry== "GR" & essround== 2 & nace_both== 13

replace	c_adv=	0 if cntry== "HU" & essround== 2 & nace_both== 13

replace	c_adv=	0 if cntry== "IS" & essround== 2 & nace_both== 13

replace	c_adv=	-1 if cntry== "IE" & essround== 2 & nace_both== 13

replace	c_adv=	-1 if cntry== "IT" & essround== 2 & nace_both== 13

replace	c_adv=	-1 if cntry== "LU" & essround== 2 & nace_both== 13

replace	c_adv=	-1 if cntry== "NL" & essround== 2 & nace_both== 13

replace	c_adv=	-1 if cntry== "NO" & essround== 2 & nace_both== 13

replace	c_adv=	-1 if cntry== "PL" & essround== 2 & nace_both== 13

replace	c_adv=	1 if cntry== "PT" & essround== 2 & nace_both== 13

replace	c_adv=	-1 if cntry== "SK" & essround== 2 & nace_both== 13

replace	c_adv=	-1 if cntry== "ES" & essround== 2 & nace_both== 13

replace	c_adv=	1 if cntry== "SE" & essround== 2 & nace_both== 13

replace	c_adv=	0 if cntry== "CH" & essround== 2 & nace_both== 13

replace	c_adv=	1 if cntry== "TR" & essround== 2 & nace_both== 13

replace	c_adv=	0 if cntry== "GB" & essround== 2 & nace_both== 13

replace	c_adv=	-1 if cntry== "AT" & essround== 2 & nace_both== 14

replace	c_adv=	1 if cntry== "BE" & essround== 2 & nace_both== 14

replace	c_adv=	-1 if cntry== "CZ" & essround== 2 & nace_both== 14

replace	c_adv=	-1 if cntry== "DK" & essround== 2 & nace_both== 14

replace	c_adv=	-1 if cntry== "FI" & essround== 2 & nace_both== 14

replace	c_adv=	-1 if cntry== "FR" & essround== 2 & nace_both== 14

replace	c_adv=	-1 if cntry== "DE" & essround== 2 & nace_both== 14

replace	c_adv=	1 if cntry== "GR" & essround== 2 & nace_both== 14

replace	c_adv=	-1 if cntry== "HU" & essround== 2 & nace_both== 14

replace	c_adv=	-1 if cntry== "IS" & essround== 2 & nace_both== 14

replace	c_adv=	-1 if cntry== "IE" & essround== 2 & nace_both== 14

replace	c_adv=	-1 if cntry== "IT" & essround== 2 & nace_both== 14

replace	c_adv=	-1 if cntry== "LU" & essround== 2 & nace_both== 14

replace	c_adv=	-1 if cntry== "NL" & essround== 2 & nace_both== 14

replace	c_adv=	-1 if cntry== "NO" & essround== 2 & nace_both== 14

replace	c_adv=	-1 if cntry== "PL" & essround== 2 & nace_both== 14

replace	c_adv=	-1 if cntry== "PT" & essround== 2 & nace_both== 14

replace	c_adv=	-1 if cntry== "SK" & essround== 2 & nace_both== 14

replace	c_adv=	-1 if cntry== "ES" & essround== 2 & nace_both== 14

replace	c_adv=	-1 if cntry== "SE" & essround== 2 & nace_both== 14

replace	c_adv=	-1 if cntry== "CH" & essround== 2 & nace_both== 14

replace	c_adv=	1 if cntry== "TR" & essround== 2 & nace_both== 14

replace	c_adv=	1 if cntry== "GB" & essround== 2 & nace_both== 14

replace	c_adv=	1 if cntry== "AT" & essround== 2 & nace_both== 15

replace	c_adv=	1 if cntry== "BE" & essround== 2 & nace_both== 15

replace	c_adv=	-1 if cntry== "CZ" & essround== 2 & nace_both== 15

replace	c_adv=	1 if cntry== "DK" & essround== 2 & nace_both== 15

replace	c_adv=	-1 if cntry== "FI" & essround== 2 & nace_both== 15

replace	c_adv=	1 if cntry== "FR" & essround== 2 & nace_both== 15

replace	c_adv=	-1 if cntry== "DE" & essround== 2 & nace_both== 15

replace	c_adv=	1 if cntry== "GR" & essround== 2 & nace_both== 15

replace	c_adv=	-1 if cntry== "HU" & essround== 2 & nace_both== 15

replace	c_adv=	1 if cntry== "IS" & essround== 2 & nace_both== 15

replace	c_adv=	1 if cntry== "IE" & essround== 2 & nace_both== 15

replace	c_adv=	1 if cntry== "IT" & essround== 2 & nace_both== 15

replace	c_adv=	-1 if cntry== "LU" & essround== 2 & nace_both== 15

replace	c_adv=	1 if cntry== "NL" & essround== 2 & nace_both== 15

replace	c_adv=	-1 if cntry== "NO" & essround== 2 & nace_both== 15

replace	c_adv=	1 if cntry== "PL" & essround== 2 & nace_both== 15

replace	c_adv=	1 if cntry== "PT" & essround== 2 & nace_both== 15

replace	c_adv=	-1 if cntry== "SK" & essround== 2 & nace_both== 15

replace	c_adv=	1 if cntry== "ES" & essround== 2 & nace_both== 15

replace	c_adv=	-1 if cntry== "SE" & essround== 2 & nace_both== 15

replace	c_adv=	-1 if cntry== "CH" & essround== 2 & nace_both== 15

replace	c_adv=	1 if cntry== "TR" & essround== 2 & nace_both== 15

replace	c_adv=	-1 if cntry== "GB" & essround== 2 & nace_both== 15

replace	c_adv=	1 if cntry== "AT" & essround== 2 & nace_both== 16

replace	c_adv=	-1 if cntry== "BE" & essround== 2 & nace_both== 16

replace	c_adv=	-1 if cntry== "CZ" & essround== 2 & nace_both== 16

replace	c_adv=	1 if cntry== "DK" & essround== 2 & nace_both== 16

replace	c_adv=	0 if cntry== "FI" & essround== 2 & nace_both== 16

replace	c_adv=	-1 if cntry== "FR" & essround== 2 & nace_both== 16

replace	c_adv=	1 if cntry== "DE" & essround== 2 & nace_both== 16

replace	c_adv=	1 if cntry== "GR" & essround== 2 & nace_both== 16

replace	c_adv=	0 if cntry== "HU" & essround== 2 & nace_both== 16

replace	c_adv=	0 if cntry== "IS" & essround== 2 & nace_both== 16

replace	c_adv=	-1 if cntry== "IE" & essround== 2 & nace_both== 16

replace	c_adv=	0 if cntry== "IT" & essround== 2 & nace_both== 16

replace	c_adv=	1 if cntry== "LU" & essround== 2 & nace_both== 16

replace	c_adv=	1 if cntry== "NL" & essround== 2 & nace_both== 16

replace	c_adv=	-1 if cntry== "NO" & essround== 2 & nace_both== 16

replace	c_adv=	-1 if cntry== "PL" & essround== 2 & nace_both== 16

replace	c_adv=	1 if cntry== "PT" & essround== 2 & nace_both== 16

replace	c_adv=	-1 if cntry== "SK" & essround== 2 & nace_both== 16

replace	c_adv=	-1 if cntry== "ES" & essround== 2 & nace_both== 16

replace	c_adv=	-1 if cntry== "SE" & essround== 2 & nace_both== 16

replace	c_adv=	1 if cntry== "CH" & essround== 2 & nace_both== 16

replace	c_adv=	-1 if cntry== "TR" & essround== 2 & nace_both== 16

replace	c_adv=	1 if cntry== "GB" & essround== 2 & nace_both== 16

replace	c_adv=	1 if cntry== "AT" & essround== 2 & nace_both== 17

replace	c_adv=	1 if cntry== "BE" & essround== 2 & nace_both== 17

replace	c_adv=	1 if cntry== "CZ" & essround== 2 & nace_both== 17

replace	c_adv=	1 if cntry== "DK" & essround== 2 & nace_both== 17

replace	c_adv=	-1 if cntry== "FI" & essround== 2 & nace_both== 17

replace	c_adv=	1 if cntry== "FR" & essround== 2 & nace_both== 17

replace	c_adv=	-1 if cntry== "DE" & essround== 2 & nace_both== 17

replace	c_adv=	1 if cntry== "GR" & essround== 2 & nace_both== 17

replace	c_adv=	-1 if cntry== "HU" & essround== 2 & nace_both== 17

replace	c_adv=	-1 if cntry== "IS" & essround== 2 & nace_both== 17

replace	c_adv=	-1 if cntry== "IE" & essround== 2 & nace_both== 17

replace	c_adv=	1 if cntry== "IT" & essround== 2 & nace_both== 17

replace	c_adv=	1 if cntry== "LU" & essround== 2 & nace_both== 17

replace	c_adv=	-1 if cntry== "NL" & essround== 2 & nace_both== 17

replace	c_adv=	-1 if cntry== "NO" & essround== 2 & nace_both== 17

replace	c_adv=	1 if cntry== "PL" & essround== 2 & nace_both== 17

replace	c_adv=	1 if cntry== "PT" & essround== 2 & nace_both== 17

replace	c_adv=	-1 if cntry== "SK" & essround== 2 & nace_both== 17

replace	c_adv=	1 if cntry== "ES" & essround== 2 & nace_both== 17

replace	c_adv=	-1 if cntry== "SE" & essround== 2 & nace_both== 17

replace	c_adv=	-1 if cntry== "CH" & essround== 2 & nace_both== 17

replace	c_adv=	1 if cntry== "TR" & essround== 2 & nace_both== 17

replace	c_adv=	-1 if cntry== "GB" & essround== 2 & nace_both== 17

replace	c_adv=	1 if cntry== "AT" & essround== 2 & nace_both== 18

replace	c_adv=	1 if cntry== "BE" & essround== 2 & nace_both== 18

replace	c_adv=	1 if cntry== "CZ" & essround== 2 & nace_both== 18

replace	c_adv=	1 if cntry== "DK" & essround== 2 & nace_both== 18

replace	c_adv=	-1 if cntry== "FI" & essround== 2 & nace_both== 18

replace	c_adv=	1 if cntry== "FR" & essround== 2 & nace_both== 18

replace	c_adv=	-1 if cntry== "DE" & essround== 2 & nace_both== 18

replace	c_adv=	1 if cntry== "GR" & essround== 2 & nace_both== 18

replace	c_adv=	1 if cntry== "HU" & essround== 2 & nace_both== 18

replace	c_adv=	-1 if cntry== "IS" & essround== 2 & nace_both== 18

replace	c_adv=	-1 if cntry== "IE" & essround== 2 & nace_both== 18

replace	c_adv=	1 if cntry== "IT" & essround== 2 & nace_both== 18

replace	c_adv=	-1 if cntry== "LU" & essround== 2 & nace_both== 18

replace	c_adv=	-1 if cntry== "NL" & essround== 2 & nace_both== 18

replace	c_adv=	-1 if cntry== "NO" & essround== 2 & nace_both== 18

replace	c_adv=	1 if cntry== "PL" & essround== 2 & nace_both== 18

replace	c_adv=	1 if cntry== "PT" & essround== 2 & nace_both== 18

replace	c_adv=	1 if cntry== "SK" & essround== 2 & nace_both== 18

replace	c_adv=	1 if cntry== "ES" & essround== 2 & nace_both== 18

replace	c_adv=	-1 if cntry== "SE" & essround== 2 & nace_both== 18

replace	c_adv=	-1 if cntry== "CH" & essround== 2 & nace_both== 18

replace	c_adv=	1 if cntry== "TR" & essround== 2 & nace_both== 18

replace	c_adv=	-1 if cntry== "GB" & essround== 2 & nace_both== 18

replace	c_adv=	1 if cntry== "AT" & essround== 2 & nace_both== 19

replace	c_adv=	1 if cntry== "BE" & essround== 2 & nace_both== 19

replace	c_adv=	-1 if cntry== "CZ" & essround== 2 & nace_both== 19

replace	c_adv=	1 if cntry== "DK" & essround== 2 & nace_both== 19

replace	c_adv=	-1 if cntry== "FI" & essround== 2 & nace_both== 19

replace	c_adv=	1 if cntry== "FR" & essround== 2 & nace_both== 19

replace	c_adv=	-1 if cntry== "DE" & essround== 2 & nace_both== 19

replace	c_adv=	-1 if cntry== "GR" & essround== 2 & nace_both== 19

replace	c_adv=	1 if cntry== "HU" & essround== 2 & nace_both== 19

replace	c_adv=	-1 if cntry== "IS" & essround== 2 & nace_both== 19

replace	c_adv=	-1 if cntry== "IE" & essround== 2 & nace_both== 19

replace	c_adv=	1 if cntry== "IT" & essround== 2 & nace_both== 19

replace	c_adv=	-1 if cntry== "LU" & essround== 2 & nace_both== 19

replace	c_adv=	-1 if cntry== "NL" & essround== 2 & nace_both== 19

replace	c_adv=	-1 if cntry== "NO" & essround== 2 & nace_both== 19

replace	c_adv=	1 if cntry== "PL" & essround== 2 & nace_both== 19

replace	c_adv=	1 if cntry== "PT" & essround== 2 & nace_both== 19

replace	c_adv=	1 if cntry== "SK" & essround== 2 & nace_both== 19

replace	c_adv=	1 if cntry== "ES" & essround== 2 & nace_both== 19

replace	c_adv=	-1 if cntry== "SE" & essround== 2 & nace_both== 19

replace	c_adv=	-1 if cntry== "CH" & essround== 2 & nace_both== 19

replace	c_adv=	-1 if cntry== "TR" & essround== 2 & nace_both== 19

replace	c_adv=	-1 if cntry== "GB" & essround== 2 & nace_both== 19

replace	c_adv=	1 if cntry== "AT" & essround== 2 & nace_both== 20

replace	c_adv=	-1 if cntry== "BE" & essround== 2 & nace_both== 20

replace	c_adv=	1 if cntry== "CZ" & essround== 2 & nace_both== 20

replace	c_adv=	1 if cntry== "DK" & essround== 2 & nace_both== 20

replace	c_adv=	1 if cntry== "FI" & essround== 2 & nace_both== 20

replace	c_adv=	-1 if cntry== "FR" & essround== 2 & nace_both== 20

replace	c_adv=	-1 if cntry== "DE" & essround== 2 & nace_both== 20

replace	c_adv=	-1 if cntry== "GR" & essround== 2 & nace_both== 20

replace	c_adv=	-1 if cntry== "HU" & essround== 2 & nace_both== 20

replace	c_adv=	0 if cntry== "IS" & essround== 2 & nace_both== 20

replace	c_adv=	-1 if cntry== "IE" & essround== 2 & nace_both== 20

replace	c_adv=	-1 if cntry== "IT" & essround== 2 & nace_both== 20

replace	c_adv=	1 if cntry== "LU" & essround== 2 & nace_both== 20

replace	c_adv=	-1 if cntry== "NL" & essround== 2 & nace_both== 20

replace	c_adv=	-1 if cntry== "NO" & essround== 2 & nace_both== 20

replace	c_adv=	1 if cntry== "PL" & essround== 2 & nace_both== 20

replace	c_adv=	1 if cntry== "PT" & essround== 2 & nace_both== 20

replace	c_adv=	1 if cntry== "SK" & essround== 2 & nace_both== 20

replace	c_adv=	-1 if cntry== "ES" & essround== 2 & nace_both== 20

replace	c_adv=	1 if cntry== "SE" & essround== 2 & nace_both== 20

replace	c_adv=	-1 if cntry== "CH" & essround== 2 & nace_both== 20

replace	c_adv=	-1 if cntry== "TR" & essround== 2 & nace_both== 20

replace	c_adv=	-1 if cntry== "GB" & essround== 2 & nace_both== 20

replace	c_adv=	1 if cntry== "AT" & essround== 2 & nace_both== 21

replace	c_adv=	-1 if cntry== "BE" & essround== 2 & nace_both== 21

replace	c_adv=	-1 if cntry== "CZ" & essround== 2 & nace_both== 21

replace	c_adv=	-1 if cntry== "DK" & essround== 2 & nace_both== 21

replace	c_adv=	1 if cntry== "FI" & essround== 2 & nace_both== 21

replace	c_adv=	-1 if cntry== "FR" & essround== 2 & nace_both== 21

replace	c_adv=	-1 if cntry== "DE" & essround== 2 & nace_both== 21

replace	c_adv=	-1 if cntry== "GR" & essround== 2 & nace_both== 21

replace	c_adv=	-1 if cntry== "HU" & essround== 2 & nace_both== 21

replace	c_adv=	-1 if cntry== "IS" & essround== 2 & nace_both== 21

replace	c_adv=	-1 if cntry== "IE" & essround== 2 & nace_both== 21

replace	c_adv=	-1 if cntry== "IT" & essround== 2 & nace_both== 21

replace	c_adv=	1 if cntry== "LU" & essround== 2 & nace_both== 21

replace	c_adv=	-1 if cntry== "NL" & essround== 2 & nace_both== 21

replace	c_adv=	-1 if cntry== "NO" & essround== 2 & nace_both== 21

replace	c_adv=	1 if cntry== "PL" & essround== 2 & nace_both== 21

replace	c_adv=	1 if cntry== "PT" & essround== 2 & nace_both== 21

replace	c_adv=	1 if cntry== "SK" & essround== 2 & nace_both== 21

replace	c_adv=	-1 if cntry== "ES" & essround== 2 & nace_both== 21

replace	c_adv=	1 if cntry== "SE" & essround== 2 & nace_both== 21

replace	c_adv=	-1 if cntry== "CH" & essround== 2 & nace_both== 21

replace	c_adv=	-1 if cntry== "TR" & essround== 2 & nace_both== 21

replace	c_adv=	-1 if cntry== "GB" & essround== 2 & nace_both== 21

replace	c_adv=	1 if cntry== "AT" & essround== 2 & nace_both== 22

replace	c_adv=	-1 if cntry== "BE" & essround== 2 & nace_both== 22

replace	c_adv=	1 if cntry== "CZ" & essround== 2 & nace_both== 22

replace	c_adv=	1 if cntry== "DK" & essround== 2 & nace_both== 22

replace	c_adv=	-1 if cntry== "FI" & essround== 2 & nace_both== 22

replace	c_adv=	-1 if cntry== "FR" & essround== 2 & nace_both== 22

replace	c_adv=	1 if cntry== "DE" & essround== 2 & nace_both== 22

replace	c_adv=	1 if cntry== "GR" & essround== 2 & nace_both== 22

replace	c_adv=	-1 if cntry== "HU" & essround== 2 & nace_both== 22

replace	c_adv=	-1 if cntry== "IS" & essround== 2 & nace_both== 22

replace	c_adv=	1 if cntry== "IE" & essround== 2 & nace_both== 22

replace	c_adv=	-1 if cntry== "IT" & essround== 2 & nace_both== 22

replace	c_adv=	1 if cntry== "LU" & essround== 2 & nace_both== 22

replace	c_adv=	1 if cntry== "NL" & essround== 2 & nace_both== 22

replace	c_adv=	-1 if cntry== "NO" & essround== 2 & nace_both== 22

replace	c_adv=	-1 if cntry== "PL" & essround== 2 & nace_both== 22

replace	c_adv=	-1 if cntry== "PT" & essround== 2 & nace_both== 22

replace	c_adv=	-1 if cntry== "SK" & essround== 2 & nace_both== 22

replace	c_adv=	1 if cntry== "ES" & essround== 2 & nace_both== 22

replace	c_adv=	-1 if cntry== "SE" & essround== 2 & nace_both== 22

replace	c_adv=	-1 if cntry== "CH" & essround== 2 & nace_both== 22

replace	c_adv=	-1 if cntry== "TR" & essround== 2 & nace_both== 22

replace	c_adv=	1 if cntry== "GB" & essround== 2 & nace_both== 22

replace	c_adv=	-1 if cntry== "AT" & essround== 2 & nace_both== 23

replace	c_adv=	1 if cntry== "BE" & essround== 2 & nace_both== 23

replace	c_adv=	-1 if cntry== "CZ" & essround== 2 & nace_both== 23

replace	c_adv=	1 if cntry== "DK" & essround== 2 & nace_both== 23

replace	c_adv=	1 if cntry== "FI" & essround== 2 & nace_both== 23

replace	c_adv=	-1 if cntry== "FR" & essround== 2 & nace_both== 23

replace	c_adv=	-1 if cntry== "DE" & essround== 2 & nace_both== 23

replace	c_adv=	1 if cntry== "GR" & essround== 2 & nace_both== 23

replace	c_adv=	-1 if cntry== "HU" & essround== 2 & nace_both== 23

replace	c_adv=	-1 if cntry== "IS" & essround== 2 & nace_both== 23

replace	c_adv=	-1 if cntry== "IE" & essround== 2 & nace_both== 23

replace	c_adv=	1 if cntry== "IT" & essround== 2 & nace_both== 23

replace	c_adv=	0 if cntry== "LU" & essround== 2 & nace_both== 23

replace	c_adv=	1 if cntry== "NL" & essround== 2 & nace_both== 23

replace	c_adv=	1 if cntry== "NO" & essround== 2 & nace_both== 23

replace	c_adv=	1 if cntry== "PL" & essround== 2 & nace_both== 23

replace	c_adv=	1 if cntry== "PT" & essround== 2 & nace_both== 23

replace	c_adv=	1 if cntry== "SK" & essround== 2 & nace_both== 23

replace	c_adv=	1 if cntry== "ES" & essround== 2 & nace_both== 23

replace	c_adv=	1 if cntry== "SE" & essround== 2 & nace_both== 23

replace	c_adv=	-1 if cntry== "CH" & essround== 2 & nace_both== 23

replace	c_adv=	-1 if cntry== "TR" & essround== 2 & nace_both== 23

replace	c_adv=	1 if cntry== "GB" & essround== 2 & nace_both== 23

replace	c_adv=	-1 if cntry== "AT" & essround== 2 & nace_both== 24

replace	c_adv=	1 if cntry== "BE" & essround== 2 & nace_both== 24

replace	c_adv=	-1 if cntry== "CZ" & essround== 2 & nace_both== 24

replace	c_adv=	-1 if cntry== "DK" & essround== 2 & nace_both== 24

replace	c_adv=	-1 if cntry== "FI" & essround== 2 & nace_both== 24

replace	c_adv=	1 if cntry== "FR" & essround== 2 & nace_both== 24

replace	c_adv=	1 if cntry== "DE" & essround== 2 & nace_both== 24

replace	c_adv=	-1 if cntry== "GR" & essround== 2 & nace_both== 24

replace	c_adv=	-1 if cntry== "HU" & essround== 2 & nace_both== 24

replace	c_adv=	-1 if cntry== "IS" & essround== 2 & nace_both== 24

replace	c_adv=	1 if cntry== "IE" & essround== 2 & nace_both== 24

replace	c_adv=	-1 if cntry== "IT" & essround== 2 & nace_both== 24

replace	c_adv=	-1 if cntry== "LU" & essround== 2 & nace_both== 24

replace	c_adv=	1 if cntry== "NL" & essround== 2 & nace_both== 24

replace	c_adv=	-1 if cntry== "NO" & essround== 2 & nace_both== 24

replace	c_adv=	-1 if cntry== "PL" & essround== 2 & nace_both== 24

replace	c_adv=	-1 if cntry== "PT" & essround== 2 & nace_both== 24

replace	c_adv=	-1 if cntry== "SK" & essround== 2 & nace_both== 24

replace	c_adv=	-1 if cntry== "ES" & essround== 2 & nace_both== 24

replace	c_adv=	-1 if cntry== "SE" & essround== 2 & nace_both== 24

replace	c_adv=	1 if cntry== "CH" & essround== 2 & nace_both== 24

replace	c_adv=	-1 if cntry== "TR" & essround== 2 & nace_both== 24

replace	c_adv=	1 if cntry== "GB" & essround== 2 & nace_both== 24

replace	c_adv=	1 if cntry== "AT" & essround== 2 & nace_both== 25

replace	c_adv=	1 if cntry== "BE" & essround== 2 & nace_both== 25

replace	c_adv=	1 if cntry== "CZ" & essround== 2 & nace_both== 25

replace	c_adv=	1 if cntry== "DK" & essround== 2 & nace_both== 25

replace	c_adv=	-1 if cntry== "FI" & essround== 2 & nace_both== 25

replace	c_adv=	1 if cntry== "FR" & essround== 2 & nace_both== 25

replace	c_adv=	1 if cntry== "DE" & essround== 2 & nace_both== 25

replace	c_adv=	1 if cntry== "GR" & essround== 2 & nace_both== 25

replace	c_adv=	1 if cntry== "HU" & essround== 2 & nace_both== 25

replace	c_adv=	-1 if cntry== "IS" & essround== 2 & nace_both== 25

replace	c_adv=	-1 if cntry== "IE" & essround== 2 & nace_both== 25

replace	c_adv=	1 if cntry== "IT" & essround== 2 & nace_both== 25

replace	c_adv=	1 if cntry== "LU" & essround== 2 & nace_both== 25

replace	c_adv=	-1 if cntry== "NL" & essround== 2 & nace_both== 25

replace	c_adv=	-1 if cntry== "NO" & essround== 2 & nace_both== 25

replace	c_adv=	1 if cntry== "PL" & essround== 2 & nace_both== 25

replace	c_adv=	1 if cntry== "PT" & essround== 2 & nace_both== 25

replace	c_adv=	1 if cntry== "SK" & essround== 2 & nace_both== 25

replace	c_adv=	1 if cntry== "ES" & essround== 2 & nace_both== 25

replace	c_adv=	-1 if cntry== "SE" & essround== 2 & nace_both== 25

replace	c_adv=	-1 if cntry== "CH" & essround== 2 & nace_both== 25

replace	c_adv=	1 if cntry== "TR" & essround== 2 & nace_both== 25

replace	c_adv=	-1 if cntry== "GB" & essround== 2 & nace_both== 25

replace	c_adv=	1 if cntry== "AT" & essround== 2 & nace_both== 26

replace	c_adv=	1 if cntry== "BE" & essround== 2 & nace_both== 26

replace	c_adv=	1 if cntry== "CZ" & essround== 2 & nace_both== 26

replace	c_adv=	-1 if cntry== "DK" & essround== 2 & nace_both== 26

replace	c_adv=	1 if cntry== "FI" & essround== 2 & nace_both== 26

replace	c_adv=	1 if cntry== "FR" & essround== 2 & nace_both== 26

replace	c_adv=	1 if cntry== "DE" & essround== 2 & nace_both== 26

replace	c_adv=	1 if cntry== "GR" & essround== 2 & nace_both== 26

replace	c_adv=	-1 if cntry== "HU" & essround== 2 & nace_both== 26

replace	c_adv=	-1 if cntry== "IS" & essround== 2 & nace_both== 26

replace	c_adv=	-1 if cntry== "IE" & essround== 2 & nace_both== 26

replace	c_adv=	1 if cntry== "IT" & essround== 2 & nace_both== 26

replace	c_adv=	1 if cntry== "LU" & essround== 2 & nace_both== 26

replace	c_adv=	-1 if cntry== "NL" & essround== 2 & nace_both== 26

replace	c_adv=	-1 if cntry== "NO" & essround== 2 & nace_both== 26

replace	c_adv=	1 if cntry== "PL" & essround== 2 & nace_both== 26

replace	c_adv=	1 if cntry== "PT" & essround== 2 & nace_both== 26

replace	c_adv=	1 if cntry== "SK" & essround== 2 & nace_both== 26

replace	c_adv=	1 if cntry== "ES" & essround== 2 & nace_both== 26

replace	c_adv=	-1 if cntry== "SE" & essround== 2 & nace_both== 26

replace	c_adv=	-1 if cntry== "CH" & essround== 2 & nace_both== 26

replace	c_adv=	1 if cntry== "TR" & essround== 2 & nace_both== 26

replace	c_adv=	-1 if cntry== "GB" & essround== 2 & nace_both== 26

replace	c_adv=	1 if cntry== "AT" & essround== 2 & nace_both== 27

replace	c_adv=	1 if cntry== "BE" & essround== 2 & nace_both== 27

replace	c_adv=	1 if cntry== "CZ" & essround== 2 & nace_both== 27

replace	c_adv=	-1 if cntry== "DK" & essround== 2 & nace_both== 27

replace	c_adv=	1 if cntry== "FI" & essround== 2 & nace_both== 27

replace	c_adv=	1 if cntry== "FR" & essround== 2 & nace_both== 27

replace	c_adv=	-1 if cntry== "DE" & essround== 2 & nace_both== 27

replace	c_adv=	1 if cntry== "GR" & essround== 2 & nace_both== 27

replace	c_adv=	-1 if cntry== "HU" & essround== 2 & nace_both== 27

replace	c_adv=	1 if cntry== "IS" & essround== 2 & nace_both== 27

replace	c_adv=	-1 if cntry== "IE" & essround== 2 & nace_both== 27

replace	c_adv=	1 if cntry== "IT" & essround== 2 & nace_both== 27

replace	c_adv=	1 if cntry== "LU" & essround== 2 & nace_both== 27

replace	c_adv=	-1 if cntry== "NL" & essround== 2 & nace_both== 27

replace	c_adv=	1 if cntry== "NO" & essround== 2 & nace_both== 27

replace	c_adv=	1 if cntry== "PL" & essround== 2 & nace_both== 27

replace	c_adv=	-1 if cntry== "PT" & essround== 2 & nace_both== 27

replace	c_adv=	1 if cntry== "SK" & essround== 2 & nace_both== 27

replace	c_adv=	-1 if cntry== "ES" & essround== 2 & nace_both== 27

replace	c_adv=	1 if cntry== "SE" & essround== 2 & nace_both== 27

replace	c_adv=	-1 if cntry== "CH" & essround== 2 & nace_both== 27

replace	c_adv=	1 if cntry== "TR" & essround== 2 & nace_both== 27

replace	c_adv=	-1 if cntry== "GB" & essround== 2 & nace_both== 27

replace	c_adv=	1 if cntry== "AT" & essround== 2 & nace_both== 28

replace	c_adv=	-1 if cntry== "BE" & essround== 2 & nace_both== 28

replace	c_adv=	1 if cntry== "CZ" & essround== 2 & nace_both== 28

replace	c_adv=	1 if cntry== "DK" & essround== 2 & nace_both== 28

replace	c_adv=	-1 if cntry== "FI" & essround== 2 & nace_both== 28

replace	c_adv=	-1 if cntry== "FR" & essround== 2 & nace_both== 28

replace	c_adv=	1 if cntry== "DE" & essround== 2 & nace_both== 28

replace	c_adv=	1 if cntry== "GR" & essround== 2 & nace_both== 28

replace	c_adv=	1 if cntry== "HU" & essround== 2 & nace_both== 28

replace	c_adv=	-1 if cntry== "IS" & essround== 2 & nace_both== 28

replace	c_adv=	-1 if cntry== "IE" & essround== 2 & nace_both== 28

replace	c_adv=	1 if cntry== "IT" & essround== 2 & nace_both== 28

replace	c_adv=	1 if cntry== "LU" & essround== 2 & nace_both== 28

replace	c_adv=	-1 if cntry== "NL" & essround== 2 & nace_both== 28

replace	c_adv=	-1 if cntry== "NO" & essround== 2 & nace_both== 28

replace	c_adv=	1 if cntry== "PL" & essround== 2 & nace_both== 28

replace	c_adv=	1 if cntry== "PT" & essround== 2 & nace_both== 28

replace	c_adv=	1 if cntry== "SK" & essround== 2 & nace_both== 28

replace	c_adv=	1 if cntry== "ES" & essround== 2 & nace_both== 28

replace	c_adv=	1 if cntry== "SE" & essround== 2 & nace_both== 28

replace	c_adv=	1 if cntry== "CH" & essround== 2 & nace_both== 28

replace	c_adv=	1 if cntry== "TR" & essround== 2 & nace_both== 28

replace	c_adv=	-1 if cntry== "GB" & essround== 2 & nace_both== 28

replace	c_adv=	1 if cntry== "AT" & essround== 2 & nace_both== 29

replace	c_adv=	-1 if cntry== "BE" & essround== 2 & nace_both== 29

replace	c_adv=	1 if cntry== "CZ" & essround== 2 & nace_both== 29

replace	c_adv=	1 if cntry== "DK" & essround== 2 & nace_both== 29

replace	c_adv=	1 if cntry== "FI" & essround== 2 & nace_both== 29

replace	c_adv=	-1 if cntry== "FR" & essround== 2 & nace_both== 29

replace	c_adv=	1 if cntry== "DE" & essround== 2 & nace_both== 29

replace	c_adv=	-1 if cntry== "GR" & essround== 2 & nace_both== 29

replace	c_adv=	-1 if cntry== "HU" & essround== 2 & nace_both== 29

replace	c_adv=	-1 if cntry== "IS" & essround== 2 & nace_both== 29

replace	c_adv=	-1 if cntry== "IE" & essround== 2 & nace_both== 29

replace	c_adv=	1 if cntry== "IT" & essround== 2 & nace_both== 29

replace	c_adv=	-1 if cntry== "LU" & essround== 2 & nace_both== 29

replace	c_adv=	-1 if cntry== "NL" & essround== 2 & nace_both== 29

replace	c_adv=	-1 if cntry== "NO" & essround== 2 & nace_both== 29

replace	c_adv=	-1 if cntry== "PL" & essround== 2 & nace_both== 29

replace	c_adv=	-1 if cntry== "PT" & essround== 2 & nace_both== 29

replace	c_adv=	-1 if cntry== "SK" & essround== 2 & nace_both== 29

replace	c_adv=	-1 if cntry== "ES" & essround== 2 & nace_both== 29

replace	c_adv=	1 if cntry== "SE" & essround== 2 & nace_both== 29

replace	c_adv=	1 if cntry== "CH" & essround== 2 & nace_both== 29

replace	c_adv=	-1 if cntry== "TR" & essround== 2 & nace_both== 29

replace	c_adv=	-1 if cntry== "GB" & essround== 2 & nace_both== 29

replace	c_adv=	-1 if cntry== "AT" & essround== 2 & nace_both== 30

replace	c_adv=	-1 if cntry== "BE" & essround== 2 & nace_both== 30

replace	c_adv=	1 if cntry== "CZ" & essround== 2 & nace_both== 30

replace	c_adv=	-1 if cntry== "DK" & essround== 2 & nace_both== 30

replace	c_adv=	-1 if cntry== "FI" & essround== 2 & nace_both== 30

replace	c_adv=	-1 if cntry== "FR" & essround== 2 & nace_both== 30

replace	c_adv=	-1 if cntry== "DE" & essround== 2 & nace_both== 30

replace	c_adv=	-1 if cntry== "GR" & essround== 2 & nace_both== 30

replace	c_adv=	1 if cntry== "HU" & essround== 2 & nace_both== 30

replace	c_adv=	0 if cntry== "IS" & essround== 2 & nace_both== 30

replace	c_adv=	1 if cntry== "IE" & essround== 2 & nace_both== 30

replace	c_adv=	-1 if cntry== "IT" & essround== 2 & nace_both== 30

replace	c_adv=	-1 if cntry== "LU" & essround== 2 & nace_both== 30

replace	c_adv=	1 if cntry== "NL" & essround== 2 & nace_both== 30

replace	c_adv=	-1 if cntry== "NO" & essround== 2 & nace_both== 30

replace	c_adv=	-1 if cntry== "PL" & essround== 2 & nace_both== 30

replace	c_adv=	-1 if cntry== "PT" & essround== 2 & nace_both== 30

replace	c_adv=	-1 if cntry== "SK" & essround== 2 & nace_both== 30

replace	c_adv=	-1 if cntry== "ES" & essround== 2 & nace_both== 30

replace	c_adv=	-1 if cntry== "SE" & essround== 2 & nace_both== 30

replace	c_adv=	-1 if cntry== "CH" & essround== 2 & nace_both== 30

replace	c_adv=	0 if cntry== "TR" & essround== 2 & nace_both== 30

replace	c_adv=	1 if cntry== "GB" & essround== 2 & nace_both== 30

replace	c_adv=	1 if cntry== "AT" & essround== 2 & nace_both== 31

replace	c_adv=	-1 if cntry== "BE" & essround== 2 & nace_both== 31

replace	c_adv=	1 if cntry== "CZ" & essround== 2 & nace_both== 31

replace	c_adv=	1 if cntry== "DK" & essround== 2 & nace_both== 31

replace	c_adv=	1 if cntry== "FI" & essround== 2 & nace_both== 31

replace	c_adv=	1 if cntry== "FR" & essround== 2 & nace_both== 31

replace	c_adv=	1 if cntry== "DE" & essround== 2 & nace_both== 31

replace	c_adv=	-1 if cntry== "GR" & essround== 2 & nace_both== 31

replace	c_adv=	1 if cntry== "HU" & essround== 2 & nace_both== 31

replace	c_adv=	0 if cntry== "IS" & essround== 2 & nace_both== 31

replace	c_adv=	-1 if cntry== "IE" & essround== 2 & nace_both== 31

replace	c_adv=	-1 if cntry== "IT" & essround== 2 & nace_both== 31

replace	c_adv=	-1 if cntry== "LU" & essround== 2 & nace_both== 31

replace	c_adv=	-1 if cntry== "NL" & essround== 2 & nace_both== 31

replace	c_adv=	-1 if cntry== "NO" & essround== 2 & nace_both== 31

replace	c_adv=	1 if cntry== "PL" & essround== 2 & nace_both== 31

replace	c_adv=	1 if cntry== "PT" & essround== 2 & nace_both== 31

replace	c_adv=	1 if cntry== "SK" & essround== 2 & nace_both== 31

replace	c_adv=	-1 if cntry== "ES" & essround== 2 & nace_both== 31

replace	c_adv=	-1 if cntry== "SE" & essround== 2 & nace_both== 31

replace	c_adv=	1 if cntry== "CH" & essround== 2 & nace_both== 31

replace	c_adv=	-1 if cntry== "TR" & essround== 2 & nace_both== 31

replace	c_adv=	-1 if cntry== "GB" & essround== 2 & nace_both== 31

replace	c_adv=	-1 if cntry== "AT" & essround== 2 & nace_both== 32

replace	c_adv=	-1 if cntry== "BE" & essround== 2 & nace_both== 32

replace	c_adv=	-1 if cntry== "CZ" & essround== 2 & nace_both== 32

replace	c_adv=	-1 if cntry== "DK" & essround== 2 & nace_both== 32

replace	c_adv=	1 if cntry== "FI" & essround== 2 & nace_both== 32

replace	c_adv=	-1 if cntry== "FR" & essround== 2 & nace_both== 32

replace	c_adv=	-1 if cntry== "DE" & essround== 2 & nace_both== 32

replace	c_adv=	-1 if cntry== "GR" & essround== 2 & nace_both== 32

replace	c_adv=	1 if cntry== "HU" & essround== 2 & nace_both== 32

replace	c_adv=	0 if cntry== "IS" & essround== 2 & nace_both== 32

replace	c_adv=	-1 if cntry== "IE" & essround== 2 & nace_both== 32

replace	c_adv=	-1 if cntry== "IT" & essround== 2 & nace_both== 32

replace	c_adv=	-1 if cntry== "LU" & essround== 2 & nace_both== 32

replace	c_adv=	1 if cntry== "NL" & essround== 2 & nace_both== 32

replace	c_adv=	-1 if cntry== "NO" & essround== 2 & nace_both== 32

replace	c_adv=	-1 if cntry== "PL" & essround== 2 & nace_both== 32

replace	c_adv=	-1 if cntry== "PT" & essround== 2 & nace_both== 32

replace	c_adv=	-1 if cntry== "SK" & essround== 2 & nace_both== 32

replace	c_adv=	-1 if cntry== "ES" & essround== 2 & nace_both== 32

replace	c_adv=	1 if cntry== "SE" & essround== 2 & nace_both== 32

replace	c_adv=	-1 if cntry== "CH" & essround== 2 & nace_both== 32

replace	c_adv=	-1 if cntry== "TR" & essround== 2 & nace_both== 32

replace	c_adv=	-1 if cntry== "GB" & essround== 2 & nace_both== 32

replace	c_adv=	-1 if cntry== "AT" & essround== 2 & nace_both== 33

replace	c_adv=	-1 if cntry== "BE" & essround== 2 & nace_both== 33

replace	c_adv=	-1 if cntry== "CZ" & essround== 2 & nace_both== 33

replace	c_adv=	1 if cntry== "DK" & essround== 2 & nace_both== 33

replace	c_adv=	-1 if cntry== "FI" & essround== 2 & nace_both== 33

replace	c_adv=	-1 if cntry== "FR" & essround== 2 & nace_both== 33

replace	c_adv=	1 if cntry== "DE" & essround== 2 & nace_both== 33

replace	c_adv=	-1 if cntry== "GR" & essround== 2 & nace_both== 33

replace	c_adv=	-1 if cntry== "HU" & essround== 2 & nace_both== 33

replace	c_adv=	-1 if cntry== "IS" & essround== 2 & nace_both== 33

replace	c_adv=	1 if cntry== "IE" & essround== 2 & nace_both== 33

replace	c_adv=	-1 if cntry== "IT" & essround== 2 & nace_both== 33

replace	c_adv=	-1 if cntry== "LU" & essround== 2 & nace_both== 33

replace	c_adv=	1 if cntry== "NL" & essround== 2 & nace_both== 33

replace	c_adv=	-1 if cntry== "NO" & essround== 2 & nace_both== 33

replace	c_adv=	-1 if cntry== "PL" & essround== 2 & nace_both== 33

replace	c_adv=	-1 if cntry== "PT" & essround== 2 & nace_both== 33

replace	c_adv=	-1 if cntry== "SK" & essround== 2 & nace_both== 33

replace	c_adv=	-1 if cntry== "ES" & essround== 2 & nace_both== 33

replace	c_adv=	-1 if cntry== "SE" & essround== 2 & nace_both== 33

replace	c_adv=	1 if cntry== "CH" & essround== 2 & nace_both== 33

replace	c_adv=	-1 if cntry== "TR" & essround== 2 & nace_both== 33

replace	c_adv=	1 if cntry== "GB" & essround== 2 & nace_both== 33

replace	c_adv=	1 if cntry== "AT" & essround== 2 & nace_both== 34

replace	c_adv=	1 if cntry== "BE" & essround== 2 & nace_both== 34

replace	c_adv=	1 if cntry== "CZ" & essround== 2 & nace_both== 34

replace	c_adv=	-1 if cntry== "DK" & essround== 2 & nace_both== 34

replace	c_adv=	-1 if cntry== "FI" & essround== 2 & nace_both== 34

replace	c_adv=	1 if cntry== "FR" & essround== 2 & nace_both== 34

replace	c_adv=	1 if cntry== "DE" & essround== 2 & nace_both== 34

replace	c_adv=	-1 if cntry== "GR" & essround== 2 & nace_both== 34

replace	c_adv=	1 if cntry== "HU" & essround== 2 & nace_both== 34

replace	c_adv=	-1 if cntry== "IS" & essround== 2 & nace_both== 34

replace	c_adv=	0 if cntry== "IE" & essround== 2 & nace_both== 34

replace	c_adv=	-1 if cntry== "IT" & essround== 2 & nace_both== 34

replace	c_adv=	-1 if cntry== "LU" & essround== 2 & nace_both== 34

replace	c_adv=	-1 if cntry== "NL" & essround== 2 & nace_both== 34

replace	c_adv=	-1 if cntry== "NO" & essround== 2 & nace_both== 34

replace	c_adv=	1 if cntry== "PL" & essround== 2 & nace_both== 34

replace	c_adv=	1 if cntry== "PT" & essround== 2 & nace_both== 34

replace	c_adv=	1 if cntry== "SK" & essround== 2 & nace_both== 34

replace	c_adv=	1 if cntry== "ES" & essround== 2 & nace_both== 34

replace	c_adv=	1 if cntry== "SE" & essround== 2 & nace_both== 34

replace	c_adv=	-1 if cntry== "CH" & essround== 2 & nace_both== 34

replace	c_adv=	1 if cntry== "TR" & essround== 2 & nace_both== 34

replace	c_adv=	-1 if cntry== "GB" & essround== 2 & nace_both== 34

replace	c_adv=	1 if cntry== "AT" & essround== 2 & nace_both== 35

replace	c_adv=	-1 if cntry== "BE" & essround== 2 & nace_both== 35

replace	c_adv=	-1 if cntry== "CZ" & essround== 2 & nace_both== 35

replace	c_adv=	-1 if cntry== "DK" & essround== 2 & nace_both== 35

replace	c_adv=	-1 if cntry== "FI" & essround== 2 & nace_both== 35

replace	c_adv=	1 if cntry== "FR" & essround== 2 & nace_both== 35

replace	c_adv=	-1 if cntry== "DE" & essround== 2 & nace_both== 35

replace	c_adv=	-1 if cntry== "GR" & essround== 2 & nace_both== 35

replace	c_adv=	-1 if cntry== "HU" & essround== 2 & nace_both== 35

replace	c_adv=	-1 if cntry== "IS" & essround== 2 & nace_both== 35

replace	c_adv=	-1 if cntry== "IE" & essround== 2 & nace_both== 35

replace	c_adv=	-1 if cntry== "IT" & essround== 2 & nace_both== 35

replace	c_adv=	-1 if cntry== "LU" & essround== 2 & nace_both== 35

replace	c_adv=	-1 if cntry== "NL" & essround== 2 & nace_both== 35

replace	c_adv=	-1 if cntry== "NO" & essround== 2 & nace_both== 35

replace	c_adv=	1 if cntry== "PL" & essround== 2 & nace_both== 35

replace	c_adv=	-1 if cntry== "PT" & essround== 2 & nace_both== 35

replace	c_adv=	-1 if cntry== "SK" & essround== 2 & nace_both== 35

replace	c_adv=	1 if cntry== "ES" & essround== 2 & nace_both== 35

replace	c_adv=	-1 if cntry== "SE" & essround== 2 & nace_both== 35

replace	c_adv=	-1 if cntry== "CH" & essround== 2 & nace_both== 35

replace	c_adv=	-1 if cntry== "TR" & essround== 2 & nace_both== 35

replace	c_adv=	1 if cntry== "GB" & essround== 2 & nace_both== 35

replace	c_adv=	1 if cntry== "AT" & essround== 2 & nace_both== 36

replace	c_adv=	1 if cntry== "BE" & essround== 2 & nace_both== 36

replace	c_adv=	1 if cntry== "CZ" & essround== 2 & nace_both== 36

replace	c_adv=	1 if cntry== "DK" & essround== 2 & nace_both== 36

replace	c_adv=	-1 if cntry== "FI" & essround== 2 & nace_both== 36

replace	c_adv=	-1 if cntry== "FR" & essround== 2 & nace_both== 36

replace	c_adv=	-1 if cntry== "DE" & essround== 2 & nace_both== 36

replace	c_adv=	-1 if cntry== "GR" & essround== 2 & nace_both== 36

replace	c_adv=	-1 if cntry== "HU" & essround== 2 & nace_both== 36

replace	c_adv=	0 if cntry== "IS" & essround== 2 & nace_both== 36

replace	c_adv=	-1 if cntry== "IE" & essround== 2 & nace_both== 36

replace	c_adv=	1 if cntry== "IT" & essround== 2 & nace_both== 36

replace	c_adv=	-1 if cntry== "LU" & essround== 2 & nace_both== 36

replace	c_adv=	-1 if cntry== "NL" & essround== 2 & nace_both== 36

replace	c_adv=	-1 if cntry== "NO" & essround== 2 & nace_both== 36

replace	c_adv=	1 if cntry== "PL" & essround== 2 & nace_both== 36

replace	c_adv=	1 if cntry== "PT" & essround== 2 & nace_both== 36

replace	c_adv=	1 if cntry== "SK" & essround== 2 & nace_both== 36

replace	c_adv=	-1 if cntry== "ES" & essround== 2 & nace_both== 36

replace	c_adv=	-1 if cntry== "SE" & essround== 2 & nace_both== 36

replace	c_adv=	1 if cntry== "CH" & essround== 2 & nace_both== 36

replace	c_adv=	1 if cntry== "TR" & essround== 2 & nace_both== 36

replace	c_adv=	1 if cntry== "GB" & essround== 2 & nace_both== 36

replace	c_adv=	0 if cntry== "AT" & essround== 2 & nace_both== 37

replace	c_adv=	0 if cntry== "BE" & essround== 2 & nace_both== 37

replace	c_adv=	0 if cntry== "CZ" & essround== 2 & nace_both== 37

replace	c_adv=	0 if cntry== "DK" & essround== 2 & nace_both== 37

replace	c_adv=	0 if cntry== "FI" & essround== 2 & nace_both== 37

replace	c_adv=	0 if cntry== "FR" & essround== 2 & nace_both== 37

replace	c_adv=	0 if cntry== "DE" & essround== 2 & nace_both== 37

replace	c_adv=	0 if cntry== "GR" & essround== 2 & nace_both== 37

replace	c_adv=	0 if cntry== "HU" & essround== 2 & nace_both== 37

replace	c_adv=	0 if cntry== "IS" & essround== 2 & nace_both== 37

replace	c_adv=	0 if cntry== "IE" & essround== 2 & nace_both== 37

replace	c_adv=	0 if cntry== "IT" & essround== 2 & nace_both== 37

replace	c_adv=	0 if cntry== "LU" & essround== 2 & nace_both== 37

replace	c_adv=	0 if cntry== "NL" & essround== 2 & nace_both== 37

replace	c_adv=	0 if cntry== "NO" & essround== 2 & nace_both== 37

replace	c_adv=	0 if cntry== "PL" & essround== 2 & nace_both== 37

replace	c_adv=	0 if cntry== "PT" & essround== 2 & nace_both== 37

replace	c_adv=	0 if cntry== "SK" & essround== 2 & nace_both== 37

replace	c_adv=	0 if cntry== "ES" & essround== 2 & nace_both== 37

replace	c_adv=	0 if cntry== "SE" & essround== 2 & nace_both== 37

replace	c_adv=	0 if cntry== "CH" & essround== 2 & nace_both== 37

replace	c_adv=	0 if cntry== "TR" & essround== 2 & nace_both== 37

replace	c_adv=	0 if cntry== "GB" & essround== 2 & nace_both== 37

replace	c_adv=	1 if cntry== "AT" & essround== 2 & nace_both== 40

replace	c_adv=	-1 if cntry== "BE" & essround== 2 & nace_both== 40

replace	c_adv=	1 if cntry== "CZ" & essround== 2 & nace_both== 40

replace	c_adv=	1 if cntry== "DK" & essround== 2 & nace_both== 40

replace	c_adv=	1 if cntry== "FI" & essround== 2 & nace_both== 40

replace	c_adv=	1 if cntry== "FR" & essround== 2 & nace_both== 40

replace	c_adv=	-1 if cntry== "DE" & essround== 2 & nace_both== 40

replace	c_adv=	0 if cntry== "GR" & essround== 2 & nace_both== 40

replace	c_adv=	-1 if cntry== "HU" & essround== 2 & nace_both== 40

replace	c_adv=	0 if cntry== "IS" & essround== 2 & nace_both== 40

replace	c_adv=	-1 if cntry== "IE" & essround== 2 & nace_both== 40

replace	c_adv=	-1 if cntry== "IT" & essround== 2 & nace_both== 40

replace	c_adv=	1 if cntry== "LU" & essround== 2 & nace_both== 40

replace	c_adv=	0 if cntry== "NL" & essround== 2 & nace_both== 40

replace	c_adv=	-1 if cntry== "NO" & essround== 2 & nace_both== 40

replace	c_adv=	1 if cntry== "PL" & essround== 2 & nace_both== 40

replace	c_adv=	-1 if cntry== "PT" & essround== 2 & nace_both== 40

replace	c_adv=	1 if cntry== "SK" & essround== 2 & nace_both== 40

replace	c_adv=	1 if cntry== "ES" & essround== 2 & nace_both== 40

replace	c_adv=	1 if cntry== "SE" & essround== 2 & nace_both== 40

replace	c_adv=	0 if cntry== "CH" & essround== 2 & nace_both== 40

replace	c_adv=	-1 if cntry== "TR" & essround== 2 & nace_both== 40

replace	c_adv=	-1 if cntry== "GB" & essround== 2 & nace_both== 40

replace	c_adv=	0 if cntry== "AT" & essround== 2 & nace_both== 41

replace	c_adv=	0 if cntry== "BE" & essround== 2 & nace_both== 41

replace	c_adv=	0 if cntry== "CZ" & essround== 2 & nace_both== 41

replace	c_adv=	0 if cntry== "DK" & essround== 2 & nace_both== 41

replace	c_adv=	0 if cntry== "FI" & essround== 2 & nace_both== 41

replace	c_adv=	0 if cntry== "FR" & essround== 2 & nace_both== 41

replace	c_adv=	0 if cntry== "DE" & essround== 2 & nace_both== 41

replace	c_adv=	0 if cntry== "GR" & essround== 2 & nace_both== 41

replace	c_adv=	0 if cntry== "HU" & essround== 2 & nace_both== 41

replace	c_adv=	0 if cntry== "IS" & essround== 2 & nace_both== 41

replace	c_adv=	0 if cntry== "IE" & essround== 2 & nace_both== 41

replace	c_adv=	0 if cntry== "IT" & essround== 2 & nace_both== 41

replace	c_adv=	0 if cntry== "LU" & essround== 2 & nace_both== 41

replace	c_adv=	0 if cntry== "NL" & essround== 2 & nace_both== 41

replace	c_adv=	0 if cntry== "NO" & essround== 2 & nace_both== 41

replace	c_adv=	0 if cntry== "PL" & essround== 2 & nace_both== 41

replace	c_adv=	0 if cntry== "PT" & essround== 2 & nace_both== 41

replace	c_adv=	0 if cntry== "SK" & essround== 2 & nace_both== 41

replace	c_adv=	0 if cntry== "ES" & essround== 2 & nace_both== 41

replace	c_adv=	0 if cntry== "SE" & essround== 2 & nace_both== 41

replace	c_adv=	0 if cntry== "CH" & essround== 2 & nace_both== 41

replace	c_adv=	0 if cntry== "TR" & essround== 2 & nace_both== 41

replace	c_adv=	0 if cntry== "GB" & essround== 2 & nace_both== 41

replace	c_adv=	0 if cntry== "AT" & essround== 2 & nace_both== 45

replace	c_adv=	0 if cntry== "BE" & essround== 2 & nace_both== 45

replace	c_adv=	0 if cntry== "CZ" & essround== 2 & nace_both== 45

replace	c_adv=	0 if cntry== "DK" & essround== 2 & nace_both== 45

replace	c_adv=	0 if cntry== "FI" & essround== 2 & nace_both== 45

replace	c_adv=	0 if cntry== "FR" & essround== 2 & nace_both== 45

replace	c_adv=	0 if cntry== "DE" & essround== 2 & nace_both== 45

replace	c_adv=	0 if cntry== "GR" & essround== 2 & nace_both== 45

replace	c_adv=	0 if cntry== "HU" & essround== 2 & nace_both== 45

replace	c_adv=	0 if cntry== "IS" & essround== 2 & nace_both== 45

replace	c_adv=	0 if cntry== "IE" & essround== 2 & nace_both== 45

replace	c_adv=	0 if cntry== "IT" & essround== 2 & nace_both== 45

replace	c_adv=	0 if cntry== "LU" & essround== 2 & nace_both== 45

replace	c_adv=	0 if cntry== "NL" & essround== 2 & nace_both== 45

replace	c_adv=	0 if cntry== "NO" & essround== 2 & nace_both== 45

replace	c_adv=	0 if cntry== "PL" & essround== 2 & nace_both== 45

replace	c_adv=	0 if cntry== "PT" & essround== 2 & nace_both== 45

replace	c_adv=	0 if cntry== "SK" & essround== 2 & nace_both== 45

replace	c_adv=	0 if cntry== "ES" & essround== 2 & nace_both== 45

replace	c_adv=	0 if cntry== "SE" & essround== 2 & nace_both== 45

replace	c_adv=	0 if cntry== "CH" & essround== 2 & nace_both== 45

replace	c_adv=	0 if cntry== "TR" & essround== 2 & nace_both== 45

replace	c_adv=	0 if cntry== "GB" & essround== 2 & nace_both== 45

replace	c_adv=	0 if cntry== "AT" & essround== 2 & nace_both== 50

replace	c_adv=	0 if cntry== "BE" & essround== 2 & nace_both== 50

replace	c_adv=	0 if cntry== "CZ" & essround== 2 & nace_both== 50

replace	c_adv=	0 if cntry== "DK" & essround== 2 & nace_both== 50

replace	c_adv=	0 if cntry== "FI" & essround== 2 & nace_both== 50

replace	c_adv=	0 if cntry== "FR" & essround== 2 & nace_both== 50

replace	c_adv=	0 if cntry== "DE" & essround== 2 & nace_both== 50

replace	c_adv=	0 if cntry== "GR" & essround== 2 & nace_both== 50

replace	c_adv=	0 if cntry== "HU" & essround== 2 & nace_both== 50

replace	c_adv=	0 if cntry== "IS" & essround== 2 & nace_both== 50

replace	c_adv=	0 if cntry== "IE" & essround== 2 & nace_both== 50

replace	c_adv=	0 if cntry== "IT" & essround== 2 & nace_both== 50

replace	c_adv=	0 if cntry== "LU" & essround== 2 & nace_both== 50

replace	c_adv=	0 if cntry== "NL" & essround== 2 & nace_both== 50

replace	c_adv=	0 if cntry== "NO" & essround== 2 & nace_both== 50

replace	c_adv=	0 if cntry== "PL" & essround== 2 & nace_both== 50

replace	c_adv=	0 if cntry== "PT" & essround== 2 & nace_both== 50

replace	c_adv=	0 if cntry== "SK" & essround== 2 & nace_both== 50

replace	c_adv=	0 if cntry== "ES" & essround== 2 & nace_both== 50

replace	c_adv=	0 if cntry== "SE" & essround== 2 & nace_both== 50

replace	c_adv=	0 if cntry== "CH" & essround== 2 & nace_both== 50

replace	c_adv=	0 if cntry== "TR" & essround== 2 & nace_both== 50

replace	c_adv=	0 if cntry== "GB" & essround== 2 & nace_both== 50

replace	c_adv=	0 if cntry== "AT" & essround== 2 & nace_both== 51

replace	c_adv=	0 if cntry== "BE" & essround== 2 & nace_both== 51

replace	c_adv=	0 if cntry== "CZ" & essround== 2 & nace_both== 51

replace	c_adv=	0 if cntry== "DK" & essround== 2 & nace_both== 51

replace	c_adv=	0 if cntry== "FI" & essround== 2 & nace_both== 51

replace	c_adv=	0 if cntry== "FR" & essround== 2 & nace_both== 51

replace	c_adv=	0 if cntry== "DE" & essround== 2 & nace_both== 51

replace	c_adv=	0 if cntry== "GR" & essround== 2 & nace_both== 51

replace	c_adv=	0 if cntry== "HU" & essround== 2 & nace_both== 51

replace	c_adv=	0 if cntry== "IS" & essround== 2 & nace_both== 51

replace	c_adv=	0 if cntry== "IE" & essround== 2 & nace_both== 51

replace	c_adv=	0 if cntry== "IT" & essround== 2 & nace_both== 51

replace	c_adv=	0 if cntry== "LU" & essround== 2 & nace_both== 51

replace	c_adv=	0 if cntry== "NL" & essround== 2 & nace_both== 51

replace	c_adv=	0 if cntry== "NO" & essround== 2 & nace_both== 51

replace	c_adv=	0 if cntry== "PL" & essround== 2 & nace_both== 51

replace	c_adv=	0 if cntry== "PT" & essround== 2 & nace_both== 51

replace	c_adv=	0 if cntry== "SK" & essround== 2 & nace_both== 51

replace	c_adv=	0 if cntry== "ES" & essround== 2 & nace_both== 51

replace	c_adv=	0 if cntry== "SE" & essround== 2 & nace_both== 51

replace	c_adv=	0 if cntry== "CH" & essround== 2 & nace_both== 51

replace	c_adv=	0 if cntry== "TR" & essround== 2 & nace_both== 51

replace	c_adv=	0 if cntry== "GB" & essround== 2 & nace_both== 51

replace	c_adv=	0 if cntry== "AT" & essround== 2 & nace_both== 52

replace	c_adv=	0 if cntry== "BE" & essround== 2 & nace_both== 52

replace	c_adv=	0 if cntry== "CZ" & essround== 2 & nace_both== 52

replace	c_adv=	0 if cntry== "DK" & essround== 2 & nace_both== 52

replace	c_adv=	0 if cntry== "FI" & essround== 2 & nace_both== 52

replace	c_adv=	0 if cntry== "FR" & essround== 2 & nace_both== 52

replace	c_adv=	0 if cntry== "DE" & essround== 2 & nace_both== 52

replace	c_adv=	0 if cntry== "GR" & essround== 2 & nace_both== 52

replace	c_adv=	0 if cntry== "HU" & essround== 2 & nace_both== 52

replace	c_adv=	0 if cntry== "IS" & essround== 2 & nace_both== 52

replace	c_adv=	0 if cntry== "IE" & essround== 2 & nace_both== 52

replace	c_adv=	0 if cntry== "IT" & essround== 2 & nace_both== 52

replace	c_adv=	0 if cntry== "LU" & essround== 2 & nace_both== 52

replace	c_adv=	0 if cntry== "NL" & essround== 2 & nace_both== 52

replace	c_adv=	0 if cntry== "NO" & essround== 2 & nace_both== 52

replace	c_adv=	0 if cntry== "PL" & essround== 2 & nace_both== 52

replace	c_adv=	0 if cntry== "PT" & essround== 2 & nace_both== 52

replace	c_adv=	0 if cntry== "SK" & essround== 2 & nace_both== 52

replace	c_adv=	0 if cntry== "ES" & essround== 2 & nace_both== 52

replace	c_adv=	0 if cntry== "SE" & essround== 2 & nace_both== 52

replace	c_adv=	0 if cntry== "CH" & essround== 2 & nace_both== 52

replace	c_adv=	0 if cntry== "TR" & essround== 2 & nace_both== 52

replace	c_adv=	0 if cntry== "GB" & essround== 2 & nace_both== 52

replace	c_adv=	0 if cntry== "AT" & essround== 2 & nace_both== 55

replace	c_adv=	0 if cntry== "BE" & essround== 2 & nace_both== 55

replace	c_adv=	0 if cntry== "CZ" & essround== 2 & nace_both== 55

replace	c_adv=	0 if cntry== "DK" & essround== 2 & nace_both== 55

replace	c_adv=	0 if cntry== "FI" & essround== 2 & nace_both== 55

replace	c_adv=	0 if cntry== "FR" & essround== 2 & nace_both== 55

replace	c_adv=	0 if cntry== "DE" & essround== 2 & nace_both== 55

replace	c_adv=	0 if cntry== "GR" & essround== 2 & nace_both== 55

replace	c_adv=	0 if cntry== "HU" & essround== 2 & nace_both== 55

replace	c_adv=	0 if cntry== "IS" & essround== 2 & nace_both== 55

replace	c_adv=	0 if cntry== "IE" & essround== 2 & nace_both== 55

replace	c_adv=	0 if cntry== "IT" & essround== 2 & nace_both== 55

replace	c_adv=	0 if cntry== "LU" & essround== 2 & nace_both== 55

replace	c_adv=	0 if cntry== "NL" & essround== 2 & nace_both== 55

replace	c_adv=	0 if cntry== "NO" & essround== 2 & nace_both== 55

replace	c_adv=	0 if cntry== "PL" & essround== 2 & nace_both== 55

replace	c_adv=	0 if cntry== "PT" & essround== 2 & nace_both== 55

replace	c_adv=	0 if cntry== "SK" & essround== 2 & nace_both== 55

replace	c_adv=	0 if cntry== "ES" & essround== 2 & nace_both== 55

replace	c_adv=	0 if cntry== "SE" & essround== 2 & nace_both== 55

replace	c_adv=	0 if cntry== "CH" & essround== 2 & nace_both== 55

replace	c_adv=	0 if cntry== "TR" & essround== 2 & nace_both== 55

replace	c_adv=	0 if cntry== "GB" & essround== 2 & nace_both== 55

replace	c_adv=	0 if cntry== "AT" & essround== 2 & nace_both== 60

replace	c_adv=	0 if cntry== "BE" & essround== 2 & nace_both== 60

replace	c_adv=	0 if cntry== "CZ" & essround== 2 & nace_both== 60

replace	c_adv=	0 if cntry== "DK" & essround== 2 & nace_both== 60

replace	c_adv=	0 if cntry== "FI" & essround== 2 & nace_both== 60

replace	c_adv=	0 if cntry== "FR" & essround== 2 & nace_both== 60

replace	c_adv=	0 if cntry== "DE" & essround== 2 & nace_both== 60

replace	c_adv=	0 if cntry== "GR" & essround== 2 & nace_both== 60

replace	c_adv=	0 if cntry== "HU" & essround== 2 & nace_both== 60

replace	c_adv=	0 if cntry== "IS" & essround== 2 & nace_both== 60

replace	c_adv=	0 if cntry== "IE" & essround== 2 & nace_both== 60

replace	c_adv=	0 if cntry== "IT" & essround== 2 & nace_both== 60

replace	c_adv=	0 if cntry== "LU" & essround== 2 & nace_both== 60

replace	c_adv=	0 if cntry== "NL" & essround== 2 & nace_both== 60

replace	c_adv=	0 if cntry== "NO" & essround== 2 & nace_both== 60

replace	c_adv=	0 if cntry== "PL" & essround== 2 & nace_both== 60

replace	c_adv=	0 if cntry== "PT" & essround== 2 & nace_both== 60

replace	c_adv=	0 if cntry== "SK" & essround== 2 & nace_both== 60

replace	c_adv=	0 if cntry== "ES" & essround== 2 & nace_both== 60

replace	c_adv=	0 if cntry== "SE" & essround== 2 & nace_both== 60

replace	c_adv=	0 if cntry== "CH" & essround== 2 & nace_both== 60

replace	c_adv=	0 if cntry== "TR" & essround== 2 & nace_both== 60

replace	c_adv=	0 if cntry== "GB" & essround== 2 & nace_both== 60

replace	c_adv=	0 if cntry== "AT" & essround== 2 & nace_both== 61

replace	c_adv=	0 if cntry== "BE" & essround== 2 & nace_both== 61

replace	c_adv=	0 if cntry== "CZ" & essround== 2 & nace_both== 61

replace	c_adv=	0 if cntry== "DK" & essround== 2 & nace_both== 61

replace	c_adv=	0 if cntry== "FI" & essround== 2 & nace_both== 61

replace	c_adv=	0 if cntry== "FR" & essround== 2 & nace_both== 61

replace	c_adv=	0 if cntry== "DE" & essround== 2 & nace_both== 61

replace	c_adv=	0 if cntry== "GR" & essround== 2 & nace_both== 61

replace	c_adv=	0 if cntry== "HU" & essround== 2 & nace_both== 61

replace	c_adv=	0 if cntry== "IS" & essround== 2 & nace_both== 61

replace	c_adv=	0 if cntry== "IE" & essround== 2 & nace_both== 61

replace	c_adv=	0 if cntry== "IT" & essround== 2 & nace_both== 61

replace	c_adv=	0 if cntry== "LU" & essround== 2 & nace_both== 61

replace	c_adv=	0 if cntry== "NL" & essround== 2 & nace_both== 61

replace	c_adv=	0 if cntry== "NO" & essround== 2 & nace_both== 61

replace	c_adv=	0 if cntry== "PL" & essround== 2 & nace_both== 61

replace	c_adv=	0 if cntry== "PT" & essround== 2 & nace_both== 61

replace	c_adv=	0 if cntry== "SK" & essround== 2 & nace_both== 61

replace	c_adv=	0 if cntry== "ES" & essround== 2 & nace_both== 61

replace	c_adv=	0 if cntry== "SE" & essround== 2 & nace_both== 61

replace	c_adv=	0 if cntry== "CH" & essround== 2 & nace_both== 61

replace	c_adv=	0 if cntry== "TR" & essround== 2 & nace_both== 61

replace	c_adv=	0 if cntry== "GB" & essround== 2 & nace_both== 61

replace	c_adv=	0 if cntry== "AT" & essround== 2 & nace_both== 62

replace	c_adv=	0 if cntry== "BE" & essround== 2 & nace_both== 62

replace	c_adv=	0 if cntry== "CZ" & essround== 2 & nace_both== 62

replace	c_adv=	0 if cntry== "DK" & essround== 2 & nace_both== 62

replace	c_adv=	0 if cntry== "FI" & essround== 2 & nace_both== 62

replace	c_adv=	0 if cntry== "FR" & essround== 2 & nace_both== 62

replace	c_adv=	0 if cntry== "DE" & essround== 2 & nace_both== 62

replace	c_adv=	0 if cntry== "GR" & essround== 2 & nace_both== 62

replace	c_adv=	0 if cntry== "HU" & essround== 2 & nace_both== 62

replace	c_adv=	0 if cntry== "IS" & essround== 2 & nace_both== 62

replace	c_adv=	0 if cntry== "IE" & essround== 2 & nace_both== 62

replace	c_adv=	0 if cntry== "IT" & essround== 2 & nace_both== 62

replace	c_adv=	0 if cntry== "LU" & essround== 2 & nace_both== 62

replace	c_adv=	0 if cntry== "NL" & essround== 2 & nace_both== 62

replace	c_adv=	0 if cntry== "NO" & essround== 2 & nace_both== 62

replace	c_adv=	0 if cntry== "PL" & essround== 2 & nace_both== 62

replace	c_adv=	0 if cntry== "PT" & essround== 2 & nace_both== 62

replace	c_adv=	0 if cntry== "SK" & essround== 2 & nace_both== 62

replace	c_adv=	0 if cntry== "ES" & essround== 2 & nace_both== 62

replace	c_adv=	0 if cntry== "SE" & essround== 2 & nace_both== 62

replace	c_adv=	0 if cntry== "CH" & essround== 2 & nace_both== 62

replace	c_adv=	0 if cntry== "TR" & essround== 2 & nace_both== 62

replace	c_adv=	0 if cntry== "GB" & essround== 2 & nace_both== 62

replace	c_adv=	0 if cntry== "AT" & essround== 2 & nace_both== 63

replace	c_adv=	0 if cntry== "BE" & essround== 2 & nace_both== 63

replace	c_adv=	0 if cntry== "CZ" & essround== 2 & nace_both== 63

replace	c_adv=	0 if cntry== "DK" & essround== 2 & nace_both== 63

replace	c_adv=	0 if cntry== "FI" & essround== 2 & nace_both== 63

replace	c_adv=	0 if cntry== "FR" & essround== 2 & nace_both== 63

replace	c_adv=	0 if cntry== "DE" & essround== 2 & nace_both== 63

replace	c_adv=	0 if cntry== "GR" & essround== 2 & nace_both== 63

replace	c_adv=	0 if cntry== "HU" & essround== 2 & nace_both== 63

replace	c_adv=	0 if cntry== "IS" & essround== 2 & nace_both== 63

replace	c_adv=	0 if cntry== "IE" & essround== 2 & nace_both== 63

replace	c_adv=	0 if cntry== "IT" & essround== 2 & nace_both== 63

replace	c_adv=	0 if cntry== "LU" & essround== 2 & nace_both== 63

replace	c_adv=	0 if cntry== "NL" & essround== 2 & nace_both== 63

replace	c_adv=	0 if cntry== "NO" & essround== 2 & nace_both== 63

replace	c_adv=	0 if cntry== "PL" & essround== 2 & nace_both== 63

replace	c_adv=	0 if cntry== "PT" & essround== 2 & nace_both== 63

replace	c_adv=	0 if cntry== "SK" & essround== 2 & nace_both== 63

replace	c_adv=	0 if cntry== "ES" & essround== 2 & nace_both== 63

replace	c_adv=	0 if cntry== "SE" & essround== 2 & nace_both== 63

replace	c_adv=	0 if cntry== "CH" & essround== 2 & nace_both== 63

replace	c_adv=	0 if cntry== "TR" & essround== 2 & nace_both== 63

replace	c_adv=	0 if cntry== "GB" & essround== 2 & nace_both== 63

replace	c_adv=	0 if cntry== "AT" & essround== 2 & nace_both== 64

replace	c_adv=	0 if cntry== "BE" & essround== 2 & nace_both== 64

replace	c_adv=	0 if cntry== "CZ" & essround== 2 & nace_both== 64

replace	c_adv=	0 if cntry== "DK" & essround== 2 & nace_both== 64

replace	c_adv=	0 if cntry== "FI" & essround== 2 & nace_both== 64

replace	c_adv=	0 if cntry== "FR" & essround== 2 & nace_both== 64

replace	c_adv=	0 if cntry== "DE" & essround== 2 & nace_both== 64

replace	c_adv=	0 if cntry== "GR" & essround== 2 & nace_both== 64

replace	c_adv=	0 if cntry== "HU" & essround== 2 & nace_both== 64

replace	c_adv=	0 if cntry== "IS" & essround== 2 & nace_both== 64

replace	c_adv=	0 if cntry== "IE" & essround== 2 & nace_both== 64

replace	c_adv=	0 if cntry== "IT" & essround== 2 & nace_both== 64

replace	c_adv=	0 if cntry== "LU" & essround== 2 & nace_both== 64

replace	c_adv=	0 if cntry== "NL" & essround== 2 & nace_both== 64

replace	c_adv=	0 if cntry== "NO" & essround== 2 & nace_both== 64

replace	c_adv=	0 if cntry== "PL" & essround== 2 & nace_both== 64

replace	c_adv=	0 if cntry== "PT" & essround== 2 & nace_both== 64

replace	c_adv=	0 if cntry== "SK" & essround== 2 & nace_both== 64

replace	c_adv=	0 if cntry== "ES" & essround== 2 & nace_both== 64

replace	c_adv=	0 if cntry== "SE" & essround== 2 & nace_both== 64

replace	c_adv=	0 if cntry== "CH" & essround== 2 & nace_both== 64

replace	c_adv=	0 if cntry== "TR" & essround== 2 & nace_both== 64

replace	c_adv=	0 if cntry== "GB" & essround== 2 & nace_both== 64

replace	c_adv=	0 if cntry== "AT" & essround== 2 & nace_both== 65

replace	c_adv=	0 if cntry== "BE" & essround== 2 & nace_both== 65

replace	c_adv=	0 if cntry== "CZ" & essround== 2 & nace_both== 65

replace	c_adv=	0 if cntry== "DK" & essround== 2 & nace_both== 65

replace	c_adv=	0 if cntry== "FI" & essround== 2 & nace_both== 65

replace	c_adv=	0 if cntry== "FR" & essround== 2 & nace_both== 65

replace	c_adv=	0 if cntry== "DE" & essround== 2 & nace_both== 65

replace	c_adv=	0 if cntry== "GR" & essround== 2 & nace_both== 65

replace	c_adv=	0 if cntry== "HU" & essround== 2 & nace_both== 65

replace	c_adv=	0 if cntry== "IS" & essround== 2 & nace_both== 65

replace	c_adv=	0 if cntry== "IE" & essround== 2 & nace_both== 65

replace	c_adv=	0 if cntry== "IT" & essround== 2 & nace_both== 65

replace	c_adv=	0 if cntry== "LU" & essround== 2 & nace_both== 65

replace	c_adv=	0 if cntry== "NL" & essround== 2 & nace_both== 65

replace	c_adv=	0 if cntry== "NO" & essround== 2 & nace_both== 65

replace	c_adv=	0 if cntry== "PL" & essround== 2 & nace_both== 65

replace	c_adv=	0 if cntry== "PT" & essround== 2 & nace_both== 65

replace	c_adv=	0 if cntry== "SK" & essround== 2 & nace_both== 65

replace	c_adv=	0 if cntry== "ES" & essround== 2 & nace_both== 65

replace	c_adv=	0 if cntry== "SE" & essround== 2 & nace_both== 65

replace	c_adv=	0 if cntry== "CH" & essround== 2 & nace_both== 65

replace	c_adv=	0 if cntry== "TR" & essround== 2 & nace_both== 65

replace	c_adv=	0 if cntry== "GB" & essround== 2 & nace_both== 65

replace	c_adv=	0 if cntry== "AT" & essround== 2 & nace_both== 66

replace	c_adv=	0 if cntry== "BE" & essround== 2 & nace_both== 66

replace	c_adv=	0 if cntry== "CZ" & essround== 2 & nace_both== 66

replace	c_adv=	0 if cntry== "DK" & essround== 2 & nace_both== 66

replace	c_adv=	0 if cntry== "FI" & essround== 2 & nace_both== 66

replace	c_adv=	0 if cntry== "FR" & essround== 2 & nace_both== 66

replace	c_adv=	0 if cntry== "DE" & essround== 2 & nace_both== 66

replace	c_adv=	0 if cntry== "GR" & essround== 2 & nace_both== 66

replace	c_adv=	0 if cntry== "HU" & essround== 2 & nace_both== 66

replace	c_adv=	0 if cntry== "IS" & essround== 2 & nace_both== 66

replace	c_adv=	0 if cntry== "IE" & essround== 2 & nace_both== 66

replace	c_adv=	0 if cntry== "IT" & essround== 2 & nace_both== 66

replace	c_adv=	0 if cntry== "LU" & essround== 2 & nace_both== 66

replace	c_adv=	0 if cntry== "NL" & essround== 2 & nace_both== 66

replace	c_adv=	0 if cntry== "NO" & essround== 2 & nace_both== 66

replace	c_adv=	0 if cntry== "PL" & essround== 2 & nace_both== 66

replace	c_adv=	0 if cntry== "PT" & essround== 2 & nace_both== 66

replace	c_adv=	0 if cntry== "SK" & essround== 2 & nace_both== 66

replace	c_adv=	0 if cntry== "ES" & essround== 2 & nace_both== 66

replace	c_adv=	0 if cntry== "SE" & essround== 2 & nace_both== 66

replace	c_adv=	0 if cntry== "CH" & essround== 2 & nace_both== 66

replace	c_adv=	0 if cntry== "TR" & essround== 2 & nace_both== 66

replace	c_adv=	0 if cntry== "GB" & essround== 2 & nace_both== 66

replace	c_adv=	0 if cntry== "AT" & essround== 2 & nace_both== 67

replace	c_adv=	0 if cntry== "BE" & essround== 2 & nace_both== 67

replace	c_adv=	0 if cntry== "CZ" & essround== 2 & nace_both== 67

replace	c_adv=	0 if cntry== "DK" & essround== 2 & nace_both== 67

replace	c_adv=	0 if cntry== "FI" & essround== 2 & nace_both== 67

replace	c_adv=	0 if cntry== "FR" & essround== 2 & nace_both== 67

replace	c_adv=	0 if cntry== "DE" & essround== 2 & nace_both== 67

replace	c_adv=	0 if cntry== "GR" & essround== 2 & nace_both== 67

replace	c_adv=	0 if cntry== "HU" & essround== 2 & nace_both== 67

replace	c_adv=	0 if cntry== "IS" & essround== 2 & nace_both== 67

replace	c_adv=	0 if cntry== "IE" & essround== 2 & nace_both== 67

replace	c_adv=	0 if cntry== "IT" & essround== 2 & nace_both== 67

replace	c_adv=	0 if cntry== "LU" & essround== 2 & nace_both== 67

replace	c_adv=	0 if cntry== "NL" & essround== 2 & nace_both== 67

replace	c_adv=	0 if cntry== "NO" & essround== 2 & nace_both== 67

replace	c_adv=	0 if cntry== "PL" & essround== 2 & nace_both== 67

replace	c_adv=	0 if cntry== "PT" & essround== 2 & nace_both== 67

replace	c_adv=	0 if cntry== "SK" & essround== 2 & nace_both== 67

replace	c_adv=	0 if cntry== "ES" & essround== 2 & nace_both== 67

replace	c_adv=	0 if cntry== "SE" & essround== 2 & nace_both== 67

replace	c_adv=	0 if cntry== "CH" & essround== 2 & nace_both== 67

replace	c_adv=	0 if cntry== "TR" & essround== 2 & nace_both== 67

replace	c_adv=	0 if cntry== "GB" & essround== 2 & nace_both== 67

replace	c_adv=	0 if cntry== "AT" & essround== 2 & nace_both== 70

replace	c_adv=	0 if cntry== "BE" & essround== 2 & nace_both== 70

replace	c_adv=	0 if cntry== "CZ" & essround== 2 & nace_both== 70

replace	c_adv=	0 if cntry== "DK" & essround== 2 & nace_both== 70

replace	c_adv=	0 if cntry== "FI" & essround== 2 & nace_both== 70

replace	c_adv=	0 if cntry== "FR" & essround== 2 & nace_both== 70

replace	c_adv=	0 if cntry== "DE" & essround== 2 & nace_both== 70

replace	c_adv=	0 if cntry== "GR" & essround== 2 & nace_both== 70

replace	c_adv=	0 if cntry== "HU" & essround== 2 & nace_both== 70

replace	c_adv=	0 if cntry== "IS" & essround== 2 & nace_both== 70

replace	c_adv=	0 if cntry== "IE" & essround== 2 & nace_both== 70

replace	c_adv=	0 if cntry== "IT" & essround== 2 & nace_both== 70

replace	c_adv=	0 if cntry== "LU" & essround== 2 & nace_both== 70

replace	c_adv=	0 if cntry== "NL" & essround== 2 & nace_both== 70

replace	c_adv=	0 if cntry== "NO" & essround== 2 & nace_both== 70

replace	c_adv=	0 if cntry== "PL" & essround== 2 & nace_both== 70

replace	c_adv=	0 if cntry== "PT" & essround== 2 & nace_both== 70

replace	c_adv=	0 if cntry== "SK" & essround== 2 & nace_both== 70

replace	c_adv=	0 if cntry== "ES" & essround== 2 & nace_both== 70

replace	c_adv=	0 if cntry== "SE" & essround== 2 & nace_both== 70

replace	c_adv=	0 if cntry== "CH" & essround== 2 & nace_both== 70

replace	c_adv=	0 if cntry== "TR" & essround== 2 & nace_both== 70

replace	c_adv=	0 if cntry== "GB" & essround== 2 & nace_both== 70

replace	c_adv=	0 if cntry== "AT" & essround== 2 & nace_both== 71

replace	c_adv=	0 if cntry== "BE" & essround== 2 & nace_both== 71

replace	c_adv=	0 if cntry== "CZ" & essround== 2 & nace_both== 71

replace	c_adv=	0 if cntry== "DK" & essround== 2 & nace_both== 71

replace	c_adv=	0 if cntry== "FI" & essround== 2 & nace_both== 71

replace	c_adv=	0 if cntry== "FR" & essround== 2 & nace_both== 71

replace	c_adv=	0 if cntry== "DE" & essround== 2 & nace_both== 71

replace	c_adv=	0 if cntry== "GR" & essround== 2 & nace_both== 71

replace	c_adv=	0 if cntry== "HU" & essround== 2 & nace_both== 71

replace	c_adv=	0 if cntry== "IS" & essround== 2 & nace_both== 71

replace	c_adv=	0 if cntry== "IE" & essround== 2 & nace_both== 71

replace	c_adv=	0 if cntry== "IT" & essround== 2 & nace_both== 71

replace	c_adv=	0 if cntry== "LU" & essround== 2 & nace_both== 71

replace	c_adv=	0 if cntry== "NL" & essround== 2 & nace_both== 71

replace	c_adv=	0 if cntry== "NO" & essround== 2 & nace_both== 71

replace	c_adv=	0 if cntry== "PL" & essround== 2 & nace_both== 71

replace	c_adv=	0 if cntry== "PT" & essround== 2 & nace_both== 71

replace	c_adv=	0 if cntry== "SK" & essround== 2 & nace_both== 71

replace	c_adv=	0 if cntry== "ES" & essround== 2 & nace_both== 71

replace	c_adv=	0 if cntry== "SE" & essround== 2 & nace_both== 71

replace	c_adv=	0 if cntry== "CH" & essround== 2 & nace_both== 71

replace	c_adv=	0 if cntry== "TR" & essround== 2 & nace_both== 71

replace	c_adv=	0 if cntry== "GB" & essround== 2 & nace_both== 71

replace	c_adv=	0 if cntry== "AT" & essround== 2 & nace_both== 72

replace	c_adv=	0 if cntry== "BE" & essround== 2 & nace_both== 72

replace	c_adv=	0 if cntry== "CZ" & essround== 2 & nace_both== 72

replace	c_adv=	0 if cntry== "DK" & essround== 2 & nace_both== 72

replace	c_adv=	0 if cntry== "FI" & essround== 2 & nace_both== 72

replace	c_adv=	0 if cntry== "FR" & essround== 2 & nace_both== 72

replace	c_adv=	0 if cntry== "DE" & essround== 2 & nace_both== 72

replace	c_adv=	0 if cntry== "GR" & essround== 2 & nace_both== 72

replace	c_adv=	0 if cntry== "HU" & essround== 2 & nace_both== 72

replace	c_adv=	0 if cntry== "IS" & essround== 2 & nace_both== 72

replace	c_adv=	0 if cntry== "IE" & essround== 2 & nace_both== 72

replace	c_adv=	0 if cntry== "IT" & essround== 2 & nace_both== 72

replace	c_adv=	0 if cntry== "LU" & essround== 2 & nace_both== 72

replace	c_adv=	0 if cntry== "NL" & essround== 2 & nace_both== 72

replace	c_adv=	0 if cntry== "NO" & essround== 2 & nace_both== 72

replace	c_adv=	0 if cntry== "PL" & essround== 2 & nace_both== 72

replace	c_adv=	0 if cntry== "PT" & essround== 2 & nace_both== 72

replace	c_adv=	0 if cntry== "SK" & essround== 2 & nace_both== 72

replace	c_adv=	0 if cntry== "ES" & essround== 2 & nace_both== 72

replace	c_adv=	0 if cntry== "SE" & essround== 2 & nace_both== 72

replace	c_adv=	0 if cntry== "CH" & essround== 2 & nace_both== 72

replace	c_adv=	0 if cntry== "TR" & essround== 2 & nace_both== 72

replace	c_adv=	0 if cntry== "GB" & essround== 2 & nace_both== 72

replace	c_adv=	0 if cntry== "AT" & essround== 2 & nace_both== 73

replace	c_adv=	0 if cntry== "BE" & essround== 2 & nace_both== 73

replace	c_adv=	0 if cntry== "CZ" & essround== 2 & nace_both== 73

replace	c_adv=	0 if cntry== "DK" & essround== 2 & nace_both== 73

replace	c_adv=	0 if cntry== "FI" & essround== 2 & nace_both== 73

replace	c_adv=	0 if cntry== "FR" & essround== 2 & nace_both== 73

replace	c_adv=	0 if cntry== "DE" & essround== 2 & nace_both== 73

replace	c_adv=	0 if cntry== "GR" & essround== 2 & nace_both== 73

replace	c_adv=	0 if cntry== "HU" & essround== 2 & nace_both== 73

replace	c_adv=	0 if cntry== "IS" & essround== 2 & nace_both== 73

replace	c_adv=	0 if cntry== "IE" & essround== 2 & nace_both== 73

replace	c_adv=	0 if cntry== "IT" & essround== 2 & nace_both== 73

replace	c_adv=	0 if cntry== "LU" & essround== 2 & nace_both== 73

replace	c_adv=	0 if cntry== "NL" & essround== 2 & nace_both== 73

replace	c_adv=	0 if cntry== "NO" & essround== 2 & nace_both== 73

replace	c_adv=	0 if cntry== "PL" & essround== 2 & nace_both== 73

replace	c_adv=	0 if cntry== "PT" & essround== 2 & nace_both== 73

replace	c_adv=	0 if cntry== "SK" & essround== 2 & nace_both== 73

replace	c_adv=	0 if cntry== "ES" & essround== 2 & nace_both== 73

replace	c_adv=	0 if cntry== "SE" & essround== 2 & nace_both== 73

replace	c_adv=	0 if cntry== "CH" & essround== 2 & nace_both== 73

replace	c_adv=	0 if cntry== "TR" & essround== 2 & nace_both== 73

replace	c_adv=	0 if cntry== "GB" & essround== 2 & nace_both== 73

replace	c_adv=	-1 if cntry== "AT" & essround== 2 & nace_both== 74

replace	c_adv=	-1 if cntry== "BE" & essround== 2 & nace_both== 74

replace	c_adv=	-1 if cntry== "CZ" & essround== 2 & nace_both== 74

replace	c_adv=	-1 if cntry== "DK" & essround== 2 & nace_both== 74

replace	c_adv=	-1 if cntry== "FI" & essround== 2 & nace_both== 74

replace	c_adv=	-1 if cntry== "FR" & essround== 2 & nace_both== 74

replace	c_adv=	1 if cntry== "DE" & essround== 2 & nace_both== 74

replace	c_adv=	-1 if cntry== "GR" & essround== 2 & nace_both== 74

replace	c_adv=	-1 if cntry== "HU" & essround== 2 & nace_both== 74

replace	c_adv=	0 if cntry== "IS" & essround== 2 & nace_both== 74

replace	c_adv=	-1 if cntry== "IE" & essround== 2 & nace_both== 74

replace	c_adv=	-1 if cntry== "IT" & essround== 2 & nace_both== 74

replace	c_adv=	-1 if cntry== "LU" & essround== 2 & nace_both== 74

replace	c_adv=	-1 if cntry== "NL" & essround== 2 & nace_both== 74

replace	c_adv=	-1 if cntry== "NO" & essround== 2 & nace_both== 74

replace	c_adv=	-1 if cntry== "PL" & essround== 2 & nace_both== 74

replace	c_adv=	-1 if cntry== "PT" & essround== 2 & nace_both== 74

replace	c_adv=	-1 if cntry== "SK" & essround== 2 & nace_both== 74

replace	c_adv=	-1 if cntry== "ES" & essround== 2 & nace_both== 74

replace	c_adv=	-1 if cntry== "SE" & essround== 2 & nace_both== 74

replace	c_adv=	1 if cntry== "CH" & essround== 2 & nace_both== 74

replace	c_adv=	-1 if cntry== "TR" & essround== 2 & nace_both== 74

replace	c_adv=	1 if cntry== "GB" & essround== 2 & nace_both== 74

replace	c_adv=	0 if cntry== "AT" & essround== 2 & nace_both== 75

replace	c_adv=	0 if cntry== "BE" & essround== 2 & nace_both== 75

replace	c_adv=	0 if cntry== "CZ" & essround== 2 & nace_both== 75

replace	c_adv=	0 if cntry== "DK" & essround== 2 & nace_both== 75

replace	c_adv=	0 if cntry== "FI" & essround== 2 & nace_both== 75

replace	c_adv=	0 if cntry== "FR" & essround== 2 & nace_both== 75

replace	c_adv=	0 if cntry== "DE" & essround== 2 & nace_both== 75

replace	c_adv=	0 if cntry== "GR" & essround== 2 & nace_both== 75

replace	c_adv=	0 if cntry== "HU" & essround== 2 & nace_both== 75

replace	c_adv=	0 if cntry== "IS" & essround== 2 & nace_both== 75

replace	c_adv=	0 if cntry== "IE" & essround== 2 & nace_both== 75

replace	c_adv=	0 if cntry== "IT" & essround== 2 & nace_both== 75

replace	c_adv=	0 if cntry== "LU" & essround== 2 & nace_both== 75

replace	c_adv=	0 if cntry== "NL" & essround== 2 & nace_both== 75

replace	c_adv=	0 if cntry== "NO" & essround== 2 & nace_both== 75

replace	c_adv=	0 if cntry== "PL" & essround== 2 & nace_both== 75

replace	c_adv=	0 if cntry== "PT" & essround== 2 & nace_both== 75

replace	c_adv=	0 if cntry== "SK" & essround== 2 & nace_both== 75

replace	c_adv=	0 if cntry== "ES" & essround== 2 & nace_both== 75

replace	c_adv=	0 if cntry== "SE" & essround== 2 & nace_both== 75

replace	c_adv=	0 if cntry== "CH" & essround== 2 & nace_both== 75

replace	c_adv=	0 if cntry== "TR" & essround== 2 & nace_both== 75

replace	c_adv=	0 if cntry== "GB" & essround== 2 & nace_both== 75

replace	c_adv=	0 if cntry== "AT" & essround== 2 & nace_both== 80

replace	c_adv=	0 if cntry== "BE" & essround== 2 & nace_both== 80

replace	c_adv=	0 if cntry== "CZ" & essround== 2 & nace_both== 80

replace	c_adv=	0 if cntry== "DK" & essround== 2 & nace_both== 80

replace	c_adv=	0 if cntry== "FI" & essround== 2 & nace_both== 80

replace	c_adv=	0 if cntry== "FR" & essround== 2 & nace_both== 80

replace	c_adv=	0 if cntry== "DE" & essround== 2 & nace_both== 80

replace	c_adv=	0 if cntry== "GR" & essround== 2 & nace_both== 80

replace	c_adv=	0 if cntry== "HU" & essround== 2 & nace_both== 80

replace	c_adv=	0 if cntry== "IS" & essround== 2 & nace_both== 80

replace	c_adv=	0 if cntry== "IE" & essround== 2 & nace_both== 80

replace	c_adv=	0 if cntry== "IT" & essround== 2 & nace_both== 80

replace	c_adv=	0 if cntry== "LU" & essround== 2 & nace_both== 80

replace	c_adv=	0 if cntry== "NL" & essround== 2 & nace_both== 80

replace	c_adv=	0 if cntry== "NO" & essround== 2 & nace_both== 80

replace	c_adv=	0 if cntry== "PL" & essround== 2 & nace_both== 80

replace	c_adv=	0 if cntry== "PT" & essround== 2 & nace_both== 80

replace	c_adv=	0 if cntry== "SK" & essround== 2 & nace_both== 80

replace	c_adv=	0 if cntry== "ES" & essround== 2 & nace_both== 80

replace	c_adv=	0 if cntry== "SE" & essround== 2 & nace_both== 80

replace	c_adv=	0 if cntry== "CH" & essround== 2 & nace_both== 80

replace	c_adv=	0 if cntry== "TR" & essround== 2 & nace_both== 80

replace	c_adv=	0 if cntry== "GB" & essround== 2 & nace_both== 80

replace	c_adv=	0 if cntry== "AT" & essround== 2 & nace_both== 85

replace	c_adv=	0 if cntry== "BE" & essround== 2 & nace_both== 85

replace	c_adv=	0 if cntry== "CZ" & essround== 2 & nace_both== 85

replace	c_adv=	0 if cntry== "DK" & essround== 2 & nace_both== 85

replace	c_adv=	0 if cntry== "FI" & essround== 2 & nace_both== 85

replace	c_adv=	0 if cntry== "FR" & essround== 2 & nace_both== 85

replace	c_adv=	0 if cntry== "DE" & essround== 2 & nace_both== 85

replace	c_adv=	0 if cntry== "GR" & essround== 2 & nace_both== 85

replace	c_adv=	0 if cntry== "HU" & essround== 2 & nace_both== 85

replace	c_adv=	0 if cntry== "IS" & essround== 2 & nace_both== 85

replace	c_adv=	0 if cntry== "IE" & essround== 2 & nace_both== 85

replace	c_adv=	0 if cntry== "IT" & essround== 2 & nace_both== 85

replace	c_adv=	0 if cntry== "LU" & essround== 2 & nace_both== 85

replace	c_adv=	0 if cntry== "NL" & essround== 2 & nace_both== 85

replace	c_adv=	0 if cntry== "NO" & essround== 2 & nace_both== 85

replace	c_adv=	0 if cntry== "PL" & essround== 2 & nace_both== 85

replace	c_adv=	0 if cntry== "PT" & essround== 2 & nace_both== 85

replace	c_adv=	0 if cntry== "SK" & essround== 2 & nace_both== 85

replace	c_adv=	0 if cntry== "ES" & essround== 2 & nace_both== 85

replace	c_adv=	0 if cntry== "SE" & essround== 2 & nace_both== 85

replace	c_adv=	0 if cntry== "CH" & essround== 2 & nace_both== 85

replace	c_adv=	0 if cntry== "TR" & essround== 2 & nace_both== 85

replace	c_adv=	0 if cntry== "GB" & essround== 2 & nace_both== 85

replace	c_adv=	0 if cntry== "AT" & essround== 2 & nace_both== 90

replace	c_adv=	0 if cntry== "BE" & essround== 2 & nace_both== 90

replace	c_adv=	0 if cntry== "CZ" & essround== 2 & nace_both== 90

replace	c_adv=	0 if cntry== "DK" & essround== 2 & nace_both== 90

replace	c_adv=	0 if cntry== "FI" & essround== 2 & nace_both== 90

replace	c_adv=	0 if cntry== "FR" & essround== 2 & nace_both== 90

replace	c_adv=	0 if cntry== "DE" & essround== 2 & nace_both== 90

replace	c_adv=	0 if cntry== "GR" & essround== 2 & nace_both== 90

replace	c_adv=	0 if cntry== "HU" & essround== 2 & nace_both== 90

replace	c_adv=	0 if cntry== "IS" & essround== 2 & nace_both== 90

replace	c_adv=	0 if cntry== "IE" & essround== 2 & nace_both== 90

replace	c_adv=	0 if cntry== "IT" & essround== 2 & nace_both== 90

replace	c_adv=	0 if cntry== "LU" & essround== 2 & nace_both== 90

replace	c_adv=	0 if cntry== "NL" & essround== 2 & nace_both== 90

replace	c_adv=	0 if cntry== "NO" & essround== 2 & nace_both== 90

replace	c_adv=	0 if cntry== "PL" & essround== 2 & nace_both== 90

replace	c_adv=	0 if cntry== "PT" & essround== 2 & nace_both== 90

replace	c_adv=	0 if cntry== "SK" & essround== 2 & nace_both== 90

replace	c_adv=	0 if cntry== "ES" & essround== 2 & nace_both== 90

replace	c_adv=	0 if cntry== "SE" & essround== 2 & nace_both== 90

replace	c_adv=	0 if cntry== "CH" & essround== 2 & nace_both== 90

replace	c_adv=	0 if cntry== "TR" & essround== 2 & nace_both== 90

replace	c_adv=	0 if cntry== "GB" & essround== 2 & nace_both== 90

replace	c_adv=	0 if cntry== "AT" & essround== 2 & nace_both== 91

replace	c_adv=	0 if cntry== "BE" & essround== 2 & nace_both== 91

replace	c_adv=	0 if cntry== "CZ" & essround== 2 & nace_both== 91

replace	c_adv=	0 if cntry== "DK" & essround== 2 & nace_both== 91

replace	c_adv=	0 if cntry== "FI" & essround== 2 & nace_both== 91

replace	c_adv=	0 if cntry== "FR" & essround== 2 & nace_both== 91

replace	c_adv=	0 if cntry== "DE" & essround== 2 & nace_both== 91

replace	c_adv=	0 if cntry== "GR" & essround== 2 & nace_both== 91

replace	c_adv=	0 if cntry== "HU" & essround== 2 & nace_both== 91

replace	c_adv=	0 if cntry== "IS" & essround== 2 & nace_both== 91

replace	c_adv=	0 if cntry== "IE" & essround== 2 & nace_both== 91

replace	c_adv=	0 if cntry== "IT" & essround== 2 & nace_both== 91

replace	c_adv=	0 if cntry== "LU" & essround== 2 & nace_both== 91

replace	c_adv=	0 if cntry== "NL" & essround== 2 & nace_both== 91

replace	c_adv=	0 if cntry== "NO" & essround== 2 & nace_both== 91

replace	c_adv=	0 if cntry== "PL" & essround== 2 & nace_both== 91

replace	c_adv=	0 if cntry== "PT" & essround== 2 & nace_both== 91

replace	c_adv=	0 if cntry== "SK" & essround== 2 & nace_both== 91

replace	c_adv=	0 if cntry== "ES" & essround== 2 & nace_both== 91

replace	c_adv=	0 if cntry== "SE" & essround== 2 & nace_both== 91

replace	c_adv=	0 if cntry== "CH" & essround== 2 & nace_both== 91

replace	c_adv=	0 if cntry== "TR" & essround== 2 & nace_both== 91

replace	c_adv=	0 if cntry== "GB" & essround== 2 & nace_both== 91

replace	c_adv=	-1 if cntry== "AT" & essround== 2 & nace_both== 92

replace	c_adv=	-1 if cntry== "BE" & essround== 2 & nace_both== 92

replace	c_adv=	-1 if cntry== "CZ" & essround== 2 & nace_both== 92

replace	c_adv=	-1 if cntry== "DK" & essround== 2 & nace_both== 92

replace	c_adv=	0 if cntry== "FI" & essround== 2 & nace_both== 92

replace	c_adv=	1 if cntry== "FR" & essround== 2 & nace_both== 92

replace	c_adv=	-1 if cntry== "DE" & essround== 2 & nace_both== 92

replace	c_adv=	-1 if cntry== "GR" & essround== 2 & nace_both== 92

replace	c_adv=	-1 if cntry== "HU" & essround== 2 & nace_both== 92

replace	c_adv=	-1 if cntry== "IS" & essround== 2 & nace_both== 92

replace	c_adv=	-1 if cntry== "IE" & essround== 2 & nace_both== 92

replace	c_adv=	-1 if cntry== "IT" & essround== 2 & nace_both== 92

replace	c_adv=	-1 if cntry== "LU" & essround== 2 & nace_both== 92

replace	c_adv=	-1 if cntry== "NL" & essround== 2 & nace_both== 92

replace	c_adv=	-1 if cntry== "NO" & essround== 2 & nace_both== 92

replace	c_adv=	-1 if cntry== "PL" & essround== 2 & nace_both== 92

replace	c_adv=	-1 if cntry== "PT" & essround== 2 & nace_both== 92

replace	c_adv=	0 if cntry== "SK" & essround== 2 & nace_both== 92

replace	c_adv=	-1 if cntry== "ES" & essround== 2 & nace_both== 92

replace	c_adv=	-1 if cntry== "SE" & essround== 2 & nace_both== 92

replace	c_adv=	1 if cntry== "CH" & essround== 2 & nace_both== 92

replace	c_adv=	0 if cntry== "TR" & essround== 2 & nace_both== 92

replace	c_adv=	1 if cntry== "GB" & essround== 2 & nace_both== 92

replace	c_adv=	0 if cntry== "AT" & essround== 2 & nace_both== 93

replace	c_adv=	0 if cntry== "BE" & essround== 2 & nace_both== 93

replace	c_adv=	0 if cntry== "CZ" & essround== 2 & nace_both== 93

replace	c_adv=	0 if cntry== "DK" & essround== 2 & nace_both== 93

replace	c_adv=	0 if cntry== "FI" & essround== 2 & nace_both== 93

replace	c_adv=	0 if cntry== "FR" & essround== 2 & nace_both== 93

replace	c_adv=	0 if cntry== "DE" & essround== 2 & nace_both== 93

replace	c_adv=	0 if cntry== "GR" & essround== 2 & nace_both== 93

replace	c_adv=	0 if cntry== "HU" & essround== 2 & nace_both== 93

replace	c_adv=	0 if cntry== "IS" & essround== 2 & nace_both== 93

replace	c_adv=	0 if cntry== "IE" & essround== 2 & nace_both== 93

replace	c_adv=	0 if cntry== "IT" & essround== 2 & nace_both== 93

replace	c_adv=	0 if cntry== "LU" & essround== 2 & nace_both== 93

replace	c_adv=	0 if cntry== "NL" & essround== 2 & nace_both== 93

replace	c_adv=	0 if cntry== "NO" & essround== 2 & nace_both== 93

replace	c_adv=	0 if cntry== "PL" & essround== 2 & nace_both== 93

replace	c_adv=	0 if cntry== "PT" & essround== 2 & nace_both== 93

replace	c_adv=	0 if cntry== "SK" & essround== 2 & nace_both== 93

replace	c_adv=	0 if cntry== "ES" & essround== 2 & nace_both== 93

replace	c_adv=	0 if cntry== "SE" & essround== 2 & nace_both== 93

replace	c_adv=	0 if cntry== "CH" & essround== 2 & nace_both== 93

replace	c_adv=	0 if cntry== "TR" & essround== 2 & nace_both== 93

replace	c_adv=	0 if cntry== "GB" & essround== 2 & nace_both== 93

replace	c_adv=	0 if cntry== "AT" & essround== 2 & nace_both== 95

replace	c_adv=	0 if cntry== "BE" & essround== 2 & nace_both== 95

replace	c_adv=	0 if cntry== "CZ" & essround== 2 & nace_both== 95

replace	c_adv=	0 if cntry== "DK" & essround== 2 & nace_both== 95

replace	c_adv=	0 if cntry== "FI" & essround== 2 & nace_both== 95

replace	c_adv=	0 if cntry== "FR" & essround== 2 & nace_both== 95

replace	c_adv=	0 if cntry== "DE" & essround== 2 & nace_both== 95

replace	c_adv=	0 if cntry== "GR" & essround== 2 & nace_both== 95

replace	c_adv=	0 if cntry== "HU" & essround== 2 & nace_both== 95

replace	c_adv=	0 if cntry== "IS" & essround== 2 & nace_both== 95

replace	c_adv=	0 if cntry== "IE" & essround== 2 & nace_both== 95

replace	c_adv=	0 if cntry== "IT" & essround== 2 & nace_both== 95

replace	c_adv=	0 if cntry== "LU" & essround== 2 & nace_both== 95

replace	c_adv=	0 if cntry== "NL" & essround== 2 & nace_both== 95

replace	c_adv=	0 if cntry== "NO" & essround== 2 & nace_both== 95

replace	c_adv=	0 if cntry== "PL" & essround== 2 & nace_both== 95

replace	c_adv=	0 if cntry== "PT" & essround== 2 & nace_both== 95

replace	c_adv=	0 if cntry== "SK" & essround== 2 & nace_both== 95

replace	c_adv=	0 if cntry== "ES" & essround== 2 & nace_both== 95

replace	c_adv=	0 if cntry== "SE" & essround== 2 & nace_both== 95

replace	c_adv=	0 if cntry== "CH" & essround== 2 & nace_both== 95

replace	c_adv=	0 if cntry== "TR" & essround== 2 & nace_both== 95

replace	c_adv=	0 if cntry== "GB" & essround== 2 & nace_both== 95

replace	c_adv=	-1 if cntry== "AT" & essround== 2 & nace_both== 98

replace	c_adv=	0 if cntry== "BE" & essround== 2 & nace_both== 98

replace	c_adv=	0 if cntry== "CZ" & essround== 2 & nace_both== 98

replace	c_adv=	1 if cntry== "DK" & essround== 2 & nace_both== 98

replace	c_adv=	-1 if cntry== "FI" & essround== 2 & nace_both== 98

replace	c_adv=	0 if cntry== "FR" & essround== 2 & nace_both== 98

replace	c_adv=	1 if cntry== "DE" & essround== 2 & nace_both== 98

replace	c_adv=	1 if cntry== "GR" & essround== 2 & nace_both== 98

replace	c_adv=	0 if cntry== "HU" & essround== 2 & nace_both== 98

replace	c_adv=	-1 if cntry== "IS" & essround== 2 & nace_both== 98

replace	c_adv=	1 if cntry== "IE" & essround== 2 & nace_both== 98

replace	c_adv=	-1 if cntry== "IT" & essround== 2 & nace_both== 98

replace	c_adv=	-1 if cntry== "LU" & essround== 2 & nace_both== 98

replace	c_adv=	-1 if cntry== "NL" & essround== 2 & nace_both== 98

replace	c_adv=	1 if cntry== "NO" & essround== 2 & nace_both== 98

replace	c_adv=	0 if cntry== "PL" & essround== 2 & nace_both== 98

replace	c_adv=	0 if cntry== "PT" & essround== 2 & nace_both== 98

replace	c_adv=	0 if cntry== "SK" & essround== 2 & nace_both== 98

replace	c_adv=	-1 if cntry== "ES" & essround== 2 & nace_both== 98

replace	c_adv=	0 if cntry== "SE" & essround== 2 & nace_both== 98

replace	c_adv=	0 if cntry== "CH" & essround== 2 & nace_both== 98

replace	c_adv=	0 if cntry== "TR" & essround== 2 & nace_both== 98

replace	c_adv=	0 if cntry== "GB" & essround== 2 & nace_both== 98

replace	c_adv=	0 if cntry== "AT" & essround== 2 & nace_both== 99

replace	c_adv=	0 if cntry== "BE" & essround== 2 & nace_both== 99

replace	c_adv=	0 if cntry== "CZ" & essround== 2 & nace_both== 99

replace	c_adv=	0 if cntry== "DK" & essround== 2 & nace_both== 99

replace	c_adv=	0 if cntry== "FI" & essround== 2 & nace_both== 99

replace	c_adv=	0 if cntry== "FR" & essround== 2 & nace_both== 99

replace	c_adv=	0 if cntry== "DE" & essround== 2 & nace_both== 99

replace	c_adv=	0 if cntry== "GR" & essround== 2 & nace_both== 99

replace	c_adv=	0 if cntry== "HU" & essround== 2 & nace_both== 99

replace	c_adv=	0 if cntry== "IS" & essround== 2 & nace_both== 99

replace	c_adv=	0 if cntry== "IE" & essround== 2 & nace_both== 99

replace	c_adv=	0 if cntry== "IT" & essround== 2 & nace_both== 99

replace	c_adv=	0 if cntry== "LU" & essround== 2 & nace_both== 99

replace	c_adv=	0 if cntry== "NL" & essround== 2 & nace_both== 99

replace	c_adv=	0 if cntry== "NO" & essround== 2 & nace_both== 99

replace	c_adv=	0 if cntry== "PL" & essround== 2 & nace_both== 99

replace	c_adv=	0 if cntry== "PT" & essround== 2 & nace_both== 99

replace	c_adv=	0 if cntry== "SK" & essround== 2 & nace_both== 99

replace	c_adv=	0 if cntry== "ES" & essround== 2 & nace_both== 99

replace	c_adv=	0 if cntry== "SE" & essround== 2 & nace_both== 99

replace	c_adv=	0 if cntry== "CH" & essround== 2 & nace_both== 99

replace	c_adv=	0 if cntry== "TR" & essround== 2 & nace_both== 99

replace	c_adv=	0 if cntry== "GB" & essround== 2 & nace_both== 99




* Update trade exposure
*-----------------------
* replace tradeexposure =0 for sectors which are clearly in the nontradable category
gen tradeexposure=tradexp


replace tradeexposure=0.000000001 if nace_both==37 | nace_both==41 | nace_both==45 | nace_both==50 | nace_both==51 | ///
	 nace_both==52 | nace_both==55 | nace_both==60 | nace_both==61 | nace_both==62 | nace_both==63 | nace_both==64 | ///
	 nace_both==65 | nace_both==66 | nace_both==67 | nace_both==70 | nace_both==71 | nace_both==72 | nace_both==73 | ///
	 nace_both==75 | nace_both==80 | nace_both==85 | nace_both==90 | nace_both==91 | nace_both==92 | nace_both==93 | ///
	 nace_both==95 | nace_both==98 | nace_both==99
replace tradeexposure=. if nace_both>100


* Trade exposure (logged)
*-----------------------
gen logtrade=log(tradeexposure)

* Tradable Sector Dummy
*------------------------
gen tradeable=tradeexposure>0.000000001
replace tradeable=. if tradeexposure==.
replace tradeable=1 if nacer1==1 | nacer11==1 
replace tradeable=1 if nacer1>19 & nacer1<40 & tradeex==.
replace tradeable=1 if nacer11>19 & nacer11<40 & tradeex==.
label var tradeable "tradeable sector (Dummy)"


* Interaction terms
* -------------------
gen tradeable_eduy=tradeable*eduyr
gen tradeable_edul=tradeable*edulvl

gen logtrade_edulvl=logtrade*edulvl
gen logtrade_eduy=logtrade*eduyrs


* -----------------------------------------------------------------------
* 1.2.2 Offshoreability
* -----------------------------------------------------------------------
* Data are based on Blinder, Alan. 2007. How Many U.S. Jobs Might Be Offshoreable. CEPS Working Paper No. 142.

gen offshore=.
label var offshore "Offshoring Potential (Blinder)"

gen isco=iscoco
label var isco "4-digit ISCO-code"

* NOTE: all professions not listed by Blinder are coded as not offshoreable (value 0)
replace offshore=0 if isco<.
replace offshore=49 if isco==1142
replace offshore=55 if isco==1222
replace offshore=28 if isco==1226
replace offshore=55 if isco==1228
replace offshore=83 if isco==1231
replace offshore=49 if isco==1232
replace offshore=40 if isco==1233
replace offshore=53 if isco==1234
replace offshore=49 if isco==1235
replace offshore=55 if isco==1236
replace offshore=55 if isco==1237
replace offshore=55 if isco==1311
replace offshore=55 if isco==1312
replace offshore=55 if isco==1313
replace offshore=55 if isco==1314
replace offshore=55 if isco==1315
replace offshore=48 if isco==1316
replace offshore=52 if isco==1317
replace offshore=55 if isco==1318
replace offshore=55 if isco==1319
replace offshore=66 if isco==2111
replace offshore=74 if isco==2112
replace offshore=66 if isco==2113
replace offshore=66 if isco==2114
replace offshore=89 if isco==2121
replace offshore=96 if isco==2122
replace offshore=83 if isco==2131
replace offshore=90 if isco==2139
replace offshore=25 if isco==2141
replace offshore=64 if isco==2143
replace offshore=74 if isco==2144
replace offshore=72 if isco==2146
replace offshore=69 if isco==2147
replace offshore=86 if isco==2148
replace offshore=71 if isco==2149
replace offshore=81 if isco==2211
replace offshore=83 if isco==2212
replace offshore=72 if isco==2411
replace offshore=50 if isco==2419
replace offshore=74 if isco==2421
replace offshore=67 if isco==2444
replace offshore=90 if isco==2451
replace offshore=78 if isco==2452
replace offshore=25 if isco==2453
replace offshore=48 if isco==2455
replace offshore=47 if isco==3111
replace offshore=47 if isco==3113
replace offshore=47 if isco==3114
replace offshore=72 if isco==3115
replace offshore=47 if isco==3116
replace offshore=94 if isco==3118
replace offshore=54 if isco==3119
replace offshore=75 if isco==3121
replace offshore=84 if isco==3122
replace offshore=68 if isco==3123
replace offshore=36 if isco==3131
replace offshore=36 if isco==3132
replace offshore=46 if isco==3133
replace offshore=34 if isco==3139
replace offshore=52 if isco==3141
replace offshore=60 if isco==3152
replace offshore=55 if isco==3211
replace offshore=55 if isco==3212
replace offshore=44 if isco==3213
replace offshore=32 if isco==3228
replace offshore=51 if isco==3411
replace offshore=85 if isco==3412
replace offshore=50 if isco==3414
replace offshore=55 if isco==3416
replace offshore=59 if isco==3419
replace offshore=51 if isco==3421
replace offshore=48 if isco==3422
replace offshore=38 if isco==3431
replace offshore=51 if isco==3432
replace offshore=84 if isco==3433
replace offshore=84 if isco==3434
replace offshore=54 if isco==3439
replace offshore=100 if isco==3442
replace offshore=85 if isco==3471
replace offshore=30 if isco==3472
replace offshore=95 if isco==4111
replace offshore=94 if isco==4112
replace offshore=100 if isco==4113
replace offshore=71 if isco==4114
replace offshore=38 if isco==4115
replace offshore=84 if isco==4121
replace offshore=54 if isco==4122
replace offshore=31 if isco==4131
replace offshore=67 if isco==4132
replace offshore=67 if isco==4133
replace offshore=46 if isco==4141
replace offshore=26 if isco==4142
replace offshore=95 if isco==4143
replace offshore=54 if isco==4144
replace offshore=54 if isco==4190
replace offshore=94 if isco==4211
replace offshore=54 if isco==4214
replace offshore=65 if isco==4215
replace offshore=72 if isco==4221
replace offshore=54 if isco==4222
replace offshore=50 if isco==4223
replace offshore=86 if isco==5113
replace offshore=59 if isco==6142
replace offshore=36 if isco==7111
replace offshore=35 if isco==7112
replace offshore=36 if isco==7113
replace offshore=65 if isco==7211
replace offshore=69 if isco==7212
replace offshore=70 if isco==7213
replace offshore=70 if isco==7222
replace offshore=68 if isco==7223
replace offshore=68 if isco==7224
replace offshore=26 if isco==7311
replace offshore=64 if isco==7313
replace offshore=69 if isco==7321
replace offshore=69 if isco==7322
replace offshore=68 if isco==7323
replace offshore=68 if isco==7324
replace offshore=60 if isco==7331
replace offshore=75 if isco==7332
replace offshore=59 if isco==7341
replace offshore=59 if isco==7342
replace offshore=59 if isco==7343
replace offshore=34 if isco==7344
replace offshore=59 if isco==7345
replace offshore=75 if isco==7346
replace offshore=68 if isco==7413
replace offshore=27 if isco==7414
replace offshore=55 if isco==7415
replace offshore=43 if isco==7421
replace offshore=57 if isco==7422
replace offshore=57 if isco==7423
replace offshore=66 if isco==7424
replace offshore=75 if isco==7431
replace offshore=75 if isco==7432
replace offshore=75 if isco==7433
replace offshore=73 if isco==7434
replace offshore=75 if isco==7435
replace offshore=75 if isco==7436
replace offshore=57 if isco==7437
replace offshore=75 if isco==7441
replace offshore=72 if isco==7442
replace offshore=36 if isco==8111
replace offshore=36 if isco==8112
replace offshore=36 if isco==8113
replace offshore=59 if isco==8121
replace offshore=68 if isco==8122
replace offshore=70 if isco==8123
replace offshore=68 if isco==8124
replace offshore=69 if isco==8131
replace offshore=68 if isco==8139
replace offshore=57 if isco==8141
replace offshore=68 if isco==8142
replace offshore=68 if isco==8143
replace offshore=68 if isco==8151
replace offshore=70 if isco==8152
replace offshore=68 if isco==8153
replace offshore=68 if isco==8154
replace offshore=29 if isco==8155
replace offshore=68 if isco==8159
replace offshore=42 if isco==8161
replace offshore=55 if isco==8162
replace offshore=29 if isco==8163
replace offshore=64 if isco==8171
replace offshore=68 if isco==8172
replace offshore=68 if isco==8211
replace offshore=68 if isco==8212
replace offshore=68 if isco==8221
replace offshore=35 if isco==8222
replace offshore=68 if isco==8223
replace offshore=41 if isco==8224
replace offshore=29 if isco==8229
replace offshore=69 if isco==8231
replace offshore=68 if isco==8232
replace offshore=57 if isco==8240
replace offshore=58 if isco==8251
replace offshore=59 if isco==8252
replace offshore=68 if isco==8253
replace offshore=75 if isco==8261
replace offshore=75 if isco==8262
replace offshore=75 if isco==8263
replace offshore=75 if isco==8264
replace offshore=75 if isco==8265
replace offshore=75 if isco==8266
replace offshore=75 if isco==8269
replace offshore=27 if isco==8271
replace offshore=68 if isco==8272
replace offshore=68 if isco==8273
replace offshore=30 if isco==8274
replace offshore=31 if isco==8275
replace offshore=68 if isco==8276
replace offshore=27 if isco==8277
replace offshore=68 if isco==8278
replace offshore=66 if isco==8281
replace offshore=66 if isco==8282
replace offshore=66 if isco==8283
replace offshore=68 if isco==8284
replace offshore=57 if isco==8285
replace offshore=64 if isco==8286
replace offshore=68 if isco==8290
replace offshore=34 if isco==8340
replace offshore=95 if isco==9113
replace offshore=64 if isco==9321
replace offshore=29 if isco==9333
replace offshore=55 if isco==1227
replace offshore=89 if isco==2121
replace offshore=100 if isco==2132
replace offshore=70 if isco==2145
replace offshore=71 if isco==2149
replace offshore=81 if isco==2211
replace offshore=46 if isco==2412
replace offshore=50 if isco==2419
replace offshore=33 if isco==2432
replace offshore=89 if isco==2441
replace offshore=48 if isco==2455
replace offshore=72 if isco==3115
replace offshore=54 if isco==3119
replace offshore=46 if isco==3133
replace offshore=34 if isco==3139
replace offshore=34 if isco==3224
replace offshore=51 if isco==3411
replace offshore=25 if isco==3415
replace offshore=50 if isco==3417
replace offshore=59 if isco==3419
replace offshore=51 if isco==3432
replace offshore=54 if isco==3439
replace offshore=90 if isco==3460
replace offshore=54 if isco==4122
replace offshore=31 if isco==4131
replace offshore=67 if isco==4132
replace offshore=46 if isco==4141
replace offshore=26 if isco==4142
replace offshore=54 if isco==4222
replace offshore=68 if isco==7141
replace offshore=68 if isco==7224
replace offshore=65 if isco==7241
replace offshore=34 if isco==7344
replace offshore=72 if isco==7442
replace offshore=68 if isco==8122
replace offshore=68 if isco==8139
replace offshore=42 if isco==8161
replace offshore=68 if isco==8211
replace offshore=68 if isco==8223
replace offshore=41 if isco==8224
replace offshore=57 if isco==8240
replace offshore=58 if isco==8251
replace offshore=75 if isco==8269
replace offshore=66 if isco==8281
replace offshore=66 if isco==8283
replace offshore=68 if isco==8284
replace offshore=68 if isco==8290
replace offshore=70 if isco==9322

* Create Ordinal Offshore Variable
*----------------------------------
gen offshore4=.
replace offshore4=3 if offshore<.
replace offshore4=2 if offshore<75
replace offshore4=1 if offshore<50
replace offshore4=0 if offshore<25

label var offshore4 "Job Offshoreability (ordinal)"
label define offshore_4 0 "not offshoreable" 3 "highly offshoreable"
label val offshore4 offshore_4

* Create Dummy Offshore Variable
*---------------------------------
gen offshore2=offshore>=25 
label var offshore2 "Job Offshoreability (Dummy)"
label define offshore_2 0 "not offshoreable" 1 " offshoreable"
label val offshore2 offshore_2


* Interaction terms: Offshore and Education
*--------------------------------------------
gen off2_eduy=offshore2*eduyrs
gen off2_edul=offshore2*edulvl


gen offshore_eduy=offshore*eduyrs
gen offshore_edul=offshore*edulvl


* -----------------------------------------------------------------------
* 1.2.3 Export-oriented and import-competing industries
* -----------------------------------------------------------------------
* generate Dummies for Export-oriented and import-competing sectors based on revealed comparative advantage
* Source: OECD Micro Trade indicators (by category of industry, ISIC)

gen exporiented=c_adv==1
replace exporiented=0 if tradeable ==0
label var exporiented "export-oriented sector"

gen impcomp=c_adv==(-1)
replace impcomp =0 if tradeable ==0
replace impcomp =1 if tradeable ==1 & c_adv==0
label var impcomp "import-competing sector

gen expor_eduy=exporie*eduyrs
gen impcom_eduy=impcomp*eduyrs

gen expor_edul=exporie*edulvl
gen impcom_edul=impcomp*edulvl


* =====================================================================================
* 	1.3 CONTROL VARIABLES
* =====================================================================================

/* --------------------------------------
* Variables already in dataset
* --------------------------------------

Education: eduyrs (education years) and edulvl (education level) 
Ideology (left-right): lrscale: 0 left, 10=right
Income: hinctnt (Higher values denote higher income, 12-point scale)
Unemployment: uempla (Doing last 7 days: unemployed, actively looking for job)
*/


* -----------------------------------------------------------------------
* 1.3.1 Skill Specificity: s1
* -----------------------------------------------------------------------
* see Excel-file provided by Philipp Rehm)
gen risco88_2d=real(substr(string(isco),1,2))
replace risco88_2d=. if real(substr(string(risco88_2d),-1,1))==0

gen s1=risco88_2d
label var s1 "Skill Specificity"
replace s1=1.84 if risco88_2d==11
replace s1=0.64 if risco88_2d==12
replace s1=0.58 if risco88_2d==13
replace s1=0.81 if risco88_2d==21
replace s1=0.73 if risco88_2d==22
replace s1=0.59 if risco88_2d==23
replace s1=0.72 if risco88_2d==24
replace s1=1.17 if risco88_2d==31
replace s1=1.12 if risco88_2d==32
replace s1=0.98 if risco88_2d==33
replace s1=1.03 if risco88_2d==34
replace s1=0.56 if risco88_2d==41
replace s1=0.68 if risco88_2d==42
replace s1=0.59 if risco88_2d==51
replace s1=0.45 if risco88_2d==52
replace s1=1.16 if risco88_2d==61
replace s1=1.40 if risco88_2d==71
replace s1=1.38 if risco88_2d==72
replace s1=2.60 if risco88_2d==73
replace s1=1.60 if risco88_2d==74
replace s1=4.05 if risco88_2d==81
replace s1=2.77 if risco88_2d==82
replace s1=2.16 if risco88_2d==83
replace s1=1.67 if risco88_2d==91
replace s1=1.91 if risco88_2d==92
replace s1=1.76 if risco88_2d==93
replace s1=.64 if isco==1000
replace s1=.72 if isco==2000
replace s1=1.03 if isco==3000
replace s1=.56 if isco==4000
replace s1=.59 if isco==5000
replace s1=1.16 if isco==6000
replace s1=1.4 if isco==7000
replace s1=2.77 if isco==8000
replace s1=1.67 if isco==9000
replace s1=1.07 if isco==100

* -----------------------------------------------------------------------
* 1.3.2 Gender: female
* -----------------------------------------------------------------------
gen female=gndr==2
label var female "Female"

* -----------------------------------------------------------------------
* 1.3.3 Union membership
* -----------------------------------------------------------------------
gen union=mbtru==1
replace union=. if mbtru==.
label var union "Trade Union member"

* -----------------------------------------------------------------------
* 1.3.4 Church attendance
* -----------------------------------------------------------------------
gen church=rlgat*(-1)+7
label var church "church attendance"

* -----------------------------------------------------------------------
* 1.3.5 Deindustrialization: Primary, Secondary, and Tertiary Sector
* -----------------------------------------------------------------------
gen sector=3
replace sector=2 if nace_both<50
replace sector=1 if nace_both<15
replace sector=. if nace_both==.
label val sector sector
label var sector "Sector"
gen primary=sector==1
replace primary=. if sector==.
gen secondary=sector==2
replace secondary =. if sector==.
gen servicesector=sector==3
replace servicesector =. if sector==.

* -----------------------------------------------------------------------
* 1.3.6 Wave Dummy
* -----------------------------------------------------------------------
gen wave04=essround==2

* -----------------------------------------------------------------------
* 1.3.7 Country Dummies: c1-c16
* -----------------------------------------------------------------------
tab cntry, gen (c)
label var c1 "Austria"
label var c2 "Belgium"
label var c3 "Switzerland"
label var c4 "Germany "
label var c5 "Denmark"
label var c6 "Spain"
label var c7 "Finland"
label var c8 "France"
label var c9 "Great Britain"
label var c10 "Greece"
label var c11 "Ireland"
label var c12 "Luxemburg"
label var c13 "Netherlands"
label var c14 "Norway"
label var c15 "Portugal"
label var c16 "Sweden"

* -----------------------------------------------------------------------
* 1.3.8 Weights
* -----------------------------------------------------------------------
gen combinedweight=pweight*dweight
label var combinedweight "Population * design weights"

save Data.Glob_PSRM.FINAL.FULL.dta, replace
* "main dataset"
* ======================================================================
* ======================================================================
* 2. ANALYSIS (MAIN TEXT)
* ======================================================================
* ======================================================================


* --------------------------------------------------------------
* 2.1.1 Figure 3: Histograms
* --------------------------------------------------------------

* Discussion in Text
ttest eduyrs if pdwrk==1 |uempla==1, by(tradeable)
ttest eduyrs if pdwrk==1 |uempla==1, by(offshore2)

tab tradeable if pdwrk==1 |uempla==1, summarize(eduyrs) means
tab offshore2 if pdwrk==1 |uempla==1, summarize(eduyrs) means
tab sector if pdwrk==1 |uempla==1, summarize(eduyrs) means


histogram eduyrs if tradeable==0 & pdwrk==1 | (tradeable==0 & uempla==1) , freq normal ///
	saving( "/Users/walter/Documents/Papers/Globalisierungs-Projekt/Concept-Paper/submission PSRM/R&R PSRM/Figures/nontrad.gph", replace) ///
	xlabel(0(5)30) ylabel(0(2500)5000) ///
	title ("Nontradables Sector", span)
	
histogram eduyrs if tradeable==1  & pdwrk==1 | (tradeable==1 & uempla==1), freq normal ///
	saving("/Users/walter/Documents/Papers/Globalisierungs-Projekt/Concept-Paper/submission PSRM/R&R PSRM/Figures/tradeables.gph", replace) ///
	xlabel(0(5)30)  ylabel(0(2500)5000) ///
	title ("Tradables Sector", span)
	
gr combine "/Users/walter/Documents/Papers/Globalisierungs-Projekt/Concept-Paper/submission PSRM/R&R PSRM/Figures/nontrad.gph" ///
	"/Users/walter/Documents/Papers/Globalisierungs-Projekt/Concept-Paper/submission PSRM/R&R PSRM/Figures/tradeables.gph", ///
	saving("/Users/walter/Documents/Papers/Globalisierungs-Projekt/Concept-Paper/submission PSRM/R&R PSRM/Figures/combined.jpg", replace)

	
* -------------------------------------------------------------
* 2.1.2 Determinants of Labor Market Risk Perceptions
* -------------------------------------------------------------
	
* ----------------------------------------------------------------
* 2.1.2.1 Table 1: Determinants of Labor Market Risk Perceptions
* ----------------------------------------------------------------

set more off
est clear
local controls "eduyrs  s1 hinctnt female age union uempla church primary secondary  wave04 "
quietly xi: ologit lmrisk   `controls'  i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")

local RHS "tradeable  offshore2 "
foreach rhs of local RHS {
	quietly xi: ologit lmrisk `rhs' `controls' i.cntry if pdwrk==1 | uempla==1  [pweight=combinedweight] , cluster(cntry) robust
	eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
}

quietly xi: ologit lmrisk exporien impcomp  `controls'  i.cntry if pdwrk==1 | uempla==1  [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit lmrisk tradeable tradeable_eduy  `controls'  i.cntry if pdwrk==1 | uempla==1  [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit lmrisk offshore2 off2_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit lmrisk exporien expor_eduy impcomp  impcom_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")


* TABLE 1: Determinants of Labor Market Risk Perceptions
* ----------------------------------------------------------
set linesize 255
esttab   est2  est5  est3  est6 est4 est7, ///
	cells(b(star fmt(3) label(Coef.)) se(par label(Std. err.)))  ///
	stats(r2_p ll N bic, fmt(2 0 0) labels("Pseudo R2" "Log Pseudolikelihood" "Observations")) ///
	star(* 0.1 ** 0.05 *** 0.01) /// 
	legend varlabels(_cons Constant) /// 	
	drop(_I*) 

	
	

* -------------------------------------------------------
* 2.1.2.2 Predicted Probabilities of Risk Perceptions
* -------------------------------------------------------
* For all figuers, I hold the control variables at the sample-medians. This implies the following:
* skill-specificity=.81, income=8, male, 40 years old, no trade union member, 
* not unemployed, church=1, primary=0, secondary=0 (and interviewed for 2004 wave), and respondent lives in Austria (baseline)

* Low-education = 8 years of education (5th percentile)
* high education = 19 years of education (95th percentile)

* -------------------------------------------------------
* 2.1.3 FIGURE 3a: TADE DUMMY (Model 1 and 4)
* -------------------------------------------------------
estimates restore est5

* Nontradable sector
* ----------------- 
prvalue, x(tradeable=0 eduyrs=8 tradeable_eduy=0 ) rest(median) level(95) bootstrap save
prvalue, x(tradeable =0 eduyrs=19 tradeable_eduy =0 ) rest(median)   level(95) bootstrap diff
prvalue, x(tradeable =0 eduyrs=19 tradeable_eduy =0 ) rest(median)   level(95) bootstrap

* prvalue, x(tradeable =0 eduyrs=19 tradeable_eduy =0 ) rest(median)   level(95) bootstrap

* Tradable sector
* ----------------- 	
prvalue, x(tradeable=1 eduyrs=8 tradeable_eduy=8 ) rest(median) level(95)  bootstrap save
prvalue, x(tradeable =1 eduyrs=19 tradeable_eduy =19 ) rest(median)   level(95)	bootstrap diff
prvalue, x(tradeable =1 eduyrs=19 tradeable_eduy =19 ) rest(median)   level(95)	bootstrap

*-------------------------------------------------------
* 2.1.4 Comparison with a non-interactive model
*-------------------------------------------------------
estimates restore est2

* Nontradable sector
* ----------------- 
prvalue, x(tradeable=0 eduyrs=8 ) rest(median) level(95) bootstrap save
prvalue, x(tradeable =0 eduyrs=19 ) rest(median)   level(95) bootstrap diff

* Tradable sector
* ----------------- 	
prvalue, x(tradeable=1 eduyrs=8 ) rest(median) level(95)  bootstrap save
prvalue, x(tradeable =1 eduyrs=19  ) rest(median)   level(95)	bootstrap diff

*------------------------------------------------------------
* 2.1.5 Discussion of implications of Hiscox (2002) argument
*------------------------------------------------------------
estimates restore est7

* Nontradable sector
* ----------------- 
prvalue, x(exporien=0 eduyrs=8 expor_eduy=0 impcomp=0  impcom_eduy=0 ) rest(median) level(95)  save
prvalue, x(exporien =0 eduyrs=19 expor_eduy=0 impcomp=0  impcom_eduy=0 ) rest(median)   level(95)  diff

* Export-oriented sector
* ----------------- 	
prvalue, x(exporien=1 eduyrs=8 expor_eduy=8 impcomp=0  impcom_eduy=0 ) rest(median) level(95)   save
prvalue, x(exporien=1 eduyrs=19 expor_eduy=19 impcomp=0  impcom_eduy=0) rest(median)   level(95)	 diff

* Import-competing sector
* ----------------- 	
prvalue, x(exporien=0 eduyrs=8 expor_eduy=0 impcomp=1  impcom_eduy=8 ) rest(median) level(95)   save
prvalue, x(exporien=0 eduyrs=19 expor_eduy=0 impcomp=1  impcom_eduy=19) rest(median)   level(95)	 diff



* ==============================================================================================================
* 2.2	THE EFFECT OF GLOBALIZATION-EXPOSURE ON SOCIAL POLICY PREFERENCES.
* ==============================================================================================================
	
* ---------------------------------------------------------------
* 2.2.1 Determinants of Preferences for Redistribution
* ---------------------------------------------------------------

* ----------------------------------------------------------------
* 2.2.1.1 Table 2: Determinants of Preferences for Redistribution
* ----------------------------------------------------------------

set more off
est clear
local controls "eduyrs  s1 hinctnt female age union uempla church  secondary primary wave04 "
quietly xi: ologit redistribution   `controls'  i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")


local RHS "tradeable  offshore2 "
foreach rhs of local RHS {
	quietly xi: ologit redistribution `rhs' `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
	eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
}

quietly xi: ologit redistribution exporien impcomp  `controls'  i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")

quietly xi: ologit redistribution tradeable tradeable_eduy  `controls'  i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")

quietly xi: ologit redistribution offshore2 off2_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")

quietly xi: ologit redistribution exporien expor_eduy impcomp  impcom_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")


* Table 2: Determinants of Preferences for Redistribution
*----------------------------------------------------------
set linesize 255
esttab   est2  est5  est3  est6 est4 est7, ///
	cells(b(star fmt(3) label(Coef.)) se(par label(Std. err.)))  ///
	stats(r2_p ll N bic, fmt(2 0 0) labels("Pseudo R2" "Log Pseudolikelihood" "Observations")) ///
	star(* 0.1 ** 0.05 *** 0.01) /// 
	legend varlabels(_cons Constant) /// 	
	drop(_I*) 


* --------------------------------------------------------------
* 2.2.1.2 Predicted Probabilities of Redistribution Preferences
* --------------------------------------------------------------
* For all figuers, I hold the control variables at the sample-medians. This implies the following:
* skill-specificity=.81, income=8, male, 40 years old, no trade union member, 
* not unemployed, church=1, lrscale=5 (and interviewed for 2004 wave), and respondent lives in Austria (baseline)

*
* Low-education = 8 years of education (5th percentile)
* high education = 19 years of education (95th percentile)

* --------------------------------------------------------------
* 2.2.2 Figure 3b: Trade Dummy (Model 8)
* --------------------------------------------------------------
estimates restore est5

* Nontradable sector
* ----------------- 
prvalue, x(tradeable=0 eduyrs=8 tradeable_eduy=0 ) rest(median) level(95) bootstrap save
prvalue, x(tradeable =0 eduyrs=19 tradeable_eduy =0 ) rest(median)   level(95) bootstrap diff
prvalue, x(tradeable =0 eduyrs=19 tradeable_eduy =0 ) rest(median)   level(95) bootstrap


* Tradable sector
* ----------------- 	
prvalue, x(tradeable=1 eduyrs=8 tradeable_eduy=8 ) rest(median) level(95)  bootstrap save
prvalue, x(tradeable =1 eduyrs=19 tradeable_eduy =19 ) rest(median)   level(95)	bootstrap diff
prvalue, x(tradeable =1 eduyrs=19 tradeable_eduy =19 ) rest(median)   level(95)	bootstrap


*--------------------------------------------------------------
* 2.2.3 Comparison with a non-interactive model
*--------------------------------------------------------------
estimates restore est2

* Nontradable sector
* ----------------- 
prvalue, x(tradeable=0 eduyrs=8 ) rest(median) level(95) bootstrap save
prvalue, x(tradeable =0 eduyrs=19 ) rest(median)   level(95) bootstrap diff

* Tradable sector
* ----------------- 	
prvalue, x(tradeable=1 eduyrs=8 ) rest(median) level(95)  bootstrap save
prvalue, x(tradeable =1 eduyrs=19  ) rest(median)   level(95)	bootstrap diff


*--------------------------------------------------------------
* 2.2.4 Discussion of implications of Hiscox (2002) argument
*--------------------------------------------------------------
estimates restore est7

* Nontradable sector
* ----------------- 
prvalue, x(exporien=0 eduyrs=8 expor_eduy=0 impcomp=0  impcom_eduy=0 ) rest(median) level(95)  save
prvalue, x(exporien =0 eduyrs=19 expor_eduy=0 impcomp=0  impcom_eduy=0 ) rest(median)   level(95)  diff

* Export-oriented sector
* ----------------- 	
prvalue, x(exporien=1 eduyrs=8 expor_eduy=8 impcomp=0  impcom_eduy=0 ) rest(median) level(95)   save
prvalue, x(exporien=1 eduyrs=19 expor_eduy=19 impcomp=0  impcom_eduy=0) rest(median)   level(95)	 diff

* Import-competing sector
* ----------------- 	
prvalue, x(exporien=0 eduyrs=8 expor_eduy=0 impcomp=1  impcom_eduy=8 ) rest(median) level(95)   save
prvalue, x(exporien=0 eduyrs=19 expor_eduy=0 impcomp=1  impcom_eduy=19) rest(median)   level(95)	 diff




	
* -------------------------------------------------------
* 2.2.5 Correlation globalization and deindustrialization		
* -------------------------------------------------------
xi: ologit lmrisk tradeable tradeable_eduy  eduyrs  s1 hinctnt female age union uempla church primary secondary  wave04 i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
gen samplecorr1=e(sample)==1
xi: ologit lmrisk offshore2 off2_eduy   eduyrs  s1 hinctnt female age union uempla church primary secondary  wave04 i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
gen samplecorr2=e(sample)==1

corr tradeable  primary secondary servicesector if samplecorr1==1
corr offshore2   primary secondary servicesector  if samplecorr2==1

tab tradeable primary  if samplecorr1==1, col
tab tradeable secondary  if samplecorr1==1, col
tab tradeable servicesector  if samplecorr1==1, col

tab offshore2 primary  if samplecorr2==1, col
tab offshore2 secondary  if samplecorr2==1, col
tab offshore2 servicesector  if samplecorr2==1, col

* -------------------------------------------------------
* 2.2.6 Restricting Sample to type of sector
* -------------------------------------------------------
* labor market risk
* ------------------
set more off
est clear
local controls "eduyrs  s1 hinctnt female age union uempla church  wave04 "
quietly xi: ologit lmrisk tradeable tradeable_eduy  `controls' primary secondary i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit lmrisk offshore2 off2_eduy  `controls' primary secondary i.cntry if pdwrk==1   & secondary==1| uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit lmrisk exporien expor_eduy impcomp  impcom_eduy  `controls' primary secondary i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")

* Secondary Sector
quietly xi: ologit lmrisk tradeable tradeable_eduy  `controls'   i.cntry if pdwrk==1  & sector==2 | uempla==1  & sector==2 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit lmrisk offshore2 off2_eduy  `controls'  i.cntry if pdwrk==1  & sector==2 | uempla==1  & sector==2  [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit lmrisk exporien expor_eduy impcomp  impcom_eduy  `controls'  i.cntry if pdwrk==1  & sector==2 | uempla==1  & sector==2  [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")

* Tertiary Sector
quietly xi: ologit lmrisk tradeable tradeable_eduy  `controls'  i.cntry if pdwrk==1  & sector==3 | uempla==1  & sector==3 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit lmrisk offshore2 off2_eduy  `controls'  i.cntry if pdwrk==1  & sector==3 | uempla==1  & sector==3  [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit lmrisk exporien expor_eduy impcomp  impcom_eduy  `controls'  i.cntry if pdwrk==1  & sector==3 | uempla==1  & sector==3 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")

set linesize 255
esttab   est1 est4  est7 est2  est5 est8 est3 est6 est9, ///
	cells(b(star fmt(3) label(Coef.)) se(par label(Std. err.)))  ///
	stats(r2_p ll N bic, fmt(2 0 0) labels("Pseudo R2" "Log Pseudolikelihood" "Observations")) ///
	star(* 0.1 ** 0.05 *** 0.01) /// 
	legend varlabels(_cons Constant) /// 	
	drop(_I*) 
	
* Redistribution
* ------------------
set more off
est clear
local controls "eduyrs  s1 hinctnt female age union uempla church primary secondary  wave04 "
quietly xi: ologit redistribution tradeable tradeable_eduy  `controls' primary secondary  i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution offshore2 off2_eduy  `controls' primary secondary  i.cntry if pdwrk==1   & secondary==1| uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution exporien expor_eduy impcomp  impcom_eduy  `controls' primary secondary  i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")

* Secondary Sector
quietly xi: ologit redistribution tradeable tradeable_eduy  `controls'  i.cntry if pdwrk==1  & sector==2 | uempla==1  & sector==2 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution offshore2 off2_eduy  `controls'  i.cntry if pdwrk==1  & sector==2 | uempla==1  & sector==2  [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution exporien expor_eduy impcomp  impcom_eduy  `controls'  i.cntry if pdwrk==1  & sector==2 | uempla==1  & sector==2  [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")

* Tertiary Sector
quietly xi: ologit redistribution tradeable tradeable_eduy  `controls'  i.cntry if pdwrk==1  & sector==3 | uempla==1  & sector==3 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution offshore2 off2_eduy  `controls'  i.cntry if pdwrk==1  & sector==3 | uempla==1  & sector==3  [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution exporien expor_eduy impcomp  impcom_eduy  `controls'  i.cntry if pdwrk==1  & sector==3 | uempla==1  & sector==3 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")

set linesize 255
esttab   est1 est4  est7 est2  est5 est8 est3 est6 est9, ///
	cells(b(star fmt(3) label(Coef.)) se(par label(Std. err.)))  ///
	stats(r2_p ll N bic, fmt(2 0 0) labels("Pseudo R2" "Log Pseudolikelihood" "Observations")) ///
	star(* 0.1 ** 0.05 *** 0.01) /// 
	legend varlabels(_cons Constant) /// 	
	drop(_I*) 
	
* -------------------------------------------------------
* 2.2.7 Adding an interaction term between manufacturing and skills
* -------------------------------------------------------
gen secondary_eduyrs=secondary*eduyrs

* labor market risk
* ------------------
set more off
est clear
local controls "eduyrs  s1 hinctnt female age union uempla church primary secondary  wave04 "
quietly xi: ologit lmrisk tradeable tradeable_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit lmrisk offshore2 off2_eduy  `controls' i.cntry if pdwrk==1  | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit lmrisk exporien expor_eduy impcomp  impcom_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")

local controls "eduyrs  s1 hinctnt female age union uempla church primary secondary  wave04 "
quietly xi: ologit lmrisk tradeable tradeable_eduy  `controls' secondary_eduyrs i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit lmrisk offshore2 off2_eduy  `controls' secondary_eduyrs i.cntry if pdwrk==1  | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit lmrisk exporien expor_eduy impcomp  impcom_eduy  `controls' secondary_eduyrs i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")

set linesize 255
esttab   est1 est4  est2  est5  est3 est6, ///
	cells(b(star fmt(3) label(Coef.)) se(par label(Std. err.)))  ///
	stats(r2_p ll N bic, fmt(2 0 0) labels("Pseudo R2" "Log Pseudolikelihood" "Observations")) ///
	star(* 0.1 ** 0.05 *** 0.01) /// 
	legend varlabels(_cons Constant) /// 	
	drop(_I*) 

* redistribution
* ------------------
set more off
est clear
local controls "eduyrs  s1 hinctnt female age union uempla church primary secondary  wave04 "
quietly xi: ologit redistribution tradeable tradeable_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution offshore2 off2_eduy  `controls' i.cntry if pdwrk==1  | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution exporien expor_eduy impcomp  impcom_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")

local controls "eduyrs  s1 hinctnt female age union uempla church primary secondary  wave04 "
quietly xi: ologit redistribution tradeable tradeable_eduy  `controls' secondary_eduyrs i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution offshore2 off2_eduy  `controls' secondary_eduyrs i.cntry if pdwrk==1  | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution exporien expor_eduy impcomp  impcom_eduy  `controls' secondary_eduyrs i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")

set linesize 255
esttab   est1 est4  est2  est5  est3 est6, ///
	cells(b(star fmt(3) label(Coef.)) se(par label(Std. err.)))  ///
	stats(r2_p ll N bic, fmt(2 0 0) labels("Pseudo R2" "Log Pseudolikelihood" "Observations")) ///
	star(* 0.1 ** 0.05 *** 0.01) /// 
	legend varlabels(_cons Constant) /// 	
	drop(_I*) 
	


	
* ==============================================================================================================
*  3.	ROBUSTNESS CHECKS
* ==============================================================================================================
	
* -------------------------------------------------------
* 3.1 USING MULIT-LEVEL SPECIFICATIONS
* -------------------------------------------------------
* (also  footnote 23)

encode cntry, generate(cntry2)

* labor market risk
* ------------------
set more off
est clear
local controls "eduyrs  s1 hinctnt female age union uempla church primary secondary  wave04 "
quietly xi: ologit lmrisk tradeable tradeable_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit lmrisk offshore2 off2_eduy  `controls' i.cntry if pdwrk==1  | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit lmrisk exporien expor_eduy impcomp  impcom_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")

meologit lmrisk tradeable tradeable_eduy  eduyrs  s1 hinctnt female age union uempla church primary secondary  wave04  if pdwrk==1 | uempla==1 || cntry2: 
eststo, title("fn 33:multilvl DV: `e(depvar)' `e(cmd)' `e(model)'")
meologit lmrisk offshore2 off2_eduy eduyrs  eduyrs  s1 hinctnt female age union uempla church primary secondary  wave04 if pdwrk==1 | uempla==1 || cntry2:
eststo, title("fn 33:multilvl DV: `e(depvar)' `e(cmd)' `e(model)'")
meologit lmrisk exporien expor_eduy impcomp  impcom_eduy   eduyrs  s1 hinctnt female age union uempla church primary secondary  wave04  if pdwrk==1 | uempla==1 || cntry2:
eststo, title("fn 33:multilvl DV: `e(depvar)' `e(cmd)' `e(model)'")



/*

gllamm lmrisk tradeable tradeable_eduy  eduyrs  s1 hinctnt female age union uempla church primary secondary  wave04  if pdwrk==1 | uempla==1 , i(cntry2)  link(ologit) adapt trace nip(15)
eststo, title("fn 33:multilvl DV: `e(depvar)' `e(cmd)' `e(model)'")
gllamm lmrisk offshore2 off2_eduy eduyrs  eduyrs  s1 hinctnt female age union uempla church primary secondary  wave04 if pdwrk==1 | uempla==1 , i(cntry2)  link(ologit) adapt trace nip(15)
eststo, title("fn 33:multilvl DV: `e(depvar)' `e(cmd)' `e(model)'")
gllamm lmrisk exporien expor_eduy impcomp  impcom_eduy   eduyrs  s1 hinctnt female age union uempla church primary secondary  wave04  if pdwrk==1 | uempla==1 , i(cntry2)  link(ologit) adapt trace nip(15)
eststo, title("fn 33:multilvl DV: `e(depvar)' `e(cmd)' `e(model)'")

*/

set linesize 255
esttab   est1 est4  est2  est5  est3 est6, ///
	cells(b(star fmt(3) label(Coef.)) se(par label(Std. err.)))  ///
	stats(r2_p ll N bic, fmt(2 0 0) labels("Pseudo R2" "Log Pseudolikelihood" "Observations")) ///
	star(* 0.1 ** 0.05 *** 0.01) /// 
	legend varlabels(_cons Constant) /// 	
	drop(_I*) 

* redistribution
* ------------------
set more off
est clear
quietly xi: ologit redistribution tradeable tradeable_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution offshore2 off2_eduy  `controls' i.cntry if pdwrk==1  | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution exporien expor_eduy impcomp  impcom_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")

/*
meologit redistribution tradeable tradeable_eduy  eduyrs  s1 hinctnt female age union uempla church primary secondary  wave04  if pdwrk==1 | uempla==1  || cntry2: , intpoints(11) 
eststo, title("fn 33:multilvl DV: `e(depvar)' `e(cmd)' `e(model)'")
meologit redistribution offshore2 off2_eduy eduyrs  s1 hinctnt female age union uempla church primary secondary  wave04  if pdwrk==1 | uempla==1  || cntry2:
eststo, title("fn 33:multilvl DV: `e(depvar)' `e(cmd)' `e(model)'")
meologit redistribution exporien expor_eduy impcomp  impcom_eduy   eduyrs  s1 hinctnt female age union uempla church primary secondary  wave04  if pdwrk==1 | uempla==1  || cntry2:
eststo, title("fn 33:multilvl DV: `e(depvar)' `e(cmd)' `e(model)'")
*/

gllamm redistribution tradeable tradeable_eduy  eduyrs  s1 hinctnt female age union uempla church primary secondary  wave04  if pdwrk==1 | uempla==1 , i(cntry2)  link(ologit) adapt trace nip(15)
eststo, title("fn 33:multilvl DV: `e(depvar)' `e(cmd)' `e(model)'")
gllamm redistribution offshore2 off2_eduy eduyrs  s1 hinctnt female age union uempla church primary secondary  wave04  if pdwrk==1 | uempla==1 , i(cntry2)  link(ologit) adapt trace nip(15)
eststo, title("fn 33:multilvl DV: `e(depvar)' `e(cmd)' `e(model)'")
gllamm redistribution exporien expor_eduy impcomp  impcom_eduy   eduyrs  s1 hinctnt female age union uempla church primary secondary  wave04  if pdwrk==1 | uempla==1 , i(cntry2)  link(ologit) adapt trace nip(15)
eststo, title("fn 33:multilvl DV: `e(depvar)' `e(cmd)' `e(model)'")


set linesize 255
esttab   est1 est4  est2  est5  est3 est6, ///
	cells(b(star fmt(3) label(Coef.)) se(par label(Std. err.)))  ///
	stats(r2_p ll N bic, fmt(2 0 0) labels("Pseudo R2" "Log Pseudolikelihood" "Observations")) ///
	star(* 0.1 ** 0.05 *** 0.01) /// 
	legend varlabels(_cons Constant) /// 	
	drop(_I*) 
	
	
	
* -------------------------------------------------------	
* 3.2 REESTIMATING ALL MODELS WITHOUT COUNTRY DUMMIES
* -------------------------------------------------------

* labor market risk
* ------------------
set more off
est clear
local controls "eduyrs  s1 hinctnt female age union uempla church primary secondary  wave04 "
quietly xi: ologit lmrisk tradeable tradeable_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit lmrisk offshore2 off2_eduy  `controls' i.cntry if pdwrk==1  | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit lmrisk exporien expor_eduy impcomp  impcom_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")

local controls "eduyrs  s1 hinctnt female age union uempla church primary secondary  wave04 "
quietly xi: ologit lmrisk tradeable tradeable_eduy  `controls' if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit lmrisk offshore2 off2_eduy  `controls'  if pdwrk==1  | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit lmrisk exporien expor_eduy impcomp  impcom_eduy  `controls'  if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")

set linesize 255
esttab   est1 est4  est2  est5  est3 est6, ///
	cells(b(star fmt(3) label(Coef.)) se(par label(Std. err.)))  ///
	stats(r2_p ll N bic, fmt(2 0 0) labels("Pseudo R2" "Log Pseudolikelihood" "Observations")) ///
	star(* 0.1 ** 0.05 *** 0.01) /// 
	legend varlabels(_cons Constant) /// 	
	drop(_I*) 

* redistribution
* ------------------
set more off
est clear
local controls "eduyrs  s1 hinctnt female age union uempla church primary secondary  wave04 "
quietly xi: ologit redistribution tradeable tradeable_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution offshore2 off2_eduy  `controls' i.cntry if pdwrk==1  | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution exporien expor_eduy impcomp  impcom_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")

quietly xi: ologit redistribution tradeable tradeable_eduy  `controls'  if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution offshore2 off2_eduy  `controls'  if pdwrk==1  | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution exporien expor_eduy impcomp  impcom_eduy  `controls'  if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")

set linesize 255
esttab   est1 est4  est2  est5  est3 est6, ///
	cells(b(star fmt(3) label(Coef.)) se(par label(Std. err.)))  ///
	stats(r2_p ll N bic, fmt(2 0 0) labels("Pseudo R2" "Log Pseudolikelihood" "Observations")) ///
	star(* 0.1 ** 0.05 *** 0.01) /// 
	legend varlabels(_cons Constant) /// 	
	drop(_I*) 


* -------------------------------------------------------
* 3.3 USING EDUCATION LEVELS
* -------------------------------------------------------
* (also footnote 15)


* labor market risk
* ------------------
set more off
est clear
local controls "s1 hinctnt female age union uempla church primary secondary  wave04 "
quietly xi: ologit lmrisk tradeable tradeable_eduy eduyrs `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit lmrisk offshore2 off2_eduy eduyrs `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit lmrisk exporien expor_eduy impcomp  impcom_eduy eduyrs `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")

quietly xi: ologit lmrisk tradeable tradeable_edul edulvl  `controls'  i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("fn 26:edulvl DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit lmrisk offshore2 off2_edul edulvl  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("fn 26:edulvl DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit lmrisk exporien expor_edul impcomp  impcom_edul edulvl  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("fn 26:edulvl DV: `e(depvar)' `e(cmd)' `e(model)'")

set linesize 255
esttab   est1 est4  est2  est5  est3 est6, ///
	cells(b(star fmt(3) label(Coef.)) se(par label(Std. err.)))  ///
	stats(r2_p ll N bic, fmt(2 0 0) labels("Pseudo R2" "Log Pseudolikelihood" "Observations")) ///
	star(* 0.1 ** 0.05 *** 0.01) /// 
	legend varlabels(_cons Constant) /// 	
	drop(_I*) 

* redistribution
* ------------------
set more off
est clear
local controls " s1 hinctnt female age union uempla church primary secondary  wave04 "
quietly xi: ologit redistribution tradeable tradeable_eduy eduyrs   `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution offshore2 off2_eduy eduyrs   `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution exporien expor_eduy   impcomp  impcom_eduy eduyrs `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")

quietly xi: ologit redistribution tradeable tradeable_edul edulvl   `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("fn 26:edulvl DV: `e(depvar)' `e(cmd)' `e(model)'")
*Est5
quietly xi: ologit redistribution offshore2 off2_edul edulvl  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("fn 26:edulvl DV: `e(depvar)' `e(cmd)' `e(model)'")
*Est6
quietly xi: ologit redistribution exporien expor_edul edulvl  impcomp  impcom_edul edulvl  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("fn 26:edulvl `e(depvar)' `e(cmd)' `e(model)'")

set linesize 255
esttab   est1 est4  est2  est5  est3 est6, ///
	cells(b(star fmt(3) label(Coef.)) se(par label(Std. err.)))  ///
	stats(r2_p ll N bic, fmt(2 0 0) labels("Pseudo R2" "Log Pseudolikelihood" "Observations")) ///
	star(* 0.1 ** 0.05 *** 0.01) /// 
	legend varlabels(_cons Constant) /// 	
	drop(_I*) 
	

* -------------------------------------------------------
* 3.4 RESTRICTING THE SAMPLE TO RESPONDENTS IN THE ACTIVE WORK FORCE(paid work)
* -------------------------------------------------------
*  (see also footnote 11)

* labor market risk
* ------------------
set more off
est clear
local controls "eduyrs  s1 hinctnt female age union uempla church primary secondary  wave04 "
quietly xi: ologit lmrisk tradeable tradeable_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit lmrisk offshore2 off2_eduy  `controls' i.cntry if pdwrk==1  | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit lmrisk exporien expor_eduy impcomp  impcom_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")

quietly xi: ologit lmrisk tradeable tradeable_eduy  `controls'  i.cntry if pdwrk==1  [pweight=combinedweight] , cluster(cntry) robust
eststo, title("fn 19: unemployed DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit lmrisk offshore2 off2_eduy  `controls' i.cntry if pdwrk==1  [pweight=combinedweight] , cluster(cntry) robust
eststo, title("fn 19: unemployed DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit lmrisk exporien expor_eduy impcomp  impcom_eduy  `controls' i.cntry if pdwrk==1  [pweight=combinedweight] , cluster(cntry) robust
eststo, title("fn 19: unemployed DV: `e(depvar)' `e(cmd)' `e(model)'")

set linesize 255
esttab   est1 est4  est2  est5  est3 est6, ///
	cells(b(star fmt(3) label(Coef.)) se(par label(Std. err.)))  ///
	stats(r2_p ll N bic, fmt(2 0 0) labels("Pseudo R2" "Log Pseudolikelihood" "Observations")) ///
	star(* 0.1 ** 0.05 *** 0.01) /// 
	legend varlabels(_cons Constant) /// 	
	drop(_I*) 

* redistribution
* ------------------
set more off
est clear
local controls "eduyrs  s1 hinctnt female age union uempla church primary secondary  wave04 "
quietly xi: ologit redistribution tradeable tradeable_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution offshore2 off2_eduy  `controls' i.cntry if pdwrk==1  | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution exporien expor_eduy impcomp  impcom_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")

quietly xi: ologit redistribution tradeable tradeable_eduy  `controls' i.cntry if pdwrk==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("fn 18: unemployed DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution offshore2 off2_eduy  `controls' i.cntry if pdwrk==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("fn 18: unemployed DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution exporien expor_eduy impcomp  impcom_eduy  `controls' i.cntry if pdwrk==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("fn 18: unemployed DV: `e(depvar)' `e(cmd)' `e(model)'")

set linesize 255
esttab   est1 est4  est2  est5  est3 est6, ///
	cells(b(star fmt(3) label(Coef.)) se(par label(Std. err.)))  ///
	stats(r2_p ll N bic, fmt(2 0 0) labels("Pseudo R2" "Log Pseudolikelihood" "Observations")) ///
	star(* 0.1 ** 0.05 *** 0.01) /// 
	legend varlabels(_cons Constant) /// 	
	drop(_I*) 	
	
	
* -----------------------------------------------------------------------------------------------------------------------------
* 3.5 EMPLOYING A WIDER DEFINITION OF UNEMPLOYMENT(whether a person has ever been unemployed for more than 3 months): uemp3m 
* -----------------------------------------------------------------------------------------------------------------------------

* labor market risk
* ------------------
set more off
est clear
local controls "eduyrs  s1 hinctnt female age union uempla church primary secondary  wave04 "
quietly xi: ologit lmrisk tradeable tradeable_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit lmrisk offshore2 off2_eduy  `controls' i.cntry if pdwrk==1  | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit lmrisk exporien expor_eduy impcomp  impcom_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")

local controls "eduyrs  s1 hinctnt female age union uemp3m church primary secondary  wave04 "
quietly xi: ologit lmrisk tradeable tradeable_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit lmrisk offshore2 off2_eduy  `controls' i.cntry if pdwrk==1  | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit lmrisk exporien expor_eduy impcomp  impcom_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")

set linesize 255
esttab   est1 est4  est2  est5  est3 est6, ///
	cells(b(star fmt(3) label(Coef.)) se(par label(Std. err.)))  ///
	stats(r2_p ll N bic, fmt(2 0 0) labels("Pseudo R2" "Log Pseudolikelihood" "Observations")) ///
	star(* 0.1 ** 0.05 *** 0.01) /// 
	legend varlabels(_cons Constant) /// 	
	drop(_I*) 

* redistribution
* ------------------
set more off
est clear
local controls "eduyrs  s1 hinctnt female age union uempla church primary secondary  wave04 "
quietly xi: ologit redistribution tradeable tradeable_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution offshore2 off2_eduy  `controls' i.cntry if pdwrk==1  | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution exporien expor_eduy impcomp  impcom_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust

eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
local controls "eduyrs  s1 hinctnt female age union uemp3m church primary secondary  wave04 "
quietly xi: ologit redistribution tradeable tradeable_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution offshore2 off2_eduy  `controls' i.cntry if pdwrk==1  | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution exporien expor_eduy impcomp  impcom_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")


set linesize 255
esttab   est1 est4  est2  est5  est3 est6, ///
	cells(b(star fmt(3) label(Coef.)) se(par label(Std. err.)))  ///
	stats(r2_p ll N bic, fmt(2 0 0) labels("Pseudo R2" "Log Pseudolikelihood" "Observations")) ///
	star(* 0.1 ** 0.05 *** 0.01) /// 
	legend varlabels(_cons Constant) /// 	
	drop(_I*) 



* --------------------------------------------------------------------------------------------------------------- -------------------------------------------------------
* 3.6 CONTROLLING FOR RESPONDENTS` LABOR MARKET STATUS(such as whether they are in paid employment, disabled, a houseperson, or studying)
* --------------------------------------------------------------------------------------------------------------- -------------------------------------------------------
* education: edctn
* permanently sick or disabled: dsbld
* retired: rtrd
* housework, looking after children, others: hswrk
* Importance of religion in life: imprlg


* labor market risk
* ------------------
set more off
est clear
local controls "eduyrs  s1 hinctnt female age union uempla church primary secondary  wave04 "
quietly xi: ologit lmrisk tradeable tradeable_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit lmrisk offshore2 off2_eduy  `controls' i.cntry if pdwrk==1  | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit lmrisk exporien expor_eduy impcomp  impcom_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")

local controls "eduyrs  s1 hinctnt female age union uempla church primary secondary  wave04 edctn dsbld rtrd hswrk imprlg"
quietly xi: ologit lmrisk tradeable tradeable_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit lmrisk offshore2 off2_eduy  `controls' i.cntry if pdwrk==1  | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit lmrisk exporien expor_eduy impcomp  impcom_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")

set linesize 255
esttab   est1 est4  est2  est5  est3 est6, ///
	cells(b(star fmt(3) label(Coef.)) se(par label(Std. err.)))  ///
	stats(r2_p ll N bic, fmt(2 0 0) labels("Pseudo R2" "Log Pseudolikelihood" "Observations")) ///
	star(* 0.1 ** 0.05 *** 0.01) /// 
	legend varlabels(_cons Constant) /// 	
	drop(_I*) 

* redistribution
* ------------------
set more off
est clear
local controls "eduyrs  s1 hinctnt female age union uempla church primary secondary  wave04 "
quietly xi: ologit redistribution tradeable tradeable_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution offshore2 off2_eduy  `controls' i.cntry if pdwrk==1  | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution exporien expor_eduy impcomp  impcom_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust

eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
local controls "eduyrs  s1 hinctnt female age union uempla church primary secondary  wave04 edctn dsbld rtrd hswrk imprlg"
quietly xi: ologit redistribution tradeable tradeable_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution offshore2 off2_eduy  `controls' i.cntry if pdwrk==1  | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution exporien expor_eduy impcomp  impcom_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")


set linesize 255
esttab   est1 est4  est2  est5  est3 est6, ///
	cells(b(star fmt(3) label(Coef.)) se(par label(Std. err.)))  ///
	stats(r2_p ll N bic, fmt(2 0 0) labels("Pseudo R2" "Log Pseudolikelihood" "Observations")) ///
	star(* 0.1 ** 0.05 *** 0.01) /// 
	legend varlabels(_cons Constant) /// 	
	drop(_I*) 



* ------------------------------------------------------- ------------------------------------------------------- -------------------------------------------------------
* 3.7 CONTROLLING FOR EMPLOYMENT IN THE PUBLIC SECTOR(defined as individuals working in the public administration, defence, education, social work, or health)
* ------------------------------------------------------- ------------------------------------------------------- -------------------------------------------------------
* the following industries are defined as public sector: Public adm and defence,compulsory socia, Education, Health and social work 
gen public=nace_both==75
replace public=1 if nace_both ==80
replace public=1 if nace_both ==85
replace public=. if nace_both ==.

* labor market risk
* ------------------
set more off
est clear
local controls "eduyrs  s1 hinctnt female age union uempla church primary secondary  wave04 "
quietly xi: ologit lmrisk tradeable tradeable_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit lmrisk offshore2 off2_eduy  `controls' i.cntry if pdwrk==1  | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit lmrisk exporien expor_eduy impcomp  impcom_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")

local controls "eduyrs  s1 hinctnt female age union uempla church primary secondary  wave04 public"
quietly xi: ologit lmrisk tradeable tradeable_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit lmrisk offshore2 off2_eduy  `controls' i.cntry if pdwrk==1  | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit lmrisk exporien expor_eduy impcomp  impcom_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")

set linesize 255
esttab   est1 est4  est2  est5  est3 est6, ///
	cells(b(star fmt(3) label(Coef.)) se(par label(Std. err.)))  ///
	stats(r2_p ll N bic, fmt(2 0 0) labels("Pseudo R2" "Log Pseudolikelihood" "Observations")) ///
	star(* 0.1 ** 0.05 *** 0.01) /// 
	legend varlabels(_cons Constant) /// 	
	drop(_I*) 

* redistribution
* ------------------
set more off
est clear
local controls "eduyrs  s1 hinctnt female age union uempla church primary secondary  wave04 "
quietly xi: ologit redistribution tradeable tradeable_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution offshore2 off2_eduy  `controls' i.cntry if pdwrk==1  | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution exporien expor_eduy impcomp  impcom_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust

eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
local controls "eduyrs  s1 hinctnt female age union uempla church primary secondary  wave04 public"
quietly xi: ologit redistribution tradeable tradeable_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution offshore2 off2_eduy  `controls' i.cntry if pdwrk==1  | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution exporien expor_eduy impcomp  impcom_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")


set linesize 255
esttab   est1 est4  est2  est5  est3 est6, ///
	cells(b(star fmt(3) label(Coef.)) se(par label(Std. err.)))  ///
	stats(r2_p ll N bic, fmt(2 0 0) labels("Pseudo R2" "Log Pseudolikelihood" "Observations")) ///
	star(* 0.1 ** 0.05 *** 0.01) /// 
	legend varlabels(_cons Constant) /// 	
	drop(_I*) 


	
	
* ------------------------------------------------------- ------------------------------------------------------- -------------------------------------------------------
* 3.8 REPLICATION OF REHM ANALYSIS(table 2, model 7, in Rehm 2009)
* ------------------------------------------------------- ------------------------------------------------------- -------------------------------------------------------

version 9.2
clear
set mem 250m
set more off

quietly do "Rehm replication/01_trade.do" 
quietly do "Rehm replication/02_othervariables.do"



* Replicate Rehm analysis
*-------------------------

cap drop sample
gen sample=employee
replace sample=0 if (cIUR_t_1d==. | cOUR_t_1d==.)
replace sample=0 if redi==.
replace sample=0 if (income==. | female==. | educdg==. | age==. | union_ever==. | emp_self==. | church==.)

cap drop CCODE
decode ccode, gen(CCODE)

*------------------
* 3.8.1 Cramérs V:
*------------------
tabulate isco88_3d nace_2d  if sample, V nof

* Table 1:
preserve
	gen r_=redi
	collapse (count) r_ if sample==1, by(ccode redi)
	*bys ccode: egen p_=pc(r_), prop
	bys ccode: egen p_=pc(r_)
	reshape wide r_ p_, i(ccode) j(redi)
	order ccode p* r* 
	sort ccode
	tempfile p
	save `p'
restore

preserve
	gen mean=redi
	gen sd=redi
	gen N=redi
	collapse (count) N (mean) mean (sd) sd if sample==1 [w=weight], by(ccode)
	sort ccode
	merge 1:m ccode using `p'
	tab _merge
	drop _merge
	order ccode mean sd N p* r* 
	sort mean
	browse
restore
*-------------------------
* 3.8.2 AIC / BIC
*-------------------------
* "Given two models fitted on the same data, the model with the smaller value of the information criterion is considered to be better." (http://www.stata.com/help.cgi?bic_note)
reg nace_2d isco88_3d [pw=weight] if sample, cluster(ccode) robust
gen SAMPLE=e(sample)
foreach v in isco88_1d isco88_2d isco88_3d nace_1d nace_2d {
	quietly xi: oprobit redi  i.`v' i.ccode i.year [pw=weight] if sample==1 & SAMPLE==1, cluster(ccode) robust
	estimates store `v'
	di "`v'"
	* BIC:
	*di [(-2)*`e(ll)']+[`e(df_m)'*ln(`e(N)')]
	* AIC:
	*di [(-2)*`e(ll)']+[2*`e(df_m)']
	estat ic
	fitstat, saving(`=substr("`v'",-4,4)') bic
}


***********************
* REDISTRIBUTION
***********************


* regressions, edulvl ******* REPLICATION REHM ********
* Table 2:
set more off
est clear
local controls " cOUR_t_1d s1 cIUR_t_1d  rca income female age union_ever  church"
quietly xi: oprobit redi tsrehm  edulvl `controls'  i.CCODE i.year [pw=weight] if sample==1 , cluster(ccode) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: oprobit redi tsrehm tsrehm_edul edulvl `controls'  i.CCODE i.year [pw=weight] if sample==1 , cluster(ccode) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")

*--------------------------------------------
*3.8.3 Table 3: Replication of Rehm analysis 
*--------------------------------------------
set linesize 255
esttab est1  est2 , ///
	cells(b(star fmt(3) label(Coef.)) se(par label(Std. err.)))  ///
	stats(r2_p ll N, fmt(2 0 0) labels("Pseudo R2" "Log Pseudolikelihood" "Observations")) ///
	star(* 0.10 ** 0.05 *** 0.01) /// 
	legend varlabels(_cons Constant) /// 	
	drop(_I*) 
		
		
	

* ------------------------------------------------------- ------------------------------------------------------- -------------------------------------------------------
* 3.9 ROBUSTNESS TO INCLUDING IDEOLOGY
* ------------------------------------------------------- ------------------------------------------------------- -------------------------------------------------------
* -------------------------------
* Use Main Dataset
* -------------------------------
use Data.Glob_PSRM.FINAL.FULL.dta, clear


*** 
*   Results are robust to controlling for ideology (left-right continuum)
* (see also footnote 22)

* labor market risk
*--------------------
set more off
est clear
local controls "eduyrs   hinctnt s1  female age union uempla church primary secondary  wave04 "
quietly xi: ologit lmrisk tradeable tradeable_eduy  `controls'  i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit lmrisk offshore2 off2_eduy  `controls' i.cntry if pdwrk==1  | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit lmrisk exporien expor_eduy impcomp  impcom_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")

quietly xi: ologit lmrisk tradeable tradeable_eduy  `controls' lrscale i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit lmrisk offshore2 off2_eduy  `controls' lrscale i.cntry if pdwrk==1  | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit lmrisk exporien expor_eduy impcomp  impcom_eduy  `controls' lrscale i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")

set linesize 255
esttab   est1 est4  est2  est5  est3 est6, ///
	cells(b(star fmt(3) label(Coef.)) se(par label(Std. err.)))  ///
	stats(r2_p ll N bic, fmt(2 0 0) labels("Pseudo R2" "Log Pseudolikelihood" "Observations")) ///
	star(* 0.1 ** 0.05 *** 0.01) /// 
	legend varlabels(_cons Constant) /// 	
	drop(_I*) 

* redistribution
*-----------------
set more off

local controls "eduyrs  hinctnt s1  female age union uempla church primary secondary  wave04 "
quietly xi: ologit redistribution tradeable tradeable_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution offshore2 off2_eduy  `controls' i.cntry if pdwrk==1  | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution exporien expor_eduy impcomp  impcom_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")

quietly xi: ologit redistribution tradeable tradeable_eduy  `controls' lrscale i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution offshore2 off2_eduy  `controls' lrscale i.cntry if pdwrk==1  | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution exporien expor_eduy impcomp  impcom_eduy  `controls' lrscale i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")

set linesize 255
esttab   est7 est10  est8  est11  est9 est12, ///
	cells(b(star fmt(3) label(Coef.)) se(par label(Std. err.)))  ///
	stats(r2_p ll N bic, fmt(2 0 0) labels("Pseudo R2" "Log Pseudolikelihood" "Observations")) ///
	star(* 0.1 ** 0.05 *** 0.01) /// 
	legend varlabels(_cons Constant) /// 	
	drop(_I*) 	
	
*-----------------------------------------------
* 3.9.1 Table 4: Robustness to including ideology
* ----------------------------------------------
set linesize 255
esttab   est4 est5 est6 est10  est11   est12, ///
	cells(b(star fmt(3) label(Coef.)) se(par label(Std. err.)))  ///
	stats(r2_p ll N bic, fmt(2 0 0) labels("Pseudo R2" "Log Pseudolikelihood" "Observations")) ///
	star(* 0.1 ** 0.05 *** 0.01) /// 
	legend varlabels(_cons Constant) /// 	
	drop(_I*)	
	

	
*** 
*    Results are robust to controlling for ideology (left-right continuum) and additional ideological variables

* labor market risk
*-------------------
set more off
est clear
local controls "eduyrs   hinctnt s1  female age union uempla church primary secondary  wave04 "
quietly xi: ologit lmrisk tradeable tradeable_eduy  `controls'  i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit lmrisk offshore2 off2_eduy  `controls' i.cntry if pdwrk==1  | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit lmrisk exporien expor_eduy impcomp  impcom_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")

quietly xi: ologit lmrisk tradeable tradeable_eduy  `controls' lrscale trstun imwbcnt ipeqopt impenv i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit lmrisk offshore2 off2_eduy  `controls' lrscale trstun imwbcnt ipeqopt impenv i.cntry if pdwrk==1  | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit lmrisk exporien expor_eduy impcomp  impcom_eduy `controls' lrscale trstun imwbcnt ipeqopt impenv i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")

set linesize 255
esttab   est1 est4  est2  est5  est3 est6, ///
	cells(b(star fmt(3) label(Coef.)) se(par label(Std. err.)))  ///
	stats(r2_p ll N bic, fmt(2 0 0) labels("Pseudo R2" "Log Pseudolikelihood" "Observations")) ///
	star(* 0.1 ** 0.05 *** 0.01) /// 
	legend varlabels(_cons Constant) /// 	
	drop(_I*) 

* redistribution
*----------------
set more off
est clear
local controls "eduyrs  hinctnt s1  female age union uempla church primary secondary  wave04 "
quietly xi: ologit redistribution tradeable tradeable_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution offshore2 off2_eduy  `controls' i.cntry if pdwrk==1  | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution exporien expor_eduy impcomp  impcom_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")

quietly xi: ologit redistribution tradeable tradeable_eduy  `controls' lrscale trstun imwbcnt ipeqopt impenv i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution offshore2 off2_eduy  `controls' lrscale trstun imwbcnt ipeqopt impenv i.cntry if pdwrk==1  | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution exporien expor_eduy impcomp  impcom_eduy  `controls' lrscale trstun imwbcnt ipeqopt impenv i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")


set linesize 255
esttab   est1 est4  est2  est5  est3 est6, ///
	cells(b(star fmt(3) label(Coef.)) se(par label(Std. err.)))  ///
	stats(r2_p ll N bic, fmt(2 0 0) labels("Pseudo R2" "Log Pseudolikelihood" "Observations")) ///
	star(* 0.1 ** 0.05 *** 0.01) /// 
	legend varlabels(_cons Constant) /// 	
	drop(_I*) 	
	



		
		

* ==============================================================================================================	
* ==============================================================================================================
* 4. APPENDIX: DESCRIPTIVE STATISTICS
* ==============================================================================================================
* ==============================================================================================================


local controls "eduyrs  s1 hinctnt female age union uempla church primary secondary  wave04 "
quietly xi: ologit lmrisk tradeable   `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
gen samplelmrisk1=e(sample)==1	
quietly xi: ologit lmrisk offshore2   `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
gen samplelmrisk2=e(sample)==1
quietly xi: ologit redistribution tradeable   `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
gen samplered1=e(sample)==1	
quietly xi: ologit redistribution offshore2   `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
gen samplered2=e(sample)==1	

sum lmrisk redistribution	///
	tradeable offshore2 exporien  impcomp ///
	eduyrs  s1 hinctnt female age union uempla church primary secondary  wave04 lrscale ///
	if samplelmrisk1==1 | samplelmrisk2 ==1 | samplered1==1 | samplered2==1
	
	

	

* ==============================================================================================================
* ==============================================================================================================
* 5. FOOTNOTES
* ==============================================================================================================
* ==============================================================================================================

		
****** FOOTNOTE 10
* The results are robust to using waves I-IV	

use ess_wavesI-V.dta, clear

gen combinedweight=PWEIGHT*dweight
replace combinedweight=DWEIGHT*pweight if combinedweight==.
tab essround, gen(wave)
rename gender female
gen church=rlgat*(-1)+7
label var church "church attendance"

gen sectortype=3
replace sectortype=2 if nacer1<50
replace sectortype=1 if nacer1<15
replace sectortype=2 if nacer11<50
replace sectortype=1 if nacer11<15
replace sectortype=2 if nacer2<33
replace sectortype=1 if nacer2<10
replace sectortype=. if nacer1==. & nacer11==. & nacer2==.
label define sectortype 1 "Primary Sector" 2 "Secondary Sector" 3 "Tertiary Sector"
label val sectortype sectortype
label var sectortype "Sector"
gen primary=sectortype==1
replace primary=. if sectortype==.
gen secondary=sectortype==2
replace secondary =. if sectortype==.
gen servicesector=sectortype==3
replace servicesector =. if sectortype==.

gen tradeable=tradeex>0.000000001
replace tradeable=. if tradeex==.
replace tradeable=1 if nacer1==1 | nacer11==1 | nacer2==1
replace tradeable=1 if nacer1>19 & nacer1<40 & tradeex==.
replace tradeable=1 if nacer11>19 & nacer11<40 & tradeex==.
gen tradeable_eduy=tradeable*eduyrs

gen off2_eduy=offshore2*eduyrs

set more off
est clear
local controls "eduyrs  skillspec inc female age union uempla church  secondary primary wave2 wave3 wave4 wave5"
quietly xi: ologit redistrib   `controls'  i.cntry  if pdwrk==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")


local RHS "tradeable  offshore2 "
foreach rhs of local RHS {
	quietly xi: ologit redistrib `rhs' `controls' i.cntry if pdwrk==1  [pweight=combinedweight] , cluster(cntry) robust
	eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
}
quietly xi: ologit redistrib tradeable tradeable_eduy  `controls'  i.cntry if pdwrk==1  [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistrib offshore2 off2_eduy  `controls' i.cntry if pdwrk==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")

set linesize 255
esttab   est2  est4  est3  est5 , ///
	cells(b(star fmt(3) label(Coef.)) se(par label(Std. err.)))  ///
	stats(r2_p ll N bic, fmt(2 0 0) labels("Pseudo R2" "Log Pseudolikelihood" "Observations")) ///
	star(* 0.1 ** 0.05 *** 0.01) /// 
	legend varlabels(_cons Constant) /// 	
	drop(_I*) 

* -------------------------------
* Use Main Dataset
* -------------------------------
use Data.Glob_PSRM.FINAL.FULL.dta, clear

	
***** FOOTNOTE 11
* The results are robust to restricting the sample only to those in paid work.	
* see robustness section



***** FOOTNOTE 12
*    The results are robust to a binary recoding of the variable on labor market risk.
gen lmrisk2=laborrisk>5
replace lmrisk2=. if laborrisk==.

set more off
est clear
local controls "eduyrs  s1 hinctnt female age union uempla church primary secondary  wave04 "
quietly xi: ologit lmrisk tradeable tradeable_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit lmrisk offshore2 off2_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit lmrisk exporien expor_eduy impcomp  impcom_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")

* Binary Labor Market risk recoding
quietly xi: logit lmrisk2 tradeable tradeable_eduy  `controls'  i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("fn 18: binary risk DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: logit lmrisk2 offshore2 off2_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("fn 18: binary risk DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: logit lmrisk2 exporien expor_eduy impcomp  impcom_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("fn 18: binary riskk DV: `e(depvar)' `e(cmd)' `e(model)'")

set linesize 255
esttab   est1 est4  est2  est5  est3 est6, ///
	cells(b(star fmt(3) label(Coef.)) se(par label(Std. err.)))  ///
	stats(r2_p ll N bic, fmt(2 0 0) labels("Pseudo R2" "Log Pseudolikelihood" "Observations")) ///
	star(* 0.1 ** 0.05 *** 0.01) /// 
	legend varlabels(_cons Constant) /// 	
	drop(_I*) 
	
	

***** FOOTNOTE 14
* Results are generally robust to use an alternative variable for policy preferences (economic protection)
* ginveco: "The less government intervenes in economy, the better for country"
set more off
est clear
local controls "eduyrs  s1 hinctnt female age union uempla church primary secondary  wave04 "
quietly xi: ologit redistribution tradeable tradeable_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution offshore2 off2_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution exporien expor_eduy impcomp  impcom_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")

* Binary Labor Market risk recoding
quietly xi: ologit ginveco tradeable tradeable_eduy  `controls'  i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("fn 23: gov intervention DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit ginveco offshore2 off2_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("fn 23: gov intervention DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit ginveco exporien expor_eduy impcomp  impcom_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("fn 23: gov intervention DV: `e(depvar)' `e(cmd)' `e(model)'")

set linesize 255
esttab   est1 est4  est2  est5  est3 est6, ///
	cells(b(star fmt(3) label(Coef.)) se(par label(Std. err.)))  ///
	stats(r2_p ll N bic, fmt(2 0 0) labels("Pseudo R2" "Log Pseudolikelihood" "Observations")) ///
	star(* 0.1 ** 0.05 *** 0.01) /// 
	legend varlabels(_cons Constant) /// 	
	drop(_I*) 


	
*** FOOTNOTE 15
*    The results are robust to using education levels.
* see robustness section



*** FOOTNOTE 16
* The results are robust to using a continuous measure of trade exposure.	
gen tradeex_eduy=tradeexposure*eduyrs

* labor market risk
set more off
est clear
local controls "eduyrs  s1 hinctnt female age union uempla church primary secondary  wave04 "
quietly xi: ologit lmrisk tradeable tradeable_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit lmrisk tradeexpos tradeex_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("fn 28:tradeexposure DV: `e(depvar)' `e(cmd)' `e(model)'")

* redistribution
local controls "eduyrs  s1 hinctnt female age union uempla church primary secondary  wave04 "
quietly xi: ologit redistribution tradeable tradeable_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution tradeexpos tradeex_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("fn 28:tradeexposure DV: `e(depvar)' `e(cmd)' `e(model)'")

set linesize 255
esttab   est1 est2  est3  est4, ///
	cells(b(star fmt(3) label(Coef.)) se(par label(Std. err.)))  ///
	stats(r2_p ll N bic, fmt(2 0 0) labels("Pseudo R2" "Log Pseudolikelihood" "Observations")) ///
	star(* 0.1 ** 0.05 *** 0.01) /// 
	legend varlabels(_cons Constant) /// 	
	drop(_I*) 


*** FOOTNOTE 18
*    Results are robust to using different codings of the offshoreability-variable

gen off23=offshore4>1
replace off23=. if offshore4==.
gen off23_eduy=off23*eduyrs
gen offshore4_eduy=offshore4*eduyrs

* labor market risk
set more off
est clear
local controls "eduyrs  s1 hinctnt female age union uempla church primary secondary  wave04 "
quietly xi: ologit lmrisk offshore2 off2_eduy  `controls' i.cntry if pdwrk==1  | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit lmrisk off23 off23_eduy  `controls' i.cntry if pdwrk==1  | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit lmrisk offshore4 offshore4_eduy  `controls' i.cntry if pdwrk==1  | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit lmrisk offshore offshore_eduy  `controls' i.cntry if pdwrk==1  | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")


* redistribution
quietly xi: ologit redistribution offshore2 off2_eduy  `controls' i.cntry if pdwrk==1  | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution off23 off23_eduy  `controls' i.cntry if pdwrk==1  | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution offshore4 offshore4_eduy  `controls' i.cntry if pdwrk==1  | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution offshore offshore_eduy  `controls' i.cntry if pdwrk==1  | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")

set linesize 255
esttab   est1 est2 est3 est4 est5 est6 est7 est8, ///
	cells(b(star fmt(3) label(Coef.)) se(par label(Std. err.)))  ///
	stats(r2_p ll N bic, fmt(2 0 0) labels("Pseudo R2" "Log Pseudolikelihood" "Observations")) ///
	star(* 0.1 ** 0.05 *** 0.01) /// 
	legend varlabels(_cons Constant) /// 	
	drop(_I*) 	
	
	
		
*** FOOTNOTE 20
* The results are laregly robust to not including income.	

* labor market risk
set more off
est clear
local controls "eduyrs  s1  female age union uempla church primary secondary  wave04 "
quietly xi: ologit lmrisk tradeable tradeable_eduy  `controls' hinctnt i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit lmrisk offshore2 off2_eduy  `controls' hinctnt i.cntry if pdwrk==1  | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit lmrisk exporien expor_eduy impcomp  impcom_eduy  `controls' hinctnt i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")

quietly xi: ologit lmrisk tradeable tradeable_eduy  `controls'  i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit lmrisk offshore2 off2_eduy  `controls' i.cntry if pdwrk==1  | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit lmrisk exporien expor_eduy impcomp  impcom_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")

set linesize 255
esttab   est1 est4  est2  est5  est3 est6, ///
	cells(b(star fmt(3) label(Coef.)) se(par label(Std. err.)))  ///
	stats(r2_p ll N bic, fmt(2 0 0) labels("Pseudo R2" "Log Pseudolikelihood" "Observations")) ///
	star(* 0.1 ** 0.05 *** 0.01) /// 
	legend varlabels(_cons Constant) /// 	
	drop(_I*) 

* redistribution
set more off
est clear
local controls "eduyrs  s1  female age union uempla church primary secondary  wave04 "
quietly xi: ologit redistribution tradeable tradeable_eduy  `controls' hinctnt i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution offshore2 off2_eduy  `controls' hinctnt i.cntry if pdwrk==1  | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution exporien expor_eduy impcomp  impcom_eduy  `controls' hinctnt i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")

quietly xi: ologit redistribution tradeable tradeable_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution offshore2 off2_eduy  `controls' i.cntry if pdwrk==1  | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution exporien expor_eduy impcomp  impcom_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")


set linesize 255
esttab   est1 est4  est2  est5  est3 est6, ///
	cells(b(star fmt(3) label(Coef.)) se(par label(Std. err.)))  ///
	stats(r2_p ll N bic, fmt(2 0 0) labels("Pseudo R2" "Log Pseudolikelihood" "Observations")) ///
	star(* 0.1 ** 0.05 *** 0.01) /// 
	legend varlabels(_cons Constant) /// 	
	drop(_I*) 	

	

*** FOOTNOTE 23
*   Results are robust to using multi-level techniques instead.

* see above (robustness checks)
	
	
*** FOOTNOTE 28
*   Results are robust to restricting sample to respondents who answered question on labor market risk
set more off
est clear
local controls "eduyrs  s1 hinctnt female age union uempla church primary secondary  wave04 "
quietly xi: ologit redistribution tradeable tradeable_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution offshore2 off2_eduy  `controls' i.cntry if pdwrk==1  | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution exporien expor_eduy impcomp  impcom_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")

quietly xi: ologit redistribution tradeable tradeable_eduy  `controls'  i.cntry if pdwrk==1 & lmrisk<3 | uempla==1 & lmrisk<3 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution offshore2 off2_eduy  `controls' i.cntry if pdwrk==1 & lmrisk<3 | uempla==1 & lmrisk<3  [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution exporien expor_eduy impcomp  impcom_eduy  `controls' i.cntry if pdwrk==1 & lmrisk<3 | uempla==1 & lmrisk<3  [pweight=combinedweight], cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
	
set linesize 255
esttab   est1 est4  est2  est5  est3 est6, ///
	cells(b(star fmt(3) label(Coef.)) se(par label(Std. err.)))  ///
	stats(r2_p ll N bic, fmt(2 0 0) labels("Pseudo R2" "Log Pseudolikelihood" "Observations")) ///
	star(* 0.1 ** 0.05 *** 0.01) /// 
	legend varlabels(_cons Constant) /// 	
	drop(_I*) 	
	
		


*** FOOTNOTE 29
*   Results get stronger when perceived labor market risk is included as control variable	
set more off
est clear
local controls "eduyrs  s1 hinctnt female age union uempla church primary secondary  wave04 "
quietly xi: ologit redistribution tradeable tradeable_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution offshore2 off2_eduy  `controls' i.cntry if pdwrk==1  | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution exporien expor_eduy impcomp  impcom_eduy  `controls' i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")

quietly xi: ologit redistribution tradeable tradeable_eduy  `controls' lmrisk i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution offshore2 off2_eduy  `controls' lmrisk i.cntry if pdwrk==1  | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
quietly xi: ologit redistribution exporien expor_eduy impcomp  impcom_eduy  `controls' lmrisk i.cntry if pdwrk==1 | uempla==1 [pweight=combinedweight] , cluster(cntry) robust
eststo, title("DV: `e(depvar)' `e(cmd)' `e(model)'")
	
set linesize 255
esttab   est1 est4  est2  est5  est3 est6, ///
	cells(b(star fmt(3) label(Coef.)) se(par label(Std. err.)))  ///
	stats(r2_p ll N bic, fmt(2 0 0) labels("Pseudo R2" "Log Pseudolikelihood" "Observations")) ///
	star(* 0.1 ** 0.05 *** 0.01) /// 
	legend varlabels(_cons Constant) /// 	
	drop(_I*) 		
	
	
log close
	
	
	
	

