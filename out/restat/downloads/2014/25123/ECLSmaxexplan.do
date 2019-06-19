/*This program is designed to choose a smooth, monotonic transformation of the
ECLS-K test scores so as to minimize the change in the test score gap as a proprotion of the
variance in the test score  (weights are used via weighted least squares)*/


clear all

set mem 400m
set more off
/*Choose directory here*/
cd "C:\Users\bond10\Desktop\RA\Test Scores\Paper\replication files"
use ECLSbondlang.dta, clear

/*Normal scores to be between 0 and 1 to make program run easier*/
replace readspring3 = readspring3/180
replace readfallk = readfallk/180

mata

st_view(race=.,.,("black hispanic asian other"))
st_view(w=.,.,("weights"))
st_view(tk=.,.,("readfallk"))
st_view(tt=.,.,("readspring3"))
st_view(controlsk=.,.,("ses books wic female birthweight missingbirthweight teenmom momover30 missingmombirth missingbooks missingwic books2 agefallk missingses"))
st_view(controlst=.,.,("ses books wic female birthweight missingbirthweight teenmom momover30 missingmombirth missingbooks missingwic books2 agespring3 missingses"))

void eval1(todo, p, race, w, tk, tt, controlsk, controlst, explained, g, H)
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
	   real scalar cgapk
	   real scalar cgapt
	   real scalar gapgrowth
	   real scalar cgapgrowth
	   real scalar i
	   
	   
	     r = p
		 
/*Col 1-2 Transformation*/		 m=1.65087720125322E-19
///*Col 3-4 Transformation*/       m=	2.55881980375649	 
		 
   	   stk= m:*(tk:+r[6]) + r[1]:*(tk:+r[6]):^2 + r[2]:*(tk:+r[6]):^3 + r[3]:*(tk:+r[6]):^4 + r[4]:*(tk:+r[6]):^5 + r[5]:*(tk:+r[6]):^6
	   stt= m:*(tt:+r[6]) + r[1]:*(tt:+r[6]):^2 + r[2]:*(tt:+r[6]):^3 + r[3]:*(tt:+r[6]):^4 + r[4]:*(tt:+r[6]):^5 + r[5]:*(tt:+r[6]):^6

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

gapk = -bk[1]
gapt = -bt[1]

gapgrowth = gapt-gapk

/*weighted OLS*/	   
	   X = (race, controlsk)
	   X = X,J(rows(X),1,1)
	   bk = invsym(cross(X,w,X))*cross(X,w,stk)
	   
	   X= (race, controlst)
	   X = X,J(rows(X),1,1)
	   bt = invsym(cross(X,w,X))*cross(X,w,stt)
	   
/*pull gaps from betas*/
cgapk = -bk[1]
cgapt = -bt[1]

	   
cgapgrowth = cgapt-cgapk
	   
scores = J(1,round(180*(max(tt))) + 1,0)

	   
for (i=1; i<=cols(scores); i++)    {
	        scores[i]=min(tk) + i -1
			                       }

scores = scores:/180
scores = m:*(scores:+r[6]) + r[1]:*(scores:+r[6]):^2 + r[2]:*(scores:+r[6]):^3 + r[3]:*(scores:+r[6]):^4 + r[4]:*(scores:+r[6]):^5 + r[5]:*(scores:+r[6]):^6
/*penalties*/

/*Column 1-2 Transformation*/ explained = 1 - (cgapgrowth/gapgrowth)
///*Column 3-4 Transformation*/ explained = gapgrowth - cgapgrowth


	for (i=2; i<=cols(scores); i++)   {
 if (scores[i]-scores[i-1]<0) explained = explained - 1
                    }
					
 
					   }
S=optimize_init()
optimize_init_evaluator(S, &eval1())
optimize_init_which(S, "max")
/*Column 1-2 Transformation*/ optimize_init_params(S,(9.94691483930691,-26.4577999746567,-9.81183841582317,26.2783331141084,82.9402686962257,0.119479))
///*Column 3-4 Transformation*/ optimize_init_params(S,(10.8705267018669,-47.4535179662484,-4.38830943412748,102.957466858085,12.5181405382265,0.1450721))
optimize_init_argument(S,1,race)
optimize_init_argument(S,2,w)
optimize_init_argument(S,3,tk)
optimize_init_argument(S,4,tt)
optimize_init_argument(S,5,controlsk)
optimize_init_argument(S,6,controlst)
optimize_init_singularHmethod(S,"hybrid")
optimize_init_trace_params(S,"on")
optimize_init_conv_maxiter(S,30)
p = optimize(S)

end

replace readspring3 = readspring3
replace readfallk = readfallk
