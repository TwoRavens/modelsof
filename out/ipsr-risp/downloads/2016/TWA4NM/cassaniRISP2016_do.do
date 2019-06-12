
********************************************************************************

**************************************************************** Analysis (RISP)

********************************************************************************


*****************
****** Guidelines
* 'Main' section of the syntax replicates analyses presented in tables 2-4 of the article
* 'Others' section of the syntax replicates the robustness checks performed (cf. table 1 and online appendix)
* 'dis' commands compute short- and long-run regime effects based on regression estimates
* 'test' commands assess the significance of the difference between the effect of electoral vs full authoritarian subtypes
* please refer to the 'empirical analysis' section of the article for further information and details




. vers 13.1

. use cassaniRISP2016_tscs, clear

. xtset cow year



*******************
************** Main
*******************

***** HP1: EA vs FA

*** Spending (gov)
. reg s3.spendhealgov l3.spendhealgov s3.elaut_ac8 l3.elaut_ac8 s3.dem_ac8 l3.dem_ac8 l3.gdppc_log l3.gdpgr l3.odapc l3.natresfx l3.poptot_log l3.popurb l3.ethnic l3.dur_ac8 l3.commrule if other1==0, vce(robust)
. dis _b[s3.elaut_ac8]
. dis 1-(abs(_b[l3.spendhealgov]))
. dis -( _b[l3.elaut_ac8] / _b[l3.spendhealgov] )

*** Spending (gdp)
. reg s3.spendhealgdp l3.spendhealgdp s3.elaut_ac8 l3.elaut_ac8 s3.dem_ac8 l3.dem_ac8 l3.gdppc_log l3.gdpgr l3.odapc l3.natresfx l3.poptot_log l3.popurb l3.ethnic l3.dur_ac8 l3.commrule if other1==0, vce(robust)
. dis _b[s3.elaut_ac8]
. dis 1-(abs(_b[l3.spendhealgdp]))
. dis -( _b[l3.elaut_ac8] / _b[l3.spendhealgdp] )

*** Infant mortality
. reg s3.mortu1 l3.mortu1 s3.elaut_ac8 l3.elaut_ac8 s3.dem_ac8 l3.dem_ac8 l3.gdppc_log l3.gdpgr l3.odapc l3.natresfx l3.poptot_log l3.popurb l3.ethnic l3.dur_ac8 l3.commrule if other1==0, vce(robust)
. dis _b[s3.elaut_ac8]
. dis 1-(abs(_b[l3.mortu1]))
. dis -( _b[l3.elaut_ac8] / _b[l3.mortu1] )

*** 2ary enrolment
. reg s3.enr2tot l3.enr2tot s3.elaut_ac8 l3.elaut_ac8 s3.dem_ac8 l3.dem_ac8 l3.gdppc_log l3.gdpgr l3.odapc l3.natresfx l3.poptot_log l3.popurb l3.ethnic l3.dur_ac8 l3.commrule if other1==0, vce(robust)
. dis _b[s3.elaut_ac8]
. dis 1-(abs(_b[l3.enr2tot]))
. dis -( _b[l3.elaut_ac8] / _b[l3.enr2tot] )


***** HP2: EA vs DEM

*** Spending (gov)
. reg s3.spendhealgov l3.spendhealgov s3.elaut_ac8 l3.elaut_ac8 s3.fullaut l3.fullaut l3.gdppc_log l3.gdpgr l3.odapc l3.natresfx l3.poptot_log l3.popurb l3.ethnic l3.dur_ac8 l3.commrule if other1==0, vce(robust)
. dis _b[s3.elaut_ac8]
. dis 1-(abs(_b[l3.spendhealgov]))
. dis -( _b[l3.elaut_ac8] / _b[l3.spendhealgov] )

*** Spending (gdp)
. reg s3.spendhealgdp l3.spendhealgdp s3.elaut_ac8 l3.elaut_ac8 s3.fullaut l3.fullaut l3.gdppc_log l3.gdpgr l3.odapc l3.natresfx l3.poptot_log l3.popurb l3.ethnic l3.dur_ac8 l3.commrule if other1==0, vce(robust)
. dis _b[s3.elaut_ac8]
. dis 1-(abs(_b[l3.spendhealgdp]))
. dis -( _b[l3.elaut_ac8] / _b[l3.spendhealgdp] )

*** Infant mortality
. reg s3.mortu1 l3.mortu1 s3.elaut_ac8 l3.elaut_ac8 s3.fullaut l3.fullaut l3.gdppc_log l3.gdpgr l3.odapc l3.natresfx l3.poptot_log l3.popurb l3.ethnic l3.dur_ac8 l3.commrule if other1==0, vce(robust)
. dis _b[s3.elaut_ac8]
. dis 1-(abs(_b[l3.mortu1]))
. dis -( _b[l3.elaut_ac8] / _b[l3.mortu1] )

