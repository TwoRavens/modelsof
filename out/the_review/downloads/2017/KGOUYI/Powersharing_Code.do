%% Replication code for "Safeguarding Democracy: Powersharing and Democratic Survival," 
%% by Benjamin Graham, Michael K. Miller, and Kaare Strom in APSR. Prepared 6/14/17.


% Main results (Tables 3-4)

global base "ELF fueldep gdp_grow bmr2_prevauth regionpolity2 lnpop loggdp yearpow yearpow2 yearpow3 bmr2_age inclusive_nm_IDC dispersive_nm_IDC constraining_nm_IDC"
global base "fhcl_s polcon ELF fueldep gdp_grow bmr2_prevauth regionpolity2 lnpop loggdp yearpow yearpow2 yearpow3 bmr2_age inclusive_nm_IDC dispersive_nm_IDC constraining_nm_IDC"
global base "reg5 irreg5 polity2 disrupted fhcl_s polcon ELF fueldep gdp_grow bmr2_prevauth regionpolity2 lnpop loggdp yearpow yearpow2 yearpow3 bmr2_age inclusive_nm_IDC dispersive_nm_IDC constraining_nm_IDC"
global error "r"

eststo clear

eststo: quietly probit F5.bmr2 $base if bmr2==1, $error
eststo: quietly probit F5.bmr2 $base civilwari_end10 incl_civwari_end10 disp_civwari_end10 cons_civwari_end10 if bmr2==1, $error

esttab, pr2 b(3) label order(inclusive_nm_IDC dispersive_nm_IDC constraining_nm_IDC ELF regionpolity2 loggdp gdp_grow fueldep lnpop bmr2_prevauth bmr2_age fhcl_s polcon reg5 irreg5 polity2 disrupted)




% Hard cases (Figure 4, Table A12)

global base "ELF fueldep gdp_grow bmr2_prevauth regionpolity2 lnpop loggdp yearpow yearpow2 yearpow3 bmr2_age inclusive_nm_IDC dispersive_nm_IDC constraining_nm_IDC"
global cond ""
eststo nohard1: quietly probit F5.bmr2 $base if bmr2==1 $cond, $error
global cond "& civilwari10==1"
eststo hard1: quietly probit F5.bmr2 $base if bmr2==1 $cond, $error
global cond "& intconflictd_end10==1"
eststo hard2: quietly probit F5.bmr2 $base if bmr2==1 $cond, $error
global cond "& pitf_ethnic_ever==1"
eststo hard3: quietly probit F5.bmr2 $base if bmr2==1 $cond, $error
global cond "& sfi_SFI >= 11 & sfi_SFI!=."
eststo hard4: quietly probit F5.bmr2 $base if bmr2==1 $cond, $error
global cond "& bmr2_age <= 10"
eststo hard5: quietly probit F5.bmr2 $base if bmr2==1 $cond, $error
global cond "& loggdp < 8.243"
eststo hard6: quietly probit F5.bmr2 $base if bmr2==1 $cond, $error
global cond "& recentcrisis==1"
eststo hard7: quietly probit F5.bmr2 $base if bmr2==1 $cond, $error
global cond "& epr_ethrel < 4"
eststo hard8: quietly probit F5.bmr2 $base if bmr2==1 $cond, $error
global cond "& ELF > .596 & ELF!=."
eststo hard9: quietly probit F5.bmr2 $base if bmr2==1 $cond, $error
global cond "& dem_surv < .936"
eststo hard10: quietly probit F5.bmr2 $base if bmr2==1 $cond, $error

coefplot nohard1, label(Full) || hard1 || hard2 || hard3 || hard4 || hard5 || hard6 || hard7 || hard8 || hard9 || hard10, keep(inclusive_nm_IDC dispersive_nm_IDC constraining_nm_IDC) order(incl* disp* cons*) vertical yline(0,lcol(black) lp(dash)) ciopts(lcolor(black)) mcolor(black) legend(off) ylabel(,angle(0)) bycoef byopts(yrescale row(3))




% Civil conflict (Table A1)

global base "ELF fueldep gdp_grow bmr2_prevauth regionpolity2 lnpop loggdp yearpow yearpow2 yearpow3 bmr2_age inclusive_nm_IDC dispersive_nm_IDC constraining_nm_IDC"
global base "fhcl_s polcon ELF fueldep gdp_grow bmr2_prevauth regionpolity2 lnpop loggdp yearpow yearpow2 yearpow3 bmr2_age inclusive_nm_IDC dispersive_nm_IDC constraining_nm_IDC"
global base "reg5 irreg5 polity2 disrupted fhcl_s polcon ELF fueldep gdp_grow bmr2_prevauth regionpolity2 lnpop loggdp yearpow yearpow2 yearpow3 bmr2_age inclusive_nm_IDC dispersive_nm_IDC constraining_nm_IDC"
eststo: quietly probit F5.bmr2 $base intconflictd_end10 incl_intconflictd_end10 cons_intconflictd_end10 disp_intconflictd_end10 if bmr2==1, $error


% Include currently at war (Table A2)

