clear 
cd ""	//SET DIRECTORY HERE
use "Denmark (2015)"
set seed 673763
set more off

************************
***REPLICATE TABLE 1a***
************************

	*Prime minister predictions 
		local a = 1
		
		while `a' <= 10 {
					
		*PM
			*get mean
				gen party`a'_PM_mean = .
				sum Prime_minister if Party == `a'
				replace party`a'_PM_mean = r(mean) in 1
	
			*Get CI's  
				
				*generate variables that we will fill in later
					gen party`a'_PM_low = .
					gen party`a'_PM_high = .
					
				*get average through regression
					reg Prime_minister if Party == `a' 
			
				*run simutils
					do simUtils
					tempname b V sig dfsig
					matrix `b' = e(b)                            /* 1 x k vector         */
					matrix `V' = e(V)                            /* k x k variance matrix*/
					local N = `e(N)'                             /* save # observations  */			
					_simp, b(`b') v(`V') s(10000) g(bbt)		/* run the program to generate the simulations */ 

				*generate the CI's	
					_pctile bbt1, p(2.5,97.5)
					replace party`a'_PM_low = r(r1) in 1
					replace party`a'_PM_low = 0 if party`a'_PM_low < 0	
					replace party`a'_PM_high = r(r2) in 1
					replace party`a'_PM_high = 1 if party`a'_PM_high > 1 in 1	

	
			local a = `a' + 1					
			capture drop bbt1	
		}		

	
					
	*Cabinet partner predictions
		
		local a = 1
		
		while `a' <= 10 {	
	
		*Cabinet
			*get mean
				gen party`a'_Cab_mean = .
				sum Cabinet if Party == `a'
				replace party`a'_Cab_mean = r(mean) in 1
	
			*Get CI's  
				
				*generate variables that we will fill in later
					gen party`a'_Cab_low = .
					gen party`a'_Cab_high = .
					
				*get average through regression
					reg Cabinet if Party == `a' 
			
				*run simutils
					do simUtils
					tempname b V sig dfsig
					matrix `b' = e(b)                            /* 1 x k vector         */
					matrix `V' = e(V)                            /* k x k variance matrix*/
					local N = `e(N)'                             /* save # observations  */			
					_simp, b(`b') v(`V') s(10000) g(bbt)		/* run the program to generate the simulations */ 

				*generate the CI's	
					_pctile bbt1, p(2.5,97.5)
					replace party`a'_Cab_low = r(r1) in 1
					replace party`a'_Cab_low = 0 if party`a'_Cab_low < 0	
					replace party`a'_Cab_high = r(r2) in 1
					replace party`a'_Cab_high = 1 if party`a'_Cab_high > 1 in 1	

	
			local a = `a' + 1					
			capture drop bbt1	
		}
		
	*Support party predictions
		
		local a = 1
		
		while `a' <= 10 {	
	
		*Support party 1
		
			*get mean
				gen party`a'_Sup_mean = .
				sum Support if Party == `a'
				replace party`a'_Sup_mean = r(mean) in 1
	
			*Get CI's  
				
				*generate variables that we will fill in later
					gen party`a'_Sup_low = .
					gen party`a'_Sup_high = .
					
				*get average through regression
					reg Support if Party == `a' 
			
				*run simutils
					do simUtils
					tempname b V sig dfsig
					matrix `b' = e(b)                            /* 1 x k vector         */
					matrix `V' = e(V)                            /* k x k variance matrix*/
					local N = `e(N)'                             /* save # observations  */			
					_simp, b(`b') v(`V') s(10000) g(bbt)		/* run the program to generate the simulations */ 

				*generate the CI's	
					_pctile bbt1, p(2.5,97.5)
					replace party`a'_Sup_low = r(r1) in 1
					replace party`a'_Sup_low = 0 if party`a'_Sup_low < 0	
					replace party`a'_Sup_high = r(r2) in 1
					replace party`a'_Sup_high = 1 if party`a'_Sup_high > 1 in 1	

	
			local a = `a' + 1					
			capture drop bbt1	
		}

	
	*Opposition party predictions
		
		local a = 1
		
		while `a' <= 10 {	
	
		*Opposition party 1
		
			*get mean
				gen party`a'_Opp_mean = .
				sum Opposition if Party == `a'
				replace party`a'_Opp_mean = r(mean) in 1
	
			*Get CI's  
				
				*generate variables that we will fill in later
					gen party`a'_Opp_low = .
					gen party`a'_Opp_high = .
					
				*get average through regression
					reg Opposition if Party == `a' 
			
				*run simutils
					do simUtils
					tempname b V sig dfsig
					matrix `b' = e(b)                            /* 1 x k vector         */
					matrix `V' = e(V)                            /* k x k variance matrix*/
					local N = `e(N)'                             /* save # observations  */			
					_simp, b(`b') v(`V') s(10000) g(bbt)		/* run the program to generate the simulations */ 

				*generate the CI's	
					_pctile bbt1, p(2.5,97.5)
					replace party`a'_Opp_low = r(r1) in 1
					replace party`a'_Opp_low = 0 if party`a'_Opp_low < 0	
					replace party`a'_Opp_high = r(r2) in 1
					replace party`a'_Opp_high = 1 if party`a'_Opp_high > 1 in 1	

	
			local a = `a' + 1					
			capture drop bbt1	
		}
	
	*No_seats party predictions
		
		local a = 1
		
		while `a' <= 10 {	
	
		*No_seats party 1
		
			*get mean
				gen party`a'_No_seats_mean = .
				sum No_seats if Party == `a'
				replace party`a'_No_seats_mean = r(mean) in 1
	
			*Get CI's  
				
				*generate variables that we will fill in later
					gen party`a'_No_seats_low = .
					gen party`a'_No_seats_high = .
					
				*get average through regression
					reg No_seats if Party == `a' 
			
				*run simutils
					do simUtils
					tempname b V sig dfsig
					matrix `b' = e(b)                            /* 1 x k vector         */
					matrix `V' = e(V)                            /* k x k variance matrix*/
					local N = `e(N)'                             /* save # observations  */			
					_simp, b(`b') v(`V') s(10000) g(bbt)		/* run the program to generate the simulations */ 

				*generate the CI's	
					_pctile bbt1, p(2.5,97.5)
					replace party`a'_No_seats_low = r(r1) in 1
					replace party`a'_No_seats_low = 0 if party`a'_No_seats_low < 0	
					replace party`a'_No_seats_high = r(r2) in 1
					replace party`a'_No_seats_high = 1 if party`a'_No_seats_high > 1 in 1	

	
			local a = `a' + 1					
			capture drop bbt1	
		}
		
		*Dont_know predictions 
			
			local a = 1
			
			while `a' <= 10 {	
		
			*Dont_know  
			
				*get mean
					gen party`a'_Dont_know_mean = .
					sum Dont_know if Party == `a'
					replace party`a'_Dont_know_mean = r(mean) in 1
		
				*Get CI's  
					
					*generate variables that we will fill in later
						gen party`a'_Dont_know_low = .
						gen party`a'_Dont_know_high = .
						
					*get average through regression
						reg Dont_know if Party == `a' 
				
					*run simutils
						do simUtils
						tempname b V sig dfsig
						matrix `b' = e(b)                            /* 1 x k vector         */
						matrix `V' = e(V)                            /* k x k variance matrix*/
						local N = `e(N)'                             /* save # observations  */			
						_simp, b(`b') v(`V') s(10000) g(bbt)		/* run the program to generate the simulations */ 

					*generate the CI's	
						_pctile bbt1, p(2.5,97.5)
						replace party`a'_Dont_know_low = r(r1) in 1
						replace party`a'_Dont_know_low = 0 if party`a'_Dont_know_low < 0	
						replace party`a'_Dont_know_high = r(r2) in 1
						replace party`a'_Dont_know_high = 1 if party`a'_Dont_know_high > 1 in 1	

		
				local a = `a' + 1					
				capture drop bbt1	
			}

	*show results using "list" command
		gen PM = .
		gen PM_lower_CI = .
		gen PM_upper_CI = .
		gen Partner = .
		gen Partner_lower_CI = .
		gen Partner_upper_CI = .
		gen Supp = .
		gen Supp_lower_CI = .
		gen Supp_upper_CI = .		
		gen Opp = .
		gen Opp_lower_CI = .
		gen Opp_upper_CI = .
		gen NoSeats = .
		gen NoSeats_lower_CI = .
		gen NoSeats_upper_CI = .
		gen DK = .
		gen DK_lower_CI = .
		gen DK_upper_CI = .
		
		
		*generate values in list form
				local a = 1
					
					while `a' <= 10 {			
						sum party`a'_PM_mean
						replace PM = r(mean) in `a' 
						sum party`a'_PM_low
						replace PM_lower_CI = r(mean) in `a' 
						sum party`a'_PM_high
						replace PM_upper_CI = r(mean) in `a' 
	
						sum party`a'_Cab_mean
						replace Partner = r(mean) in `a' 
						sum party`a'_Cab_low
						replace Partner_lower_CI = r(mean) in `a' 
						sum party`a'_Cab_high
						replace Partner_upper_CI = r(mean) in `a' 
	
						sum party`a'_Sup_mean
						replace Supp = r(mean) in `a' 
						sum party`a'_Sup_low
						replace Supp_lower_CI = r(mean) in `a' 
						sum party`a'_Sup_high
						replace Supp_upper_CI = r(mean) in `a' 						
						
						sum party`a'_Opp_mean
						replace Opp = r(mean) in `a' 
						sum party`a'_Opp_low
						replace Opp_lower_CI = r(mean) in `a' 
						sum party`a'_Opp_high
						replace Opp_upper_CI = r(mean) in `a' 

						sum party`a'_No_seats_mean
						replace NoSeats = r(mean) in `a' 
						sum party`a'_No_seats_low
						replace NoSeats_lower_CI = r(mean) in `a' 
						sum party`a'_No_seats_high
						replace NoSeats_upper_CI = r(mean) in `a' 

						sum party`a'_Dont_know_mean
						replace DK = r(mean) in `a' 
						sum party`a'_Dont_know_low
						replace DK_lower_CI = r(mean) in `a' 
						sum party`a'_Dont_know_high
						replace DK_upper_CI = r(mean) in `a' 
							
					local a = `a' + 1					
				}					

		
		*show results	
			drop if PM == .
			list partyname PM PM_lower_CI PM_upper_CI 
			list partyname Partner Partner_lower_CI Partner_upper_CI 
			list partyname Supp Supp_lower_CI Supp_upper_CI 			
			list partyname Opp Opp_lower_CI Opp_upper_CI 
			list partyname NoSeats NoSeats_lower_CI NoSeats_upper_CI 
			list partyname DK DK_lower_CI DK_upper_CI				


************************
***REPLICATE TABLE 2a***
************************	
clear 
use "Denmark (2015)"
set seed 673763


	*code missing answers as missing
		replace Resp_attribution = . if Resp_attribution == 0

	*predictions (note that responsibility attribution for Alternativet was not possible)
		local a = 1
		
		while `a' <= 9 {
					
		*PM
			*get mean
				gen party`a'_mean = .
				sum Resp_attribution if Party == `a'
				replace party`a'_mean = r(mean) in 1
	
			*Get CI's  
				
				*generate variables that we will fill in later
					gen party`a'_low = .
					gen party`a'_high = .
					
				*get average through regression
					reg Resp_attribution if Party == `a' 
			
				*run simutils
					do simUtils
					tempname b V sig dfsig
					matrix `b' = e(b)                            /* 1 x k vector         */
					matrix `V' = e(V)                            /* k x k variance matrix*/
					local N = `e(N)'                             /* save # observations  */			
					_simp, b(`b') v(`V') s(10000) g(bbt)		/* run the program to generate the simulations */ 

				*generate the CI's	
					_pctile bbt1, p(2.5,97.5)
					replace party`a'_low = r(r1) in 1
					replace party`a'_high = r(r2) in 1

			local a = `a' + 1					
			capture drop bbt1	
		}		
			
		*show results in list form
			gen mean_resp_att = .
			gen resp_att_low = .
			gen resp_att_high = .
			
			local a = 1
					
					while `a' <= 9 {			
						sum party`a'_mean
						replace mean_resp_att = r(mean) in `a'
						sum party`a'_low
						replace resp_att_low = r(mean) in `a'
						sum party`a'_high 
						replace resp_att_high = r(mean) in `a'
							
						
					local a = `a' + 1					
				}								
			
			drop if mean_resp_att == .
			list partyname mean_resp_att resp_att_low resp_att_high

			
	