*** 2ary enrolment
. reg s3.enr2tot l3.enr2tot s3.elaut_ac8 l3.elaut_ac8 s3.fullaut l3.fullaut l3.gdppc_log l3.gdpgr l3.odapc l3.natresfx l3.poptot_log l3.popurb l3.ethnic l3.dur_ac8 l3.commrule if other1==0, vce(robust)
. dis _b[s3.elaut_ac8]
. dis 1-(abs(_b[l3.enr2tot]))
. dis -( _b[l3.elaut_ac8] / _b[l3.enr2tot] )


***** HP3-5: EA vs Milit/Single-p/Heredit FA

*** Spending (gov)
. reg s3.spendhealgov l3.spendhealgov s3.elaut_ac8 l3.elaut_ac8 s3.singlep l3.singlep s3.hereditary l3.hereditary s3.dem_ac8 l3.dem_ac8 l3.gdppc_log l3.gdpgr l3.odapc l3.natresfx l3.poptot_log l3.popurb l3.ethnic l3.dur_ac8 l3.commrule if other2==0, vce(robust)
. test s3.elaut_ac8 = s3.singlep
. test l3.elaut_ac8 = l3.singlep
. test s3.elaut_ac8 = s3.hereditary
. test l3.elaut_ac8 = l3.hereditary

*** Spending (gdp)
. reg s3.spendhealgdp l3.spendhealgdp s3.elaut_ac8 l3.elaut_ac8 s3.singlep l3.singlep s3.hereditary l3.hereditary s3.dem_ac8 l3.dem_ac8 l3.gdppc_log l3.gdpgr l3.odapc l3.natresfx l3.poptot_log l3.popurb l3.ethnic l3.dur_ac8 l3.commrule if other2==0, vce(robust)
. test s3.elaut_ac8 = s3.singlep
. test l3.elaut_ac8 = l3.singlep
. test s3.elaut_ac8 = s3.hereditary
. test l3.elaut_ac8 = l3.hereditary

*** Infant mortality
. reg s3.mortu1 l3.mortu1 s3.elaut_ac8 l3.elaut_ac8 s3.singlep l3.singlep s3.hereditary l3.hereditary s3.dem_ac8 l3.dem_ac8 l3.gdppc_log l3.gdpgr l3.odapc l3.natresfx l3.poptot_log l3.popurb l3.ethnic l3.dur_ac8 l3.commrule if other2==0, vce(robust)
. test s3.elaut_ac8 = s3.singlep
. test l3.elaut_ac8 = l3.singlep
. test s3.elaut_ac8 = s3.hereditary
. test l3.elaut_ac8 = l3.hereditary

*** 2ary enrolment
. reg s3.enr2tot l3.enr2tot s3.elaut_ac8 l3.elaut_ac8 s3.singlep l3.singlep s3.hereditary l3.hereditary s3.dem_ac8 l3.dem_ac8 l3.gdppc_log l3.gdpgr l3.odapc l3.natresfx l3.poptot_log l3.popurb l3.ethnic l3.dur_ac8 l3.commrule if other2==0, vce(robust)
. test s3.elaut_ac8 = s3.singlep
. test l3.elaut_ac8 = l3.singlep
. test s3.elaut_ac8 = s3.hereditary
. test l3.elaut_ac8 = l3.hereditary






**********************
**** Robustness checks
**********************


*******************
***** Alternative X : Freedom House


*** Spending (gov)
. reg s3.spendhealgov l3.spendhealgov s3.elaut_ac5 l3.elaut_ac5 s3.dem_ac5 l3.dem_ac5 l3.gdppc_log l3.gdpgr l3.odapc l3.natresfx l3.poptot_log l3.popurb l3.ethnic l3.dur_ac5 l3.commrule if other1==0, vce(robust)
. test s3.elaut_ac5 = s3.dem_ac5
. test l3.elaut_ac5 = l3.dem_ac5

*** Spending (gdp)
. reg s3.spendhealgdp l3.spendhealgdp s3.elaut_ac5 l3.elaut_ac5 s3.dem_ac5 l3.dem_ac5 l3.gdppc_log l3.gdpgr l3.odapc l3.natresfx l3.poptot_log l3.popurb l3.ethnic l3.dur_ac5 l3.commrule if other1==0, vce(robust)
. test s3.elaut_ac5 = s3.dem_ac5
. test l3.elaut_ac5 = l3.dem_ac5

*** Spending (gov)
. reg s3.spendhealgov l3.spendhealgov s3.elaut_ac5 l3.elaut_ac5 s3.singlep l3.singlep s3.hereditary l3.hereditary s3.dem_ac5 l3.dem_ac5 l3.gdppc_log l3.gdpgr l3.odapc l3.natresfx l3.poptot_log l3.popurb l3.ethnic l3.dur_ac5 l3.commrule if other2==0, vce(robust)
. test s3.elaut_ac5 = s3.singlep
. test l3.elaut_ac5 = l3.singlep
. test s3.elaut_ac5 = s3.hereditary
. test l3.elaut_ac5 = l3.hereditary

