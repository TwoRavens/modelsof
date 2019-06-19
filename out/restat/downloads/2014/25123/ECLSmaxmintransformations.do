/*This program is designed to choose a smooth, monotonic transformation of the
ECLS-K test scores so as to minimize the change in the test score gap as a proprotion of the
variance in the test score  (weights are used via weighted least squares)*/


clear all

set mem 250m
set more off
set matsiz 8000
/*choose directory*/
cd "C:\Users\Tim\Desktop\RA\Test Scores\Paper\replication files" 
use ECLSbondlang.dta, clear

/*Normalize test scores to be between 0 and 1 -- improves running of program*/
replace readfallk=readfallk/180
replace readspring3 = readspring3/180

mata

st_view(race=.,.,("black hispanic asian other"))
st_view(w=.,.,("weights"))
st_view(tk=.,.,("readfallk"))
st_view(tt=.,.,("readspring3"))

void eval1(todo, p, race, w, tk, tt, gapgrowth, g, H)
{
       real vector stk
	   real vector stt
	   real vector bk
	   real vector bt
	   real vector scores
	   real vector r
	   
	   real matrix X
	   
	   real scalar smk
	   real scalar smt
	   real scalar svk
	   real scalar svt
	   real scalar gapk
	   real scalar gapt
	   real scalar i
	   real scalar z
	   
/*Inpur B1 here*/
	   
	   z=43.5647755472808

	   
	     r = p
   	   stk= z:*(tk:+r[6]) + r[1]:*(tk:+r[6]):^2 + r[2]:*(tk:+r[6]):^3 + r[3]:*(tk:+r[6]):^4 + r[4]:*(tk:+r[6]):^5 + r[5]:*(tk:+r[6]):^6
	   stt = z:*(tt:+r[6]) + r[1]:*(tt:+r[6]):^2 + r[2]:*(tt:+r[6]):^3 + r[3]:*(tt:+r[6]):^4 + r[4]:*(tt:+r[6]):^5 + r[5]:*(tt:+r[6]):^6

/*normalize new test scores*/
smk = (w'stk/sum(w))
svk = sum(w)*(w'(stk:-smk):^2)/(sum(w)^2-sum(w:^2))
stk = (stk:-smk):/(svk^.5)
smt = (w'stt/sum(w))
svt = sum(w)*(w'(stt:-smt):^2)/(sum(w)^2-sum(w:^2))
stt = (stt:-smt):/(svt^.5)

/*weighted OLS*/	   
	   X = (race)
	   X = X,J(rows(X),1,1)
	   bk = invsym(cross(X,w,X))*cross(X,w,stk)
	   bt = invsym(cross(X,w,X))*cross(X,w,stt)
	   
/*pull gaps from betas*/
gapk = -bk[1]
gapt = -bt[1]

	   
gapgrowth = gapt-gapk
	   
scores = J(1,round(180*max(tt)) - round(180*min(tk))+2,0)

	   
for (i=1; i<=cols(scores); i++)    {
	        scores[i]= round(180*min(tk)) + i -2
            	}
				
scores = scores:/180

scores = z:*(scores:+r[6]) + r[1]:*(scores:+r[6]):^2 + r[2]:*(scores:+r[6]):^3 + r[3]:*(scores:+r[6]):^4 + r[4]:*(scores:+r[6]):^5 + r[5]:*(scores:+r[6]):^6

 
 
/*Check for monotonicity*/
for (i=2; i<=cols(scores); i++)   {
 /*Change this line to + 1 to find minimum*/
 if (scores[i]-scores[i-1]<0) gapgrowth = gapgrowth - 1
                    }
					
                    
					   }
S=optimize_init()
optimize_init_evaluator(S, &eval1())
/*Choose max or min depending on which transformation you want*/
optimize_init_which(S, "max")
/*Input B2-k here*/
optimize_init_params(S,(333.812048652315,684.872693152376, -1090.89901769114, -474.236826241268, 623.006815083061, -0.2784345))
optimize_init_argument(S,1,race)
optimize_init_argument(S,2,w)
optimize_init_argument(S,3,tk)
optimize_init_argument(S,4,tt)
optimize_init_singularHmethod(S,"hybrid")
optimize_init_trace_params(S,"on")
optimize_init_conv_maxiter(S,15)
p = optimize(S)

p


end

replace readfallk=readfallk*180
replace readspring3 = readspring3*180
