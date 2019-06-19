*******  This program draws densities and cdfs ********
*******  Figure 2 in the paper ********


******* The program uses Stata 10, with the Mata extension ********


clear
clear mata 
set mem 300m
set more off

** Load the data 
cd D:\Dossiers\Stata\Inequality
use samplefinal, clear


** Options 

local y="math16"
local w1="math11"
local z1="draw copy"
local option="three"



mata:

// Nquant=nb of percentiles
Nquant=99

// ngrid is the number of nods to compute the characteristic function (and integrate it)
// npoint is the number of values where the densities/cdfs are evaluated
ngrid=201
npoint=1001

// S is the bandwidth for the deconvolution
// May be modified, using as a guide the approach in Diggle and Hall (1993)
// See program Diggle.do

S=.42
end


** Keep children with non-missing parental education when the Z's used are (FEDUC,MEDUC)

local FEDUClist="FEDUC MEDUC"

local a : list FEDUClist==z1
if `a'==1 {
keep if FEDUCmiss==0 & MEDUCmiss==0
local zerolist=""
}
else {
local zerolist="FEDUC MEDUC FEDUCmiss MEDUCmiss"
}


** Covariates: possible choices

local onelist "`zerolist' cmsex sc580-sc584 sc58miss sc69* sc1965* sc65miss oldersib oldersibmiss mwork65 mwork65miss MINC1-MINC2 FINC1-FINC4" 
local twolist "`onelist' stay65 stay65miss nchildc65 nchildc65miss noschool noschoolmiss ptr69 ptr69miss junior69 buildage69 buildage69miss nostream69"
local threelist "`twolist' usick mwork mininge manage skme sskme ppr iwc immi RE161-RE169"

** Rule of thumb's bandwidth for smoothing cdf's and pdf's
** Used for estimates on the raw data only

qui _pctile `y', p(25 75)
scalar bw=(r(r2)-r(r1))/1.34
qui su `y'
scalar bw=.9*min(r(sd),bw)*_N^(-1/5)
mata:
bw=st_numscalar("bw")
end



** The program allows for several W's or Z's

local b: list sizeof w1
scalar B=`b'

** Keep observations with non-missing dependent/independent variables 

keep ``option'list' `y' `w1' `z1' la C GRAM SECMOD 
qui reg `y' ``option'list'  `w1' `z1' la C
keep if e(sample)

** Save the initial sample

save init2, replace


** Start mata routine

mata: 


b=st_numscalar("B")

// Bootstrap iterations
// The iteration (Nboot+1) is the estimate on the original sample


stata("use init2, clear")


// 2SLS regression, to estimate the ratio of beta's
// C=1 denotes comprehensive


stata("ivreg2 `y' (`w1'=`z1') ``option'list' if C==1, first cluster(la)")


stata("matrix eb=e(b)")

if (b==1){
	stata("scalar Ratio1=eb[1,1]")
	stata("scalar Ratio2=.")
	stata("qui gen w=Ratio1*`w1'")
}


// Compute regression residuals

stata("qui reg `y' ``option'list' if C==1")
stata("qui predict resy1, resid")
stata("qui reg `y' ``option'list' if C==0")
stata("qui predict resy0, resid")
stata("qui reg w ``option'list' if C==1")
stata("qui predict resw1, resid")
stata("qui reg w ``option'list' if C==0")
stata("qui predict resw0, resid")
stata("qui reg `z1' ``option'list' if C==1")
stata("qui predict resz11, resid")
stata("qui reg `z1' ``option'list' if C==0")
stata("qui predict resz10, resid")



// Propensity score
 
stata("qui xi: logit C ``option'list' if C==0|C==1")
stata("qui predict piX")

stata("qui su C if C==0|C==1")
stata("scalar piC=r(mean)")


// Mean effect, raw

stata("qui su `y' if C==0")
stata("scalar mean0=r(mean)")
stata("qui su `y' if C==1")
stata("scalar mean1=r(mean)")

mean0=st_numscalar("mean0")
mean1=st_numscalar("mean1")


// Mean effect, matching on observables
stata("qui gen effectm=C/(1-piC)*(`y')*(1-piX)/piX if piX>=0.05 & piX<=0.95")
stata("qui su effectm if C==0|C==1")
stata("scalar meanm1=r(mean)")

// Mean effect, matching on observables and unobservables

