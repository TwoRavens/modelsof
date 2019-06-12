cd "/Users/kenwick2/Dropbox/jop_response"

use "Johnson&LeedsFPA.dta", clear
set more off
sort ddyad year
*generate a separate indicator for every alliance ID column to 
*indicate whether the alliance is recently formed.  Alliances
*from birth are excluded. 
forval i = 1/13{
gen new_`i' = ddyad==ddyad[_n-1] & t_def_atopid`i'!=. & ///
	t_def_atopid`i'!=t_def_atopid1[_n-1] & ///
	t_def_atopid`i'!=t_def_atopid2[_n-1] & ///
	t_def_atopid`i'!=t_def_atopid3[_n-1] & ///
	t_def_atopid`i'!=t_def_atopid4[_n-1] & ///
	t_def_atopid`i'!=t_def_atopid5[_n-1] & ///
	t_def_atopid`i'!=t_def_atopid6[_n-1] & ///
	t_def_atopid`i'!=t_def_atopid7[_n-1] & ///
	t_def_atopid`i'!=t_def_atopid8[_n-1] & ///
	t_def_atopid`i'!=t_def_atopid9[_n-1] & ///
	t_def_atopid`i'!=t_def_atopid10[_n-1] & ///
	t_def_atopid`i'!=t_def_atopid11[_n-1] & ///
	t_def_atopid`i'!=t_def_atopid12[_n-1] & ///
	t_def_atopid`i'!=t_def_atopid13[_n-1] 
}
*Generate an indicator that says whether any of the current alliances
*were formed this year (again, excluding alliances "from birth")
gen def_form = (new_1==1 | new_2==1 | new_3==1 | new_4==1 | ///
	new_5==1 | new_6==1 | new_7==1 | new_8==1 | new_9==1 | ///
	new_10==1 | new_11==1 | new_12==1 | new_13==1)

forval t = 1/4{
	*bring in "new_" and id indicators from previous obs., provided it is 
	*from the same directed dyad and within 5 years of the current obs.
	forval i = 1/13{
		gen new_l`t'_`i' = new_`i'[_n-`t'] if ddyad==ddyad[_n-`t'] & ///
		year[_n-`t']>=year-5
		gen l`t'_t_def_atopid`i' = t_def_atopid`i'[_n-`t'] if ///
		ddyad==ddyad[_n-`t'] & year[_n-`t']>=year-5
		}
	
	*generate an indicator of whether any of the alliances from the
	*previous obs were new and still around
	gen def_form_l`t' = 0
	forval i = 1/13{
		replace def_form_l`t' = 1 if new_l`t'_`i' == 1 & ( ///
		l`t'_t_def_atopid`i' == t_def_atopid1 | ///
		l`t'_t_def_atopid`i' == t_def_atopid2 | ///
		l`t'_t_def_atopid`i' == t_def_atopid3 | ///
		l`t'_t_def_atopid`i' == t_def_atopid4 | ///
		l`t'_t_def_atopid`i' == t_def_atopid5 | ///
		l`t'_t_def_atopid`i' == t_def_atopid6 | ///
		l`t'_t_def_atopid`i' == t_def_atopid7 | ///
		l`t'_t_def_atopid`i' == t_def_atopid8 | ///
		l`t'_t_def_atopid`i' == t_def_atopid9 | ///
		l`t'_t_def_atopid`i' == t_def_atopid10 | ///
		l`t'_t_def_atopid`i' == t_def_atopid11 | ///
		l`t'_t_def_atopid`i' == t_def_atopid12 | ///
		l`t'_t_def_atopid`i' == t_def_atopid13 ///
		)
		}

	drop new_l`t'* l`t'_t_def*
}	
gen def_form_5yr = (def_form==1 | def_form_l1==1 | ///
	def_form_l2==1 | def_form_l3==1 | def_form_l4==1 )	
	
	
