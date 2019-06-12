version 10
cd "/Users/gehlbach/Dropbox/Data/Russian Enterprise/Replication"
clear
set mem 100m
set matsize 500


/* CREATE DATA */

/* merge first-stage estimates */
use terlist
drop if ter == 1144
merge using sDTmatrix
drop _merge
sort ter
save temp, replace

use terlist
drop if ter == 1140 | ter == 1145
merge using DTnocmatrix
drop _merge
sort ter
save temp1, replace

use terlist
merge using OLSmatrix
drop _merge
merge using DTmatrix
drop _merge
merge using DTnofmatrix
drop _merge
sort ter
merge ter using temp
drop _merge
sort ter
merge ter using temp1
drop _merge
sort ter
save priv, replace

/* merge regional data */
use regional
keep if year == 5
drop year
sort ter
merge ter using priv
drop _merge
sort ter
merge ter using firmyear
drop _merge
save work, replace


/* SUMSTATS AND FIGURES */

sum lnmbur lnmburexecfed lnmburexecreg lnmburnoexec lnmpop lninc91 urban91 auton lndensity91 juris privDT lsoOLS sprivDT
hist privDT, freq xtitle("Estimated regional privatization effect") ytitle("Number of regions") scheme(s2mono) bin(16) 
gen temp = SE2privDT^.5
scatter temp firmyear, xtitle("Number of firm-year observations") ytitle("Standard error of estimated privatization effect") scheme(s2mono)


/* BASELINE REGRESSIONS */

/* TABLE 3: DT marginal effect of priv - OLS w/ ROBUST SEs */
reg privDT lnmbur lnmpop lninc91 urban91 auton, robust

/* TABLE 3: DT marginal effect of priv - FGLS */
preserve
global DV "privDT"
global SE2 "SE2privDT"
global GCOL "VprivDT1-VprivDT77"
global RHS "lnmbur lnmpop lninc91 urban91 auton"
do FGLS
restore

/* TABLE 3: DT marginal effect of priv - 2SLS w/ ROBUST SEs */
ivreg2 privDT (lnmbur = lndensity juris) lnmpop lninc91 urban91 auton, robust first small

/* TABLE 4: OLS total effect of LSO - OLS w/ ROBUST SEs */
reg lsoOLS lnmbur lnmpop lninc91 urban91 auton, robust

/* TABLE 4: OLS total effect of LSO - FGLS */
preserve
global DV "lsoOLS"
global SE2 "SE2lsoOLS"
global GCOL "VlsoOLS1-VlsoOLS77"
global RHS "lnmbur lnmpop lninc91 urban91 auton"
do FGLS
restore

/* TABLE 4: OLS total effect of LSO - 2SLS w/ ROBUST SEs */
ivreg2 lsoOLS (lnmbur = lndensity juris) lnmpop lninc91 urban91 auton, robust first small

/* TABLE 4: Auxiliary regressions */
* OLS marginal effect of priv - DT marginal effect of priv
gen privOLS_DT = ldo - lso - privDT
reg privOLS_DT lnmbur lnmpop lninc91 urban91 auton, robust

/* TABLE 5: Unpacked bureaucracy - OLS w/ ROBUST SEs */
reg privDT lnmburexecfed lnmburexecreg lnmburnoexec lnmpop lninc91 urban91 auton, robust

/* TABLE 5: Unpacked bureaucracy - FGLS */
preserve
global DV "privDT"
global SE2 "SE2privDT"
global GCOL "VprivDT1-VprivDT77"
global RHS "lnmburexecfed lnmburexecreg lnmburnoexec lnmpop lninc91 urban91 auton"
do FGLS
restore

/* TABLE 5: Auxiliary regressions */
* Control for mregfed
reg privDT lnmbur mregfed lnmpop lninc91 urban91 auton, robust
preserve
global DV "privDT"
global SE2 "SE2privDT"
global GCOL "VprivDT1-VprivDT77"
global RHS "lnmbur mregfed lnmpop lninc91 urban91 auton"
do FGLS
restore
* Unpacked bureaucracy for lsoOLS
reg lsoOLS lnmburexecfed lnmburexecreg lnmpop lninc91 urban91 auton, robust
preserve
global DV "lsoOLS"
global SE2 "SE2lsoOLS"
global GCOL "VlsoOLS1-VlsoOLS77"
global RHS "lnmburexecfed lnmburexecreg lnmburnoexec lnmpop lninc91 urban91 auton"
do FGLS
restore

