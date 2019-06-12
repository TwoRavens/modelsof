clear all
cd U:/FEC/AJPS
use "U:/FEC/Tables1_4.dta"


*******************Treatment Effects*******************

g Treatment1= 1 if TotAds>=1000
	replace Treatment1=0 if TotAds<1000
	replace Treatment1=. if missing(TotAds)	


gen Contributions=Cont*1000

gen com=AmountRComm+AmountDComm
gen cand=AmountRCand+AmountDCand
mean com, over(NonComp)
mean cand, over(NonComp)
su com cand
des com cand

estpost tabstat com cand , by(NonComp) statistics(mean sd count) columns(statistics)
eststo b1
esttab b1 using tables1.csv, cells("mean(fmt(4))" "sd(fmt(4)par)"  "count(fmt(0))")  noobs nonumbers unstack label legend replace
esttab b1 using tables1.tex, cells("mean(fmt(4))" "sd(fmt(4)par)"  "count(fmt(0))")  noobs nonumbers unstack label legend replace 


su  Contributions , det
des Contributions

estpost tabstat Contributions , by(NonComp) statistics(mean sd count) columns(statistics)
eststo b1
esttab b1 using tables2.csv, cells("mean(fmt(4))" "sd(fmt(4)par)"  "count(fmt(0))")  noobs nonumbers unstack label legend replace
esttab b1 using tables2.tex, cells("mean(fmt(4))" "sd(fmt(4)par)"  "count(fmt(0))")  noobs nonumbers unstack label legend replace 
su Contributions if NonComp==1, det
su Contributions if NonComp==0, det
su Contributions, det


	
forvalues i==1(1)56{
g StFIPS`i'=.
replace StFIPS`i'=1 if StFIPS==`i'
replace StFIPS`i'=0 if StFIPS!=`i'
}	

drop if NonComp==0
drop if TotalPop==0
gen state=trim(State)
bysort DMAName: egen Overlap=nvals(StFIPS)

g PerCapitaGiving=amount/Pop
label variable PerCapitaGiving "Amount Given Per Person"

g PerCapitaGivingThous=amount/TotalPop
label variable PerCapitaGiving "Amount Given Per Thousand People"

g PercentVoted=(TotVote/1000)/TotalPop

gen lnperout=ln(perout+1)
gen CanCommute=1 if perout>5
replace CanCommute=0 if perout<=5
g logDollars=ln(Cont+.001)

xtset StFIPS
xtlogit Treatment1 Inc PercentHispanic PercentBlack density per_collegegrads, fe or
predict PropScore1, pu0  

esttab using "U:\FEC\Tables\Dec2AppendixLogit.tex", se r2 star(* 0.10 ** 0.05 *** 0.01) replace

 psmatch2 Treatment1, outcome(Cont) neighbor(20) pscore(PropScore1) common
