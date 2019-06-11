*****************************************************************
****************************Do File for Political Behavior paper
*****************************************************************

*****************************************************************
****************************************************FIGURE 1
use "filepathname.dta", clear

gen eighties = 1 if year<1990
replace eighties = 0 if year>1989
gen nineties = 1 if year>1991 & year<2001
replace nineties = 0 if year<1991 | year>2001
gen thousands = 1 if year>2001
replace thousands = 0 if year<2001

count if priwin2!=.
count if genwin2!=. 
count if priwin2!=. & cfscoresdyn!=.
count if genwin2!=. & cfscoresdyn!=.

ttest cfscoresdyn if eighties==1 & party==200, by(gender)
ttest cfscoresdyn if nineties==1 & party==200, by(gender)
ttest cfscoresdyn if thousands==1 & party==200, by(gender)

ttest cfscoresdyn if eighties==1 & party==100, by(gender)
ttest cfscoresdyn if nineties==1 & party==100, by(gender)
ttest cfscoresdyn if thousands==1 & party==100, by(gender)

sum cfscoresdyn if gender==1 & party==200 & year==1980 
sum cfscoresdyn if gender==1 & party==200 & year==1990 
sum cfscoresdyn if gender==1 & party==200 & year==2000 
sum cfscoresdyn if gender==1 & party==200 & year==2010 

sum cfscoresdyn if gender==0 & party==200 & year==1980
sum cfscoresdyn if gender==0 & party==200 & year==1990
sum cfscoresdyn if gender==0 & party==200 & year==2000
sum cfscoresdyn if gender==0 & party==200 & year==2010

sum cfscoresdyn if gender==1 & party==100 & year==1980
sum cfscoresdyn if gender==1 & party==100 & year==1990
sum cfscoresdyn if gender==1 & party==100 & year==2000
sum cfscoresdyn if gender==1 & party==100 & year==2010

sum cfscoresdyn if gender==0 & party==100 & year==1980
sum cfscoresdyn if gender==0 & party==100 & year==1990
sum cfscoresdyn if gender==0 & party==100 & year==2000
sum cfscoresdyn if gender==0 & party==100 & year==2010

egen avgcfscoresdyn_repwomenpricands = mean(cfscoresdyn) if gender==1 & party==200 & priwin2!=., by(year)
egen avgcfscoresdyn_repmenpricands = mean(cfscoresdyn) if gender==0 & party==200 & priwin2!=., by(year)
egen avgcfscoresdyn_demwomenpricands = mean(cfscoresdyn) if gender==1 & party==100 & priwin2!=., by(year)
egen avgcfscoresdyn_demmenpricands = mean(cfscoresdyn) if gender==0 & party==100 & priwin2!=., by(year)

egen avgcfscoresdyn_repwomengencands = mean(cfscoresdyn) if gender==1 & party==200 & genwin2!=., by(year)
egen avgcfscoresdyn_repmengencands = mean(cfscoresdyn) if gender==0 & party==200 & genwin2!=., by(year)
egen avgcfscoresdyn_demwomengencands = mean(cfscoresdyn) if gender==1 & party==100 & genwin2!=., by(year)
egen avgcfscoresdyn_demmengencands = mean(cfscoresdyn) if gender==0 & party==100 & genwin2!=., by(year)

collapse (mean) (avgcfscoresdyn_repwomenpricands ///
	avgcfscoresdyn_repmenpricands avgcfscoresdyn_demwomenpricands avgcfscoresdyn_demmenpricands ///
	avgcfscoresdyn_repwomengencands avgcfscoresdyn_repmengencands avgcfscoresdyn_demwomengencands ///
	avgcfscoresdyn_demmengencands ), by(year)

