set mem 400m
set matsize 800
set more off

*Duration Analysis--Early vs. late--non-proportional hazards

*Correlation Matrices
use "C:\Documents and Settings\ZacharyS\My Documents\Research\Working Projects\How Many and When--Effects of Joining\Stats\wars by day.dta", clear
correlate j3mnoearly j3mearly participantsall mpin gpboth deminall mixedimall relcapii rivalall territory regime oadm oada oadp opda rterrain
correlate j3mnoearlymaj j3mearlymaj participantsmajor mpin gpboth deminmajor mixedimmajor relcapii rivalmajor territory regime oadm oada oadp opda rterrain

*Table II, Column 1
stset duration, id(number) failure(failure==1)
streg j3mnoearly j3mearly participantsall mpin gpboth deminall mixedimall relcapii rivalall territory regime oadm oada oadp opda rterrain, dist(weibull) ancillary (j3mnoearly) vce(robust) nohr nolog
predict estimate
drop if estimate==.
gen error = fullduration - estimate
correlate error j3mnoearly j3mearly
use "C:\Documents and Settings\ZacharyS\My Documents\Research\Working Projects\How Many and When--Effects of Joining\Stats\predict.dta", clear
stset duration,
predict newvar
list newvar
*Dropping >.6 correlation variables check
use "C:\Documents and Settings\ZacharyS\My Documents\Research\Working Projects\How Many and When--Effects of Joining\Stats\wars by day.dta", clear
stset duration, id(number) failure(failure==1)
streg j3mnoearly j3mearly participantsall mpin deminall mixedimall relcapii rivalall territory oadm opda oada rterrain, dist(weibull) ancillary (j3mnoearly) vce(robust) nohr nolog
*rate of depreciation check
streg j1mnoearly j1mearly participantsall mpin gpboth deminall mixedimall relcapii rivalall territory regime oadm oada oadp opda rterrain, dist(weibull) ancillary (j1mnoearly) vce(robust) nohr nolog
streg j2mnoearly j2mearly participantsall mpin gpboth deminall mixedimall relcapii rivalall territory regime oadm oada oadp opda rterrain, dist(weibull) ancillary (j2mnoearly) vce(robust) nohr nolog
streg j6mnoearly j6mearly participantsall mpin gpboth deminall mixedimall relcapii rivalall territory regime oadm oada oadp opda rterrain, dist(weibull) ancillary (j6mnoearly) vce(robust) nohr nolog
streg j1ynoearly j1yearly participantsall mpin gpboth deminall mixedimall relcapii rivalall territory regime oadm oada oadp opda rterrain, dist(weibull) ancillary (j1ynoearly) vce(robust) nohr nolog
streg j2ynoearly j2yearly participantsall mpin gpboth deminall mixedimall relcapii rivalall territory regime oadm oada oadp opda rterrain, dist(weibull) ancillary (j2ynoearly) vce(robust) nohr nolog
*cutoff check
streg j3mnoearlyalt3m j3mearlyalt3m participantsall mpin gpboth deminall mixedimall relcapii rivalall territory regime oadm oada oadp opda rterrain, dist(weibull) ancillary (j3mnoearlyalt3m) vce(robust) nohr nolog
streg j3mnoearlyalt6m j3mearlyalt6m participantsall mpin gpboth deminall mixedimall relcapii rivalall territory regime oadm oada oadp opda rterrain, dist(weibull) ancillary (j3mnoearlyalt6m) vce(robust) nohr nolog
*previous war check
streg j3mnoearly j3mearly participantsall mpin gpboth deminall mixedimall relcapii rivalall territory regime oadm oada oadp opda rterrain previous, dist(weibull) ancillary (j3mnoearly) vce(robust) nohr nolog