/*

        egen g = group(StFIPS)
        levelsof g, local(g)
        foreach j of g2 {
                psmatch2 Treatment1, outcome(Cont) neighbor(20) pscore(PropScore1) common
                replace att = r(att) if  g2==`j'
        }
        sum att
*/
psmatch2 Treatment1 , llr outcome(Cont) kerneltype(epan) pscore(PropScore1) bwidth(.04182925)
		pstest Treatment1 Inc PercentHispanic Pop PercentBlack density  per_hsgrads per_collegegrads CanCommute 
		/*g att = .*/
		
 g att = .
 g SE=.
        egen g = group(State)
		destring g, replace
        levelsof g, local(gr)
        forvalues j==1(1)35 {
				psmatch2 Treatment1 if `j'==g, llr outcome(Cont) kerneltype(epan) pscore(PropScore1) bwidth(.04182925)
				replace att = r(att) if  `j'==g
                replace SE =  r(seatt) if `j'==g
}
        sum att if Treatment1==1
		cumul(att), generate(CDFATT)
		
		g TopHalfATT=.
		replace TopHalfATT=1 if CDFATT>.5&Treatment1==1
		replace TopHalfATT=0 if CDFATT<.5&Treatment1==1
		
		g TopQuarterATT=.
		replace TopQuarterATT=1 if CDFATT>.75&Treatment1==1
		replace TopQuarterATT=0 if CDFATT<.75&Treatment1==1
		
		g TopTenATT=.
		replace TopTenATT=1 if CDFATT>.90&Treatment1==1
		replace TopTenATT=0 if CDFATT<.90&Treatment1==1

		psmatch2 Treatment1 , outcome(Cont) pscore(PropScore1) kernel kerneltype(epan) bwidth(.04182925) common
				
		
g attKernel = .		
g SEKernel=.
		forvalues j==1(1)35 {
                psmatch2 Treatment1 if `j'==g, outcome(Cont) pscore(PropScore1) kernel kerneltype(epan) bwidth(.04182925) common
				replace attKernel = r(att) if  `j'==g
                replace SEKernel =  r(seatt) if `j'==g
        }
		
		sum attKernel if Treatment1==1, det
		cumul(attKernel), generate(CDFATTKernel)
		
		g TopHalfATTK=.
		replace TopHalfATTK=1 if CDFATTK>.5&Treatment1==1
		replace TopHalfATTK=0 if CDFATTK<.5&Treatment1==1
		
		g TopQuarterATTK=.
		replace TopQuarterATTK=1 if CDFATTK>.75&Treatment1==1
		replace TopQuarterATTK=0 if CDFATTK<.75&Treatment1==1
		
		g TopTenATTK=.
		replace TopTenATTK=1 if CDFATTK>.90&Treatment1==1
		replace TopTenATTK=0 if CDFATTK<.90&Treatment1==1
		
		
**Nearest one Neighbor Matching
psmatch2 Treatment1, outcome(Cont) neighbor(20) caliper (.0001) pscore(PropScore1)  common
pstest Treatment1 Inc PercentHispanic Pop PercentBlack density  per_hsgrads per_collegegrads StFIPS1-StFIPS56


psmatch2 Treatment1, outcome(Cont) neighbor(5) pscore(PropScore1)  common
pstest Treatment1 Inc PercentHispanic Pop PercentBlack density  per_hsgrads per_collegegrads
psmatch2 Treatment1, outcome(Cont) neighbor(10) pscore(PropScore1)  common
pstest Treatment1 Inc PercentHispanic Pop PercentBlack density  per_hsgrads per_collegegrads 
psmatch2 Treatment1, outcome(Cont) neighbor(1) pscore(PropScore1)  common
pstest Treatment1 Inc PercentHispanic Pop PercentBlack density  per_hsgrads per_collegegrads 


***Caliper Matching, one closest match
psmatch2 Treatment1, outcome(Cont) pscore(PropScore1) cal(.01) common
pstest Treatment1 Inc Pop PercentHispanic PercentBlack density  per_collegegrads
g Difference=Cont-_Cont if Treatment==1
mean Difference
su Difference, detail


psmatch2 Treatment1, outcome(Cont) pscore(PropScore1) cal(.001) common
pstest Treatment1 Inc Pop PercentHispanic PercentBlack density  per_collegegrads
psmatch2 Treatment1, outcome(Cont) pscore(PropScore1) cal(.0001) common
pstest Treatment1 Inc Pop PercentHispanic PercentBlack density  per_collegegrads



drop Difference
psmatch2 Treatment1, outcome(Cont) pscore(PropScore1)  cal(.001) common
pstest Treatment1 Inc Pop PercentHispanic PercentBlack density  per_collegegrads
g Difference=Cont-_Cont
reg Cont _Cont
cumul(Difference), generate(CDFDiff)


******Kernel Matching
psmatch2 Treatment1, outcome(Cont) pscore(PropScore1) kernel kerneltype(epan) bwidth(.04182925) common
pstest Treatment1 Inc Pop PercentHispanic PercentBlack density  per_collegegrads
g D=Cont-_Cont if Treatment==1
cumul(D), generate(CDFD)
tab DMAName if CDFD>.95 &CDFD!=.

g TopD=.
replace TopD=1 if CDF>.90&CDFD!=.
replace TopD=0 if CDF<0.9&CDFD!=.


