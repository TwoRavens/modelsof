**CREATES FIGURES 1(b),7
**CREATES TABLE 1(RIGHT PANELS),2(RIGHT PANELS),5(BOTTOM PANEL),6(BOTTOM PANEL),7

**MERGE UNION ELECTIONS DATABASES**
**start with elections from fy1961-fy2009
set more off
clear
use "C:\Users\ODMXK1\Documents\Research\unions_offshoring\data\merged_elections_1961_2009.dta", clear
append using "C:\Users\ODMXK1\Documents\Research\unions_offshoring\data\union elections\2009-2015 data\election_data_sept_2009_sep_2014"
drop if employer==""
gen employer_ = substr(employer, 3,.) if strpos(employer, "*")==1
replace employer = employer_ if strpos(employer, "*")==1
drop employer_
replace employer = upper(employer)
stnd_compname employer, gen(stn_name stn_dbaname stn_fkaname entitytype attn_name)
duplicates tag stn_name, generate(same_firm_dummy)
egen employer_id=group(stn_name) 
gen union_id = _n
replace union_id = union_id*2
rename employer name
drop if employer_id==.
replace year_electionheld = year_election if year_electionheld==.
replace  month_electionheld = month_election if month_electionheld==.
drop year_election
drop month_election
sort employer_id
save "C:\Users\ODMXK1\Documents\Research\unions_offshoring\data\merged_elections_1961_2014_tags_2.dta", replace
clear
use "C:\Users\ODMXK1\Documents\Research\unions_offshoring\data\merged_elections_1961_2014_tags_2.dta"
**Create a master list of all firms in union elections db
*collapse to one employer
collapse (first) employer_id, by(stn_name)
moss stn_name, match("(")
moss stn_name, match(")") prefix(close_)
browse if _count!=close_count
drop _count close_count
replace stn_name = trim(stn_name)
compress
keep stn_name employer_id 
sort employer_id
save "C:\Users\ODMXK1\Documents\Research\unions_offshoring\data\master_unions_list_1961_2014.dta", replace
**USE COMPUSTAT PANEL AND EXTRACT NAMES/EINS OF BUSINESSES**

 /* set data directory */
global filepath "DIRECTORY MASKED"
*load in compustat panel
clear
set more off
use "$filepath\79_2014_cpustat_emp.dta"
**standardize business names
collapse (first) number, by(name) 
stnd_compname name, gen(stn_name stn_dbaname stn_fkaname entitytype attn_name)
moss stn_name, match("(")
moss stn_name, match(")") prefix(close_)
edit if _count!=close_count
keep stn_name number
sort number
save "$filepath\names_compustat.dta", replace
**now link
clear 
use "$filepath\names_compustat.dta"
sort number
save "$filepath\names_compustat.dta", replace
sort number
reclink2 stn_name using "C:\Users\ODMXK1\Documents\Research\unions_offshoring\data\master_unions_list_1961_2014.dta", idm(number) idu(employer_id) gen(myscore) minbigram(.60) many
order myscore stn_name Ustn_name number employer_id
gsort - myscore
compress Ustn_name
save "$filepath\linked_unions_to_cpustat.dta", replace
clear 
use "$filepath\linked_unions_to_cpustat.dta"