*Table II, Column 2
streg j3mnoearly j3mearly participantsall mpin gpboth deminall mixedimall relcapii rivalall territory regime, dist(weibull) ancillary (j3mnoearly) vce(robust) nohr nolog
predict estimate
drop if estimate==.
gen error = fullduration - estimate
correlate error j3mnoearly j3mearly
use "C:\Documents and Settings\ZacharyS\My Documents\Research\Working Projects\How Many and When--Effects of Joining\Stats\predict.dta", clear
stset duration,
predict newvar
list newvar
*Dropping >.6 correlation variables check
use "C:\Documents and Settings\ZacharyS\My Documents\Research\Working Projects\How Many and When--Effects of Joining\Stats\wars by day.dta", clear
stset duration, id(number) failure(failure==1)
streg j3mnoearly j3mearly participantsall mpin deminall mixedimall relcapii rivalall territory regime, dist(weibull) ancillary (j3mnoearly) vce(robust) nohr nolog
*rate of depreciation check
streg j1mnoearly j1mearly participantsall mpin gpboth deminall mixedimall relcapii rivalall territory regime, dist(weibull) ancillary (j1mnoearly) vce(robust) nohr nolog
streg j2mnoearly j2mearly participantsall mpin gpboth deminall mixedimall relcapii rivalall territory regime, dist(weibull) ancillary (j2mnoearly) vce(robust) nohr nolog
streg j6mnoearly j6mearly participantsall mpin gpboth deminall mixedimall relcapii rivalall territory regime, dist(weibull) ancillary (j6mnoearly) vce(robust) nohr nolog
streg j1ynoearly j1yearly participantsall mpin gpboth deminall mixedimall relcapii rivalall territory regime, dist(weibull) ancillary (j1ynoearly) vce(robust) nohr nolog
streg j2ynoearly j2yearly participantsall mpin gpboth deminall mixedimall relcapii rivalall territory regime, dist(weibull) ancillary (j2ynoearly) vce(robust) nohr nolog
*cutoff check
streg j3mnoearlyalt3m j3mearlyalt3m participantsall mpin gpboth deminall mixedimall relcapii rivalall territory regime, dist(weibull) ancillary (j3mnoearlyalt3m) vce(robust) nohr nolog
streg j3mnoearlyalt6m j3mearlyalt6m participantsall mpin gpboth deminall mixedimall relcapii rivalall territory regime, dist(weibull) ancillary (j3mnoearlyalt6m) vce(robust) nohr nolog
*previous war check
streg j3mnoearly j3mearly participantsall mpin gpboth deminall mixedimall relcapii rivalall territory regime previous, dist(weibull) ancillary (j3mnoearly) vce(robust) nohr nolog

