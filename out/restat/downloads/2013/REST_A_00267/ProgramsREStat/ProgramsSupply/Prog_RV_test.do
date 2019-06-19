clear
pause off 
set mem 100m 
set matsize 4500

cd c:\Celine\Recherche\bdv\data

use "margins.dta", clear

sort trend retailer brand
tsset trend productid

gen pcm1=price - gamma1D - gamma1P /*C BN BN*/
gen pcm2=price - margeRPM /*RPM (w=mc)*/
gen pcm3=price - gammaRPM2 /*RPM (p-w-c=0)*/
gen pcm4=price - margeWRPM - gamma2D /*sans RPM*/
gen pcm5=price - gammaRPM2_unif /*RPM (p-w-c=0) & uniform pricing*/
gen pcm6=price - margeWRPM_unif - gamma2D /*sans RPM  & uniform pricing*/


forvalues i=1/6 {
    gen margin`i'=price-pcm`i'
    replace margin`i'=. if margin`i'==0
    gen lnpcm`i'=ln(pcm`i')
    replace lnpcm`i'=. if pcm`i'<0
    replace price=. if pcm`i'==.
        }




sort trend retailer brand


gen const=1



/******HETEROSCEDASTICITE???????******/
drop if id==.
forvalues i=1/6 {
    xi : reg pcm`i' i.brand*i.trend i.retailer*i.trend 
    predict u`i', r
    gen u2`i'=u`i'*u`i'
    egen ec`i'=sd(u`i')
    egen ec2`i'=sd(u2`i')
    egen Slny`i'=sum(u`i'*u`i') 
            }
        
gen point=.
replace point=1 if u1!=. & u2!=. & u3!=. & u4!=. & u5!=. & u6!=. 

forvalues i=1/6 {
    sum point
    local T=r(N)

    mkmat u`i' if point==1
    mkmat u2`i' if point==1
    mkmat ec`i' if point==1

            }

mat ST=0,0,0
mat LR=0,0
mat var=0
mat L2R=0,0
mat v=0
mat w=0
mat RVa=0
mat varRV=0
mat seuil=0

drawnorm v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 v16 v17 v18 v19 v20 v21 v22 v24 v25 v26 v27


forvalues i=1/6 { /*hypothèse nulle*/
    forvalues j=2/6 { /*alternative*/
        sum point
        local T=r(N)


        /*Calcul  de la statistique de test de Vuong*/
        egen LR`i'a`j'=sum(ln(ec`j'/ec`i') - 0.5*(u`i'/ec`i')*(u`i'/ec`i') + 0.5*(u`j'/ec`j')*(u`j'/ec`j'))
        gen LR`i'b`j'=ln(ec`j'/ec`i') - 0.5*(u`i'/ec`i')*(u`i'/ec`i') + 0.5*(u`j'/ec`j')*(u`j'/ec`j')
        mkmat LR`i'a`j' if point==1

        /*mat LRij=`i'`j',2*(Slny`i'[1]-Slny`j'[1])*/
        mat LRij=`i'`j',2*LR`i'a`j'[1,1]
        egen v`i'a`j'=sd(LR`i'b`j')
        gen v2`i'a`j'=v`i'a`j'*v`i'a`j'
        mkmat v2`i'a`j' if point==1
        mkmat v`i'a`j'
        mat LR=LR\LRij
        mat var=var\v2`i'a`j'[1,1]  
        mat L2Rij=`i'`j',(1/sqrt(`T'))*LR`i'a`j'[1,1]/v`i'a`j'[1,1]
        mat L2R=L2R\L2Rij
        mat v=v\v`i'a`j'[1,1]
        

        /*Calcul de la statistique de test de Rivers et Vuong*/
        egen RV`i'a`j'= sum(u2`j'- u2`i')
        gen D`i'a`j'= u2`j'- u2`i'
        egen ec`i'a`j'=sd(D`i'a`j')
        gen varRV`i'a`j'=ec`i'a`j'*ec`i'a`j'
        gen RVa`i'a`j'=(1/ec`i'a`j')*RV`i'a`j'
        replace RVa`i'a`j'=RVa`i'a`j'/(sqrt(`T'))
        mkmat RVa`i'a`j' if point==1
        mat RVa=RVa\RVa`i'a`j'[1,1]
        mkmat varRV`i'a`j' if point==1
        mat varRV=varRV\varRV`i'a`j'[1,1]
        

                    }
            }
mat result=L2R,RVa
mat list result 

/*mat list ST , f(%4.2f)
mat list LRR , f(%4.2f)*/
/*Ecriture de la statistique de Vuong*/
/*sum LR*  */
