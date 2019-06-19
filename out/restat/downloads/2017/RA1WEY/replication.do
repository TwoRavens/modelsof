// Set computer path
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
local comp /Users/achalfin/Desktop/restat012017/dofiles
local comp C:\Users\achalfin\Desktop\chalfin_mcrary_restat
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
set more off
cd `comp'

use chalfin_mccrary_restat.dta, clear
tsset agencynum year // Panel dataset
local w popweight // population weight

// %%%%%%%%%%%%%%%%%%%%%%%%%
// %%%%%%%% TABLE 2 %%%%%%%%
// %%%%%%%%%%%%%%%%%%%%%%%%%

// Per capita variables in levels (LEOKA population as a deflator)
local varlist pc_ucr pc_asg ///
pc_violent pc_murder pc_rape pc_robbery pc_assault ///
pc_property pc_burglary pc_larceny pc_motor pccw

// Differenced variables
local dvarlist  gpolice_ucr gpolice_asg gviolent ///
gmurder grape grobbery gassault ///
gproperty gburglary glarceny gmotor gcw

foreach i of varlist `varlist' `dvarlist' {
	by agencynum, sort: egen MM_`i' = mean(`i')
}

foreach i of varlist `varlist' `dvarlist' {
	by agencynum, sort: gen DD_`i' = `i'-MM_`i'
}

capture log close
log using table2.log, replace
sum `varlist' `dvarlist' [aw=`w']
sum MM* [aw=`w']
sum DD* [aw=`w']
log close 


// %%%%%%%%%%%%%%%%%%%%%%%%%
// %%%%%%%% TABLE 3 %%%%%%%%
// %%%%%%%%%%%%%%%%%%%%%%%%%
// Main Results - OLS and 2SLS; The first 8 columns of Table 3

// GENERATE LAGS OF COVARIATES
foreach i of varlist  ///
gviolent gmurder grape grobbery gassault ///
gproperty gburglary glarceny gmotor { 
    gen l`i' = `i'[_n-1] 
    gen l2`i' = `i'[_n-2]
}

capture log close
log using table3a.log, replace

// %%%%%%%%%%%%%%%%%
// LEAST SQUARES
// %%%%%%%%%%%%%%%%%
tsset agencynum year

// FORWARD
foreach i of varlist  ///
gviolent gmurder grape grobbery gassault ///
gproperty gburglary glarceny gmotor { 

// Column 1
areg `i' gpolice_ucr gpop_ucr gpop_asg [aw=popweight], absorb(year) robust

// Column 2
areg `i' gpolice_ucr gpop_ucr gpop_asg [aw=popweight], absorb(styr) robust

// Column 3
areg `i' gpolice_asg gpop_ucr gpop_asg [aw=popweight],  absorb(year) robust

// Column 4
areg `i' gpolice_asg gpop_ucr gpop_asg [aw=popweight], absorb(styr) robust

}

// %%%%%%%%%%%%%%%%%
// 2SLS
// %%%%%%%%%%%%%%%%%
tsset agencynum year

// FORWARD
foreach i of varlist  ///
gviolent gmurder grape grobbery gassault ///
gproperty gburglary glarceny gmotor { 

// Column 5
ivreg `i' (gpolice_ucr=gpolice_asg) gpop_ucr gpop_asg y1-y51 [aw=popweight], robust

// Column 6
tsset styr cityyr
xtivreg2 `i' (gpolice_ucr=gpolice_asg) gpop_ucr gpop_asg [aw=popweight], fe robust

}


// REFLECTED
foreach i of varlist  ///
gviolent gmurder grape grobbery gassault ///
gproperty gburglary glarceny gmotor { 

// Column 7
tsset agencynum year
ivreg `i' (gpolice_asg=gpolice_ucr) gpop_ucr gpop_asg y1-y51 [aw=popweight], robust

// Column 8
tsset styr cityyr
xtivreg2 `i' (gpolice_asg=gpolice_ucr) gpop_ucr gpop_asg [aw=popweight], fe robust

}


log close

// Main Results - OLS and 2SLS; The first 8 columns of Table 3
// Estimates shown for violent crimes
local i violent
drop if year<1962

// keep the variables we need
keep ORI7 year g`i' gpolice_ucr gpolice_asg gpop_ucr gpop_asg `w' styr


// Drop variables with missing values
foreach k of varlist g`i' gpolice_ucr gpolice_asg gpop_ucr gpop_asg {
	drop if `k'==.
}