stata("qui su w if C==0")
stata("qui gen effect=C/(1-piC)*(`y'-w)*(1-piX)/piX+r(mean) if piX>=0.05 & piX<=0.95")
stata("qui su effect if C==0|C==1")
stata("scalar meanc1=r(mean)")
stata("scalar dmean=mean0-mean1")
stata("scalar dmeanc=mean0-meanc1")
stata("scalar dmeanm=mean0-meanm1")
meanc1=st_numscalar("meanc1")
meanm1=st_numscalar("meanm1")




// Compute regression residuals and squared residuals

stata("qui reg w ``option'list'")
stata("qui predict resw, resid")
stata("qui gen resw1_2=(resw1)^2")
stata("qui gen resw0_2=(resw0)^2")
stata("qui gen resy1_2=(resy1)^2")
stata("qui gen resy0_2=(resy0)^2")
stata("qui gen resw_2=(resw)^2")


// Generate the indicator of selective schooling

stata("g NC=(C==0)")

// Transfering the data from Stata to Mata

stata("qui cumul `y' if C==0, gen(rank`y')")

c=st_data(.,("C"))
nc=st_data(.,("NC"))
y=st_data(.,("`y'"))
y0=st_data(.,("`y'"),"NC")
y1=st_data(.,("`y'"),"C")
p=st_data(.,("piX"))
w=st_data(.,("w"))
w1=st_data(.,("w"),"C")
w0=st_data(.,("w"),"NC")
ResVarY1=st_data(.,"resy1_2")
ResVarY0=st_data(.,"resy0_2")
ResVarW1=st_data(.,"resw1_2")
ResVarW0=st_data(.,"resw0_2")
ResVarW=st_data(.,"resw_2")
n1=colsum(c)
n=rows(y)
n0=n-n1
pc=(1/n)*n1

// Support of the dependent variable 
// May be modified if needed

suppmin=min(y)-(max(y)-min(y))/5
suppmax=max(y)+(max(y)-min(y))/5


// Generating a constant

stata("g cons=1")

stata("keep ``option'list' cons C NC")

X=st_data(.,.)
X0=select(X,nc)
X1=select(X,c)

stata("drop C NC")
X=st_data(.,.)


// Variance, raw and matching

varc1=(1/n1)*colsum((ResVarY1-(ResVarW1-ResVarW0)):*(J(n,1,1)-c))+variance(X0*pinv(X1)*y1+(X0*(pinv(X0)*w0-pinv(X1)*w1)))
varm1=(1/n1)*colsum((ResVarY1):*(J(n,1,1)-c))+variance(X0*pinv(X1)*y1)
var1=variance(y1)
var0=variance(y0)

v0=var0-var1
v0c=var0-varc1
v0m=var0-varm1





// Characteristic function 

psiY20=J(ngrid,1,0+0i)
psiD=J(ngrid,1,0+0i)
ti=J(npoint,1,0)
tD=J(ngrid,1,0)

B11=y:*J(n,1,0+1i)
B0=w:*J(n,1,0+1i)
pinvX=pinv(X)

