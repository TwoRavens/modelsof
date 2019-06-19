/*This program chooses monotonically increasing parameter values to form a
new set of test scores which maximizes or minimizes the growth of the black-white
test gap over the first four years of education*/

clear mata
clear matrix
clear
set more off
set mem 300m
set matsize 800
/*choose data directory*/
cd "C:\Users\bond10\Desktop\RA\Test Scores\Paper\replication files"
use CNLSYbondlang.dta, clear


keep if (grade==0|grade==3) & PIATreadcomraw!=.

mata
mata clear

st_view(race=.,.,("black"))
st_view(piat=.,.,("PIATreadcomraw"))
st_view(grade=.,.,("grade"))

/*This divides test scores into a vector of third graders and a vector
of kindergartners*/

totalkind=0
totalthird=0

for (i=1; i<=rows(grade); i++)      {
       if (grade[i]<=0) totalkind = totalkind + 1
	   if (grade[i]>=1) totalthird = totalthird + 1
	                                    }

	   kind = J(totalkind,1,0)
	   krace = J(totalkind,1,0)
	   third = J(totalthird,1,0)
	   thrace = J(totalthird,1,0)

currentkind=1
currentthird=1


for (i=1; i<=rows(piat); i++)          {
       if (grade[i]<=0) kind[currentkind]=piat[i]
	   if (grade[i]<=0) krace[currentkind]=race[i]
	   if (grade[i]<=0) currentkind = currentkind+1
	   if (grade[i]>=1) third[currentthird]=piat[i]
	   if (grade[i]>=1) thrace[currentthird]=race[i]
	   if (grade[i]>=1) currentthird= currentthird+1
	                      }

void eval1(todo, p, krace, thrace, kind, third, gapgrowth, S, H)
{

	real vector skind
	real vector sthird
	real vector qt 
	real vector q 
	real vector qtone
	real vector qttwo
	real vector pone
	real vector ptwo
	real vector r
	real scalar i 
	real scalar j
	real scalar svk
	real scalar smk
	real scalar smt
	real scalar smbk
	real scalar smwk
	real scalar smwt
	real scalar svt
	real scalar smbt
	real scalar sbk
	real scalar swk
	real scalar sbt
	real scalar swt
	real scalar gapk
	real scalar gapt

	skind = J(rows(kind),1,0)
	
	sthird = J(rows(third),1,0)
	
/*normalize 20 and 21 -- lowest scores with both black and white at both grades*/
	
	r=p
	
	pone = J(1,20,0)
	ptwo = J(1,52,0)
	
	for (i=1; i<=20; i++)  {
	pone[i] = r[i]
	              }
	pone = 20:-runningsum(pone:*pone)
	
	qtone=J(1,20,0)
	
	for (i=1; i<=20; i++)  {
	qtone[i]=pone[21-i]
	                  }
	for (i=1; i<=52; i++)  {
	ptwo[i] = r[20+i]
  }
//	qttwo = runningsum(ptwo:*ptwo):+20.000000001 /*comment out for max*/
	qttwo = runningsum(ptwo:*ptwo):+21 /*comment out for min*/
	
	

//	q = (qtone, 20, 20.000000001, qttwo) /*comment out for max*/
	q = (qtone, 20, 21, qttwo) /*oomment out for min*/

	for (i=1; i<=rows(kind); i++) {
		j = kind[i]+1
		skind[i]= q[j]
		}
		
	for (i=1; i<=rows(third); i++)  {
	    j=third[i]+1
		if (j<=70) sthird[i]=q[j]
		if (j==72) sthird[i]=q[71]
		if (j==77) sthird[i]=q[72]
		if (j==79) sthird[i]=q[73]
		if (j==82) sthird[i]=q[74]
	    }
		
/*Kindergarten gap*/
	   smk = mean(skind)
	   svk = variance(skind)
	   sbk = skind:*krace
	   swk = skind:*(1:-krace)
	   smbk = mean(sbk)*rows(kind)/sum(krace)
	   smwk = mean(swk)*rows(kind)/sum(1:-krace)
	   gapk = (smwk - smbk)/(svk^.5)
/*Third Grade gap*/
	   smt = mean(sthird)
	   svt = variance(sthird)
	   sbt = sthird:*thrace
	   swt = sthird:*(1:-thrace)
	   smbt = mean(sbt)*rows(third)/sum(thrace)
	   smwt = mean(swt)*rows(third)/sum(1:-thrace)
	   gapt = (smwt - smbt)/(svt^.5)
 
	   
	   gapgrowth = (gapt-gapk)
	   

	}

S=optimize_init()
optimize_init_evaluator(S, &eval1())
/*max or min*/optimize_init_which(S, "max")
optimize_init_evaluatortype(S,"v0")
/*max params*/
optimize_init_params(S,(-0.000014,9.21E-07,2.09E-06,2.02E-06,-0.0000127,0.0000173,8.92E-06,7.57E-06,0.0000194,-7.83E-08,0.000019,0.0000153,0.0000183,-9.99E-06,4.15E-06,0.0000148,9.05E-06,2.81E-06,-602.1643,0.0000357,1.44E-06,-0.0000174,-0.0015683,-0.0000198,-0.0000247,-0.0001557,-0.0000136,0.0001929,85.33652,114.5859,0.0029625,-0.008584,-0.236461,0.0009196,-0.0003152,106.2285,66.91647,-0.1191813,59.15557,59.02026,1.997891,-0.7287101,138.0792,2.183553,-0.0014379,27.40182,66.4903,23.6936,-0.0002214,-0.0002554,-0.0000563,-0.0440697,-0.0007198,3.30E-06,-0.0225837,60.64724,-0.0000941,-0.0000232,69.14789,0.0000217,-0.0005507,1.82E-06,-0.0007539,3.767011,0.0001715,4.234463,0.0000797,170.0415,30.59504,-0.1279303,-0.2773463,-0.1204581))
/*min params*/
//optimize_init_params(S,(-0.0000474,492.2914,-0.0164457,405.0533,-0.0004923,480.482,0.0004774,268.4127,-0.0000188,-3.790892,-571.2755,291.6694,0.0006099,-0.000079,5.50E-07,907.5368,0.0824099,-938.3521,-0.0006764,0.0003017,0.0000329,-5.07E-06,5.91E-07,-2.17E-06,-1.97E-06,0.0000549,-9.77E-06,7.30E-06,-5.67E-06,-4.73E-06,-2.80E-06,-2.47E-07,4.22E-06,-3.34E-06,2.58E-06,0.0000114,3.10E-06,-0.000015,5.14E-06,4.59E-06,4.49E-06,5.18E-06,-0.0000157,-1.12E-06,-1.08E-06,-7.39E-06,0.0000116,4.46E-07,0.0001531,0.0000127,8.54E-07,-0.0000147,-2.56E-06,0.0000321,0.0000205,0.0000209,3.97E-06,0.0000133,0.0000261,9.05E-06,0.0000398,0.0000423,0.0000194,0.00001,0.0000274,0.0000398,0.0000965,-0.0000115,0.000031,0.0000328,0.0000506,0.0002295))
optimize_init_argument(S,1,krace)
optimize_init_argument(S,2,thrace)
optimize_init_argument(S,3,kind)
optimize_init_argument(S,4,third)
optimize_init_conv_ptol(S,.00001)
optimize_init_conv_vtol(S,.00001)
optimize_init_conv_nrtol(S,.00001)
optimize_init_trace_tol(S,"on")
p = optimize(S)

end

