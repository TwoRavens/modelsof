/////////
// May 7, 2017
// Analysis of Morning Consult Data for "Explaining Immigration Preferences: Disentangling Skill and Prevalence
////////


cd "C:/~"   // set working directory

insheet	using data_jan182017.csv, clear names

/// Coding dependent variables

gen admit_bin = (nm2-2)/-1   //  Binary Admissions Measure (Q1)
gen admit_scale = (nm3-1)/6  // Continuous Admissions Measure (Q2)
gen howmanymore = (nm4-5)/-4  // How Many More? (Q3)
gen tenthousand = (nm5-5)/-4 // Admit Ten Thousand? (Q4)
gen avg = (admit_bin+admit_scale+howmanymore+tenthousand)/4 // Additive Scale of Q1-Q4

// Coding Experimental Treatments

// Country of origin

gen canada = country=="Canada"
gen mexico = country=="Mexico"
gen india = country=="India"

gen ethnicity = .
recode ethnicity (.=1) if mexico==1
recode ethnicity (.=2) if india==1
recode ethnicity (.=3) if canada==1

gen ethnicity2 = .
recode ethnicity2 (.=1) if mexico==1
recode ethnicity2 (.=2) if india==1|canada==1

// Skill level

gen high_skill = profession=="Doctor"

// Prevalence sentence presented

gen prevalence = sentence!=""

// Descriptive Statistics (Table 1)

// Full Sample (column 1)

forvalues y=0/1 {
forvalues z=0/1 {
sum admit_bin if high_skill==`y'&prevalence==`z'
}
}

// differences and p-values

reg admit_bin high_skill if prevalence==0
reg admit_bin high_skill if prevalence==1
reg admit_bin high_skill##prevalence


// Results by country (columns 2-4)

forvalues x=1/3 {
forvalues y=0/1 {
forvalues z=0/1 {
sum admit_bin if ethnicity==`x'&high_skill==`y'&prevalence==`z'
}
}
}

// differences and p-values

forvalues x=1/3 {
reg admit_bin high_skill if prevalence==0&ethnicity==`x'
reg admit_bin high_skill if prevalence==1&ethnicity==`x'
reg admit_bin high_skill##prevalence if ethnicity==`x'
}

// Balance Statistics (Online Appendices 2 and 5)

gen agecat = .
recode agecat (.=1) if demagefull>1&demagefull<14
recode agecat (.=2) if demagefull>13&demagefull<24
recode agecat (.=3) if demagefull>23&demagefull<34
recode agecat (.=4) if demagefull>33&demagefull<49
recode agecat (.=5) if demagefull>48

tab agecat high_skill, nofreq col chi2
tab agecat ethnicity, nofreq col chi2
tab agecat prevalence, nofreq col chi2

tab demgender high_skill, nofreq col chi2
tab demgender ethnicity, nofreq col chi2
tab demgender prevalence, nofreq col chi2

gen educat = .
recode educat (.=1) if demedufull==1|demedufull==2
recode educat (.=2) if demedufull==3
recode educat (.=3) if demedufull==4|demedufull==5|demedufull==6
recode educat (.=4) if demedufull==7
recode educat (.=5) if demedufull==8|demedufull==9

tab educat high_skill, nofreq col chi2
tab educat ethnicity, nofreq col chi2
tab educat prevalence, nofreq col chi2

tab demhisp high_skill, nofreq col chi2
tab demhisp ethnicity, nofreq col chi2
tab demhisp prevalence, nofreq col chi2

tab demrace high_skill, nofreq col chi2
tab demrace ethnicity, nofreq col chi2
tab demrace prevalence, nofreq col chi2

tab dempidnoln high_skill, nofreq col chi2
tab dempidnoln ethnicity, nofreq col chi2
tab dempidnoln prevalence, nofreq col chi2

// Experimental Cell Counts (Online Appendix 4)

forvalues x=1/3 {
forvalues y=0/1 {
forvalues z=0/1 {
count if ethnicity==`x'&high_skill==`y'&prevalence==`z'
}
}
}


// Test 1/2: Does the High-Skill Prevalence Vary by Prevalence and Outcome Variable? (Online Appendix 7)

foreach var of varlist avg admit_bin-tenthousand {
reg `var' high_skill if prevalence==0  
reg `var' high_skill if prevalence==0&canada==1  
reg `var' high_skill if prevalence==0&mexico==1 
reg `var' high_skill if prevalence==0&india==1 
}

foreach var of varlist avg admit_bin-tenthousand {
reg `var' i.ethnicity high_skill i.ethnicity##high_skill if prevalence==0 
}


// Test 3: Does Prevalence Information Change Skill Preference? 

// (Online Appendix 7d)

foreach var of varlist avg admit_bin-tenthousand {
reg `var' high_skill prevalence high_skill##prevalence // 
reg `var' high_skill prevalence high_skill##prevalence if canada==1 // 
reg `var' high_skill prevalence high_skill##prevalence if mexico==1 // 
reg `var' high_skill prevalence high_skill##prevalence if india==1 // 
}

// Online Appendix 7e

foreach var of varlist avg admit_bin-tenthousand {
reg `var' high_skill prevalence i.ethnicity##high_skill##prevalence
}

// Online Appendix 7f

foreach var of varlist avg admit_bin-tenthousand {
reg `var' high_skill prevalence i.ethnicity2##high_skill##prevalence
}

// Online Appendix 7c

gen prevalence2 = .
recode prevalence2 (.=0) if prevalence==0&mexico==1
recode prevalence2 (.=0) if prevalence==0&india==1
recode prevalence2 (.=0) if prevalence==0&canada==1
recode prevalence2 (.=1) if prevalence==1&mexico==1
recode prevalence2 (.=-1) if prevalence==1&india==1
recode prevalence2 (.=-1) if prevalence==1&canada==1

gen prevalence2_high_skill = prevalence2*high_skill

foreach var of varlist avg admit_bin-tenthousand {
reg `var' high_skill prevalence2 prevalence2_high_skill
}

// Online Appendix 8

polychoric admit_bin-tenthousand
