t=range(-S,S,(2*S)/(ngrid-1))

	   expbt=exp(B0*t')
	   expbt1=pinvX*((J(n,1,1)-c):*expbt)
	   expbt2=pinvX*(c:*expbt)

		beta1=X*(expbt1)
	   	beta2=X*(expbt2)
	   	psiY20=conj((1/(n*(1-pc)))*colsum(c:*(exp(B11*t')):*((beta1):/(beta2)):*(p:<=.95*J(rows(p),1,1)):*(p:>=.05*J(rows(p),1,1))))'
	      psiY20=psiY20:/((1/(n))*colsum((p:<=.95*J(rows(p),1,1)):*(p:>=.05*J(rows(p),1,1))))

// Rescaling the c.f. so that the distribution has mean meanc1
// May be removed
	     
	      alpha=-log(psiY20[ngrid/2])
		beta=meanc1+(1i)*(log(psiY20[ngrid/2+10])-log(psiY20[ngrid/2-10]))*(ngrid-1)/(40*S)
	      
		psiY20=psiY20:*exp(alpha*J(rows(t),1,1)+(1i)*beta*t)


// Density function

f=J(npoint,1,0+0i)

for (k=1; k<=npoint; k++) {

// Support of the counterfactual density

spt=suppmin+(k-1)*(suppmax-suppmin)/(npoint-1)

// Inverse Fourier transformation
f[k,1]=(1/(2*pi()))*colsum((psiY20):*exp(-J(ngrid,1,1i):*t:*spt))*2*(S/(ngrid-1))
}

// Impose that the density is non-negative, and integrates to 1
// May be removed

f=Re(f):*(Re(f):>0)
f=f/colsum(f:*(f:>0)*(suppmax-suppmin)/(npoint-1))

st_matrix("D",f)

// Cumulative distribution function

ff=J(npoint,1,0+0i)

ff=mm_colrunsum(f:*(f:>0))*(suppmax-suppmin)/(npoint-1)


for (l=1; l<=npoint; l++) 
{
ti[l,1]= suppmin+(l-1)*(suppmax-suppmin)/(npoint-1)
}

st_matrix("C",Re(ff))
st_matrix("support",ti)

// Original CDF

fo=J(npoint,1,0)

for (m=1; m<=npoint; m++) 
{
spt=suppmin+(m-1)*(suppmax-suppmin)/(npoint-1)
fo[m,1]=(1/(n0))*colsum(J(n0,1,1)-normal((y0-J(n0,1,spt))/bw))
}
st_matrix("O",fo)

// Original CDF, comprehensive

fo1=J(npoint,1,0)

for (m=1; m<=npoint; m++) 
{
spt=suppmin+(m-1)*(suppmax-suppmin)/(npoint-1)
fo1[m,1]=(1/(n1))*colsum(J(n1,1,1)-normal((y1-J(n1,1,spt))/bw))
}

st_matrix("O1",fo1)

// Original density, using the same bandwidth

fd=J(npoint,1,0)
for (n=1; n<=npoint; n++) 
{
spt=suppmin+(n-1)*(suppmax-suppmin)/(npoint-1)
fd[n,1]=(1/n0)*colsum((1/bw)*mm_kern("gaussian",(y0-J(n0,1,spt))/bw))
}

st_matrix("A",fd)

// Original density, comprehensive, using the same bandwidth

fd1=J(npoint,1,0)
for (n=1; n<=npoint; n++) 
{
spt=suppmin+(n-1)*(suppmax-suppmin)/(npoint-1)
fd1[n,1]=(1/n1)*colsum((1/bw)*mm_kern("gaussian",(y1-J(n1,1,spt))/bw))
}

st_matrix("A1",fd1)


// END OF BOOTSTRAP


end



** Post-processing of output (graphs etc.)
  
svmat D, names(density)
svmat C, names(cumultreat)
svmat O, names(cumulorig)
svmat O1, names(cumulorig1)
svmat A, names(origdens)
svmat A1, names(origdens1)
svmat support, names(support)

** cdf, uncorrected

#delimit ;
 twoway (line cumulorig11 support1, lcolor(black) lpattern(dash) lwidth(thick)) 
 (line cumulorig1 support1, lcolor(black) lpattern(solid) lwidth(thick)), 
 ytitle(cdf) 
 xtitle(outcome) 
legend(order(1 "counterfactual" 2 "realized") size(medsmall)) scheme(s1mono);
*graph export "/Users/uli/Desktop/phdchapters/comp/submission/revision mai 2008/revision oct 2008/test2.eps", as(eps) preview(on) replace;
 #delimit cr

sleep 1000



** cdf, corrected

#delimit ;
 twoway (line cumultreat1 support1, lcolor(black) lpattern(dash) lwidth(thick)) 
 (line cumulorig1 support1, lcolor(black) lpattern(solid) lwidth(thick)), 
 ytitle(cdf) 
 xtitle(outcome) 
legend(order(1 "counterfactual" 2 "realized") size(medsmall)) scheme(s1mono);
*graph export "/Users/uli/Desktop/phdchapters/comp/submission/revision mai 2008/revision oct 2008/test2.eps", as(eps) preview(on) replace;
 #delimit cr


sleep 1000

** density, uncorrected

#delimit ;
 twoway (line origdens11 support1, lcolor(black) lpattern(dash) lwidth(thick))
 (line origdens1 support1, lcolor(black) lpattern(solid) lwidth(thick)),
 ytitle(density) 
 xtitle(outcome) 
legend(order(1 "counterfactual" 2 "realized") size(medsmall)) scheme(s1mono);
*graph export "/Users/uli/Desktop/phdchapters/comp/submission/revision mai 2008/revision oct 2008/test3.eps", as(eps) preview(on) replace;
 #delimit cr

sleep 1000

** density, corrected


#delimit ;
 twoway (line density1 support1, lcolor(black) lpattern(dash) lwidth(thick))
 (line origdens1 support1, lcolor(black) lpattern(solid) lwidth(thick)),
 ytitle(density) 
 xtitle(outcome) 
legend(order(1 "counterfactual" 2 "realized") size(medsmall)) scheme(s1mono);
*graph export "/Users/uli/Desktop/phdchapters/comp/submission/revision mai 2008/revision oct 2008/test3.eps", as(eps) preview(on) replace;
 #delimit cr