global base "ELF fueldep gdp_grow bmr2_prevauth regionpolity2 lnpop loggdp yearpow yearpow2 yearpow3 bmr2_age inclusive_nm_IDC dispersive_nm_IDC constraining_nm_IDC"
global base "fhcl_s polcon ELF fueldep gdp_grow bmr2_prevauth regionpolity2 lnpop loggdp yearpow yearpow2 yearpow3 bmr2_age inclusive_nm_IDC dispersive_nm_IDC constraining_nm_IDC"
global base "reg5 irreg5 polity2 disrupted fhcl_s polcon ELF fueldep gdp_grow bmr2_prevauth regionpolity2 lnpop loggdp yearpow yearpow2 yearpow3 bmr2_age inclusive_nm_IDC dispersive_nm_IDC constraining_nm_IDC"
eststo: quietly probit F5.bmr2 $base civilwari10 incl_civwari10 cons_civwari10 disp_civwari10 if bmr2==1, $error


% Post-civil war year range (Table A3)

global base "ELF fueldep gdp_grow bmr2_prevauth regionpolity2 lnpop loggdp yearpow yearpow2 yearpow3 bmr2_age inclusive_nm_IDC dispersive_nm_IDC constraining_nm_IDC"
eststo: quietly probit F5.bmr2 $base civilwari_end5 incl_civwari_end5 cons_civwari_end5 disp_civwari_end5 if bmr2==1, $error
eststo: quietly probit F5.bmr2 $base civilwari_end10 incl_civwari_end10 cons_civwari_end10 disp_civwari_end10 if bmr2==1, $error
eststo: quietly probit F5.bmr2 $base civilwari_end15 incl_civwari_end15 cons_civwari_end15 disp_civwari_end15 if bmr2==1, $error


% Controls for civil war types (Table A4)

global base "ELF fueldep gdp_grow bmr2_prevauth regionpolity2 lnpop loggdp yearpow yearpow2 yearpow3 bmr2_age inclusive_nm_IDC dispersive_nm_IDC constraining_nm_IDC"
eststo: quietly probit F5.bmr2 $base civilwari_sep10 civilwari_end10 incl_civwari_end10 disp_civwari_end10 cons_civwari_end10 if bmr2==1, $error
eststo: quietly probit F5.bmr2 $base civilwari_compromise10 civilwari_end10 incl_civwari_end10 disp_civwari_end10 cons_civwari_end10 if bmr2==1, $error
eststo: quietly probit F5.bmr2 $base civilwari_peacek10c civilwari_end10 incl_civwari_end10 disp_civwari_end10 cons_civwari_end10 if bmr2==1, $error




% Alternative democracy measures (Table A5)

global base "ELF fueldep gdp_grow regionpolity2 lnpop loggdp yearpow yearpow2 yearpow3 inclusive_nm_IDC dispersive_nm_IDC constraining_nm_IDC"
global dembin "chga_s"
global dembin2 "chga_prevauth chga_age"
global dembin "poldem"
global dembin2 "poldem_prevauth poldem_age"

eststo: quietly probit F5.$dembin $base $dembin2 if $dembin==1, $error
eststo: quietly probit F5.$dembin $base $dembin2 civilwari_end10 incl_civwari_end10 disp_civwari_end10 cons_civwari_end10 if $dembin==1, $error

global demcont "polity_noxconst"
eststo: quietly reg F5.$demcont $demcont $base $dembin2 if $dembin==1, $error
eststo: quietly reg F5.$demcont $demcont $base $dembin2 civilwari_end10 incl_civwari_end10 disp_civwari_end10 cons_civwari_end10 if $dembin==1, $error


% Alternative controls (inequality, aid, state capacity) (Table A6)

global base "ELF fueldep gdp_grow bmr2_prevauth regionpolity2 lnpop loggdp yearpow yearpow2 yearpow3 bmr2_age inclusive_nm_IDC dispersive_nm_IDC constraining_nm_IDC"
eststo: quietly probit F5.bmr2 gini2 aid $base if bmr2==1, $error
eststo: quietly probit F5.bmr2 gini2 aid $base civilwari_end10 incl_civwari_end10 disp_civwari_end10 cons_civwari_end10 if bmr2==1, $error
eststo: quietly probit F5.bmr2 state_capacity $base if bmr2==1, $error
eststo: quietly probit F5.bmr2 state_capacity $base civilwari_end10 incl_civwari_end10 disp_civwari_end10 cons_civwari_end10 if bmr2==1, $error

% Interactions between powersharing dimensions + state capacity
eststo: quietly probit F5.bmr2 state_capacity incl_capacity disp_capacity cons_capacity $base if bmr2==1, $error
eststo: quietly probit F5.bmr2 state_capacity incl_capacity disp_capacity cons_capacity $base if bmr2==1 & civilwari_end10==1, $error


% Alternative duration models (Table A7)

global base "bmr2_age bmr2_age2 bmr2_age3 ELF fueldep gdp_grow bmr2_prevauth regionpolity2 lnpop loggdp yearpow yearpow2 yearpow3 bmr2_age inclusive_nm_IDC dispersive_nm_IDC constraining_nm_IDC"
global base "lnbmr_age ELF fueldep gdp_grow bmr2_prevauth regionpolity2 lnpop loggdp yearpow yearpow2 yearpow3 bmr2_age inclusive_nm_IDC dispersive_nm_IDC constraining_nm_IDC"
version 10: eststo: quietly probit F5.bmr2 $base if bmr2==1, $error
version 10: eststo: quietly probit F5.bmr2 $base civilwari_end10 incl_civwari_end10 disp_civwari_end10 cons_civwari_end10 if bmr2==1, $error

