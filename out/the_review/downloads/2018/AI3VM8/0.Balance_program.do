

set trace on

cap prog drop balance_fe
program define balance_fe, eclass
syntax, outcome_list(varlist) treat_var(varname) fe_var(varname) store(string)
	
*Set local for number of outcome variables
local num: word count `outcome_list'

*Pull the levels of fixed effect variable for degrees of freedom adjustment: 
levelsof `fe_var', local(fe_level)
local dgf_adjust: word count `fe_level'


*Center outcome variables by the FE variable 

foreach var in `outcome_list'{
				   

bys `fe_var': center `var', gen(temp_`var')

}

*Loop over the 4 columns of the table:
forvalues i=1/4{


*Create mean and SD vector/matrix to store estimates in
matrix mean=J(1,`num',.) 
matrix sd=J(1,`num',.)

*Estimates for first two columns (treat/control means).  Uses ttest for means and SE
if `i'==1 | `i'==2{

	forvalues j=1/`num'{
	local var: word `j' of `outcome_list'

		ttest temp_`var', by(`treat_var')
		matrix mean[1,`j']=r(mu_`i')
		matrix sd[1,`j']=r(sd_`i')
		
		}
		
	matrix colnames mean= `outcome_list'   
	matrix colnames sd= `outcome_list'   

}

/*
Estimates for the thrid column (difference of means).  Uses ttest for difference and areg for adjusted SE.
NOTE: The SE from ttest can NOT be used due to the fact that their degrees of freedom have not been adjusted to account for
the estimated, centered means. */
 
else if `i'==3{

forvalues j=1/`num'{
	local var: word `j' of `outcome_list'

		ttest temp_`var', by(`treat_var')

	
		local diff=`r(mu_1)' - `r(mu_2)'
		matrix mean[1,`j'] = `diff'
		
		
		*Calculate corrected standard errors
		local s1=r(sd_1)
		local s2=r(sd_2)
		local n1=r(N_1)
		local n2=r(N_2)

		local s1_sq=`s1'^2
		local s2_sq=`s2'^2

		local term1=(`n1'-1-`dgf_adjust')*`s1_sq'
		local term2=(`n2'-1-`dgf_adjust')*`s2_sq'

		local numerator=`term1'+`term2'
		local total_df=(`n1'+`n2')-`dgf_adjust' -2

		local sp_sq=`numerator'/`total_df'

		local frac1=`sp_sq'/`n1'
		local frac2=`sp_sq'/`n2'

		local sum=`frac1'+`frac2'

		local se=sqrt(`sum')


		matrix sd[1,`j']=`se'
		
			
	}
	matrix colnames mean= `outcome_list'   
	matrix colnames sd= `outcome_list'   
		
}

*Estimates for the fourth column (p-value of difference).  Again uses areg for adjusted p-value
else if `i'==4{

forvalues j=1/`num'{
local var: word `j' of `outcome_list'

		*Calculate corrected standard errors
		
		ttest temp_`var', by(`treat_var')
		local diff=`r(mu_1)' - `r(mu_2)'

		local s1=r(sd_1)
		local s2=r(sd_2)
		local n1=r(N_1)
		local n2=r(N_2)

		local s1_sq=`s1'^2
		local s2_sq=`s2'^2

		local term1=(`n1'-1-`dgf_adjust')*`s1_sq'
		local term2=(`n2'-1-`dgf_adjust')*`s2_sq'

		local numerator=`term1'+`term2'
		local denom=(`n1'+`n2')-`dgf_adjust' -2

		local sp_sq=`numerator'/`denom'

		local frac1=`sp_sq'/`n1'
		local frac2=`sp_sq'/`n2'

		local sum=`frac1'+`frac2'

		local se=sqrt(`sum')


		*Use standard errors to calculate p-values
		local t=abs(`diff'/`se')

		local total_df=`n1'+`n2'-2-`dgf_adjust'
		local p_oneside=ttail(`total_df',`t')
		local p_twoside=ttail(`total_df',`t')*2

		
		matrix mean[1,`j']=`p_oneside'
	}
	
	matrix colnames mean= `outcome_list'   

}
	

qui reg `outcome_list' // Create a set of stored estimates to be overwritten.  This can be any regression


*Add the new esimtates to the estimate set
estadd matrix mean= mean
estadd matrix sd= sd

*Store estimates to be exported using esttab
eststo `store'_`i' 

}

end
