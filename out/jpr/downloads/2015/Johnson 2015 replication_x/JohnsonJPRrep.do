* Replication File for "The Cost of Security: Foreign Policy Concessions and Military Alliances"
* Jesse C. Johnson

	use "\JohnsonJPRrep\JohnsonJPRrep.dta", clear
	
	set more off
	
* Table 1
		
	tab c1
	tab c2
	tab c3
	tab c4
	tab c5
	tab c6
	tab c7
	tab c8
	tab c9
	tab c10
	
* Table 2

	nbreg concession t_win 

	nbreg concession d_contr

	nbreg concession t_win d_contr

	nbreg concession t_win d_contr prWWI WWI iWW WWII cold 
	
	nbreg concession t_win d_contr prWWI WWI iWW WWII cold cwpceyrs

* Table A1

	nbreg concession2 t_win 
	
	nbreg concession2 d_contr
	
	nbreg concession2 t_win d_contr
	
	nbreg concession2 t_win d_contr prWWI WWI iWW WWII cold 

	nbreg concession2 t_win d_contr prWWI WWI iWW WWII cold cwpceyrs

* Table A2
	
	pwcorr c1-c10, sig

* Table A3

	nbreg concession t_win d_contr 

	nbreg concession t_win t_cap c_cap d_cap

	nbreg concession d_contr t_cap c_cap d_cap

	nbreg concession t_win d_contr t_cap c_cap d_cap
	
* Table A4

	poisson concession t_win 
	
	poisson concession d_contr
	
	poisson concession t_win d_contr
	
	poisson concession t_win d_contr prWWI WWI iWW WWII cold 
	
	poisson concession t_win d_contr prWWI WWI iWW WWII cold cwpceyrs
	
* Table A5

	nbreg concession t_win d_contr if europe~=.

	nbreg concession t_win d_contr europe me africa asia 
	
	nbreg concession t_win d_contr prWWI WWI iWW WWII cold cwpceyrs if europe~=.
		
	nbreg concession t_win d_contr europe me africa asia prWWI WWI iWW WWII cold cwpceyrs 
	
* Table A6

	xtmepoisson concession t_win || tc:
	
	xtmepoisson concession d_contr || tc:
	
	xtmepoisson concession t_win d_contr || tc:
	
	xtmepoisson concession t_win d_contr prWWI WWI iWW WWII cold || tc:
	
	xtmepoisson concession t_win d_contr prWWI WWI iWW WWII cold cwpceyrs || tc:
	
* Table A7

	nbreg concession t_win d_contr cwpceyrs 
	
	nbreg concession t_win d_contr cwpceyrs cwpceyrs2 cwpceyrs3	
	
	nbreg concession t_win d_contr prWWI WWI iWW WWII cold cwpceyrs

	nbreg concession t_win d_contr prWWI WWI iWW WWII cold cwpceyrs cwpceyrs2 cwpceyrs3
