
*** CT DECOMPOSITION: SCENARIOS >95, 3 rebal and 4 rebal 	 ***
****************************************************************
clear all
set mem 500m
set more off
set seed 12345

************************************************************************************************************
* SCENARIO 1: DOLdollar SAMPLE (>95), MAY90-MAY10 														 ***
************************************************************************************************************

cd C:\Users\RMano\Desktop\Mypapers\Tarek\HassanManoQJE

use "Input\Data\DOLdollar_BIG_ALLfwd_clean.dta"

keep if countries=="C2" | countries=="C4" | countries=="C5" | countries=="C8" | countries=="C15" | ///
countries=="C22" | countries=="C24" | countries=="C26" | countries=="C28" | countries=="C29" | ///
countries=="C33" | countries=="C34" | countries=="C35" | countries=="C41" | countries=="C42"

sort countriesnum time
xtset countriesnum time

tab countries
local N = r(r)

save "Temp\temp1.dta", replace

/* GET OVERALL AVERAGE FP
egen fpi = mean(fp1m) if fp1m!=., by(countries)
egen fp = mean(fpi) if fpi!=., by(time)

sum fp
mat fp = r(mean)
drop fpi fp
*/


{
/* (A) IN SAMPLE */
************************************************************************************************************

keep if time>=419

************************************************************************************************************
* GENERATE VARIABLES NEEDED FOR THE REGRESSIONS
************************************************************************************************************
* create avgfp
egen avgfp1m = mean(fp1m) if fp1m!=., by(countries)
egen rxi = mean(rx1m1) if rx1m1!=., by(countries)
rename avgfp1m fpi
egen fp = mean(fpi) if fpi!=., by(time)

* Generate averages: time and country level
egen rxt = mean(rx1m1) if rx1m1!=., by(time)
egen rx = mean(rxi) if rxi!=., by(time)

gen drxi = rxi - rx
gen rxhml = rx1m1 - rxt
gen rxwithin = rxhml - drxi
gen rxfpp = rx1m1 - rxi
gen drxt = rxt - rx

* Generate all ds variables
egen dsi = mean(ds1m), by(countries)
egen dst = mean(ds1m) if ds1m!=., by(time)
egen ds = mean(dsi) if dsi!=., by(time)

gen ddsi = dsi - ds
gen dshml = ds1m - dst
gen dswithin = dshml - ddsi
gen dsfpp = ds1m - dsi
gen ddst = dst - ds

egen fpt = mean(fp1m) if fp1m!=., by(time)

gen fphml = fp1m - fpt
gen dfpi = fpi - fp
gen fpwithin = fphml - dfpi
gen fpfpp = fp1m - fpi
gen dfpt = fpt - fp

gmm (rxwithin - {bdyn}*fpwithin), instruments(fpwithin, noconstant) winitial(identity) wmatrix(hac nwest 12)
mat bdyn = e(b)
mat B_in = bdyn
mat se = e(V)
mat SE_in = sqrt(se[1,1])

gmm (eq1: rxfpp - {afpp} - {bfpp}*fpfpp), instruments(eq1: fpfpp) winitial(identity) wmatrix(hac nwest 12)
mat bfpp = e(b)
mat bfpp = bfpp[1,2]
mat B_in = [B_in,bfpp[1,1]]
mat se = e(V)
mat SE_in = [SE_in, sqrt(se[2,2])]

* GET fpiIN
keep countriesnum countries time fpwithin fpfpp dfpi fpi fp dfpt
rename fpwithin fpwithinIN
rename fpfpp fpfppIN
rename dfpi dfpiIN
rename dfpt dfptIN
rename fpi fpiIN
rename fp fpIN
sort countriesnum time

mata fpwithinIN = st_data(.,("fpwithinIN"))
mata fpiIN = st_data(.,("fpiIN"))

merge 1:1 countries time using "Temp\temp1.dta"
drop _merge

sort countriesnum time
}



/* (B) STRICTLY OOS */
************************************************************************************************************
* Declare common parameters
scalar finish = 604
scalar cut = 419
scalar periods = finish-cut+1

levelsof countriesnum, local(clist)
mat N = r(N)
xtset countriesnum time

corr fpwithinIN fpfppIN if time>=419, cov

mat var = r(C)
mat vdyn = var[1,1]
mat vfpp = var[2,2]

local S = 10 /* # scenarios */