global stx "d(exp)"
global stx "d(w)"
global base "ELF fueldep gdp_grow bmr2_prevauth regionpolity2 lnpop loggdp yearpow yearpow2 yearpow3 inclusive_nm_IDC dispersive_nm_IDC constraining_nm_IDC"
version 10: eststo: quietly streg $base if bmr2==1, vce(robust) $stx
version 10: eststo: quietly streg $base civilwari_end10 incl_civwari_end10 disp_civwari_end10 cons_civwari_end10 if bmr2==1, vce(robust) $stx
version 10: eststo: quietly stcox $base if bmr2==1, vce(robust)
version 10: eststo: quietly stcox $base civilwari_end10 incl_civwari_end10 disp_civwari_end10 cons_civwari_end10 if bmr2==1, vce(robust)




% Instrumental variables (Table A8)

global base "dispersive constraining ELF fueldep gdp_grow bmr2_prevauth regionpolity2 lnpop loggdp yearpow yearpow2 yearpow3 bmr2_age"
global iv "Britcolony nocolony d_colonial5 d_legal1 inclpr_colonizer"
global civwar " & civilwari10==1"
eststo: quietly ivprobit f5bmr2 $base (inclusive = $iv) if bmr2==1 $civwar & civilwari10!=. & statehist!=. & areamill!=. & popdens!=. & mountain!=., vce(r) first
global base "inclusive constraining ELF fueldep gdp_grow bmr2_prevauth regionpolity2 lnpop loggdp yearpow yearpow2 yearpow3 bmr2_age"
global iv "Britcolony nocolony d_colonial5 d_legal1 areamill mountain popdens"
global civwar " & civilwari10==1"
eststo: quietly ivprobit f5bmr2 $base (dispersive = $iv) if bmr2==1 $civwar & civilwari10!=. & statehist!=. & areamill!=. & popdens!=. & mountain!=., vce(r) first
global base "dispersive constraining ELF fueldep gdp_grow bmr2_prevauth regionpolity2 lnpop loggdp yearpow yearpow2 yearpow3 bmr2_age"
global iv "Britcolony nocolony d_colonial5 d_legal1 inclpr_colonizer"
global civwar ""
eststo: quietly ivprobit f5bmr2 $base (inclusive = $iv) if bmr2==1 $civwar & civilwari10!=. & statehist!=. & areamill!=. & popdens!=. & mountain!=., vce(r) first
global base "inclusive constraining ELF fueldep gdp_grow bmr2_prevauth regionpolity2 lnpop loggdp yearpow yearpow2 yearpow3 bmr2_age"
global iv "Britcolony nocolony d_colonial5 d_legal1 areamill mountain popdens"
global civwar ""
eststo: quietly ivprobit f5bmr2 $base (dispersive = $iv) if bmr2==1 $civwar & civilwari10!=. & statehist!=. & areamill!=. & popdens!=. & mountain!=., vce(r) first
global base "inclusive dispersive ELF fueldep gdp_grow bmr2_prevauth regionpolity2 lnpop loggdp yearpow yearpow2 yearpow3 bmr2_age"
global iv "Britcolony nocolony d_colonial5 d_legal1 statehist"
global civwar ""
eststo: quietly ivprobit f5bmr2 $base (constraining = $iv) if bmr2==1 $civwar & civilwari10!=. & areamill!=. & popdens!=. & mountain!=., vce(r) first




% Breakdown types (Table A9)

global base "ELF fueldep gdp_grow bmr2_prevauth regionpolity2 lnpop loggdp yearpow yearpow2 yearpow3 bmr2_age inclusive_nm_IDC dispersive_nm_IDC constraining_nm_IDC"
eststo: quietly probit demfail_violentopp_anyf5 $base if bmr2==1 & demfail_selfcoup_anyf5!=., $error
eststo: quietly probit demfail_military_anyf5 $base if bmr2==1 & demfail_selfcoup_anyf5!=., $error
eststo: quietly probit demfail_selfcoup_anyf5 $base if bmr2==1 & demfail_selfcoup_anyf5!=., $error
eststo: quietly mlogit demfail_type_f5 $base if bmr2==1, base(0) $error




% Predicting dimensions (Table A10)

global base "ELF fueldep gdp_grow bmr2_prevauth regionpolity2 lnpop loggdp yearpow yearpow2 yearpow3 bmr2_age"
eststo: quietly reg F.inclusive inclusive dispersive constraining $base if bmr2==1 & F.bmr2==1, $error
eststo: quietly reg F.dispersive inclusive dispersive constraining $base if bmr2==1 & F.bmr2==1, $error
eststo: quietly reg F.constraining inclusive dispersive constraining $base if bmr2==1 & F.bmr2==1, $error


% Interactions of dimensions (Table A11)

global base "ELF fueldep gdp_grow bmr2_prevauth regionpolity2 lnpop loggdp yearpow yearpow2 yearpow3 bmr2_age"
global dim "inclusive dispersive constraining"
global dim "inclusive dispersive constraining incl_disp incl_cons disp_cons"
global dim "inclusive dispersive constraining incl_disp incl_cons disp_cons incl_disp_cons"

