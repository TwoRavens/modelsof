cd "SET TO TABLES FOLDER AS DESCRIBED IN README.TXT"
cd "C:\Users\ddoherty\Dropbox\My Work Documents\Tunisia Participation\JOP FINAL FILES\replication archive\tables"

use "..\2012_survey_full.dta", clear


***SUMMARY STATS (APPENDIX TABLE A1)
outsum demonstrate_pre voted demonstrate_post income_mis educ EDnone EDcoll age male employed emp_outofforce emp_student coll_relig polinterest VERYpolinterest rural commit_dem *_was_* gov_* [aw=weight] using "sum_stats", replace bracket
outsum income_ln  if income_mis!=1 [aw=weight] using "sum_stats_inc", replace bracket
drop gov_6

**GENERATE District Level Measures
sort m4_mapid
foreach i in voted demonstrate_pre demonstrate_post income_ln income_mis educ age male employed emp_outofforce emp_student indiv_relig coll_relig polinterest {
by m4_mapid: egen map_`i'_total=total(`i')
replace map_`i'_total=map_`i'_total-`i'
by m4_mapid: egen map_`i'_count=count(`i')
gen map_`i'=map_`i'_total/(map_`i'_count-1)
}
label var map_voted "% District Voting (excluding R)"
label var map_demonstrate_pre "% District Participating in Revolutionary Protests (excluding R)"
label var map_demonstrate_post "% District Participating in Post-election Protests (excluding R)"
label var map_employed "% in District Employed (excluding R)"
label var map_emp_outofforce "% in District Retired/Housewife (excluding R)"
label var map_emp_student "% in District Students (excluding R)"
label var map_income_ln "Avg. District Income (excluding R)"
label var map_income_mis "Avg. District Income Missing (excluding R)"
label var map_educ "Avg. District Education Level (excluding R)"
label var map_male "% in District Male (excluding R)"
label var map_age "Avg. District Age (excluding R)"
label var map_polinterest "Avg. District Interest in Politics (excluding R)"
label var map_indiv_relig "Avg. District Religiosity (excluding R)"
label var map_coll_relig "Avg. District Freq. of Mosque Attend. (excluding R)"

***
//DROP variables retained by authors for other projects. 
egen district=group(m4_mapid)
label var district "District"
drop voted demonstrate_post m4_mapid

save "..\2012_survey.dta", replace