*** Spending (gdp)
. reg s3.spendhealgdp l3.spendhealgdp s3.elaut_ac5 l3.elaut_ac5 s3.singlep l3.singlep s3.hereditary l3.hereditary s3.dem_ac5 l3.dem_ac5 l3.gdppc_log l3.gdpgr l3.odapc l3.natresfx l3.poptot_log l3.popurb l3.ethnic l3.dur_ac5 l3.commrule if other2==0, vce(robust)
. test s3.elaut_ac5 = s3.singlep
. test l3.elaut_ac5 = l3.singlep
. test s3.elaut_ac5 = s3.hereditary
. test l3.elaut_ac5 = l3.hereditary


*** Infant mortality
. reg s3.mortu1 l3.mortu1 s3.elaut_ac5 l3.elaut_ac5 s3.dem_ac5 l3.dem_ac5 l3.gdppc_log l3.gdpgr l3.odapc l3.natresfx l3.poptot_log l3.popurb l3.ethnic l3.dur_ac5 l3.commrule if other1==0, vce(robust)
. test s3.elaut_ac5 = s3.dem_ac5
. test l3.elaut_ac5 = l3.dem_ac5

*** 2ary enrolment
. reg s3.enr2tot l3.enr2tot s3.elaut_ac5 l3.elaut_ac5 s3.dem_ac5 l3.dem_ac5 l3.gdppc_log l3.gdpgr l3.odapc l3.natresfx l3.poptot_log l3.popurb l3.ethnic l3.dur_ac5 l3.commrule if other1==0, vce(robust)
. test s3.elaut_ac5 = s3.dem_ac5
. test l3.elaut_ac5 = l3.dem_ac5

*** Infant mortality
. reg s3.mortu1 l3.mortu1 s3.elaut_ac5 l3.elaut_ac5 s3.singlep l3.singlep s3.hereditary l3.hereditary s3.dem_ac5 l3.dem_ac5 l3.gdppc_log l3.gdpgr l3.odapc l3.natresfx l3.poptot_log l3.popurb l3.ethnic l3.dur_ac5 l3.commrule if other2==0, vce(robust)
. test s3.elaut_ac5 = s3.singlep
. test l3.elaut_ac5 = l3.singlep
. test s3.elaut_ac5 = s3.hereditary
. test l3.elaut_ac5 = l3.hereditary

*** 2ary enrolment
. reg s3.enr2tot l3.enr2tot s3.elaut_ac5 l3.elaut_ac5 s3.singlep l3.singlep s3.hereditary l3.hereditary s3.dem_ac5 l3.dem_ac5 l3.gdppc_log l3.gdpgr l3.odapc l3.natresfx l3.poptot_log l3.popurb l3.ethnic l3.dur_ac5 l3.commrule if other2==0, vce(robust)
. test s3.elaut_ac5 = s3.singlep
. test l3.elaut_ac5 = l3.singlep
. test s3.elaut_ac5 = s3.hereditary
. test l3.elaut_ac5 = l3.hereditary






*******************
***** Alternative X : DPI


*** Spending (gov)
. reg s3.spendhealgov l3.spendhealgov s3.elaut_ac9 l3.elaut_ac9 s3.dem_ac9 l3.dem_ac9 l3.gdppc_log l3.gdpgr l3.odapc l3.natresfx l3.poptot_log l3.popurb l3.ethnic l3.dur_ac9 l3.commrule if other1==0, vce(robust)
. test s3.elaut_ac9 = s3.dem_ac9
. test l3.elaut_ac9 = l3.dem_ac9

*** Spending (gdp)
. reg s3.spendhealgdp l3.spendhealgdp s3.elaut_ac9 l3.elaut_ac9 s3.dem_ac9 l3.dem_ac9 l3.gdppc_log l3.gdpgr l3.odapc l3.natresfx l3.poptot_log l3.popurb l3.ethnic l3.dur_ac9 l3.commrule if other1==0, vce(robust)
. test s3.elaut_ac9 = s3.dem_ac9
. test l3.elaut_ac9 = l3.dem_ac9

*** Spending (gov)
. reg s3.spendhealgov l3.spendhealgov s3.elaut_ac9 l3.elaut_ac9 s3.singlep l3.singlep s3.hereditary l3.hereditary s3.dem_ac9 l3.dem_ac9 l3.gdppc_log l3.gdpgr l3.odapc l3.natresfx l3.poptot_log l3.popurb l3.ethnic l3.dur_ac9 l3.commrule if other2==0, vce(robust)
. test s3.elaut_ac9 = s3.singlep
. test l3.elaut_ac9 = l3.singlep
. test s3.elaut_ac9 = s3.hereditary
. test l3.elaut_ac9 = l3.hereditary

*** Spending (gdp)
. reg s3.spendhealgdp l3.spendhealgdp s3.elaut_ac9 l3.elaut_ac9 s3.singlep l3.singlep s3.hereditary l3.hereditary s3.dem_ac9 l3.dem_ac9 l3.gdppc_log l3.gdpgr l3.odapc l3.natresfx l3.poptot_log l3.popurb l3.ethnic l3.dur_ac9 l3.commrule if other2==0, vce(robust)
. test s3.elaut_ac9 = s3.singlep
. test l3.elaut_ac9 = l3.singlep
. test s3.elaut_ac9 = s3.hereditary
. test l3.elaut_ac9 = l3.hereditary