// Drop observations with a 'zero' residual (these are the singletons)	
areg g`i' gpolice_ucr, absorb(styr)
	predict cat, res
	drop if cat==0
	drop cat
	

// De-mean the data using population weights
foreach j of varlist g`i' gpolice_asg gpolice_ucr gpop_ucr gpop_asg  {
	areg `j' [aw=popweight], absorb(styr) 
		predict res_`j', res
		drop `j'
}


// Save the de-meaned dataset
save table3b.dta, replace
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

capture log close
log using table3b, text replace

use table3b, clear

// Declare the instruments and endogenous regressors
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gen S=res_gpolice_ucr
gen Z=res_gpolice_asg
gen W=popweight
gen var1=runiform()
gen Y=res_g`i'

putmata Y S Z W //Put data into MATA
// putmata X=(var1 X1-X`T' 1)  //last column is the constant
putmata X=(res_gpop_ucr res_gpop_asg)  

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//FIRST: Fit separate just-identified models
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//ivreg Y (S=Z) var1 X1-X`T' [aw=W]
//mat ivf=e(b)
//ivreg Y (Z=S) var1 X1-X`T' [aw=W]
//mat ivr=e(b)
//mat b0=(0.5*(ivf[1,1]+ivr[1,1])),ivf[1,"var1".."_cons"],ivr[1,"var1".."_cons"]


//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//REST OF PROGRAM IS IN MATA
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set matastrict off
mata

J1=3  // number of parameters
K1=1514 // number of implied parameters for df correction


//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Set up the GMM problem
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

//FUNCTION TO TAKE THE TRANPOSE 
//(I hate having to use the prime; it messes up my editor)
real matrix function transpose(real matrix A) {
  real matrix B
  B=A
  _transpose(B)
  return(B)
}

//DIMENSIONS
K=cols(X) // number of included instruments (fixed effects + population)
n=rows(X) // number of observations
L=2*(K+1) // number of moments
J=1+2*K   // number of parameters

//MOMENT MATRIX(equation 3)
// Note: The "stacking" here is different than in gmm3.pdf
//returns an n x L matrix with ith row given by g_i'(\beta)
//i.e., the moments evaluated at alpha
real matrix function A(real colvector alpha) {

  external colvector Y, S, Z, W
  external matrix X
  external scalar K 
  real scalar theta
  real colvector nu1, nu2
  real matrix A1, A2
  theta=alpha[1]
  nu1=alpha[2::K+1]
  nu2=alpha[K+2::2*K+1]
  A1=W:*(Y:-theta*S:-X*nu1):*(Z,X)
  A2=W:*(Y:-theta*Z:-X*nu2):*(S,X)
  return((A1,A2))
}

//LxJ MATRIX OF DERIVATIVES (equation 4)
//returns an n x J matrix with ith row given by lambda'G_i
//where G_i is the L x J derivative matrix associated with 
//the L x 1 moment vector g_i(\beta)
real matrix function B(real colvector lambda) {
  external colvector W, S, Z
  external matrix X
  external scalar K, L
  real matrix _B1, _B2, _B3
  real scalar lambda1, lambda3
  real colvector lambda2, lambda4
  lambda1=lambda[1]
  lambda2=lambda[2::K+1]
  lambda3=lambda[K+2]
  lambda4=lambda[K+3::L]
  _B1=(S:*Z)*(lambda1+lambda3) + (S:*X)*lambda2 + (Z:*X)*lambda4
  _B2=(Z:*X)*lambda1 + (X*lambda2):*X
  _B3=(S:*X)*lambda3 + (X*lambda4):*X
  return(-W:*(_B1,_B2,_B3))
}

//AVERAGE OF MOMENT VECTOR
real matrix function gbar(real colvector beta) {
  external scalar n, K, J, L
  real colvector alpha
  alpha=beta\J(L,1,0)
  return(transpose(mean(A(alpha))))
}

//AVERAGE OF DERIVATIVE MATRIX

