*********************************************************************************************************************
*** Replication do-file for Cornell and Grimes: ***
*** "Institutions as Incentives for Civic Action: Bureaucratic Structures, Civil Society and Disruptive Protests" ***
*** Journal of Politics ***
*********************************************************************************************************************

*******RECODING OF VARIABLES FROM THE AMERICAS BAROMETER (2012)********
***APPENDED SEPARATE DATASETS FOR EACH COUNTRY****
***www.LapopSurveys.org (accessed November 18, 2013)***

***IDENTIFIER***
gen ccode=0

recode ccode(0=	32	)	if pais==17
recode ccode(0=	84	)	if pais==26
recode ccode(0=	68	)	if pais==10
recode ccode(0=	76	)	if pais==15
recode ccode(0=	124	)	if pais==41
recode ccode(0=	152	)	if pais==13
recode ccode(0=	170	)	if pais==8
recode ccode(0=	214	)	if pais==21
recode ccode(0=	188	)	if pais==6
recode ccode(0=	218	)	if pais==9
recode ccode(0=	222	)	if pais==3
recode ccode(0=	328	)	if pais==24
recode ccode(0=	320	)	if pais==2
recode ccode(0=	332	)	if pais==22
recode ccode(0=	340	)	if pais==4
recode ccode(0=	388	)	if pais==23
recode ccode(0=	484	)	if pais==1
recode ccode(0=	558	)	if pais==5
recode ccode(0=	600	)	if pais==12
recode ccode(0=	604	)	if pais==11
recode ccode(0=	740	)	if pais==27
recode ccode(0=	840	)	if pais==40
recode ccode(0=	780	)	if pais==25
recode ccode(0=	858	)	if pais==14
recode ccode(0=	862	)	if pais==16
recode ccode(0=	591	)	if pais==7

***SAMPLE WITHOUT BOLIVIA***
gen samplenotBol=1
recode samplenotBol(1=0) if ccode==68

***DISRUPTIVE PROTESTS***
gen block_prot=. 
recode block_prot(.=0) if prot3<.
recode block_prot(0=1) if prot7==1

recode block_prot(0=.) if cname=="United States"
recode block_prot(0=.) if cname=="Canada"

***% DISRUPTIVE PROTESTS PER COUNTRY***
by ccode, sort: egen mean_block_prot=mean(block_prot)
gen per_mean_block_prot=mean_block_prot*100

***PROTESTS IN GENERAL***
gen protests=.
replace protests=1 if prot3==1
replace protests=0 if prot3==2

recode protests (0=.) if cname=="United States"
recode protests (0=.) if cname=="Canada"
recode protests (1=.) if cname=="United States"
recode protests (1=.) if cname=="Canada"

***OTHER PROTESTS***
gen non_blockprot=protests
replace non_blockprot=0 if block_prot==1


***CIVIL SOCIETY***
xi i.cp7, noomit prefix(d_)

rename d_cp7_1 cp7_1
rename d_cp7_2 cp7_2
rename d_cp7_3 cp7_3
rename d_cp7_4 cp7_4

xi i.cp8, noomit prefix(d_)
rename d_cp8_1 cp8_1
rename d_cp8_2 cp8_2
rename d_cp8_3 cp8_3
rename d_cp8_4 cp8_4

xi i.cp9, noomit prefix(d_)
rename d_cp9_1 cp9_1
rename d_cp9_2 cp9_2
rename d_cp9_3 cp9_3
rename d_cp9_4 cp9_4

xi i.cp13, noomit prefix(d_)
rename d_cp13_1 cp13_1
rename d_cp13_2 cp13_2
rename d_cp13_3 cp13_3
rename d_cp13_4 cp13_4

gen yes_cp7=.
recode yes_cp7(.=0) if cp7_4==1
recode yes_cp7(.=1) if cp7_1==1
recode yes_cp7(.=1) if cp7_2==1
recode yes_cp7(.=1) if cp7_3==1

gen yes_cp8=.
recode yes_cp8(.=0) if cp8_4==1
recode yes_cp8(.=1) if cp8_1==1
recode yes_cp8(.=1) if cp8_2==1
recode yes_cp8(.=1) if cp8_3==1

gen yes_cp9=.
recode yes_cp9(.=0) if cp9_4==1
recode yes_cp9(.=1) if cp9_1==1
recode yes_cp9(.=1) if cp9_2==1
recode yes_cp9(.=1) if cp9_3==1

