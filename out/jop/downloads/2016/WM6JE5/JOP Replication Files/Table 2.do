*
*This file replicates the primary (Table 2) results reported in 
*"Droughts, Land Appropriation, and Rebel Violence in The Developing World"
*by Benjamin E. Bagozzi, Ore Koren, and Bumba Mukherjee
*

****************************************
******Estimated Effect of Drought*******
****************************************

*clear stata, set working directory
clear
set more off
cd "\JOP Replication Files\"

*read-in replication dataset
use "JOP_drought.dta", clear 

*estimate main model
xi:zinb incidentnonstatefull lagcivconflagtemp spidum loglagttime loglagcellarea laglogpop loglagppp lagp_polity2 loglagbdist1 lagurban lagcropland loglagwdi_gdpc laggroupsum spatialDVlag t t2 t3 if lagcropland>0, inflate(laglogpop loglagttime lagcivconflagtemp lagurban loglagwdi_gdpc lagp_polity2 spidum) cluster(gid)
preserve
set seed 339487731
drawnorm SN_b1-SN_b26, n(10000) means(e(b)) cov(e(V)) clear

*generate loop to calculate desired quantities of interest
postutil clear
postfile mypost prob_hat0 lo0 hi0 using "sim.dta", replace           
noisily display "start"
            
*start loop
local a=0 
while `a' <= 0 { 

{
scalar h_lagcivconflagtemp=0
scalar h_spidum =0
scalar h_loglagttime =5.916
scalar h_loglagcellarea =7.709
scalar h_loglagpop =10.234 
scalar h_loglagppp =.616
scalar h_lagp_polity2 =1.823
scalar h_loglagbdist1 =4.998
scalar h_lagurban=.216
scalar h_lagcropland= 29.669
scalar h_loglagwdi_gdpc =8.127
scalar h_laggroupsum =1.706
scalar h_spatialDVlag=.0029992
scalar h_t= 7
scalar h_t2 =49
scalar h_t3 =343
scalar h_constant=1    

    generate x_betahat0  = SN_b1*h_lagcivconflagtemp+SN_b2*0+SN_b3*h_loglagttime+SN_b4*h_loglagcellarea+SN_b5*h_loglagpop+SN_b6*h_loglagppp+SN_b7*h_lagp_polity2+SN_b8*h_loglagbdist1+SN_b9*h_lagurban+SN_b10*h_lagcropland+SN_b11*h_loglagwdi_gdpc+SN_b12*h_laggroupsum+SN_b13*h_spatialDVlag+SN_b14*h_t+SN_b15*h_t2+SN_b16*h_t3+SN_b17*h_constant
    generate x_betahat1  = SN_b1*h_lagcivconflagtemp+SN_b2*1+SN_b3*h_loglagttime+SN_b4*h_loglagcellarea+SN_b5*h_loglagpop+SN_b6*h_loglagppp+SN_b7*h_lagp_polity2+SN_b8*h_loglagbdist1+SN_b9*h_lagurban+SN_b10*h_lagcropland+SN_b11*h_loglagwdi_gdpc+SN_b12*h_laggroupsum+SN_b13*h_spatialDVlag+SN_b14*h_t+SN_b15*h_t2+SN_b16*h_t3+SN_b17*h_constant

    gen prob0 =(exp(x_betahat1)-exp(x_betahat0))/exp(x_betahat0)
    
    egen probhat0 =mean(prob0)
    
    tempname prob_hat0 lo0 hi0 

    _pctile prob0, p(2.5,97.5) 
    scalar `lo0' = r(r1)
    scalar `hi0' = r(r2) 
    scalar `prob_hat0'=probhat0
    
    post mypost (`prob_hat0') (`lo0') (`hi0') 
   
    }    
    
    drop x_betahat0 x_betahat1 prob0 probhat0 
    
    local a=`a'+ 1
    
    display "." _c
    
} 

display ""

postclose mypost

***************************************************
******Print Quantities of Interest to Screen*******
***************************************************
restore
merge using "sim.dta"
table prob_hat0
table lo0
table hi0


***********************************************
******Estimated Effect of Civil Conflict*******
***********************************************

*clear stata, set working directory
clear
set more off
cd "\JOP Replication Files\"

*read-in replication dataset
use "JOP_drought.dta", clear 

*estimate main model
xi:zinb incidentnonstatefull lagcivconflagtemp spidum loglagttime loglagcellarea laglogpop loglagppp lagp_polity2 loglagbdist1 lagurban lagcropland loglagwdi_gdpc laggroupsum spatialDVlag t t2 t3 if lagcropland>0, inflate(laglogpop loglagttime lagcivconflagtemp lagurban loglagwdi_gdpc lagp_polity2 spidum) cluster(gid
preserve
set seed 33948773
drawnorm SN_b1-SN_b26, n(10000) means(e(b)) cov(e(V)) clear

*generate loop to calculate desired quantities of interest
postutil clear
postfile mypost prob_hat0 lo0 hi0 using "sim.dta", replace     
noisily display "start"
            
*start loop
local a=0 
while `a' <= 0 { 