// A1=W:*(Y:-theta*S:-X*nu1):*(Z,X)
// A2=W:*(Y:-theta*Z:-X*nu2):*(S,X)

// theta  nu1 nu2
// S*Z   X*Z  0
// S*X   X*X  0
// Z*S    0  S*X
// Z*X    0  X*X

real matrix function Gbar() {
  external scalar n, K, J, L
  external colvector W, S, Z
  external matrix X
  real matrix G1, G2, G3, G4, zK, zKK
  G1=mean(W:*S:*Z)            
  G2=transpose(mean(W:*S:*X)) 
  G3=transpose(mean(W:*Z:*X)) 
  G4=quadcross(X,W,X)/n       
  zK=J(1,K,0)
  zKK=J(K,K,0)
  Gbar=-( (G1, transpose(G3), zK) \ (G2, G4, zKK) \ (G1, zK, transpose(G2)) \ (G3, zKK, G4) )
  return(Gbar)
}

//AVERAGE OF DERIVATIVE MATRIX
real matrix function Gbarchk() {
  external scalar n, K, J, L
  Gbar=J(L,J,.)
  for (l=1; l<=L; l++) {
    Gbar[l,.]=mean(B(transpose(e(l,L))))
  }
  return(Gbar)
}

//WEIGHTED AVERAGE OF DERIVATIVE MATRIX
//USED FOR COMPUTING STANDARD ERRORS
real matrix function GVbar(real colvector alpha) {
  external scalar n, K, J, L
  external colvector W, S, Z
  external matrix X
  real matrix G1, G2, G3, G4, zK, zKK
  real colvector beta, lambda, V
  beta=alpha[1::J]
  lambda=alpha[J+1::J+L]
  A=A(alpha)
  V=1:/(1:+A*lambda)
  G1=mean(V:*W:*S:*Z)            
  G2=transpose(mean(V:*W:*S:*X)) 
  G3=transpose(mean(V:*W:*Z:*X)) 
  G4=quadcross(X,V:*W,X)/n       
  zK=J(1,K,0)
  zKK=J(K,K,0)
  GVbar=-( (G1, transpose(G3), zK) \ (G2, G4, zKK) \ (G1, zK, transpose(G2)) \ (G3, zKK, G4) )
  return(GVbar)
}

//double check
real matrix function GVbarchk(real colvector alpha) {
  external scalar n, K, J, L
  real matrix A, B
  real colvector beta, lambda, V
  beta=alpha[1::J]
  lambda=alpha[J+1::J+L]
  A=A(alpha)
  V=1:/(1:+A*lambda)
  GVbar=J(L,J,.)
  for (l=1; l<=L; l++) {
    B=B(transpose(e(l,L)))
    GVbar[l,.]=mean(V:*B)
  }
  return(GVbar)
}


//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//SOLVE GMM PROBLEM with I as matrix: 1 iteration
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
alpha=J(J+L,1,.)
beta=J(J,1,0)
alpha[1::J]=beta
alpha[J+1::J+L]=J(L,1,0)
lambda=alpha[2*K+2::J+L]

maxiter=3
betamat=J(J,maxiter,.)
betamat[.,1]=beta
Gbar=Gbar()   
A=A(alpha)
muA=mean(A)
Omega=quadcrossdev(A,muA,A,muA)/n 
        
MEAT = Gbar'*I(L)*Gbar   // Sigma=I(L)
C = invsym(MEAT)  // inverse of Gbar'*I*Gbar
H1 = C*Gbar'*I(L)*Omega*I(L)*Gbar*C  // one-step GMM variance matrix
H=quadcross(Gbar,Gbar) // use dot generate betas

for (iter=2; iter<=maxiter; iter++) {
  h=quadcross(Gbar,gbar(beta))
  p=lusolve(H,-h)
  beta=beta:+p
  betamat[.,iter]=beta
}
betamat 
seGMM1 = sqrt(diagonal(H1))/sqrt(n) // GMM standard errors
seGMM1

// inflate the standard errors
seGMM1_i = seGMM1* sqrt((n-J1)/(n-K1))  // df correction for the standard errors
betamat,seGMM1_i