*** Infant mortality
. reg s3.mortu1 l3.mortu1 s3.elaut_ac9 l3.elaut_ac9 s3.dem_ac9 l3.dem_ac9 l3.gdppc_log l3.gdpgr l3.odapc l3.natresfx l3.poptot_log l3.popurb l3.ethnic l3.dur_ac9 l3.commrule if other1==0, vce(robust)
. test s3.elaut_ac9 = s3.dem_ac9
. test l3.elaut_ac9 = l3.dem_ac9

*** 2ary enrolment
. reg s3.enr2tot l3.enr2tot s3.elaut_ac9 l3.elaut_ac9 s3.dem_ac9 l3.dem_ac9 l3.gdppc_log l3.gdpgr l3.odapc l3.natresfx l3.poptot_log l3.popurb l3.ethnic l3.dur_ac9 l3.commrule if other1==0, vce(robust)
. test s3.elaut_ac9 = s3.dem_ac9
. test l3.elaut_ac9 = l3.dem_ac9

*** Infant mortality
. reg s3.mortu1 l3.mortu1 s3.elaut_ac9 l3.elaut_ac9 s3.singlep l3.singlep s3.hereditary l3.hereditary s3.dem_ac9 l3.dem_ac9 l3.gdppc_log l3.gdpgr l3.odapc l3.natresfx l3.poptot_log l3.popurb l3.ethnic l3.dur_ac9 l3.commrule if other2==0, vce(robust)
. test s3.elaut_ac9 = s3.singlep
. test l3.elaut_ac9 = l3.singlep
. test s3.elaut_ac9 = s3.hereditary
. test l3.elaut_ac9 = l3.hereditary

*** 2ary enrolment
. reg s3.enr2tot l3.enr2tot s3.elaut_ac9 l3.elaut_ac9 s3.singlep l3.singlep s3.hereditary l3.hereditary s3.dem_ac9 l3.dem_ac9 l3.gdppc_log l3.gdpgr l3.odapc l3.natresfx l3.poptot_log l3.popurb l3.ethnic l3.dur_ac9 l3.commrule if other2==0, vce(robust)
. test s3.elaut_ac9 = s3.singlep
. test l3.elaut_ac9 = l3.singlep
. test s3.elaut_ac9 = s3.hereditary
. test l3.elaut_ac9 = l3.hereditary






*******************
***** Alternative Y (life expct; 1ary enrolm)


*** Life expectancy
. reg s3.lifetot l3.lifetot l.s3.lifetot s3.elaut_ac8 l3.elaut_ac8 s3.dem_ac8 l3.dem_ac8 l3.gdppc_log l3.gdpgr l3.odapc l3.natresfx l3.poptot_log l3.popurb l3.ethnic l3.dur_ac8 l3.commrule if other1==0, vce(robust)
. test s3.elaut_ac8 = s3.dem_ac8
. test l3.elaut_ac8 = l3.dem_ac8

*** 1ary enrolment
. reg s3.enr1tot l3.enr1tot s3.elaut_ac8 l3.elaut_ac8 s3.dem_ac8 l3.dem_ac8 l3.gdppc_log l3.gdpgr l3.odapc l3.natresfx l3.poptot_log l3.popurb l3.ethnic l3.dur_ac8 l3.commrule if other1==0, vce(robust)
. test s3.elaut_ac8 = s3.dem_ac8
. test l3.elaut_ac8 = l3.dem_ac8

*** Life expectancy
. reg s3.lifetot l3.lifetot l.s3.lifetot s3.elaut_ac8 l3.elaut_ac8 s3.singlep l3.singlep s3.hereditary l3.hereditary s3.dem_ac8 l3.dem_ac8 l3.gdppc_log l3.gdpgr l3.odapc l3.natresfx l3.poptot_log l3.popurb l3.ethnic l3.dur_ac8 l3.commrule if other2==0, vce(robust)
. test s3.elaut_ac8 = s3.singlep
. test l3.elaut_ac8 = l3.singlep
. test s3.elaut_ac8 = s3.hereditary
. test l3.elaut_ac8 = l3.hereditary

*** 1ary enrolment
. reg s3.enr1tot l3.enr1tot s3.elaut_ac8 l3.elaut_ac8 s3.singlep l3.singlep s3.hereditary l3.hereditary s3.dem_ac8 l3.dem_ac8 l3.gdppc_log l3.gdpgr l3.odapc l3.natresfx l3.poptot_log l3.popurb l3.ethnic l3.dur_ac8 l3.commrule if other2==0, vce(robust)
. test s3.elaut_ac8 = s3.singlep
. test l3.elaut_ac8 = l3.singlep
. test s3.elaut_ac8 = s3.hereditary
. test l3.elaut_ac8 = l3.hereditary