edit
gen match=1 if myscore==1
order myscore stn_name Ustn_name number employer_id match
gen flag = 1 if match==1 & stn_name!=Ustn_name
replace flag = . in 166
replace flag = . in 234
replace match=0 if flag==1 & myscore==1
gen contained=1 if strpos(stn_name, Ustn_name) | strpos(Ustn_name, stn_name)
browse if contained==1&match==.
edit
save "$filepath\linked_unions_to_cpustat_979matches.dta"
**FIRM NAMES/IDS MASKED TO PROTECT CONFIDENTIALITY**
replace match = 1 in 621
replace match = 1 in 622
replace match = 1 in 625
replace match = 1 in 626
replace match = 1 in 627
replace match = 1 in 628
replace match = 1 in 629
replace match = 1 in 631
replace match = 1 in 632
replace match = 1 in 633
replace match = 1 in 634
replace match = 1 in 635
replace match = 1 in 636
replace match = 1 in 637
replace match = 1 in 638
replace match = 1 in 640
replace match = 1 in 642
replace match = 1 in 644
replace match = 1 in 645
replace match = 1 in 647
replace match = 1 in 648
replace match = 1 in 651
replace match = 1 in 652
replace match = 1 in 654
replace match = 1 in 655
replace match = 1 in 656
replace match = 1 in 659
replace match = 1 in 660
replace match = 1 in 661
replace match = 1 in 662
replace match = 1 in 665
replace match = 1 in 666
replace match = 1 in 669
replace match = 1 in 671
replace match = 1 in 672
replace match = 1 in 674
replace match = 1 in 676
replace match = 1 in 677
replace match = 1 in 678
replace match = 1 in 682
replace match = 1 in 685
replace match = 1 in 694
replace match = 1 in 696
replace match = 1 in 697
replace match = 1 in 698
replace match = 1 in 699
replace match = 1 in 702
replace match = 1 in 704
replace match = 1 in 708
replace match = 1 in 709
replace match = 1 in 712
replace match = 1 in 713
replace match = 1 in 720
replace match = 1 in 723
replace match = 1 in 727
replace match = 1 in 732
replace match = 1 in 733
replace match = 1 in 734
replace match = 1 in 740
replace match = 1 in 742
replace match = 1 in 743
replace match = 1 in 744
replace match = 1 in 745
replace match = 1 in 747
replace match = 1 in 748
replace match = 1 in 754
replace match = 1 in 758
replace match = 1 in 763
replace match = 1 in 769
replace match = 1 in 770
replace match = 1 in 776
replace match = 1 in 777
replace match = 1 in 781
replace match = 1 in 784
replace match = 1 in 787
replace match = 1 in 790
replace match = 1 in 796
replace match = 1 in 803
replace match = 1 in 806
replace match = 1 in 810
replace match = 1 in 811
replace match = 1 in 818
replace match = 1 in 820
replace match = 1 in 828
replace match = 1 in 829
replace match = 1 in 831
replace match = 1 in 832
replace match = 1 in 834
replace match = 1 in 835
replace match = 1 in 837
replace match = 1 in 838
replace match = 1 in 842
replace match = 1 in 843
replace match = 1 in 848
replace match = 1 in 852
replace match = 1 in 855
replace match = 1 in 860
replace match = 1 in 861
replace match = 1 in 864
replace match = 1 in 865
replace match = 1 in 867
replace match = 1 in 869
replace match = 1 in 871
replace match = 1 in 874
replace match = 1 in 878
replace match = 1 in 882
replace match = 1 in 883
replace match = 1 in 884
replace match = 1 in 894
replace match = 1 in 905
replace match = 1 in 909
replace match = 1 in 913
replace match = 1 in 917
replace match = 1 in 919
replace match = 1 in 927
replace match = 1 in 929
replace match = 1 in 937
replace match = 1 in 939
replace match = 1 in 944
replace match = 1 in 950
replace match = 1 in 959
replace match = 1 in 962
replace match = 1 in 963
replace match = 1 in 965
replace match = 1 in 966
replace match = 1 in 979
replace match = 1 in 989
replace match = 1 in 992
replace match = 1 in 995
replace match = 1 in 996
replace match = 1 in 1000
replace match = 1 in 1002
replace match = 1 in 1022
replace match = 1 in 1024
replace match = 1 in 1026
replace match = 1 in 1029
replace match = 1 in 1031
replace match = 1 in 1032
replace match = 1 in 1034
replace match = 1 in 1041
replace match = 1 in 1044
replace match = 1 in 1090
replace match = 1 in 1101
replace match = 1 in 1107
replace match = 1 in 1119
replace match = 1 in 1123
replace match = 1 in 1146
replace match = 1 in 1237
replace match = 1 in 1297
replace match = 1 in 1337
replace match = 1 in 1336
replace match = 1 in 1338
replace match = 1 in 1340
replace match = 1 in 1341
replace match = 1 in 1456
replace match = 1 in 1455
replace match = 1 in 1465
replace match = 1 in 1498
keep if match==1
drop _merge flag contained
drop match
sort employer_id
save "$filepath\linked_unions_to_cpustat_979matched.dta", replace

***NOW MERGE
** START WITH UNIONS DB
clear
set more off
use "C:\Users\ODMXK1\Documents\Research\unions_offshoring\data\merged_elections_1961_2014_tags_2.dta"
sort employer_id
*MERGE WITH MATCHED UNIONS-CPUSTAT DB
merge m:m employer_id using "$filepath\linked_unions_to_cpustat_979matched.dta"
keep if _merge==3
drop _merge
rename year_election year
sort number year
gen vote_share = votes_for/(votes_for + votes_against)
drop if vote_share==.
replace name=trim(name)
compress name
sort number year 
save "$filepath\unions_with_cpustat_ids.dta", replace

*********
**NOW MERGE CPUSTAT DATA WITH UNIONS
**START HERE FOR ANALYSIS**
*******
clear
set more off
use "$filepath\79_2014_cpustat_emp.dta"
sort number year
merge 1:m number year using "$filepath\unions_with_cpustat_ids.dta"
sort number year
drop if _merge==2
replace type="RC" if type=="-R"
replace type = "RD" if type=="UD"
drop if type=="RM"
gen naics3 = substr(string(naics), 1,3)
destring naics3, replace
browse number year type votes_for vote_share outcome numberelig emp_ emp_compen_ pension_ naics3
replace outcome = "WON" if votes_for>votes_against & year>=2009
replace outcome = "LOST" if votes_for<=votes_against & year>=2009 & votes_for!=.
replace outcome = "LOST" if outcome=="LOSS"
gen win=1 if outcome=="WON" & type=="RC"
replace win=0 if outcome=="LOST" & type=="RC"
*replace win=0 if outcome=="WON" & type=="RD"
*replace win=1 if outcome=="LOST" & type=="RD"
rename emp_ emp
rename emp_compen_ emp_compen
rename pension_ pension
sort number year

