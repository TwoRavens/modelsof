use "experiment data.dta"

** Affective polarization is the absolute difference in candidate feeling thermometers
gen affective_polarization=abs(candAtherm-candBtherm)

** Setup data to handle survey weights
svyset [pw=weight]

** Descriptive statistics (in "Study Design" section)
svy: mean candAtherm
svy: mean candBtherm
svy: mean affective_polarization


***************************************************
** RESULTS SECTION (statistics reported in text) **
***************************************************

** test whether affective polarization is greater among respondents in the polarization condition
svy: mean affective_polarization,over(polarized)
lincom [affective_polarization]0-[affective_polarization]1

** Generate statistics for Figure 2
** See Figure2.R for producing Figure 2
gen Aadvantage=1 if ideology<6
replace Aadvantage=0 if ideology>6

gen Badvantage1=1 if ideology>6
replace Badvantage=0 if ideology<6

svy, subpop(Aadvantage): mean candAtherm,over(polarized)
lincom [candAtherm]0 - [candAtherm]1

svy, subpop(Badvantage): mean candAtherm,over(polarized)
lincom [candAtherm]0 - [candAtherm]1

svy, subpop(Badvantage): mean candBtherm,over(polarized)
lincom [candBtherm]0 - [candBtherm]1

svy, subpop(Aadvantage): mean candBtherm,over(polarized)
lincom [candBtherm]0 - [candBtherm]1

** Generate statistics for Figure 3
** See Figure3.R for producing Figure 3
svy: mean affective_polarization,over(ideology polarized)
lincom [affective_polarization]_subpop_1 - [affective_polarization]_subpop_2
lincom [affective_polarization]_subpop_3 - [affective_polarization]_subpop_4
lincom [affective_polarization]_subpop_5 - [affective_polarization]_subpop_6
lincom [affective_polarization]_subpop_7 - [affective_polarization]_subpop_8
lincom [affective_polarization]_subpop_9 - [affective_polarization]_subpop_10
lincom [affective_polarization]_subpop_11 - [affective_polarization]_subpop_12
lincom [affective_polarization]_subpop_13 - [affective_polarization]_subpop_14
lincom [affective_polarization]_subpop_15 - [affective_polarization]_subpop_16
lincom [affective_polarization]_subpop_17 - [affective_polarization]_subpop_18
lincom [affective_polarization]_subpop_19 - [affective_polarization]_subpop_20
lincom [affective_polarization]_subpop_21 - [affective_polarization]_subpop_22

** Generate statistics for differences by political interest
svy: mean affective_polarization,over(polarized ext_very_interested)
lincom [affective_polarization]_subpop_1-[affective_polarization]_subpop_3
lincom [affective_polarization]_subpop_2-[affective_polarization]_subpop_4
lincom ([affective_polarization]_subpop_2-[affective_polarization]_subpop_4)-([affective_polarization]_subpop_1-[affective_polarization]_subpop_3)

** Table 1
gen ideo_extreme=ideology
recode ideo_extreme (6=0) (5 7=1) (4 8=2) (3 9=3) (2 10=4) (1 11=5)
svy: reg affective_polarization polarized XPARTY7  PPAGE PPEDUC i.PPETHM i.PPGENDER ideology
svy: reg affective_polarization c.polarized##c.ideo_extreme XPARTY7  PPAGE PPEDUC i.PPETHM i.PPGENDER ideology
svy: reg affective_polarization c.polarized##i.ext_very_interested XPARTY7  PPAGE PPEDUC i.PPETHM i.PPGENDER ideology


** Moderating effects of biographical information
** Generate statistics for Figure 4
svy: mean affective_polarization,over(XTESS078)
* effect of polarization among people who did not receive non-policy bio_info
lincom [affective_polarization]_subpop_2-[affective_polarization]_subpop_4

* effect of polarization among respondents who received non-policy bio_info
lincom [affective_polarization]_subpop_1-[affective_polarization]_subpop_3

* test whether these differences in treatment effects are statistically different.
lincom ([affective_polarization]_subpop_2-[affective_polarization]_subpop_4)-([affective_polarization]_subpop_1-[affective_polarization]_subpop_3)