*******************
***** Country & Time FE


*** Spending (gov)
. xi: xtreg s3.spendhealgov l3.spendhealgov s3.elaut_ac8 l3.elaut_ac8 s3.dem_ac8 l3.dem_ac8  i.year if other1==0, fe
. test s3.elaut_ac8 = s3.dem_ac8
. test l3.elaut_ac8 = l3.dem_ac8

*** Spending (gdp)
. xi: xtreg s3.spendhealgdp l3.spendhealgdp s3.elaut_ac8 l3.elaut_ac8 s3.dem_ac8 l3.dem_ac8  i.year if other1==0, fe
. test s3.elaut_ac8 = s3.dem_ac8
. test l3.elaut_ac8 = l3.dem_ac8

*** Spending (gov)
. xi: xtreg s3.spendhealgov l3.spendhealgov s3.elaut_ac8 l3.elaut_ac8 s3.singlep l3.singlep s3.hereditary l3.hereditary s3.dem_ac8 l3.dem_ac8  i.year if other2==0, fe
. test s3.elaut_ac8 = s3.singlep
. test l3.elaut_ac8 = l3.singlep
. test s3.elaut_ac8 = s3.hereditary
. test l3.elaut_ac8 = l3.hereditary

*** Spending (gdp)
. xi: xtreg s3.spendhealgdp l3.spendhealgdp s3.elaut_ac8 l3.elaut_ac8 s3.singlep l3.singlep s3.hereditary l3.hereditary s3.dem_ac8 l3.dem_ac8  i.year if other2==0, fe
. test s3.elaut_ac8 = s3.singlep
. test l3.elaut_ac8 = l3.singlep
. test s3.elaut_ac8 = s3.hereditary
. test l3.elaut_ac8 = l3.hereditary


*** Infant mortality
. xi: xtreg s3.mortu1 l3.mortu1 s3.elaut_ac8 l3.elaut_ac8 s3.dem_ac8 l3.dem_ac8  i.year if other1==0, fe
. test s3.elaut_ac8 = s3.dem_ac8
. test l3.elaut_ac8 = l3.dem_ac8

*** 2ary enrolment
. xi: xtreg s3.enr2tot l3.enr2tot s3.elaut_ac8 l3.elaut_ac8 s3.dem_ac8 l3.dem_ac8  i.year if other1==0, fe
. test s3.elaut_ac8 = s3.dem_ac8
. test l3.elaut_ac8 = l3.dem_ac8

*** Infant mortality
. xi: xtreg s3.mortu1 l3.mortu1 s3.elaut_ac8 l3.elaut_ac8 s3.singlep l3.singlep s3.hereditary l3.hereditary s3.dem_ac8 l3.dem_ac8  i.year if other2==0, fe
. test s3.elaut_ac8 = s3.singlep
. test l3.elaut_ac8 = l3.singlep
. test s3.elaut_ac8 = s3.hereditary
. test l3.elaut_ac8 = l3.hereditary

*** 2ary enrolment
. xi: xtreg s3.enr2tot l3.enr2tot s3.elaut_ac8 l3.elaut_ac8 s3.singlep l3.singlep s3.hereditary l3.hereditary s3.dem_ac8 l3.dem_ac8  i.year if other2==0, fe
. test s3.elaut_ac8 = s3.singlep
. test l3.elaut_ac8 = l3.singlep
. test s3.elaut_ac8 = s3.hereditary
. test l3.elaut_ac8 = l3.hereditary






*******************
***** Alternative intervals (1-year)


*** Spending (gov)
. reg d.spendhealgov l.spendhealgov d.elaut_ac8 l.elaut_ac8 d.dem_ac8 l.dem_ac8 l.gdppc_log l.gdpgr l.odapc l.natresfx l.poptot_log l.popurb l.ethnic l.dur_ac8 l.commrule if other1==0, vce(robust)
. test d.elaut_ac8 = d.dem_ac8
. test l.elaut_ac8 = l.dem_ac8

*** Spending (gdp)
. reg d.spendhealgdp l.spendhealgdp d.elaut_ac8 l.elaut_ac8 d.dem_ac8 l.dem_ac8 l.gdppc_log l.gdpgr l.odapc l.natresfx l.poptot_log l.popurb l.ethnic l.dur_ac8 l.commrule if other1==0, vce(robust)
. test d.elaut_ac8 = d.dem_ac8
. test l.elaut_ac8 = l.dem_ac8

*** Spending (gov)
. reg d.spendhealgov l.spendhealgov d.elaut_ac8 l.elaut_ac8 d.singlep l.singlep d.hereditary l.hereditary d.dem_ac8 l.dem_ac8 l.gdppc_log l.gdpgr l.odapc l.natresfx l.poptot_log l.popurb l.ethnic l.dur_ac8 l.commrule if other2==0, vce(robust)
. test d.elaut_ac8 = d.singlep
. test l.elaut_ac8 = l.singlep
. test d.elaut_ac8 = d.hereditary
. test l.elaut_ac8 = l.hereditary