*Table II, Column 3
streg j3mnoearlymaj j3mearlymaj participantsmajor mpin gpboth deminmajor mixedimmajor relcapii rivalmajor territory regime oadm oada oadp opda rterrain, dist(weibull) ancillary (j3mnoearlymaj) vce(robust) nohr nolog
predict estimate
drop if estimate==.
gen error = fullduration - estimate
correlate error j3mnoearlymaj j3mearlymaj
use "C:\Documents and Settings\ZacharyS\My Documents\Research\Working Projects\How Many and When--Effects of Joining\Stats\predict.dta", clear
stset duration,
predict newvar
list newvar
*Dropping >.6 correlation variables check
use "C:\Documents and Settings\ZacharyS\My Documents\Research\Working Projects\How Many and When--Effects of Joining\Stats\wars by day.dta", clear
stset duration, id(number) failure(failure==1)
streg j3mnoearlymaj j3mearlymaj participantsmajor mpin deminmajor mixedimmajor relcapii rivalmajor territory oadm oada opda rterrain, dist(weibull) ancillary (j3mnoearlymaj) vce(robust) nohr nolog
*rate of depreciation check
streg j1mnoearlymaj j1mearlymaj participantsmajor mpin gpboth deminmajor mixedimmajor relcapii rivalmajor territory regime oadm oada oadp opda rterrain, dist(weibull) ancillary (j1mnoearlymaj) vce(robust) nohr nolog
streg j2mnoearlymaj j2mearlymaj participantsmajor mpin gpboth deminmajor mixedimmajor relcapii rivalmajor territory regime oadm oada oadp opda rterrain, dist(weibull) ancillary (j2mnoearlymaj) vce(robust) nohr nolog
streg j6mnoearlymaj j6mearlymaj participantsmajor mpin gpboth deminmajor mixedimmajor relcapii rivalmajor territory regime oadm oada oadp opda rterrain, dist(weibull) ancillary (j6mnoearlymaj) vce(robust) nohr nolog
streg j1ynoearlymaj j1yearlymaj participantsmajor mpin gpboth deminmajor mixedimmajor relcapii rivalmajor territory regime oadm oada oadp opda rterrain, dist(weibull) ancillary (j1ynoearlymaj) vce(robust) nohr nolog
streg j2ynoearlymaj j2yearlymaj participantsmajor mpin gpboth deminmajor mixedimmajor relcapii rivalmajor territory regime oadm oada oadp opda rterrain, dist(weibull) ancillary (j2ynoearlymaj) vce(robust) nohr nolog
*cutoff check
streg j3mnoearlymajalt3m j3mearlymajalt3m participantsall mpin gpboth deminall mixedimall relcapii rivalall territory regime oadm oada oadp opda rterrain, dist(weibull) ancillary (j3mnoearlymajalt3m) vce(robust) nohr nolog
streg j3mnoearlymajalt6m j3mearlymajalt6m participantsall mpin gpboth deminall mixedimall relcapii rivalall territory regime oadm oada oadp opda rterrain, dist(weibull) ancillary (j3mnoearlymajalt6m) vce(robust) nohr nolog
* previous war check
streg j3mnoearlymaj j3mearlymaj participantsmajor mpin gpboth deminmajor mixedimmajor relcapii rivalmajor territory regime oadm oada oadp opda rterrain previous, dist(weibull) ancillary (j3mnoearlymaj) vce(robust) nohr nolog

*Table II, Column 4
streg j3mnoearlymaj j3mearlymaj participantsmajor mpin gpboth deminmajor mixedimmajor relcapii rivalmajor territory regime, dist(weibull) ancillary (j3mnoearlymaj) vce(robust) nohr nolog
predict estimate
drop if estimate==.
gen error = fullduration - estimate
correlate error j3mnoearlymaj j3mearlymaj
use "C:\Documents and Settings\ZacharyS\My Documents\Research\Working Projects\How Many and When--Effects of Joining\Stats\predict.dta", clear
stset duration,
predict newvar
list newvar
drop newvar
*Dropping >.6 correlation variables check
use "C:\Documents and Settings\ZacharyS\My Documents\Research\Working Projects\How Many and When--Effects of Joining\Stats\wars by day.dta", clear
stset duration, id(number) failure(failure==1)
streg j3mnoearlymaj j3mearlymaj participantsmajor mpin deminmajor mixedimmajor relcapii rivalmajor territory regime, dist(weibull) ancillary (j3mnoearlymaj) vce(robust) nohr nolog
*rate of depreciation check
streg j1mnoearlymaj j1mearlymaj participantsmajor mpin gpboth deminmajor mixedimmajor relcapii rivalmajor territory regime, dist(weibull) ancillary (j1mnoearlymaj) vce(robust) nohr nolog
streg j2mnoearlymaj j2mearlymaj participantsmajor mpin gpboth deminmajor mixedimmajor relcapii rivalmajor territory regime, dist(weibull) ancillary (j2mnoearlymaj) vce(robust) nohr nolog
streg j6mnoearlymaj j6mearlymaj participantsmajor mpin gpboth deminmajor mixedimmajor relcapii rivalmajor territory regime, dist(weibull) ancillary (j6mnoearlymaj) vce(robust) nohr nolog
streg j1ynoearlymaj j1yearlymaj participantsmajor mpin gpboth deminmajor mixedimmajor relcapii rivalmajor territory regime, dist(weibull) ancillary (j1ynoearlymaj) vce(robust) nohr nolog
streg j2ynoearlymaj j2yearlymaj participantsmajor mpin gpboth deminmajor mixedimmajor relcapii rivalmajor territory regime, dist(weibull) ancillary (j2ynoearlymaj) vce(robust) nohr nolog
*cutoff check
streg j3mnoearlymajalt3m j3mearlymajalt3m participantsall mpin gpboth deminall mixedimall relcapii rivalall territory regime, dist(weibull) ancillary (j3mnoearlymajalt3m) vce(robust) nohr nolog
streg j3mnoearlymajalt6m j3mearlymajalt6m participantsall mpin gpboth deminall mixedimall relcapii rivalall territory regime, dist(weibull) ancillary (j3mnoearlymajalt6m) vce(robust) nohr nolog
* previous war check
streg j3mnoearlymaj j3mearlymaj participantsmajor mpin gpboth deminmajor mixedimmajor relcapii rivalmajor territory regime previous, dist(weibull) ancillary (j3mnoearlymaj) vce(robust) nohr nolog