***EMPLOYMENT
gen ln_emp = ln(emp)
gen num_votes = votes_for + votes_against
encode employerstate, gen(st)
*drop ln_diff_diff_emp
*drop ln_diff_diff
by number, sort: gen ln_diff_emp = (ln_emp[_n+1]-ln_emp[_n-1])

summ ln_diff_emp if win==1 & year[_n+1]-year==1& year[_n-1]-year==-1
summ ln_diff_emp if win==0 & year[_n+1]-year==1& year[_n-1]-year==-1

***ASSIGN RIGHT-TO-WORK STATUS
gen rtw=.
global non_right "AK CA CO CT DE DC HI IL IN MI KY MD MA ME MN MO NH NJ NM NY OH OR PA RI VT WA WV WI"
global right "AL AZ AR FL GA ID IA KS LA MS MT NE NC ND NV OK SC SD TN TX UT VA WY"
foreach st in $right {
	replace rtw=1 if employerstate=="`st'"
}
foreach st in $non_right {
	replace rtw=0 if employerstate=="`st'"
}
replace rtw=0 if employerstate=="OK" & year<=2001
replace rtw=1 if employerstate=="IN" & year>=2012
replace rtw=1 if employerstate=="MI" & year>=2012

**EMPLOYEE COMPENSATION

*ADJUST FOR INFLATION (base year= 2016)
gen cpi = 37.875 if year==1981
replace cpi = 40.208 if year==1982
replace cpi = 41.5 if year==1983
replace cpi = 43.29 if year==1984
replace cpi = 44.83 if year==1985
replace cpi = 45.67 if year==1986
replace cpi = 47.33 if year==1987
replace cpi = 49.29 if year==1988
replace cpi = 51.67 if year==1989
replace cpi = 54.46 if year==1990
replace cpi = 56.75 if year==1991
replace cpi = 58.46 if year==1992
replace cpi = 60.21 if year==1993
replace cpi = 61.75 if year==1994
replace cpi = 63.5 if year==1995
replace cpi = 65.375 if year==1996
replace cpi = 66.875 if year==1997
replace cpi = 67.92 if year==1998
replace cpi = 69.42 if year==1999
replace cpi = 71.75 if year==2000
replace cpi = 73.792 if year==2001
replace cpi = 74.96 if year==2002
replace cpi = 76.67 if year==2003
replace cpi = 78.71 if year==2004
replace cpi = 81.375 if year==2005
replace cpi = 84 if year==2006
replace cpi = 86.375 if year==2007
replace cpi = 89.71 if year==2008
replace cpi = 89.375 if year==2009
replace cpi = 90.875 if year==2010
replace cpi = 93.71 if year==2011
replace cpi = 95.67 if year==2012
replace cpi = 97.08 if year==2013
replace cpi = 98.625 if year==2014
replace cpi = 98.75 if year==2015
replace cpi = 100 if year==2016

gen wage = emp_compen/emp
gen ln_wage = ln(emp_compen/emp)
gen p = cpi/100
gen wage_def = wage/p
gen ln_wage_def = ln(wage_def)
sort number year
by number, sort: gen ln_diff_wage = (ln_wage[_n+1]-ln_wage[_n-1])
by number, sort: gen avg_fut_wage = (wage[_n+1]+wage[_n+2])/2
by number, sort: gen avg_pre_wage = (wage[_n-1]+wage[_n-2])/2
by number, sort: gen ln_avg_diff_wage = ln(avg_fut_wage)-ln(avg_pre_wage)
by number, sort: gen ln_diff_pre_wage = (ln_wage[_n-1]-ln_wage[_n-2])
by number, sort: gen ln_diff_wage_def = (ln_wage_def[_n+1]-ln_wage_def[_n-1])
by number, sort: gen avg_fut_wage_def = (wage_def[_n+1]+wage_def[_n+2])/2
by number, sort: gen avg_pre_wage_def = (wage_def[_n-1]+wage_def[_n-2])/2
by number, sort: gen fut_wage_def = wage_def[_n+1]
by number, sort: gen pre_wage_def = wage_def[_n-1]
by number, sort: gen ln_avg_diff_wage_def = ln(avg_fut_wage_def)-ln(avg_pre_wage_def)
by number, sort: gen ln_diff_pre_wage_def = (ln_wage_def[_n-1]-ln_wage_def[_n-2])
by number, sort: gen Femp = emp[_n+1]
by number, sort: gen Lemp = emp[_n-1]

**
*** COMPENSATION
****FULL SAMPLE
gen margin_of_victory = votes_for - votes_against if type=="RC"
*replace margin_of_victory = votes_against - votes_for if type=="RD"