*** Spending (gdp)
. reg d.spendhealgdp l.spendhealgdp d.elaut_ac8 l.elaut_ac8 d.singlep l.singlep d.hereditary l.hereditary d.dem_ac8 l.dem_ac8 l.gdppc_log l.gdpgr l.odapc l.natresfx l.poptot_log l.popurb l.ethnic l.dur_ac8 l.commrule if other2==0, vce(robust)
. test d.elaut_ac8 = d.singlep
. test l.elaut_ac8 = l.singlep
. test d.elaut_ac8 = d.hereditary
. test l.elaut_ac8 = l.hereditary


*** Infant mortality
. reg d.mortu1 l.mortu1 d.elaut_ac8 l.elaut_ac8 d.dem_ac8 l.dem_ac8 l.gdppc_log l.gdpgr l.odapc l.natresfx l.poptot_log l.popurb l.ethnic l.dur_ac8 l.commrule if other1==0, vce(robust)
. test d.elaut_ac8 = d.dem_ac8
. test l.elaut_ac8 = l.dem_ac8

*** 2ary enrolment
. reg d.enr2tot l.enr2tot d.elaut_ac8 l.elaut_ac8 d.dem_ac8 l.dem_ac8 l.gdppc_log l.gdpgr l.odapc l.natresfx l.poptot_log l.popurb l.ethnic l.dur_ac8 l.commrule if other1==0, vce(robust)
. test d.elaut_ac8 = d.dem_ac8
. test l.elaut_ac8 = l.dem_ac8

*** Infant mortality
. reg d.mortu1 l.mortu1 d.elaut_ac8 l.elaut_ac8 d.singlep l.singlep d.hereditary l.hereditary d.dem_ac8 l.dem_ac8 l.gdppc_log l.gdpgr l.odapc l.natresfx l.poptot_log l.popurb l.ethnic l.dur_ac8 l.commrule if other2==0, vce(robust)
. test d.elaut_ac8 = d.singlep
. test l.elaut_ac8 = l.singlep
. test d.elaut_ac8 = d.hereditary
. test l.elaut_ac8 = l.hereditary

*** 2ary enrolment
. reg d.enr2tot l.enr2tot d.elaut_ac8 l.elaut_ac8 d.singlep l.singlep d.hereditary l.hereditary d.dem_ac8 l.dem_ac8 l.gdppc_log l.gdpgr l.odapc l.natresfx l.poptot_log l.popurb l.ethnic l.dur_ac8 l.commrule if other2==0, vce(robust)
. test d.elaut_ac8 = d.singlep
. test l.elaut_ac8 = l.singlep
. test d.elaut_ac8 = d.hereditary
. test l.elaut_ac8 = l.hereditary






*******************
***** Thinner model


*** Spending (gov)
. reg s3.spendhealgov l3.spendhealgov s3.elaut_ac8 l3.elaut_ac8 s3.dem_ac8 l3.dem_ac8 l3.gdppc_log l3.poptot_log l3.popurb l3.ethnic l3.commrule if other1==0, vce(robust)
. test s3.elaut_ac8 = s3.dem_ac8
. test l3.elaut_ac8 = l3.dem_ac8

*** Spending (gdp)
. reg s3.spendhealgdp l3.spendhealgdp s3.elaut_ac8 l3.elaut_ac8 s3.dem_ac8 l3.dem_ac8 l3.gdppc_log l3.poptot_log l3.popurb l3.ethnic l3.commrule if other1==0, vce(robust)
. test s3.elaut_ac8 = s3.dem_ac8
. test l3.elaut_ac8 = l3.dem_ac8

*** Spending (gov)
. reg s3.spendhealgov l3.spendhealgov s3.elaut_ac8 l3.elaut_ac8 s3.singlep l3.singlep s3.hereditary l3.hereditary s3.dem_ac8 l3.dem_ac8 l3.gdppc_log l3.poptot_log l3.popurb l3.ethnic l3.commrule if other2==0, vce(robust)
. test s3.elaut_ac8 = s3.singlep
. test l3.elaut_ac8 = l3.singlep
. test s3.elaut_ac8 = s3.hereditary
. test l3.elaut_ac8 = l3.hereditary

*** Spending (gdp)
. reg s3.spendhealgdp l3.spendhealgdp s3.elaut_ac8 l3.elaut_ac8 s3.singlep l3.singlep s3.hereditary l3.hereditary s3.dem_ac8 l3.dem_ac8 l3.gdppc_log l3.poptot_log l3.popurb l3.ethnic l3.commrule if other2==0, vce(robust)
. test s3.elaut_ac8 = s3.singlep
. test l3.elaut_ac8 = l3.singlep
. test s3.elaut_ac8 = s3.hereditary
. test l3.elaut_ac8 = l3.hereditary