*Vietnam check
drop if number==163
streg j3mnoearly j3mearly participantsall mpin gpboth deminall mixedimall relcapii rivalall territory regime oadm oada oadp opda rterrain, dist(weibull) ancillary (j3mnoearly) vce(robust) nohr nolog
streg j3mnoearly j3mearly participantsall mpin gpboth deminall mixedimall relcapii rivalall territory regime, dist(weibull) ancillary (j3mnoearly) vce(robust) nohr nolog
streg j3mnoearlymaj j3mearlymaj participantsmajor mpin gpboth deminmajor mixedimmajor relcapii rivalmajor territory regime oadm oada oadp opda rterrain, dist(weibull) ancillary (j3mnoearlymaj) vce(robust) nohr nolog
streg j3mnoearlymaj j3mearlymaj participantsmajor mpin gpboth deminmajor mixedimmajor relcapii rivalmajor territory regime, dist(weibull) ancillary (j3mnoearlymaj) vce(robust) nohr nolog

*World War Checks
use "C:\Documents and Settings\ZacharyS\My Documents\Research\Working Projects\How Many and When--Effects of Joining\Stats\wars by day.dta", clear
stset duration, id(number) failure(failure==1)
drop if number==106
drop if number==136
drop if number==130
streg j3mnoearly j3mearly participantsall mpin gpboth deminall mixedimall relcapii rivalall territory regime oadm oada oadp opda rterrain, dist(weibull) ancillary (j3mnoearly) vce(robust) nohr nolog
streg j3mnoearly j3mearly participantsall mpin gpboth deminall mixedimall relcapii rivalall territory regime, dist(weibull) ancillary (j3mnoearly) vce(robust) nohr nolog
streg j3mnoearlymaj j3mearlymaj participantsmajor mpin gpboth deminmajor mixedimmajor relcapii rivalmajor territory regime oadm oada oadp opda rterrain, dist(weibull) ancillary (j3mnoearlymaj) vce(robust) nohr nolog
streg j3mnoearlymaj j3mearlymaj participantsmajor mpin gpboth deminmajor mixedimmajor relcapii rivalmajor territory regime, dist(weibull) ancillary (j3mnoearlymaj) vce(robust) nohr nolog

*UN check
streg j3mnoearly j3mearly participantsall mpin gpboth deminall mixedimall relcapii rivalall territory regime oadm oada oadp opda rterrain un, dist(weibull) ancillary (j3mnoearly) vce(robust) nohr nolog
streg j3mnoearly j3mearly participantsall mpin gpboth deminall mixedimall relcapii rivalall territory regime un, dist(weibull) ancillary (j3mnoearly) vce(robust) nohr nolog
streg j3mnoearlymaj j3mearlymaj participantsmajor mpin gpboth deminmajor mixedimmajor relcapii rivalmajor territory regime oadm oada oadp opda rterrain un, dist(weibull) ancillary (j3mnoearlymaj) vce(robust) nohr nolog
streg j3mnoearlymaj j3mearlymaj participantsmajor mpin gpboth deminmajor mixedimmajor relcapii rivalmajor territory regime un, dist(weibull) ancillary (j3mnoearlymaj) vce(robust) nohr nolog

