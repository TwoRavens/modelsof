clear
set mem 600m
set matsize 4000
profiler on

cd c:\Celine\Recherche\bdv\data


use coffee.dta,replace

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


capture drop _merge
merge using mu.dta
capture drop _merge 
merge using delta.dta
capture drop _merge
merge using rdraws.dta

compress 


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




/*****retailers ownership matrices*****/

foreach E of numlist 1/$nb_e {
    gen ens`E'=(retailer==`E')
                }

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

foreach P of numlist 1/$nb_m {
gen manuf`P'=manufacturer==`P'
}

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
compress 

mat A=J($nb_p,$nb_p,1)
mat B=I($nb_p)
mat C=A-B
mat U=J(1,$nb_p,1)
mat V=J($nb_p,1,0)

mat tetau=J($nb_p,1,0)
mat exptet=J($nb_p,1,0)

/****calculation of estimated market share, first derivatives and second derivatives of s wrt p****/

forvalues t=1/$T {

mat define sj_p_star_`t'=J($nb_p,1,0)
mat DS`t'=J($nb_p,$nb_p,0)
forvalues j=1/$nb_p {
    mat D`t'SPP`j'=J($nb_p,$nb_p,0)
            }

*set trace on
forvalues s=1/$ns {
    mat define sj_p_star`s'=J($nb_p,1,0)
    scalar define total=0
    forvalues j=1/$nb_p {
        *mat tetau[`j',1]=delta[`j',`t']+mu`t'[`j',`s']-($beta-($beta+$sigma*rdraws`t'[`j',`s']))*price[`j',`t']
        mat tetau[`j',1]=delta[`j',`t']+mu`t'[`j',`s']
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
        mat sj_p_star_`t'[`j',1]=sj_p_star_`t'[`j',1]+(1/$ns)*sj_p_star`s'[`j',1]
                }

    mat define DS`t'=DS`t'+(1/$ns)*hadamard($beta*J($nb_p,$nb_p,1)+$sigma*rdrawsb,(hadamard(-sj_p_star`s'*(sj_p_star`s')',C)+hadamard(sj_p_star`s'*(J($nb_p,1,1)-sj_p_star`s')',B)))
    
    forvalues k=1/$nb_p {
        mat A`k'=V
        mat A`k'[`k',1]=1              
        mat D`t'SPP`k'=D`t'SPP`k'+(1/$ns)*(($beta+$sigma*rdraws`t'[`k',`s'])^2)*sj_p_star`s'[`k',1]*(hadamard(2*hadamard(sj_p_star`s'*(sj_p_star`s')',C)-hadamard(sj_p_star`s'*(J($nb_p,1,1)-2*sj_p_star`s')',B),A-(A`k'*U+U'*(A`k')'-(A`k')*(A`k')'))-hadamard((hadamard(sj_p_star`s'*(J($nb_p,1,1)-2*sj_p_star`s')',U'*(A`k')')+hadamard((J($nb_p,1,1)-2*sj_p_star`s')*(sj_p_star`s')',(A`k')*U)),A-(A`k'*(A`k')'))+hadamard((J($nb_p,1,1)-sj_p_star`s')*(J($nb_p,1,1)-2*sj_p_star`s')',(A`k')*(A`k')'))
                }

        }


} /*end of the `t' loop*/


/*******************Linear pricing*********************/


/******retailers margins******/

/***competition: Collusion***/

forvalues t=1/$T {
    matginv(DS`t'), ginv(DSI`t')
    mat gamma1Db`t'=-DSI`t'*sj_p_star_`t'
    sort trend retailer brand   
    svmat gamma1Db`t'
    mat drop gamma1Db`t'
    bysort retailer brand: egen gamma1Dc`t'=max(gamma1Db`t'1)
    drop gamma1Db`t'1

        }

sort trend retailer brand

gen gamma1D=gamma1Dc1 if trend==1
drop gamma1Dc1
forvalues t=2/$T {
    replace gamma1D=gamma1Dc`t' if trend==`t'
    drop gamma1Dc`t'
        }
    
forvalues t=1/$T {
    gen gamma1D`t'=gamma1D if (_n>=((`t'-1)*$nb_p)+1) & (_n<=$nb_p*`t')
    mkmat gamma1D`t' if gamma1D`t'!=.
    drop gamma1D`t'
        }

gen Pgamma1D=gamma1D/price*100


/***Competition: Bertrand Nash***/

forvalues j=1/$nb_e {
    forvalues t=1/$T {
        mat DSI`j'`t'=IR`j'`t'*DS`t'*IR`j'`t'
        matginv(DSI`j'`t'), ginv(DSII`j'`t')
        mat drop DSI`j'`t'
        mat gamma2D`j'`t'= -DSII`j'`t'*IR`j'`t'*sj_p_star_`t'
        sort trend retailer brand
        svmat gamma2D`j'`t'
        bysort retailer brand: egen gamma2D`j'`t'1b=max(gamma2D`j'`t'1)
        drop gamma2D`j'`t'1

            }
        }


sort trend retailer brand

forvalues j=1/$nb_e {
    gen gamma2D`j'=gamma2D`j'11b if trend==1
    drop gamma2D`j'11b
    forvalues t=2/$T {
        replace gamma2D`j'=gamma2D`j'`t'1b if trend==`t'
        drop gamma2D`j'`t'1b
            }
        }

gen gamma2D=.
foreach E of numlist 1/$nb_e {
    replace gamma2D=gamma2D`E' if retailer==`E'
    drop gamma2D`E' 
}


forvalues t=1/$T {
    gen gamma2D`t'=gamma2D if (_n>=((`t'-1)*$nb_p)+1) & (_n<=$nb_p*`t')
    mkmat gamma2D`t' if gamma2D`t'!=.
    drop gamma2D`t'
        }

gen Pgamma2D=gamma2D/price*100


/*******Manufacturers margins*******/

/***competition: Bertrand Nash***/
forvalues i=1/$nb_m {
    forvalues t=1/$T {
        mat SPI`i'`t'=IF`i'`t'*DS`t'*IF`i'`t'
        matginv(SPI`i'`t'), ginv(SPII`i'`t') 
        mat drop SPI`i'`t' 
        mat gamma`i'`t'=-SPII`i'`t'*IF`i'`t'*sj_p_star_`t' 
        mat drop SPII`i'`t' 
        sort trend retailer brand
        svmat gamma`i'`t' 
        mat drop gamma`i'`t'
        bysort productid: egen gamma`i'`t'1c=max(gamma`i'`t'1) 
        drop gamma`i'`t'1 

            } 
        }