* store results
mat B_all =  J(`S',2,0)
mat SE_all = J(`S',2,0)

mata
K = 1000 /* # of paths */
T = 604-419+1 /* # periods for each simulation */
S = 10 /* # scenarios */

bdyn = st_matrix("bdyn")
bfpp = st_matrix("bfpp")
vdyn = st_matrix("vdyn")
vfpp = st_matrix("vfpp")

DYNbias = J(1,S,.)
FPPbias = J(1,S,.)
varfpi = J(1,S,.)
Vfpihat = J(1,S,.)
sdfpi = J(1,S,.)

end

************************************************************************************************************
* MEAN: ONLY pre-sample AS IN THE PAPER
************************************************************************************************************
* SCENARIO #
local s = 1
{
preserve
* BEFORE 1995 
gen fp1mtemp = fp1m if time<=cut
egen fpi = mean(fp1mtemp) if fp1m!=., by(countries)
drop fp1mtemp


keep if time==419

mata 

fpihat = st_data(.,("fpi"))
fpi0 = st_data(.,("fp1m"))

fpihat = fpihat#J(T,1,1)
error = fpihat-fpiIN
var = quadvariance(error)
/*
er_m = quadcolsum(error)/2706
er_m = er_m*J(2790,1,1)
var_n = quadcolsum((error - er_m):^2)
var_d = quadcolsum(fpwithinIN:^2)
DYNbias[1,1] = 1+var_n/var_d*/
vfpihat = quadvariance(fpihat)
Vfpihat[1,`s'] = vfpihat
DYNbias[1,`s'] = 1+var/vdyn
FPPbias[1,`s'] = 1+var/vfpp
varfpi[1,`s'] = var
sdfpi[1,`s'] = sqrt(var)*1200

end
restore
}

************************************************************************************************************
* AR(1): common rho, common sigma (iid), different alpha_i
************************************************************************************************************
* SCENARIO #
local s = 2

{
preserve
* 1) ESTIMATION: using pre-sample
keep if time>=364
*keep if time<=419
* declare parameters
tempvar rho sig

g fp1m_1 = l.fp1m
xi i.countriesnum, noomit

quietly reg fp1m fp1m_1 _Icou*, noconstant

* store parameters
levelsof countriesnum, local(clist)
mat alpha = J(15,1,.)
local i = 15
foreach c of local clist {
mat alpha[`i',1] = _b[_Icountries_`c']
local `i--'
}
mat rho = _b[fp1m_1]
mat sig = e(rss)/e(df_r)
restore

preserve
* 2) GENERATE PATHS
keep if time>=419
mata 
sig = st_matrix("sig")
alpha = st_matrix("alpha")
rho = st_matrix("rho")
MATfpihat = J(`N',K,.) 

end

mata 
for (k=1; k<=K; k++) {
eps = sqrt(sig)*invnormal(uniform(`N',T))

/* matrix to store fp_{i,t} */
fpit = J(`N', T, 0)

fpit[.,1] = fpi0

for (t=2; t<=T; t++) {
	fpit[.,t] = alpha + rho*fpit[.,t-1] + eps[.,t]
}

fpihat = mean(fpit')

MATfpihat[.,k] = fpihat'
}
end

* GET VAR(fpi-fpihat)
mata 
fpihat = mean(MATfpihat')

fpihat = fpihat'#J(T,1,1)
error = fpihat-fpiIN
var = quadvariance(error)
/*var_n = quadsum(error:^2)
var_d = quadsum(fpwithinIN:^2)
DYNbias[1,`s'] = 1+var_n/var_d*/
DYNbias[1,`s'] = 1+var/vdyn 
FPPbias[1,`s'] = 1+var/vfpp
vfpihat = quadvariance(fpihat)
Vfpihat[1,`s'] = vfpihat
varfpi[1,`s'] = var
sdfpi[1,`s'] = sqrt(var)*1200

st_matrix("vfpihat",vfpihat)
st_addvar("float", "fpi")
st_store(., "fpi", fpihat )
end

/* GET VARIANCE fpi: REGRESSION */
* V(fpihat)
mat vfpi = vfpihat

replace fpi=. if fpiIN==.

egen rxi = mean(rx1m1) if rx1m1!=., by(countries)
egen fp = mean(fpi) if fpi!=., by(time)

* Generate averages: time and country level
egen rxt = mean(rx1m1) if rx1m1!=., by(time)
egen rx = mean(rxi) if rxi!=., by(time)

gen drxi = rxi - rx
gen rxhml = rx1m1 - rxt
gen rxwithin = rxhml - drxi
gen rxfpp = rx1m1 - rxi
gen drxt = rxt - rx
gen drxit = rx1m1-rx

egen fpt = mean(fp1m) if fp1m!=., by(time)

gen fphml = fp1m - fpt
gen dfpi = fpi - fp
gen fpwithin = fphml - dfpi
gen fpfpp = fp1m - fpi
gen dfpt = fpt - fp

* Generate all ds variables
egen dsi = mean(ds1m), by(countries)
egen dst = mean(ds1m) if ds1m!=., by(time)
egen ds = mean(dsi) if dsi!=., by(time)

gen ddsi = dsi - ds
gen dshml = ds1m - dst
gen dswithin = dshml - ddsi
gen dsfpp = ds1m - dsi
gen ddst = dst - ds

mat V = J(3,3,0)
mat B = J(3,1,.)

* DYNAMIC equation
gmm (rxwithin - {bdyn}*fpwithin), instruments(fpwithin, noconstant) winitial(identity) wmatrix(hac nwest 12)
estimates store dynOOS_95_`s'
mat V[2,2] = e(V)
mat B[2,1] = e(b)

reg rxwithin fpwithin, noconstant robust
reg rxwithin fpwithin, robust

{/* MT Adjustment: STACKED*/
g v = fpwithin^2
sum v if time>=cut

mat VMT = V[2,2] + _b[fpwithin]^2/`r(sum)'*vfpi[1,1]
mat seMTdyn = sqrt(VMT[1,1])
}

* FPP equation
gmm (eq1: rxfpp - {afpp} - {bfpp}*fpfpp), instruments(eq1: fpfpp) winitial(identity) wmatrix(hac nwest 12)
estimates store fppOOS_95_`s'
mat b = e(b)
mat b = b[1,2]
mat vf = e(V)
mat vf = vf[2,2]
{/* MT Adjustment: STACKED*/
* VAR(dfpi)
* DONE ABOVE
replace v = fpfpp^2
sum v if time>=cut

mat VMT = vf + b[1,1]^2/`r(sum)'*vfpi[1,1]
mat seMTfpp = sqrt(VMT[1,1])
}

mat B_all[`s',1] = B[2,1]
mat B_all[`s',2] = b

mat SE_all[`s',1] = seMTdyn 
mat SE_all[`s',2] = seMTfpp

restore
}


************************************************************************************************************
* AR(1): common rho, common sigma (iid), different alpha_i, ONLY pre-sample
************************************************************************************************************
* SCENARIO #
local s = 3

{
preserve
* 1) ESTIMATION: using pre-sample
*keep if time>=364
keep if time<=419
* declare parameters
tempvar rho sig

g fp1m_1 = l.fp1m
xi i.countriesnum, noomit

quietly reg fp1m fp1m_1 _Icou*, noconstant

* store parameters
levelsof countriesnum, local(clist)
mat alpha = J(15,1,.)
local i = 15
foreach c of local clist {
mat alpha[`i',1] = _b[_Icountries_`c']
local `i--'
}

mat rho = _b[fp1m_1]
mat sig = e(rss)/e(df_r)
restore

preserve
* 2) GENERATE PATHS
keep if time>=419
mata 
sig = st_matrix("sig")
alpha = st_matrix("alpha")
rho = st_matrix("rho")
MATfpihat = J(`N',K,.) 

end

mata 
for (k=1; k<=K; k++) {
eps = sqrt(sig)*invnormal(uniform(`N',T))

/* matrix to store fp_{i,t} */
fpit = J(`N', T, 0)

fpit[.,1] = fpi0

for (t=2; t<=T; t++) {
	fpit[.,t] = alpha + rho*fpit[.,t-1] + eps[.,t]
}

fpihat = mean(fpit')

MATfpihat[.,k] = fpihat'
}
end

* GET VAR(fpi-fpihat)
mata 
fpihat = mean(MATfpihat')

fpihat = fpihat'#J(T,1,1)
error = fpihat-fpiIN
var = quadvariance(error)
/*var_n = quadsum(error:^2)
var_d = quadsum(fpwithinIN:^2)
DYNbias[1,`s'] = 1+var_n/var_d*/
DYNbias[1,`s'] = 1+var/vdyn 
FPPbias[1,`s'] = 1+var/vfpp
vfpihat = quadvariance(fpihat)
Vfpihat[1,`s'] = vfpihat
varfpi[1,`s'] = var
sdfpi[1,`s'] = sqrt(var)*1200

st_matrix("vfpihat",vfpihat)
st_addvar("float", "fpi")
st_store(., "fpi", fpihat )
end

/* GET VARIANCE fpi: REGRESSION */
* V(fpihat)
mat vfpi = vfpihat

replace fpi=. if fpiIN==.

egen rxi = mean(rx1m1) if rx1m1!=., by(countries)
egen fp = mean(fpi) if fpi!=., by(time)

* Generate averages: time and country level
egen rxt = mean(rx1m1) if rx1m1!=., by(time)
egen rx = mean(rxi) if rxi!=., by(time)

gen drxi = rxi - rx
gen rxhml = rx1m1 - rxt
gen rxwithin = rxhml - drxi
gen rxfpp = rx1m1 - rxi
gen drxt = rxt - rx
gen drxit = rx1m1-rx

egen fpt = mean(fp1m) if fp1m!=., by(time)

gen fphml = fp1m - fpt
gen dfpi = fpi - fp
gen fpwithin = fphml - dfpi
gen fpfpp = fp1m - fpi
gen dfpt = fpt - fp

* Generate all ds variables
egen dsi = mean(ds1m), by(countries)
egen dst = mean(ds1m) if ds1m!=., by(time)
egen ds = mean(dsi) if dsi!=., by(time)

gen ddsi = dsi - ds
gen dshml = ds1m - dst
gen dswithin = dshml - ddsi
gen dsfpp = ds1m - dsi
gen ddst = dst - ds

mat V = J(3,3,0)
mat B = J(3,1,.)

* DYNAMIC equation
gmm (rxwithin - {bdyn}*fpwithin), instruments(fpwithin, noconstant) winitial(identity) wmatrix(hac nwest 12)
estimates store dynOOS_95_`s'
mat V[2,2] = e(V)
mat B[2,1] = e(b)

reg rxwithin fpwithin, noconstant robust
reg rxwithin fpwithin, robust

{/* MT Adjustment: STACKED*/
g v = fpwithin^2
sum v if time>=cut

mat VMT = V[2,2] + _b[fpwithin]^2/`r(sum)'*vfpi[1,1]
mat seMTdyn = sqrt(VMT[1,1])
}

* FPP equation
gmm (eq1: rxfpp - {afpp} - {bfpp}*fpfpp), instruments(eq1: fpfpp) winitial(identity) wmatrix(hac nwest 12)
estimates store fppOOS_95_`s'
mat b = e(b)
mat b = b[1,2]
mat vf = e(V)
mat vf = vf[2,2]
{/* MT Adjustment: STACKED*/
* VAR(dfpi)
* DONE ABOVE
replace v = fpfpp^2
sum v if time>=cut

mat VMT = vf + b[1,1]^2/`r(sum)'*vfpi[1,1]
mat seMTfpp = sqrt(VMT[1,1])
}

mat B_all[`s',1] = B[2,1]
mat B_all[`s',2] = b

mat SE_all[`s',1] = seMTdyn 
mat SE_all[`s',2] = seMTfpp

restore
}


************************************************************************************************************
* AR(1): different rho, different sigma (iid), different alpha_i
************************************************************************************************************
* SCENARIO #
local s = 4

{
preserve
* 1) ESTIMATION: using whole balanced sample
keep if time>=364

g fp1m_1 = l.fp1m
xi i.countriesnum, noomit

* declare parameters
tempvar rho sig

mat alpha = J(`N',1,.)
mat rho = J(`N',1,.)
mat sig = J(`N',1,.)

local i = 1
foreach c of local clist {
quietly reg fp1m fp1m_1 if countriesnum==`c'

* store parameters
mat alpha[`i',1] = _b[_cons]
if _b[fp1m_1]<1 {
mat rho[`i',1] = _b[fp1m_1]
}
else if _b[fp1m_1]>=1 {
mat rho[`i',1] = 0.999
}
mat sig[`i',1] = e(rss)/e(df_r)
local `i++'
}

* 2) GENERATE PATHS
keep if time>=419

mata 
sig = st_matrix("sig")
alpha = st_matrix("alpha")
rho = st_matrix("rho")
MATfpihat = J(`N',K,.) 
end


mata 
for (k=1; k<=K; k++) {
eps = diag(sqrt(sig))*invnormal(uniform(`N',T))

/* matrix to store fp_{i,t} */
fpit = J(`N', T, 0)

fpit[.,1] = fpi0

for (t=2; t<=T; t++) {
	fpit[.,t] = alpha + diag(rho)*fpit[.,t-1] + eps[.,t]
}

fpihat = mean(fpit')

MATfpihat[.,k] = fpihat'
}
end

* GET VAR(fpi-fpihat)
mata 
fpihat = mean(MATfpihat')
fpihat = fpihat'#J(T,1,1)
error = fpihat-fpiIN
var = quadvariance(error)
/*
var_n = quadsum(error:^2)
var_d = quadsum(fpwithinIN:^2)
DYNbias[1,`s'] = 1+var_n/var_d
*/
DYNbias[1,`s'] = 1+var/vdyn 
FPPbias[1,`s'] = 1+var/vfpp
varfpi[1,`s'] = var
sdfpi[1,`s'] = sqrt(var)*1200

vfpihat = quadvariance(fpihat)
Vfpihat[1,`s'] = vfpihat
st_matrix("vfpihat",vfpihat)
st_addvar("float", "fpi")
st_store(., "fpi", fpihat )
end

/* GET VARIANCE fpi: REGRESSION */
* V(fpihat)
mat vfpi = vfpihat

replace fpi=. if fpiIN==.

egen rxi = mean(rx1m1) if rx1m1!=., by(countries)
egen fp = mean(fpi) if fpi!=., by(time)

* Generate averages: time and country level
egen rxt = mean(rx1m1) if rx1m1!=., by(time)
egen rx = mean(rxi) if rxi!=., by(time)

gen drxi = rxi - rx
gen rxhml = rx1m1 - rxt
gen rxwithin = rxhml - drxi
gen rxfpp = rx1m1 - rxi
gen drxt = rxt - rx
gen drxit = rx1m1-rx

egen fpt = mean(fp1m) if fp1m!=., by(time)

gen fphml = fp1m - fpt
gen dfpi = fpi - fp
gen fpwithin = fphml - dfpi
gen fpfpp = fp1m - fpi
gen dfpt = fpt - fp

* Generate all ds variables
egen dsi = mean(ds1m), by(countries)
egen dst = mean(ds1m) if ds1m!=., by(time)
egen ds = mean(dsi) if dsi!=., by(time)

gen ddsi = dsi - ds
gen dshml = ds1m - dst
gen dswithin = dshml - ddsi
gen dsfpp = ds1m - dsi
gen ddst = dst - ds

mat V = J(3,3,0)
mat B = J(3,1,.)

* DYNAMIC equation
gmm (rxwithin - {bdyn}*fpwithin), instruments(fpwithin, noconstant) winitial(identity) wmatrix(hac nwest 12)
estimates store dynOOS_95_`s'
mat V[2,2] = e(V)
mat B[2,1] = e(b)

reg rxwithin fpwithin, noconstant robust

{/* MT Adjustment: STACKED*/
g v = fpwithin^2
sum v if time>=cut

mat VMT = V[2,2] + _b[fpwithin]^2/`r(sum)'*vfpi[1,1]
mat seMTdyn = sqrt(VMT[1,1])
}

* FPP equation
gmm (eq1: rxfpp - {afpp} - {bfpp}*fpfpp), instruments(eq1: fpfpp) winitial(identity) wmatrix(hac nwest 12)
estimates store fppOOS_95_`s'
mat b = e(b)
mat b = b[1,2]
mat vf = e(V)
mat vf = vf[2,2]
{/* MT Adjustment: STACKED*/
* VAR(dfpi)
* DONE ABOVE
replace v = fpfpp^2
sum v if time>=cut

mat VMT = vf + b[1,1]^2/`r(sum)'*vfpi[1,1]
mat seMTfpp = sqrt(VMT[1,1])
}

mat B_all[`s',1] = B[2,1]
mat B_all[`s',2] = b

mat SE_all[`s',1] = seMTdyn 
mat SE_all[`s',2] = seMTfpp


restore
}

************************************************************************************************************
* AR(1): different rho, different sigma (iid), different alpha_i, ONLY pre-sample
************************************************************************************************************
* SCENARIO #
local s = 5

{
preserve
* 1) ESTIMATION: using only pre sample non-balanced sample
keep if time<=419

g fp1m_1 = l.fp1m
xi i.countriesnum, noomit

* declare parameters
tempvar rho sig

mat alpha = J(`N',1,.)
mat rho = J(`N',1,.)
mat sig = J(`N',1,.)

local i = 1
foreach c of local clist {
quietly reg fp1m fp1m_1 if countriesnum==`c'

* store parameters
mat alpha[`i',1] = _b[_cons]
if _b[fp1m_1]<1 {
mat rho[`i',1] = _b[fp1m_1]
}
else if _b[fp1m_1]>=1 {
mat rho[`i',1] = 0.999
}
mat sig[`i',1] = e(rss)/e(df_r)
local `i++'
}

restore

preserve
* 2) GENERATE PATHS
keep if time>=419

mata 
sig = st_matrix("sig")
alpha = st_matrix("alpha")
rho = st_matrix("rho")
MATfpihat = J(`N',K,.) 
end


mata 
for (k=1; k<=K; k++) {
eps = diag(sqrt(sig))*invnormal(uniform(`N',T))

/* matrix to store fp_{i,t} */
fpit = J(`N', T, 0)

fpit[.,1] = fpi0

for (t=2; t<=T; t++) {
	fpit[.,t] = alpha + diag(rho)*fpit[.,t-1] + eps[.,t]
}

fpihat = mean(fpit')

MATfpihat[.,k] = fpihat'
}
end

* GET VAR(fpi-fpihat)
mata 
fpihat = mean(MATfpihat')
fpihat = fpihat'#J(T,1,1)
error = fpihat-fpiIN
var = quadvariance(error)
/*
var_n = quadsum(error:^2)
var_d = quadsum(fpwithinIN:^2)
DYNbias[1,`s'] = 1+var_n/var_d
*/
DYNbias[1,`s'] = 1+var/vdyn 
FPPbias[1,`s'] = 1+var/vfpp
varfpi[1,`s'] = var
sdfpi[1,`s'] = sqrt(var)*1200

vfpihat = quadvariance(fpihat)
Vfpihat[1,`s'] = vfpihat
st_matrix("vfpihat",vfpihat)
st_addvar("float", "fpi")
st_store(., "fpi", fpihat )
end

/* GET VARIANCE fpi: REGRESSION */
* V(fpihat)
mat vfpi = vfpihat

replace fpi=. if fpiIN==.

egen rxi = mean(rx1m1) if rx1m1!=., by(countries)
egen fp = mean(fpi) if fpi!=., by(time)

* Generate averages: time and country level
egen rxt = mean(rx1m1) if rx1m1!=., by(time)
egen rx = mean(rxi) if rxi!=., by(time)

gen drxi = rxi - rx
gen rxhml = rx1m1 - rxt
gen rxwithin = rxhml - drxi
gen rxfpp = rx1m1 - rxi
gen drxt = rxt - rx
gen drxit = rx1m1-rx

egen fpt = mean(fp1m) if fp1m!=., by(time)

gen fphml = fp1m - fpt
gen dfpi = fpi - fp
gen fpwithin = fphml - dfpi
gen fpfpp = fp1m - fpi
gen dfpt = fpt - fp

* Generate all ds variables
egen dsi = mean(ds1m), by(countries)
egen dst = mean(ds1m) if ds1m!=., by(time)
egen ds = mean(dsi) if dsi!=., by(time)

gen ddsi = dsi - ds
gen dshml = ds1m - dst
gen dswithin = dshml - ddsi
gen dsfpp = ds1m - dsi
gen ddst = dst - ds

mat V = J(3,3,0)
mat B = J(3,1,.)

* DYNAMIC equation
gmm (rxwithin - {bdyn}*fpwithin), instruments(fpwithin, noconstant) winitial(identity) wmatrix(hac nwest 12)
estimates store dynOOS_95_`s'
mat V[2,2] = e(V)
mat B[2,1] = e(b)

reg rxwithin fpwithin, noconstant robust

{/* MT Adjustment: STACKED*/
g v = fpwithin^2
sum v if time>=cut

mat VMT = V[2,2] + _b[fpwithin]^2/`r(sum)'*vfpi[1,1]
mat seMTdyn = sqrt(VMT[1,1])
}

* FPP equation
gmm (eq1: rxfpp - {afpp} - {bfpp}*fpfpp), instruments(eq1: fpfpp) winitial(identity) wmatrix(hac nwest 12)
estimates store fppOOS_95_`s'
mat b = e(b)
mat b = b[1,2]
mat vf = e(V)
mat vf = vf[2,2]
{/* MT Adjustment: STACKED*/
* VAR(dfpi)
* DONE ABOVE
replace v = fpfpp^2
sum v if time>=cut

mat VMT = vf + b[1,1]^2/`r(sum)'*vfpi[1,1]
mat seMTfpp = sqrt(VMT[1,1])
}

mat B_all[`s',1] = B[2,1]
mat B_all[`s',2] = b

mat SE_all[`s',1] = seMTdyn 
mat SE_all[`s',2] = seMTfpp


restore
}

************************************************************************************************************
* AR(1): different rho, different sigma (iid), different alpha_i, ONLY pre-sample, ADDING fpt
************************************************************************************************************
* SCENARIO #
local s = 6

{
preserve
* 1) ESTIMATION: using only pre sample non-balanced sample
keep if time<=419

g fp1m_1 = l.fp1m
egen fpt = mean(fp1m) if fp1m!=., by(time)

g fpt_1 = l.fpt
xi i.countriesnum, noomit

* declare parameters
tempvar rho sig

mat alpha = J(`N',1,.)
mat rho = J(`N',1,.)
mat sig = J(`N',1,.)
mat beta = J(`N',1,.)

local i = 1
foreach c of local clist {
/*quietly*/ reg fp1m fp1m_1 fpt_1 if countriesnum==`c'

* store parameters
mat alpha[`i',1] = _b[_cons]
if _b[fp1m_1]<1 {
mat rho[`i',1] = _b[fp1m_1]
}
else if _b[fp1m_1]>=1 {
mat rho[`i',1] = 0.999
}
mat sig[`i',1] = e(rss)/e(df_r)
mat beta[`i',1] = _b[fpt_1]
local `i++'
}

restore

preserve
* 2) GENERATE PATHS
keep if time>=419

mata 
sig = st_matrix("sig")
alpha = st_matrix("alpha")
rho = st_matrix("rho")
beta = st_matrix("beta")
MATfpihat = J(`N',K,.) 
end


mata 
for (k=1; k<=K; k++) {
eps = diag(sqrt(sig))*invnormal(uniform(`N',T))

/* matrix to store fp_{i,t} */
fpit = J(`N', T, 0)
fpt = J(1, T, 0)

fpit[.,1] = fpi0
fpt[.,1] = J(1,`N',1)*fpi0/`N'

for (t=2; t<=T; t++) {
	fpit[.,t] = alpha + diag(rho)*fpit[.,t-1] + fpt[.,t-1]*beta + eps[.,t]
	fpt[.,t] = J(1,`N',1)*fpit[.,t]/`N'
}

fpihat = mean(fpit')

MATfpihat[.,k] = fpihat'
}
end

* GET VAR(fpi-fpihat)
mata 
fpihat = mean(MATfpihat')
fpihat = fpihat'#J(T,1,1)
error = fpihat-fpiIN
var = quadvariance(error)
/*
var_n = quadsum(error:^2)
var_d = quadsum(fpwithinIN:^2)
DYNbias[1,`s'] = 1+var_n/var_d
*/
DYNbias[1,`s'] = 1+var/vdyn 
FPPbias[1,`s'] = 1+var/vfpp
varfpi[1,`s'] = var
sdfpi[1,`s'] = sqrt(var)*1200

vfpihat = quadvariance(fpihat)
Vfpihat[1,`s'] = vfpihat
st_matrix("vfpihat",vfpihat)
st_addvar("float", "fpi")
st_store(., "fpi", fpihat )
end

/* GET VARIANCE fpi: REGRESSION */
* V(fpihat)
mat vfpi = vfpihat

replace fpi=. if fpiIN==.

egen rxi = mean(rx1m1) if rx1m1!=., by(countries)
egen fp = mean(fpi) if fpi!=., by(time)

* Generate averages: time and country level
egen rxt = mean(rx1m1) if rx1m1!=., by(time)
egen rx = mean(rxi) if rxi!=., by(time)

gen drxi = rxi - rx
gen rxhml = rx1m1 - rxt
gen rxwithin = rxhml - drxi
gen rxfpp = rx1m1 - rxi
gen drxt = rxt - rx
gen drxit = rx1m1-rx

egen fpt = mean(fp1m) if fp1m!=., by(time)

gen fphml = fp1m - fpt
gen dfpi = fpi - fp
gen fpwithin = fphml - dfpi
gen fpfpp = fp1m - fpi
gen dfpt = fpt - fp

* Generate all ds variables
egen dsi = mean(ds1m), by(countries)
egen dst = mean(ds1m) if ds1m!=., by(time)
egen ds = mean(dsi) if dsi!=., by(time)

gen ddsi = dsi - ds
gen dshml = ds1m - dst
gen dswithin = dshml - ddsi
gen dsfpp = ds1m - dsi
gen ddst = dst - ds

mat V = J(3,3,0)
mat B = J(3,1,.)

* DYNAMIC equation
gmm (rxwithin - {bdyn}*fpwithin), instruments(fpwithin, noconstant) winitial(identity) wmatrix(hac nwest 12)
estimates store dynOOS_95_`s'
mat V[2,2] = e(V)
mat B[2,1] = e(b)

reg rxwithin fpwithin, noconstant robust

{/* MT Adjustment: STACKED*/
g v = fpwithin^2
sum v if time>=cut

mat VMT = V[2,2] + _b[fpwithin]^2/`r(sum)'*vfpi[1,1]
mat seMTdyn = sqrt(VMT[1,1])
}

* FPP equation
gmm (eq1: rxfpp - {afpp} - {bfpp}*fpfpp), instruments(eq1: fpfpp) winitial(identity) wmatrix(hac nwest 12)
estimates store fppOOS_95_`s'
mat b = e(b)
mat b = b[1,2]
mat vf = e(V)
mat vf = vf[2,2]
{/* MT Adjustment: STACKED*/
* VAR(dfpi)
* DONE ABOVE
replace v = fpfpp^2
sum v if time>=cut

mat VMT = vf + b[1,1]^2/`r(sum)'*vfpi[1,1]
mat seMTfpp = sqrt(VMT[1,1])
}

mat B_all[`s',1] = B[2,1]
mat B_all[`s',2] = b

mat SE_all[`s',1] = seMTdyn 
mat SE_all[`s',2] = seMTfpp


restore
}



************************************************************************************************************
* AR(1): different rho, different sigma (iid), different alpha_i, ADDING fpt
************************************************************************************************************
* SCENARIO #
local s = 7

{
preserve
* 1) ESTIMATION: using only pre sample non-balanced sample
*keep if time<=419
keep if time>=364

g fp1m_1 = l.fp1m
egen fpt = mean(fp1m) if fp1m!=., by(time)

g fpt_1 = l.fpt
xi i.countriesnum, noomit

* declare parameters
tempvar rho sig

mat alpha = J(`N',1,.)
mat rho = J(`N',1,.)
mat sig = J(`N',1,.)
mat beta = J(`N',1,.)

local i = 1
foreach c of local clist {
/*quietly*/ reg fp1m fp1m_1 fpt_1 if countriesnum==`c'

* store parameters
mat alpha[`i',1] = _b[_cons]
if _b[fp1m_1]<1 {
mat rho[`i',1] = _b[fp1m_1]
}
else if _b[fp1m_1]>=1 {
mat rho[`i',1] = 0.999
}
mat sig[`i',1] = e(rss)/e(df_r)
mat beta[`i',1] = _b[fpt_1]
local `i++'
}

restore

preserve
* 2) GENERATE PATHS
keep if time>=419

mata 
sig = st_matrix("sig")
alpha = st_matrix("alpha")
rho = st_matrix("rho")
beta = st_matrix("beta")
MATfpihat = J(`N',K,.) 
end


mata 
for (k=1; k<=K; k++) {
eps = diag(sqrt(sig))*invnormal(uniform(`N',T))

/* matrix to store fp_{i,t} */
fpit = J(`N', T, 0)
fpt = J(1, T, 0)

fpit[.,1] = fpi0
fpt[.,1] = J(1,`N',1)*fpi0/`N'

for (t=2; t<=T; t++) {
	fpit[.,t] = alpha + diag(rho)*fpit[.,t-1] + fpt[.,t-1]*beta + eps[.,t]
	fpt[.,t] = J(1,`N',1)*fpit[.,t]/`N'
}

fpihat = mean(fpit')

MATfpihat[.,k] = fpihat'
}
end

* GET VAR(fpi-fpihat)
mata 
fpihat = mean(MATfpihat')
fpihat = fpihat'#J(T,1,1)
error = fpihat-fpiIN
var = quadvariance(error)
/*
var_n = quadsum(error:^2)
var_d = quadsum(fpwithinIN:^2)
DYNbias[1,`s'] = 1+var_n/var_d
*/
DYNbias[1,`s'] = 1+var/vdyn 
FPPbias[1,`s'] = 1+var/vfpp
varfpi[1,`s'] = var
sdfpi[1,`s'] = sqrt(var)*1200

vfpihat = quadvariance(fpihat)
Vfpihat[1,`s'] = vfpihat
st_matrix("vfpihat",vfpihat)
st_addvar("float", "fpi")
st_store(., "fpi", fpihat )
end

/* GET VARIANCE fpi: REGRESSION */
* V(fpihat)
mat vfpi = vfpihat

replace fpi=. if fpiIN==.

egen rxi = mean(rx1m1) if rx1m1!=., by(countries)
egen fp = mean(fpi) if fpi!=., by(time)

* Generate averages: time and country level
egen rxt = mean(rx1m1) if rx1m1!=., by(time)
egen rx = mean(rxi) if rxi!=., by(time)

gen drxi = rxi - rx
gen rxhml = rx1m1 - rxt
gen rxwithin = rxhml - drxi
gen rxfpp = rx1m1 - rxi
gen drxt = rxt - rx
gen drxit = rx1m1-rx

egen fpt = mean(fp1m) if fp1m!=., by(time)

gen fphml = fp1m - fpt
gen dfpi = fpi - fp
gen fpwithin = fphml - dfpi
gen fpfpp = fp1m - fpi
gen dfpt = fpt - fp

* Generate all ds variables
egen dsi = mean(ds1m), by(countries)
egen dst = mean(ds1m) if ds1m!=., by(time)
egen ds = mean(dsi) if dsi!=., by(time)

gen ddsi = dsi - ds
gen dshml = ds1m - dst
gen dswithin = dshml - ddsi
gen dsfpp = ds1m - dsi
gen ddst = dst - ds

mat V = J(3,3,0)
mat B = J(3,1,.)

* DYNAMIC equation
gmm (rxwithin - {bdyn}*fpwithin), instruments(fpwithin, noconstant) winitial(identity) wmatrix(hac nwest 12)
estimates store dynOOS_95_`s'
mat V[2,2] = e(V)
mat B[2,1] = e(b)

reg rxwithin fpwithin, noconstant robust

{/* MT Adjustment: STACKED*/
g v = fpwithin^2
sum v if time>=cut

mat VMT = V[2,2] + _b[fpwithin]^2/`r(sum)'*vfpi[1,1]
mat seMTdyn = sqrt(VMT[1,1])
}

* FPP equation
gmm (eq1: rxfpp - {afpp} - {bfpp}*fpfpp), instruments(eq1: fpfpp) winitial(identity) wmatrix(hac nwest 12)
estimates store fppOOS_95_`s'
mat b = e(b)
mat b = b[1,2]
mat vf = e(V)
mat vf = vf[2,2]
{/* MT Adjustment: STACKED*/
* VAR(dfpi)
* DONE ABOVE
replace v = fpfpp^2
sum v if time>=cut

mat VMT = vf + b[1,1]^2/`r(sum)'*vfpi[1,1]
mat seMTfpp = sqrt(VMT[1,1])
}

mat B_all[`s',1] = B[2,1]
mat B_all[`s',2] = b

mat SE_all[`s',1] = seMTdyn 
mat SE_all[`s',2] = seMTfpp


restore
}



************************************************************************************************************
* GARCH(1): different rho, different sigma (arch), different alpha_i
************************************************************************************************************
* SCENARIO #
local s = 8
{
preserve
* 1) ESTIMATION: using only pre sample non-balanced sample
*keep if time<=419
keep if time>=364

g fp1m_1 = l.fp1m
xi i.countriesnum, noomit

* declare parameters
tempvar rho b0 b1

mat alpha = J(`N',1,.)
mat rho = J(`N',1,.)
mat b0 = J(`N',1,.)
mat b1 = J(`N',1,.)
mat b2 = J(`N',1,.)
mat e0_sq = J(`N',1,.)
mat sig0 = J(`N',1,.)

local i = 1
foreach c of local clist {
quietly arch fp1m fp1m_1 if countriesnum==`c', arch(1) garch(1) iter(100)

* no arch coeff
if `e(converged)'==0 | [ARCH]_b[L.arch] + [ARCH]_b[L.garch] > 1 {
quietly reg fp1m fp1m_1 if countriesnum==`c'

* store parameters
mat b1[`i',1] = 0
mat b2[`i',1] = 0
mat alpha[`i',1] = _b[_cons]
if _b[fp1m_1]<1 {
mat rho[`i',1] = _b[fp1m_1]
}
else if _b[fp1m_1]>=1 {
mat rho[`i',1] = 0.999
}
mat b0[`i',1] = e(rss)/e(df_r)
mat sig0[`i',1] = b0[`i',1]
}

* ARCH
else if `e(converged)'==1 & [ARCH]_b[L.arch] + [ARCH]_b[L.garch] <= 1 {
* store parameters
mat alpha[`i',1] = [fp1m]_b[_cons]
if _b[fp1m_1]<1 {
mat rho[`i',1] = [fp1m]_b[fp1m_1]
}
else if _b[fp1m_1]>=1 {
mat rho[`i',1] = 0.999
}
mat b0[`i',1] = [ARCH]_b[_cons]
mat b1[`i',1] = [ARCH]_b[L.arch]
mat b2[`i',1] = [ARCH]_b[L.garch]

quietly {
predict v if e(sample), var
sum v if time==419
mat sig0[`i',1] = `r(mean)'
drop v
}
}

quietly {
predict e if e(sample), res
sum e if time==419
mat e0_sq[`i',1] = (`r(mean)')^2
drop e

}
local `i++'
}

restore

preserve
* 2) GENERATE PATHS
keep if time>=419

mata 
b0 = st_matrix("b0")
b1 = st_matrix("b1")
b2 = st_matrix("b2")
e0_sq = st_matrix("e0_sq")
sig0 = st_matrix("sig0")
alpha = st_matrix("alpha")
rho = st_matrix("rho")
MATfpihat = J(`N',K,.) 
end


mata 
for (k=1; k<=K; k++) {

/* matrices to store  */
fpit = J(`N', T, 0)
eps =  J(`N', T, 0)
sig =  J(`N', T, 0)

/* intial values */
fpit[.,1] = fpi0
sig[.,1] = b0 + diag(b1)*e0_sq + diag(b2)*sig0
eps[.,1] = diag(sqrt(sig[.,1]))*invnormal(uniform(`N',1))

for (t=2; t<=T; t++) {
	sig[.,t] = b0 + diag(b1)*(eps[.,t-1]):^2 + diag(b2)*sig[.,t-1]
	eps[.,t] = diag(sqrt(sig[.,t]))*invnormal(uniform(`N',1))
	fpit[.,t] = alpha + diag(rho)*fpit[.,t-1] + eps[.,t]
}

fpihat = mean(fpit')

MATfpihat[.,k] = fpihat'
}
end

* GET VAR(fpi-fpihat)
mata 
fpihat = mean(MATfpihat')
fpihat = fpihat'#J(T,1,1)
error = fpihat-fpiIN
var = quadvariance(error)
/*
var_n = quadsum(error:^2)
var_d = quadsum(fpwithinIN:^2)
DYNbias[1,`s'] = 1+var_n/var_d
*/
DYNbias[1,`s'] = 1+var/vdyn 
FPPbias[1,`s'] = 1+var/vfpp
varfpi[1,`s'] = var
sdfpi[1,`s'] = sqrt(var)*1200

vfpihat = quadvariance(fpihat)
Vfpihat[1,`s'] = vfpihat
st_matrix("vfpihat",vfpihat)
st_addvar("float", "fpi")
st_store(., "fpi", fpihat )
end

/* GET VARIANCE fpi: REGRESSION */
* V(fpihat)
mat vfpi = vfpihat

replace fpi=. if fpiIN==.

egen rxi = mean(rx1m1) if rx1m1!=., by(countries)
egen fp = mean(fpi) if fpi!=., by(time)

* Generate averages: time and country level
egen rxt = mean(rx1m1) if rx1m1!=., by(time)
egen rx = mean(rxi) if rxi!=., by(time)

gen drxi = rxi - rx
gen rxhml = rx1m1 - rxt
gen rxwithin = rxhml - drxi
gen rxfpp = rx1m1 - rxi
gen drxt = rxt - rx
gen drxit = rx1m1-rx

egen fpt = mean(fp1m) if fp1m!=., by(time)

gen fphml = fp1m - fpt
gen dfpi = fpi - fp
gen fpwithin = fphml - dfpi
gen fpfpp = fp1m - fpi
gen dfpt = fpt - fp

* Generate all ds variables
egen dsi = mean(ds1m), by(countries)
egen dst = mean(ds1m) if ds1m!=., by(time)
egen ds = mean(dsi) if dsi!=., by(time)

gen ddsi = dsi - ds
gen dshml = ds1m - dst
gen dswithin = dshml - ddsi
gen dsfpp = ds1m - dsi
gen ddst = dst - ds

mat V = J(3,3,0)
mat B = J(3,1,.)

* DYNAMIC equation
gmm (rxwithin - {bdyn}*fpwithin), instruments(fpwithin, noconstant) winitial(identity) wmatrix(hac nwest 12)
estimates store dynOOS_95_`s'
mat V[2,2] = e(V)
mat B[2,1] = e(b)

reg rxwithin fpwithin, noconstant robust

{/* MT Adjustment: STACKED*/
g v = fpwithin^2
sum v if time>=cut

mat VMT = V[2,2] + _b[fpwithin]^2/`r(sum)'*vfpi[1,1]
mat seMTdyn = sqrt(VMT[1,1])
}

* FPP equation
gmm (eq1: rxfpp - {afpp} - {bfpp}*fpfpp), instruments(eq1: fpfpp) winitial(identity) wmatrix(hac nwest 12)
estimates store fppOOS_95_`s'
mat b = e(b)
mat b = b[1,2]
mat vf = e(V)
mat vf = vf[2,2]
{/* MT Adjustment: STACKED*/
* VAR(dfpi)
* DONE ABOVE
replace v = fpfpp^2
sum v if time>=cut

mat VMT = vf + b[1,1]^2/`r(sum)'*vfpi[1,1]
mat seMTfpp = sqrt(VMT[1,1])
}

mat B_all[`s',1] = B[2,1]
mat B_all[`s',2] = b

mat SE_all[`s',1] = seMTdyn 
mat SE_all[`s',2] = seMTfpp


restore
}

************************************************************************************************************
* GARCH(1): different rho, different sigma (arch), different alpha_i, ADDING fpt
************************************************************************************************************
* SCENARIO #
local s = 9
{
preserve
* 1) ESTIMATION: using only pre sample non-balanced sample
*keep if time<=419
keep if time>=364

g fp1m_1 = l.fp1m
egen fpt = mean(fp1m) if fp1m!=., by(time)

g fpt_1 = l.fpt
xi i.countriesnum, noomit

* declare parameters
mat alpha = J(`N',1,.)
mat rho = J(`N',1,.)
mat b0 = J(`N',1,.)
mat b1 = J(`N',1,.)
mat b2 = J(`N',1,.)
mat e0_sq = J(`N',1,.)
mat sig0 = J(`N',1,.)
mat beta = J(`N',1,.)

local i = 1
foreach c of local clist {
quietly arch fp1m fp1m_1 fpt_1 if countriesnum==`c', arch(1) garch(1) iter(100)

* no arch coeff
if `e(converged)'==0 | [ARCH]_b[L.arch] + [ARCH]_b[L.garch] > 1 {
quietly reg fp1m fp1m_1 fpt_1 if countriesnum==`c'

* store parameters
mat b1[`i',1] = 0
mat b2[`i',1] = 0
mat alpha[`i',1] = _b[_cons]
if _b[fp1m_1]<1 {
mat rho[`i',1] = _b[fp1m_1]
}
else if _b[fp1m_1]>=1 {
mat rho[`i',1] = 0.999
}
mat b0[`i',1] = e(rss)/e(df_r)
mat sig0[`i',1] = b0[`i',1]
mat beta[`i',1] = _b[fpt_1]
}

* ARCH
else if `e(converged)'==1 & [ARCH]_b[L.arch] + [ARCH]_b[L.garch] <= 1 {
* store parameters
mat alpha[`i',1] = [fp1m]_b[_cons]
if _b[fp1m_1]<1 {
mat rho[`i',1] = [fp1m]_b[fp1m_1]
}
else if _b[fp1m_1]>=1 {
mat rho[`i',1] = 0.999
}
mat b0[`i',1] = [ARCH]_b[_cons]
mat b1[`i',1] = [ARCH]_b[L.arch]
mat b2[`i',1] = [ARCH]_b[L.garch]
mat beta[`i',1] = _b[fpt_1]

quietly {
predict v if e(sample), var
sum v if time==419
mat sig0[`i',1] = `r(mean)'
drop v
}
}

quietly {
predict e if e(sample), res
sum e if time==419
mat e0_sq[`i',1] = (`r(mean)')^2
drop e

}
local `i++'
}

restore

preserve
* 2) GENERATE PATHS
keep if time>=419

mata 
b0 = st_matrix("b0")
b1 = st_matrix("b1")
b2 = st_matrix("b2")
e0_sq = st_matrix("e0_sq")
sig0 = st_matrix("sig0")
alpha = st_matrix("alpha")
rho = st_matrix("rho")
beta = st_matrix("beta")
MATfpihat = J(`N',K,.) 
end


mata 
for (k=1; k<=K; k++) {

/* matrices to store  */
fpit = J(`N', T, 0)
eps =  J(`N', T, 0)
sig =  J(`N', T, 0)
fpt = J(1, T, 0)

/* intial values */
fpit[.,1] = fpi0
fpt[.,1] = J(1,`N',1)*fpi0/`N'
sig[.,1] = b0
eps[.,1] = diag(sqrt(sig[.,1]))*invnormal(uniform(`N',1))

for (t=2; t<=T; t++) {
	sig[.,t] = b0 + diag(b1)*(eps[.,t-1]):^2 + diag(b2)*sig[.,t-1]
	eps[.,t] = diag(sqrt(sig[.,t]))*invnormal(uniform(`N',1))
	fpit[.,t] = alpha + diag(rho)*fpit[.,t-1] + fpt[.,t-1]*beta + eps[.,t]
	fpt[.,t] = J(1,`N',1)*fpit[.,t]/`N'
}

fpihat = mean(fpit')

MATfpihat[.,k] = fpihat'
}
end

* GET VAR(fpi-fpihat)
mata 
fpihat = mean(MATfpihat')
fpihat = fpihat'#J(T,1,1)
error = fpihat-fpiIN
var = quadvariance(error)
/*
var_n = quadsum(error:^2)
var_d = quadsum(fpwithinIN:^2)
DYNbias[1,`s'] = 1+var_n/var_d
*/
DYNbias[1,`s'] = 1+var/vdyn 
FPPbias[1,`s'] = 1+var/vfpp
varfpi[1,`s'] = var
sdfpi[1,`s'] = sqrt(var)*1200

vfpihat = quadvariance(fpihat)
Vfpihat[1,`s'] = vfpihat
st_matrix("vfpihat",vfpihat)
st_addvar("float", "fpi")
st_store(., "fpi", fpihat )
end

/* GET VARIANCE fpi: REGRESSION */
* V(fpihat)
mat vfpi = vfpihat

replace fpi=. if fpiIN==.

egen rxi = mean(rx1m1) if rx1m1!=., by(countries)
egen fp = mean(fpi) if fpi!=., by(time)

* Generate averages: time and country level
egen rxt = mean(rx1m1) if rx1m1!=., by(time)
egen rx = mean(rxi) if rxi!=., by(time)

gen drxi = rxi - rx
gen rxhml = rx1m1 - rxt
gen rxwithin = rxhml - drxi
gen rxfpp = rx1m1 - rxi
gen drxt = rxt - rx
gen drxit = rx1m1-rx

egen fpt = mean(fp1m) if fp1m!=., by(time)

gen fphml = fp1m - fpt
gen dfpi = fpi - fp
gen fpwithin = fphml - dfpi
gen fpfpp = fp1m - fpi
gen dfpt = fpt - fp

* Generate all ds variables
egen dsi = mean(ds1m), by(countries)
egen dst = mean(ds1m) if ds1m!=., by(time)
egen ds = mean(dsi) if dsi!=., by(time)

gen ddsi = dsi - ds
gen dshml = ds1m - dst
gen dswithin = dshml - ddsi
gen dsfpp = ds1m - dsi
gen ddst = dst - ds

mat V = J(3,3,0)
mat B = J(3,1,.)

* DYNAMIC equation
gmm (rxwithin - {bdyn}*fpwithin), instruments(fpwithin, noconstant) winitial(identity) wmatrix(hac nwest 12)
estimates store dynOOS_95_`s'
mat V[2,2] = e(V)
mat B[2,1] = e(b)

reg rxwithin fpwithin, noconstant robust

{/* MT Adjustment: STACKED*/
g v = fpwithin^2
sum v if time>=cut

mat VMT = V[2,2] + _b[fpwithin]^2/`r(sum)'*vfpi[1,1]
mat seMTdyn = sqrt(VMT[1,1])
}

* FPP equation
gmm (eq1: rxfpp - {afpp} - {bfpp}*fpfpp), instruments(eq1: fpfpp) winitial(identity) wmatrix(hac nwest 12)
estimates store fppOOS_95_`s'
mat b = e(b)
mat b = b[1,2]
mat vf = e(V)
mat vf = vf[2,2]
{/* MT Adjustment: STACKED*/
* VAR(dfpi)
* DONE ABOVE
replace v = fpfpp^2
sum v if time>=cut

mat VMT = vf + b[1,1]^2/`r(sum)'*vfpi[1,1]
mat seMTfpp = sqrt(VMT[1,1])
}

mat B_all[`s',1] = B[2,1]
mat B_all[`s',2] = b

mat SE_all[`s',1] = seMTdyn 
mat SE_all[`s',2] = seMTfpp


restore
}



************************************************************************************************************
* AR(1): common rho, different sigma (iid), different alpha_i, ADDING fpt, ONLY pre-sample
************************************************************************************************************
* SCENARIO #
local s = 10

{
preserve
* 1) ESTIMATION: using only pre sample non-balanced sample
keep if time<=419

g fp1m_1 = l.fp1m
egen fpt = mean(fp1m) if fp1m!=., by(time)

g fpt_1 = l.fpt
xi i.countriesnum, noomit

/*quietly*/ reg fp1m fp1m_1 fpt_1 _Icou*, noconstant
predict error if e(sample), r  
g error_sq = error^2

* store parameters
mat alpha = J(`N',1,.)
mat sig = J(`N',1,.)
mat rho = J(`N',1,.)
mat beta = J(`N',1,.)
*mat rss = J(1,1,0)

* store parameters
levelsof countriesnum, local(clist)

local i = 1
foreach c of local clist {
mat alpha[`i',1] = _b[_Icountries_`c']
quietly sum error_sq if _Icountries_`c'==1
mat sig[`i',1] = r(sum)/e(df_r)
mat rho[`i',1] = _b[fp1m_1]
mat beta[`i',1] = _b[fpt_1]
*mat rss[1,1] = rss[1,1]+r(sum)
local `i++'
}

restore

preserve
* 2) GENERATE PATHS
keep if time>=419
local N = 15
mata 
sig = st_matrix("sig")
alpha = st_matrix("alpha")
rho = st_matrix("rho")
beta = st_matrix("beta")
MATfpihat = J(`N',K,.) 
end


mata 
for (k=1; k<=K; k++) {
eps = diag(sqrt(sig))*invnormal(uniform(`N',T))

/* matrix to store fp_{i,t} */
fpit = J(`N', T, 0)
fpt = J(1, T, 0)

fpit[.,1] = fpi0
fpt[.,1] = J(1,`N',1)*fpi0/`N'

for (t=2; t<=T; t++) {
	fpit[.,t] = alpha + diag(rho)*fpit[.,t-1] + fpt[.,t-1]*beta + eps[.,t]
	fpt[.,t] = J(1,`N',1)*fpit[.,t]/`N'
}

fpihat = mean(fpit')

MATfpihat[.,k] = fpihat'
}
end

* GET VAR(fpi-fpihat)
mata 
fpihat = mean(MATfpihat')
fpihat = fpihat'#J(T,1,1)
error = fpihat-fpiIN
var = quadvariance(error)
/*
var_n = quadsum(error:^2)
var_d = quadsum(fpwithinIN:^2)
DYNbias[1,`s'] = 1+var_n/var_d
*/
DYNbias[1,`s'] = 1+var/vdyn 
FPPbias[1,`s'] = 1+var/vfpp
varfpi[1,`s'] = var
sdfpi[1,`s'] = sqrt(var)*1200

vfpihat = quadvariance(fpihat)
Vfpihat[1,`s'] = vfpihat
st_matrix("vfpihat",vfpihat)
st_addvar("float", "fpi")
st_store(., "fpi", fpihat )
end

/* GET VARIANCE fpi: REGRESSION */
* V(fpihat)
mat vfpi = vfpihat

replace fpi=. if fpiIN==.

egen rxi = mean(rx1m1) if rx1m1!=., by(countries)
egen fp = mean(fpi) if fpi!=., by(time)

* Generate averages: time and country level
egen rxt = mean(rx1m1) if rx1m1!=., by(time)
egen rx = mean(rxi) if rxi!=., by(time)

gen drxi = rxi - rx
gen rxhml = rx1m1 - rxt
gen rxwithin = rxhml - drxi
gen rxfpp = rx1m1 - rxi
gen drxt = rxt - rx
gen drxit = rx1m1-rx

egen fpt = mean(fp1m) if fp1m!=., by(time)

gen fphml = fp1m - fpt
gen dfpi = fpi - fp
gen fpwithin = fphml - dfpi
gen fpfpp = fp1m - fpi
gen dfpt = fpt - fp

* Generate all ds variables
egen dsi = mean(ds1m), by(countries)
egen dst = mean(ds1m) if ds1m!=., by(time)
egen ds = mean(dsi) if dsi!=., by(time)

gen ddsi = dsi - ds
gen dshml = ds1m - dst
gen dswithin = dshml - ddsi
gen dsfpp = ds1m - dsi
gen ddst = dst - ds

mat V = J(3,3,0)
mat B = J(3,1,.)

* DYNAMIC equation
gmm (rxwithin - {bdyn}*fpwithin), instruments(fpwithin, noconstant) winitial(identity) wmatrix(hac nwest 12)
estimates store dynOOS_95_`s'
mat V[2,2] = e(V)
mat B[2,1] = e(b)

reg rxwithin fpwithin, noconstant robust

{/* MT Adjustment: STACKED*/
g v = fpwithin^2
sum v if time>=cut

mat VMT = V[2,2] + _b[fpwithin]^2/`r(sum)'*vfpi[1,1]
mat seMTdyn = sqrt(VMT[1,1])
}

* FPP equation
gmm (eq1: rxfpp - {afpp} - {bfpp}*fpfpp), instruments(eq1: fpfpp) winitial(identity) wmatrix(hac nwest 12)
estimates store fppOOS_95_`s'
mat b = e(b)
mat b = b[1,2]
mat vf = e(V)
mat vf = vf[2,2]
{/* MT Adjustment: STACKED*/
* VAR(dfpi)
* DONE ABOVE
replace v = fpfpp^2
sum v if time>=cut

mat VMT = vf + b[1,1]^2/`r(sum)'*vfpi[1,1]
mat seMTfpp = sqrt(VMT[1,1])
}

mat B_all[`s',1] = B[2,1]
mat B_all[`s',2] = b

mat SE_all[`s',1] = seMTdyn 
mat SE_all[`s',2] = seMTfpp


restore
}



************************************************************************************************************

* b) Get Out-of-sample coefficients
************************************************************************************************************
* SCENARIO #
local s = 1

{
* BEFORE 1995 
gen fp1mtemp = fp1m if time<=cut
egen fpi = mean(fp1mtemp) if fp1m!=., by(countries)
drop fp1mtemp

/* GET VARIANCE fpi: REGRESSION */
xi i.countriesnum, noomit
* Standard OLS
reg fp1m _Icount* if time<=cut, noconstant
* V(fpihat)
mat D = e(V)
mat vfpi = D[1,1]

keep if time>=cut

egen rxi = mean(rx1m1) if rx1m1!=., by(countries)
egen fp = mean(fpi) if fpi!=., by(time)

* Generate averages: time and country level
egen rxt = mean(rx1m1) if rx1m1!=., by(time)
egen rx = mean(rxi) if rxi!=., by(time)

gen drxi = rxi - rx
gen rxhml = rx1m1 - rxt
gen rxwithin = rxhml - drxi
gen rxfpp = rx1m1 - rxi
gen drxt = rxt - rx
gen drxit = rx1m1-rx

egen fpt = mean(fp1m) if fp1m!=., by(time)

gen fphml = fp1m - fpt
gen dfpi = fpi - fp
gen fpwithin = fphml - dfpi
gen fpfpp = fp1m - fpi
gen dfpt = fpt - fp

* Generate all ds variables
egen dsi = mean(ds1m), by(countries)
egen dst = mean(ds1m) if ds1m!=., by(time)
egen ds = mean(dsi) if dsi!=., by(time)

gen ddsi = dsi - ds
gen dshml = ds1m - dst
gen dswithin = dshml - ddsi
gen dsfpp = ds1m - dsi
gen ddst = dst - ds

*------------------------------------------------------------------------------
* UNIVARIATE REGRESSIONS & ESS RATIOS
*------------------------------------------------------------------------------
mat V = J(3,3,0)
mat B = J(3,1,.)

* DYNAMIC equation
gmm (rxwithin - {bdyn}*fpwithin), instruments(fpwithin, noconstant) winitial(identity) wmatrix(hac nwest 12)
estimates store dynOOS_95_`s'
mat V[2,2] = e(V)
mat B[2,1] = e(b)

reg rxwithin fpwithin, noconstant robust

{/* MT Adjustment: STACKED*/
g v = fpwithin^2
sum v if time>=cut

mat VMT = V[2,2] + _b[fpwithin]^2/`r(sum)'*vfpi[1,1]
mat seMTdyn = sqrt(VMT[1,1])
}

* FPP equation
gmm (eq1: rxfpp - {afpp} - {bfpp}*fpfpp), instruments(eq1: fpfpp) winitial(identity) wmatrix(hac nwest 12)
estimates store fppOOS_95_`s'
mat b = e(b)
mat b = b[1,2]
mat vf = e(V)
mat vf = vf[2,2]
{/* MT Adjustment: STACKED*/
* VAR(dfpi)
* DONE ABOVE
replace v = fpfpp^2
sum v if time>=cut

mat VMT = vf + b[1,1]^2/`r(sum)'*vfpi[1,1]
mat seMTfpp = sqrt(VMT[1,1])
}

mat B_all[`s',1]= B[2,1] 
mat B_all[`s',2]= b
mat SE_all[`s',1] = seMTdyn 
mat SE_all[`s',2] = seMTfpp

}

* Compute implied coefficients, BIAS
*-------------------------------------------------------------------------------

mata

BIAS = ((1 , DYNbias) \ (1 , FPPbias))
varfpi = ((0 , varfpi) \ (0,sdfpi))

bdyn = (bdyn :/ (1 , DYNbias))
bfpp = (bfpp :/ (1 , FPPbias))

end

*-------------------------------------------------------------------------------
* Create chart
*-------------------------------------------------------------------------------

* # OF SCENARIOS + IN-SAMPLE
local S1 = `S'+1

clear
mata
st_addobs(`S1')

st_addvar("float", ("biasDYN" ,"biasFPP"))
st_store(., ("biasDYN" ,"biasFPP"), BIAS' )

st_addvar("float", ("varfpi", "sdfpi"))
st_store(., ("varfpi", "sdfpi"), varfpi' )

st_addvar("float", ("bdyn"))
st_store(., ("bdyn"), bdyn' )
st_addvar("float", ("bfpp"))
st_store(., ("bfpp"), bfpp' )

end

g labels = "Fixed Effects" if _n==1
replace labels = "pre-sample mean" if _n==2
replace labels = "full-sample common AR(1)" if _n==3
replace labels = "pre-sample common AR(1)" if _n==4
replace labels = "full-sample AR(1)" if _n==5
replace labels = "pre-sample AR(1)" if _n==6
replace labels = "pre-sample AR(1), fpt" if _n==7
replace labels = "full-sample AR(1), fpt" if _n==8
replace labels = "full-sample GARCH(1,1)" if _n==9
replace labels = "full-sample GARCH(1,1), fpt"  if _n==10
replace labels = "pre-sample common AR(1), fpt"  if _n==11

g scen = _n

g varDYN = varfpi/(biasDYN-1)
g varFPP = varfpi/(biasFPP-1)

replace biasDYN = biasDYN-1
replace biasFPP = biasFPP-1

g mindyn=.
g maxdyn=.
g minfpp=.
g maxfpp=.
g bdyn_reg=.
g bfpp_reg=.
g sedyn_reg=.
g sefpp_reg=.

forval i=1(1)`S' {
replace maxdyn = B_all[`i',1] + 1.96*SE_all[`i',1]  if _n==`i'+1
replace mindyn = B_all[`i',1]  - 1.96*SE_all[`i',1] if _n==`i'+1
replace maxfpp = B_all[`i',2] + 1.96*SE_all[`i',2]  if _n==`i'+1
replace minfpp = B_all[`i',2]  - 1.96*SE_all[`i',2] if _n==`i'+1
replace bdyn_reg = B_all[`i',1] if _n==`i'+1
replace bfpp_reg = B_all[`i',2] if _n==`i'+1
replace sedyn_reg = SE_all[`i',1] if _n==`i'+1
replace sefpp_reg = SE_all[`i',2] if _n==`i'+1
}

replace maxdyn = B_in[1,1] + 1.96*SE_in[1,1]  if _n==1
replace mindyn = B_in[1,1] - 1.96*SE_in[1,1]  if _n==1
replace maxfpp = B_in[1,2]  if _n==1
replace minfpp = B_in[1,2] - 1.96*SE_in[1,2]  if _n==1

g miny = 0
g maxy = 2

g labalt = "{&rho}{subscript:i,1} = {&rho}{subscript:1}, {&rho}{subscript:2} = 0" if _n==4
replace labalt = "Unrestricted {&rho}{subscript:i,1}, {&rho}{subscript:2}" if _n==7


preserve

twoway function y=0, ra(biasDYN) lwidth(0.2) lcolor(black) || function y=bdyn[1,1]*(1/(1+x)), ra(biasDYN) lwidth(0.5) lcolor(black) || ///
scatter bdyn biasDYN if scen==1, msize(normal) msymbol(Sh) mlcolor(black) mfcolor(black) ///
mlab(labels)  mlabcolor(black) mlabsize(medsmall) || (rcap mindyn maxdyn biasDYN if (scen>=1 & scen<3) | (scen==4 | scen==7) , lcolor(black)) ///
|| scatter bdyn_reg biasDYN if scen==2, msize(large) msymbol(D) mlcolor(black) mfcolor(black)  ///
mlab(labels)  mlabcolor(black) mlabsize(medsmall) mlabpos(3)  mlabgap(*0.4) ///
|| scatter bdyn_reg biasDYN if scen==4, msize(large) msymbol(T) mlcolor(black) mfcolor(black) mlab(labalt)  ///
mlabposition(8) mlabcolor(black) mlabsize(medsmall) mlabgap(*2) ///
|| scatter bdyn_reg biasDYN if scen==7, msize(large) msymbol(Oh) mlcolor(black) mfcolor(black) mlab(labalt)  ///
mlabposition(2) mlabcolor(black) mlabsize(medsmall) mlabgap(*0.2) title("Dynamic Trade") /// 
 ylabels(0 .4 .8 1.2 1.6 2,nogrid) xtitle("") ytitle("{&beta}{superscript:dyn}",  orientation(horizontal) size(medlarge))  ///
graphregion(color(white)) plotregion(lcolor(black)) xlabels(0 1 2 3 4 5, ) legend(off) 
graph save Input\tex_figs\dynamic_vfpi.gph, replace


twoway function y=0, ra(biasFPP) lwidth(0.2) lcolor(black) || function y=bfpp[1,1]*(1/(1+x)), ra(biasFPP) lwidth(0.5) lcolor(black) || ///
scatter bfpp biasFPP if scen==1, msize(normal) msymbol(Sh) mlcolor(black) mfcolor(black) ///
mlab(labels)  mlabcolor(black) mlabsize(medsmall)  || (rcap minfpp maxfpp biasFPP if (scen>=1 & scen<3) | (scen==4 | scen==7) , lcolor(black))  || ///
(rcap minfpp maxy biasFPP if scen==1, msize(vtiny) lcolor(black)) ///
|| scatter bfpp_reg biasFPP if scen==2, msize(large) msymbol(D) mlcolor(black) mfcolor(black)  mlab(labels)  mlabcolor(black) ///
mlabsize(medsmall) mlabpos(3) mlabgap(*.4) ///
|| scatter bfpp_reg biasFPP if scen==4, msize(large) msymbol(T) mlcolor(black) ///
mfcolor(black)  mlab(labalt)  mlabposition(8) mlabcolor(black) mlabsize(medsmall) ///
|| scatter bfpp_reg biasFPP if scen==7, msize(large) msymbol(Oh) mlcolor(black) ///
mlabgap(*1) mfcolor(black)  mlab(labalt)  mlabposition(2) mlabcolor(black) mlabsize(medsmall) ///
 xtitle("") ytitle("{&beta}{superscript:fpp}",  orientation(horizontal) size(medlarge))  ///
 ylabels(0 .4 .8 1.2 1.6 2, nogrid) yscale(r(-.2 2)) graphregion(color(white)) ///
 plotregion(lcolor(black))  xlabels(0 1 2 3, ) legend(off) title("Forward Premium Trade")
graph save Input\tex_figs\fpp_vfpi.gph, replace


graph combine Input\tex_figs\dynamic_vfpi.gph Input\tex_figs\fpp_vfpi.gph, graphregion(color(white)) plotregion(lcolor(white)) ycommon
graph export Input\tex_figs\Figure2.pdf, replace
graph export Input\tex_figs\Figure2.eps, replace
restore

erase Input\tex_figs\dynamic_vfpi.gph 
erase Input\tex_figs\fpp_vfpi.gph



