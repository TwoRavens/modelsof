/*This code produces the test gaps in the PIAT for the growth maximizing
transformation(Column 2 of Table 3)*/


clear mata
clear matrix
clear
set more off
set mem 300m
set matsize 800
/*choose data directory*/
cd "C:\Users\bond10\Desktop\RA\Test Scores\Paper\replication files"
use CNLSYbondlang.dta, clear

keep if grade==0 & PIATreadcomraw!=.


sum black PPVTraw
mata
mata clear

p = (-0.000014,9.21E-07,2.09E-06,2.02E-06,-0.0000127,0.0000173,8.92E-06,7.57E-06,0.0000194,-7.83E-08,0.000019,0.0000153,0.0000183,-9.99E-06,4.15E-06,0.0000148,9.05E-06,2.81E-06,-602.1643,0.0000357,1.44E-06,-0.0000174,-0.0015683,-0.0000198,-0.0000247,-0.0001557,-0.0000136,0.0001929,85.33652,114.5859,0.0029625,-0.008584,-0.236461,0.0009196,-0.0003152,106.2285,66.91647,-0.1191813,59.15557,59.02026,1.997891,-0.7287101,138.0792,2.183553,-0.0014379,27.40182,66.4903,23.6936,-0.0002214,-0.0002554,-0.0000563,-0.0440697,-0.0007198,3.30E-06,-0.0225837,60.64724,-0.0000941,-0.0000232,69.14789,0.0000217,-0.0005507,1.82E-06,-0.0007539,3.767011,0.0001715,4.234463,0.0000797,170.0415,30.59504,-0.1279303,-0.2773463,-0.1204581)


st_view(black=.,.,("black"))
st_view(third=.,.,("PIATreadcomraw"))


sthird = J(rows(third),1,0)

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
	qttwo = runningsum(ptwo:*ptwo):+21
	
	
//	tmp = qt[81]

	q = (qtone, 20, 21, qttwo)
	
		for (i=1; i<=rows(third); i++)  {
	    j=third[i]+1
		if (j<=70) sthird[i]=q[j]
		if (j==72) sthird[i]=q[71]
		if (j==77) sthird[i]=q[72]
		if (j==79) sthird[i]=q[73]
		if (j==82) sthird[i]=q[74]
	    }
		
		
	   smt = mean(sthird)
	   svt = variance(sthird)
	   
sthird = (sthird:-smt):/svt^.5

ones = J(rows(sthird),1,1)
X = black, ones

