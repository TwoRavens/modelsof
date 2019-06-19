clear
set mem 100m
set matsize 8000

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
global beta=-0.7696
global sigma=0.0949

sort trend productid
capture drop _merge 
merge using mvaln.dta
capture drop _merge
merge using rdraws.dta

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


/***construction of ownership matrices for uniform pricing hypothesis***/

/*manufacturer ownership matrices*/
forvalues i=1/$nb_m {
    forvalues t=1/$T {
        mkmat manuf`i' if trend==`t', matrix(prod`i'`t')
        mkmat retailer if trend==`t'
        mat define IFU`i'`t'=J($nb_p,$nb_b,0)
        forvalues j=1/$nb_p {
            mat IFU`i'`t'[`j',`j'-(retailer[`j',1]-1)*$nb_b]=prod`i'`t'[`j',1]
                }
        mat drop prod`i'`t'
            }
        }

/*retailer ownership matrices*/
forvalues j=1/$nb_e {
    forvalues t=1/$T {
        mkmat ens`j' if trend==`t', matrix(ensg`j'`t')
        mat IRU`j'`t'=J($nb_p,$nb_b,0)
        forvalues i=1/$nb_p {
            mat IRU`j'`t'[`i',`i'-(retailer[`i',1]-1)*$nb_b]=ensg`j'`t'[`i',1]
                }
        mat drop ensg`j'`t'
            }
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
    mkmat col1-col100 if trend==`t', matrix(rdraws`t')
    local t=`t'+1
        }


mat A=J($nb_p,$nb_p,1)
mat B=I($nb_p)
mat C=A-B
mat U=J(1,$nb_p,1)
mat V=J($nb_p,1,0)

/*computation of market share and elasticities changes*/

mat define sj_p_star=J($nb_p,$T,0)
mat tetau=J($nb_p,1,0)
mat exptet=J($nb_p,1,0)

forvalues t=1/$T {
mat DS`t'=J($nb_p,$nb_p,0)

forvalues s=1/$ns {
    mat define sj_p_star`s'=J($nb_p,1,0)
    scalar define total=0
    forvalues j=1/$nb_p {
        mat tetau[`j',1]=delta[`j',`t']+$sigma*rdraws`t'[`j',`s']*price[`j',`t']
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
    
    mat define DS`t'=DS`t'+(1/$ns)*hadamard($beta*J($nb_p,$nb_p,1)+$sigma*rdrawsb,(hadamard(-sj_p_star`s'*(sj_p_star`s')',C)+hadamard(sj_p_star`s'*(J($nb_p,1,1)-sj_p_star`s')',B)))

        }
}



/***** With Resale price Maintenance *****/


/***Second case : p-w-c=0***/

forvalues i=1/$nb_m {
    forvalues t=1/$T {
        mat SPaI`i'`t'=IF`i'`t'*DS`t'*IFU`i'`t'

        mata s=st_matrix("SPaI`i'`t'")
        mata s=qrinv(s)
        mata st_matrix("SPaII`i'`t'", s) 

        mat drop SPaI`i'`t' 
        mat gamama`i'`t'=-SPaII`i'`t'*IF`i'`t'*sj_p_star[1...,`t']
        mat drop SPaII`i'`t' 
        mat gamama`i'`t'=IFU`i'`t'*gamama`i'`t'
    capture drop gamama`i'`t'1
        svmat gamama`i'`t' 
        mat drop gamama`i'`t'
            } 
        } 


forvalues i=1/$nb_m {
    capture drop gamamaU`i'
    gen gamamaU`i'=0
    forvalues t=1/$T {
    capture drop gamama`i'`t'1b
        bysort retailer brand: egen gamama`i'`t'1b=max(gamama`i'`t'1) 
        replace gamamaU`i'=gamama`i'`t'1b if trend==`t'
        drop gamama`i'`t'1b gamama`i'`t'1 
            } 
        } 


sort trend retailer brand

gen gammaRPM2_unif_MS=.

forvalues f=1/$nb_m {
    replace gammaRPM2_unif_MS=gamamaU`f' if manufacturer==`f'
            }

gen PgammaRPM2_unif_MS=gammaRPM2_unif_MS/price*100

save margins_MS.dta,replace


sort trend productid



/* simulations */


gen pcm=price - gammaRPM2_unif  /*TPT with RPM unif*/

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


forvalues s=1/$ns {
    mat define sj_p_star`s'=J($nb_p,1,0)
    scalar define total=0
    forvalues j=1/$nb_p {
        mat p_star${tt}[`j',1]=${B`j'}
        mat tetau[`j',1]=delta[`j',1]-$beta*price${tt}[`j',1]+($beta+$sigma*rdraws[`j',`s'])*p_star${tt}[`j',1]
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
        mat SPaI`i'=IF`i'${tt}*sp_star*IFU`i'${tt}

            mat essai=SPaI`i'
            mata s=st_matrix("essai")
            mata s=qrinv(s)
            mata st_matrix("essai", s) 
            mat SPaII`i'=essai

        mat drop SPaI`i' 
        mat objM`i'${tt}=-SPaII`i'*IF`i'${tt}*sj_p_star
        mat drop SPaII`i'
        mat objM`i'${tt}=IFU`i'${tt}*objM`i'${tt}
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
    mkmat col1-col100 if trend==`t', matrix(rdraws`t')
    local t=`t'+1
        }



/*computation of market share and elasticities changes*/

mat define sj_p_star=J($nb_p,$T,0)
mat Ident=J(1,$nb_p,0)
mat DS=J(1,$nb_p,0)

forvalues t=1/$T {
mat DS`t'=J($nb_p,$nb_p,0)

forvalues s=1/$ns {
    mat define sj_p_star`s'=J($nb_p,1,0)
    scalar define total=0
    forvalues j=1/$nb_p {
        mat tetau[`j',1]=delta[`j',`t']-$beta*price[`j',`t']+($beta+$sigma*rdraws[`j',`s'])*price_sim[`j',`t']
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
    
    mat define DS`t'=DS`t'+(1/$ns)*hadamard($beta*J($nb_p,$nb_p,1)+$sigma*rdrawsb,(hadamard(-sj_p_star`s'*(sj_p_star`s')',C)+hadamard(sj_p_star`s'*(J($nb_p,1,1)-sj_p_star`s')',B)))
    mat DS`t'=DS`t'
        }
mat DS=DS\DS`t'
mat Ident=Ident\I($nb_p)

} /*end of the `t' loop*/

mat DS=DS[2..$nb_p*$T,1..$nb_p]
mat Ident=Ident[2..$nb_p*$T,1..$nb_p]
mat elastP=hadamard(DS,Ident)*J($nb_p,1,1)
svmat elastP






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

replace elastP1=elastP1*price_sim/shares_sim
rename elastP1 elastP_sim

save simulRPM_unif_MS.dta,replace