gen share_margin = vote_share if type=="RC"
*replace share_margin = 1-vote_share if type=="RD"

by number, sort: gen Fln_wage =ln_wage[_n+1]
by number, sort: gen F2ln_wage =ln_wage[_n+2]

by number, sort: gen Lln_wage =ln_wage[_n-1]
by number, sort: gen L2ln_wage =ln_wage[_n-2]

by number, sort: gen Fln_wage_def =ln_wage_def[_n+1]
by number, sort: gen F2ln_wage_def =ln_wage_def[_n+2]

by number, sort: gen Lln_wage_def =ln_wage_def[_n-1]
by number, sort: gen L2ln_wage_def =ln_wage_def[_n-2]

by number, sort: gen Lln_emp =ln_emp[_n-1]

gen x_c = share_margin - 0.5
gen x2_c = x_c^2
gen x3_c = x_c^3

gen y_c = margin
gen y2_c = y_c^2
gen y3_c = y_c^3

gen Lln_wage2 = Lln_wage*Lln_wage
gen L2ln_wage2 = L2ln_wage*L2ln_wage
*gen L3ln_wage2 = L3ln_wage*L3ln_wage
gen L2ln_wage3 = L2ln_wage2*L2ln_wage

gen Lln_wage2_def = Lln_wage_def*Lln_wage_def
gen L2ln_wage2_def = L2ln_wage_def*L2ln_wage_def
gen L2ln_wage3_def = L2ln_wage2_def*L2ln_wage_def

gen election=1 if win!=.
replace election= 0 if election!=1
sort number year
by number, sort: gen tot_elec = sum(election)
by number, sort: gen total_elec = tot_elec[_N]
gen win_x_elec = 1==win==1 &type=="RC"
by number, sort: gen tot_wins = sum(win_x_elec)

*TABLE 5
**FULL SAMPLE FOR COMPARISON W/ MNE RESULTS
*ROW 3

*COLUMNS 1 + 2
*degree 2, ln_diff_wage
reg ln_diff_wage_def i.win##(c.y_c c.y2_c) i.year [iw=share_margin/.5] if num_votes>=10 & abs(vote_share-.5)<=.5& year[_n+1]-year==1& year[_n-1]-year==-1&year<=2009, cluster(number)
*degree 1, ln_diff_wage
reg ln_diff_wage_def i.win##(c.y_c) i.year [iw=share_margin/.5] if num_votes>=10 & abs(vote_share-.5)<=.5& year[_n+1]-year==1& year[_n-1]-year==-1&year<=2009, cluster(number)

*COLUMNS 3 + 4
*degree 2, ln_diff_wage
reg Fln_wage_def i.win##(c.y_c c.y2_c) i.year Lln_wage_def Lln_wage2_def L2ln_wage_def L2ln_wage2_def [iw=share_margin/.5] if num_votes>=10 & abs(vote_share-.5)<=.5& year[_n+1]-year==1& year[_n-1]-year==-1&year<=2009, cluster(number)
*degree 1, ln_diff_wage
reg Fln_wage_def i.win##(c.y_c) i.year Lln_wage_def Lln_wage2_def L2ln_wage_def L2ln_wage2_def [iw=share_margin/.5] if num_votes>=10 & abs(vote_share-.5)<=.5& year[_n+1]-year==1& year[_n-1]-year==-1&year<=2009, cluster(number)

*TABLE 6
**WITH CONTROLS
gen rtwxwin = rtw*win
gen winxtot_wins =win*tot_wins

*BOTTOM PANEL
*COLUMNS 1 + 2

*degree 2, ln_diff_wage
reg ln_diff_wage_def i.win##(c.y_c c.y2_c) rtw rtwxwin tot_wins i.year [iw=share_margin/.5] if num_votes>=10 & abs(vote_share-.5)<=.5& year[_n+1]-year==1& year[_n-1]-year==-1&year<=2009, cluster(number)
*degree 1, ln_diff_wage
reg ln_diff_wage_def i.win##(c.y_c) rtw rtwxwin tot_wins i.year [iw=share_margin/.5] if num_votes>=10 & abs(vote_share-.5)<=.5& year[_n+1]-year==1& year[_n-1]-year==-1&year<=2009, cluster(number)

*COLUMNS 3 + 4
*degree 2, ln_diff_wage
reg Fln_wage_def i.win##(c.y_c c.y2_c) rtw rtwxwin tot_wins i.year Lln_wage_def Lln_wage2_def L2ln_wage_def L2ln_wage2_def [iw=share_margin/.5] if num_votes>=10 & abs(vote_share-.5)<=.5& year[_n+1]-year==1& year[_n-1]-year==-1&year<=2009, cluster(number)
*degree 1, ln_diff_wage
reg Fln_wage_def i.win##(c.y_c) rtw rtwxwin tot_wins i.year Lln_wage_def Lln_wage2_def L2ln_wage_def L2ln_wage2_def [iw=share_margin/.5] if num_votes>=10 & abs(vote_share-.5)<=.5& year[_n+1]-year==1& year[_n-1]-year==-1&year<=2009, cluster(number)

