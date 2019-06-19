#delimit ;
set more off;
clear;

/*NOTE: For a Mac, file path names use a forward slash (/) but for 
PC's they require a backward slash (\). Make these changes below 
if necessary depending on your computer type. 
*/

*Dropbox paths by user;
if c(username)=="shayaksarkar" {;
	local path "/Users/shayaksarkar/Desktop/ReStat_Data_Publication";
};


/*FIGURE A1*/;

cd `path';

* create two values for R;
* R_p < R_b;
* R_b = 1.05;
* R_p = 1.01;

tempname sim;
postfile `sim' beta R_p U_p U_b using "`path'/dta/simresults.dta", replace;

quietly {;

	forval beta = .1(.1)1 {;
	
	forval R_p = 1.035(0.01)1.045 {;
		clear;
		/* Each obseration is an age */;
		set obs 45;
		/* Set age to be the number of the observation */;
		gen age=_n;
	
		* Set parameters;
		gen delta = .9571;
		gen R_b = 1.08;
		gen A_1 = 100;
		gen rho = 2;
		
		************LN utility precommit *******************;
		* Generate numerators;
		gen beta_delta_R_power = `beta'*(delta*`R_p')^(age);
		gen num_ln_p = A_1;
		replace num_ln_p = beta_delta_R_power[_n-1]*A_1 if age >=2;

		* Generate denominators for consumption in all periods;

		gen beta_delta= `beta'*delta^age;
		gen sum_beta_delta= sum(beta_delta);
		gen den_ln_p = 1+sum_beta_delta[_N-1];

		* Generate consumptions;

		gen cons_ln_p = num_ln_p/den_ln_p;
	
		* Generate U_p;
	
		gen ut_p = ln(cons_ln_p);
		replace ut_p = `beta'*delta^(age-1)*cons_ln_p if age >= 2;
		sum ut_p;
		scalar Ut_p = r(sum);
	

		**********Backwards with LN utility ****************;

		*I want the sum of the first n-j rows for the jth entry, so I reverse the sum;
		gen sum_beta_delta_rev = sum_beta_delta[_N-age];
		replace sum_beta_delta_rev = beta_delta[1] if age == _N;

		*I add 1 to find the donominators;
		gen den_ln_b = 1 + sum_beta_delta_rev;

		*create cons_b, A_b for backwards induction;
		gen cons_ln_b = .;
		gen A_b = .;
		replace A_b = A_1 if age == 1;
		replace cons_ln_b = A_1/den_ln_b if age == 1;

		*This loop updates income at period i first then consumption at that period;
		local samp_size = _N-1;
		forvalues i = 2/`samp_size' {;
			replace A_b = (A_b[_n-1]-cons_ln_b[_n-1])*R_b if age == `i';
			replace cons_ln_b = A_b/den_ln_b if age == `i';
		};
		*modify the last period;
		replace A_b = (A_b[_n-1]-cons_ln_b[_n-1])*R_b if age == _N;
		replace cons_ln_b = A_b if age == _N;
			
	* Calculate U_p and U_b;
	* Generate utility streams;
		local types p b;
		foreach x of local types {;

			gen u_t_`x' = ln(cons_ln_`x');
			replace u_t_`x' = `beta'*delta^(age-1)*ln(cons_ln_`x') if age >= 2 ;
			sum u_t_`x';
			scalar U_`x' = r(sum);
		} ;
		
		post `sim' (`beta') (`R_p') (U_p) (U_b);
		};
	};
};

postclose `sim';

clear;
use "`path'/dta/simresults.dta";
label var U_p "Utility Whole Insurance";
label var U_b "Utility Liquid Savings";
egen r_group = group(R_p);
capture cd "`path'/out";


	gen temp = cond(r_group==2,0,1);
	sort temp beta ;
	local gross_rate: display %5.3f R_p;
	twoway line U_p beta if r_group == 2 || line U_b beta if r_group == 2, ytitle("Lifetime Utility") scheme(s2mono) 
	note(The gross interest on whole insurance and liquid savings here are `gross_rate' and 1.08 respectively.);
	graph export figureA1.png, replace;
	drop temp;



