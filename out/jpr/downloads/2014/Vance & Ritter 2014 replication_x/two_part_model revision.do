*Open data
*use "Path\SweeneyJCR.dta", clear
set more off

*Rescale logdstab to be measured in 1000s of km to ease interpretation, as requested by a reviewer
gen temp = exp(logdstab)
replace temp = temp/1000
gen temp1 = ln(temp)
replace logdstab= temp1
drop temp temp1

/**************************************************************************************************************************************************************/
*Estimate the heckman model using maximum likelihood. This appears as Table One, Model 1 in the Sweeney article, and is replicated in Table 1 in the present article.
/*all dyads, all years, full Interest Similarity Measure*/

heckman brl2 ln_capratio s_wt_glo2 NEWCAP3 smldmat smldep smigoabi TERR2 ACTORS2 logdstab contigkb majmaj, robust select (disputex = ln_capratio smldmat smldep smigoabi allies contigkb logdstab majpower peace _spline1 _spline2 _spline3)
keep if e(sample)
/**************************************************************************************************************************************************************/


/**************************************************************************************************************************************************************/
*get various ingredients to calculate the marginal effects
*xbprobit= predicitions from probit
local xbprobit ([#2]_b[ln_capratio]*ln_capratio+[#2]_b[smldmat]*smldmat+[#2]_b[smldep]* smldep+ [#2]_b[smigoabi]*smigoabi+ [#2]_b[allies]*allies+  [#2]_b[contigkb]*contigkb+ [#2]_b[logdstab]*logdstab+ [#2]_b[majpower]*majpower+ [#2]_b[peace]*peace+ [#2]_b[_spline1]*_spline1+ [#2]_b[_spline2]*_spline2+ [#2]_b[_spline3]*_spline3+ [#2]_b[_cons])

*xbols= predictions from second stage ols
local xbols (_b[ln_capratio]*ln_capratio +_b[s_wt_glo2]*s_wt_glo2 +_b[NEWCAP3]*NEWCAP3 +_b[smldmat]*smldmat +_b[smldep]*smldep +_b[smigoabi]*smigoabi +_b[TERR2]*TERR2 +_b[ACTORS2]*ACTORS2 +_b[logdstab]*logdstab +_b[contigkb]*contigkb +_b[majmaj]*majmaj +_b[_cons])

*Generate IMR  
gen IMR= (normalden(`xbprobit')/normal(`xbprobit'))
*Calculate the condition number
* Retrieve command "collin" by using findit function in STATA
*collin ln_capratio s_wt_glo2 NEWCAP3 smldmat smldep smigoabi TERR2 ACTORS2 logdstab contigkb majmaj IMR


*Retrieve coefficient of inverse Mills ratio
local IMR  ((exp(2*_b[/athrho])-1)/(exp(2*_b[/athrho])+1))*(exp(_b[/lnsigma])) 
/**************************************************************************************************************************************************************/


/**************************************************************************************************************************************************************/
*Now calculate the Heckman results presented in Table 3.
/**************************************************************************************************************************************************************/

/*
The marginal effect of "Capability ratio" from the Heckman model
Formula from equation 11, dependent variable in levels, explanatory variable logged and interacted with another variable:
Marginal effect= beta_k/x_k + beta_ki*x_j/x_k - IMR*(theta_k/x_k)*(normalden(xbprobit)/normal(xbprobit)*(normalden(xbprobit)/normal(xbprobit)-xbprobit)
Now plug this formula into Stata's predictnl command
*/
gen capratio = exp(ln_capratio)
predictnl ME_capratio = _b[ln_capratio]/capratio + (_b[NEWCAP3]/capratio)*s_wt_glo2 - `IMR'*([#2]_b[ln_capratio]/capratio)*(normalden(`xbprobit')/normal(`xbprobit'))*(normalden(`xbprobit')/normal(`xbprobit')+(`xbprobit')), se(seME_capratio)
gen z_1 =ME_capratio/seME_capratio

*The folowing gives Sweeney's result for ln_capratio, which does not take into account the logged form of the explanatory variable.
predictnl ME_capratioS = _b[ln_capratio]  - ([#2]_b[ln_capratio])*((exp(2*_b[/athrho])-1)/(exp(2*_b[/athrho])+1))*(exp(_b[/lnsigma]))*((normalden([#2]_b[ln_capratio]*ln_capratio+[#2]_b[smldmat]*smldmat+[#2]_b[smldep]* smldep+ [#2]_b[smigoabi]*smigoabi+ [#2]_b[allies]*allies+  [#2]_b[contigkb]*contigkb+ [#2]_b[logdstab]*logdstab+ [#2]_b[majpower]*majpower+ [#2]_b[peace]*peace+ [#2]_b[_spline1]*_spline1+ [#2]_b[_spline2]*_spline2+ [#2]_b[_spline3]*_spline3+ [#2]_b[_cons])/norm([#2]_b[ln_capratio]*ln_capratio+[#2]_b[smldmat]*smldmat+[#2]_b[smldep]* smldep+ [#2]_b[smigoabi]*smigoabi+ [#2]_b[allies]*allies+  [#2]_b[contigkb]*contigkb+ [#2]_b[logdstab]*logdstab+ [#2]_b[majpower]*majpower+ [#2]_b[peace]*peace+ [#2]_b[_spline1]*_spline1+ [#2]_b[_spline2]*_spline2+ [#2]_b[_spline3]*_spline3+ [#2]_b[_cons]))*(normalden([#2]_b[ln_capratio]*ln_capratio+[#2]_b[smldmat]*smldmat+[#2]_b[smldep]* smldep+ [#2]_b[smigoabi]*smigoabi+ [#2]_b[allies]*allies+  [#2]_b[contigkb]*contigkb+ [#2]_b[logdstab]*logdstab+ [#2]_b[majpower]*majpower+ [#2]_b[peace]*peace+ [#2]_b[_spline1]*_spline1+ [#2]_b[_spline2]*_spline2+ [#2]_b[_spline3]*_spline3+ [#2]_b[_cons])/norm([#2]_b[ln_capratio]*ln_capratio+[#2]_b[smldmat]*smldmat+[#2]_b[smldep]* smldep+ [#2]_b[smigoabi]*smigoabi+ [#2]_b[allies]*allies+  [#2]_b[contigkb]*contigkb+ [#2]_b[logdstab]*logdstab+ [#2]_b[majpower]*majpower+ [#2]_b[peace]*peace+ [#2]_b[_spline1]*_spline1+ [#2]_b[_spline2]*_spline2+ [#2]_b[_spline3]*_spline3+ [#2]_b[_cons])+([#2]_b[ln_capratio]*ln_capratio+[#2]_b[smldmat]*smldmat+[#2]_b[smldep]* smldep+ [#2]_b[smigoabi]*smigoabi+ [#2]_b[allies]*allies+  [#2]_b[contigkb]*contigkb+ [#2]_b[logdstab]*logdstab+ [#2]_b[majpower]*majpower+ [#2]_b[peace]*peace+ [#2]_b[_spline1]*_spline1+ [#2]_b[_spline2]*_spline2+ [#2]_b[_spline3]*_spline3+ [#2]_b[_cons]))), se(seME_capratioS)
   
  
/*
The marginal effect of "Democracy" from the Heckman model
Formula from equation 5, dependent variable in levels, explanatory variable levels:
ME_smldmat = beta_k - IMR*theta_k*(normalden(xbprobit)/normal(xbprobit))*(normalden(xbprobit)/normal(xbprobit)+xbprobit)
Now plug this into Stata's predictnl command (Note that Sweeney uses the same formula)
*/
predictnl ME_smldmat = _b[smldmat] -  `IMR'*[#2]_b[smldmat]*(normalden(`xbprobit')/normal(`xbprobit'))*(normalden(`xbprobit')/normal(`xbprobit')+`xbprobit'), se(se_smldmat)
 

/*
The marginal effect of "Dependence" from the Heckman model
Formula from equation 5, dependent variable in levels, explanatory variable levels:
ME_smldmat = beta_k - IMR*theta_k*(normalden(xbprobit)/normal(xbprobit))*(normalden(xbprobit)/normal(xbprobit)+xbprobit)
Now plug this into Stata's predictnl command (Note that Sweeney uses the same formula)
*/
predictnl ME_smldep = _b[smldep] -  `IMR'*[#2]_b[smldep]*(normalden(`xbprobit')/normal(`xbprobit'))*(normalden(`xbprobit')/normal(`xbprobit')+`xbprobit'), se(se_smldep)
  

/*
The marginal effect of "Common IGOs" from the Heckman model
Formula from equation 5, dependent variable in levels, explanatory variable levels:
ME_smldmat = beta_k - IMR*theta_k*(normalden(xbprobit)/normal(xbprobit))*(normalden(xbprobit)/normal(xbprobit)+xbprobit)
Now plug this into Stata's predictnl command (Note that Sweeney uses the same formula)
*/
predictnl ME_smigoabi = _b[smigoabi] -  `IMR'*[#2]_b[smigoabi]*(normalden(`xbprobit')/normal(`xbprobit'))*(normalden(`xbprobit')/normal(`xbprobit')+`xbprobit'), se(se_smigoabi)


/*
The marginal effect of "Contiguous" from the Heckman model
Formula from equation 8, dependent variable in levels, explanatory variable is a dummy:
ME_contig = xbols_1 + IMR*(normalden(xbprobit_1)/normal(xbprobit_1)) - (xbols_0 + IMR*(normalden(xbprobit_0)/normal(xbprobit_0)))
Now plug this into Stata's predictnl command (Note that Sweeney uses a different formula)
*/
predictnl  ME_contig = (_b[ln_capratio]*ln_capratio +_b[s_wt_glo2]*s_wt_glo2 +_b[NEWCAP3]*NEWCAP3 +_b[smldmat]*smldmat +_b[smldep]*smldep +_b[smigoabi]*smigoabi +_b[TERR2]*TERR2 +_b[ACTORS2]*ACTORS2 +_b[logdstab]*logdstab +_b[contigkb]*1 +_b[majmaj]*majmaj +_b[_cons]) + `IMR'*(normalden(([#2]_b[ln_capratio]*ln_capratio+[#2]_b[smldmat]*smldmat+[#2]_b[smldep]* smldep+ [#2]_b[smigoabi]*smigoabi+ [#2]_b[allies]*allies+  [#2]_b[contigkb]*1+ [#2]_b[logdstab]*logdstab+ [#2]_b[majpower]*majpower+ [#2]_b[peace]*peace+ [#2]_b[_spline1]*_spline1+ [#2]_b[_spline2]*_spline2+ [#2]_b[_spline3]*_spline3+ [#2]_b[_cons]))/normal(([#2]_b[ln_capratio]*ln_capratio+[#2]_b[smldmat]*smldmat+[#2]_b[smldep]* smldep+ [#2]_b[smigoabi]*smigoabi+ [#2]_b[allies]*allies+  [#2]_b[contigkb]*1+ [#2]_b[logdstab]*logdstab+ [#2]_b[majpower]*majpower+ [#2]_b[peace]*peace+ [#2]_b[_spline1]*_spline1+ [#2]_b[_spline2]*_spline2+ [#2]_b[_spline3]*_spline3+ [#2]_b[_cons]))) - ((_b[ln_capratio]*ln_capratio +_b[s_wt_glo2]*s_wt_glo2 +_b[NEWCAP3]*NEWCAP3 +_b[smldmat]*smldmat +_b[smldep]*smldep +_b[smigoabi]*smigoabi +_b[TERR2]*TERR2 +_b[ACTORS2]*ACTORS2 +_b[logdstab]*logdstab +_b[contigkb]*0 +_b[majmaj]*majmaj +_b[_cons]) + `IMR'*(normalden(([#2]_b[ln_capratio]*ln_capratio+[#2]_b[smldmat]*smldmat+[#2]_b[smldep]* smldep+ [#2]_b[smigoabi]*smigoabi+ [#2]_b[allies]*allies+  [#2]_b[contigkb]*0+ [#2]_b[logdstab]*logdstab+ [#2]_b[majpower]*majpower+ [#2]_b[peace]*peace+ [#2]_b[_spline1]*_spline1+ [#2]_b[_spline2]*_spline2+ [#2]_b[_spline3]*_spline3+ [#2]_b[_cons]))/normal(([#2]_b[ln_capratio]*ln_capratio+[#2]_b[smldmat]*smldmat+[#2]_b[smldep]* smldep+ [#2]_b[smigoabi]*smigoabi+ [#2]_b[allies]*allies+  [#2]_b[contigkb]*0+ [#2]_b[logdstab]*logdstab+ [#2]_b[majpower]*majpower+ [#2]_b[peace]*peace+ [#2]_b[_spline1]*_spline1+ [#2]_b[_spline2]*_spline2+ [#2]_b[_spline3]*_spline3+ [#2]_b[_cons])))), se(se_contig)

*the folowing gives Sweeney's result for contigkb, which treats the dummy variable as if it were continuous (as in equation 5)
predictnl contigkba1 = _b[contigkb]- ([#2]_b[contigkb]*((exp(2*_b[/athrho])-1)/(exp(2*_b[/athrho])+1))*(exp(_b[/lnsigma]))*((normalden([#2]_b[ln_capratio]*ln_capratio+[#2]_b[smldmat]*smldmat+[#2]_b[smldep]* smldep+ [#2]_b[smigoabi]*smigoabi+ [#2]_b[allies]*allies+  [#2]_b[contigkb]*contigkb+ [#2]_b[logdstab]*logdstab+ [#2]_b[majpower]*majpower+ [#2]_b[peace]*peace+ [#2]_b[_spline1]*_spline1+ [#2]_b[_spline2]*_spline2+ [#2]_b[_spline3]*_spline3+ [#2]_b[_cons])/norm([#2]_b[ln_capratio]*ln_capratio+[#2]_b[smldmat]*smldmat+[#2]_b[smldep]* smldep+ [#2]_b[smigoabi]*smigoabi+ [#2]_b[allies]*allies+  [#2]_b[contigkb]*contigkb+ [#2]_b[logdstab]*logdstab+ [#2]_b[majpower]*majpower+ [#2]_b[peace]*peace+ [#2]_b[_spline1]*_spline1+ [#2]_b[_spline2]*_spline2+ [#2]_b[_spline3]*_spline3+ [#2]_b[_cons]))*(normalden([#2]_b[ln_capratio]*ln_capratio+[#2]_b[smldmat]*smldmat+[#2]_b[smldep]* smldep+ [#2]_b[smigoabi]*smigoabi+ [#2]_b[allies]*allies+  [#2]_b[contigkb]*contigkb+ [#2]_b[logdstab]*logdstab+ [#2]_b[majpower]*majpower+ [#2]_b[peace]*peace+ [#2]_b[_spline1]*_spline1+ [#2]_b[_spline2]*_spline2+ [#2]_b[_spline3]*_spline3+ [#2]_b[_cons])/norm([#2]_b[ln_capratio]*ln_capratio+[#2]_b[smldmat]*smldmat+[#2]_b[smldep]* smldep+ [#2]_b[smigoabi]*smigoabi+ [#2]_b[allies]*allies+  [#2]_b[contigkb]*contigkb+ [#2]_b[logdstab]*logdstab+ [#2]_b[majpower]*majpower+ [#2]_b[peace]*peace+ [#2]_b[_spline1]*_spline1+ [#2]_b[_spline2]*_spline2+ [#2]_b[_spline3]*_spline3+ [#2]_b[_cons])+([#2]_b[ln_capratio]*ln_capratio+[#2]_b[smldmat]*smldmat+[#2]_b[smldep]* smldep+ [#2]_b[smigoabi]*smigoabi+ [#2]_b[allies]*allies+  [#2]_b[contigkb]*contigkb+ [#2]_b[logdstab]*logdstab+ [#2]_b[majpower]*majpower+ [#2]_b[peace]*peace+ [#2]_b[_spline1]*_spline1+ [#2]_b[_spline2]*_spline2+ [#2]_b[_spline3]*_spline3+ [#2]_b[_cons])))), se(se_contigkba1) 


/*
The marginal effect of "Log distance" from the Heckman model
Formula from equation 10, dependent variable in levels, explanatory variable is logged:
ME_logdstab = beta_k/x_k - IMR*(theta_k/x_k)*(normalden(xbprobit)/normal(xbprobit))*(normalden(xbprobit)/normal(xbprobit) + xbprobit)
Now plug this into Stata's predictnl command (Note that Sweeney uses a differwent formula)
*/
gen explogdstab = exp(logdstab)
predictnl  ME_logdstab = _b[logdstab]/explogdstab - `IMR'*([#2]_b[logdstab]/explogdstab)*(normalden(`xbprobit')/normal(`xbprobit'))*(normalden(`xbprobit')/normal(`xbprobit')+`xbprobit') , se(se_logdstab)
 
*the folowing gives Sweeney's result for logdstab, which treats the variable as if it were in levels, not logged(as in equation 5)
predictnl logdstabb = _b[logdstab] - ([#2]_b[logdstab])*((exp(2*_b[/athrho])-1)/(exp(2*_b[/athrho])+1))*(exp(_b[/lnsigma]))*((normalden([#2]_b[ln_capratio]*ln_capratio+[#2]_b[smldmat]*smldmat+[#2]_b[smldep]* smldep+ [#2]_b[smigoabi]*smigoabi+ [#2]_b[allies]*allies+  [#2]_b[contigkb]*contigkb+ [#2]_b[logdstab]*logdstab+ [#2]_b[majpower]*majpower+ [#2]_b[peace]*peace+ [#2]_b[_spline1]*_spline1+ [#2]_b[_spline2]*_spline2+ [#2]_b[_spline3]*_spline3+ [#2]_b[_cons])/norm([#2]_b[ln_capratio]*ln_capratio+[#2]_b[smldmat]*smldmat+[#2]_b[smldep]* smldep+ [#2]_b[smigoabi]*smigoabi+ [#2]_b[allies]*allies+  [#2]_b[contigkb]*contigkb+ [#2]_b[logdstab]*logdstab+ [#2]_b[majpower]*majpower+ [#2]_b[peace]*peace+ [#2]_b[_spline1]*_spline1+ [#2]_b[_spline2]*_spline2+ [#2]_b[_spline3]*_spline3+ [#2]_b[_cons]))*(normalden([#2]_b[ln_capratio]*ln_capratio+[#2]_b[smldmat]*smldmat+[#2]_b[smldep]* smldep+ [#2]_b[smigoabi]*smigoabi+ [#2]_b[allies]*allies+  [#2]_b[contigkb]*contigkb+ [#2]_b[logdstab]*logdstab+ [#2]_b[majpower]*majpower+ [#2]_b[peace]*peace+ [#2]_b[_spline1]*_spline1+ [#2]_b[_spline2]*_spline2+ [#2]_b[_spline3]*_spline3+ [#2]_b[_cons])/norm([#2]_b[ln_capratio]*ln_capratio+[#2]_b[smldmat]*smldmat+[#2]_b[smldep]* smldep+ [#2]_b[smigoabi]*smigoabi+ [#2]_b[allies]*allies+  [#2]_b[contigkb]*contigkb+ [#2]_b[logdstab]*logdstab+ [#2]_b[majpower]*majpower+ [#2]_b[peace]*peace+ [#2]_b[_spline1]*_spline1+ [#2]_b[_spline2]*_spline2+ [#2]_b[_spline3]*_spline3+ [#2]_b[_cons])+([#2]_b[ln_capratio]*ln_capratio+[#2]_b[smldmat]*smldmat+[#2]_b[smldep]* smldep+ [#2]_b[smigoabi]*smigoabi+ [#2]_b[allies]*allies+  [#2]_b[contigkb]*contigkb+ [#2]_b[logdstab]*logdstab+ [#2]_b[majpower]*majpower+ [#2]_b[peace]*peace+ [#2]_b[_spline1]*_spline1+ [#2]_b[_spline2]*_spline2+ [#2]_b[_spline3]*_spline3+ [#2]_b[_cons]))), se(se_logdstabb) 



/**************************************************************************************************************************************************************/
/*APPLY 2-PART FORMULA for continuous variables.*/ 
/*First estimate the probit model and store the results as 'v'.*/
probit disputex ln_capratio smldmat smldep smigoabi allies contigkb logdstab majpower peace _spline1 _spline2 _spline3
estimates store v
/*Now estimate the OLS model and store the results as 'z'.*/              
regress brl2 ln_capratio s_wt_glo2 NEWCAP3 smldmat smldep smigoabi TERR2 ACTORS2 logdstab contigkb majmaj if disputex==1
estimates store z
/*Now estimate the two modeles jointly using 'seemingly unrelated regression'. The table produced by this will give the raw coefficient estimates, which are presented in Table 1.*/
suest v z, robust
/**************************************************************************************************************************************************************/

/**************************************************************************************************************************************************************/
*get various ingredients to calculate the marginal effects and store in local macros
local probit_xb  ([v_disputex]_b[ln_capratio]*ln_capratio +[v_disputex]_b[smldmat]*smldmat +[v_disputex]_b[smldep]*smldep +[v_disputex]_b[smigoabi]*smigoabi +[v_disputex]_b[allies]*allies +[v_disputex]_b[contigkb]*contigkb +[v_disputex]_b[logdstab]*logdstab +[v_disputex]_b[majpower]*majpower +[v_disputex]_b[peace]*peace +[v_disputex]_b[_spline1]*_spline1 +[v_disputex]_b[_spline2]*_spline2 +[v_disputex]_b[_spline3]*_spline3+[v_disputex]_b[_cons])
local ols_xb ([z_mean]_b[ln_capratio]*ln_capratio +[z_mean]_b[s_wt_glo2]*s_wt_glo2 +[z_mean]_b[NEWCAP3]*NEWCAP3 +[z_mean]_b[smldmat]*smldmat +[z_mean]_b[smldep]*smldep +[z_mean]_b[smigoabi]*smigoabi +[z_mean]_b[TERR2]*TERR2 +[z_mean]_b[ACTORS2]*ACTORS2 +[z_mean]_b[logdstab]*logdstab +[z_mean]_b[contigkb]*contigkb +[z_mean]_b[majmaj]*majmaj +[z_mean]_b[_cons])
/**************************************************************************************************************************************************************/

/**************************************************************************************************************************************************************/
*Now calculate the 2PM results presented in Table 3.
/**************************************************************************************************************************************************************/

/*
The marginal effect of "Capability ratio" from the 2PM
Formula from equation 13, dependent variable in levels, explanatory variable logged and interacted with another variable:
ME_lncap2a = ((beta_k/x_k) + (beta_ki*x_j/x_k))*normal(probit_xb) + (theta_k/x_k)*normalden(probit_xb)*(ols_xb) if brl2!=.
Now plug this into Stata's predictnl command:
*/
cap drop capratio
gen capratio = exp(ln_capratio)
predictnl ME_lncap2PM = (([z_mean]_b[ln_capratio]/capratio) + ([z_mean]_b[NEWCAP3]/capratio)*s_wt_glo2)*normal(`probit_xb') + ([v_disputex]_b[ln_capratio]/capratio)*normalden(`probit_xb')*(`ols_xb') if brl2!=., se(seln_cap)
gen z_2 =ME_lncap2PM/seln_cap


/*
The marginal effect of "Democracy" from the 2PM
Formula from equation 7, dependent variable in levels, explanatory variable in levels:
ME_smaldmat2PM = beta_k*normal(probit_xb)+theta_k*normalden(xb_probit)*(xb_ols) if brl2!=.
Now plug this into Stata's predictnl command:
*/
predictnl ME_smaldmat2PM  = [z_mean]_b[smldmat]*normal(`probit_xb')+ [v_disputex]_b[smldmat]*normalden(`probit_xb')*(`ols_xb')if brl2!=., se(sesmaldat2PM)


/*
The marginal effect of "Dependence" from the 2PM
Formula from equation 7, dependent variable in levels, explanatory variable in levels:
ME_smldep2PM = beta_k*normal(probit_xb)+theta_k*normalden(xb_probit)*(xb_ols) if brl2!=.
Now plug this into Stata's predictnl command:
*/
predictnl ME_smldep2PM  = [z_mean]_b[smldep]*normal(`probit_xb')+ [v_disputex]_b[smldep]*normalden(`probit_xb')*(`ols_xb')if brl2!=., se(sesmldep2PM)


/*
The marginal effect of "Common IGOs" from the 2PM
Formula from equation 7, dependent variable in levels, explanatory variable in levels:
ME_smigoabi2PM = beta_k*normal(probit_xb)+theta_k*normalden(xb_probit)*(xb_ols) if brl2!=.
Now plug this into Stata's predictnl command:
*/
*Marginal effect for smigoabi
predictnl ME_smigoabi2PM  = [z_mean]_b[smigoabi]*normal(`probit_xb')+ [v_disputex]_b[smigoabi]*normalden(`probit_xb')*(`ols_xb')if brl2!=., se(sesmigoabi2PM)


/*
The marginal effect of "Contiguous" from the 2PM
Formula from equation 9, dependent variable in levels, explanatory variable is a dummy:
ME_contigkb2PM= normal(probit_xb1)*(ols_xb1) - normal(probit_xb0)*(ols_xb0) if brl2!=.
*/
predictnl ME_contigkb2PM= normal(([v_disputex]_b[ln_capratio]*ln_capratio +[v_disputex]_b[smldmat]*smldmat +[v_disputex]_b[smldep]*smldep +[v_disputex]_b[smigoabi]*smigoabi +[v_disputex]_b[allies]*allies +[v_disputex]_b[contigkb]*1 +[v_disputex]_b[logdstab]*logdstab +[v_disputex]_b[majpower]*majpower +[v_disputex]_b[peace]*peace +[v_disputex]_b[_spline1]*_spline1 +[v_disputex]_b[_spline2]*_spline2 +[v_disputex]_b[_spline3]*_spline3+[v_disputex]_b[_cons]))*(([z_mean]_b[ln_capratio]*ln_capratio +[z_mean]_b[s_wt_glo2]*s_wt_glo2 +[z_mean]_b[NEWCAP3]*NEWCAP3 +[z_mean]_b[smldmat]*smldmat +[z_mean]_b[smldep]*smldep +[z_mean]_b[smigoabi]*smigoabi +[z_mean]_b[TERR2]*TERR2 +[z_mean]_b[ACTORS2]*ACTORS2 +[z_mean]_b[logdstab]*logdstab +[z_mean]_b[contigkb]*1 +[z_mean]_b[majmaj]*majmaj +[z_mean]_b[_cons])) - normal(([v_disputex]_b[ln_capratio]*ln_capratio +[v_disputex]_b[smldmat]*smldmat +[v_disputex]_b[smldep]*smldep +[v_disputex]_b[smigoabi]*smigoabi +[v_disputex]_b[allies]*allies +[v_disputex]_b[contigkb]*0 +[v_disputex]_b[logdstab]*logdstab +[v_disputex]_b[majpower]*majpower +[v_disputex]_b[peace]*peace +[v_disputex]_b[_spline1]*_spline1 +[v_disputex]_b[_spline2]*_spline2 +[v_disputex]_b[_spline3]*_spline3+[v_disputex]_b[_cons]))*(([z_mean]_b[ln_capratio]*ln_capratio +[z_mean]_b[s_wt_glo2]*s_wt_glo2 +[z_mean]_b[NEWCAP3]*NEWCAP3 +[z_mean]_b[smldmat]*smldmat +[z_mean]_b[smldep]*smldep +[z_mean]_b[smigoabi]*smigoabi +[z_mean]_b[TERR2]*TERR2 +[z_mean]_b[ACTORS2]*ACTORS2 +[z_mean]_b[logdstab]*logdstab +[z_mean]_b[contigkb]*0 +[z_mean]_b[majmaj]*majmaj +[z_mean]_b[_cons])) if brl2!=., se(secontigkb2PM)


/*
The marginal effect of "Log distance" from the 2PM
Formula from equation 12, dependent variable in levels, explanatory variable is logged:
ME_logdstab2PM= (beta_k/x_k)*normal(probit_xb) + (theta_k/x_k)*normalden(probit_xb)*(ols_xb) if brl2!=.
Now plug this into Stata's predictnl command:
*/
cap drop explogdstab
gen explogdstab = exp(logdstab)
predictnl ME_logdstab2PM= ([z_mean]_b[logdstab]/explogdstab)*normal(`probit_xb') + ([v_disputex]_b[logdstab]/explogdstab)*normalden(`probit_xb')*(`ols_xb') if brl2!=., se(selogdstab2PM)




/**************************************************************************************************************************************************************/
*Consolidate  the above results for insertion into Table 3.
/**************************************************************************************************************************************************************/

/*The left two columns in the table, Sweeney's Calculations, can be obtained from the Sweeney article.*/

/*Below are the calculations from the middle two columns, Author's Calculations of the Heckman.*/
*Coefficients
sum ME_capratio ME_smldmat ME_smldep ME_smigoabi ME_contig ME_logdstab
*Standard errors
sum seME_capratio se_smldmat se_smldep se_smigoabi se_contig se_logdstab

/*Below are the calculations from the final two columns, Author's Calculations of the 2PM.*/
*Coefficients
sum ME_lncap2PM ME_smaldmat2PM ME_smldep2PM ME_smigoabi2PM ME_contigkb2PM ME_logdstab2PM
*Standard errors
sum seln_cap sesmaldat2PM sesmldep2PM sesmigoabi2PM secontigkb2PM selogdstab2PM




********************************************************
******Make Figures 1 and 2
********************************************************


/*Figure 1, Heckman*/
twoway (scatter z_1 ME_capratio, mcolor(black) msize(vtiny) msymbol(X)) ///
,yline(-1.96, lwidth(vvvthin) lpattern(dash) lcolor(black)) yline(1.96, lwidth(vvvthin)  lpattern(dash) lcolor(black)) ylabel(,nogrid) yscale(range(-2 2)) legend(off) ///
ylabel(#5,  labsize(small) tposition(outside)) ///
xtitle("") xlabel(#10,  labsize(Medium) tposition(outside)) ///
ytitle(Z-Statistic) ylabel(#5,  labsize(Medium small) tposition(outside)) ///
graphregion(color(white))  aspectratio(0.25) name(scatter2e)

hist ME_capratio, color(white) lcolor(black) xtitle("Marginal effects") xlabel(#10,  labsize(Medium) tposition(outside)) ///
ytitle(Frequency) ylabel(#5,  labsize(Medium small) nogrid tposition(outside)) title(" ") ///
graphregion(color(white)) aspectratio(0.25) name(hist2e)

graph combine scatter2e hist2e, col(1) graphregion(color(white))



/*Figure 2, 2PM*/
twoway (scatter z_2 ME_lncap2PM, mcolor(black) msize(vtiny) msymbol(X)) ///
,yline(-1.96, lwidth(vvvthin) lpattern(dash) lcolor(black)) yline(1.96, lwidth(vvvthin)  lpattern(dash) lcolor(black)) ylabel(,nogrid) yscale(range(-2 2)) legend(off) ///
ylabel(#5,  labsize(small) tposition(outside)) ///
xtitle("") xlabel(#10,  labsize(Medium) tposition(outside)) ///
ytitle(Z-Statistic) ylabel(#5,  labsize(Medium small) tposition(outside)) ///
graphregion(color(white))  aspectratio(0.25) name(scatter2r)

hist ME_lncap2PM, freq bin(75) color(white) lcolor(black) ///
xtitle("Marginal effects") xlabel(#10,  labsize(Medium) tposition(outside)) ///
ytitle(Frequency) ylabel(#5,  labsize(Medium small) nogrid tposition(outside)) ///
graphregion(color(white)) aspectratio(0.25) name(hist2r)

graph combine scatter2r hist2r, col(1) graphregion(color(white))