alpha=J(J+L,1,.)
alpha[1::J]=beta
alpha[J+1::J+L]=J(L,1,0)
lambda=alpha[2*K+2::J+L]

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//SOLVE 2-step GMM PROBLEM: 1 iteration
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
maxiter=3
betamat=J(J,maxiter,.)
betamat[.,1]=beta
A=A(alpha)
muA=mean(A)
Omega=quadcrossdev(A,muA,A,muA)/n 

// For the betas
C=lusolve(Omega,Gbar) 
H=quadcross(Gbar,C) 

// For the standard errors
C1 = lusolve(Omega,I(L))
H1 = Gbar'*C1*Gbar   // H1^(-1) is the two-step GMM variance matrix
H2 = lusolve(H1,I(J)) // two-step GMM variance matrix

for (iter=2; iter<=maxiter; iter++) {
  h=quadcross(C,gbar(beta))
  p=lusolve(H,-h)
  beta=beta:+p
  betamat[.,iter]=beta
}
betamat
seGMM2 = sqrt(diagonal(H2))/sqrt(n) // GMM standard errors
seGMM2

betamatk = betamat

// inflate the standard errors
seGMM2_i = seGMM2* sqrt((n-J1)/(n-K1))  // df correction for standard errors
seGMM2_i


alpha=J(J+L,1,.)
alpha[1::J]=beta
alpha[J+1::J+L]=J(L,1,0)
lambda=alpha[2*K+2::J+L]


//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//THIRD: EMPIRICAL LIKELIHOOD
//PROGRAM WILL NOT MAKE SENSE UNLESS YOU LOOK AT
//gmm2.pdf
//WE FOLLOW THE GUGGENBERGER AND HAHN OBSERVATION
//THAT EL IS REALLY A JUST-IDENTIFIED GMM PROBLEM
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

//MOMENTS FOR EL: see gmm2.pdf
real matrix function mbar(real colvector alpha) {
  external J, L
  real matrix A, B
  real colvector V, A1, A2
  lambda=alpha[J+1::J+L]     //Lagrange multipliers
  A=A(alpha)                 //moments for beta parameters
  V=1:/(1:+A*lambda)         //n*EL weight
  B=B(lambda)                //moments for lambda parameters
  A1=transpose(mean(V:*A))
  A2=transpose(mean(V:*B))
  return((A1\A2))
}

//DERIVATIVES FOR EL: see gmm2.pdf
real matrix function Mbar(real colvector alpha) {
  external scalar n, J, L
  real matrix A, B, M11bar, N11bar, N12bar, N21bar, N22bar
  real colvector lambda, V, e
  real scalar l
  lambda=alpha[J+1::J+L]
  A=A(alpha)                 //matrix of moments
  V=1:/(1:+A*lambda)         //EL weights to apply to first term
  M11bar=GVbar(alpha)        //see gmm2.pdf
  V=1:/((1:+A*lambda):^2)    //EL weights to apply to second term
  B=B(lambda)
  N11bar=quadcross(A,V,B)/n
  N12bar=quadcross(A,V,A)/n
  N21bar=quadcross(B,V,B)/n
  N22bar=quadcross(B,V,A)/n
  return( (M11bar-N11bar,-N12bar) \ (-N21bar,transpose(M11bar)-N22bar) )
}

real matrix function Mbarchk(real colvector alpha) {
  external scalar n, J, L
  real matrix A, B, M11bar, N11bar, N12bar, N21bar, N22bar
  real colvector lambda, V, e
  real scalar l
  lambda=alpha[J+1::J+L]
  A=A(alpha)                 //matrix of moments
  V=1:/(1:+A*lambda)         //EL weights to apply to first term
  M11bar=J(L,J,.)            //initialize
  for (l=1; l<=L; l++) {
    e=transpose(e(l,L))
    B=B(e)
    M11bar[l,.]=mean(B:*V)
  }
  V=1:/((1:+A*lambda):^2)    //EL weights to apply to second term
  B=B(lambda)
  N11bar=quadcross(A,V,B)/n
  N12bar=quadcross(A,V,A)/n
  N21bar=quadcross(B,V,B)/n
  N22bar=quadcross(B,V,A)/n
  return( (M11bar-N11bar,-N12bar) \ (-N21bar,transpose(M11bar)-N22bar) )
}

