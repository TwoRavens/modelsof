********************************************************************************
* Replication code for 
*Dafoe, Allan and Nina Kelsey. Forthcoming. Observing the Capitalist Peace: Examining Market-Mediated Signaling and Other Mechanisms. The Journal of Peace Research. 
* Contact the authors at allan.dafoe@yale.edu if you have any questions.
********************************************************************************

**Preparing dataset
clear
cd "/Users/Allan/Dropbox/!!Papers/Liberal Peace/Nina Gartzke paper/2013-20/ReplicationFiles"
*Change this to the directory with our replication files. 

log using "Output/log_observing_do", replace

set mem 1g
use "Original Files/capitalistpeace_012007.dta"
gen orig=1
**This datafile was downloaded from Erik Gartzke's website: http://dss.ucsd.edu/~egartzke/data/capitalistpeace_012007.dta

sort statea stateb year

merge statea stateb year using "Original Files/COW MID.dta"

rename _merge merge1


kountry statea, from(cown) to(cowc)
rename _COWC_ stateabb_a

kountry statea, from(cown) 
rename NAMES_STD statename_a

kountry stateb, from(cown) to (cowc)
rename _COWC_ stateabb_b

kountry stateb, from(cown) 
rename NAMES_STD statename_b

sort stateabb_a stateabb_b year

*From Weeks and Cohen's "Red Herrings" paper
merge stateabb_a stateabb_b year using "Original Files/fishingdisputes.dta"


*Correcting dataset by shifting Gartzke's capopenl and capopenh one year forward.
sort dyadid year
by dyadid: gen capopenl2=capopenl[_n-1]



gen fatalmax=max(cwfatal1, cwfatal2) if cwfatal1~=. & cwfatal2~=.

*Datasets combined, now analyze
*excluded fishing disputes and non bilateral disputes
**FATAL MIDS, High Capopenl

order stateabb_a stateabb_b year capopenl capopenl2 capopenh fdecision cwfatald fatalmax cwfatal1 cwfatal2 cwhiact1 cwhiact2 cwnumst1 cwnumst2
gsort   -capopenl2 -cwfatald


tab capopenl2 maoznewl, ro
tab capopenl2 deadlyl, ro

**fix drop definition so it is precise
gen drop=0
bysort dyadid: replace drop=1 if fdecision[_n-1]=="Drop" | fdecision[_n]=="Drop" | fdecision[_n+1]=="Drop"


save "Output/temp", replace



**Creating Figure 1**
**Using a 3 order polynomial because it is smoother
*To implement 3 order polynomial, estimate model, extract SEs, then calculate CI. 

gen capopenlp2=capopenl^2
gen capopenlp3=capopenl^3



logit maoznewl  capopenl capopenlp2 capopenlp3 demlo demhi deplo rgdppclo gdpcontg sun2cati contig logdstab majpdyds allies lncaprt namerica samerica europe africa nafmeast asia if drop==0, cluster(dyadid) 

matrix b=e(b)
matrix V=e(V)


*marginal effect is:
gen capB5=_b[capopenl]*capopenl+(_b[capopenlp2])*capopenl^2+(_b[capopenlp3])*capopenl^3

gen capse5=sqrt(V[1,1]+(2*capopenl)^2*V[2,2]+9*capopenl^4*V[3,3]+4*capopenl*V[1,2]+6*capopenl^2*V[1,3]+12*capopenl^3*V[2,3])

*gen conse=sqrt(V[1,1]+(2*MV)^2 * V[2,2] + (3*MV^2)^2 * V[3,3] + 2 * ( 2 * MV * V[1,2] + 3*MV^2 *V[1,3] + 2*MV*3*MV^2 * V[2,3])) 


logit deadlyl  capopenl capopenlp2 capopenlp3 demlo demhi deplo rgdppclo gdpcontg sun2cati contig logdstab majpdyds allies lncaprt namerica samerica europe africa nafmeast asia if drop==0, cluster(dyadid) 

matrix b2=e(b)
matrix V2=e(V)