*** Infant mortality
. reg s3.mortu1 l3.mortu1 s3.elaut_ac8 l3.elaut_ac8 s3.dem_ac8 l3.dem_ac8 l3.gdppc_log l3.poptot_log l3.popurb l3.ethnic l3.commrule if other1==0, vce(robust)
. test s3.elaut_ac8 = s3.dem_ac8
. test l3.elaut_ac8 = l3.dem_ac8

*** 2ary enrolment
. reg s3.enr2tot l3.enr2tot s3.elaut_ac8 l3.elaut_ac8 s3.dem_ac8 l3.dem_ac8 l3.gdppc_log l3.poptot_log l3.popurb l3.ethnic l3.commrule if other1==0, vce(robust)
. test s3.elaut_ac8 = s3.dem_ac8
. test l3.elaut_ac8 = l3.dem_ac8

*** Infant mortality
. reg s3.mortu1 l3.mortu1 s3.elaut_ac8 l3.elaut_ac8 s3.singlep l3.singlep s3.hereditary l3.hereditary s3.dem_ac8 l3.dem_ac8 l3.gdppc_log l3.poptot_log l3.popurb l3.ethnic l3.commrule if other2==0, vce(robust)
. test s3.elaut_ac8 = s3.singlep
. test l3.elaut_ac8 = l3.singlep
. test s3.elaut_ac8 = s3.hereditary
. test l3.elaut_ac8 = l3.hereditary

*** 2ary enrolment
. reg s3.enr2tot l3.enr2tot s3.elaut_ac8 l3.elaut_ac8 s3.singlep l3.singlep s3.hereditary l3.hereditary s3.dem_ac8 l3.dem_ac8 l3.gdppc_log l3.poptot_log l3.popurb l3.ethnic l3.commrule if other2==0, vce(robust)
. test s3.elaut_ac8 = s3.singlep
. test l3.elaut_ac8 = l3.singlep
. test s3.elaut_ac8 = s3.hereditary
. test l3.elaut_ac8 = l3.hereditary






*******************
***** Cross-sectional analysis

. use cassaniRISP2016_cs, clear

*** Spending (gov)
. reg spendhealgov elaut_ac8 dem_ac8 gdppc_log gdpgr odapc natresfx poptot_log popurb ethnic dur_ac8 commrule if other1==0 & dur_ac8>=5, robust
. test elaut_ac8 = dem_ac8
. test elaut_ac8 = dem_ac8

*** Spending (gdp)
. reg spendhealgdp elaut_ac8 dem_ac8 gdppc_log gdpgr odapc natresfx poptot_log popurb ethnic dur_ac8 commrule if other1==0 & dur_ac8>=5, robust
. test elaut_ac8 = dem_ac8
. test elaut_ac8 = dem_ac8

*** Spending (gov)
. reg spendhealgov elaut_ac8 singlep hereditary dem_ac8 gdppc_log gdpgr odapc natresfx poptot_log popurb ethnic dur_ac8 commrule if other2==0 & dur_ac8>=5, robust
. test elaut_ac8 = singlep
. test elaut_ac8 = singlep
. test elaut_ac8 = hereditary
. test elaut_ac8 = hereditary

*** Spending (gdp)
. reg spendhealgdp elaut_ac8 singlep hereditary dem_ac8 gdppc_log gdpgr odapc natresfx poptot_log popurb ethnic dur_ac8 commrule if other2==0 & dur_ac8>=5, robust
. test elaut_ac8 = singlep
. test elaut_ac8 = singlep
. test elaut_ac8 = hereditary
. test elaut_ac8 = hereditary


*** Infant mortality
. reg mortu1 elaut_ac8 dem_ac8 gdppc_log gdpgr odapc natresfx poptot_log popurb ethnic dur_ac8 commrule if other1==0 & dur_ac8>=5, robust
. test elaut_ac8 = dem_ac8
. test elaut_ac8 = dem_ac8

*** 2ary enrolment
. reg enr2tot elaut_ac8 dem_ac8 gdppc_log gdpgr odapc natresfx poptot_log popurb ethnic dur_ac8 commrule if other1==0 & dur_ac8>=5, robust
. test elaut_ac8 = dem_ac8
. test elaut_ac8 = dem_ac8

*** Infant mortality
. reg mortu1 elaut_ac8 singlep hereditary dem_ac8 gdppc_log gdpgr odapc natresfx poptot_log popurb ethnic dur_ac8 commrule if other2==0 & dur_ac8>=5, robust
. test elaut_ac8 = singlep
. test elaut_ac8 = singlep
. test elaut_ac8 = hereditary
. test elaut_ac8 = hereditary

*** 2ary enrolment
. reg enr2tot elaut_ac8 singlep hereditary dem_ac8 gdppc_log gdpgr odapc natresfx poptot_log popurb ethnic dur_ac8 commrule if other2==0 & dur_ac8>=5, robust
. test elaut_ac8 = singlep
. test elaut_ac8 = singlep
. test elaut_ac8 = hereditary
. test elaut_ac8 = hereditary






*******************
***** Multiple imputation

. use cassaniRISP2016_mi95, clear
. mi convert wide
. mi stset, clear