*duration transformation check for Table II
use "C:\Documents and Settings\ZacharyS\My Documents\Research\Working Projects\How Many and When--Effects of Joining\Stats\wars by day.dta", clear
gen logduration = log(duration)
stset logduration, id(number) failure(failure==1)
streg j3mnoearly j3mearly participantsall mpin gpboth deminall mixedimall relcapii rivalall territory regime oadm oada oadp opda rterrain, dist(weibull) ancillary (j3mnoearly) vce(robust) nohr nolog
streg j3mnoearly j3mearly participantsall mpin gpboth deminall mixedimall relcapii rivalall territory regime, dist(weibull) ancillary (j3mnoearly) vce(robust) nohr nolog
streg j3mnoearlymaj j3mearlymaj participantsmajor mpin gpboth deminmajor mixedimmajor relcapii rivalmajor territory regime oadm oada oadp opda rterrain, dist(weibull) ancillary (j3mnoearlymaj) vce(robust) nohr nolog
streg j3mnoearlymaj j3mearlymaj participantsmajor mpin gpboth deminmajor mixedimmajor relcapii rivalmajor territory regime, dist(weibull) ancillary (j3mnoearlymaj) vce(robust) nohr nolog

*Duration--one vs. two sided & early and late--Cox
*Table IV, Column 1
use "C:\Documents and Settings\ZacharyS\My Documents\Research\Working Projects\How Many and When--Effects of Joining\Stats\all belligerents.dta", clear
stset duration, id(number) failure(failure==1)
correlate earlyonesided earlytwosided lateonesided latetwosided participants mpin gpboth demin mixedim relcapii rival territory regime punishment maneuver rterrain
stcox earlyonesided earlytwosided lateonesided latetwosided participants mpin gpboth demin mixedim relcapii rival territory regime punishment maneuver rterrain, vce(robust) nolog
predict estimate
drop if estimate==.
gen error = duration - estimate
correlate error earlyonesided earlytwosided lateonesided latetwosided
drop error estimate
*Mid Year RelCap check
stcox earlyonesided earlytwosided lateonesided latetwosided participants mpin gpboth demin mixedim relcapiimidyear rival territory regime punishment maneuver rterrain, vce(robust) nolog
*Dropping >.6 correlation variables check
stcox earlyonesided earlytwosided lateonesided latetwosided mpin gpboth demin mixedim relcapii rival territory regime punishment maneuver rterrain, vce(robust) nolog
* Previous wars check
stcox earlyonesided earlytwosided lateonesided latetwosided participants mpin gpboth demin mixedim relcapii rival territory regime punishment maneuver rterrain, vce(robust) nolog strata(previouswar)

*Table IV, Column 2
use "C:\Documents and Settings\ZacharyS\My Documents\Research\Working Projects\How Many and When--Effects of Joining\Stats\all belligerents.dta", clear
stset duration, id(number) failure(failure==1)
stcox earlyonesided earlytwosided lateonesided latetwosided participants mpin gpboth demin mixedim relcapii rival territory regime, vce(robust) nolog
predict estimate
drop if estimate==.
gen error = duration - estimate
correlate error earlyonesided earlytwosided lateonesided latetwosided
*Midyear RelCap Check
stcox earlyonesided earlytwosided lateonesided latetwosided participants mpin gpboth demin mixedim relcapiimidyear rival territory regime, vce(robust) nolog
*Dropping >.6 correlation variables check
stcox earlyonesided earlytwosided lateonesided latetwosided mpin gpboth demin mixedim relcapii rival territory regime, vce(robust) nolog
*Previous wars check
stcox earlyonesided earlytwosided lateonesided latetwosided participants mpin gpboth demin mixedim relcapii rival territory regime, vce(robust) nolog strata(previouswar)