drop def_form_l1 def_form_l2 def_form_l3 def_form_l4 	

	
forval t = 1/14{
	*bring in "new_" and id indicators from previous obs., provided it is 
	*from the same directed dyad and within 5 years of the current obs.
	forval i = 1/13{
		gen new_l`t'_`i' = new_`i'[_n-`t'] if ddyad==ddyad[_n-`t'] & ///
		year[_n-`t']>=year-15
		gen l`t'_t_def_atopid`i' = t_def_atopid`i'[_n-`t'] if ///
		ddyad==ddyad[_n-`t'] & year[_n-`t']>=year-15
		}
	
	*generate an indicator of whether any of the alliances from the
	*previous obs were new, and still around
	gen def_form_l`t' = 0
	forval i = 1/13{
		replace def_form_l`t' = 1 if new_l`t'_`i' == 1 & ( ///
		l`t'_t_def_atopid`i' == t_def_atopid1 | ///
		l`t'_t_def_atopid`i' == t_def_atopid2 | ///
		l`t'_t_def_atopid`i' == t_def_atopid3 | ///
		l`t'_t_def_atopid`i' == t_def_atopid4 | ///
		l`t'_t_def_atopid`i' == t_def_atopid5 | ///
		l`t'_t_def_atopid`i' == t_def_atopid6 | ///
		l`t'_t_def_atopid`i' == t_def_atopid7 | ///
		l`t'_t_def_atopid`i' == t_def_atopid8 | ///
		l`t'_t_def_atopid`i' == t_def_atopid9 | ///
		l`t'_t_def_atopid`i' == t_def_atopid10 | ///
		l`t'_t_def_atopid`i' == t_def_atopid11 | ///
		l`t'_t_def_atopid`i' == t_def_atopid12 | ///
		l`t'_t_def_atopid`i' == t_def_atopid13 ///
		)
		}

	drop new_l`t'* l`t'_t_def*
}	
gen def_form_15yr = (def_form==1 | def_form_l1==1 | ///
	def_form_l2==1 | def_form_l3==1 | def_form_l4==1 ///
	| def_form_l5==1 | def_form_l6==1 | def_form_l7==1 ///
	| def_form_l8==1 | def_form_l9==1 | def_form_l10==1 | ///
	def_form_l11==1 | def_form_l12==1 | def_form_l13==1 ///
	| def_form_l14==1 )
	
gen def_form_6to15 = (ptargdef==1 & def_form_5yr==0 & def_form_15yr==1)


***Identifying alliances from indepenence
*indicator if an observation is the ddyad's first
sort ddyad year
gen enter = 1 if ddyad!=ddyad[_n-1]
*year indicator
gen entry_yr = year if enter==1

*generate new variables that record each of the alliances in year 1,
*use egen to expand this out for the entire dyad
forval i = 1/13{
	gen birth_def_`i' = t_def_atopid`i' if enter==1
	egen birth_def`i' = max(birth_def_`i'), by(ddyad)
	drop birth_def_*
}
*for each observation, check if each alliance has the same ID as
*any of those recorded at birth
forval i = 1/13{
	gen from_birth`i' = t_def_atopid`i'!=. & ( ///
	t_def_atopid`i'== birth_def1 | ///
	t_def_atopid`i'== birth_def2 | ///
	t_def_atopid`i'== birth_def3 | ///
	t_def_atopid`i'== birth_def4 | ///
	t_def_atopid`i'== birth_def5 | ///
	t_def_atopid`i'== birth_def6 | ///
	t_def_atopid`i'== birth_def7 | ///
	t_def_atopid`i'== birth_def8 | ///
	t_def_atopid`i'== birth_def9 | ///
	t_def_atopid`i'== birth_def10 | ///
	t_def_atopid`i'== birth_def11 | ///
	t_def_atopid`i'== birth_def12 | ///
	t_def_atopid`i'== birth_def13) 
	*make missing if def ID indicator is missing
	replace from_birth`i' = . if t_def_atopid`i'==.
}

*generate a variable that indicates whether all of a state's current
*alliances were also in place at birth
egen all_from_birth = rowmin(from_birth1 from_birth2 from_birth3 ///
	from_birth4 from_birth5 from_birth6 from_birth7 from_birth8 ///
		from_birth9 from_birth10 from_birth11 from_birth12 from_birth13)
replace all_from_birth = 0 if all_from_birth==.

*generate an indicator if any of a states current defensive alliances
*were in place at birth
egen fbdef = rowmax(from_birth1 from_birth2 from_birth3 from_birth4 from_birth5 from_birth6 from_birth7 from_birth8 from_birth9 from_birth10 from_birth11 from_birth12 from_birth13)
replace fbdef = 0 if fbdef==.

gen nfbdef = ptargdef==1 & all_from_birth==0

*generate an indicator for whther there is an alliance present that is
*neither from birth, nor within its first 15 years of life.
gen def_form_16plus = (ptargdef==1 & def_form_5yr==0 & def_form_6to15==0 ///
	& all_from_birth==0)

drop from_birth* birth_def* def_form_l* new_* def_form enter entry_yr ///
	all_from_birth

save jl_modified, replace