sort trend retailer brand

forvalues i=1/$nb_m {
    gen gamma1bP`i'=gamma`i'11c if trend==1
    drop gamma`i'11c
    forvalues t=2/$T {
        replace gamma1bP`i'=gamma`i'`t'1c if trend==`t'
        drop gamma`i'`t'1c
            } 
        }

gen gamma1P=.
foreach M of numlist 1/$nb_m {
    replace gamma1P=gamma1bP`M' if manufacturer==`M'
}

gen Pgamma1P=gamma1P/price*100


/***competition: Collusion***/

forvalues t=1/$T {
    mat SPI`t'=DS`t'
    matginv(SPI`t'), ginv(SPII`t') 
    mat drop SPI`t' 
    mat gamma`t'=-SPII`t'*sj_p_star_`t' 
    mat drop SPII`t' 
    sort trend retailer brand
    svmat gamma`t' 
    mat drop gamma`t'
    bysort productid: egen gamma`t'1d=max(gamma`t'1) 
    drop gamma`t'1 
            } 

sort trend retailer brand

gen gamma2P=gamma11d if trend==1
drop gamma11d
forvalues t=2/$T {
    replace gamma2P=gamma`t'1d if trend==`t'
    drop gamma`t'1d 
            } 

gen Pgamma2P=gamma2P/price*100


/***first derivatives of p wrt w***/

forvalues t=1/$T {
    di "t vaut " `t'
    mat SPP1`t'=D`t'SPP1*gamma1D`t'
    forvalues j=1/$nb_e {
        mat SP2`j'P1`t'=D`t'SPP1*IR`j'`t'*gamma2D`t'
            }
    

    mat SPPG`t'=SPP1`t'
    mat drop SPP1`t'

    forvalues j=1/$nb_e {
        mat SP2`j'PG`t'=SP2`j'P1`t'
        mat drop SP2`j'P1`t'
            }

    forvalues i=2/$nb_p {   
        mat SPP`i'`t'=D`t'SPP`i'*gamma1D`t'
        forvalues j=1/$nb_e {
            mat SP2`j'P`i'`t'=D`t'SPP`i'*IR`j'`t'*gamma2D`t'
            }
        
        mat SPPG`t'=SPPG`t',SPP`i'`t'
        mat drop SPP`i'`t'

        forvalues j=1/$nb_e {
            mat SP2`j'PG`t'=SP2`j'PG`t',SP2`j'P`i'`t'
            mat drop SP2`j'P`i'`t'
                }
            }

    mat SPPGSP`t'=SPPG`t'+DS`t'+(DS`t')'
    mat drop SPPG`t'

    forvalues j=1/$nb_e {
        mat SP2`j'PGSP`t'=SP2`j'PG`t'*IR`j'`t' + DS`t'*IR`j'`t' + IR`j'`t'*(DS`t')'*IR`j'`t'
        mat drop SP2`j'PG`t'
            }


    matginv(SPPGSP`t'), ginv(SPPGSPI`t')
    mat drop SPPGSP`t'

    forvalues j=1/$nb_e{
        matginv(SP2`j'PGSP`t'), ginv(SP2`j'PGSPI`t')
        mat drop SP2`j'PGSP`t'
            }

    mat PW`t'=DS`t'*SPPGSPI`t'
    /*mat drop SPPGSPI`t'*/

    forvalues j=1/$nb_e {
        mat PW`j'`t'=IR`j'`t'*DS`t'*IR`j'`t'*SP2`j'PGSPI`t'
        /*mat drop SP2`j'PGSPI`t'*/
            }
    
    mat P2W1`t'=PW1`t'[1..$nb_b,1..$nb_p]
    mat P2W`t'=P2W1`t'
    forvalues j=2/$nb_e {
        mat P2W`j'`t'=PW`j'`t'[(`j'-1)*$nb_b+1..`j'*$nb_b,1..$nb_p]
        mat P2W`t'=P2W`t'\P2W`j'`t'
            }
        }


/***competition : Collusion***/

forvalues t=1/$T {
    di "t vaut " `t'
    mat PWSP`t'=PW`t'*DS`t'
    mat P2WSP`t'=P2W`t'*DS`t'
    matginv(PWSP`t'),ginv(PWSPI`t')
    matginv(P2WSP`t'),ginv(P2WSPI`t')
    mat drop PWSP`t'
    mat drop P2WSP`t'
    mat gammaP`t'=-PWSPI`t'*sj_p_star_`t'
    mat gamma2P`t'=-P2WSPI`t'*sj_p_star_`t'
    mat drop PWSPI`t'
    mat drop P2WSPI`t'
    svmat gammaP`t'
    svmat gamma2P`t'
    mat drop gammaP`t'
    mat drop gamma2P`t'
        }

forvalues t=1/$T {
    bysort retailer brand: egen gammaP`t'1b=max(gammaP`t'1)
    bysort retailer brand: egen gamma2P`t'1b=max(gamma2P`t'1)
    drop gammaP`t'1
        }

sort trend retailer brand

gen gamma3P=gammaP11b if trend==1
drop gammaP11b
forvalues t=2/$T {
    replace gamma3P=gammaP`t'1b if trend==`t'
    drop gammaP`t'1b
        }
gen Pgamma3P=gamma3P/price*100

gen gamma5P=gamma2P11b if trend==1
drop gamma2P11b
forvalues t=2/$T {
    replace gamma5P=gamma2P`t'1b if trend==`t'
    drop gamma2P`t'1b
        }
gen Pgamma5P=gamma5P/price*100


/***competition : Bertrand Nash***/

forvalues t=1/$T {
    drop gamma2P`t'1
        }

forvalues i=1/$nb_m {
    di "i vaut "`i'
    forvalues t=1/$T {
        di "t vaut " `t'
        mat PWSP`i'`t'=IF`i'`t'*PW`t'*DS`t'*IF`i'`t'
        mat P2WSP`i'`t'=IF`i'`t'*P2W`t'*DS`t'*IF`i'`t'
        matginv(PWSP`i'`t'), ginv(PWSPI`i'`t')
        matginv(P2WSP`i'`t'), ginv(P2WSPI`i'`t')
        mat drop PWSP`i'`t'
        mat drop P2WSP`i'`t'
        mat gammaP`i'`t'=-PWSPI`i'`t'*IF`i'`t'*sj_p_star_`t'
        mat gamma2P`i'`t'=-P2WSPI`i'`t'*IF`i'`t'*sj_p_star_`t'
        mat drop PWSPI`i'`t'
        mat drop P2WSPI`i'`t'
        svmat gammaP`i'`t'
        mat drop gammaP`i'`t'
        svmat gamma2P`i'`t'
        mat drop gamma2P`i'`t'
            }
        }
forvalues i=1/$nb_m {
    forvalues t=1/$T {
        bysort retailer brand: egen gammaP`i'`t'1b=max(gammaP`i'`t'1)
        drop gammaP`i'`t'1
        bysort retailer brand: egen gamma2P`i'`t'1b=max(gamma2P`i'`t'1)
        drop gamma2P`i'`t'1
            }
        }

sort trend retailer brand


forvalues i=1/$nb_m {
    gen gamma4P`i'=gammaP`i'11b if trend==1
    drop gammaP`i'11b
    forvalues t=2/$T {
        replace gamma4P`i'=gammaP`i'`t'1b if trend==`t' 
        drop gammaP`i'`t'1b 
            } 
        } 

gen gamma4P=.
forvalues i=1/$nb_m {
    replace gamma4P=gamma4P`i' if manufacturer==`i' 
            }
gen Pgamma4P=gamma4P/price*100 


forvalues i=1/$nb_m {
    gen gamma6P`i'=gamma2P`i'11b if trend==1
    drop gamma2P`i'11b 
    forvalues t=2/$T {
        replace gamma6P`i'=gamma2P`i'`t'1b if trend==`t' 
        drop gamma2P`i'`t'1b 
            } 
        } 

gen gamma6P=.
forvalues i=1/$nb_m {
    replace gamma6P=gamma6P`i' if manufacturer==`i' 
            }
gen Pgamma6P=gamma6P/price*100 

 

/********Two part Tariff*******/


/*****No uniform pricing******/


/***** With Resale price Maintenance *****/


/***First case w=mc***/

sort trend retailer brand
forvalues t=1/$T {
    mat margeb`t'=J($nb_p,1,0)
    mat marge`t'=J($nb_p,$nb_p,0)

    forvalues f=1/$nb_m {
        mat A`f'_`t'=IF`f'`t'*DS`t' 
        mat y`f'_`t'=IF`f'`t'*sj_p_star_`t'
        mat marge`t'=marge`t'+(A`f'_`t')'*A`f'_`t'
        mat margeb`t'=margeb`t'+(A`f'_`t')'*y`f'_`t'
        mat drop A`f'_`t' y`f'_`t'
            }
    
    matginv(marge`t'), ginv(margea`t')
    mat margeRPM`t'=-margea`t'*margeb`t'
    capture drop margeRPM`t'1
    svmat margeRPM`t'

    mat drop marge`t'
    mat drop margea`t'
    mat drop margeb`t'
        } 


gen margeRPM=0
forvalues t=1/$T {
    bysort retailer brand: egen margeRPM`t'1b=max(margeRPM`t'1) 
    replace margeRPM=margeRPM`t'1b if trend==`t'
    drop margeRPM`t'1b
    drop margeRPM`t'1
        } 
sort trend retailer brand


gen PmargeRPM=margeRPM/price*100
replace PmargeRPM=. if PmargeRPM==0



/***Second case : p-w-c=0***/

forvalues i=1/$nb_m {
    forvalues t=1/$T {
        mat SPaI`i'`t'=IF`i'`t'*DS`t'*IF`i'`t'
        matginv(SPaI`i'`t'), ginv(SPaII`i'`t') 
        mat drop SPaI`i'`t' 
        mat gamama`i'`t'=-SPaII`i'`t'*IF`i'`t'*sj_p_star_`t'
        mat drop SPaII`i'`t' 
        svmat gamama`i'`t' 
        mat drop gamama`i'`t'
            } 
        } 


forvalues i=1/$nb_m {
    gen gamama`i'=0
    forvalues t=1/$T {
        bysort retailer brand: egen gamama`i'`t'1b=max(gamama`i'`t'1) 
        replace gamama`i'=gamama`i'`t'1b if trend==`t'
        drop gamama`i'`t'1b gamama`i'`t'1 
            } 
        } 


sort trend retailer brand

gen gammaRPM2=.

forvalues f=1/$nb_m {
    replace gammaRPM2=gamama`f' if manufacturer==`f'
            }

gen PgammaRPM2=gammaRPM2/price*100


/*****Without Resale price Maintenance*****/

forvalues i=1/$nb_m {
    forvalues t=1/$T {
        mat SPI`i'`t'=IF`i'`t'*P2W`t'*DS`t'*IF`i'`t'
        matginv(SPI`i'`t'), ginv(SPII`i'`t') 
        mat drop SPI`i'`t' 
        mat gamma`i'`t'=-SPII`i'`t'*(IF`i'`t'*P2W`t'*sj_p_star_`t'+ IF`i'`t'*P2W`t'*DS`t'*((I($nb_p)-IF`i'`t')*gamma2D`t'))
        mat drop SPII`i'`t' 
        svmat gamma`i'`t' 
        mat drop gamma`i'`t'
            } 
        } 

forvalues i=1/$nb_m {
    gen gammaS`i'=0
    forvalues t=1/$T {
        bysort retailer brand: egen gammaS`i'`t'1b=max(gamma`i'`t'1) 
        replace gammaS`i'=gammaS`i'`t'1b if trend==`t'
        drop gammaS`i'`t'1b gamma`i'`t'1 
            } 
        } 
sort trend retailer brand

gen margeWRPM=.
forvalues i=1/$nb_m { 
    replace margeWRPM=gammaS`i' if manufacturer==`i'
    drop gammaS`i'
            }
gen PmargeWRPM=margeWRPM/price*100




/*****Uniform pricing******/


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


/***** With Resale price Maintenance *****/


/***Second case : p-w-c=0***/

forvalues i=1/$nb_m {
    forvalues t=1/$T {
        mat SPaI`i'`t'=IF`i'`t'*DS`t'*IFU`i'`t'
        matginv(SPaI`i'`t'), ginv(SPaII`i'`t') 
        mat drop SPaI`i'`t' 
        mat gamama`i'`t'=-SPaII`i'`t'*IF`i'`t'*sj_p_star_`t'
        mat drop SPaII`i'`t' 
        mat gamama`i'`t'=IFU`i'`t'*gamama`i'`t'
        svmat gamama`i'`t' 
        mat drop gamama`i'`t'
            } 
        } 


forvalues i=1/$nb_m {
    gen gamamaU`i'=0
    forvalues t=1/$T {
        bysort retailer brand: egen gamama`i'`t'1b=max(gamama`i'`t'1) 
        replace gamamaU`i'=gamama`i'`t'1b if trend==`t'
        drop gamama`i'`t'1b gamama`i'`t'1 
            } 
        } 


sort trend retailer brand

gen gammaRPM2_unif=.

forvalues f=1/$nb_m {
    replace gammaRPM2_unif=gamamaU`f' if manufacturer==`f'
            }

gen PgammaRPM2_unif=gammaRPM2_unif/price*100


/*****Without Resale price Maintenance*****/


/*Computation of PwU*/

forvalues t=1/$T {

    forvalues j=1/$nb_e {
        mat SP2`j'PG`t'=D`t'SPP1*IR`j'`t'*gamma2D`t'
            }
    
    forvalues i=2/$nb_p {   
        forvalues j=1/$nb_e {
            mat SP2`j'P`i'`t'=D`t'SPP`i'*IR`j'`t'*gamma2D`t'
            mat SP2`j'PG`t'=SP2`j'PG`t',SP2`j'P`i'`t'
            mat drop SP2`j'P`i'`t'
                    }
              }

                
          

    forvalues j=1/$nb_e{
        mat SP2`j'PGSP`t'=SP2`j'PG`t'*IR`j'`t' + DS`t'*IR`j'`t' + IR`j'`t'*(DS`t')'*IR`j'`t'
        mat drop SP2`j'PG`t'
        matginv(SP2`j'PGSP`t'), ginv(SP2`j'PGSPI`t')
        mat drop SP2`j'PGSP`t'
        mat PW`j'`t'=(IRU`j'`t')'*(DS`t')'*IR`j'`t'*SP2`j'PGSPI`t'
        mat drop SP2`j'PGSPI`t'
            }


    mat P2W1`t'=PW1`t'[1..$nb_b,1..$nb_b]
    mat P2UW`t'=P2W1`t'
    forvalues j=2/$nb_e {
        mat P2W`j'`t'=PW`j'`t'[1..$nb_b,(`j'-1)*$nb_b+1..`j'*$nb_b]
        mat P2UW`t'=P2UW`t',P2W`j'`t'
            }

        } /*end of the t loop*/






forvalues i=1/$nb_m {
    forvalues t=1/$T {
        mat SPI`i'`t'=IFU`i'`t'*P2UW`t'*DS`t'*IFU`i'`t'
        matginv(SPI`i'`t'), ginv(SPII`i'`t') 
        mat drop SPI`i'`t' 
        mat gamma`i'`t'=-SPII`i'`t'*(IFU`i'`t'*P2UW`t'*sj_p_star_`t'+ IFU`i'`t'*P2UW`t'*DS`t'*((I($nb_p)-IF`i'`t')*gamma2D`t'))
        mat drop SPII`i'`t' 
        mat gamma`i'`t'=IFU`i'`t'*gamma`i'`t'
        capture drop gamma`i'`t'1
        svmat gamma`i'`t' 
        mat drop gamma`i'`t'
            } 
        } 

forvalues i=1/$nb_m {
    capture drop gammaS`i'
    gen gammaS`i'=0
    forvalues t=1/$T {
        capture drop gammaS`i'`t'1b
        bysort retailer brand: egen gammaS`i'`t'1b=max(gamma`i'`t'1) 
        qui replace gammaS`i'=gammaS`i'`t'1b if trend==`t'
        drop gammaS`i'`t'1b gamma`i'`t'1 
            } 
        } 
sort trend retailer brand

gen margeWRPM_unif=.
forvalues i=1/$nb_m { 
    qui replace margeWRPM_unif=gammaS`i' if manufacturer==`i'
    drop gammaS`i'
            }
gen PmargeWRPM_unif=margeWRPM_unif/price*100



/****Monopole****/

forvalues i=1/$nb_m {
    forvalues t=1/$T {
        matginv(DS`t'), ginv(IDS`t') 
        mat gammma`i'`t'=-IDS`t'*sj_p_star_`t'
        svmat gammma`i'`t' 
        mat drop gammma`i'`t'
            } 
        } 


forvalues i=1/$nb_m {
    gen gammma`i'=0
    forvalues t=1/$T {
        bysort retailer brand: egen gammma`i'`t'1b=max(gammma`i'`t'1) 
        replace gammma`i'=gammma`i'`t'1b if trend==`t'
        drop gammma`i'`t'1b gammma`i'`t'1 
            } 
        } 


sort trend retailer brand

gen gammaMonop=.

forvalues f=1/$nb_m {
    replace gammaMonop=gammma`f' if manufacturer==`f'
            }

gen PgammaMonop=gammaMonop/price*100


save margins.dta, replace



profiler off
profiler report