{
scalar h_lagcivconflagtemp=0
scalar h_spidum =0
scalar h_loglagttime =5.916
scalar h_loglagcellarea =7.709
scalar h_loglagpop =10.234 
scalar h_loglagppp =.616
scalar h_lagp_polity2 =1.823
scalar h_loglagbdist1 =4.998
scalar h_lagurban=.216
scalar h_lagcropland= 29.669
scalar h_loglagwdi_gdpc =8.127
scalar h_laggroupsum =1.706
scalar h_spatialDVlag=.0029992
scalar h_t= 7
scalar h_t2 =49
scalar h_t3 =343
scalar h_constant=1       

    generate x_betahat0  = SN_b1*0+SN_b2*h_spidum+SN_b3*h_loglagttime+SN_b4*h_loglagcellarea+SN_b5*h_loglagpop+SN_b6*h_loglagppp+SN_b7*h_lagp_polity2+SN_b8*h_loglagbdist1+SN_b9*h_lagurban+SN_b10*h_lagcropland+SN_b11*h_loglagwdi_gdpc+SN_b12*h_laggroupsum+SN_b13*h_spatialDVlag+SN_b14*h_t+SN_b15*h_t2+SN_b16*h_t3+SN_b17*h_constant
    generate x_betahat1  = SN_b1*1+SN_b2*h_spidum+SN_b3*h_loglagttime+SN_b4*h_loglagcellarea+SN_b5*h_loglagpop+SN_b6*h_loglagppp+SN_b7*h_lagp_polity2+SN_b8*h_loglagbdist1+SN_b9*h_lagurban+SN_b10*h_lagcropland+SN_b11*h_loglagwdi_gdpc+SN_b12*h_laggroupsum+SN_b13*h_spatialDVlag+SN_b14*h_t+SN_b15*h_t2+SN_b16*h_t3+SN_b17*h_constant

    gen prob0 =(exp(x_betahat1)-exp(x_betahat0))/exp(x_betahat0)
    
    egen probhat0 =mean(prob0)
    
    tempname prob_hat0 lo0 hi0 

    _pctile prob0, p(2.5,97.5) 
    scalar `lo0' = r(r1)
    scalar `hi0' = r(r2) 
    scalar `prob_hat0'=probhat0
    
    post mypost (`prob_hat0') (`lo0') (`hi0') 
   
    }    
    
    drop x_betahat0 x_betahat1 prob0 probhat0 
    
    local a=`a'+ 1
    
    display "." _c
    
} 

display ""

postclose mypost

***************************************************
******Print Quantities of Interest to Screen*******
***************************************************
restore
merge using "sim.dta"
table prob_hat0
table lo0
table hi0


****************************************************
******Estimated Effect of Spatially Lagged DV*******
****************************************************

*clear stata, set working directory
clear
set more off
cd "\JOP Replication Files\"

*read-in replication dataset
use "JOP_drought.dta", clear 

*estimate main model
xi:zinb incidentnonstatefull lagcivconflagtemp spidum loglagttime loglagcellarea laglogpop loglagppp lagp_polity2 loglagbdist1 lagurban lagcropland loglagwdi_gdpc laggroupsum spatialDVlag t t2 t3 if lagcropland>0, inflate(laglogpop loglagttime lagcivconflagtemp lagurban loglagwdi_gdpc lagp_polity2 spidum) cluster(gid)
preserve
set seed 339487731
drawnorm SN_b1-SN_b26, n(10000) means(e(b)) cov(e(V)) clear

*generate loop to calculate desired quantities of interest
postutil clear
postfile mypost prob_hat0 lo0 hi0 using "sim.dta", replace       
noisily display "start"
            
*start loop
local a=0 
while `a' <= 0 { 

{
scalar h_lagcivconflagtemp=0
scalar h_spidum =0
scalar h_loglagttime =5.916
scalar h_loglagcellarea =7.709
scalar h_loglagpop =10.234 
scalar h_loglagppp =.616
scalar h_lagp_polity2 =1.823
scalar h_loglagbdist1 =4.998
scalar h_lagurban=.216
scalar h_lagcropland= 29.669
scalar h_loglagwdi_gdpc =8.127
scalar h_laggroupsum =1.706
scalar h_spatialDVlag=.0029992
scalar h_t= 7
scalar h_t2 =49
scalar h_t3 =343
scalar h_constant=1      

    generate x_betahat0  = SN_b1*h_lagcivconflagtemp+SN_b2*h_spidum+SN_b3*h_loglagttime+SN_b4*h_loglagcellarea+SN_b5*h_loglagpop+SN_b6*h_loglagppp+SN_b7*h_lagp_polity2+SN_b8*h_loglagbdist1+SN_b9*h_lagurban+SN_b10*h_lagcropland+SN_b11*h_loglagwdi_gdpc+SN_b12*h_laggroupsum+SN_b13*(.0029992)+SN_b14*h_t+SN_b15*h_t2+SN_b16*h_t3+SN_b17*h_constant
    generate x_betahat1  = SN_b1*h_lagcivconflagtemp+SN_b2*h_spidum+SN_b3*h_loglagttime+SN_b4*h_loglagcellarea+SN_b5*h_loglagpop+SN_b6*h_loglagppp+SN_b7*h_lagp_polity2+SN_b8*h_loglagbdist1+SN_b9*h_lagurban+SN_b10*h_lagcropland+SN_b11*h_loglagwdi_gdpc+SN_b12*h_laggroupsum+SN_b13*(.0029992+.0303936)+SN_b14*h_t+SN_b15*h_t2+SN_b16*h_t3+SN_b17*h_constant

    gen prob0 =(exp(x_betahat1)-exp(x_betahat0))/exp(x_betahat0)
    
    egen probhat0 =mean(prob0)
    
    tempname prob_hat0 lo0 hi0 

    _pctile prob0, p(2.5,97.5) 
    scalar `lo0' = r(r1)
    scalar `hi0' = r(r2) 
    scalar `prob_hat0'=probhat0
    
    post mypost (`prob_hat0') (`lo0') (`hi0') 
   
    }    
    
    drop x_betahat0 x_betahat1 prob0 probhat0 
    
    local a=`a'+ 1
    
    display "." _c
    
} 

display ""

postclose mypost

***************************************************
******Print Quantities of Interest to Screen*******
***************************************************
restore
merge using "sim.dta"
table prob_hat0
table lo0
table hi0