eststo: quietly probit F5.bmr2 $base $dim if bmr2==1, $error
eststo: quietly probit F5.bmr2 $base $dim if bmr2==1 & civilwari_end10==1, $error
eststo: quietly probit F5.bmr2 $base $dim if bmr2==1 & civilwari_end10==0, $error
eststo: quietly probit F5.bmr2 $base $dim if bmr2==1 & civilwari10==1, $error
eststo: quietly probit F5.bmr2 $base $dim if bmr2==1 & civilwari10==0, $error
eststo: quietly probit F5.bmr2 $base $dim if bmr2==1 & intconflictd_end10==1, $error
eststo: quietly probit F5.bmr2 $base $dim if bmr2==1 & intconflictd_end10==0, $error




% Sensitivity analysis

global base "ELF fueldep gdp_grow bmr2_prevauth regionpolity2 lnpop loggdp yearpow yearpow2 yearpow3 bmr2_age inclusive_nm_IDC dispersive_nm_IDC constraining_nm_IDC"
quietly probit F5.bmr2 $base if bmr2==1, $error
quietly probit F5.bmr2 constraining_nm_IDC if bmr2==1, $error
quietly probit F5.bmr2 $base if bmr2==1 & civilwari_end10==1, $error
quietly probit F5.bmr2 constraining_nm_IDC if bmr2==1 & civilwari_end10==1, $error
quietly probit F5.bmr2 inclusive_nm_IDC if bmr2==1 & civilwari_end10==1, $error
quietly probit F5.bmr2 dispersive_nm_IDC if bmr2==1 & civilwari_end10==1, $error
quietly reg F5.bmr2 $base if bmr2==1
quietly reg F5.bmr2 $base if bmr2==1 & civilwari_end10==1

psacalc constraining_nm_IDC delta
psacalc inclusive_nm_IDC delta
psacalc dispersive_nm_IDC delta







% Figures

% Figure 1
set obs 4 %% Insert values for num (11 6 11 9) & pct (2.7 1 1.32 .99)
gen period = _n
gen periodnum = period - 0.2
gen periodpct = period + 0.2
tw bar num periodnum, barw(0.4) yaxis(1) yscale(range(0) axis(1)) || bar pct periodpct, barw(0.4) yaxis(2) yscale(range(0) axis(2))


% Figure 2
tw line cons_bmrresid_avg year if year >= 1975 & year <= 2010 & ccode==2 || line disp_bmrresid_avg year if year >= 1975 & year <= 2010 & ccode==2 || line incl_bmrresid_avg year if year >= 1975 & year <= 2010 & ccode==2
tw line cons_bmrresid_c10iendavg year if year >= 1975 & year <= 2010 & civilwari_end10==1 || line disp_bmrresid_c10iendavg year if year >= 1975 & year <= 2010 & civilwari_end10==1 || line incl_bmrresid_c10iendavg year if year >= 1975 & year <= 2010 & civilwari_end10==1