b = invsym(X'X)*X'sthird

uhat = sthird:-X*b
sandwich = J(2,2,0)
for (i=1; i<=rows(uhat); i++) {
    sandwich = sandwich:+ uhat[i]:^2*X[i,.]'X[i,.]
	    }

sigma = invsym(X'X)*sandwich*invsym(X'X)

b[1,1]

sqrt(sigma[1,1])

end


clear mata
clear matrix
clear
set more off
set mem 300m
set matsize 800
/*choose data directory*/
cd "C:\Users\bond10\Desktop\RA\Test Scores\Paper\replication files"
use CNLSYbondlang.dta, clear

*
keep if grade==1 & PIATreadcomraw!=.

mata
mata clear

p = (-0.000014,9.21E-07,2.09E-06,2.02E-06,-0.0000127,0.0000173,8.92E-06,7.57E-06,0.0000194,-7.83E-08,0.000019,0.0000153,0.0000183,-9.99E-06,4.15E-06,0.0000148,9.05E-06,2.81E-06,-602.1643,0.0000357,1.44E-06,-0.0000174,-0.0015683,-0.0000198,-0.0000247,-0.0001557,-0.0000136,0.0001929,85.33652,114.5859,0.0029625,-0.008584,-0.236461,0.0009196,-0.0003152,106.2285,66.91647,-0.1191813,59.15557,59.02026,1.997891,-0.7287101,138.0792,2.183553,-0.0014379,27.40182,66.4903,23.6936,-0.0002214,-0.0002554,-0.0000563,-0.0440697,-0.0007198,3.30E-06,-0.0225837,60.64724,-0.0000941,-0.0000232,69.14789,0.0000217,-0.0005507,1.82E-06,-0.0007539,3.767011,0.0001715,4.234463,0.0000797,170.0415,30.59504,-0.1279303,-0.2773463,-0.1204581)



st_view(black=.,.,("black"))
st_view(third=.,.,("PIATreadcomraw"))


sthird = J(rows(third),1,0)

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
	qttwo = runningsum(ptwo:*ptwo):+21
	
	
//	tmp = qt[81]

	q = (qtone, 20, 21, qttwo)
	
		for (i=1; i<=rows(third); i++)  {
	    j=third[i]+1
		if (j<=70) sthird[i]=q[j]
		if (j==72) sthird[i]=q[71]
		if (j==77) sthird[i]=q[72]
		if (j==79) sthird[i]=q[73]
		if (j==82) sthird[i]=q[74]
	    }
		
		
	   smt = mean(sthird)
	   svt = variance(sthird)
	   
sthird = (sthird:-smt):/svt^.5

ones = J(rows(sthird),1,1)
X = black, ones

b = invsym(X'X)*X'sthird

uhat = sthird:-X*b
sandwich = J(2,2,0)
for (i=1; i<=rows(uhat); i++) {
    sandwich = sandwich:+ uhat[i]:^2*X[i,.]'X[i,.]
	    }

sigma = invsym(X'X)*sandwich*invsym(X'X)
b[1,1]

sqrt(sigma[1,1])

end

clear mata
clear matrix
clear
set more off
set mem 300m
set matsize 800
/*choose data directory*/
cd "C:\Users\bond10\Desktop\RA\Test Scores\Paper\replication files"
use CNLSYbondlang.dta, clear
*
keep if grade==2 & PIATreadcomraw!=.

sum black PPVTraw
mata
mata clear

p = (-0.000014,9.21E-07,2.09E-06,2.02E-06,-0.0000127,0.0000173,8.92E-06,7.57E-06,0.0000194,-7.83E-08,0.000019,0.0000153,0.0000183,-9.99E-06,4.15E-06,0.0000148,9.05E-06,2.81E-06,-602.1643,0.0000357,1.44E-06,-0.0000174,-0.0015683,-0.0000198,-0.0000247,-0.0001557,-0.0000136,0.0001929,85.33652,114.5859,0.0029625,-0.008584,-0.236461,0.0009196,-0.0003152,106.2285,66.91647,-0.1191813,59.15557,59.02026,1.997891,-0.7287101,138.0792,2.183553,-0.0014379,27.40182,66.4903,23.6936,-0.0002214,-0.0002554,-0.0000563,-0.0440697,-0.0007198,3.30E-06,-0.0225837,60.64724,-0.0000941,-0.0000232,69.14789,0.0000217,-0.0005507,1.82E-06,-0.0007539,3.767011,0.0001715,4.234463,0.0000797,170.0415,30.59504,-0.1279303,-0.2773463,-0.1204581)



st_view(black=.,.,("black"))
st_view(third=.,.,("PIATreadcomraw"))


sthird = J(rows(third),1,0)

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
	qttwo = runningsum(ptwo:*ptwo):+21
	
	
//	tmp = qt[81]

	q = (qtone, 20, 21, qttwo)
	
		for (i=1; i<=rows(third); i++)  {
	    j=third[i]+1
		if (j<=70) sthird[i]=q[j]
		if (j==72) sthird[i]=q[71]
		if (j==77) sthird[i]=q[72]
		if (j==79) sthird[i]=q[73]
		if (j==82) sthird[i]=q[74]
	    }
		
		
	   smt = mean(sthird)
	   svt = variance(sthird)
	   
sthird = (sthird:-smt):/svt^.5

ones = J(rows(sthird),1,1)
X = black, ones

b = invsym(X'X)*X'sthird

uhat = sthird:-X*b
sandwich = J(2,2,0)
for (i=1; i<=rows(uhat); i++) {
    sandwich = sandwich:+ uhat[i]:^2*X[i,.]'X[i,.]
	    }

sigma = invsym(X'X)*sandwich*invsym(X'X)

b[1,1]

sqrt(sigma[1,1])

end

clear mata
clear matrix
clear
set more off
set mem 300m
set matsize 800
/*choose data directory*/
cd "C:\Users\bond10\Desktop\RA\Test Scores\Paper\replication files"
use CNLSYbondlang.dta, clear
*
keep if grade==3 & PIATreadcomraw!=.

mata
mata clear

p = (-0.000014,9.21E-07,2.09E-06,2.02E-06,-0.0000127,0.0000173,8.92E-06,7.57E-06,0.0000194,-7.83E-08,0.000019,0.0000153,0.0000183,-9.99E-06,4.15E-06,0.0000148,9.05E-06,2.81E-06,-602.1643,0.0000357,1.44E-06,-0.0000174,-0.0015683,-0.0000198,-0.0000247,-0.0001557,-0.0000136,0.0001929,85.33652,114.5859,0.0029625,-0.008584,-0.236461,0.0009196,-0.0003152,106.2285,66.91647,-0.1191813,59.15557,59.02026,1.997891,-0.7287101,138.0792,2.183553,-0.0014379,27.40182,66.4903,23.6936,-0.0002214,-0.0002554,-0.0000563,-0.0440697,-0.0007198,3.30E-06,-0.0225837,60.64724,-0.0000941,-0.0000232,69.14789,0.0000217,-0.0005507,1.82E-06,-0.0007539,3.767011,0.0001715,4.234463,0.0000797,170.0415,30.59504,-0.1279303,-0.2773463,-0.1204581)


st_view(black=.,.,("black"))
st_view(third=.,.,("PIATreadcomraw"))


sthird = J(rows(third),1,0)

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
	qttwo = runningsum(ptwo:*ptwo):+21
	
	
//	tmp = qt[81]

	q = (qtone, 20, 21, qttwo)
	
		for (i=1; i<=rows(third); i++)  {
	    j=third[i]+1
		if (j<=70) sthird[i]=q[j]
		if (j==72) sthird[i]=q[71]
		if (j==77) sthird[i]=q[72]
		if (j==79) sthird[i]=q[73]
		if (j==82) sthird[i]=q[74]
	    }
		
		
	   smt = mean(sthird)
	   svt = variance(sthird)
	   
sthird = (sthird:-smt):/svt^.5

ones = J(rows(sthird),1,1)
X = black, ones

b = invsym(X'X)*X'sthird

uhat = sthird:-X*b
sandwich = J(2,2,0)
for (i=1; i<=rows(uhat); i++) {
    sandwich = sandwich:+ uhat[i]:^2*X[i,.]'X[i,.]
	    }

sigma = invsym(X'X)*sandwich*invsym(X'X)

b[1,1]

sqrt(sigma[1,1])

end




/*This code produces the test gaps in the PIAT for the minimizing transformation
(Column 3 of Table 2)*/



clear mata
clear matrix
clear
set more off
set mem 300m
set matsize 800
/*choose data directory*/
cd "C:\Users\bond10\Desktop\RA\Test Scores\Paper\replication files"
use CNLSYbondlang.dta, clear

keep if grade==0 & PIATreadcomraw!=.


sum black PPVTraw
mata
mata clear

p=(-0.0000474,492.2914,-0.0164457,405.0533,-0.0004923,480.482,0.0004774,268.4127,-0.0000188,-3.790892,-571.2755,291.6694,0.0006099,-0.000079,5.50E-07,907.5368,0.0824099,-938.3521,-0.0006764,0.0003017,0.0000329,-5.07E-06,5.91E-07,-2.17E-06,-1.97E-06,0.0000549,-9.77E-06,7.30E-06,-5.67E-06,-4.73E-06,-2.80E-06,-2.47E-07,4.22E-06,-3.34E-06,2.58E-06,0.0000114,3.10E-06,-0.000015,5.14E-06,4.59E-06,4.49E-06,5.18E-06,-0.0000157,-1.12E-06,-1.08E-06,-7.39E-06,0.0000116,4.46E-07,0.0001531,0.0000127,8.54E-07,-0.0000147,-2.56E-06,0.0000321,0.0000205,0.0000209,3.97E-06,0.0000133,0.0000261,9.05E-06,0.0000398,0.0000423,0.0000194,0.00001,0.0000274,0.0000398,0.0000965,-0.0000115,0.000031,0.0000328,0.0000506,0.0002295)


st_view(black=.,.,("black"))
st_view(third=.,.,("PIATreadcomraw"))


sthird = J(rows(third),1,0)

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
	qttwo = runningsum(ptwo:*ptwo):+20.000000001
	
	
//	tmp = qt[81]

	q = (qtone, 20, 20.000000001, qttwo)
	
		for (i=1; i<=rows(third); i++)  {
	    j=third[i]+1
		if (j<=70) sthird[i]=q[j]
		if (j==72) sthird[i]=q[71]
		if (j==77) sthird[i]=q[72]
		if (j==79) sthird[i]=q[73]
		if (j==82) sthird[i]=q[74]
	    }
		
		
	   smt = mean(sthird)
	   svt = variance(sthird)
	   
sthird = (sthird:-smt):/svt^.5

ones = J(rows(sthird),1,1)
X = black, ones

b = invsym(X'X)*X'sthird

uhat = sthird:-X*b
sandwich = J(2,2,0)
for (i=1; i<=rows(uhat); i++) {
    sandwich = sandwich:+ uhat[i]:^2*X[i,.]'X[i,.]
	    }

sigma = invsym(X'X)*sandwich*invsym(X'X)

b[1,1]

sqrt(sigma[1,1])

end


clear mata
clear matrix
clear
set more off
set mem 300m
set matsize 800
/*choose data directory*/
cd "C:\Users\bond10\Desktop\RA\Test Scores\Paper\replication files"
use CNLSYbondlang.dta, clear

*
keep if grade==1 & PIATreadcomraw!=.

mata
mata clear

p=(-0.0000474,492.2914,-0.0164457,405.0533,-0.0004923,480.482,0.0004774,268.4127,-0.0000188,-3.790892,-571.2755,291.6694,0.0006099,-0.000079,5.50E-07,907.5368,0.0824099,-938.3521,-0.0006764,0.0003017,0.0000329,-5.07E-06,5.91E-07,-2.17E-06,-1.97E-06,0.0000549,-9.77E-06,7.30E-06,-5.67E-06,-4.73E-06,-2.80E-06,-2.47E-07,4.22E-06,-3.34E-06,2.58E-06,0.0000114,3.10E-06,-0.000015,5.14E-06,4.59E-06,4.49E-06,5.18E-06,-0.0000157,-1.12E-06,-1.08E-06,-7.39E-06,0.0000116,4.46E-07,0.0001531,0.0000127,8.54E-07,-0.0000147,-2.56E-06,0.0000321,0.0000205,0.0000209,3.97E-06,0.0000133,0.0000261,9.05E-06,0.0000398,0.0000423,0.0000194,0.00001,0.0000274,0.0000398,0.0000965,-0.0000115,0.000031,0.0000328,0.0000506,0.0002295)


st_view(black=.,.,("black"))
st_view(third=.,.,("PIATreadcomraw"))


sthird = J(rows(third),1,0)

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
	qttwo = runningsum(ptwo:*ptwo):+20.000000001
	
	
//	tmp = qt[81]

	q = (qtone, 20, 20.000000001, qttwo)
	
		for (i=1; i<=rows(third); i++)  {
	    j=third[i]+1
		if (j<=70) sthird[i]=q[j]
		if (j==72) sthird[i]=q[71]
		if (j==77) sthird[i]=q[72]
		if (j==79) sthird[i]=q[73]
		if (j==82) sthird[i]=q[74]
	    }
		
		
	   smt = mean(sthird)
	   svt = variance(sthird)
	   
sthird = (sthird:-smt):/svt^.5

ones = J(rows(sthird),1,1)
X = black, ones

b = invsym(X'X)*X'sthird

uhat = sthird:-X*b
sandwich = J(2,2,0)
for (i=1; i<=rows(uhat); i++) {
    sandwich = sandwich:+ uhat[i]:^2*X[i,.]'X[i,.]
	    }

sigma = invsym(X'X)*sandwich*invsym(X'X)
b[1,1]

sqrt(sigma[1,1])

end

clear mata
clear matrix
clear
set more off
set mem 300m
set matsize 800
/*choose data directory*/
cd "C:\Users\bond10\Desktop\RA\Test Scores\Paper\replication files"
use CNLSYbondlang.dta, clear
*
keep if grade==2 & PIATreadcomraw!=.

sum black PPVTraw
mata
mata clear

p=(-0.0000474,492.2914,-0.0164457,405.0533,-0.0004923,480.482,0.0004774,268.4127,-0.0000188,-3.790892,-571.2755,291.6694,0.0006099,-0.000079,5.50E-07,907.5368,0.0824099,-938.3521,-0.0006764,0.0003017,0.0000329,-5.07E-06,5.91E-07,-2.17E-06,-1.97E-06,0.0000549,-9.77E-06,7.30E-06,-5.67E-06,-4.73E-06,-2.80E-06,-2.47E-07,4.22E-06,-3.34E-06,2.58E-06,0.0000114,3.10E-06,-0.000015,5.14E-06,4.59E-06,4.49E-06,5.18E-06,-0.0000157,-1.12E-06,-1.08E-06,-7.39E-06,0.0000116,4.46E-07,0.0001531,0.0000127,8.54E-07,-0.0000147,-2.56E-06,0.0000321,0.0000205,0.0000209,3.97E-06,0.0000133,0.0000261,9.05E-06,0.0000398,0.0000423,0.0000194,0.00001,0.0000274,0.0000398,0.0000965,-0.0000115,0.000031,0.0000328,0.0000506,0.0002295)


st_view(black=.,.,("black"))
st_view(third=.,.,("PIATreadcomraw"))


sthird = J(rows(third),1,0)

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
	qttwo = runningsum(ptwo:*ptwo):+20.000000001
	
	
//	tmp = qt[81]

	q = (qtone, 20, 20.000000001, qttwo)
	
		for (i=1; i<=rows(third); i++)  {
	    j=third[i]+1
		if (j<=70) sthird[i]=q[j]
		if (j==72) sthird[i]=q[71]
		if (j==77) sthird[i]=q[72]
		if (j==79) sthird[i]=q[73]
		if (j==82) sthird[i]=q[74]
	    }
		
		
	   smt = mean(sthird)
	   svt = variance(sthird)
	   
sthird = (sthird:-smt):/svt^.5

ones = J(rows(sthird),1,1)
X = black, ones

b = invsym(X'X)*X'sthird

uhat = sthird:-X*b
sandwich = J(2,2,0)
for (i=1; i<=rows(uhat); i++) {
    sandwich = sandwich:+ uhat[i]:^2*X[i,.]'X[i,.]
	    }

sigma = invsym(X'X)*sandwich*invsym(X'X)

b[1,1]

sqrt(sigma[1,1])

end

clear mata
clear matrix
clear
set more off
set mem 300m
set matsize 800
/*choose data directory*/
cd "C:\Users\bond10\Desktop\RA\Test Scores\Paper\replication files"
use CNLSYbondlang.dta, clear
*
keep if grade==3 & PIATreadcomraw!=.

mata
mata clear

p=(-0.0000474,492.2914,-0.0164457,405.0533,-0.0004923,480.482,0.0004774,268.4127,-0.0000188,-3.790892,-571.2755,291.6694,0.0006099,-0.000079,5.50E-07,907.5368,0.0824099,-938.3521,-0.0006764,0.0003017,0.0000329,-5.07E-06,5.91E-07,-2.17E-06,-1.97E-06,0.0000549,-9.77E-06,7.30E-06,-5.67E-06,-4.73E-06,-2.80E-06,-2.47E-07,4.22E-06,-3.34E-06,2.58E-06,0.0000114,3.10E-06,-0.000015,5.14E-06,4.59E-06,4.49E-06,5.18E-06,-0.0000157,-1.12E-06,-1.08E-06,-7.39E-06,0.0000116,4.46E-07,0.0001531,0.0000127,8.54E-07,-0.0000147,-2.56E-06,0.0000321,0.0000205,0.0000209,3.97E-06,0.0000133,0.0000261,9.05E-06,0.0000398,0.0000423,0.0000194,0.00001,0.0000274,0.0000398,0.0000965,-0.0000115,0.000031,0.0000328,0.0000506,0.0002295)

st_view(black=.,.,("black"))
st_view(third=.,.,("PIATreadcomraw"))


sthird = J(rows(third),1,0)

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
	qttwo = runningsum(ptwo:*ptwo):+20.000000001
	
	
//	tmp = qt[81]

	q = (qtone, 20, 20.000000001, qttwo)
	
		for (i=1; i<=rows(third); i++)  {
	    j=third[i]+1
		if (j<=70) sthird[i]=q[j]
		if (j==72) sthird[i]=q[71]
		if (j==77) sthird[i]=q[72]
		if (j==79) sthird[i]=q[73]
		if (j==82) sthird[i]=q[74]
	    }
		
		
	   smt = mean(sthird)
	   svt = variance(sthird)
	   
sthird = (sthird:-smt):/svt^.5

ones = J(rows(sthird),1,1)
X = black, ones

b = invsym(X'X)*X'sthird

uhat = sthird:-X*b
sandwich = J(2,2,0)
for (i=1; i<=rows(uhat); i++) {
    sandwich = sandwich:+ uhat[i]:^2*X[i,.]'X[i,.]
	    }

sigma = invsym(X'X)*sandwich*invsym(X'X)

b[1,1]

sqrt(sigma[1,1])

end