****PENSION CONTRIBUTION RESULTS

gen pension_emp = pension/emp
gen ln_pension = ln(pension)
gen ln_pension_emp = ln(pension/emp)
by number, sort: gen ln_diff_pension = (ln_pension[_n+1]-ln_pension[_n-1])
by number, sort: gen ln_diff_pension_emp = (ln_pension_emp[_n+1]-ln_pension_emp[_n-1])
by number, sort: gen avg_fut_pension = (pension[_n+1]+pension[_n+2])/2
by number, sort: gen avg_pre_pension = (pension[_n-1]+pension[_n-2])/2
by number, sort: gen ln_avg_diff_pension = ln(avg_fut_pension)-ln(avg_pre_pension)
gen share_pension = pension_emp/emp_compen
*DEFLATED
gen pension_def = pension/p
gen ln_pension_def = ln(pension_def)
gen pension_def_emp = pension_def/emp
by number, sort: gen Lemp = emp[_n-1]
by number, sort: gen Femp = emp[_n+1]
by number, sort: gen ln_diff_pension_def = (ln_pension_def[_n+1]-ln_pension_def[_n-1])
by number, sort: gen avg_fut_pension_def = (pension_def[_n+1]+pension_def[_n+2])/2
by number, sort: gen avg_pre_pension_def = (pension_def[_n-1]+pension_def[_n-2])/2
by number, sort: gen fut_pension_def = pension_def[_n+1]
by number, sort: gen pre_pension_def = pension_def[_n-1]
by number, sort: gen avg_fut_emp = (emp[_n+1]+emp[_n+2])/2
by number, sort: gen avg_pre_emp = (emp[_n-1]+emp[_n-2])/2
gen avg_fut_pens_def_emp = avg_fut_pension_def/avg_fut_emp
gen avg_pre_pens_def_emp = avg_pre_pension_def/avg_pre_emp
gen fut_pens_def_emp = fut_pension_def/Femp
gen pre_pens_def_emp = pre_pension_def/Lemp

**SUMMARY STATS-PENSIONS/EMP AND COMPENSATION/EMP

*TABLE 2: AVG PRE and POST-ELECTION FIRM CHARACTERISTICS
*COMPENSATION ANALYSIS
*EMPLOYMENT
summ Femp if fut_wage_def!=. &  win!=. & year[_n+1]-year==1& year[_n-1]-year==-1 & num_votes>=10& abs(vote_share-.5)<=.5&year<=2009
summ Lemp if pre_wage_def!=. &  win!=. & year[_n+1]-year==1& year[_n-1]-year==-1& num_votes>=10& abs(vote_share-.5)<=.5&year<=2009

summ Femp if fut_wage_def!=. & win==0 & year[_n+1]-year==1& year[_n-1]-year==-1 & num_votes>=10& abs(vote_share-.5)<=.5&year<=2009
summ Lemp if pre_wage_def!=. & win==0  & year[_n+1]-year==1& year[_n-1]-year==-1& num_votes>=10& abs(vote_share-.5)<=.5&year<=2009

summ Femp if fut_wage_def!=. & win==1 & year[_n+1]-year==1& year[_n-1]-year==-1 & num_votes>=10& abs(vote_share-.5)<=.5&year<=2009
summ Lemp if pre_wage_def!=. & win==1  & year[_n+1]-year==1& year[_n-1]-year==-1& num_votes>=10& abs(vote_share-.5)<=.5&year<=2009

*DELTA COMPENSATION
summ fut_wage_def if win!=. & year[_n+1]-year==1& year[_n-1]-year==-1 & num_votes>=10& abs(vote_share-.5)<=.5&year<=2009
summ pre_wage_def if win!=. & year[_n+1]-year==1& year[_n-1]-year==-1& num_votes>=10& abs(vote_share-.5)<=.5&year<=2009

summ fut_wage_def if win==0 & year[_n+1]-year==1& year[_n-1]-year==-1 & num_votes>=10& abs(vote_share-.5)<=.5&year<=2009
summ pre_wage_def if win==0  & year[_n+1]-year==1& year[_n-1]-year==-1& num_votes>=10& abs(vote_share-.5)<=.5&year<=2009

summ fut_wage_def if win==1 & year[_n+1]-year==1& year[_n-1]-year==-1 & num_votes>=10& abs(vote_share-.5)<=.5&year<=2009
summ pre_wage_def if win==1  & year[_n+1]-year==1& year[_n-1]-year==-1& num_votes>=10& abs(vote_share-.5)<=.5&year<=2009

