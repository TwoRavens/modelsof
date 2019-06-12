#delimit ;

drop _all;
matrix drop _all;
set linesize 250;


/* MAKE AND COLLECT ALL NEEDED NUMBERS INTO MATRICES */

matrix N1 = J(21,7,.);
matrix B1 = J(21,7,.);
matrix S1 = J(21,7,.);
matrix P1 = J(21,7,.);
matrix N2 = J(21,7,.);
matrix B2 = J(21,7,.);
matrix S2 = J(21,7,.);
matrix P2 = J(21,7,.);
matrix Mt = J(21,3,.);
matrix Mp = J(21,3,.);


/* ANALYSES, LOOP THROUGH VARIOUS CASES */

forvalues i = 1(1)21 {;

	use replication_main, clear;

	if `i' == 1 {;
		keep if country == "USA" & office_type == "HOUSE OF REPRESENTATIVES" & year >= 1880 & year <= 2010;
		local n_1  "U.S., House of Reps, 1880-2010";
		local p_2  "Democratic";
	};

	if `i' == 2 {;
		keep if country == "USA" & office_type == "HOUSE OF REPRESENTATIVES" & year >= 1880 & year <= 1944;
		local n_2  "~~ U.S., House of Reps, 1880-1944";
		local p_2  "Democratic";
	};

	if `i' == 3 {;
		keep if country == "USA" & office_type == "HOUSE OF REPRESENTATIVES" & year >= 1946 & year <= 2010;
		local n_3  "~~ U.S., House of Reps, 1946-2010";
		local p_3  "Democratic";
	};

	if `i' == 4 {;
		keep if country == "USA" & office_type == "STATEWIDE";
		local d_4  "tmp_rdd_us_statewide_postwar";
		local n_4  "U.S., Statewide, 1946-2010";
		local p_4  "Democratic";
	};

	if `i' == 5 {;
		keep if country == "USA" & office_type == "STATE LEGISLATURE";
		local d_5  "tmp_rdd_us_state_leg";
		local n_5  "U.S., State Legislature, 1990-2010";
		local p_5  "Democratic";
	};

	if `i' == 6 {;
		keep if country == "USA" & office_type == "MAYOR";
		local d_6  "tmp_rdd_us_mayors";
		local n_6  "U.S., Mayors, 1947-2007";
		local p_6  "Democratic";
	};

	if `i' == 7 {;
		keep if country == "CANADA";
		local d_7  "tmp_rdd_canada_commons_all";
		local n_7  "Canada, Commons, 1867-2011";
		local p_7  "Liberal";
	};

	if `i' == 8 {;
		keep if country == "CANADA" & year >= 1867 & year <= 1911;
		local n_8  "~~ Canada, Commons, 1867-1911";
		local p_8  "Liberal";
	};

	if `i' == 9 {;
		keep if country == "CANADA" & year >= 1921;
		local n_9  "~~ Canada, Commons, 1921-2011";
		local p_9  "Liberal";
	};

	if `i' == 10 {;
		keep if country == "UK" & office_type == "HOUSE OF COMMONS";
		local n_10  "U.K., Commons, 1918-2010";
		local p_10  "Conservative";
	};

	if `i' == 11 {;
		keep if country == "UK" & office_type == "LOCAL COUNCIL";
		local n_11  "U.K., Local Councils, 1946-2010";
		local p_11  "Conservative";
	};

	if `i' == 12 {;
		keep if country == "GERMANY" & office_type == "BUNDESTAG";
		local n_12  "Germany, Bundestag, 1953-2009";
		local p_12  "CDU/CSU";
	};

	if `i' == 13 {;
		keep if country == "GERMANY" & office_type == "BAVARIA, MAYOR";
		local n_13  "Bavaria, Mayors, 1948-2009";
		local p_13  "CSU";
	};

	if `i' == 14 {;
		keep if country == "FRANCE" & office_type == "NATIONAL ASSEMBLY";
		local n_14  "France, Natl Assembly, 1958-2007";
		local p_14  "Socialist";
	};

	if `i' == 15 {;
		keep if country == "FRANCE" & office_type == "MUNICIPALITY";
		local n_15  "France, Municipalities, 2008";
		local p_15  "Left";
	};

	if `i' == 16 {;
		keep if country == "AUSTRALIA";
		local n_16  "Australia, House of Reps, 1987-2007";
		local p_16  "Labor";
	};

	if `i' == 17 {;
		keep if country == "NEW ZEALAND";
		local n_17  "New Zealand, Parliament, 1949-1987";
		local p_17  "National";
	};

	if `i' == 18 {;
		keep if country == "INDIA";
		local n_18  "India, Lower House, 1977-2004";   
		local p_18  "Congress";
	};

	if `i' == 19 {;
		keep if country == "BRAZIL";
		local n_19  "Brazil, Mayors, 2000-2008";
		local p_19  "PMDB";
	};

	if `i' == 20 {;
		keep if country == "MEXICO";
		local n_20  "Mexico, Mayors, 1970-2009";
		local p_20  "PRI";
	};

	if `i' == 21 {;
		local n_21  "All Races Pooled";
		local p_21  "--";
	};


	capture gen share_first = 10;
	capture gen share_third =  0;

	replace rv = . if share_first != . & share_third != . & share_first - share_third < 5;

	gen lag_victory = lag_rv > 0 if lag_rv != .;
	gen treat = rv > 0 if rv != .;
	gen rv_treat = rv * treat;
	gen margin = abs(rv);

	gen rv2       = rv^2;
	gen rv3       = rv^3;
	gen rv_treat2 = rv_treat^2;
	gen rv_treat3 = rv_treat^3;

	if "`d_`i'" == "tmp_rdd_us_statewide" {;
			capture gen state_year = state + string(year);
			local clust "cluster(state_year)";
	};
	else {;
			local clust "robust ";
	};


/* LOOP THROUGH TWO DEPENDENT VARIABLES OF PLACEBO REGRESSIONS */

	local j = 1;
	foreach dv in lag_victory lag_rv {;

/* NAIVE P-VALUES */

		reg `dv' treat if margin < 0.5, `clust';
		matrix N`j'[`i',1]       = e(N);
		matrix B`j'[`i',1]  = _b[treat];
		matrix S`j'[`i',1] = _se[treat];
		matrix P`j'[`i',1] = 2*ttail(e(df_r),abs(_b[treat]/_se[treat]));

		reg `dv' treat if margin < 1.0, `clust';
		matrix N`j'[`i',2]       = e(N);
		matrix B`j'[`i',2]  = _b[treat];
		matrix S`j'[`i',2] = _se[treat];
		matrix P`j'[`i',2] = 2*ttail(e(df_r),abs(_b[treat]/_se[treat]));