gen yes_cp13=.
recode yes_cp13(.=0) if cp13_4==1
recode yes_cp13(.=1) if cp13_1==1
recode yes_cp13(.=1) if cp13_2==1
recode yes_cp13(.=1) if cp13_3==1

***CIVIL SOCIETY (INDIVIDUAL LEVEL)***
gen corepol_civ_part=yes_cp7+yes_cp8+yes_cp9+yes_cp13

***CIVIL SOCIETY STRENGTH (COUNTRY LEVEL)*** 
by ccode, sort: egen mean_corepol_civ_part=mean(corepol_civ_part)

***CIVIL STRENGTH (BROAD)***
xi i.cp6, noomit prefix(d_)
rename d_cp6_1 cp6_1
rename d_cp6_2 cp6_2
rename d_cp6_3 cp6_3
rename d_cp6_4 cp6_4

xi i.cp21, noomit prefix(d_)
rename d_cp21_1 cp21_1
rename d_cp21_2 cp21_2
rename d_cp21_3 cp21_3
rename d_cp21_4 cp21_4

gen yes_cp6=.
recode yes_cp6(.=0) if cp6_4==1
recode yes_cp6(.=1) if cp6_1==1
recode yes_cp6(.=1) if cp6_2==1
recode yes_cp6(.=1) if cp6_3==1

gen yes_cp21=.
recode yes_cp21(.=0) if cp21_4==1
recode yes_cp21(.=1) if cp21_1==1
recode yes_cp21(.=1) if cp21_2==1
recode yes_cp21(.=1) if cp21_3==1

gen add_all_civ_part=yes_cp7+yes_cp8+yes_cp9+yes_cp13+yes_cp6+yes_cp21
by ccode, sort: egen mean_add_all_civ_part=mean(add_all_civ_part)

***GENDER***
gen sex=q1
recode sex(2=0) if q1==2

***POLITICAL INTEREST***
gen polint=pol1
recode polint(1=4) if pol1==1
recode polint(2=3) if pol1==2
recode polint(3=2) if pol1==3
recode polint(4=1) if pol1==4

***BRIBE***
gen index_bribe=(exc11+exc14+exc15+exc16)/4
gen bribe=0
recode bribe(0=1) if index_bribe==1
recode bribe(0=1) if index_bribe==0.75
recode bribe(0=1) if index_bribe==0.5
recode bribe(0=1) if index_bribe==0.25

***DISSATISFACTION WITH SERVICE PROVISION***
gen dis_ind_serv=(sd2new2+sd3new2+sd6new2)/3

***NON-RESPONSIVE***
gen dis_eff1=.
recode dis_eff1(.=1) if eff1==7
recode dis_eff1(.=2) if eff1==6
recode dis_eff1(.=3) if eff1==5
recode dis_eff1(.=4) if eff1==4
recode dis_eff1(.=5) if eff1==3
recode dis_eff1(.=6) if eff1==2
recode dis_eff1(.=7) if eff1==1


*******RECODING OF COUNTRY LEVEL VARIABLES IN AVAILABLE DATASET (RECODED IN THIS VERSION)********

***GDP PER CAPITA GROWTH (2011)***
*Merge from QoG-dataset (Teorell et al. 2013)
gen unna_gdp_cap=unna_gdp/unna_pop
gen growth_unna_gdp_cap=(unna_gdp_cap-l.unna_gdp_cap)/l.unna_gdp_cap*100
rename growth_unna_gdp_cap growth_gdp_cap_2011

***GDP PER CAPITA (2011)***
*Merge from QoG-dataset (Teorell et al. 2013)
gen unna_gdp_cap=unna_gdp/unna_pop
rename unna_gdp_cap unna_gdp_cap_2011

***CIVIL LIBERTIES (2011)***
*Merge from QoG-dataset (Teorell et al. 2013)
rename fh_cl fh_cl_2011
gen rev_fh_cl_2011=.
recode rev_fh_cl_2011(.=7) if fh_cl_2011==1
recode rev_fh_cl_2011(.=6) if fh_cl_2011==2
recode rev_fh_cl_2011(.=5) if fh_cl_2011==3
recode rev_fh_cl_2011(.=4) if fh_cl_2011==4
recode rev_fh_cl_2011(.=3) if fh_cl_2011==5
recode rev_fh_cl_2011(.=2) if fh_cl_2011==6
recode rev_fh_cl_2011(.=1) if fh_cl_2011==7

