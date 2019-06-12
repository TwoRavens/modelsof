

/*  THIS FILE CALCULATES THE FOUR ETHNIC VOTING/ETHNIC PARTY FILES.  IT IS CALLED BY "sample do file for creating voting measures from survey data.do".
THAT DO FILE DEFINES A GROUP AND THEN EXECUTES THIS FILE FOR THAT GROUP.

*/


gen x=(group==.)
gen y=1
gen denom=sum(y)
egen denom1=max(denom)
gen num=sum(x)
egen num1=max(num)
gen pctmiss=num1/denom1


/* Drop observations for groups that are less than 2% of voters */

drop if vote==.
egen totvoter=count(voters)


* What is the total number of voters for each group 

egen group_n=sum(voters),by(group)

* What is the pct of each group among total voters

gen grouppct=group_n/totvoter

* Drop obs of those supporting parties receiving less than 2%
drop if grouppct<.02
drop totvoter group_n grouppct



/* Drop observations for parties that receive less than 2% of vote */


* What is the total number of voters
drop if vote==.
egen totvoter=count(voters)

gen nv=totvoter

* What is the total number of voters for each party 

egen voters_p=sum(voters),by(vote)

* What is the pct of votes received by each party

gen partypct=voters_p/nv
* Drop obs of those supporting parties receiving less than 2%
drop if partypct<.02
drop voters_p partypct totvoter nv

egen totvoter=count(voters)
gen nv=totvoter


/* Find number of different parties or candidates supported in entire population */

egen parties=group(vote)
egen numparties=max(parties)
local  np=numparties


* Set number of ethnic groups
egen groups=group(group)
drop if group==.
drop group
rename groups group
egen numgroups=max(group)
local ng=numgroups

* Recalc total voters

drop totvoter nv
egen totvoter=count(voters)
local nv=totvoter  // nv is a local that counts the total number of voters
gen nv=totvoter

* What is the total number and percent of voters in each group

forvalues i=1/`ng'{
	
	*voters in group i
	gen temp_in`i' = vote~=. if group==`i'
	egen v_in`i' =sum(temp_in`i')  // v_in`i' is the total number of voters in each group, i
	gen apct`i'=v_in`i'/totvoter  // v_in`i' is the total voters in each group, so are finding the pct of all voters in group i
	drop temp_in`i'
	}


/* What is the proportion of all voters that support each party
*/

set more off
forvalues j=1/`np'{
	
	* Pct of vote for each party j by all voters
	gen voted`j'=  parties==`j' // voted`j' equals 1 if voter voted for party j
	egen votes`j'=sum(voted`j')
	gen tpct`j'=votes`j'/`nv' // tpct`j' is the vote by all voters for party j 
		}
	
	

	
set more off
forvalues j=1/`np'{
	forvalues i=1/`ng'{
		
	* Pct of vote for each party j by voters in  group i
	gen voted`j'_in`i'=  parties==`j' & group==`i'
	egen votes`j'_in`i'=sum(voted`j'_in`i')
	gen pct`j'_in`i'=votes`j'_in`i'/v_in`i'  // pct j in i is the total percent of voters in group i that voted for party j
	
	
	    	}
			}
*******Keep only one observation: all values below calculated based on group- and country-level obs
keep if _n==1


** Calculate ethnic parties measure

* What percentage of party j's support comes from group i?

set more off
forvalues i=1/`ng'{
	forvalues j=1/`np'{


gen pctfromG`i'_inP`j'=votes`j'_in`i' / votes`j'
	
		
	}
	}

*************calculate Group  VF (Voting Fractionalization) and VP (Voting Polarization)

*calculate rij for group dyads.
forvalues i=1/`ng'{
	forvalues j=1/`ng'{
		forvalues p=1/`np'{
			gen rT_`i'_`j'_`p'=(pct`p'_in`i'-pct`p'_in`j')^2
		}
	egen rT_`i'_`j'=rowtotal(rT_`i'_`j'_*)	//This sums all differences by party
	gen r_`i'_`j'=sqrt(.5*(rT_`i'_`j'))
	}
}

*calculate VF
forvalues i=1/`ng' {
	forvalues j=1/`ng'{
		gen VFelement_`i'_`j'=apct`i'*apct`j'*r_`i'_`j'
	}
}
egen VF=rowtotal(VFelement*)
label var VF "Group voting fractionalization"

*calculate VP
forvalues i=1/`ng' {
	forvalues j=1/`ng'{
		gen VPelement_`i'_`j'=apct`i'*apct`j'^2*r_`i'_`j'
	}
}
egen VP_temp=rowtotal(VPelement*)
gen VP=4*VP_temp
label var VP "Group voting polarization"
*drop VPelement* VFelement* rT*		


drop rT*  VFelement* VPelement* VP_temp
forvalues i=1/`ng'{
	forvalues j=1/`ng'{
	rename r_`i'_`j' Groupr_`i'_`j'
	}
	}

*************calculate Party VF (Voting Fractionalization) and Party VP (Voting Polarization)*calculate rij for group dyads.forvalues i=1/`np'{	forvalues j=1/`np'{		forvalues k=1/`ng'{			gen rP_`i'_`j'_`k'=(pctfromG`k'_inP`i'-pctfromG`k'_inP`j')^2		}	egen rP_`i'_`j'=rowtotal(rP_`i'_`j'_*)	//This sums all differences by party	gen r_`i'_`j'=sqrt(.5*rP_`i'_`j')	}}



forvalues i=1/`np' {
	forvalues j=1/`np'{
		gen VFelement_`i'_`j'=tpct`i'*tpct`j'*r_`i'_`j'
	}
}
egen PVF=rowtotal(VFelement*)
label var PVF "Party voting fractionalization"
*calculate VP
forvalues i=1/`np' {
	forvalues j=1/`np'{
		gen VPelement_`i'_`j'=tpct`i'*tpct`j'^2*r_`i'_`j'
	}
}
egen VP_temp=rowtotal(VPelement*)
gen PVP=4*VP_temp
label var PVP "Party  voting polarization"


forvalues i=1/`ng'{
rename apct`i' groupsize`i'

}
keep country VF VP PVF PVP numparties numgroups groupsize*	



