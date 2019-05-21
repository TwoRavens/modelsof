
/*
Replication of Table 1: p-values from placebo tests in Caughey and Sekhon (2011) with and without con- trolling for incumbency
*/

#delimit ;
drop _all;

set linesize 200;

use replication_cs, clear;

quietly {;
	capture log close;
	log using caughey_sekhon_checks_output_table.tex, text replace;

	noisily display "\begin{center}\setlength{\baselineskip}{10pt}";
	noisily display "\begin{tabular}{|l|c|c|}";

	noisily display "\hline";
	noisily display "& & \\ [-.1in]";
	noisily display "Dependent &  Original         & Including              \\ ";
	noisily display "Variable  &  ~Specification~  & Dem Win $ t \!-\! 1 $  \\ [.05in]";
	noisily display "\hline";
	noisily display "& & \\ [-.1in]";
	log off;
};


foreach i of varlist dwinprv dpctprv difdpprv incdwnom1 deminc nondinc prvtrmsd prvtrmso dexpadv rexpadv elcswing cqrating3 dspndpct ddonapct {;

	quietly {;
		log on;
		if "`i'" == "dwinprv" {;
			noisily display "Democratic Win $ t \!-\! 1 $" _cont;
		};

		if "`i'" == "dpctprv" {;
			noisily display "Democratic \% Vote $ t \!-\! 1 $" _cont;
		};

		if "`i'" == "difdpprv" {;
			noisily display "Democratic \% Margin $ t \!-\! 1 $" _cont;
		};

		if "`i'" == "incdwnom1" {;
			noisily display "Incumbent D1 Nominate" _cont;
		};

		if "`i'" == "deminc" {;
			noisily display "Democratic Incumb in Race" _cont;
		};

		if "`i'" == "nondinc" {;
			noisily display "Republican Incumb in Race" _cont;
		};

		if "`i'" == "prvtrmsd" {;
			noisily display "Democratic \# Previous Terms" _cont;
		};

		if "`i'" == "prvtrmso" {;
			noisily display "Republican \# Previous Terms" _cont;
		};

		if "`i'" == "dexpadv" {;
			noisily display "Democratic Experience Adv" _cont;
		};

		if "`i'" == "rexpadv" {;
			noisily display "Republican Experience Adv" _cont;
		};

		if "`i'" == "elcswing" {;
			noisily display "Partisan Swing" _cont;
		};

		if "`i'" == "cqrating3" {;
			noisily display "CQ Rating" _cont;
		};

		if "`i'" == "dspndpct" {;
			noisily display "Democratic Spending \%" _cont;
		};

		if "`i'" == "ddonapct" {;
			noisily display "Democratic Donation \%" _cont;
		};



		reg `i' demwin           if abs(difdpct) < .5 & year>=1942 & dwinprv != . , robust;
		local n_`i' = e(N);
		local b_`i' = _b[demwin];
		local s_`i' = _se[demwin];
		local p_value_`i' = 2*ttail(e(df_r),abs(_b[demwin]/_se[demwin]));
		noisily display " & " %4.2f `p_value_`i'' _cont;

		reg `i' demwin  dwinprv  if abs(difdpct) < .5 & year>=1942  & dwinprv != . , robust;
		local n_`i' = e(N);
		local b_`i' = _b[demwin];
		local s_`i' = _se[demwin];
		local p_value_`i' = 2*ttail(e(df_r),abs(_b[demwin]/_se[demwin]));
		if "`i'" != "dwinprv" {;
			noisily display " & " %4.2f `p_value_`i'' _cont;
		};
		else {;
			noisily display " & -- " _cont;
		};



		noisily display " \\ [.05in]";

		log off;

	};

};


quietly {;

	log on;
	noisily display "\hline";
	noisily display "\end{tabular}";
	noisily display "\end{center}";

	log close;

};