***EFFECTIVE NUMBER OF ELECTIONS (DIFFERENT YEARS)***
**Merge from QoG-dataset (Teorell et al. 2013)
*gol_enep (variable merged and renamed depending on the year)
gen recel_gol_enep=.
replace recel_gol_enep=gol_enep_2011 if cname=="Argentina"
replace recel_gol_enep=gol_enep_2009 if cname=="Bolivia"
replace recel_gol_enep=gol_enep_2010 if cname=="Brazil"
replace recel_gol_enep=gol_enep_2009 if cname=="Chile"
replace recel_gol_enep=gol_enep_2010 if cname=="Colombia"
replace recel_gol_enep=gol_enep_2010 if cname=="Costa Rica"
replace recel_gol_enep=gol_enep_2010 if cname=="Dominican Republic"
replace recel_gol_enep=gol_enep_2009 if cname=="Ecuador"
replace recel_gol_enep=gol_enep_2009 if cname=="El Salvador"
replace recel_gol_enep=gol_enep_2011 if cname=="Guatemala"
replace recel_gol_enep=gol_enep_2009 if cname=="Honduras"
replace recel_gol_enep=gol_enep_2011 if cname=="Jamaica"
replace recel_gol_enep=gol_enep_2009 if cname=="Mexico"
replace recel_gol_enep=gol_enep_2011 if cname=="Nicaragua"
replace recel_gol_enep=gol_enep_2008 if cname=="Paraguay"
replace recel_gol_enep=gol_enep_2011 if cname=="Peru"
replace recel_gol_enep=gol_enep_2010 if cname=="Suriname"
replace recel_gol_enep=gol_enep_2009 if cname=="Uruguay"
replace recel_gol_enep=gol_enep_2010 if cname=="Venezuela"

***POLITICAL RIGHTS***
rename fh_pr fh_pr_2011
gen rev_fh_pr_2011=.
recode rev_fh_pr_2011(.=7) if fh_pr_2011==1
recode rev_fh_pr_2011(.=6) if fh_pr_2011==2
recode rev_fh_pr_2011(.=5) if fh_pr_2011==3
recode rev_fh_pr_2011(.=4) if fh_pr_2011==4
recode rev_fh_pr_2011(.=3) if fh_pr_2011==5
recode rev_fh_pr_2011(.=2) if fh_pr_2011==6
recode rev_fh_pr_2011(.=1) if fh_pr_2011==7



*******MAIN ARTICLE********
***************************

*******FIGURE 1. DISRUPTIVE PROTESTS******
xtmelogit block_prot mean_corepol_civ_part q2_b q2 sex ed polint bribe dis_ind_serv dis_eff1 b47a || ccode: if nresp>2, or
gen sample1=0
recode sample1(0=1) if e(sample)==1

graph bar (mean) per_mean_block_prot if sample1==1, over(cname)

*******TABLE 1. DISRUPTIVE PROTESTS******
***Model 1
eststo:xtmelogit block_prot mean_corepol_civ_part q2_b q2 sex ed polint bribe dis_ind_serv dis_eff1 b47a || ccode: if nresp>2, or
estat icc
***Model 2
eststo:xtmelogit block_prot mean_corepol_civ_part q2_b gd_ptss_2011 growth_gdp_cap_2011 van_comp_2010 || ccode: if nresp>2, or
estat icc
***Model 3
eststo:xtmelogit block_prot mean_corepol_civ_part q2_b q2 sex ed polint bribe dis_ind_serv dis_eff1 b47a gd_ptss_2011 growth_gdp_cap_2011 ///
van_comp_2010 || ccode: if nresp>2, or
estat icc
***Model 4
eststo:xtmelogit block_prot c.mean_corepol_civ_part##c.q2_b q2 sex ed polint bribe dis_ind_serv dis_eff1 b47a || ccode: if nresp>2, or
estat icc
***Model 5
eststo:xtmelogit block_prot c.mean_corepol_civ_part##c.q2_b gd_ptss_2011 growth_gdp_cap_2011 van_comp_2010 || ccode: if nresp>2, or
estat icc
***Model 6
eststo:xtmelogit block_prot c.mean_corepol_civ_part##c.q2_b q2 sex ed polint bribe dis_ind_serv dis_eff1 b47a gd_ptss_2011 growth_gdp_cap_2011 van_comp_2010 || ccode: if nresp>2, or
estat icc