psmatch2 Treatment1, outcome(Cont) pscore(PropScore1) kernel kerneltype(normal) bwidth(.04182925) common
pstest Treatment1 Inc Pop PercentHispanic PercentBlack density  per_collegegrads
bs "psmatch2 Treatment1, outcome(Cont) pscore(PropScore1) kernel kerneltype(normal) bwidth(.04182925) common" "r(att)"

*****LLR MAtching

psmatch2 Treatment1, llr outcome(Cont) kerneltype(epan) pscore(PropScore1) bwidth(.04182925)
pstest Treatment1 Inc Pop PercentHispanic PercentBlack density  per_collegegrads



******ROBUSTNESSS***************

g attNN10 = .
 g SENN10=.
        forvalues j==1(1)35 {
                psmatch2 Treatment1 if `j'==g, outcome(Cont) neighbor(10) pscore(PropScore1) common
				replace attNN10 = r(att) if  `j'==g
                replace SENN10 =  r(seatt) if `j'==g
        }
		
g attNN1 = .
 g SENN1=.
       
        forvalues j==1(1)35 {
                psmatch2 Treatment1 if `j'==g, outcome(Cont) neighbor(1) pscore(PropScore1) common
				replace attNN1 = r(att) if  `j'==g
                replace SENN1 =  r(seatt) if `j'==g
        }
		
g attKN = .
 g SEKN=.
 
                forvalues j==1(1)35 {
                psmatch2 Treatment1 if  `j'==g, outcome(Cont) pscore(PropScore1) kernel kerneltype(normal) bwidth(.04182925) common
				replace attKN = r(att) if  `j'==g
                replace SEKN =  r(seatt) if `j'==g
        }

g attLLR = .
 g SELLR=.
     
        forvalues j==1(1)35 {
                psmatch2 Treatment1 if  `j'==g, llr outcome(Cont) kerneltype(epan) pscore(PropScore1) bwidth(.04182925)
				replace attLLR = r(att) if  `j'==g
                replace SELLR =  r(seatt) if `j'==g
        }

g attRC = .
 g SERC=.
     
        forvalues j==1(1)35 {
               psmatch2 Treatment1 if `j'==g, outcome(Cont) pscore(PropScore1) cal(.01) common
				replace attRC = r(att) if  `j'==g
                replace SERC =  r(seatt) if `j'==g
        }

	g attRC001 = .
 g SERC001=.
     
        forvalues j==1(1)35 {
               psmatch2 Treatment1 if `j'==g, outcome(Cont) pscore(PropScore1) cal(.001) common
				replace attRC001 = r(att) if  `j'==g
                replace SERC001 =  r(seatt) if `j'==g
        }

	g attRC0001 = .
 g SERC0001=.
     
        forvalues j==1(1)35 {
               psmatch2 Treatment1 if `j'==g, outcome(Cont) pscore(PropScore1) cal(.0001) common
				replace attRC0001 = r(att) if  `j'==g
                replace SERC0001 =  r(seatt) if `j'==g
        }
		
		
		
		 forvalues j==11(1)35 {
                psmatch2 Treatment1 if `j'==g, outcome(Cont) neighbor(20) pscore(PropScore1) common
				replace att = r(att) if  `j'==g
                replace SE =  r(seatt) if `j'==g
pstest Treatment1 Inc PercentHispanic Pop PercentBlack density  per_hsgrads per_collegegrads 
        }

		

		cumul(TotAds), gen(cut)
		cumul(Treat), gen(cut1)
		
gpscore Inc PercentHispanic PercentBlack density per_collegegrads Pop , t(TotAds) gpscore(mygps) predict(hat_treat) sigma(hat_sd) cutpoints(cut) index(p25) nq_gps(4) 

doseresponse  Inc PercentHispanic PercentBlack density per_collegegrads Pop StFIPS1-StFIPS55,outcome(Cont) t(Treat) gpscore(mygps1) predict(hat_treat1) sigma(hat_sd1) cutpoints(cut1) index(p33) nq_gps(3) dose_response(mydoseresponse) 