//routine to ensure that derivatives are computed correctly
//uses forward difference to approximate derivative matrix
real matrix function Mbarchk2(real colvector alpha) {
  external scalar n, K, J, L
  real scalar h, i
  real colvector mbar0, mbar1
  h=0.001
  mbar0=mbar(alpha)
  Mbarchk=J(J+L,J+L,.)
  for (i=1; i<=J+L; i++) {
    mbar1=mbar(alpha+h*transpose(e(i,J+L)))
    Mbarchk[.,i]=(mbar1-mbar0)/h
  }
  return(Mbarchk)
}

//UPDATING FORMULA FOR ALPHA
real colvector function alphanew(real colvector alpha, real scalar eta) {
  external n, K, J, L
  real matrix Mbar
  real colvector mbar, p, mbar1, mbar0
  real scalar chk, h, i
  mbar=mbar(alpha)
  chk=0
  if (chk==0) {
    Mbar=Mbar(alpha)
  }
  if (chk==1) {
    Mbar=Mbarchk(alpha)
  }
  p=lusolve(Mbar,-mbar) //Mbar*p = -mbar
  alphanew=alpha+eta*p
  return(alphanew)
}

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//NOW COMPUTE EL
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
maxiter=5
alphamat=J(J+L,maxiter,.)
alphamat[.,1]=alpha
alphanew=J(J+L,1,0)
eta=1 //try shortening if moment conditions not satisfied
for (iter=2; iter<=maxiter; iter++) {
  alphanew=alphanew(alphanew,eta)
  alphamat[.,iter]=alphanew
}
alphamat

//Mbar(alpha)
//Mbarchk(alpha)

alpha=alphamat[.,maxiter]
beta=alpha[1::J]
lambda=alpha[J+1::J+L]
A=A(alpha)
V=1:/(1:+A*lambda)
sum(V),min(V),max(V)