esttab using table1.rtf, star(* 0.05) constant aic bic eform scalars(ll) se

eststo clear


*******EMPTY MODEL******
xtmelogit block_prot || ccode: if e(sample)==1, or
estat icc


*******FIGURE 2. DISRUPTIVE PROTESTS Ð CONDITIONAL MARGINAL EFFECTS OF POLITICAL CONTROL OF THE BUREAUCRACY AT DIFFERENT LEVELS OF CIVIL SOCIETY STRENGTH******
xtmelogit block_prot c.mean_corepol_civ_part##c.q2_b q2 sex ed polint bribe dis_ind_serv dis_eff1 b47a gd_ptss_2011 growth_gdp_cap_2011 van_comp_2010 || ccode: if nresp>2, or
margins , dydx(q2_b) asbalanced atmeans predict(mu fixedonly) at(mean_corepol_civ_part=( 0.5 (.1) 1.4))
marginsplot, yline(0)


*******TABLE 2. THE INTENSIFYING EFFECTS OF CIVIL SOCIETY STRENGTH Ð ADDITIONAL TESTS******
***Model 1
eststo:xtmelogit block_prot c.mean_corepol_civ_part##c.bribe c.mean_corepol_civ_part##c.q2_b q2 sex ed polint dis_ind_serv dis_eff1 b47a gd_ptss_2011 growth_gdp_cap_2011 van_comp_2010|| ccode: if nresp>2, or
estat icc
***Model 2
eststo:xtmelogit block_prot c.mean_corepol_civ_part##c.dis_ind_serv c.mean_corepol_civ_part##c.q2_b q2 sex ed polint bribe dis_eff1 b47a gd_ptss_2011 growth_gdp_cap_2011 van_comp_2010|| ccode: if nresp>2, or
estat icc
***Model 3
eststo:xtmelogit block_prot c.mean_corepol_civ_part##c.dis_eff1 c.mean_corepol_civ_part##c.q2_b q2 sex ed polint bribe dis_ind_serv b47a gd_ptss_2011 growth_gdp_cap_2011 van_comp_2010|| ccode: if nresp>2, or
estat icc
***Model 4
eststo:xtmelogit block_prot c.mean_corepol_civ_part##c.growth_gdp_cap_2011 c.mean_corepol_civ_part##c.q2_b q2 sex ed polint bribe dis_ind_serv dis_eff1 b47a gd_ptss_2011 van_comp_2010|| ccode: if nresp>2, or
estat icc
***Model 5
eststo:xtmelogit block_prot c.mean_corepol_civ_part##c.van_comp_2010 c.mean_corepol_civ_part##c.q2_b q2 sex ed polint bribe dis_ind_serv dis_eff1 b47a gd_ptss_2011 growth_gdp_cap_2011|| ccode: if nresp>2, or
estat icc
***Model 6
eststo:xtmelogit block_prot c.mean_corepol_civ_part##c.b47a c.mean_corepol_civ_part##c.q2_b q2 sex ed polint dis_ind_serv bribe dis_eff1 gd_ptss_2011 growth_gdp_cap_2011 van_comp_2010|| ccode: if nresp>2, or
estat icc
esttab using table2.rtf, star(* 0.05) constant aic bic eform scalars(ll) se

eststo clear


*******FIGURE 3. DISRUPTIVE PROTESTS Ð CONDITIONAL MARGINAL EFFECTS OF DISSATISFACTION WITH PUBLIC SERVICES AT DIFFERENT LEVELS OF CIVIL SOCIETY STRENGTH******
xtmelogit block_prot c.mean_corepol_civ_part##c.dis_ind_serv c.mean_corepol_civ_part##c.q2_b q2 sex ed polint bribe dis_eff1 b47a gd_ptss_2011 growth_gdp_cap_2011 van_comp_2010|| ccode: if nresp>2, or
margins , dydx(dis_ind_serv) asbalanced atmeans predict(mu fixedonly) at(mean_corepol_civ_part=( 0.5 (.1) 1.4))
marginsplot, yline(0)


