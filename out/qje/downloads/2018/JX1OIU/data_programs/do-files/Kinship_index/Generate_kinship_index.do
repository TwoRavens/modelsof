*** kinship index
 

* Generate components
gen bilateral=0 if v43!=. & v43!=0
replace bilateral=1 if v43==6
 
gen locality=0 if v11==2 | v11==9
replace locality=1 if v11==1 | v11==3
 
gen nuclear=0 if v8!=. & v8!=0
replace nuclear=1 if v8==1 | v8==2
 
gen clan=0 if v15!=. & v15!=0
replace clan=1 if v15==2 | v15==5 | v15==6
 
 
gen not_bilateral=-bilateral+1
gen not_nuclear=-nuclear+1
 
 
* Compute number of missing components
 
gen kinship_components_missing=0
 
foreach i in  locality nuclear bilateral clan{
replace kinship_components_missing=kinship_components_missing+1 if `i'==.
}

 
* Generate indices
 
egen kinship_score=rowmean(locality not_nuclear not_bilateral clan) if kinship_components_missing<2
egen kinship_score_full=rowmean(locality not_nuclear not_bilateral clan)
 
 
 
label var kinship_score "Kinship tightness"
label var kinship_score_full "Kinship tightness incl. missings"
label var nuclear "Nuclear family"
label var bilateral "Bilateral descent"
label var locality "Joint residence"
label var clan "Localized clans"
label var kinship_components_missing "Number of missing kinship score components"