***Table 6 regressions: 1995 bureaucracy and population, need "keep if year == 5" above

/* TABLE 6: Privatization propensity - OLS w/ ROBUST SEs */
reg privDT lnburexecfed lnburexecreg lnburnoexec terdever lnpop lninc91 urban91 auton, robust

/* TABLE 6: Privatization propensity - FGLS */
preserve
global DV "privDT"
global SE2 "SE2privDT"
global GCOL "VprivDT1-VprivDT77"
global RHS "lnburexecfed lnburexecreg lnburnoexec terdever lnpop lninc91 urban91 auton"
do FGLS
restore

/* TABLE 6: Small vs. large  - OLS w/ ROBUST SEs */
reg sprivDT lnburexecfed lnburexecreg lnburnoexec lnpop lninc91 urban91 auton, robust

/* TABLE 6: Small vs. large - FGLS */
preserve
drop if sprivDT == .
global DV "sprivDT"
global SE2 "SE2sprivDT"
global GCOL "VsprivDT1-VsprivDT76"
global RHS "lnburexecfed lnburexecreg lnburnoexec lnpop lninc91 urban91 auton"
do FGLS
restore

/* TABLE 6: Auxiliary regressions */
* privatization propensity - average unpacked bureaucracy and population
preserve
global DV "privDT"
global SE2 "SE2privDT"
global GCOL "VprivDT1-VprivDT77"
global RHS "lnmburexecfed lnmburexecreg lnmburnoexec terdever lnmpop lninc91 urban91 auton"
do FGLS
restore
* small vs. large - average unpacked bureaucracy and population
preserve
drop if sprivDT == .
global DV "sprivDT"
global SE2 "SE2sprivDT"
global GCOL "VsprivDT1-VsprivDT76"
global RHS "lnmburexecfed lnmburexecreg lnmburnoexec lnmpop lninc91 urban91 auton"
do FGLS
restore


/* ROBUSTNESS AND EXTENSIONS */

/* fever == 0 */
preserve
global DV "privDTnof"
global SE2 "SE2privDTnof"
global GCOL "VprivDTnof1-VprivDTnof77"
global RHS "lnmbur lnmpop lninc91 urban91 auton"
do FGLS
restore
*
preserve
global DV "privDTnof"
global SE2 "SE2privDTnof"
global GCOL "VprivDTnof1-VprivDTnof77"
global RHS "lnmburexecfed lnmburexecreg lnmburnoexec lnmpop lninc91 urban91 auton"
do FGLS
restore

/* Drop Moscow and St. Petersburg */
preserve
drop if privDTnoc == .
global DV "privDTnoc"
global SE2 "SE2privDTnoc"
global GCOL "VprivDTnoc1-VprivDTnoc75"
global RHS "lnmbur lnmpop lninc91 urban91 auton"
do FGLS
restore
*
preserve
drop if privDTnoc == .
global DV "privDTnoc"
global SE2 "SE2privDTnoc"
global GCOL "VprivDTnoc1-VprivDTnoc75"
global RHS "lnmburexecfed lnmburexecreg lnmburnoexec lnmpop lninc91 urban91 auton"
do FGLS
restore

/* Use republic rather than auton (Jewish AO qualitatively different) */
preserve
global DV "privDT"
global SE2 "SE2privDT"
global GCOL "VprivDT1-VprivDT77"
global RHS "lnmbur lnmpop lninc91 urban91 republic"
do FGLS
restore