/* LOCAL LINEAR P-VALUES */

		reg `dv' treat rv rv_treat if margin < 1.0, `clust';
		matrix N`j'[`i',3]       = e(N);
		matrix B`j'[`i',3]  = _b[treat];
		matrix S`j'[`i',3] = _se[treat];
		matrix P`j'[`i',3] = 2*ttail(e(df_r),abs(_b[treat]/_se[treat]));

		reg `dv' treat rv rv_treat if margin < 2.0, `clust';
		matrix N`j'[`i',4]       = e(N);
		matrix B`j'[`i',4]  = _b[treat];
		matrix S`j'[`i',4] = _se[treat];
		matrix P`j'[`i',4] = 2*ttail(e(df_r),abs(_b[treat]/_se[treat]));

		reg `dv' treat rv rv_treat if margin < 5.0, `clust';
		matrix N`j'[`i',5]       = e(N);
		matrix B`j'[`i',5]  = _b[treat];
		matrix S`j'[`i',5] = _se[treat];
		matrix P`j'[`i',5] = 2*ttail(e(df_r),abs(_b[treat]/_se[treat]));


/* POLYNOMIAL P-VALUES */

		reg `dv' treat rv rv2 rv3 rv_treat rv_treat2 rv_treat3 if margin < 5.0, `clust';
		matrix N`j'[`i',6]       = e(N);
		matrix B`j'[`i',6]  = _b[treat];
		matrix S`j'[`i',6] = _se[treat];
		matrix P`j'[`i',6] = 2*ttail(e(df_r),abs(_b[treat]/_se[treat]));


		reg `dv' treat rv rv2 rv3 rv_treat rv_treat2 rv_treat3 if margin < 10.0, `clust';
		matrix N`j'[`i',7]       = e(N);
		matrix B`j'[`i',7]  = _b[treat];
		matrix S`j'[`i',7] = _se[treat];
		matrix P`j'[`i',7] = 2*ttail(e(df_r),abs(_b[treat]/_se[treat]));

		local j = `j' + 1;


/* FIGURE OF CHANGING BANDWIDTHS */

		capture matrix drop BB;
		matrix BB = J(100,4,.);
		forvalues k = 5(1)50 {;
			quietly {;
				scalar bandwidth = `k'/10;
				reg `dv' treat rv rv_treat if margin < bandwidth, `clust';
				local n = e(N);
				if `n' >= 60 {;
					matrix BB[`k',1] = _b[treat];
					matrix BB[`k',2] = _b[treat] + 1.96*_se[treat];
					matrix BB[`k',3] = _b[treat] - 1.96*_se[treat];
					matrix BB[`k',4] = bandwidth;
				};
			};
		};
		svmat BB;
		rename BB1 estimate;
		rename BB2 upper;
		rename BB3 lower;
		rename BB4 bandwidth;

		local nn = subinstr("`n_`i''", "~" , "" , .);
		if "`dv'" == "lag_victory" {;
			graph twoway line estimate upper lower bandwidth, lc(gs0 gs0 gs0) lp(solid dash dash) legend(off) ylabel(-1(.5)1, ang(h) nogrid)   xlabel(.5(1.5)5) graphr(c(gs16)) plotr(style(outline)) yline(0) title("`nn'", size(medsmall)) xtitle("") saving(bandwidths_`dv'_`i'.gph, replace);
		};
		if "`dv'" == "lag_rv" {;
			graph twoway line estimate upper lower bandwidth, lc(gs0 gs0 gs0) lp(solid dash dash) legend(off) ylabel(-50(25)50, ang(h) nogrid) xlabel(.5(1.5)5) graphr(c(gs16)) plotr(style(outline)) yline(0) title("`nn'", size(medsmall)) xtitle("") saving(bandwidths_`dv'_`i'.gph, replace);
		};

		drop estimate upper lower bandwidth;

	};



/* MCCRARY P-VALUES */

	count        if lag_victory == 1 & rv > -10 & rv < 10 & lag_rv >= -10 & lag_rv <= 10;
	local n = r(N);
	DCdensity rv if lag_victory == 1 & rv > -10 & rv < 10 & lag_rv >= -10 & lag_rv <= 10, breakpoint(0) generate(xj yj r0 fhat se_fhat) nograph;
	local t = r(theta)/r(se);
	matrix Mt[`i',1] = `t';
	matrix Mp[`i',1] = 2*ttail(`n',abs(`t'));
	drop xj yj r0 fhat se_fhat;

	count        if lag_victory == 0 & rv > -10 & rv < 10 & lag_rv >= -10 & lag_rv <= 10;
	local n = r(N);
	DCdensity rv if lag_victory == 0 & rv > -10 & rv < 10 & lag_rv >= -10 & lag_rv <= 10, breakpoint(0) generate(xj yj r0 fhat se_fhat) nograph;
	local t = r(theta)/r(se);
	matrix Mt[`i',2] = `t';
	matrix Mp[`i',2] = 2*ttail(`n',abs(`t'));
	drop xj yj r0 fhat se_fhat;

	gen     rv_x =  rv if lag_victory == 1;
	replace rv_x = -rv if lag_victory == 0;
	count if  rv_x > -10 & rv_x < 10 & lag_rv >= -10 & lag_rv <= 10;
	local n = r(N);
	DCdensity rv_x  if   rv_x > -10 & rv_x < 10 & lag_rv >= -10 & lag_rv <= 10, breakpoint(0) generate(xj yj r0 fhat se_fhat) nograph;
	local t = r(theta)/r(se);
	matrix Mt[`i',3] = `t';
	matrix Mp[`i',3] = 2*ttail(`n',abs(`t'));


};


svmat N1;
svmat B1;
svmat S1;
svmat P1;
svmat N2;
svmat B2;
svmat S2;
svmat P2;
svmat Mt;
svmat Mp;
drop if N11 ==.;
keep N1* B1* S1* P1* N2* B2* S2* P2* Mt* Mp*;
save tmp_estimates, replace;



/* TABLE WITH NUMBERS OF OBSERVATIONS AND PARTY OF INTEREST */

quietly {;

	capture log close;
	log using rdd_checks_output_table_1_replication.tex, text replace;

	noisily display "\begin{center}\setlength{\baselineskip}{10pt}";
	noisily display "\begin{tabular}{|l|c|c|c|c|}";
	noisily display "\hline";
	noisily display "\multirow{2}{1in}{Setting} & \multicolumn{3}{|c|}{Bandwidth} & \multirow{2}{1in}{Reference party} \\ [.05in]";
	noisily display "& \multicolumn{1}{|c}{10}  & \multicolumn{1}{|c}{2}  & \multicolumn{1}{c|}{1} & \\";
	noisily display "\hline";

	forvalues i = 1(1)21 {;

		if "`d_`i''" == "tmp_rdd_all" {;
			noisily display "\hline";
			noisily display "& & & & \\ [-.10in]";
		};
		noisily display "`n_`i'' & " %3.0f N17[`i'] " & " %3.0f N14[`i'] " & " %3.0f N13[`i'] " & `p_`i'' \\ [.03in]";

	};

	noisily display "\hline";
	noisily display "\end{tabular}";
	noisily display "\end{center}";
	log close;

};


/* TABLES WITH PLACEBO REGRESSION P-VALUES */

local thresh1 =  40;
local thresh2 =  40;
local thresh3 =  60;
local thresh4 =  60;
local thresh5 =  60;
local thresh6 = 100;
local thresh7 = 100;

local j = 1;
quietly foreach dv in lag_victory lag_rv {;

	capture log close;
	log using rdd_checks_output_table_`dv'_replication.tex, text replace;

	noisily display "\begin{center}\setlength{\baselineskip}{10pt}";
	noisily display "\begin{tabular}{|l|c|c|c|c|c|c|c|}";
	noisily display "\hline";
	noisily display "& \multicolumn{2}{|c|}{}      & \multicolumn{3}{|c|}{}             & \multicolumn{2}{|c|}{}           \\ [-.10in]";
	noisily display "& \multicolumn{2}{|c|}{Diff-in-Means} & \multicolumn{3}{|c|}{Local Linear} & \multicolumn{2}{|c|}{Polynomial} \\ [.05in]";
	noisily display "\hline";
	noisily display "& & & & & & & \\ [-.10in]";
	noisily display "\multicolumn{1}{|r|}{{\it Bandwidth} $=$} &~ {\it 0.5} ~&~ {\it 1} ~&~ {\it 1} ~&~ {\it 2} ~&~ {\it 5} ~&~ {\it 5} ~&~ {\it 10} \\ [.05in]";
	noisily display "\hline";
	noisily display "& & & & & & & \\ [-.10in]";

	forvalues i = 1(1)21 {;

		if "`d_`i''" == "tmp_rdd_all" {;
			noisily display "\hline";
			noisily display "& & & & & & & \\ [-.10in]";
		};
		noisily display "`n_`i'' " _cont;   

		forvalues k = 1(1)7 {;
			if      N`j'`k'[`i'] >= `thresh`k''  &  B`j'`k'[`i'] > 0  {;
				noisily display " & {\rm " %3.2f P`j'`k'[`i'] "}" _cont;
			};
			else if N`j'`k'[`i'] >= `thresh`k''  &  B`j'`k'[`i'] < 0  {;
				noisily display " & {\it " %3.2f P`j'`k'[`i'] "}" _cont;
			};
			else if N`j'`k'[`i'] < `thresh`k'' {;
				noisily display " & -- " _cont;				
			};
		};

		noisily display " \\ [.03in]";

	};

	noisily display "\hline";
	noisily display "\end{tabular}";
	noisily display "\end{center}";
	log close;

	local j = `j' + 1;

};


/* TABLE WITH MCCRARY TEST P-VALUES */

quietly {;

	capture log close;
	log using rdd_checks_output_table_mccrary_replication.tex, text replace;

	noisily display "\begin{center}\setlength{\baselineskip}{10pt}";
	noisily display "\begin{tabular}{|l|c|c|c|}";

	noisily display "\hline";
	noisily display "& \\ [-.10in]";
	noisily display "& Incumbent & Non-Incumb & Pooled \\ [.05in]";
	noisily display "\hline";
	noisily display "& & & \\ [-.10in]";

	forvalues i = 1(1)21 {;

		if "`d_`i''" == "tmp_rdd_all" {;
			noisily display "\hline";
			noisily display "& & & \\ [-.10in]";
		};
		noisily display "`n_`i'' " _cont;   

		if Mt1[`i'] > 0 {;
			noisily display "& {\rm " %3.2f Mp1[`i'] "}" _cont;
		};
		else if Mt1[`i'] < 0 {;
			noisily display "& {\it " %3.2f Mp1[`i'] "}" _cont;
		};

		if Mt2[`i'] > 0 {;
			noisily display "& {\it " %3.2f Mp2[`i'] "}" _cont;
		};
		else if Mt2[`i'] < 0 {;
			noisily display "& {\rm " %3.2f Mp2[`i'] "}" _cont;
		};

		if Mt3[`i'] > 0 {;
			noisily display "& {\rm " %3.2f Mp3[`i'] "} \\ [.03in]";
		};
		else if Mt3[`i'] < 0 {;
			noisily display "& {\it " %3.2f Mp3[`i'] "} \\ [.03in]";
		};

	};

	noisily display "\hline";
	noisily display "\end{tabular}";
	noisily display "\end{center}";
	log close;


};
