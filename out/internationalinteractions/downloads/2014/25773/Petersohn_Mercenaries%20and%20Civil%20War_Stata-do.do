* The Impact of Mercenaries and Private Military Companies on Civil War - do.file
* Ulrich Petersohn
* August 1, 2013
* Stata Version: 12.1


regress Battledeadbest Mercenaries Intervention Democracy Milqual Strongrebel Ethfrac Durationmonth
estat hettest
generate LNBattledead = ln(Battledeadbest)
regress LNBattledead Mercenaries Intervention Democracy Milqual Strongrebel Ethfrac Durationmonth
scatter LNBattledead Mercenaries, mlabel(conflict_name)
predict r, rstudent
stem r
sort r
list conflict_name ID r in 1/10

*findit hilo -> install

hilo r conflict_name ID
drop if ID == 1960
drop if ID == 1040
drop if ID == 1030
drop if ID == 2370

*Results Table 2
regress LNBattledead Mercenaries Intervention Democracy Milqual Strongrebel Ethfrac Durationmonth
regress LNBattledead Mercenaries Intervention Democracy Milqual Strongrebel Ethfrac Durationmonth Conflict_before_89 MercCW
regress LNBattledead Mercenaries Intervention Democracy Milqual Strongrebel Ethfrac Durationmonth Resources MercRes

log close
exit