/* Expenses: various specifications */
*missing data for income--to run FGLS, would need to recalculate var matrix
*code includes checks for robustness of basic result to smaller sample size
* total bureaucracy
reg privDT lnmbur lnmexpexec lnmpop lninc91 urban91 auton, robust
reg privDT lnmburexec lnmexpexec lnmpop lninc91 urban91 auton, robust
reg privDT lnmbur lnmexpexecnoloc lnmexpexecloc lnmpop lninc91 urban91 auton, robust
reg privDT lnmbur lnmpop lninc91 urban91 auton if lnmexpexec ~= ., robust
* unpacked bureaucracy
reg privDT lnmburexecfed lnmburexecreg lnmburnoexec lnmexpexec lnmpop lninc91 urban91 auton, robust
reg privDT lnmburexecfed lnmburexecreg lnmburnoexec lnmexpexecnoloc lnmexpexecloc lnmpop lninc91 urban91 auton, robust
reg privDT lnmburexecfed lnmburexecreg lnmburnoexec lnmpop lninc91 urban91 auton if lnmexpexec ~= ., robust
* expenses only
reg privDT lnmexpexec lnmpop lninc91 urban91 auton, robust
reg privDT lnmexpexecnoloc lnmexpexecloc lnmpop lninc91 urban91 auton, robust

/* 1995 bureaucracy and population */
*need "keep if year == 5" in merge program above
preserve
global DV "privDT"
global SE2 "SE2privDT"
global GCOL "VprivDT1-VprivDT77"
global RHS "lnbur lnpop lninc91 urban91 auton"
do FGLS
restore
*
preserve
global DV "privDT"
global SE2 "SE2privDT"
global GCOL "VprivDT1-VprivDT77"
global RHS "lnburexecfed lnburexecreg lnburnoexec lnpop lninc91 urban91 auton"
do FGLS
restore

/* Use various years for regional characteristics */
*try different "keep if year == X" in merge program above
preserve
global DV "privDT"
global SE2 "SE2privDT"
global GCOL "VprivDT1-VprivDT77"
global RHS "lnbur lnpop lninc urban auton"
do FGLS
restore
*
preserve
global DV "privDT"
global SE2 "SE2privDT"
global GCOL "VprivDT1-VprivDT77"
global RHS "lnburexecfed lnburexecreg lnburnoexec lnpop lninc urban auton"
do FGLS
restore

/* Drop outliers (OLS) */
preserve
global DV "privDT"
global RHS "lnmbur lnmpop lninc91 urban91 auton"
reg $DV $RHS
dfbeta
drop if abs(DFlnmbur) > .2
reg $DV $RHS, robust
restore
*
preserve
global DV "privDT"
global RHS "lnmburexecfed lnmburexecreg lnmburnoexec lnmpop lninc91 urban91 auton"
reg $DV $RHS
dfbeta
drop if abs(DFlnmburexecreg) > .2
reg $DV $RHS, robust
restore

/* Other controls */
*try various controls: shoutextract91 jantemp pophe94 distmo trans governm_tr free_media99 mparty border super yelt91 HHout91 HHemp91 demsumavg GovPowerSMD99 GovPowerSMD99lib
preserve
gen control = shoutextract91
global DV "privDT"
global SE2 "SE2privDT"
global GCOL "VprivDT1-VprivDT77"
global RHS "lnmbur lnmpop lninc91 urban91 auton control"
do FGLS
restore
*
preserve
gen control = shoutextract91
global DV "privDT"
global SE2 "SE2privDT"
global GCOL "VprivDT1-VprivDT77"
global RHS "lnmburexecfed lnmburexecreg lnmburnoexec lnmpop lninc91 urban91 auton control"
do FGLS
restore
*controls with missing values--use OLS--if not close, no need to reconstruct var matrix for FGLS
reg privDT lnmbur lnmpop lninc91 urban91 auton GovPowerSMD99lib, robust
reg privDT lnmburexecfed lnmburexecreg lnmburnoexec lnmpop lninc91 urban91 auton GovPowerSMD99lib, robust

/* Monitoring and BEEPS regions only */
*to run FGLS, would have to regenerate var matrix, as with no-capital regressions above
reg privDT lnmbur lnmpop lninc91 urban91 auton if monitoring == 1, robust
reg privDT lnmburexecfed lnmburexecreg lnmburnoexec lnmpop lninc91 urban91 auton if monitoring == 1, robust
reg privDT lnmbur lnmpop lninc91 urban91 auton if beeps == 1, robust
reg privDT lnmburexecfed lnmburexecreg lnmburnoexec lnmpop lninc91 urban91 auton if beeps == 1, robust