*PENSION ANALYSIS
*EMPLOYMENT
summ Femp if fut_pens_def_emp!=. &  win!=. & year[_n+1]-year==1& year[_n-1]-year==-1 & num_votes>=10& abs(vote_share-.5)<=.5&year<=2009
summ Lemp if pre_pens_def_emp!=. &  win!=. & year[_n+1]-year==1& year[_n-1]-year==-1& num_votes>=10& abs(vote_share-.5)<=.5&year<=2009

summ Femp if fut_pens_def_emp!=. & win==0 & year[_n+1]-year==1& year[_n-1]-year==-1 & num_votes>=10& abs(vote_share-.5)<=.5&year<=2009
summ Lemp if pre_pens_def_emp!=. & win==0  & year[_n+1]-year==1& year[_n-1]-year==-1& num_votes>=10& abs(vote_share-.5)<=.5&year<=2009

summ Femp if fut_pens_def_emp!=. & win==1 & year[_n+1]-year==1& year[_n-1]-year==-1 & num_votes>=10& abs(vote_share-.5)<=.5&year<=2009
summ Lemp if pre_pens_def_emp!=. & win==1  & year[_n+1]-year==1& year[_n-1]-year==-1& num_votes>=10& abs(vote_share-.5)<=.5&year<=2009

*DELTA PENSION CONTRIBUTIONS
summ fut_pens_def_emp if win!=. & year[_n+1]-year==1& year[_n-1]-year==-1 & num_votes>=20& abs(vote_share-.5)<=.5&year<=2009
summ pre_pens_def_emp if win!=. & year[_n+1]-year==1& year[_n-1]-year==-1& num_votes>=20& abs(vote_share-.5)<=.5&year<=2009

summ fut_pens_def_emp if win==0 & year[_n+1]-year==1& year[_n-1]-year==-1 & num_votes>=20& abs(vote_share-.5)<=.5&year<=2009
summ pre_pens_def_emp if win==0  & year[_n+1]-year==1& year[_n-1]-year==-1& num_votes>=20& abs(vote_share-.5)<=.5&year<=2009

summ fut_pens_def_emp if win==1 & year[_n+1]-year==1& year[_n-1]-year==-1 & num_votes>=20& abs(vote_share-.5)<=.5&year<=2009
summ pre_pens_def_emp if win==1  & year[_n+1]-year==1& year[_n-1]-year==-1& num_votes>=20& abs(vote_share-.5)<=.5&year<=2009

***********************************************
*SUMM STAT TABLES
*TABLE 1: NLRB ELECTION SUMMARY STATS 
*win %
summ win if ln_diff_wage_def!=. & _merge==3 & num_votes>=10 & year[_n+1]-year==1& year[_n-1]-year==-1 &year<=2009
*% in favor
summ vote_share if ln_diff_wage_def!=. & _merge==3 & num_votes>=10 & year[_n+1]-year==1& year[_n-1]-year==-1 &year<=2009
summ vote_share if win==1&  ln_diff_wage_def!=. & _merge==3 & num_votes>=10 & year[_n+1]-year==1& year[_n-1]-year==-1 &year<=2009
summ vote_share if win==0&  ln_diff_wage_def!=. & _merge==3 & num_votes>=10 & year[_n+1]-year==1& year[_n-1]-year==-1 &year<=2009
*number of voters
summ num_votes if ln_diff_wage_def!=. & _merge==3 &win!=. & num_votes>=10 & year[_n+1]-year==1& year[_n-1]-year==-1 &year<=2009
summ num_votes if ln_diff_wage_def!=. & _merge==3 &win==1 & num_votes>=10 & year[_n+1]-year==1& year[_n-1]-year==-1 &year<=2009
summ num_votes if ln_diff_wage_def!=. &_merge==3 &win==0 & num_votes>=10 & year[_n+1]-year==1& year[_n-1]-year==-1 &year<=2009

**PENSION ELECTIONS SUMM STATS
*win %
summ win if ln_avg_diff_pension!=. & _merge==3 & num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1 &year<=2009
*% in favor
summ vote_share if ln_avg_diff_pension!=. & _merge==3 & num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1 &year<=2009
summ vote_share if win==1&  ln_avg_diff_pension!=. & _merge==3 & num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1 &year<=2009
summ vote_share if win==0&  ln_avg_diff_pension!=. & _merge==3 & num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1 &year<=2009
*number of voters
summ num_votes if ln_avg_diff_pension!=. & _merge==3 &win!=. & num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1 &year<=2009
summ num_votes if ln_avg_diff_pension!=. & _merge==3 &win==1 & num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1 &year<=2009
summ num_votes if ln_avg_diff_pension!=. &_merge==3 &win==0 & num_votes>=20 & year[_n+1]-year==1& year[_n-1]-year==-1 &year<=2009

**Include footnote about matching procedure and match rate.

*PENSION/EMPLOYEE RESULTS