*******TABLE 3. ADDITIONAL COUNTRY LEVEL CONTROLS******
***Model 1
eststo:xtmelogit block_prot c.mean_corepol_civ_part##c.q2_b q2 sex ed polint bribe dis_ind_serv dis_eff1 b47a gd_ptss_2011 unna_gdp_cap van_comp_2010|| ccode: if nresp>2, or
estat icc
***Model 2
eststo:xtmelogit block_prot c.mean_corepol_civ_part##c.q2_b q2 sex ed polint bribe dis_ind_serv dis_eff1 b47a growth_gdp_cap_2011 van_comp_2010 rev_fh_cl_2011|| ccode: if nresp>2, or
estat icc
***Model 3
eststo:xtmelogit block_prot c.mean_corepol_civ_part##c.q2_b q2 sex ed polint bribe dis_ind_serv dis_eff1 b47a gd_ptss_2011 growth_gdp_cap_2011 recel_gol_enep|| ccode: if nresp>2, or
estat icc
***Model 4
eststo:xtmelogit block_prot c.mean_corepol_civ_part##c.q2_b q2 sex ed polint bribe dis_ind_serv dis_eff1 b47a growth_gdp_cap_2011 van_comp_2010 rev_fh_pr_2011|| ccode: if nresp>2, or
estat icc
***Model 5
eststo:xtmelogit block_prot c.mean_corepol_civ_part##c.q2_b q2 sex ed polint bribe dis_ind_serv dis_eff1 b47a growth_gdp_cap_2011 van_comp_2010 p_polity2_2011|| ccode: if nresp>2, or
estat icc
esttab using table3.rtf, star(* 0.05) constant aic bic eform scalars(ll) se
eststo clear


*******ONLINE APPENDIX********
******************************

*******TABLE A1. COUNTRIES INCLUDED IN THE SAMPLE******
tab cname if sample1==1


*******TABLE A2. SUMMARY STATISTICS******
sum q2_b block_prot protests non_blockprot mean_corepol_civ_part mean_add_all_civ_part q2 sex ed polint bribe dis_ind_serv dis_eff1 b47a corepol_civ_part ///
gd_ptss_2011 growth_gdp_cap_2011 van_comp_2010 unna_gdp_cap ///
rev_fh_cl_2011 recel_gol_enep rev_fh_pr_2011 ///
p_polity2_2011 party_inst_2013 if sample1==1


*******TABLE A4. CONTROL FOR CIVIL SOCIETY AT THE INDIVIDUAL LEVEL******
***Model 1
eststo:xtmelogit block_prot mean_corepol_civ_part q2_b corepol_civ_part q2 sex ed polint bribe dis_ind_serv dis_eff1 b47a || ccode: if nresp>2, or
estat icc
***Model 2
eststo:xtmelogit block_prot mean_corepol_civ_part q2_b corepol_civ_part q2 sex ed polint bribe dis_ind_serv dis_eff1 b47a gd_ptss_2011 growth_gdp_cap_2011 ///
van_comp_2010 || ccode: if nresp>2, or
estat icc
***Model 3
eststo:xtmelogit block_prot c.mean_corepol_civ_part##c.q2_b corepol_civ_part q2 sex ed polint bribe dis_ind_serv dis_eff1 b47a || ccode: if nresp>2, or
estat icc
***Model 4
eststo:xtmelogit block_prot c.mean_corepol_civ_part##c.q2_b corepol_civ_part q2 sex ed polint bribe dis_ind_serv dis_eff1 b47a gd_ptss_2011 growth_gdp_cap_2011 van_comp_2010|| ccode: if nresp>2, or
estat icc
esttab using tableA4.rtf, star(* 0.05) constant aic bic eform scalars(ll) se
eststo clear


*******TABLE A5. PROTESTS IN GENERAL AS DEPENDENT VARIABLE******
***Model 1
eststo:xtmelogit protests mean_corepol_civ_part q2_b q2 sex ed polint bribe dis_ind_serv dis_eff1 b47a || ccode: if nresp>2, or
estat icc
***Model 2
eststo:xtmelogit protests mean_corepol_civ_part q2_b gd_ptss_2011 growth_gdp_cap_2011 van_comp_2010 || ccode: if nresp>2, or
estat icc
***Model 3
eststo:xtmelogit protests mean_corepol_civ_part q2_b q2 sex ed polint bribe dis_ind_serv dis_eff1 b47a gd_ptss_2011 growth_gdp_cap_2011 ///
van_comp_2010 || ccode: if nresp>2, or
estat icc
***Model 4
eststo:xtmelogit protests c.mean_corepol_civ_part##c.q2_b q2 sex ed polint bribe dis_ind_serv dis_eff1 b47a || ccode: if nresp>2, or
estat icc
***Model 5
eststo:xtmelogit protests c.mean_corepol_civ_part##c.q2_b gd_ptss_2011 growth_gdp_cap_2011 van_comp_2010 || ccode: if nresp>2, or
estat icc
***Model 6
eststo:xtmelogit protests c.mean_corepol_civ_part##c.q2_b q2 sex ed polint bribe dis_ind_serv dis_eff1 b47a gd_ptss_2011 growth_gdp_cap_2011 van_comp_2010|| ccode: if nresp>2, or
estat icc