graph twoway (line avgcfscoresdyn_repwomenpricands year, lcolor(gs1) lwidth(medthick)) ///
	(line avgcfscoresdyn_demwomenpricands year, lcolor(gs1) lwidth(medthick)) ///
	(line avgcfscoresdyn_repmenpricands year, lcolor(gs1) lwidth(medthick) lpattern(dash)) ///
	(line avgcfscoresdyn_demmenpricands year, lcolor(gs1) lwidth(medthick) lpattern(dash)), ///
	ytitle(`"Primary Election Candidate Ideology"' `"(Liberal - Conservative)"') ///
	legend(order(1 3) label(1 "Women") label(3 "Men")) ///
	text(0.6 2005 "Republicans", place(ne)) ///
	text(-0.3 1998 "Democrats", place(sw)) ///
	xtitle("") xlabel(1980(4)2012) graphregion(color(white)) 
 
graph twoway (line avgcfscoresdyn_repwomengencands year, lcolor(gs1) lwidth(medthick)) ///
	(line avgcfscoresdyn_demwomengencands year, lcolor(gs1) lwidth(medthick)) ///
	(line avgcfscoresdyn_repmengencands year, lcolor(gs1) lwidth(medthick) lpattern(dash)) ///
	(line avgcfscoresdyn_demmengencands year, lcolor(gs1) lwidth(medthick) lpattern(dash)), ///
	ytitle(`"General Election Candidate Ideology"' `"(Liberal - Conservative)"') ///
	legend(order(1 3) label(1 "Women") label(3 "Men")) ///
	text(0.6 2005 "Republicans", place(ne)) ///
	text(-0.3 1998 "Democrats", place(sw)) ///
	xtitle("") xlabel(1980(4)2012) graphregion(color(white)) 

*****************************************************************
****************************************************TABLE 1
use "filepathname.dta", clear

*****DV: Win Primary
reg priwin2 c.cfscoresdyn##i.gender i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts i.extremedummy3  c.reppresvs2  ///
	cycledummy1-cycledummy17 statedummy1-statedummy50 if priuo!=1 & rep==1 & pripct2!=1 & pripct2!=.,  robust cluster(stcdyr2pty)
reg priwin2 c.cfscoresdyn##i.gender i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts i.extremedummy3 c.reppresvs2  ///
	cycledummy1-cycledummy17 statedummy1-statedummy50 if priuo!=1 & rep==0 & pripct2!=1 & pripct2!=. & statedummy28!=1, robust cluster(stcdyr2pty)

*REPUBLICANS
reg priwin2 c.cfscoresdyn##i.gender i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts i.extremedummy3 c.reppresvs2  ///
	cycledummy1-cycledummy17 statedummy1-statedummy50  if priuo!=1 & rep==1 & pripct2!=1 & pripct2!=.,  robust cluster(stcdyr2pty)

*FIGURE 2
margins, atmeans at(cfscoresdyn=(0(.05)1.5) incum10=0 extremedummy3=0 gender=0)
marginsplot, xlabel(0(.3)1.5, labsize(small)) yline(0) scheme(s1manual) ///
recast(line) recastci(rarea)   ///
	xlabel(0.2(.4)1.4) yline(0, lcolor(black)) ylabel(.3(.05).5, axis(1)) ///
	ytitle("Probability of Primary Election Victory", axis(1) size(small))  ///
	xtitle("Candidate Ideology" "(Liberal - Conservative)", size(small)) title(" ")
	
margins, atmeans at(cfscoresdyn=(0(.05)1.5) incum10=0 extremedummy3=0 gender=1)
marginsplot, xlabel(0(.3)1.5, labsize(small)) yline(0) scheme(s1manual) ///
recast(line) recastci(rarea)   ///
	xlabel(0.2(.4)1.4) yline(0, lcolor(black)) ylabel(.3(.05).5, axis(1)) ///
	ytitle("Probability of Primary Election Victory", axis(1) size(small))  ///
	xtitle("Candidate Ideology" "(Liberal - Conservative)", size(small)) title(" ")
 
margins, atmeans at(cfscoresdyn=(0.5 1.09) incum10=0 extremedummy3=0 gender=0) 
margins, atmeans at(cfscoresdyn=(0.31 1.13) incum10=0 extremedummy3=0 gender=1)

sum cfscoresdyn if e(sample), d
sum npricands10 if e(sample), d
sum logcandreceipts if e(sample), d
sum reppresvs2 if e(sample), d
sum cfscoresdyn if e(sample) & gender==1, d
sum cfscoresdyn if e(sample) & gender==0, d

margins, atmeans at(cfscoresdyn=(.96 1.5) incum10=0 extremedummy3=0 gender=0)
margins, atmeans at(npricands10=(3.86 6.21) incum10=0 extremedummy3=0 gender=0)
margins, atmeans at(logcandreceipts=(11.52 14.28) incum10=0 extremedummy3=0 gender=0)
margins, atmeans at(reppresvs2=(5.19 6.35) incum10=0 extremedummy3=0 gender=0)
margins, atmeans at(incum10=(0 1) extremedummy3=0 gender=0)
margins, atmeans at(cfscoresdyn=.93 gender=1 extremedummy3=0 incum10=0)
margins, atmeans at(cfscoresdyn=.97 gender=0 extremedummy3=0 incum10=0)

*DEMOCRATS
reg priwin2 c.cfscoresdyn##i.gender i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts i.extremedummy3 c.reppresvs2  ///
	cycledummy1-cycledummy17 statedummy1-statedummy50 if priuo!=1 & rep==0 & pripct2!=1 & pripct2!=. & statedummy28!=1, robust cluster(stcdyr2pty)

*FIGURE 2
margins, atmeans at(cfscoresdyn=(-1.5(.05)0) incum10=0 extremedummy3=0 gender=0)
marginsplot, xlabel(-1.5(.3)-.2, labsize(small)) yline(0) scheme(s1manual) ///
recast(line) recastci(rarea)   ///
	xlabel(-1.4(.4)-.2) yline(0, lcolor(black)) ylabel(.35(.05).60, axis(1)) ///
	ytitle("Probability of Primary Election Victory", axis(1) size(small))  ///
	xtitle("Candidate Ideology" "(Liberal - Conservative)", size(small))  title(" ")

margins, atmeans at(cfscoresdyn=(-1.5(.05)0) incum10=0 extremedummy3=0 gender=1)
marginsplot, xlabel(-1.5(.3)-.2, labsize(small)) yline(0) scheme(s1manual) ///
recast(line) recastci(rarea)   ///
	xlabel(-1.4(.4)-.2) yline(0, lcolor(black)) ylabel(.35(.05).60, axis(1)) ///
	ytitle("Probability of Primary Election Victory", axis(1) size(small))  ///
	xtitle("Candidate Ideology" "(Liberal - Conservative)", size(small)) title(" ") 
 
margins, atmeans at(cfscoresdyn=(-1.13 -0.58) incum10=0 extremedummy3=0 gender=0) 
margins, atmeans at(cfscoresdyn=(-1.02 -0.52) incum10=0 extremedummy3=0 gender=1)

sum cfscoresdyn if e(sample), d
sum npricands10 if e(sample), d
sum logcandreceipts if e(sample), d
sum reppresvs2 if e(sample), d
sum cfscoresdyn if e(sample) & gender==1, d
sum cfscoresdyn if e(sample) & gender==0, d

margins, atmeans at(cfscoresdyn=(-0.68 .02) incum10=0 extremedummy3=0 gender=0)
margins, atmeans at(npricands10=(3.58 5.88) incum10=0 extremedummy3=0 gender=0)
margins, atmeans at(logcandreceipts=(11.52 14.34) incum10=0 extremedummy3=0 gender=0)
margins, atmeans at(reppresvs2=(4.68 6.13) incum10=0 extremedummy3=0 gender=0)
margins, atmeans at(cfscoresdyn=-.94 gender=1 extremedummy3=0 incum10=0)
margins, atmeans at(cfscoresdyn=-.62 gender=0 extremedummy3=0 incum10=0)

*****DV: Win General Election
reg genwin2 c.cfscoresdyn##i.gender i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts i.extremedummy3  c.reppresvs2 ///
	cycledummy1-cycledummy17 statedummy1-statedummy50 if genuo!=1 & rep==1 & genpct!=1 & genpct!=. 
reg genwin2 c.cfscoresdyn##i.gender i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts i.extremedummy3  c.reppresvs2  ///
	cycledummy1-cycledummy17 statedummy1-statedummy50 if genuo!=1 & rep==0 & genpct!=1 & genpct!=. 
	
*REPUBLICANS
reg genwin2 c.cfscoresdyn##i.gender i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts i.extremedummy3 c.reppresvs2  ///
	cycledummy1-cycledummy17 statedummy1-statedummy50 if genuo!=1 & rep==1 & genpct!=1 & genpct!=.

*FIGURE 3
margins, atmeans at(cfscoresdyn=(0.2(.05)1.5) incum10=0 extremedummy3=0 gender=0)
marginsplot, xlabel(-1.5(.05)0, labsize(small)) scheme(s1manual) ///
recast(line) recastci(rarea)   ///
	xlabel(0.2(.4)1.5)  ylabel(.1(.1).35, axis(1)) ///
	ytitle("Probability of General Election Victory", axis(1) size(vsmall))  ///
	xtitle("Candidate Ideology" "(Liberal - Conservative)", size(small)) title(" ")
	
margins, atmeans at(cfscoresdyn=(0.2(.05)1.5) incum10=0 extremedummy3=0 gender=1)
marginsplot, xlabel(-1.5(.05)0, labsize(small)) scheme(s1manual) ///
recast(line) recastci(rarea)   ///
	xlabel(0.2(.4)1.5) ylabel(.1(.1).35, axis(1)) ///
	ytitle("Probability of General Election Victory", axis(1) size(vsmall))  ///
	xtitle("Candidate Ideology" "(Liberal - Conservative)", size(small)) title(" ") 
 
margins, atmeans at(cfscoresdyn=(0.5 1.09) incum10=0 extremedummy3=0 gender=0) 
margins, atmeans at(cfscoresdyn=(0.31 1.13) incum10=0 extremedummy3=0 gender=1)
	 
sum cfscoresdyn if e(sample), d
sum logcandreceipts if e(sample), d
sum reppresvs2 if e(sample), d
sum cfscoresdyn if e(sample) & gender==1, d
sum cfscoresdyn if e(sample) & gender==0, d

margins, atmeans at(cfscoresdyn=(.89 1.25) incum10=0 extremedummy3=0 gender=0)
margins, atmeans at(logcandreceipts=(12.32 14.78) incum10=0 extremedummy3=0 gender=0)
margins, atmeans at(reppresvs2=(5.17 6.4) incum10=0 extremedummy3=0 gender=0)
margins, atmeans at(incum10=(0 1) extremedummy3=0 gender=0)
margins, atmeans at(cfscoresdyn=.86 gender=1 extremedummy3=0 incum10=0)
margins, atmeans at(cfscoresdyn=.89 gender=0 extremedummy3=0 incum10=0)

*DEMOCRATS
reg genwin2 c.cfscoresdyn##i.gender  i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts i.extremedummy3 c.reppresvs2  ///
	cycledummy1-cycledummy17 statedummy1-statedummy50 if genuo!=1 & rep==0 & genpct!=1 & genpct!=.

*FIGURE 3 
margins, atmeans at(cfscoresdyn=(-1.5(.05)-.2) ///
	incum10=0 extremedummy3=0 gender=0)
marginsplot, xlabel(-1.5(.05)0, labsize(small)) scheme(s1manual) ///
recast(line) recastci(rarea)   ///
	xlabel(-1.4(.4)-.3) ylabel(.1(.1).35, axis(1)) ///
	ytitle("Probability of General Election Victory", axis(1) size(small))  ///
	xtitle("Candidate Ideology" "(Liberal - Conservative)", size(small)) title(" ")
 
margins, atmeans at(cfscoresdyn=(-1.5(.05)-.2) ///
	incum10=0 extremedummy3=0 gender=1)
marginsplot, xlabel(-1.5(.05)-.2, labsize(small))  scheme(s1manual) ///
recast(line) recastci(rarea)   ///
	xlabel(-1.4(.4)-.3) ylabel(.1(.1).35, axis(1)) ///
	ytitle("Probability of General Election Victory", axis(1) size(small))  ///
	xtitle("Candidate Ideology" "(Liberal - Conservative)", size(small)) title(" ")
 
margins, atmeans at(cfscoresdyn=(-1.13 -0.58) incum10=0 extremedummy3=0 gender=0) 
margins, atmeans at(cfscoresdyn=(-1.02 -0.52) incum10=0 extremedummy3=0 gender=1)
	 
sum cfscoresdyn if e(sample), d
sum logcandreceipts if e(sample), d
sum reppresvs2 if e(sample), d
sum cfscoresdyn if e(sample) & gender==1, d
sum cfscoresdyn if e(sample) & gender==0, d

margins, atmeans at(cfscoresdyn=(-.72 -.28) incum10=0 extremedummy3=0 gender=0)
margins, atmeans at(logcandreceipts=(12.40 14.55) incum10=0 extremedummy3=0 gender=0)
margins, atmeans at(reppresvs2=(4.9 6.3) incum10=0 extremedummy3=0 gender=0)
margins, atmeans at(incum10=(0 1) extremedummy3=0 gender=0)
margins, atmeans at(cfscoresdyn=-.96 gender=1 extremedummy3=0 incum10=0)
margins, atmeans at(cfscoresdyn=-.67 gender=0 extremedummy3=0 incum10=0)

*****************************************************************
****************************************************TABLE 2
use "filepathname.dta", clear
drop if cfscoresdyn==.
keep if incumchall10=="O"

egen ideocat = cut(moderate_dyn) if party==100, group(5)
ttest moderate_dyn if ideocat==0, by(gender)
ttest moderate_dyn if ideocat==1, by(gender)
ttest moderate_dyn if ideocat==2, by(gender)
ttest moderate_dyn if ideocat==3, by(gender)
ttest moderate_dyn if ideocat==4, by(gender)

egen ideocat2 = cut(moderate_dyn) if party==200, group(5)
ttest moderate_dyn if ideocat2==0, by(gender)
ttest moderate_dyn if ideocat2==1, by(gender)
ttest moderate_dyn if ideocat2==2, by(gender)
ttest moderate_dyn if ideocat2==3, by(gender)
ttest moderate_dyn if ideocat2==4, by(gender)

replace ideocat = ideocat2 if party==200 & ideocat==.
egen totalwomeninrace = total(gender), by(stcdyr2 party)
drop if totalwomeninrace==0

egen rankideocat = rank(moderate_dyn) if gender==1, by(stcdyr2 party)
egen ideocat_a = mean(ideocat) if rankideocat==1, by(stcdyr2 party)
egen ideocat_b = mean(ideocat) if rankideocat==2, by(stcdyr2 party)
egen ideocat_c = mean(ideocat) if rankideocat==3, by(stcdyr2 party)
egen ideocat_d = mean(ideocat) if rankideocat==4, by(stcdyr2 party)
egen ideocat_e = mean(ideocat) if rankideocat==5, by(stcdyr2 party)
egen maxideocat_a = max(ideocat_a), by(stcdyr2 party)
egen maxideocat_b = max(ideocat_b), by(stcdyr2 party)
egen maxideocat_c = max(ideocat_c), by(stcdyr2 party)
egen maxideocat_d = max(ideocat_d), by(stcdyr2 party)
egen maxideocat_e = max(ideocat_e), by(stcdyr2 party)

gen matchawoman = 1 if ideocat==maxideocat_a | ideocat==maxideocat_b | ideocat==maxideocat_c | ideocat==maxideocat_d | ideocat==maxideocat_e
sort year state district party

keep if matchawoman==1 
egen totalmatchawoman = total(matchawoman), by(stcdyr2 party)
drop if totalmatchawoman==1
egen totalwomeninrace2 = total(gender), by(stcdyr2 party)
drop if totalmatchawoman==totalwomeninrace2

egen rankideocat_man = rank(moderate_dyn) if gender==0, by(stcdyr2 party)
egen ideocat_mana = mean(ideocat) if rankideocat_man==1, by(stcdyr2 party)
egen ideocat_manb = mean(ideocat) if rankideocat_man==2, by(stcdyr2 party)
egen ideocat_manc = mean(ideocat) if rankideocat_man==3, by(stcdyr2 party)
egen ideocat_mand = mean(ideocat) if rankideocat_man==4, by(stcdyr2 party)
egen ideocat_mane = mean(ideocat) if rankideocat_man==5, by(stcdyr2 party)
egen ideocat_manf = mean(ideocat) if rankideocat_man==6, by(stcdyr2 party)
egen ideocat_mang = mean(ideocat) if rankideocat_man==7, by(stcdyr2 party)

egen maxideocat_mana = max(ideocat_mana), by(stcdyr2 party)
egen maxideocat_manb = max(ideocat_manb), by(stcdyr2 party)
egen maxideocat_manc = max(ideocat_manc), by(stcdyr2 party)
egen maxideocat_mand = max(ideocat_mand), by(stcdyr2 party)
egen maxideocat_mane = max(ideocat_mane), by(stcdyr2 party)
egen maxideocat_manf = max(ideocat_manf), by(stcdyr2 party)
egen maxideocat_mang = max(ideocat_mang), by(stcdyr2 party)

gen matchaman = 1 if ideocat==maxideocat_mana | ideocat==maxideocat_manb | ideocat==maxideocat_manc | ideocat==maxideocat_mand | ///
	ideocat==maxideocat_mane | ideocat==maxideocat_manf | ideocat==maxideocat_mang 
drop if matchaman==.

egen totalwomeninrace3 = total(gender), by(stcdyr2 party)
drop if totalwomeninrace3==0
tab ideocat, gen(ideocatdummy)

reg priwin2 gender c.npricands10 logcandreceipts ideocatdummy1-ideocatdummy5 if rep==1
reg priwin2 gender c.npricands10 logcandreceipts ideocatdummy1-ideocatdummy5 if rep==0

*****************************************************************
****************************************************DESCRIPTIVE STATISTICS AND PARTISAN DIFFERENCES
use "filepathname.dta", clear

*REPUBLICANS
reg priwin2 c.cfscoresdyn##i.gender i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts i.extremedummy3 c.reppresvs2 ///
	cycledummy1-cycledummy17 statedummy1-statedummy50  if priuo!=1 & rep==1 & pripct2!=1 & pripct2!=.,  robust cluster(stcdyr2pty)
ttest priwin2 if e(sample) & incum10==0, by(gender)
count if e(sample) & gender==1
count if e(sample) & gender==1 & priwin2==1
count if e(sample) & gender==0
count if e(sample)

*DEMOCRATS
reg priwin2 c.cfscoresdyn##i.gender i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts i.extremedummy3 c.reppresvs2  ///
	cycledummy1-cycledummy17  statedummy1-statedummy50 if priuo!=1 & rep==0 & pripct2!=1 & pripct2!=. & statedummy28!=1, robust cluster(stcdyr2pty)
ttest priwin2 if e(sample) & incum10==0, by(gender)
count if e(sample) & gender==1
count if e(sample) & gender==1 & priwin2==1
count if e(sample) & gender==0
count if e(sample)

*ttests of win rates by group
reg priwin2 c.cfscoresdyn##i.gender i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts i.extremedummy3 c.reppresvs2  ///
	cycledummy1-cycledummy17 statedummy1-statedummy50 if priuo!=1 & pripct2!=1 & pripct2!=.,  robust cluster(stcdyr2pty)

gen gopmen = 1 if gender==0 & rep==1 & e(sample)
replace gopmen = 0 if gender==1 & rep==0 & e(sample)
gen gopwomen = 1 if gender==1 & rep==1 & e(sample)
replace gopwomen = 0 if gender==1 & rep==0 & e(sample)
gen demmen = 1 if gender==0 & rep==0 & e(sample)
replace demmen = 0 if gender==1 & rep==0 & e(sample)

ttest priwin2 if incum10==0 & e(sample), by(gopmen)
ttest priwin2 if incum10==0 & e(sample), by(gopwomen)
ttest priwin2 if incum10==0 & e(sample), by(demmen)

use "filepathname.dta", clear

reg genwin2 c.cfscoresdyn##i.gender  i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts i.extremedummy3 c.reppresvs2  ///
	cycledummy1-cycledummy17 statedummy1-statedummy50 if genuo!=1 & genpct!=1 & genpct!=.
ttest genwin2 if incum10==0 & e(sample) & rep==1, by(gender)
ttest genwin2 if incum10==1 & e(sample) & rep==1, by(gender)
ttest genwin2 if incum10==0 & e(sample) & rep==0, by(gender)
ttest genwin2 if incum10==1 & e(sample) & rep==0, by(gender)

gen gopmen = 1 if gender==0 & rep==1 & e(sample)
replace gopmen = 0 if gender==1 & rep==0 & e(sample)
gen gopwomen = 1 if gender==1 & rep==1 & e(sample)
replace gopwomen = 0 if gender==1 & rep==0 & e(sample)
gen demmen = 1 if gender==0 & rep==0 & e(sample)
replace demmen = 0 if gender==1 & rep==0 & e(sample)

ttest genwin2 if incum10==0 & e(sample), by(gopmen)
ttest genwin2 if incum10==0 & e(sample), by(gopwomen)
ttest genwin2 if incum10==0 & e(sample), by(demmen)

*****************************************************************
*****************************************************************
*****************************APPENDIX 
use "filepathname.dta", clear

*Table A1
reg priwin2 c.cfscoresdyn##i.gender i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts i.extremedummy3 c.reppresvs2 perioddummy1-perioddummy3 ///
	cycledummy1-cycledummy17 statedummy1-statedummy50  if priuo!=1 & rep==1 & pripct2!=1 & pripct2!=.,  robust cluster(stcdyr2pty)
reg priwin2  c.cfscoresdyn##i.gender  i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts i.extremedummy3 c.reppresvs2 perioddummy1-perioddummy3 ///
	cycledummy1-cycledummy17 statedummy1-statedummy50 if priuo!=1 & rep==0 & pripct2!=1 & pripct2!=. & statedummy28!=1, robust cluster(stcdyr2pty)
reg genwin2 c.cfscoresdyn##i.gender i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts i.extremedummy3 c.reppresvs2 perioddummy1-perioddummy3 ///
	cycledummy1-cycledummy17 statedummy1-statedummy50 if genuo!=1 & rep==1 & genpct!=1 & genpct!=.
reg genwin2  c.cfscoresdyn##i.gender i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts i.extremedummy3 c.reppresvs2 perioddummy1-perioddummy3 ///
	cycledummy1-cycledummy17 statedummy1-statedummy50 if genuo!=1 & rep==0 & genpct!=1 & genpct!=.

*Table A2
gen presyear = 1 if year==1980 | year==1984 | year==1988 | year==1992 | year==1996 | ///
	year==2000 | year==2004 | year==2008 | year==2012
replace presyear = 0 if presyear==.

gen south = 1 if state=="AL" | state=="AR" | state=="FL" | state=="GA" | state=="LA" | ///
	state=="MS" | state=="NC" | state=="SC" | state=="TN" | state=="TX" | state=="VA"
replace south = 0 if south==.

reg priwin2 c.cfscoresdyn##i.gender i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts i.extremedummy3 c.reppresvs2 presyear south ///
	cycledummy1-cycledummy17 statedummy1-statedummy50 if priuo!=1 & rep==1 & pripct2!=1 & pripct2!=., robust cluster(stcdyr2pty)
reg priwin2 c.cfscoresdyn##i.gender  i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts i.extremedummy3 c.reppresvs2 presyear south ///
	cycledummy1-cycledummy17 statedummy1-statedummy50 if priuo!=1 & rep==0 & pripct2!=1 & pripct2!=. & statedummy28!=1, robust cluster(stcdyr2pty)
reg genwin2 c.cfscoresdyn##i.gender i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts i.extremedummy3 c.reppresvs2 presyear south ///
	cycledummy1-cycledummy17 statedummy1-statedummy50 if genuo!=1 & rep==1 & genpct!=1 & genpct!=.
reg genwin2 c.cfscoresdyn##i.gender i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts i.extremedummy3 c.reppresvs2 presyear south ///
	cycledummy1-cycledummy17 statedummy1-statedummy50 if genuo!=1 & rep==0 & genpct!=1 & genpct!=.
	
*Table A3
logit priwin2 c.cfscoresdyn##i.gender i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts i.extremedummy3 c.reppresvs2 ///
	cycledummy1-cycledummy17 statedummy1-statedummy50  if priuo!=1 & rep==1 & pripct2!=1 & pripct2!=.,  robust cluster(stcdyr2pty)
logit priwin2  c.cfscoresdyn##i.gender  i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts i.extremedummy3 c.reppresvs2  ///
	cycledummy1-cycledummy17  statedummy1-statedummy50 if priuo!=1 & rep==0 & pripct2!=1 & pripct2!=. & statedummy28!=1, robust cluster(stcdyr2pty)
logit genwin2 c.cfscoresdyn##i.gender i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts i.extremedummy3 c.reppresvs2  ///
	cycledummy1-cycledummy17 statedummy2-statedummy48 if genuo!=1 & rep==1 & genpct!=1 & genpct!=.
logit genwin2  c.cfscoresdyn##i.gender i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts i.extremedummy3 c.reppresvs2  ///
	cycledummy1-cycledummy17 statedummy2-statedummy48 if genuo!=1 & rep==0 & genpct!=1 & genpct!=.

*Table A4
reg priwin2 c.cfscoresdyn##i.gender i.incum10 ///
	 if priuo!=1 & rep==1 & pripct2!=1 & pripct2!=.,  robust cluster(stcdyr2pty)
reg priwin2 c.cfscoresdyn##i.gender i.incum10 ///
	 if priuo!=1 & rep==0 & pripct2!=1 & pripct2!=.,  robust cluster(stcdyr2pty)
reg genwin2 c.cfscoresdyn##i.gender i.incum10 ///
	 if genuo!=1 & rep==1 & genpct!=1 & genpct!=.
reg genwin2 c.cfscoresdyn##i.gender i.incum10 ///
	 if genuo!=1 & rep==0 & genpct!=1 & genpct!=.

*Table A5
reg pripct2 c.cfscoresdyn##i.gender i.incum10  ///
	c.npricands10##c.npricands10 logcandreceipts i.extremedummy3 c.reppresvs2  ///
	cycledummy1-cycledummy17 statedummy1-statedummy50  if priuo!=1 & rep==1 & pripct2!=1 & pripct2!=., robust cluster(stcdyr2pty)
reg pripct2  c.cfscoresdyn##i.gender  i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts i.extremedummy3 c.reppresvs2  ///
	cycledummy1-cycledummy17  statedummy1-statedummy50  if priuo!=1 & rep==0 & pripct2!=1 & pripct2!=. & statedummy28!=1, robust cluster(stcdyr2pty)
reg genpct c.cfscoresdyn##i.gender i.incum10  ///
	c.npricands10##c.npricands10 logcandreceipts i.extremedummy3 c.reppresvs2  ///
	cycledummy1-cycledummy17 statedummy1-statedummy50  if genuo!=1 & rep==1 & genpct!=1 & genpct!=., robust cluster(stcdyr2pty)
reg genpct  c.cfscoresdyn##i.gender  i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts i.extremedummy3 c.reppresvs2  ///
	cycledummy1-cycledummy17  statedummy1-statedummy50  if genuo!=1 & rep==0 & genpct!=1 & genpct!=., robust cluster(stcdyr2pty)

*Table A6
reg priwin2 c.cfscoresdyn##i.gender qual2 ///
	c.npricands10##c.npricands10 i.extremedummy3 c.reppresvs2 ///
	cycledummy11-cycledummy17  statedummy2-statedummy25 statedummy27 statedummy29-statedummy43 statedummy45-statedummy50 ///
	if priuo!=1 & rep==1 & pripct2!=1 & pripct2!=. & year>1999 & year<2011 & incum10==0, robust cluster(stcdyr2pty)
reg priwin2  c.cfscoresdyn##i.gender  qual2 ///
	c.npricands10##c.npricands10 i.extremedummy3 c.reppresvs2 ///
	cycledummy11-cycledummy17 statedummy1-statedummy6 statedummy8-statedummy50 ///
	if priuo!=1 & rep==0 & pripct2!=1 & pripct2!=. & year>1999 & year<2011 & incum10==0, robust cluster(stcdyr2pty)

*Table A7
reg priwin2 i.gender i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts i.extremedummy3  c.reppresvs2  ///
	cycledummy1-cycledummy17 statedummy1-statedummy50 if priuo!=1 & rep==1 & pripct2!=1 & pripct2!=.,  robust cluster(stcdyr2pty)
reg priwin2 c.cfscoresdyn i.gender  i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts i.extremedummy3  c.reppresvs2  ///
	cycledummy1-cycledummy17 statedummy1-statedummy50 if priuo!=1 & rep==1 & pripct2!=1 & pripct2!=.,  robust cluster(stcdyr2pty)
reg priwin2 i.gender i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts i.extremedummy3 c.reppresvs2  ///
	cycledummy1-cycledummy17 statedummy1-statedummy50 if priuo!=1 & rep==0 & pripct2!=1 & pripct2!=. & statedummy28!=1, robust cluster(stcdyr2pty)
reg priwin2 i.gender c.cfscoresdyn i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts i.extremedummy3 c.reppresvs2  ///
	cycledummy1-cycledummy17 statedummy1-statedummy50 if priuo!=1 & rep==0 & pripct2!=1 & pripct2!=. & statedummy28!=1, robust cluster(stcdyr2pty)

*Table A8
reg genwin2 i.gender i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts i.extremedummy3  c.reppresvs2 ///
	cycledummy1-cycledummy17 statedummy1-statedummy50 if genuo!=1 & rep==1 & genpct!=1 & genpct!=. 
reg genwin2 c.cfscoresdyn i.gender  i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts i.extremedummy3  c.reppresvs2 ///
	cycledummy1-cycledummy17 statedummy1-statedummy50 if genuo!=1 & rep==1 & genpct!=1 & genpct!=.
reg genwin2 i.gender i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts i.extremedummy3  c.reppresvs2  ///
	cycledummy1-cycledummy17 statedummy1-statedummy50 if genuo!=1 & rep==0 & genpct!=1 & genpct!=. 
reg genwin2 c.cfscoresdyn i.gender  i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts i.extremedummy3  c.reppresvs2  ///
	cycledummy1-cycledummy17 statedummy1-statedummy50 if genuo!=1 & rep==0 & genpct!=1 & genpct!=. 

*Figures A1 and A2
*REPUBLICANS
reg priwin2 c.cfscoresdyn##i.gender i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts i.extremedummy3 c.reppresvs2  ///
	cycledummy1-cycledummy17 statedummy1-statedummy50  if priuo!=1 & rep==1 & pripct2!=1 & pripct2!=.,  robust cluster(stcdyr2pty)

*marginal effect of conservatism
margins, atmeans dydx(cfscoresdyn) at(gender=(0 1) incum10=0 extremedummy3=0) 
marginsplot, xlabel(-.2 1.2, labsize(small)) recast(scatter) scheme(s1manual)  ///
	xlabel(-.5 " " 0 "Male Candidates" 1 "Female Candidates" 1.5 " ", labsize(medium)  notick) ///
	yline(0, lcolor(black)) ylabel(0(.05).1, axis(1)) ///
	ytitle("Marginal Effect of Conservatism" "on Primary Election Victory", axis(1) size(medium))  ///
	xtitle(" ") title(" ") 

*DEMOCRATS
reg priwin2 c.cfscoresdyn##i.gender i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts i.extremedummy3 c.reppresvs2  ///
	cycledummy1-cycledummy17 statedummy1-statedummy50 if priuo!=1 & rep==0 & pripct2!=1 & pripct2!=. & statedummy28!=1, robust cluster(stcdyr2pty)

*marginal effect of conservatism
margins, atmeans dydx(cfscoresdyn) at(gender=(0 1) incum10=0 extremedummy3=0) 
marginsplot, xlabel(-.2 1.2, labsize(small)) recast(scatter) scheme(s1manual)  ///
	xlabel(-.5 " " 0 "Male Candidates" 1 "Female Candidates" 1.5 " ", labsize(medium)  notick) ///
	yline(0, lcolor(black)) ylabel(-.1(.05)0, axis(1)) ///
	ytitle("Marginal Effect of Conservatism" "on Primary Election Victory", axis(1) size(medium))  ///
	xtitle(" ") title(" ") 

*Figure A3
*Republicans, Primary
reg priwin2 c.cfscoresdyn##i.gender i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2 extremedummy3    ///
	if priuo!=1 & rep==1 & pripct2!=1 & pripct2!=. & cycledummy1==1
est store m1980

reg priwin2 c.cfscoresdyn##i.gender i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2 extremedummy3    ///
	if priuo!=1 & rep==1 & pripct2!=1 & pripct2!=. & cycledummy2==1
est store m1982

reg priwin2 c.cfscoresdyn##i.gender  ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2 extremedummy3    ///
	if priuo!=1 & rep==1 & pripct2!=1 & pripct2!=. & cycledummy3==1
est store m1984
 
reg priwin2 c.cfscoresdyn##i.gender i.incum10  ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2 extremedummy3    ///
	if priuo!=1 & rep==1 & pripct2!=1 & pripct2!=. & cycledummy4==1
est store m1986
 
reg priwin2 c.cfscoresdyn##i.gender i.incum10   ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2 extremedummy3    ///
	if priuo!=1 & rep==1 & pripct2!=1 & pripct2!=. & cycledummy5==1
est store m1988
 
reg priwin2 c.cfscoresdyn##i.gender i.incum10   ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2 extremedummy3    ///
	if priuo!=1 & rep==1 & pripct2!=1 & pripct2!=. & cycledummy6==1
est store m1990

reg priwin2 c.cfscoresdyn##i.gender i.incum10   ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2 extremedummy3    ///
	if priuo!=1 & rep==1 & pripct2!=1 & pripct2!=. & cycledummy7==1
est store m1992

reg priwin2 c.cfscoresdyn##i.gender i.incum10   ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2     ///
	if priuo!=1 & rep==1 & pripct2!=1 & pripct2!=. & cycledummy8==1
est store m1994

reg priwin2 c.cfscoresdyn##i.gender    ///
	  c.npricands10##c.npricands10 logcandreceipts c.reppresvs2 extremedummy3    ///
	if priuo!=1 & rep==1 & pripct2!=1 & pripct2!=. & cycledummy9==1
est store m1996
 
reg priwin2 c.cfscoresdyn##i.gender i.incum10   ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2     ///
	if priuo!=1 & rep==1 & pripct2!=1 & pripct2!=. & cycledummy10==1
est store m1998
 
reg priwin2 c.cfscoresdyn##i.gender i.incum10   ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2 extremedummy3    ///
	if priuo!=1 & rep==1 & pripct2!=1 & pripct2!=. & cycledummy11==1
est store m2000

reg priwin2 c.cfscoresdyn##i.gender i.incum10   ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2     ///
	if priuo!=1 & rep==1 & pripct2!=1 & pripct2!=. & cycledummy12==1
est store m2002

reg priwin2 c.cfscoresdyn##i.gender i.incum10   ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2 extremedummy3    ///
	if priuo!=1 & rep==1 & pripct2!=1 & pripct2!=. & cycledummy13==1
est store m2004
 
reg priwin2 c.cfscoresdyn##i.gender i.incum10   ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2 extremedummy3    ///
	if priuo!=1 & rep==1 & pripct2!=1 & pripct2!=. & cycledummy14==1
est store m2006
 
reg priwin2 c.cfscoresdyn##i.gender i.incum10   ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2 extremedummy3    ///
	if priuo!=1 & rep==1 & pripct2!=1 & pripct2!=. & cycledummy15==1
est store m2008
 
reg priwin2 c.cfscoresdyn##i.gender i.incum10   ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2 extremedummy3    ///
	if priuo!=1 & rep==1 & pripct2!=1 & pripct2!=. & cycledummy16==1
est store m2010
 
reg priwin2 c.cfscoresdyn##i.gender i.incum10   ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2 extremedummy3    ///
	if priuo!=1 & rep==1 & pripct2!=1 & pripct2!=. & cycledummy17==1
est store m2012
 
coefplot m1980 || m1982 || m1984 || m1986 || m1988 || m1990 || m1992 || m1994 || m1996 || m1998 || m2000 || m2002 || ///
	m2004 || m2006 || m2008 || m2010 || m2012, mcolor(black) ///
	keep(1.gender#c.cfscoresdyn) yline(0) ytitle("Coefficient") vertical bycoefs byopts(yrescale) xtitle("") xlabel(1 "1980" 3 "1984" 5 "1988" ///
	7 "1992" 9 "1996" 11 "2000" 13 "2004" 15 "2008" 17 "2012")

drop _est_m1980 _est_m1980 _est_m1982 _est_m1984 _est_m1986 _est_m1988 _est_m1990 _est_m1992 ///
 _est_m1994 _est_m1996 _est_m1998 _est_m2000 _est_m2002 _est_m2004 _est_m2006 _est_m2008 _est_m2010 _est_m2012

*Republicans, General
reg genwin2 c.cfscoresdyn##i.gender i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2 extremedummy3 ///
	if genuo!=1 & rep==1 & genpct!=1 & genpct!=. & cycledummy1==1
est store m1980
 
reg genwin2 c.cfscoresdyn##i.gender i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2 extremedummy3 ///
	if genuo!=1 & rep==1 & genpct!=1 & genpct!=. & cycledummy2==1
est store m1982
 
reg genwin2 c.cfscoresdyn##i.gender i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2 extremedummy3 ///
	if genuo!=1 & rep==1 & genpct!=1 & genpct!=. & cycledummy3==1
est store m1984
 
reg genwin2 c.cfscoresdyn##i.gender i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2 extremedummy3 ///
	if genuo!=1 & rep==1 & genpct!=1 & genpct!=. & cycledummy4==1
est store m1986
 
reg genwin2 c.cfscoresdyn##i.gender i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2 extremedummy3 ///
	if genuo!=1 & rep==1 & genpct!=1 & genpct!=. & cycledummy5==1
est store m1988
 
reg genwin2 c.cfscoresdyn##i.gender i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2 ///
	if genuo!=1 & rep==1 & genpct!=1 & genpct!=. & cycledummy6==1
est store m1990
 
reg genwin2 c.cfscoresdyn##i.gender i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2  ///
	if genuo!=1 & rep==1 & genpct!=1 & genpct!=. & cycledummy7==1
est store m1992

reg genwin2 c.cfscoresdyn##i.gender  ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2  ///
	if genuo!=1 & rep==1 & genpct!=1 & genpct!=. & cycledummy8==1
est store m1994
 
reg genwin2 c.cfscoresdyn##i.gender i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2 extremedummy3 ///
	if genuo!=1 & rep==1 & genpct!=1 & genpct!=. & cycledummy9==1
est store m1996
 
reg genwin2 c.cfscoresdyn##i.gender i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2  ///
	if genuo!=1 & rep==1 & genpct!=1 & genpct!=. & cycledummy10==1
est store m1998
 
reg genwin2 c.cfscoresdyn##i.gender i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2  ///
	if genuo!=1 & rep==1 & genpct!=1 & genpct!=. & cycledummy11==1
est store m2000
 
reg genwin2 c.cfscoresdyn##i.gender i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2  ///
	if genuo!=1 & rep==1 & genpct!=1 & genpct!=. & cycledummy12==1
est store m2002
 
reg genwin2 c.cfscoresdyn##i.gender i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2  ///
	if genuo!=1 & rep==1 & genpct!=1 & genpct!=. & cycledummy13==1
est store m2004
 
reg genwin2 c.cfscoresdyn##i.gender i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2  ///
	if genuo!=1 & rep==1 & genpct!=1 & genpct!=. & cycledummy14==1
est store m2006
 
reg genwin2 c.cfscoresdyn##i.gender i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2  ///
	if genuo!=1 & rep==1 & genpct!=1 & genpct!=. & cycledummy15==1
est store m2008
 
reg genwin2 c.cfscoresdyn##i.gender i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2  ///
	if genuo!=1 & rep==1 & genpct!=1 & genpct!=. & cycledummy16==1
est store m2010
 
reg genwin2 c.cfscoresdyn##i.gender i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2 extremedummy3 ///
	if genuo!=1 & rep==1 & genpct!=1 & genpct!=. & cycledummy17==1
est store m2012
 
coefplot m1980 || m1982 || m1984 || m1986 || m1988 || m1990 || m1992 || m1994 || m1996 || m1998 || m2000 || m2002 || ///
	m2004 || m2006 || m2008 || m2010 || m2012, mcolor(black) ///
	keep(1.gender#c.cfscoresdyn) yline(0) ytitle("Coefficient") vertical bycoefs byopts(yrescale) xtitle("") xlabel(1 "1980" 3 "1984" 5 "1988" ///
	7 "1992" 9 "1996" 11 "2000" 13 "2004" 15 "2008" 17 "2012")
	
drop _est_m1980 _est_m1980 _est_m1982 _est_m1984 _est_m1986 _est_m1988 _est_m1990 _est_m1992 ///
 _est_m1994 _est_m1996 _est_m1998 _est_m2000 _est_m2002 _est_m2004 _est_m2006 _est_m2008 _est_m2010 _est_m2012
	
*Democrats, Primary
reg priwin2 c.cfscoresdyn##i.gender  i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2 extremedummy3    ///
	if priuo!=1 & rep==0 & pripct2!=1 & pripct2!=. & cycledummy1==1
est store m1980
 
reg priwin2 c.cfscoresdyn##i.gender  i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2 extremedummy3    ///
	if priuo!=1 & rep==0 & pripct2!=1 & pripct2!=. & cycledummy2==1
est store m1982
 
reg priwin2 c.cfscoresdyn##i.gender  i.incum10  ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2     ///
	if priuo!=1 & rep==0 & pripct2!=1 & pripct2!=. & cycledummy3==1
est store m1984
 
reg priwin2 c.cfscoresdyn##i.gender  i.incum10  ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2     ///
	if priuo!=1 & rep==0 & pripct2!=1 & pripct2!=. & cycledummy4==1
est store m1986
 
reg priwin2 c.cfscoresdyn##i.gender  i.incum10   ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2 extremedummy3    ///
	if priuo!=1 & rep==0 & pripct2!=1 & pripct2!=. & cycledummy5==1
est store m1988
 
reg priwin2 c.cfscoresdyn##i.gender     ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2     ///
	if priuo!=1 & rep==0 & pripct2!=1 & pripct2!=. & cycledummy6==1
est store m1990
 
reg priwin2 c.cfscoresdyn##i.gender  i.incum10   ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2     ///
	if priuo!=1 & rep==0 & pripct2!=1 & pripct2!=. & cycledummy7==1
est store m1992
 
reg priwin2 c.cfscoresdyn##i.gender  i.incum10   ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2  extremedummy3   ///
	if priuo!=1 & rep==0 & pripct2!=1 & pripct2!=. & cycledummy8==1
est store m1994
 
reg priwin2 c.cfscoresdyn##i.gender   i.incum10   ///
	  c.npricands10##c.npricands10 logcandreceipts c.reppresvs2 extremedummy3    ///
	if priuo!=1 & rep==0 & pripct2!=1 & pripct2!=. & cycledummy9==1
est store m1996

reg priwin2 c.cfscoresdyn##i.gender    ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2     ///
	if priuo!=1 & rep==0 & pripct2!=1 & pripct2!=. & cycledummy10==1
est store m1998

reg priwin2 c.cfscoresdyn##i.gender  i.incum10   ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2 extremedummy3    ///
	if priuo!=1 & rep==0 & pripct2!=1 & pripct2!=. & cycledummy11==1
est store m2000
 
reg priwin2 c.cfscoresdyn##i.gender  i.incum10   ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2  extremedummy3   ///
	if priuo!=1 & rep==0 & pripct2!=1 & pripct2!=. & cycledummy12==1
est store m2002
 
reg priwin2 c.cfscoresdyn##i.gender  i.incum10   ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2 extremedummy3    ///
	if priuo!=1 & rep==0 & pripct2!=1 & pripct2!=. & cycledummy13==1
est store m2004
 
reg priwin2 c.cfscoresdyn##i.gender  i.incum10   ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2     ///
	if priuo!=1 & rep==0 & pripct2!=1 & pripct2!=. & cycledummy14==1
est store m2006
 
reg priwin2 c.cfscoresdyn##i.gender  i.incum10   ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2 extremedummy3    ///
	if priuo!=1 & rep==0 & pripct2!=1 & pripct2!=. & cycledummy15==1
est store m2008

reg priwin2 c.cfscoresdyn##i.gender  i.incum10   ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2 extremedummy3    ///
	if priuo!=1 & rep==0 & pripct2!=1 & pripct2!=. & cycledummy16==1
est store m2010
 
reg priwin2 c.cfscoresdyn##i.gender  i.incum10   ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2 extremedummy3    ///
	if priuo!=1 & rep==0 & pripct2!=1 & pripct2!=. & cycledummy17==1
est store m2012
 
coefplot m1980 || m1982 || m1984 || m1986 || m1988 || m1990 || m1992 || m1994 || m1996 || m1998 || m2000 || m2002 || ///
	m2004 || m2006 || m2008 || m2010 || m2012, mcolor(black) ///
	keep(1.gender#c.cfscoresdyn) yline(0) ytitle("Coefficient") vertical bycoefs byopts(yrescale) xtitle("") xlabel(1 "1980" 3 "1984" 5 "1988" ///
	7 "1992" 9 "1996" 11 "2000" 13 "2004" 15 "2008" 17 "2012")

drop _est_m1980 _est_m1980 _est_m1982 _est_m1984 _est_m1986 _est_m1988 _est_m1990 _est_m1992 ///
 _est_m1994 _est_m1996 _est_m1998 _est_m2000 _est_m2002 _est_m2004 _est_m2006 _est_m2008 _est_m2010 _est_m2012
	
*Democrats, General
reg genwin2 c.cfscoresdyn##i.gender  i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2 extremedummy3 ///
	if genuo!=1 & rep==0 & genpct!=1 & genpct!=. & cycledummy1==1
est store m1980
 
reg genwin2 c.cfscoresdyn##i.gender  i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2 extremedummy3 ///
	if genuo!=1 & rep==0 & genpct!=1 & genpct!=. & cycledummy2==1
est store m1982
 
reg genwin2 c.cfscoresdyn##i.gender  i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2 extremedummy3 ///
	if genuo!=1 & rep==0 & genpct!=1 & genpct!=. & cycledummy3==1
est store m1984
 
reg genwin2 c.cfscoresdyn##i.gender  i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2 extremedummy3 ///
	if genuo!=1 & rep==0 & genpct!=1 & genpct!=. & cycledummy4==1
est store m1986
 
reg genwin2 c.cfscoresdyn##i.gender  i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2  ///
	if genuo!=1 & rep==0 & genpct!=1 & genpct!=. & cycledummy5==1
est store m1988
 
reg genwin2 c.cfscoresdyn##i.gender  i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2  ///
	if genuo!=1 & rep==0 & genpct!=1 & genpct!=. & cycledummy6==1
est store m1990
 
reg genwin2 c.cfscoresdyn##i.gender  i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2  ///
	if genuo!=1 & rep==0 & genpct!=1 & genpct!=. & cycledummy7==1
est store m1992
 
reg genwin2 c.cfscoresdyn##i.gender  i.incum10  ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2 extremedummy3 ///
	if genuo!=1 & rep==0 & genpct!=1 & genpct!=. & cycledummy8==1
est store m1994
 
reg genwin2 c.cfscoresdyn##i.gender  i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2  ///
	if genuo!=1 & rep==0 & genpct!=1 & genpct!=. & cycledummy9==1
est store m1996
 
reg genwin2 c.cfscoresdyn##i.gender  i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2 extremedummy3 ///
	if genuo!=1 & rep==0 & genpct!=1 & genpct!=. & cycledummy10==1
est store m1998
 
reg genwin2 c.cfscoresdyn##i.gender  i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2 extremedummy3 ///
	if genuo!=1 & rep==0 & genpct!=1 & genpct!=. & cycledummy11==1
est store m2000
 
reg genwin2 c.cfscoresdyn##i.gender  i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2 extremedummy3 ///
	if genuo!=1 & rep==0 & genpct!=1 & genpct!=. & cycledummy12==1
est store m2002
 
reg genwin2 c.cfscoresdyn##i.gender  i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2 extremedummy3 ///
	if genuo!=1 & rep==0 & genpct!=1 & genpct!=. & cycledummy13==1
est store m2004
 
reg genwin2 c.cfscoresdyn##i.gender  ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2 extremedummy3 ///
	if genuo!=1 & rep==0 & genpct!=1 & genpct!=. & cycledummy14==1
est store m2006
 
reg genwin2 c.cfscoresdyn##i.gender  i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2  ///
	if genuo!=1 & rep==0 & genpct!=1 & genpct!=. & cycledummy15==1
est store m2008
 
reg genwin2 c.cfscoresdyn##i.gender  i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2  ///
	if genuo!=1 & rep==0 & genpct!=1 & genpct!=. & cycledummy16==1
est store m2010
 
reg genwin2 c.cfscoresdyn##i.gender  i.incum10 ///
	c.npricands10##c.npricands10 logcandreceipts c.reppresvs2  ///
	if genuo!=1 & rep==0 & genpct!=1 & genpct!=. & cycledummy17==1
est store m2012

coefplot m1980 || m1982 || m1984 || m1986 || m1988 || m1990 || m1992 || m1994 || m1996 || m1998 || m2000 || m2002 || ///
	m2004 || m2006 || m2008 || m2010 || m2012, mcolor(black) ///
	keep(1.gender#c.cfscoresdyn) yline(0) ytitle("Coefficient") vertical bycoefs byopts(yrescale) xtitle("") xlabel(1 "1980" 3 "1984" 5 "1988" ///
	7 "1992" 9 "1996" 11 "2000" 13 "2004" 15 "2008" 17 "2012")

drop _est_m1980 _est_m1980 _est_m1982 _est_m1984 _est_m1986 _est_m1988 _est_m1990 _est_m1992 ///
 _est_m1994 _est_m1996 _est_m1998 _est_m2000 _est_m2002 _est_m2004 _est_m2006 _est_m2008 _est_m2010 _est_m2012
 
