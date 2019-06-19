/*This program is designed to choose a smooth, monotonic transformation of the
ECLS-K test scores so as to maximize the R-squared of a regression of
the kindergarten scores on the third grade scores
(weights are used via weighted least squares)*/


clear all

set mem 250m
set more off
set matsiz 8000
/*choose directory*/
cd "C:\Users\bond10\Desktop\RA\Test Scores\Paper\replication files" 
use ECLSbondlang.dta, clear

/*Normalize test scores to be between 0 and 1 -- made program run smoother*/
replace readfallk=readfallk/180
replace readspring3 = readspring3/180


mata

st_view(race=.,.,("black hispanic asian other"))
st_view(w=.,.,("weights"))
st_view(tk=.,.,("readfallk"))
st_view(tt=.,.,("readspring3"))


void eval1(todo, p, w, tk, tt,covtk, g, H)
{
       real vector stk
	   real vector stt
	   real vector b
	   real vector scores
	   real vector z
	   
	   real scalar smk
	   real scalar smt
	   real scalar svk
	   real scalar svt
	   real scalar gapk
	   real scalar gapt
	   real scalar i
	   real scalar eigen
	   real scalar q
	   
	   
	     z= p
		 
		 
		 q = 2959.23268775735
   	   stk= q:*(tk:+z[6]) + z[1]:*(tk:+z[6]):^2 + z[2]:*(tk:+z[6]):^3 + z[3]:*(tk:+z[6]):^4 + z[4]:*(tk:+z[6]):^5 + z[5]:*(tk:+z[6]):^6
	   stt = q:*(tt:+z[6]) + z[1]:*(tt:+z[6]):^2 + z[2]:*(tt:+z[6]):^3 + z[3]:*(tt:+z[6]):^4 + z[4]:*(tt:+z[6]):^5 + z[5]:*(tt:+z[6]):^6

/*normalize new test scores*/
smk = sum(stk:*w)/sum(w)
svk = sum(w:*(stk:-smk):^2)/sum(w)
stk = (stk:-smk):/(svk^.5)
smt = sum(stt:*w)/sum(w)
svt = sum(w:*(stt:-smt):^2)/sum(w)
stt = (stt:-smt):/(svt^.5)

/*weighed correlation*/
covtk = sum(w:*stk:*stt)/sum(w)



/*Monotonicity constraint*/
scores = J(1,round(180*max(tt)) - round(180*min(tk))+2,0)

	   
for (i=1; i<=cols(scores); i++)    {
	        scores[i]= round(180*min(tk)) + i -2
            	}
				
scores = scores:/180

scores = q:*(scores:+z[6]) + z[1]:*(scores:+z[6]):^2 + z[2]:*(scores:+z[6]):^3 + z[3]:*(scores:+z[6]):^4 + z[4]:*(scores:+z[6]):^5 + z[5]:*(scores:+z[6]):^6
	   
 for (i=2; i<=cols(scores); i++)   {
  if (scores[i]-scores[i-1]<0) covtk = covtk - 1
                    }
					
}
S=optimize_init()
optimize_init_evaluator(S, &eval1())
optimize_init_which(S, "max")
optimize_init_params(S,(12710.2673064966,29460.2745370992,36857.0819681668,23279.9123969347,5752.4599459532,-1.158344))
optimize_init_argument(S,1,w)
optimize_init_argument(S,2,tk)
optimize_init_argument(S,3,tt)
optimize_init_singularHmethod(S,"hybrid")
optimize_init_trace_params(S,"on")
optimize_init_conv_maxiter(S,30)
p = optimize(S)

end

replace readfallk=readfallk*180
replace readspring3 = readspring3*180