*World War check for all belligerents
drop if number==106
drop if number==136
drop if number==130
stcox earlyonesided earlytwosided lateonesided latetwosided participants mpin gpboth demin mixedim relcapii rival territory regime punishment maneuver rterrain, vce(robust) nolog
stcox earlyonesided earlytwosided lateonesided latetwosided participants mpin gpboth demin mixedim relcapiimidyear rival territory regime, vce(robust) nolog

*Table IV, Column 3
use "C:\Documents and Settings\ZacharyS\My Documents\Research\Working Projects\How Many and When--Effects of Joining\Stats\major belligerents.dta", clear
stset duration, id(number) failure(failure==1)
correlate earlyonesided earlytwosided lateonesided latetwosided participants mpin gpboth demin mixedim relcapii rival territory regime punishment maneuver rterrain
stcox earlyonesided earlytwosided lateonesided latetwosided participants mpin gpboth demin mixedim relcapii rival territory regime punishment maneuver rterrain, vce(robust) nolog
predict estimate
drop if estimate==.
gen error = duration - estimate
correlate error earlyonesided earlytwosided lateonesided latetwosided
drop error estimate
*Mid Year RelCap check
stcox earlyonesided earlytwosided lateonesided latetwosided participants mpin gpboth demin mixedim relcapiimidyear rival territory regime punishment maneuver rterrain, vce(robust) nolog
*Dropping >.6 correlation variables check
stcox earlyonesided earlytwosided lateonesided latetwosided mpin gpboth demin mixedim relcapii rival territory regime punishment maneuver rterrain, vce(robust) nolog
* Previous wars check
stcox earlyonesided earlytwosided lateonesided latetwosided participants mpin gpboth demin mixedim relcapii rival territory regime punishment maneuver rterrain, vce(robust) nolog strata(previouswar)

*Table IV, Column 4
use "C:\Documents and Settings\ZacharyS\My Documents\Research\Working Projects\How Many and When--Effects of Joining\Stats\major belligerents.dta", clear
stset duration, id(number) failure(failure==1)
stcox earlyonesided earlytwosided lateonesided latetwosided participants mpin gpboth demin mixedim relcapii rival territory regime, vce(robust) nolog
predict estimate
drop if estimate==.
gen error = duration - estimate
correlate error earlyonesided earlytwosided lateonesided latetwosided
*Midyear RelCap Check
stcox earlyonesided earlytwosided lateonesided latetwosided participants mpin gpboth demin mixedim relcapiimidyear rival territory regime, vce(robust) nolog
*Dropping >.6 correlation variables check
stcox earlyonesided earlytwosided lateonesided latetwosided mpin gpboth demin mixedim relcapii rival territory regime, vce(robust) nolog
*Previous wars check
stcox earlyonesided earlytwosided lateonesided latetwosided participants mpin gpboth demin mixedim relcapii rival territory regime, vce(robust) nolog strata(previouswar)

*World War check for all belligerents
drop if number==106
drop if number==136
drop if number==130
stcox earlyonesided earlytwosided lateonesided latetwosided participants mpin gpboth demin mixedim relcapii rival territory regime punishment maneuver rterrain, vce(robust) nolog
stcox earlyonesided earlytwosided lateonesided latetwosided participants mpin gpboth demin mixedim relcapii rival territory regime, vce(robust) nolog

*Vietnam check
use "C:\Documents and Settings\ZacharyS\My Documents\Research\Working Projects\How Many and When--Effects of Joining\Stats\all belligerents.dta", clear
stset duration, id(number) failure(failure==1)
drop if number==163
stcox earlyonesided earlytwosided lateonesided latetwosided participants mpin gpboth demin mixedim relcapii rival territory regime punishment maneuver rterrain, vce(robust) nolog
stcox earlyonesided earlytwosided lateonesided latetwosided participants mpin gpboth demin mixedim relcapii rival territory regime, vce(robust) nolog