*marginal effect is:
gen capB9=_b[capopenl]*capopenl+(_b[capopenlp2])*capopenl^2+(_b[capopenlp3])*capopenl^3

gen capse9=sqrt(V2[1,1]+(2*capopenl)^2*V2[2,2]+9*capopenl^4*V2[3,3]+4*capopenl*V2[1,2]+6*capopenl^2*V2[1,3]+12*capopenl^3*V2[2,3])


*bysort capopenl: egen mpr5c = mean(pr5c)
bysort capopenl: egen mprop5 = mean(maoznewl) if drop==0
tab mprop5 capopenl 
*bysort capopenl: egen mpr9c = mean(pr9c)
bysort capopenl: egen mprop9 = mean(deadlyl) if drop==0
tab mprop9 capopenl 

sum mprop5 if capopenl==0
gen mprop5c0= r(mean)

sum mprop9 if capopenl==0
gen mprop9c0= r(mean)


bysort capopenl: gen firstn=1 if _n==1
*above line is to simplify computation
*line mpr5c capopenl if firstn==1
*line mpr9c capopenl if firstn==1
sort capopenl

order capopenl mprop5 mprop9  capB* capse* firstn stateabb* year
*browse if firstn==1

*value of XB is -ln((1-p)/p), where p is the estimated probability

*_n==0 refers to first observation, which is proportion for capopenl==0
sort capopenl
gen XB5=-ln((1-mprop5c0)/mprop5c0)+capB5 
gen XB9=-ln((1-mprop9c0)/mprop9c0)+capB9
*the capB# adds the coefficient for the relevant capital openness dummy. 

*gen XB5H=-ln((1-mpr5c)/mpr5c)+1.96*capse5
*gen XB5L=-ln((1-mpr5c)/mpr5c)-1.96*capse5
gen XB5H=XB5+1.96*capse5 if firstn==1
gen XB5L=XB5-1.96*capse5 if firstn==1

*gen XB9H=-ln((1-mpr9c)/mpr9c)+1.96*capse9
*gen XB9L=-ln((1-mpr9c)/mpr9c)-1.96*capse9
gen XB9H=XB9+1.96*capse9 if firstn==1
gen XB9L=XB9-1.96*capse9 if firstn==1

*Generating calculated probability (pr5ce means probability from model 5 calculated estimated using changes in capopenl, not that derived from the model).
gen pr5ce=1/(1+exp(-XB5)) if firstn==1
gen pr5ch=1/(1+exp(-XB5H)) if firstn==1
gen pr5cl=1/(1+exp(-XB5L)) if firstn==1
gen pr9ce=1/(1+exp(-XB9)) if firstn==1
gen pr9ch=1/(1+exp(-XB9H)) if firstn==1
gen pr9cl=1/(1+exp(-XB9L)) if firstn==1

*order capopenl mprop5* mprop9* pr* XB* firstn
order capopenl mprop5 pr5ce pr5ch pr5cl mprop9 pr9ce pr9ch pr9cl
*browse if firstn==1

list capopenl mprop5 mprop9 pr* if firstn==1
*browse capopenl mpr5c* mpr9c* if firstn==1
outsheet capopenl mprop5 pr5ce pr5ch pr5cl mprop9 pr9ce pr9ch pr9cl  if firstn==1 & capopenl~=. using "Output/11-07-14predicted.csv", comma replace




***Selecting Cases
*clear
*cd "/Users/Allan/Dropbox/!!Papers/Liberal Peace/Nina Gartzke paper/2013-20/ReplicationFiles"
*use "Output/temp"

gen rule1=.
order stateabb_a stateabb_b year capopenl capopenl2 capopenh fatalmax cwfatald cwfatal1 cwfatal2
gsort -cwfatald -capopenl2
browse if capopenl2~=. & fatalmax~=.  & capopenl2>3
replace rule1=1 if capopenl2>3 & capopenl2~=. & fatalmax>2 & fatalmax~=.


gen rule2=.
gsort -capopenl2 stateabb_a stateabb_b year
browse if capopenl2~=. & cwfatald==0 
replace rule2=1 if capopenl2==8 & capopenl2~=. & cwfatald==0 