gen ln_fut_pension = ln(avg_fut_pension)
gen ln_pre_pension = ln(avg_pre_pension)
gen ln_pre_pension2 = ln_pre_pension*ln_pre_pension
gen ln_fut_pension_def = ln(avg_fut_pension_def)
gen ln_pre_pension_def = ln(avg_pre_pension_def)
gen ln_prepre_pension_def = ln(avg_prepre_pension_def)
gen ln_pre_pension2_def = ln_pre_pension_def*ln_pre_pension_def

**TABLE 7

*TOP PANEL
*bandwidth=.35
gen rtwxwin = rtw*win
gen winxtot_wins =win*tot_wins
reg ln_avg_diff_pension_def win if year[_n+1]-year==1& year[_n-1]-year==-1& num_votes>=20& abs(vote_share-.5)<=.35&year<=2009, cluster(number)
reg ln_avg_diff_pension_def win rtwxwin tot_wins if year[_n+1]-year==1& year[_n-1]-year==-1& num_votes>=20& abs(vote_share-.5)<=.35&year<=2009, cluster(number)
reg ln_avg_diff_pension_def win rtwxwin tot_wins i.naics3 if year[_n+1]-year==1& year[_n-1]-year==-1& num_votes>=20& abs(vote_share-.5)<=.35&year<=2009, cluster(number)
reg ln_avg_diff_pension_def win rtwxwin tot_wins i.year i.naics3 if year[_n+1]-year==1& year[_n-1]-year==-1& num_votes>=20& abs(vote_share-.5)<=.35&year<=2009, cluster(number)

*BOTTOM PANEL
*bandwidth = all, 20 votes
reg ln_avg_diff_pension_def win if year[_n+1]-year==1& year[_n-1]-year==-1& num_votes>=20& abs(vote_share-.5)<=.5&year<=2009, cluster(number)
reg ln_avg_diff_pension_def win rtwxwin tot_wins if year[_n+1]-year==1& year[_n-1]-year==-1& num_votes>=20& abs(vote_share-.5)<=.5&year<=2009, cluster(number)
reg ln_avg_diff_pension_def win rtwxwin tot_wins i.naics3 if year[_n+1]-year==1& year[_n-1]-year==-1& num_votes>=20& abs(vote_share-.5)<=.5&year<=2009, cluster(number)
reg ln_avg_diff_pension_def win rtwxwin tot_wins i.year i.naics3 if year[_n+1]-year==1& year[_n-1]-year==-1& num_votes>=20& abs(vote_share-.5)<=.5&year<=2009, cluster(number)
 
**HISTOGRAMS

*FIGURE 1(b)
hist vote_share if num_votes>=20, width(.050000001) addplot(pci 0 .5 2.2 .5) legend(off) title("Union Vote Share Density") subtitle("Compustat Sample") xtitle("union vote share")

*FIGURE 7
hist margin if num_votes>=20 &abs(margin)<=30, width(1.00001) xlabel(-30(10)30) addplot(pci 0 0 .034 0) legend(off) title("Union Votes Margin Density") subtitle("Compustat Sample") xtitle("votes margin")

*****BY BIN, RD GRAPHS
*COMPENSATION
summ ln_diff_wage_def if [vote_share>=0&vote_share<=.10& type=="RC"]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1 &year<=2009
summ ln_diff_wage_def if [vote_share>.1&vote_share<=.20& type=="RC"]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1&year<=2009
summ ln_diff_wage_def if [vote_share>.2&vote_share<=.30& type=="RC"]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1&year<=2009
summ ln_diff_wage_def if [vote_share>.3&vote_share<=.40& type=="RC"]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1 &year<=2009
summ ln_diff_wage_def if [vote_share>.4&vote_share<=.50& type=="RC"]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1&year<=2009
summ ln_diff_wage_def if [vote_share>.5&vote_share<=.60& type=="RC"]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1&year<=2009
summ ln_diff_wage_def if [vote_share>.6&vote_share<=.70& type=="RC"]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1&year<=2009
summ ln_diff_wage_def if [vote_share>.7&vote_share<=.80& type=="RC"]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1&year<=2009
summ ln_diff_wage_def if [vote_share>.8&vote_share<=.90& type=="RC"]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1&year<=2009
summ ln_diff_wage_def if [vote_share>.9&vote_share<=1& type=="RC"]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1&year<=2009

summ ln_diff_pre_wage_def if [vote_share>=0&vote_share<=.10& type=="RC"]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1 &year<=2009
summ ln_diff_pre_wage_def if [vote_share>.1&vote_share<=.20& type=="RC"]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1&year<=2009
summ ln_diff_pre_wage_def if [vote_share>.2&vote_share<=.30& type=="RC"]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1&year<=2009
summ ln_diff_pre_wage_def if [vote_share>.3&vote_share<=.40& type=="RC"]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1 &year<=2009
summ ln_diff_pre_wage_def if [vote_share>.4&vote_share<=.50& type=="RC"]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1&year<=2009
summ ln_diff_pre_wage_def if [vote_share>.5&vote_share<=.60& type=="RC"]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1&year<=2009
summ ln_diff_pre_wage_def if [vote_share>.6&vote_share<=.70& type=="RC"]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1&year<=2009
summ ln_diff_pre_wage_def if [vote_share>.7&vote_share<=.80& type=="RC"]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1&year<=2009
summ ln_diff_pre_wage_def if [vote_share>.8&vote_share<=.90& type=="RC"]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1&year<=2009
summ ln_diff_pre_wage_def if [vote_share>.9&vote_share<=1& type=="RC"]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1&year<=2009