% Figure 3
global base "ELF fueldep gdp_grow bmr2_prevauth regionpolity2 lnpop loggdp yearpow yearpow2 yearpow3 bmr2_age"
quietly probit F5.bmr2 $base civilwari_end10 incl_nocivwari_end10 cons_nocivwari_end10 disp_nocivwari_end10 incl_civwari_end10 cons_civwari_end10 disp_civwari_end10 if bmr2==1, $error
quietly margins, at(*_nocivwari_end10=(**)) vsquish post
est store *_nociv
quietly margins, at(*_nocivwari_end10=(**) civilwari_end10=0 *_civwari_end10=0) vsquish post
est store *_nociv
quietly probit F5.bmr2 $base civilwari_end10 incl_nocivwari_end10 cons_nocivwari_end10 disp_nocivwari_end10 incl_civwari_end10 cons_civwari_end10 disp_civwari_end10 if bmr2==1, $error
quietly margins, at(*_civwari_end10=(**) vsquish post
est store *_civ
quietly margins, at(*_civwari_end10=(**) civilwari_end10=1 *_nocivwari_end10=0) vsquish post
est store *_civ
coefplot *_nociv *_civ, recast(line) ciopts(recast(rarea)) ylabel(,angle(0)) xlab(**) vert
graph combine incl_marg2.gph disp_marg2.gph cons_marg2.gph legend.gph, col(1)


% Varying lags (Figures A1-A2)

global base "ELF fueldep gdp_grow bmr2_prevauth regionpolity2 lnpop loggdp yearpow yearpow2 yearpow3 bmr2_age inclusive_nm_IDC dispersive_nm_IDC constraining_nm_IDC"
eststo lag1: quietly probit F.bmr2 $base if bmr2==1, $error
eststo lag2: quietly probit F2.bmr2 $base if bmr2==1, $error
eststo lag3: quietly probit F3.bmr2 $base if bmr2==1, $error
eststo lag4: quietly probit F4.bmr2 $base if bmr2==1, $error
eststo lag5: quietly probit F5.bmr2 $base if bmr2==1, $error
eststo lag6: quietly probit F6.bmr2 $base if bmr2==1, $error
eststo lag7: quietly probit F7.bmr2 $base if bmr2==1, $error
eststo lag8: quietly probit F8.bmr2 $base if bmr2==1, $error
eststo lag9: quietly probit F9.bmr2 $base if bmr2==1, $error
eststo lag10: quietly probit F10.bmr2 $base if bmr2==1, $error

global base "incl_nocivwari_end10 disp_nocivwari_end10 cons_nocivwari_end10 ELF fueldep gdp_grow bmr2_prevauth regionpolity2 lnpop loggdp yearpow yearpow2 yearpow3 bmr2_age"
global base2 "civilwari_end10 incl_civwari_end10 disp_civwari_end10 cons_civwari_end10"
eststo lag1: quietly probit F.bmr2 $base $base2 if bmr2==1, $error
eststo lag2: quietly probit F2.bmr2 $base $base2 if bmr2==1, $error
eststo lag3: quietly probit F3.bmr2 $base $base2 if bmr2==1, $error
eststo lag4: quietly probit F4.bmr2 $base $base2 if bmr2==1, $error
eststo lag5: quietly probit F5.bmr2 $base $base2 if bmr2==1, $error
eststo lag6: quietly probit F6.bmr2 $base $base2 if bmr2==1, $error
eststo lag7: quietly probit F7.bmr2 $base $base2 if bmr2==1, $error
eststo lag8: quietly probit F8.bmr2 $base $base2 if bmr2==1, $error
eststo lag9: quietly probit F9.bmr2 $base $base2 if bmr2==1, $error
eststo lag10: quietly probit F10.bmr2 $base $base2 if bmr2==1, $error

set scheme s1color
coefplot lag1 || lag2 || lag3 || lag4 || lag5 || lag6 || lag7 || lag8 || lag9 || lag10, keep(constraining_nm_IDC) vertical ylabel(0(0.2)0.8) yline(0) ciopts(lcolor(black)) mcolor(black) legend(off) bycoef xlab(1(1)10) ylabel(,angle(0))
coefplot lag1 || lag2 || lag3 || lag4 || lag5 || lag6 || lag7 || lag8 || lag9 || lag10, keep(inclusive_nm_IDC dispersive_nm_IDC constraining_nm_IDC) order(incl* disp* cons*) vertical yline(0,lcol(black) lp(dash)) ciopts(lcolor(black)) mcolor(black) legend(off) bycoef xlab(1(1)10) ylabel(,angle(0)) byopts(yrescale row(3))
coefplot lag1 || lag2 || lag3 || lag4 || lag5 || lag6 || lag7 || lag8 || lag9 || lag10, keep(incl_civwari_end10 incl_nocivwari_end10 disp_civwari_end10 disp_nocivwari_end10 cons_civwari_end10 cons_nocivwari_end10) vertical yline(0,lcol(black) lp(dash)) ciopts(lcolor(black)) mcolor(black) legend(off) bycoef xlab(1(1)10) ylabel(,angle(0)) byopts(yrescale row(3)) order(Incl* Disp* Cons*) rename(incl_civwari_end10 = "Inclusive (Post-War)" incl_nocivwari_end10 = "Inclusive (Not Post-War)" disp_civwari_end10 = "Dispersive (Post-War)" disp_nocivwari_end10 = "Dispersive (Not Post-War)" cons_civwari_end10 = "Constraining (Post-War)" cons_nocivwari_end10 = "Constraining (Not Post-War)")


% Calculating marginal effects (Post-Civil War Settings)

quietly probit f5bmr2 $base civilwari_end10 incl_civwari_end10 disp_civwari_end10 cons_civwari_end10 if bmr2==1, $error
predict qq
sum f5bmr2 if bmr2==1 & f5bmr2!=. & qq!=. & civilwari_end10==1
sum constraining_nm_IDC if bmr2==1 & f5bmr2!=. & qq!=. & civilwari_end10==1, detail
di normal(invnormal(.917)-(.714+.418)*(.397+.250))
di normal(invnormal(.917)+(1.143-.714)*(.397+.250))
sum inclusive_nm_IDC if bmr2==1 & f5bmr2!=. & qq!=. & civilwari_end10==1, detail
di normal(invnormal(.917)-(-.196+.196)*(-.065+2.113))
di normal(invnormal(.917)+(0.768+.196)*(-.065+2.113))
sum dispersive_nm_IDC if bmr2==1 & f5bmr2!=. & qq!=. & civilwari_end10==1, detail
di normal(invnormal(.917)-(.130+.769)*(-.013-.440))
di normal(invnormal(.917)+(1.585-.130)*(-.013-.440))





% Coding

gen civilwarh = 1 if (ucdp_conflict==3 & (ucdp_type==3)) | cow_intwar==1
replace civilwarh = 0 if civilwarh!=1 & (ucdp_conflict!=. | cow_intwar!=.)
replace civilwarh = 0 if ccode==2 | ccode==200 | ccode==211 | ccode==220 | ccode==325 | ccode==900
replace civilwarh = 0 if (ccode==433 & year==1998) | (ccode==770 & year>=1992 & year<=1993)
gen civilwarh10 = (civilwarh==1 | L.civilwarh==1 | L2.civilwarh==1 | L3.civilwarh==1 | L4.civilwarh==1 | L5.civilwarh==1 | L6.civilwarh==1 | L7.civilwarh==1 | L8.civilwarh==1 | L9.civilwarh==1)
replace civilwarh10 = . if civilwarh==. | L.civilwarh==. | L2.civilwarh==. | L3.civilwarh==. | L4.civilwarh==. | L5.civilwarh==. | L6.civilwarh==. | L7.civilwarh==. | L8.civilwarh==. | L9.civilwarh==.
gen civilwari10 = civilwarh10
replace civilwari10 = 1 if civilwarh==1 | L.civilwarh==1 | L2.civilwarh==1 | L3.civilwarh==1 | L4.civilwarh==1 | L5.civilwarh==1 | L6.civilwarh==1 | L7.civilwarh==1 | L8.civilwarh==1 | L9.civilwarh==1
gen incl_civwari10 = inclusive_nm_IDC*civilwari10
gen cons_civwari10 = constraining_nm_IDC*civilwari10
gen disp_civwari10 = dispersive_nm_IDC*civilwari10
gen civilwari_end10 = 0
replace civilwari_end10 = . if civilwari10==.
replace civilwari_end10 = 1 if civilwari10==1 & (F.civilwarh==0 | civilwarh==0)
gen incl_civwari_end10 = inclusive_nm_IDC*civilwari_end10
gen cons_civwari_end10 = constraining_nm_IDC*civilwari_end10
gen disp_civwari_end10 = dispersive_nm_IDC*civilwari_end10
gen incl_nocivwari_end10 = inclusive_nm_IDC*(1-civilwari_end10)
gen cons_nocivwari_end10 = constraining_nm_IDC*(1-civilwari_end10)
gen disp_nocivwari_end10 = dispersive_nm_IDC*(1-civilwari_end10)

gen civilwarh5 = (civilwarh==1 | L.civilwarh==1 | L2.civilwarh==1 | L3.civilwarh==1 | L4.civilwarh==1)
replace civilwarh5 = . if civilwarh==. | L.civilwarh==. | L2.civilwarh==. | L3.civilwarh==. | L4.civilwarh==.
gen civilwari5 = civilwarh5
replace civilwari5 = 1 if civilwarh==1 | L.civilwarh==1 | L2.civilwarh==1 | L3.civilwarh==1 | L4.civilwarh==1 
gen civilwarh15 = (civilwarh==1 | L.civilwarh==1 | L2.civilwarh==1 | L3.civilwarh==1 | L4.civilwarh==1 | L5.civilwarh==1 | L6.civilwarh==1 | L7.civilwarh==1 | L8.civilwarh==1 | L9.civilwarh==1 | L10.civilwarh==1 | L11.civilwarh==1 | L12.civilwarh==1 | L13.civilwarh==1 | L14.civilwarh==1)
replace civilwarh15 = . if civilwarh==. | L.civilwarh==. | L2.civilwarh==. | L3.civilwarh==. | L4.civilwarh==. | L5.civilwarh==. | L6.civilwarh==. | L7.civilwarh==. | L8.civilwarh==. | L9.civilwarh==. | L10.civilwarh==. | L11.civilwarh==. | L12.civilwarh==. | L13.civilwarh==. | L14.civilwarh==.
gen civilwari15 = civilwarh15
replace civilwari15 = 1 if civilwarh==1 | L.civilwarh==1 | L2.civilwarh==1 | L3.civilwarh==1 | L4.civilwarh==1 | L5.civilwarh==1 | L6.civilwarh==1 | L7.civilwarh==1 | L8.civilwarh==1 | L9.civilwarh==1 | L10.civilwarh==1 | L11.civilwarh==1 | L12.civilwarh==1 | L13.civilwarh==1 | L14.civilwarh==1
gen civilwari_end5 = 0
replace civilwari_end5 = . if civilwari5==.
replace civilwari_end5 = 1 if civilwari5==1 & (F.civilwarh==0 | civilwarh==0)
gen civilwari_end15 = 0
replace civilwari_end15 = . if civilwari15==.
replace civilwari_end15 = 1 if civilwari15==1 & (F.civilwarh==0 | civilwarh==0)
gen incl_civwari_end5 = inclusive_nm_IDC*civilwari_end5
gen cons_civwari_end5 = constraining_nm_IDC*civilwari_end5
gen disp_civwari_end5 = dispersive_nm_IDC*civilwari_end5
gen incl_civwari_end15 = inclusive_nm_IDC*civilwari_end15
gen cons_civwari_end15 = constraining_nm_IDC*civilwari_end15
gen disp_civwari_end15 = dispersive_nm_IDC*civilwari_end15

gen intconflict = 1 if ucdp_conflict >= 2 & ucdp_conflict != . & ucdp_type==3
replace intconflict = 0 if (ucdp_conflict < 2 & ucdp_conflict!=.) | (ucdp_type != 3 & ucdp_type!=.)
replace intconflict = . if ucdp_conflict == .
gen intconflictc5 = (intconflict==1 | L.intconflict==1 | L2.intconflict==1 | L3.intconflict==1 | L4.intconflict==1)
replace intconflictc5 = . if intconflict==. | L.intconflict==. | L2.intconflict==. | L3.intconflict==. | L4.intconflict==.
replace intconflictc5 = 1 if intconflict==1 | L.intconflict==1 | L2.intconflict==1 | L3.intconflict==1 | L4.intconflict==1
gen intconflictc10 = (intconflictc5==1 | L5.intconflictc5==1)
replace intconflictc10 = . if intconflictc5==. | L5.intconflictc5==.
replace intconflictc10 = 1 if intconflictc5==1 | L5.intconflictc5==1
gen intconflictc_end10 = 0
replace intconflictc_end10 = . if intconflictc10==.
replace intconflictc_end10 = 1 if intconflictc10==1 & (F.intconflict==0 | intconflict==0)
gen intconflictd10 = civilwari10
replace intconflictd10 = 1 if intconflictc10==1
gen intconflictd_end10 = civilwari_end10
replace intconflictd_end10 = 1 if intconflictc_end10==1
gen incl_intconflictd_end10 = inclusive*intconflictd_end10
gen cons_intconflictd_end10 = constraining*intconflictd_end10
gen disp_intconflictd_end10 = dispersive*intconflictd_end10

gen inclusive = inclusive_nm_IDC
gen dispersive = dispersive_nm_IDC
gen constraining = constraining_nm_IDC

gen disrupted = 1*(polity2==0)
replace disrupted = . if polity2==.
gen pitf_ethnic_ever = pitf_ethnic
replace pitf_ethnic_ever = L.pitf_ethnic_ever if L.pitf_ethnic_ever==1
gen crisis = 0 if year > 1974
replace crisis = 1 if bkcrisis_WFD == 1 | debt_crisis_LV == 1 | currency_crisis_LV == 1 | sysbank_crisis_LV == 1
gen recentcrisis = 0 if year > 1974 
replace recentcrisis = 1 if crisis == 1 | L.crisis == 1 | L2.crisis == 1 | L3.crisis == 1 | L4.crisis == 1 | L5.crisis == 1
replace f5bmr2 = F5.bmr2
gen bmr2_age2 = bmr2_age^2
gen bmr2_age3 = bmr2_age^3
gen lnbmr_age = log(bmr_age)
tab legal, gen(d_legal)
gen areamill = area/1000000
gen yearpow = year - 1975
gen yearpow2 = yearpow^2
gen yearpow3 = yearpow^3
gen incl_capacity = inclusive*state_capacity
gen disp_capacity = dispersive*state_capacity
gen cons_capacity = constraining*state_capacity

gen poldem_age = 1 if poldem!=. & bmrid==1
replace poldem_age = 1 if poldem!=. & L.poldem==.
replace poldem_age = 1 if poldem==1 & L.poldem==0
replace poldem_age = 1 if poldem==0 & L.poldem==1
replace poldem_age = L.poldem_age + 1 if poldem!=. & poldem_age==.
gen poldem_prevauth = 0 if poldem!=. 
replace poldem_prevauth = L.poldem_prevauth if L.poldem_prevauth!=.
replace poldem_prevauth = L.poldem_prevauth + 1*(poldem==0 & L.poldem==1) if L.poldem_prevauth != .

gen xconst6 = 6*xconst+1
gen polity_noxconst = polity2 - (xconst6 - 3) if xconst6 >= 4 & xconst6!=.
replace polity_noxconst = polity2 + (4 - xconst6) if xconst6 < 4

gen aa = demfail_violentopp
gen anyaa = 1 if F.aa==1 | F2.aa==1 | F3.aa==1 | F4.aa==1 | F5.aa==1
replace anyaa = 0 if F.aa==0 & F2.aa==0 & F3.aa==0 & F4.aa==0 & F5.aa==0
replace demfail_violentopp_anyf5 = anyaa
drop aa anyaa

gen demfail_type_f5 = 0 if demfail_violentopp_anyf5==0 & demfail_military_anyf5==0 & demfail_selfcoup_anyf5==0
replace demfail_type_f5 = 1 if demfail_military_anyf5==1
replace demfail_type_f5 = 2 if demfail_selfcoup_anyf5==1
replace demfail_type_f5 = 3 if demfail_violentopp_anyf5==1

gen peacek = (peacekeeping >= 2)
replace peacek = . if peacekeeping==.
gen peacek10 = (peacek==1 | L.peacek==1 | L2.peacek==1 | L3.peacek==1 | L4.peacek==1 | L5.peacek==1 | L6.peacek==1 | L7.peacek==1 | L8.peacek==1 | L9.peacek==1)
replace peacek10 = . if peacek==. | L.peacek==. | L2.peacek==. | L3.peacek==. | L4.peacek==. | L5.peacek==. | L6.peacek==. | L7.peacek==. | L8.peacek==. | L9.peacek==.
replace peacek10 = 1 if peacek==1 | L.peacek==1 | L2.peacek==1 | L3.peacek==1 | L4.peacek==1 | L5.peacek==1 | L6.peacek==1 | L7.peacek==1 | L8.peacek==1 | L9.peacek==1
gen compromise = (cow_intoutcome==3)
replace compromise = . if cow_intoutcome==.
gen compromise10 = (compromise==1 | L.compromise==1 | L2.compromise==1 | L3.compromise==1 | L4.compromise==1 | L5.compromise==1 | L6.compromise==1 | L7.compromise==1 | L8.compromise==1 | L9.compromise==1)
replace compromise10 = . if compromise==. | L.compromise==. | L2.compromise==1 | L3.compromise==. | L4.compromise==. | L5.compromise==. | L6.compromise==. | L7.compromise==. | L8.compromise==. | L9.compromise==.
replace compromise10 = 1 if compromise==1 | L.compromise==1 | L2.compromise==1 | L3.compromise==1 | L4.compromise==1 | L5.compromise==1 | L6.compromise==1 | L7.compromise==1 | L8.compromise==1 | L9.compromise==1

gen civilwari_compromise10 = (civilwari10==1 & compromise10==1)
replace civilwari_compromise10 = . if civilwari10==. | compromise10==.
gen civilwari_end_compromise10 = (civilwari_end10==1 & civilwari_compromise10==1)
replace civilwari_end_compromise10 = . if civilwari_end10==. | civilwari_compromise10==.
gen civilwarh_peacek = civilwarh
replace civilwarh_peacek = 0 if peacekeeping < 2 | peacekeeping == .
replace civilwarh_peacek = L.civilwarh_peacek if civilwarh==1 & L.civilwarh==1 & L.civilwarh_peacek==1
gen civilwari_peacek10c = 1*(civilwarh_peacek==1 | L.civilwarh_peacek==1 | L2.civilwarh_peacek==1 | L3.civilwarh_peacek==1 | L4.civilwarh_peacek==1 | L5.civilwarh_peacek==1 | L6.civilwarh_peacek==1 | L7.civilwarh_peacek==1 | L8.civilwarh_peacek==1 | L9.civilwarh_peacek==1)
replace civilwari_peacek10c = . if civilwarh_peacek==. | L.civilwarh_peacek==. | L2.civilwarh_peacek==. | L3.civilwarh_peacek==. | L4.civilwarh_peacek==. | L5.civilwarh_peacek==. | L6.civilwarh_peacek==. | L7.civilwarh_peacek==. | L8.civilwarh_peacek==. | L9.civilwarh_peacek==.
replace civilwari_peacek10c = 1 if civilwarh_peacek==1 | L.civilwarh_peacek==1 | L2.civilwarh_peacek==1 | L3.civilwarh_peacek==1 | L4.civilwarh_peacek==1 | L5.civilwarh_peacek==1 | L6.civilwarh_peacek==1 | L7.civilwarh_peacek==1 | L8.civilwarh_peacek==1 | L9.civilwarh_peacek==1
gen civilwari_end_peacek10c = (civilwari_end10==1 & civilwari_peacek10c==1)
replace civilwari_end_peacek10c = . if civilwari_end10==. | civilwari_peacek10c==.
gen civilwarh_sep = civilwarh
replace civilwarh_sep = 0 if ucdp_incomp!=1 & ucdp_incomp!=3
gen civilwari_sep10 = 1*(civilwarh_sep==1 | L.civilwarh_sep==1 | L2.civilwarh_sep==1 | L3.civilwarh_sep==1 | L4.civilwarh_sep==1 | L5.civilwarh_sep==1 | L6.civilwarh_sep==1 | L7.civilwarh_sep==1 | L8.civilwarh_sep==1 | L9.civilwarh_sep==1)
replace civilwari_sep10 = . if civilwarh_sep==. | L.civilwarh_sep==. | L2.civilwarh_sep==. | L3.civilwarh_sep==. | L4.civilwarh_sep==. | L5.civilwarh_sep==. | L6.civilwarh_sep==. | L7.civilwarh_sep==. | L8.civilwarh_sep==. | L9.civilwarh_sep==.
replace civilwari_sep10 = 1 if civilwarh_sep==1 | L.civilwarh_sep==1 | L2.civilwarh_sep==1 | L3.civilwarh_sep==1 | L4.civilwarh_sep==1 | L5.civilwarh_sep==1 | L6.civilwarh_sep==1 | L7.civilwarh_sep==1 | L8.civilwarh_sep==1 | L9.civilwarh_sep==1
gen civilwari_end_sep10 = (civilwari_end10==1 & civilwari_sep10==1)
replace civilwari_end_sep10 = . if civilwari_end10==. | civilwari_sep10==.

global base2 "ELF fueldep gdp_grow bmr2_prevauth regionpolity2 lnpop loggdp yearpow yearpow2 yearpow3 bmr2_age"
quietly probit F5.bmr2 $base2 if bmr2==1 & inclusive!=., $error
predict dem_surv

reg constraining_nm_IDC bmr2
predict cons_bmrresid, resid
reg dispersive_nm_IDC bmr2
predict disp_bmrresid, resid
reg inclusive_nm_IDC bmr2
predict incl_bmrresid, resid
by year, sort: egen cons_bmrresid_avg = mean(cons_bmrresid)
by year, sort: egen disp_bmrresid_avg = mean(disp_bmrresid)
by year, sort: egen incl_bmrresid_avg = mean(incl_bmrresid)
by year civilwari_end10, sort: egen cons_bmrresid_cwiendavg = mean(cons_bmrresid)
by year civilwari_end10, sort: egen disp_bmrresid_cwiendavg = mean(disp_bmrresid)
by year civilwari_end10, sort: egen incl_bmrresid_cwiendavg = mean(incl_bmrresid)