*** Spending (gov)
. mi estimate, dots post : reg s3.spendhealgov l3.spendhealgov s3.elaut_ac8 l3.elaut_ac8 s3.dem_ac8 l3.dem_ac8 l3.gdppc_log l3.gdpgr l3.odapc l3.natresfx l3.poptot_log l3.popurb l3.ethnic l3.dur_ac8 l3.commrule if other1==0, vce(robust)
. test s3.elaut_ac8 = s3.dem_ac8
. test l3.elaut_ac8 = l3.dem_ac8

*** Spending (gdp)
. mi estimate, dots post : reg s3.spendhealgdp l3.spendhealgdp s3.elaut_ac8 l3.elaut_ac8 s3.dem_ac8 l3.dem_ac8 l3.gdppc_log l3.gdpgr l3.odapc l3.natresfx l3.poptot_log l3.popurb l3.ethnic l3.dur_ac8 l3.commrule if other1==0, vce(robust)
. test s3.elaut_ac8 = s3.dem_ac8
. test l3.elaut_ac8 = l3.dem_ac8

*** Spending (gov)
. mi estimate, dots post : reg s3.spendhealgov l3.spendhealgov s3.elaut_ac8 l3.elaut_ac8 s3.singlep l3.singlep s3.hereditary l3.hereditary s3.dem_ac8 l3.dem_ac8 l3.gdppc_log l3.gdpgr l3.odapc l3.natresfx l3.poptot_log l3.popurb l3.ethnic l3.dur_ac8 l3.commrule if other2==0, vce(robust)
. test s3.elaut_ac8 = s3.singlep
. test l3.elaut_ac8 = l3.singlep
. test s3.elaut_ac8 = s3.hereditary
. test l3.elaut_ac8 = l3.hereditary

*** Spending (gdp)
. mi estimate, dots post : reg s3.spendhealgdp l3.spendhealgdp s3.elaut_ac8 l3.elaut_ac8 s3.singlep l3.singlep s3.hereditary l3.hereditary s3.dem_ac8 l3.dem_ac8 l3.gdppc_log l3.gdpgr l3.odapc l3.natresfx l3.poptot_log l3.popurb l3.ethnic l3.dur_ac8 l3.commrule if other2==0, vce(robust)
. test s3.elaut_ac8 = s3.singlep
. test l3.elaut_ac8 = l3.singlep
. test s3.elaut_ac8 = s3.hereditary
. test l3.elaut_ac8 = l3.hereditary


. use cassaniRISP2016_mi80, clear
. mi convert wide
. mi stset, clear

*** Infant mortality
. mi estimate, dots post : reg s3.mortu1 l3.mortu1 s3.elaut_ac8 l3.elaut_ac8 s3.dem_ac8 l3.dem_ac8 l3.gdppc_log l3.gdpgr l3.odapc l3.natresfx l3.poptot_log l3.popurb l3.ethnic l3.dur_ac8 l3.commrule if other1==0, vce(robust)
. test s3.elaut_ac8 = s3.dem_ac8
. test l3.elaut_ac8 = l3.dem_ac8

*** 2ary enrolment
. mi estimate, dots post : reg s3.enr2tot l3.enr2tot s3.elaut_ac8 l3.elaut_ac8 s3.dem_ac8 l3.dem_ac8 l3.gdppc_log l3.gdpgr l3.odapc l3.natresfx l3.poptot_log l3.popurb l3.ethnic l3.dur_ac8 l3.commrule if other1==0, vce(robust)
. test s3.elaut_ac8 = s3.dem_ac8
. test l3.elaut_ac8 = l3.dem_ac8

*** Infant mortality
. mi estimate, dots post : reg s3.mortu1 l3.mortu1 s3.elaut_ac8 l3.elaut_ac8 s3.singlep l3.singlep s3.hereditary l3.hereditary s3.dem_ac8 l3.dem_ac8 l3.gdppc_log l3.gdpgr l3.odapc l3.natresfx l3.poptot_log l3.popurb l3.ethnic l3.dur_ac8 l3.commrule if other2==0, vce(robust)
. test s3.elaut_ac8 = s3.singlep
. test l3.elaut_ac8 = l3.singlep
. test s3.elaut_ac8 = s3.hereditary
. test l3.elaut_ac8 = l3.hereditary

*** 2ary enrolment
. mi estimate, dots post : reg s3.enr2tot l3.enr2tot s3.elaut_ac8 l3.elaut_ac8 s3.singlep l3.singlep s3.hereditary l3.hereditary s3.dem_ac8 l3.dem_ac8 l3.gdppc_log l3.gdpgr l3.odapc l3.natresfx l3.poptot_log l3.popurb l3.ethnic l3.dur_ac8 l3.commrule if other2==0, vce(robust)
. test s3.elaut_ac8 = s3.singlep
. test l3.elaut_ac8 = l3.singlep
. test s3.elaut_ac8 = s3.hereditary
. test l3.elaut_ac8 = l3.hereditary