summ Lln_wage_def if [vote_share>=0&vote_share<=.10& type=="RC"]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1 &year<=2009
summ Lln_wage_def if [vote_share>.1&vote_share<=.20& type=="RC"]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1&year<=2009
summ Lln_wage_def if [vote_share>.2&vote_share<=.30& type=="RC"]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1&year<=2009
summ Lln_wage_def if [vote_share>.3&vote_share<=.40& type=="RC"]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1 &year<=2009
summ Lln_wage_def if [vote_share>.4&vote_share<=.50& type=="RC"]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1&year<=2009
summ Lln_wage_def if [vote_share>.5&vote_share<=.60& type=="RC"]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1&year<=2009
summ Lln_wage_def if [vote_share>.6&vote_share<=.70& type=="RC"]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1&year<=2009
summ Lln_wage_def if [vote_share>.7&vote_share<=.80& type=="RC"]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1&year<=2009
summ Lln_wage_def if [vote_share>.8&vote_share<=.90& type=="RC"]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1&year<=2009
summ Lln_wage_def if [vote_share>.9&vote_share<=1& type=="RC"]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1&year<=2009

summ Lln_emp if [vote_share>=0&vote_share<=.10& type=="RC"]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1 &year<=2009
summ Lln_emp if [vote_share>.1&vote_share<=.20& type=="RC"]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1&year<=2009
summ Lln_emp if [vote_share>.2&vote_share<=.30& type=="RC"]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1&year<=2009
summ Lln_emp if [vote_share>.3&vote_share<=.40& type=="RC"]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1 &year<=2009
summ Lln_emp if [vote_share>.4&vote_share<=.50& type=="RC"]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1&year<=2009
summ Lln_emp if [vote_share>.5&vote_share<=.60& type=="RC"]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1&year<=2009
summ Lln_emp if [vote_share>.6&vote_share<=.70& type=="RC"]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1&year<=2009
summ Lln_emp if [vote_share>.7&vote_share<=.80& type=="RC"]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1&year<=2009
summ Lln_emp if [vote_share>.8&vote_share<=.90& type=="RC"]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1&year<=2009
summ Lln_emp if [vote_share>.9&vote_share<=1& type=="RC"]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1&year<=2009

sort number year
summ ln_diff_wage_def if [margin_of_victory>30&margin_of_victory<=40]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1 &year<=2009
summ ln_diff_wage_def if [margin_of_victory>20&margin_of_victory<=30]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1 &year<=2009
summ ln_diff_wage_def if [margin_of_victory>10&margin_of_victory<=20]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1 &year<=2009
summ ln_diff_wage_def if [margin_of_victory>0&margin_of_victory<=10]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1 &year<=2009
summ ln_diff_wage_def if [margin_of_victory>-10&margin_of_victory<=0]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1 &year<=2009
summ ln_diff_wage_def if [margin_of_victory>-20&margin_of_victory<=-10]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1 &year<=2009
summ ln_diff_wage_def if [margin_of_victory>-30&margin_of_victory<=-20]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1 &year<=2009
summ ln_diff_wage_def if [margin_of_victory>-40&margin_of_victory<=-30]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1 &year<=2009
summ ln_diff_wage_def if [margin_of_victory>-50&margin_of_victory<=-40]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1 &year<=2009

summ ln_diff_pre_wage_def if [margin_of_victory>30&margin_of_victory<=40]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1 &year<=2009
summ ln_diff_pre_wage_def if [margin_of_victory>20&margin_of_victory<=30]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1 &year<=2009
summ ln_diff_pre_wage_def if [margin_of_victory>10&margin_of_victory<=20]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1 &year<=2009
summ ln_diff_pre_wage_def if [margin_of_victory>0&margin_of_victory<=10]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1 &year<=2009
summ ln_diff_pre_wage_def if [margin_of_victory>-10&margin_of_victory<=0]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1 &year<=2009
summ ln_diff_pre_wage_def if [margin_of_victory>-20&margin_of_victory<=-10]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1 &year<=2009
summ ln_diff_pre_wage_def if [margin_of_victory>-30&margin_of_victory<=-20]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1 &year<=2009
summ ln_diff_pre_wage_def if [margin_of_victory>-40&margin_of_victory<=-30]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1 &year<=2009
summ ln_diff_pre_wage_def if [margin_of_victory>-50&margin_of_victory<=-40]&number_of_votes>=10& year[_n+1]-year==1& year[_n-1]-year==-1 &year<=2009