esttab using tableA5.rtf, star(* 0.05) constant aic bic eform scalars(ll) se
eststo clear


*******TABLE A6. OTHER PROTESTS AS DEPENDENT VARIABLE******
***Model 1
eststo:xtmelogit non_blockprot mean_corepol_civ_part q2_b q2 sex ed polint bribe dis_ind_serv dis_eff1 b47a || ccode: if nresp>2, or
estat icc
***Model 2
eststo:xtmelogit non_blockprot mean_corepol_civ_part q2_b gd_ptss_2011 growth_gdp_cap_2011 van_comp_2010 || ccode: if nresp>2, or
estat icc
***Model 3
eststo:xtmelogit non_blockprot mean_corepol_civ_part q2_b q2 sex ed polint bribe dis_ind_serv dis_eff1 b47a gd_ptss_2011 growth_gdp_cap_2011 ///
van_comp_2010 || ccode: if nresp>2, or
estat icc
***Model 4
eststo:xtmelogit non_blockprot c.mean_corepol_civ_part##c.q2_b q2 sex ed polint bribe dis_ind_serv dis_eff1 b47a || ccode: if nresp>2, or
estat icc
***Model 5
eststo:xtmelogit non_blockprot c.mean_corepol_civ_part##c.q2_b gd_ptss_2011 growth_gdp_cap_2011 van_comp_2010 || ccode: if nresp>2, or
estat icc
***Model 6
eststo:xtmelogit non_blockprot c.mean_corepol_civ_part##c.q2_b q2 sex ed polint bribe dis_ind_serv dis_eff1 b47a gd_ptss_2011 growth_gdp_cap_2011 van_comp_2010|| ccode: if nresp>2, or
estat icc

esttab using tableA6.rtf, star(* 0.05) constant aic bic eform scalars(ll) se
eststo clear


*******TABLE A7. DISRUPTIVE PROTESTS Ð ADDITIONAL TESTS******
***Model 1
eststo:xtmelogit block_prot c.mean_corepol_civ_part##c.q2_b q2 sex ed polint bribe dis_ind_serv dis_eff1 b47a gd_ptss_2011 growth_gdp_cap_2011 van_comp_2010 || ccode: if nresp>2 & samplenotBol==1, or
estat icc
***Model 2
eststo:xtmelogit block_prot c.mean_add_all_civ_part##c.q2_b q2 sex ed polint bribe dis_ind_serv dis_eff1 b47a gd_ptss_2011 growth_gdp_cap_2011 van_comp_2010|| ccode: if nresp>2, or
estat icc
***Model 3
eststo:xtmelogit block_prot c.mean_corepol_civ_part##c.q2_b q2 sex ed polint bribe dis_ind_serv dis_eff1 b47a gd_ptss_2011 growth_gdp_cap_2011 van_comp_2010 party_inst_2013 || ccode: if nresp>2, or
estat icc

esttab using tableA7.rtf, star(* 0.05) constant aic bic eform scalars(ll) se
eststo clear


*******TABLE A8. DISRUPTIVE PROTESTS Ð COUNTRY CONTROLS ONE BY ONE******
***Model 1
eststo:xtmelogit block_prot c.mean_corepol_civ_part##c.q2_b q2 sex ed polint bribe dis_ind_serv dis_eff1 b47a gd_ptss_2011 || ccode: if nresp>2, or
estat icc
***Model 2
eststo:xtmelogit block_prot c.mean_corepol_civ_part##c.q2_b q2 sex ed polint bribe dis_ind_serv dis_eff1 b47a growth_gdp_cap_2011 || ccode: if nresp>2, or
estat icc
***Model 3
eststo:xtmelogit block_prot c.mean_corepol_civ_part##c.q2_b q2 sex ed polint bribe dis_ind_serv dis_eff1 b47a van_comp_2010 || ccode: if nresp>2, or
estat icc