**Calculating Rule3 (prMID)

** The following analyses produce the case selection and tables displayed in the Online Appendix, page 3.
** These analyses were performed in 2010, before we were aware of the value of producing high quality replication files. 
** These replication files were produced in 2013. 
** The following code approximately reproduces, but not exactly, our 2010 analyses reported in the Online Appendix
** used to implement Rule 3.


gen rule3=.
*Table 1, Model 5:  adding Interests 
logit maoznewl demlo demhi deplo capopenl rgdppclo gdpcontg sun2cati contig logdstab majpdyds allies lncaprt _spline*, cluster(dyadid) 
*demonstrating that we nearly get the same results as Gartzke 2007 when restricting to his dataset, slight difference probably because of 12 additional observations 

*using Model 5 without temporal controls to avoid selection bias into situations where capital openness is broken

logit maoznewl demlo demhi deplo capopenl rgdppclo gdpcontg sun2cati contig logdstab majpdyds allies lncaprt namerica samerica europe africa nafmeast asia, cluster(dyadid) 
predict pr5
predict inMID, dx2

order capopenl pr5
gsort -pr5 -capopenl
order inMID pr5 capopenl capopenl2 stateabb_a stateabb_b year
browse if capopenl==8


*Table 2, Model 9:  adding Fin.Open.(Low), GDPPC(Low) and GDPPC x Contig. 
logit deadlyl demlo demhi deplo capopenl rgdppclo gdpcontg contig logdstab majpdyds allies lncaprt namerica samerica europe africa nafmeast asia, cluster(dyadid) 
predict pr9
predict infMID, dx2

order capopenl pr9
sort capopenl pr9
sort pr9
order pr9 capopenl stateabb_a stateabb_b year
*browse if pr9~=. & capopenl>5

logit deadlyl demlo demhi deplo capopenl rgdppclo gdpcontg contig logdstab majpdyds allies lncaprt, cluster(dyadid) 
predict pr92

order capopenl pr92
sort capopenl pr92
sort pr92
*browse if pr92~=. & capopenl>5

*Table 2, Model 7:  adding Fin.Open.(Low), GDPPC(Low) and GDPPC x Contig. 
logit warl demlo demhi deplo capopenl rgdppclo gdpcontg contig logdstab majpdyds allies lncaprt namerica samerica europe africa nafmeast asia, cluster(dyadid) 
predict pr7
predict inWAR, dx2

order pr7
sort  pr7
*browse if pr7~=. & capopenl>6
order pr5 pr9 pr7
gsort -pr5
gsort fatalmax -pr5
gen rankM=.
by fatalmax: replace rankM=_n if fatalmax==.
order fatalmax rankM

gsort fatalmax -pr9
gen rankF=.
by fatalmax: replace rankF=_n if fatalmax==.
order fatalmax rankM rankF

gen rankC=rankM+rankF
gsort rankC -capopenl2
order fatalmax rankM rankF rankC capopenl2 stateabb* year inWAR infMID inMID

replace rule3=1 if rankC<5100 & capopenl2==8 & statename_b~="Haiti" 

*selection rule is for those two dyads that are prevelant in the top 20 dyad-years selected by low rank for given capopenl2 level 
replace rule3=1 if rankC<4300 & capopenl2==7 & statename_b~="Mexico" & statename_a~="Kuwait" & statename_b~="Yemen Arab Republic" & statename_b~="Nicaragua"

*browse if capopenl2==6
gen priority=1 if rule1==1 
replace priority=2 if rule2==1
replace priority=3 if rule3==1
sort priority

order rule1 rule2 rule3 stateabb_a stateabb_b year fatalmax capopenl2 capopenh rankC rankM rankF pr5 pr7 pr9
keep rule1 rule2 rule3 stateabb_a stateabb_b year fatalmax capopenl2 capopenh rankC rankM rankF pr5 pr7 pr9

outsheet using "Output/10.07.21 cases.csv" if rule1==1 | rule2==1 | rule3==1, comma replace

log close