GVbar=GVbar(alpha)
Omega=quadcross(A,V,A)/n
b4=beta
V4=invsym(GVbar'invsym(Omega)*GVbar) //there must be some way of speeding up this calculation...
se4=sqrt(diagonal(V4))/sqrt(n)

b4,se4, (se4*sqrt((n-J1)/(n-K1))) // df correction


// Estimated Parameters and Standard Errors
// GMM1, GMM2, EL
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
betamat,seGMM1_i
betamatk,seGMM2_i
b4, (se4*sqrt((n-J1)/(n-K1)))

seEL = (se4*sqrt((n-J1)/(n-K1)))

// Now let's make a table
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MATRIX = (betamat[1,1] \ seGMM1_i[1,1] \ betamatk[1,2] \ seGMM2_i[1,1] \ b4[1,1] \ seEL[1,1])
MATRIX


st_matrix("MATRIX",MATRIX)

end
svmat MATRIX

keep MATRIX
keep in 1/6

generate str var29 = "&" in 1
replace var29 = "&" in 2
replace var29 = "&" in 3
replace var29 = "&" in 4
replace var29 = "&" in 5
replace var29 = "&" in 6

generate i = 1 in 1
replace i = 2 in 2
replace i = 3 in 3
replace i = 4 in 4
replace i = 5 in 5
replace i = 6 in 6

move i MATRIX

rename MATRIX MATRIX_violent

list
log close

/*
// %%%%%%%%%%%%%%%%%%%%%%%%%
// %%%%%%%% TABLE 5 %%%%%%%%
// %%%%%%%%%%%%%%%%%%%%%%%%%
use chalfin_mccrary_restat.dta, clear
capture log close
log using table5.log, text replace


gen S=gpolice_ucr
gen Z=gpolice_asg
gen C1=gpop_ucr
gen C2=gpop_asg
gen W=popweight

//egen styr=group(STATE year)

foreach var in S Z C1 C2 {
  quietly areg `var' [aw=W], absorb(styr)
  capture drop e
  predict e, resid
  replace `var'=e
}

include gmmCMcov.ado

tempname memhold
postfile `memhold' str20(var1 var2) double(theta1 se1 theta2 se2 diff sediff) using reg.dta, replace

foreach var1 in violent murder rape robbery assault property burglary larceny motor cw cwviolent cwproperty {
  foreach var2 in violent murder rape robbery assault property burglary larceny motor cw cwviolent cwproperty {
    if ("`var1'"~="`var2'") {

      capture drop Y1
      capture drop Y2
      gen Y1=qi`var1'
      gen Y2=qi`var2'

      foreach var in Y1 Y2 {
        quietly areg `var' [aw=W], absorb(styr)
        capture drop e
        predict e, resid
        replace `var'=e
      }

      ivreg Y1 (S=Z) C1 C2 [aw=W]
      local b11=_b[S]
      local se11=_se[S]
      ivreg Y1 (Z=S) C1 C2 [aw=W]
      local b12=_b[Z]
      local se12=_se[Z]
      local b1=((`b11')*(1/(`se11')^2)+(`b12')*(1/(`se12')^2))/((1/(`se11')^2)+(1/(`se12')^2))
      local se1=sqrt(1/((1/(`se11')^2)+(1/(`se12')^2)))

      ivreg Y2 (S=Z) C1 C2 [aw=W]
      local b21=_b[S]
      local se21=_se[S]
      ivreg Y2 (Z=S) C1 C2 [aw=W]
      local b22=_b[Z]
      local se22=_se[Z]
      local b2=((`b21')*(1/(`se21')^2)+(`b22')*(1/(`se22')^2))/((1/(`se21')^2)+(1/(`se22')^2))
      local se2=sqrt(1/((1/(`se21')^2)+(1/(`se22')^2)))

      gmmCM Y1 Y2 S Z C1 C2 W
      return list

      di "Compare 2-step GMM estimates to simple inverse-variance weighted average of IV estimates"
      di `b1' _newline `se1' _newline r(beta1GMM2) _newline r(se1GMM2)

      di `b2' _newline `se2' _newline r(beta2GMM2) _newline r(se2GMM2)

      local diff=(`b2')-(`b1')
      local sediff=sqrt( r(se2GMM2)^2 + r(se1GMM2)^2 - 2*r(covGMM2) )

      di "Look at differences: are they significant at 95% confidence level?"
      di `diff' _newline `sediff'

      post `memhold' ("`var1'") ("`var2'") ///
        (r(beta1GMM2)) (r(se1GMM2)) (r(beta2GMM2)) (r(se2GMM2)) (`diff') (`sediff')

    }
  }
}

postclose `memhold'

use reg.dta, clear

list, clean noobs
gen t=diff/sediff
list if t>1.96
gen p=2*(1-normal(abs(t)))
list var1 var2 p
log close
*/

set more off
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// %%%%%%%% WEB APPENDIX %%%%%%%%
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
use chalfin_mccrary_restat.dta, clear
local ucr gpolice_ucr
local asg gpolice_asg
local lemas gpolice_lemas
local w popweight
	
// panelid variable
tsset agencynum year

// measurement error type Y
gen yyyy = `ucr'-`asg'
capture log close
log using webappendix1.log, replace

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// FULL SAMPLE
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

// Panel A: Regress measurement errors on crime variables
gen lemasflag=1 if year==1987 | year==1990 | year==1992 | year==1993 | year==1996 | ///
year==1997 | year==1999 | year==2000 | year==2003 | year==2004 | year==2007 | year==2008
 

// Individual coefficients
foreach i of varlist yyyy {
 	foreach j of varlist gviolent gmurder grape grobbery gassault gproperty gburglary glarceny gmotor {
		areg `i' `j' gpop_ucr gpop_asg [aw=popweight], absorb(styr) robust
 	}
}
 
// F-statistic on joint significance of crime variables
areg yyyy gviolent gmurder grape grobbery gassault ///
gproperty gburglary glarceny gmotor if lemasflag==1 [aw=`w'], absorb(styr) robust  

  

preserve

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Do analyses where LEMAS data are involved
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
keep if lemasflag==1 

egen yrgrp = group(year)
    
tsset agencynum yrgrp // new year variable
by agencynum, sort: gen Qucr = ln(police_ucr/l.police_ucr)
by agencynum, sort: gen Qlemas = ln(police_lemas/l.police_lemas)
by agencynum, sort: gen Qasg = ln(police_asg/l.police_asg)

local Qucr Qucr
local Qlemas Qlemas
local Qasg Qasg

gen xxxx = `Qucr'-`Qlemas'
gen zzzz = `Qasg'-`Qlemas'

// PANEL A

// only keep the years which have LEMAS data
foreach i of varlist xxxx zzzz {
 	foreach j of varlist gviolent gmurder grape grobbery gassault gproperty gburglary glarceny gmotor {
		areg `i' `j' gpop_ucr gpop_asg [aw=popweight] if lemasflag==1, absorb(styr) robust
 	}
}
 
 // F-statistics
 areg xxxx gviolent gmurder grape grobbery gassault gproperty gburglary glarceny gmotor if lemasflag==1 [aw=`w'], absorb(styr) robust

 areg zzzz gviolent gmurder grape grobbery gassault gproperty gburglary glarceny gmotor if lemasflag==1 [aw=`w'], absorb(styr) robust

  
// PANEL B
areg xxxx `asg'  [aw=`w'], absorb(styr) robust
areg yyyy `lemas' [aw=`w'], absorb(styr) robust
areg zzzz `ucr'  [aw=`w'], absorb(styr) robust

// PANEL C: POPULATIONN

areg xxxx gpop_ucr gpop_asg  [aw=`w'], absorb(styr) robust
    test gpop_ucr gpop_asg
areg yyyy gpop_ucr gpop_asg [aw=`w'], absorb(styr) robust
    test gpop_ucr gpop_asg
areg zzzz gpop_ucr gpop_asg [aw=`w'], absorb(styr) robust
    test gpop_ucr gpop_asg
    
    

restore

log close


// %%%%%%%%%%%%%%%%%%%%%%%%%
// %%%%%%%% TABLE 4 %%%%%%%%
// %%%%%%%%%%%%%%%%%%%%%%%%%
use covars.dta, clear

tsset agencynum year

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// PREPARE COVARIATES
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

keep if year>=1969 & year<=2002


foreach i of varlist gviolent gmurder grape grobbery gassault ///
gproperty gburglary glarceny gmotor gcw gpolice_ucr gpolice_asg ///
gpop_ucr gpop_asg ///
`covariates' `lcovariates' `ddemog' {
    drop if `i'==.
}


// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// SET UP DE-MEANED DATA
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

// Locals
local covariates rmage_all_18 rmage_black_18 ///
rbweight gCA04_10 ///
gCA05_400 gCA05_500 gCA05_600 gCA05_700 ///
gCA25_10 ///
gCA25_400 gCA25_500 gCA25_600 gCA25_700 fexp 

local lcovariates lrmage_all_18 lrmage_black_18  ///
lrbweight lgCA04_10 ///
lgCA05_400 lgCA05_500 lgCA05_600 lgCA05_700 ///
lgCA25_10 ///
lgCA25_400 lgCA25_500 lgCA25_600 lgCA25_700 lfexp 

local ddemog diage15_24_1- diage40_4

local poly2  diage15_24_1_sq diage25_39_1_sq diage40_1_sq diage0_14_2_sq ///
diage15_24_2_sq diage25_39_2_sq diage40_2_sq diage0_14_3_sq diage15_24_3_sq ///
diage25_39_3_sq diage40_3_sq diage0_14_4_sq diage15_24_4_sq diage25_39_4_sq ///
diage40_4_sq 

local inter inter*

foreach i of varlist gviolent gmurder grape grobbery gassault ///
gproperty gburglary glarceny gmotor gcw gpolice_ucr gpolice_asg ///
gpop_ucr gpop_asg  {
	areg `i' [aw=popweight], absorb(styr) 
		predict res1_`i', res
		
	areg `i' `covariates' [aw=popweight], absorb(styr) 
		predict res2_`i', res
		
	areg `i' `covariates' `lcovariates' [aw=popweight], absorb(styr) 
		predict res3_`i', res
		
	areg `i' `covariates' `lcovariates' `ddemog'  [aw=popweight], absorb(styr) 
		predict res4_`i', res
		
	areg `i' `covariates' `lcovariates' `ddemog' `poly' `inter' ///
	[aw=popweight], absorb(styr) 
		predict res5_`i', res
		
	areg `i' `covariates' `lcovariates' `ddemog' `poly' `inter' tr_citynum*  ///
	[aw=popweight], absorb(styr) 
		predict res6_`i', res
}


// %%%%%%%%%%%%%%%%%%%%%%%%%%%
// TABLE 4 (Columns 1-6)
// %%%%%%%%%%%%%%%%%%%%%%%%%%%

capture log close
log using table4a.log, replace


// VIOLENT
foreach j of numlist 1/6 {
gen Y`j'=res`j'_gviolent
gen S`j'=res`j'_gpolice_ucr
gen Z`j'=res`j'_gpolice_asg
gen P`j'=res`j'_gpop_ucr
gen Q`j'=res`j'_gpop_asg

di `j'

gmm ///
  (LLAA: Y`j'-{b01}-{b1}*S`j'-{b21}*P`j'-{b31}*Q`j') /// 
  (AALL: Y`j'-{b04}-{b1}*Z`j'-{b22}*P`j'-{b32}*Q`j') ///
  [aw=popweight], ///
  instruments(LLAA: Z`j' P`j' Q`j') ///
  instruments(AALL: S`j' P`j' Q`j') ///
  winitial(identity)

}


log close


// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// %%%%%%%% WEB APPENDIX TABLE 1 %%%%%%%%
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
use chalfin_mccrary_restat.dta, clear

	
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
local qucr gpolice_ucr
local qasg gpolice_asg
local qlemas gpolice_lemas
local w popweight
	
// panelid variable
tsset agencynum year

// measurement error type Y
gen yyyy = `qucr'-`qasg'

capture log close
log using webappendix1.log, replace

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// FULL SAMPLE: Column 1
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

areg yyyy gmurder grape grobbery gassault gburglary glarceny gmotor ///
gpop_ucr gpop_asg [aw=`w'], absorb(styr) robust   

// F-tests
test gmurder grape grobbery gassault gburglary glarceny gmotor
test gpop_ucr gpop_asg

drop yyyy
preserve

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// LEMAS SUB-SAMPLE: Columns, 2, 3 and 4
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gen lemasflag=1 if year==1987 | year==1990 | year==1992 | year==1993 | year==1996 ///
| year==1997 | year==1999 | year==2000 | year==2003 | year==2004 | year==2007 | year==2008
keep if lemasflag==1 

egen yrgrp = group(year)
    
tsset agencynum yrgrp // new year variable
by agencynum, sort: gen Qucr = ln(police_ucr/l.police_ucr)
by agencynum, sort: gen Qasg = ln(police_asg/l.police_asg)
by agencynum, sort: gen Qlemas = ln(police_lemas/l.police_lemas)
by agencynum, sort: gen Qucrpop = ln(pop_ucr/l.pop_ucr)
by agencynum, sort: gen Qasgpop = ln(pop_asg/l.pop_asg)

local Qucr Qucr
local Qasg Qasg
local Qlemas Qlemas

gen yyyy = `Qucr'-`Qasg'
gen xxxx = `Qucr'-`Qlemas'
gen zzzz = `Qasg'-`Qlemas'


foreach i of varlist yyyy  {
		areg `i' gmurder grape grobbery gassault gburglary glarceny gmotor `Qlemas' ///
		Qucrpop Qasgpop if lemasflag==1 [aw=`w'], absorb(styr) robust   
}
test gmurder grape grobbery gassault gburglary glarceny gmotor
test `Qlemas'
test Qucrpop Qasgpop

 
foreach i of varlist xxxx  {
		areg `i' gmurder grape grobbery gassault gburglary glarceny gmotor `Qasg' ///
		Qucrpop Qasgpop if lemasflag==1 [aw=`w'], absorb(styr) robust   
}
test gmurder grape grobbery gassault gburglary glarceny gmotor
test `Qasg'
test Qucrpop Qasgpop

foreach i of varlist zzzz  {
		areg `i' gmurder grape grobbery gassault gburglary glarceny gmotor `Qucr' ///
		Qucrpop Qasgpop if lemasflag==1 [aw=`w'], absorb(styr) robust   
}
test gmurder grape grobbery gassault gburglary glarceny gmotor
test `Qucr'
test Qucrpop Qasgpop

 
// PANEL B
areg xxxx `qasg'  [aw=`w'], absorb(styr) robust
areg yyyy `qlemas' [aw=`w'], absorb(styr) robust
areg zzzz `qucr'  [aw=`w'], absorb(styr) robust


restore

log close
 
