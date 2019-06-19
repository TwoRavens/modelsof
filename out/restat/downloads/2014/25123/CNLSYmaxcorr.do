/*This program will attempt to find transformations of the PIAT-K and the PPVT so
  as to maximize the correlation between the two.*/
  
clear all

set mem 300m
set more off
set matsiz 800
/*Input data directory here*/
cd "C:\Users\bond10\Desktop\RA\Test Scores\Paper\replication files"
use CNLSYbondlang.dta, clear

keep if earlyppvt!=. & PIATreadcomraw!=. & grade==0



mata
st_view(ppvt=.,.,"earlyppvt")
st_view(piat=.,.,"PIATreadcomraw")
st_view(race=.,.,"black")

void eval1(todo, p, ppvt, piat, race, r, S, H)  {

real vector ppvts
real vector piats
real vector z
real vector b
real vector constant
real vector ppvtscores
real vector piatscores

real matrix X

real scalar SSE
real scalar SST
real scalar i
real scalar cov
real scalar v
real scalar w

/*B1 for PPVT*/
v=2.8622362189904E-27
/*B1 for PIAT*/
w=1.33305939592453E-26

z=p

ppvts = v:*(ppvt:+z[6]) + z[1]:*(ppvt:+z[6]):^2 + z[2]:*(ppvt:+z[6]):^3 +z[3]:*(ppvt:+z[6]):^4 + z[4]:*(ppvt:+z[6]):^5 + z[5]:*(ppvt:+z[6]):^6

piats = w:*(piat:+z[12]) + z[7]:*(piat:+z[12]):^2 + z[8]:*(piat:+z[12]):^3 + z[9]:*(piat:+z[12]):^4 + z[10]:*(piat:+z[12]):^5 + z[11]:*(piat:+z[12]):^6

ppvts = ppvts:-mean(ppvts)
ppvts = ppvts:/variance(ppvts)^.5
piats = piats:-mean(piats)
piats = piats:/variance(piats)^.5


constant = J(rows(ppvts),1,1)



X = (ppvts, constant)
b = invsym(cross(X,X))*cross(X,piats)

SST = sum((piats:-mean(piats)):^2)
SSE = sum((piats:-X*b):^2)
r = 1-(SSE/SST)



//r = sum(ppvts:*piats)/(rows(ppvts)-1)

/*Monotonicity constraint*/
ppvtscores = J(1,max(ppvt),1)
piatscores = J(1,max(piat)-min(piat),1)

ppvtscores = (min(ppvt),ppvtscores)'
piatscores = (min(piat),piatscores)'

ppvtscores = runningsum(ppvtscores)
piatscores = runningsum(piatscores)



ppvtscores = v:*(ppvtscores:+z[6]) + z[1]:*(ppvtscores:+z[6]):^2 + z[2]:*(ppvtscores:+z[6]):^3 +z[3]:*(ppvtscores:+z[6]):^4 + z[4]:*(ppvtscores:+z[6]):^5 + z[5]:*(ppvtscores:+z[6]):^6

piatscores = w:*(piatscores:+z[12]) + z[7]:*(piatscores:+z[12]):^2 + z[8]:*(piatscores:+z[12]):^3 + z[9]:*(piatscores:+z[12]):^4 + z[10]:*(piatscores:+z[12]):^5 + z[11]:*(piatscores:+z[12]):^6

for (i=2;i<=rows(ppvtscores);i++) {
      if (ppvtscores[i]-ppvtscores[i-1]<0) r = r-1 
                  }
for (i=2; i<=rows(piatscores);i++)  {
      if (piatscores[i]-piatscores[i-1]<0) r = r-1
	              }
				                    }
				  
S=optimize_init()
optimize_init_evaluator(S, &eval1())
optimize_init_evaluatortype(S,"v0")
/*input (ppvtB2,ppvtB3,ppvtB4,ppvtB5,ppvtB6,ppvtK,PIATb2,PIATb3,PIATb4,PIATb5,PIATb6,PIATk) */
optimize_init_params(S,(0.019175009412964,0.000014276995922288,-2.65405674756929E-06,2.35935354335936E-08,-8.70461218109283E-11,29.87955862,0.0338082359805415,0.00191017752220908,-0.0000690517381140018,-1.92428688013601E-07,1.34570452940933E-08,4.852657601))
optimize_init_argument(S,1,ppvt)
optimize_init_argument(S,2,piat)
optimize_init_argument(S,3,race)
optimize_init_trace_params(S,"on")
optimize_init_singularHmethod(S,"hybrid")
optimize_init_conv_maxiter(S,50)
p=optimize(S)


	   
	  