use "C:\Documents and Settings\ZacharyS\My Documents\Research\Working Projects\How Many and When--Effects of Joining\Stats\major belligerents.dta", clear
drop if number==163
stset duration, id(number) failure(failure==1)
stcox earlyonesided earlytwosided lateonesided latetwosided participants mpin gpboth demin mixedim relcapii rival territory regime punishment maneuver rterrain, vce(robust) nolog
stcox earlyonesided earlytwosided lateonesided latetwosided participants mpin gpboth demin mixedim relcapii rival territory regime, vce(robust) nolog

*duration transformation check for Table IV
use "C:\Documents and Settings\ZacharyS\My Documents\Research\Working Projects\How Many and When--Effects of Joining\Stats\all belligerents.dta", clear
gen logduration = log(duration)
stset logduration, id(number) failure(failure==1)
stcox earlyonesided earlytwosided lateonesided latetwosided participants mpin gpboth demin mixedim relcapii rival territory regime punishment maneuver rterrain, vce(robust) nolog
stcox earlyonesided earlytwosided lateonesided latetwosided participants mpin gpboth demin mixedim relcapii rival territory regime, vce(robust) nolog

use "C:\Documents and Settings\ZacharyS\My Documents\Research\Working Projects\How Many and When--Effects of Joining\Stats\major belligerents.dta", clear
gen logduration = log(duration)
stset logduration, id(number) failure(failure==1)
stcox earlyonesided earlytwosided lateonesided latetwosided participants mpin gpboth demin mixedim relcapii rival territory regime punishment maneuver rterrain, vce(robust) nolog
stcox earlyonesided earlytwosided lateonesided latetwosided participants mpin gpboth demin mixedim relcapii rival territory regime, vce(robust) nolog

*Severity--OLS
*Table V, Column 1
use "C:\Documents and Settings\ZacharyS\My Documents\Research\Working Projects\How Many and When--Effects of Joining\Stats\all belligerents.dta", clear
gen logdeaths = log(deaths)
correlate logdeaths duration earlyjoining latejoining participants mpin gpboth demin mixedim relcapii rival territory regime oadm oada oadp opda rterrain
regress logdeaths duration earlyjoining latejoining participants mpin gpboth demin mixedim relcapii rival territory regime oadm oada oadp opda rterrain, vce(robust)
estat vif
*Midyear RelCap check
regress logdeaths duration earlyjoining latejoining participants mpin gpboth demin mixedim relcapiimidyear rival territory regime oadm oada oadp opda rterrain, vce(robust)
*Dropping >.6 correlation variables check
regress logdeaths duration earlyjoining latejoining mpin gpboth demin mixedim relcapii rival territory regime oada oadp opda rterrain, vce(robust)

*Table V, Column 2
regress logdeaths duration earlyjoining latejoining participants mpin gpboth demin mixedim relcapii rival territory regime, vce(robust)
estat vif
*Midyear Relcap check
regress logdeaths duration earlyjoining latejoining participants mpin gpboth demin mixedim relcapiimidyear rival territory regime, vce(robust)
*Dropping >.6 correlation variables check
regress logdeaths duration earlyjoining latejoining mpin gpboth demin mixedim relcapii rival territory regime, vce(robust)

*World War Check
drop if number==106
drop if number==136
drop if number==130
regress logdeaths duration earlyjoining latejoining participants mpin gpboth demin mixedim relcapii rival territory regime oadm oada oadp opda rterrain, vce(robust)
regress logdeaths duration earlyjoining latejoining participants mpin gpboth demin mixedim relcapii rival territory regime, vce(robust)

* UN check
regress logdeaths duration earlyjoining latejoining participants mpin gpboth demin mixedim relcapii rival territory regime oadm oada oadp opda rterrain un, vce(robust)
regress logdeaths duration earlyjoining latejoining participants mpin gpboth demin mixedim relcapii rival territory regime un, vce(robust)