esttab using tableA8.rtf, star(* 0.05) constant aic bic eform scalars(ll) se
eststo clear


*******TABLE A9. DISRUPTIVE PROTESTS Ð ADDITIONAL COUNTRY CONTROLS ONE BY ONE******
***Model 1
eststo:xtmelogit block_prot c.mean_corepol_civ_part##c.q2_b q2 sex ed polint bribe dis_ind_serv dis_eff1 b47a unna_gdp_cap_2011 || ccode: if nresp>2, or
estat icc
***Model 2
eststo:xtmelogit block_prot c.mean_corepol_civ_part##c.q2_b q2 sex ed polint bribe dis_ind_serv dis_eff1 b47a rev_fh_cl_2011 || ccode: if nresp>2, or
estat icc
***Model 3
eststo:xtmelogit block_prot c.mean_corepol_civ_part##c.q2_b q2 sex ed polint bribe dis_ind_serv dis_eff1 b47a recel_gol_enep || ccode: if nresp>2, or
estat icc
***Model 4
eststo:xtmelogit block_prot c.mean_corepol_civ_part##c.q2_b q2 sex ed polint bribe dis_ind_serv dis_eff1 b47a rev_fh_pr_2011 || ccode: if nresp>2, or
estat icc
***Model 5
eststo:xtmelogit block_prot c.mean_corepol_civ_part##c.q2_b q2 sex ed polint bribe dis_ind_serv dis_eff1 b47a p_polity2_2011 || ccode: if nresp>2, or
estat icc
***Model 6
eststo:xtmelogit block_prot c.mean_corepol_civ_part##c.q2_b q2 sex ed polint bribe dis_ind_serv dis_eff1 b47a party_inst_2013 || ccode: if nresp>2, or
estat icc

esttab using tableA9.rtf, star(* 0.05) constant aic bic eform scalars(ll) se
eststo clear


*******FIGURE A1. POLITICAL CONTROL OF THE BUREAUCRACY******
graph bar (mean) q2_b, over(cname)


*******FIGURE A2. PROTESTS IN GENERAL Ð CONDITIONAL MARGINAL EFFECTS OF POLITICAL CONTROL OF THE BUREAUCRACY AT DIFFERENT LEVELS OF CIVIL SOCIETY STRENGTH******
xtmelogit protests c.mean_corepol_civ_part##c.q2_b q2 sex ed polint bribe dis_ind_serv dis_eff1 b47a gd_ptss_2011 growth_gdp_cap_2011 van_comp_2010|| ccode: if nresp>2, or
margins , dydx(q2_b) asbalanced atmeans predict(mu fixedonly) at(mean_corepol_civ_part=( 0.5 (.1) 1.4))
marginsplot, yline(0)


*******FIGURE A3. OTHER PROTESTS Ð CONDITIONAL MARGINAL EFFECTS OF POLITICAL CONTROL OF THE BUREAUCRACY AT DIFFERENT LEVELS OF CIVIL SOCIETY STRENGTH******
xtmelogit non_blockprot c.mean_corepol_civ_part##c.q2_b q2 sex ed polint bribe dis_ind_serv dis_eff1 b47a gd_ptss_2011 growth_gdp_cap_2011 van_comp_2010|| ccode: if nresp>2, or
margins , dydx(q2_b) asbalanced atmeans predict(mu fixedonly) at(mean_corepol_civ_part=( 0.5 (.1) 1.4))
marginsplot, yline(0)


*******FIGURE A4. DISRUPTIVE PROTESTS Ð CONDITIONAL MARGINAL EFFECTS OF POLITICAL CONTROL OF THE BUREAUCRACY AT DIFFERENT LEVELS OF CIVIL SOCIETY STRENGTH - BROADER MEASURE OF CIVIL SOCIETY******
xtmelogit block_prot c.mean_add_all_civ_part##c.q2_b q2 sex ed polint bribe dis_ind_serv dis_eff1 b47a gd_ptss_2011 growth_gdp_cap_2011 van_comp_2010|| ccode: if nresp>2, or
margins , dydx(q2_b) asbalanced atmeans predict(mu fixedonly) at(mean_add_all_civ_part=( 1 (.1) 2.4))
marginsplot, yline(0)

