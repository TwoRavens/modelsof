clear
set mem 100m

*cd c:\Celine\Recherche\bdv\data
*cd c:\datadivers\coffee\data1
cd Z:\bdv\data

use margins.dta

/*number of weeks*/
sum trend
global T=r(max)


/*number of products*/
sum productid
global nb_p=r(max) 

/*number of retailers*/
sum retailer
global nb_e=r(max)   

/*number of brands*/
sum brand
global nb_b=r(max)    

/*number of manufacturers*/
sum manufacturer
global nb_m=r(max)

/*number of simulations*/
global ns=100

/*price coefficients*/
global beta=-0.7721275
global sigma=0.0988086

/*****retailers ownership matrices*****/

forvalues j=1/$nb_e {
	forvalues t=1/$T {
		mkmat ens`j' if trend==`t', matrix(ensg`j'`t')
		mat IR`j'`t'=J($nb_p,$nb_p,0)
		forvalues i=1/$nb_p {
			mat IR`j'`t'[`i',`i']=ensg`j'`t'[`i',1]
				}
		mat drop ensg`j'`t'
			}
		}


/*****manufacturers ownership matrices*****/

forvalues i=1/$nb_m {
	forvalues t=1/$T {
		mkmat manuf`i' if trend==`t', matrix(prod`i'`t')
		mat define IF`i'`t'=J($nb_p,$nb_p,0)
		forvalues j=1/$nb_p {
			mat IF`i'`t'[`j',`j']=prod`i'`t'[`j',1]
				}
		mat drop prod`i'`t'
			}
		}

capture drop _merge
merge using data2b_rev.dta
capture drop _merge
merge using mu.dta
capture drop _merge 
merge using delta.dta
capture drop _merge
merge using rdraws.dta


mat A=J($nb_p,$nb_p,1)
mat B=I($nb_p)
mat C=A-B
mat U=J(1,$nb_p,1)
mat V=J($nb_p,1,0)

/* simulations */


gen pcm=1.1*(price - gammaRPM2_unif)  /*TPT with RPM unif*/



sort trend retailer brand

mat lypsy=J($nb_p,1,0)


capture program drop nlstar


program define nlstar
            if "`1'" == "?" {
global list ""
foreach j of numlist 1/$nb_p {
	global list="$list"+" "+"B`j'"
				}
global S_1 "$list"

foreach j of numlist 1/$nb_p {
	global B`j'=price${tt}[`j',1]
				}
                exit
            }





mat define sj_p_star=J($nb_p,1,0)
mat sp_star=J($nb_p,$nb_p,0)
forvalues k=1/$nb_p {
	mat DSPP`k'=J($nb_p,$nb_p,0)
			}

forvalues s=1/$ns {
	mat define sj_p_star`s'=J($nb_p,1,0)
	scalar define total=0
	forvalues j=1/$nb_p {
		mat p_star${tt}[`j',1]=${B`j'}
		mat tetau[`j',1]=delta[`j',1]+mu[`j',`s']-($beta+$sigma*rdraws[`j',`s'])*(price${tt}[`j',1]-p_star${tt}[`j',1])
		mat  exptet[`j',1]=exp(tetau[`j',1]) 
		if exptet[`j',1]==. {
			mat exptet[`j',1]=0
				} 
		scalar total=total+exptet[`j',1]
		if `j'==1 {
			mat rdraws2=rdraws[1...,`s']
			}
		if `j'>1 {
			mat rdraws2=rdraws2,rdraws[1...,`s']
			}
			}		
	forvalues j=1/$nb_p {
		mat sj_p_star`s'[`j',1]=exptet[`j',1]/(1+total)
		mat sj_p_star[`j',1]=sj_p_star[`j',1]+(1/$ns)*sj_p_star`s'[`j',1]
				}

	mat define sp_star=sp_star+(1/$ns)*hadamard($beta*J($nb_p,$nb_p,1)+$sigma*rdraws2,(hadamard(-sj_p_star`s'*(sj_p_star`s')',C)+hadamard(sj_p_star`s'*(J($nb_p,1,1)-sj_p_star`s')',B)))


		}

		
forvalues i=1/$nb_m {
	mat P2WSP`i'=IF`i'${tt}*sp_star*IF`i'${tt}
	matginv(P2WSP`i'), ginv(P2WSPI`i')
	mat drop P2WSP`i'
	mat objM`i'${tt}=-P2WSPI`i'*IF`i'${tt}*sj_p_star
	mat drop P2WSPI`i'
			}
	



mat obj${tt}=IF1${tt}*objM1${tt}
forvalues i=2/$nb_m {
	mat obj${tt}=obj${tt}+IF`i'${tt}*objM`i'${tt}
		}

mat obj${tt}=-obj${tt}+p_star${tt}

				
capture drop v_obj1
svmat obj${tt} , name(v_obj)
replace `1' =v_obj1


        end





global tt=1
while $tt<=$T {


mkmat price if trend==${tt}, matrix(price${tt})
mkmat delta if trend==${tt},matrix(delta)
mkmat mu1-mu100 if trend==${tt},matrix(mu)
mkmat col1-col100 if trend==${tt}, matrix(rdraws)


mat p_star${tt}=J($nb_p,1,0)
mat tetau=J($nb_p,1,0)
mat exptet=J($nb_p,1,0)
mat sj_p_star=J($nb_p,1,0)
mat obj${tt}=J($nb_p,1,0)
gen pcm_${tt}=pcm if trend==${tt}



preserve
keep if trend==${tt}
di "t=" $tt
profiler on
*set trace on
/*capture*/ nl star pcm_${tt}
profiler report

global coucou=_rc
restore
capture drop pcm_${tt}
mat lypsy2=J($nb_p,1,0)

foreach j of numlist 1/$nb_p {
	mat lypsy2[`j',1]=${B`j'}
if $coucou~=0 {
mat lypsy2[`j',1]=.
}

			}
mat lypsy=lypsy,lypsy2


global tt=$tt+1
}

mat lypsy=lypsy[.,2..$T+1]
capture drop lypsy*
sort trend productid
svmat lypsy

/*computation of price changes*/
capture drop price_sim
gen price_sim=0
foreach t of numlist 1/$T {
	capture drop price_sim`t'b
	bysort productid : egen price_sim`t'b=max(lypsy`t')
	replace price_sim=price_sim`t'b if trend==`t'
	drop price_sim`t'b
			}
capture drop Dprice_sim
gen Dprice_sim=(price_sim-price)/price

sort trend productid
foreach N in price_sim {
mat define `N'=J($nb_p,1,0)
local t=1
while `t'<$T+1 {
	mkmat `N' if trend==`t', matrix(`N'`t')
	matrix `N'=`N',`N'`t'
	mat drop `N'`t'
	local t=`t'+1
		}
mat `N'=`N'[.,2..$T+1]
}


/***transformation of variables in matrix****/

foreach N in price delta {
mat define `N'=J($nb_p,1,0)
local t=1
while `t'<$T+1 {
	mkmat `N' if trend==`t', matrix(`N'`t')
	matrix `N'=`N',`N'`t'
	mat drop `N'`t'
	local t=`t'+1
		}
mat `N'=`N'[.,2..$T+1]
}


local t=1
while `t'<$T+1 {
	mkmat mu1-mu100 if trend==`t', matrix(mu`t')
	local t=`t'+1
		}

local t=1
while `t'<$T+1 {
	mkmat col1-col100 if trend==`t', matrix(rdraws`t')
	local t=`t'+1
		}



/*computation of market share changes*/

mat define sj_p_star=J($nb_p,$T,0)

forvalues t=1/$T {

forvalues s=1/$ns {
	mat define sj_p_star`s'=J($nb_p,1,0)
	scalar define total=0
	forvalues j=1/$nb_p {
		mat tetau[`j',1]=delta[`j',`t']+mu[`j',`s']-($beta+$sigma*rdraws[`j',`s'])*(price[`j',`t']-price_sim[`j',`t'])
		mat  exptet[`j',1]=exp(tetau[`j',1]) 
		if exptet[`j',1]==. {
			mat exptet[`j',1]=0
				} 
		scalar total=total+exptet[`j',1]
		if `j'==1 {
			mat rdrawsb=rdraws`t'[1...,`s']
			}
		if `j'>1 {
			mat rdrawsb=rdrawsb,rdraws`t'[1...,`s']
			}
			}		
	forvalues j=1/$nb_p {
		mat sj_p_star`s'[`j',1]=exptet[`j',1]/(1+total)
		mat sj_p_star[`j',`t']=sj_p_star[`j',`t']+(1/$ns)*sj_p_star`s'[`j',1]

				}

		}


} /*end of the `t' loop*/

sort trend productid
capture drop sj_p_star*
svmat sj_p_star
capture drop shares_sim
gen shares_sim=0
foreach t of numlist 1/$T {
	capture drop shares_sim`t'b
	bysort productid : egen shares_sim`t'b=max(sj_p_star`t')
	replace shares_sim=shares_sim`t'b if trend==`t'
	drop shares_sim`t'b
			}
capture drop Dshares_sim
gen Dshares_sim=(shares_sim-shares)/shares

save simulRPM_cost10.dta,replace