* previous war check
regress logdeaths duration earlyjoining latejoining participants mpin gpboth demin mixedim relcapii rival territory regime oadm oada oadp opda rterrain previouswar, vce(robust)
regress logdeaths duration earlyjoining latejoining participants mpin gpboth demin mixedim relcapii rival territory regime previouswar, vce(robust)

*Table V, Column 3
use "C:\Documents and Settings\ZacharyS\My Documents\Research\Working Projects\How Many and When--Effects of Joining\Stats\major belligerents.dta", clear
gen logdeaths = log(deaths)
correlate logdeaths duration earlyjoining latejoining participants mpin gpboth demin mixedim relcapii rival territory regime oadm oada oadp opda rterrain
regress logdeaths duration earlyjoining latejoining participants mpin gpboth demin mixedim relcapii rival territory regime oadm oada oadp opda rterrain, vce(robust)
estat vif
*Midyear Relcap Check
regress logdeaths duration earlyjoining latejoining participants mpin gpboth demin mixedim relcapiimidyear rival territory regime oadm oada oadp opda rterrain, vce(robust)
*Dropping >.6 correlation variables check
regress logdeaths duration earlyjoining latejoining mpin gpboth demin mixedim relcapii rival territory regime oada oadp opda rterrain, vce(robust)

*Table V, Column 4
regress logdeaths duration earlyjoining latejoining participants mpin gpboth demin mixedim relcapii rival territory regime, vce(robust)
estat vif
*Midyear relcap check
regress logdeaths duration earlyjoining latejoining participants mpin gpboth demin mixedim relcapiimidyear rival territory regime, vce(robust)
*Dropping >.6 correlation variables check
regress logdeaths duration earlyjoining latejoining mpin gpboth demin mixedim relcapii rival territory regime, vce(robust)

*World War Check
drop if number==106
drop if number==136
drop if number==130
regress logdeaths duration earlyjoining latejoining participants mpin gpboth demin mixedim relcapii rival territory regime oadm oada oadp opda rterrain, vce(robust)
regress logdeaths duration earlyjoining latejoining participants mpin gpboth demin mixedim relcapii rival territory regime, vce(robust)

* UN check
regress logdeaths duration earlyjoining latejoining participants mpin gpboth demin mixedim relcapii rival territory regime oadm oada oadp opda rterrain un, vce(robust)
regress logdeaths duration earlyjoining latejoining participants mpin gpboth demin mixedim relcapii rival territory regime un, vce(robust)

* previous war check
regress logdeaths duration earlyjoining latejoining participants mpin gpboth demin mixedim relcapii rival territory regime oadm oada oadp opda rterrain previouswar, vce(robust)
regress logdeaths duration earlyjoining latejoining participants mpin gpboth demin mixedim relcapii rival territory regime previouswar, vce(robust)

*duration transformation check for Table V
use "C:\Documents and Settings\ZacharyS\My Documents\Research\Working Projects\How Many and When--Effects of Joining\Stats\all belligerents.dta", clear
gen logdeaths = log(deaths)
gen logduration = log(duration)
regress logdeaths logduration earlyjoining latejoining participants mpin gpboth demin mixedim relcapii rival territory regime oadm oada oadp opda rterrain, vce(robust)
regress logdeaths logduration earlyjoining latejoining participants mpin gpboth demin mixedim relcapiimidyear rival territory regime, vce(robust)

use "C:\Documents and Settings\ZacharyS\My Documents\Research\Working Projects\How Many and When--Effects of Joining\Stats\major belligerents.dta", clear
gen logdeaths = log(deaths)
gen logduration = log(duration)
regress logdeaths logduration earlyjoining latejoining participants mpin gpboth demin mixedim relcapii rival territory regime oadm oada oadp opda rterrain, vce(robust)
regress logdeaths logduration earlyjoining latejoining participants mpin gpboth demin mixedim relcapiimidyear rival territory regime, vce(robust)

