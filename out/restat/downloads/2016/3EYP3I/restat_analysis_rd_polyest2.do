capture log close
clear all
set maxvar 10000
set more off
pause off
# delimit;

local manasi "";
local output "";
local log "";
local data "";
local earn "";

log using "`log'\restat_analysis_rd_polyest2.log", replace;

/* 
Manasi Deshpande, 09/02/2014
RD graphs (non-earnings)
*/

local exp "entry04rd";
local time "wk";
local unit "weekly";
local tlabel_dte "01oct2000 01jan2001 01apr2001 01jul2001 01oct2001 01jan2002 01apr2002 01jul2002 01oct2002, format(%tdmd)";
local tlabel_wk "2001w1 2001w14 2001w27 2001w40 2002w1 2002w14 2002w27";
local tline_dte "01oct2001";
local tline_wk "2001w40";

local title_fy_2004 "Eligible for CDR in FY2004";
local title_n_cdr_rel "Received CDR";
local title_n_timetocdr "Time to CDR completion";
local title_n_cdrunfav_18 "Unfavorable CDR";
local title_n_paymon18 "Months on SSI";
local title_n_combpay18 "Total SSI payment";
local title_n_avgpay18 "Average annual SSI payment";
local title_n_paymonpre "Pre-treatment months on SSI";
local title_n_paymon_2yr "Months on SSI 2 years after CDR event";
local title_n_paymon_5yr "Months on SSI 5 years after CDR event";
local title_n_paymon_9yr "Months on SSI 9 years after CDR event";
local title_n_paymonlife "Months on SSI";
local title_n_paymonpost "Post-treatment months on SSI";
local title_n_paymoncum "Post-treatment months on SSI";
local title_n_combpaypre "Pre-treatment SSI payment";
local title_n_combpay_2yr "Total SSI payment 2 years out";
local title_n_combpay_5yr "Total SSI payment 5 years out";
local title_n_combpay_9yr "Total SSI payment 9 years out";
local title_n_combpaylife "Months on SSI";
local title_n_combpaypost "Post-treatment SSI payment";
local title_n_combpaycum "Post-treatment SSI payment";
local title_n_onssipost "On SSI after treatment";
local title_n_hhunearn "Total household unearned income";
local title_n_hhunearn0206 "Total household unearned income";
local title_n_hhunearnwokid "Parent and sibling disability receipt";
local title_n_hhunearnwokid0206 "Parent and sibling disability receipt";
local title_n_hhdiamt "Parental DI receipt";
local title_n_hhdiamt0206 "Parental DI receipt";
local title_n_hhnumdi "Number of parents on DI";
local title_n_hhnumdi0206 "Number of parents on DI";
local title_n_hhssipay "Parental SSI receipt";
local title_n_hhssipay0206 "Parental SSI receipt";
local title_n_hhnumssi "Number of parents on SSI";
local title_n_hhnumssi0206 "Number of parents on SSI";
local title_n_sibssipay "Sibling SSI receipt";
local title_n_sibnumssi "Number of siblings on SSI";
local title_n_hhappdi "Parental DI applications";
local title_n_hhappdi0206 "Parental DI applications";
local title_n_hhappssi "Parental SSI applications";
local title_n_hhappssi0206 "Parental SSI applications";
local title_n_kidappdi "Child DI applications";
local title_n_kidappssi "Child SSI applications";
local title_n_sibappnum "Sibling SSI applications";
local title_n_totapp "Parent and sibling disability applications";
local title_n_totapp0206 "Parent and sibling disability applications";
local title_pardeathtot "Number of parent deaths";
local title_pardeathtot0206 "Number of parent deaths";
local title_kiddeath "Child dies";
local title_anydeath "Either parent or child dies";
local title_anydeath0206 "Either parent or child dies";
local title_pardeath0206_1yr "Parent dies within 1 year";
local title_pardeath0206_5yr "Parent dies within 5 years";
local title_kiddeath_1yr "Child dies within 1 year";
local title_kiddeath_5yr "Child dies within 5 years";
local title_anydeath0206_1yr "Either parent or child dies within 1 year";
local title_anydeath0206_5yr "Either parent or child dies within 5 years";
local title_n_totapp0206pre "Pre-treatment family disability apps";
local title_n_hhunearnwokid0206pre "Pre-treatment family disability receipt";
forval yr=1985(1)2012 {; 
	local title_n_paymon_`yr' "Months on SSI in `yr'";
	local title_n_combpay_`yr' "Child's SSI payment in `yr'";
	local title_n_hhcombpay_`yr' "Parental SSI receipt in `yr'";
	local title_n_hhcombpay0206_`yr' "Parental SSI receipt in `yr'";
	local title_n_sibpayall_`yr' "Sibling SSI receipt in `yr'";
	local title_n_par831di_`yr' "Parental DI app in `yr'";
	local title_n_par831ssi_`yr' "Parental SSI app in `yr'";
	local title_n_kid831_di_`yr' "Kid applies for DI in `yr'";
	local title_n_kid831_ssi_`yr' "Kid applies for SSI in `yr'";
};
local title_n_male "Male";
local title_n_fam_singmom "Single mother";
local title_n_fam_youngpar "Young parent";
local title_cdr_dobyy "Year of birth";
local title_n_fiscalyob "Fiscal year of birth";
forval yr=1991(1)2004 {;
	local title_n_yob_`yr' "Year of birth `yr'";
	local title_n_fiscalyob_`yr' "Fiscal YOB `yr'";
};
local title_n_firstage "Age at initial SSI receipt";
forval i=0(1)11 {;
	local title_n_firstage_`i' "Age `i' at initial SSI receipt";
};
local title_n_diag1_none "No diagnosis";
local title_n_diag1_infec "Infectious diagnosis";
local title_n_diag1_neo "Neoplasm diagnosis";
local title_n_diag1_endo "Endocrine diagnosis";
local title_n_diag1_blood "Blood diagnosis";
local title_n_diag1_mental "Mental diagnosis";
local title_n_diag1_nerv "Nervous diagnosis";
local title_n_diag1_sense "Sensory diagnosis";
local title_n_diag1_circ "Circulatory diagnosis";
local title_n_diag1_resp "Respiratory diagnosis";
local title_n_diag1_dig "Digestive diagnosis";
local title_n_diag1_gu "GU diagnosis";
local title_n_diag1_skin "Skin diagnosis";
local title_n_diag1_musc "Musculoskeletal diagnosis";
local title_n_diag1_cong "Congenital diagnosis";
local title_n_diag1_nat "Natal diagnosis";
local title_n_diag1_ill "Ill-defined diagnosis";
local title_n_diag1_inj "Injury diagnosis";

local title_n_hhearn18 "Household earnings to age 18";
local title_n_hhearnpost "Household earnings post-CDR";
local title_n_hhearn0206post "Household earnings post-CDR";
local title_n_tothhincpost "Total household income post-CDR";
local title_n_tothhinc0206post "Total household income post-CDR";
forval yr=1985(1)2011 {;
	local title_n_hhearns_`yr' "Household earnings in `yr'";
	local title_n_hhearns0206_`yr' "Household earnings in `yr'";
	local title_n_hhearngt0_`yr' "Earnings>0 in `yr'";
	local title_n_hhearngt20_`yr' "Earnings>poverty in `yr'";
	local title_n_tothhinc_`yr' "Household income in `yr'";
	local title_n_tothhinc0206_`yr' "Household income in `yr'";
	local title_n_hhunearninc_`yr' "Household unearned income in `yr'";
	local title_n_hhunearninc0206_`yr' "Household unearned income in `yr'";
	local title_n_hhunearnwokid_`yr' "Household unearned income in `yr' (w/o kid pay)";
	local title_n_hhunearnwokid0206_`yr' "Household unearned income in `yr' (w/o kid pay)";
};


local ytitle_fy_2004 "Eligible for CDR in FY04";
local ytitle_n_cdr_rel "Released for a CDR in FY2004 or FY2005";
local ytitle_n_timetocdr "Time between award date and CDR (years)";
local ytitle_n_cdrunfav_18 "Unfavorable CDR before age 18";
local ytitle_n_paymon18 "Number of months on SSI before age 18";
local ytitle_n_combpay18 "Total SSI payment before age 18";
local ytitle_n_avgpay18 "Average annual SSI payment before age 18";
local ytitle_n_paymonpre "Annual months on SSI before 2004";
local ytitle_n_paymon_2yr "Months on SSI 2 years after CDR event";
local ytitle_n_paymon_5yr "Months on SSI 5 years after CDR event";
local ytitle_n_paymon_9yr "Months on SSI 9 years after CDR event";
local ytitle_n_paymonlife "Months on SSI over lifetime";
local ytitle_n_paymonpost "Annual months on SSI after 2003";
local ytitle_n_paymoncum "Cumulative months on SSI after 2003";
local ytitle_n_combpaypre "Annual SSI payment before 2004";
local ytitle_n_combpay_2yr "Total SSI payment 2 years after CDR event";
local ytitle_n_combpay_5yr "Total SSI payment 5 years after CDR event";
local ytitle_n_combpay_9yr "Total SSI payment 9 years after CDR event";
local ytitle_n_combpaylife "Total SSI payment over lifetime";
local ytitle_n_combpaypost "Annual SSI payment after 2003";
local ytitle_n_combpaycum "Cumulative SSI payment after 2003";
local ytitle_n_onssipost "On SSI after 2003";
local ytitle_n_hhunearn "Total HH unearned income post-CDR";
local ytitle_n_hhunearn0206 "Total HH unearned income post-CDR";
local ytitle_n_hhunearnwokid "Parent DI + parent SSI + sibling SSI post-CDR";
local ytitle_n_hhunearnwokid0206 "Parent DI + parent SSI + sibling SSI post-CDR";
local ytitle_n_hhdiamt "Parental DI receipt post-CDR";
local ytitle_n_hhdiamt0206 "Parental DI receipt post-CDR";
local ytitle_n_hhnumdi "Number of parents on DI post-CDR";
local ytitle_n_hhnumdi0206 "Number of parents on DI post-CDR";
local ytitle_n_hhssipay "Parental SSI receipt post-CDR";
local ytitle_n_hhssipay0206 "Parental SSI receipt post-CDR";
local ytitle_n_hhnumssi "Number of parents on SSI post-CDR";
local ytitle_n_hhnumssi0206 "Number of parents on SSI post-CDR";
local ytitle_n_sibssipay "Sibling SSI receipt post-CDR";
local ytitle_n_sibnumssi "Number of siblings on SSI post-CDR";
local ytitle_n_hhappdi "Number of parental DI applications post-CDR";
local ytitle_n_hhappdi0206 "Number of parental DI applications post-CDR";
local ytitle_n_hhappssi "Number of parental SSI applications post-CDR";
local ytitle_n_hhappssi0206 "Number of parental SSI applications post-CDR";
local ytitle_n_kidappdi "Number of child DI applications post-CDR";
local ytitle_n_kidappssi "Number of child SSI applications post-CDR";
local ytitle_n_sibappnum "Number of sibling SSI applications post-CDR";
local ytitle_n_totapp "Parent and sibling disability apps post-CDR";
local ytitle_n_totapp0206 "Parent and sibling disability apps post-CDR";
local ytitle_pardeathtot "Number of parent deaths post-CDR";
local ytitle_pardeathtot0206 "Number of parent deaths post-CDR";
local ytitle_kiddeath "Child dies post-CDR";
local ytitle_anydeath "Either parent or child dies post-CDR";
local ytitle_anydeath0206 "Either parent or child dies post-CDR";
local ytitle_pardeath0206_1yr "Parent dies within 1 year of CDR";
local ytitle_pardeath0206_5yr "Parent dies within 5 years of CDR";
local ytitle_kiddeath_1yr "Child dies within 1 year of CDR";
local ytitle_kiddeath_5yr "Child dies within 5 years of CDR";
local ytitle_anydeath0206_1yr "Either parent or child dies within 1 year of CDR";
local ytitle_anydeath0206_5yr "Either parent or child dies within 5 years of CDR";
local ytitle_n_totapp0206pre "Family disability apps pre-CDR";
local ytitle_n_hhunearnwokid0206pre "Family disability receipt pre-CDR";
forval yr=1985(1)2012 {; 
	local ytitle_n_paymon_`yr' "Months on SSI in `yr'";
	local ytitle_n_combpay_`yr' "Child's SSI payment in `yr'";
	local ytitle_n_hhcombpay_`yr' "Parental SSI receipt in `yr'";
	local ytitle_n_hhcombpay0206_`yr' "Parental SSI receipt in `yr'";
	local ytitle_n_sibpayall_`yr' "Sibling SSI receipt in `yr'";
	local ytitle_n_par831di_`yr' "Number of parents applying for DI in `yr'";
	local ytitle_n_par831di0206_`yr' "Number of parents applying for DI in `yr'";
	local ytitle_n_par831ssi_`yr' "Number of parents applying for SSI in `yr'";
	local ytitle_n_par831ssi0206_`yr' "Number of parents applying for SSI in `yr'";
	local ytitle_n_kid831_di_`yr' "Kid applies for DI in `yr'";
	local ytitle_n_kid831_ssi_`yr' "Kid applies for SSI in `yr'";
};
local ytitle_n_male "Male";
local ytitle_n_fam_singmom "Single mother";
local ytitle_n_fam_youngpar "Young parent";
local ytitle_cdr_dobyy "Year of birth";
local ytitle_n_fiscalyob "Fiscal year of birth";
forval yr=1991(1)2004 {;
	local ytitle_n_yob_`yr' "Year of birth `yr'";
	local ytitle_n_fiscalyob_`yr' "Fiscal year of birth `yr'";
};
local ytitle_n_firstage "Age at initial SSI receipt";
forval i=0(1)11 {;
	local ytitle_n_firstage_`i' "Age `i' at initial SSI receipt";
};
local ytitle_n_diag1_none "No diagnosis";
local ytitle_n_diag1_infec "Infectious diagnosis";
local ytitle_n_diag1_neo "Neoplasm diagnosis";
local ytitle_n_diag1_endo "Endocrine diagnosis";
local ytitle_n_diag1_blood "Blood diagnosis";
local ytitle_n_diag1_mental "Mental diagnosis";
local ytitle_n_diag1_nerv "Nervous diagnosis";
local ytitle_n_diag1_sense "Sensory diagnosis";
local ytitle_n_diag1_circ "Circulatory diagnosis";
local ytitle_n_diag1_resp "Respiratory diagnosis";
local ytitle_n_diag1_dig "Digestive diagnosis";
local ytitle_n_diag1_gu "GU diagnosis";
local ytitle_n_diag1_skin "Skin diagnosis";
local ytitle_n_diag1_musc "Musculoskeletal diagnosis";
local ytitle_n_diag1_cong "Congenital diagnosis";
local ytitle_n_diag1_nat "Natal diagnosis";
local ytitle_n_diag1_ill "Ill-defined diagnosis";
local ytitle_n_diag1_inj "Injury diagnosis";

local yytitle_n_hhearn18 "Household earnings before age 18";
local ytitle_n_hhearnpost "Household earnings post-CDR";
local ytitle_n_hhearn0206post "Household earnings post-CDR";
local ytitle_n_tothhincpost "Total household income post-CDR";
local ytitle_n_tothhinc0206post "Total household income post-CDR";
forval yr=1985(1)2011 {;
	local ytitle_n_hhearns_`yr' "Household earnings in `yr'";
	local ytitle_n_hhearns0206_`yr' "Household earnings in `yr'";
	local ytitle_n_hhearngt0_`yr' "Earnings>0 in `yr'";
	local ytitle_n_hhearngt20_`yr' "Earnings>poverty in `yr'";
	local ytitle_n_tothhinc_`yr' "Total household income (earnings, DI, SSI) in `yr'";
	local ytitle_n_tothhinc0206_`yr' "Total household income (earnings, DI, SSI) in `yr'";
	local title_n_hhunearninc_`yr' "Household unearned income in `yr' (incl. kid pay)";
	local title_n_hhunearninc0206_`yr' "Household unearned income in `yr' (incl. kid pay)";
	local title_n_hhunearnwokid_`yr' "Household unearned income in `yr' (w/o kid pay)";
	local title_n_hhunearnwokid0206_`yr' "Household unearned income in `yr' (w/o kid pay)";
};

local abbr_fy_2004 "fy04";
local abbr_n_cdr_rel "rel";
local abbr_n_timetocdr "timetocdr";
local abbr_n_cdrunfav_18 "cdrunfav";
local abbr_n_paymon18 "months";
local abbr_n_combpay18 "pay";
local abbr_n_avgpay18 "avgpay";
local abbr_n_paymonpre "monthspre";
local abbr_n_paymon_2yr "months2yr";
local abbr_n_paymon_5yr "months5yr";
local abbr_n_paymon_9yr "months9yr";
local abbr_n_paymonlife "monthslife";
local abbr_n_paymonpost "monthspost";
local abbr_n_paymoncum "monthspostcum";
local abbr_n_combpaypre "paypre";
local abbr_n_combpay_2yr "pay2yr";
local abbr_n_combpay_5yr "pay5yr";
local abbr_n_combpay_9yr "pay9yr";
local abbr_n_combpaylife "paylife";
local abbr_n_combpaypost "paypost";
local abbr_n_combpaycum "paypostcum";
local abbr_n_onssipost "onssipost";
local abbr_n_hhunearn "hhunearn";
local abbr_n_hhunearn0206 "hhunearn0206";
local abbr_n_hhunearnwokid "hhunearnwokid";
local abbr_n_hhunearnwokid0206 "hhunearnwokid0206";
local abbr_n_hhdiamt "hhdiamt";
local abbr_n_hhdiamt0206 "hhdiamt0206";
local abbr_n_hhnumdi "hhnumdi";
local abbr_n_hhnumdi0206 "hhnumdi0206";
local abbr_n_hhssipay "hhssipay";
local abbr_n_hhssipay0206 "hhssipay0206";
local abbr_n_hhnumssi "hhnumssi";
local abbr_n_hhnumssi0206 "hhnumssi0206";
local abbr_n_sibssipay "sibssipay";
local abbr_n_sibnumssi "sibnumssi";
local abbr_n_hhappdi "hhappdi";
local abbr_n_hhappdi0206 "hhappdi0206";
local abbr_n_hhappssi "hhappssi";
local abbr_n_hhappssi0206 "hhappssi0206";
local abbr_n_tothhincpost "tothhinc";
local abbr_n_tothhinc0206post "tothhinc0206";
local abbr_n_kidappdi "kidappdi";
local abbr_n_kidappssi "kidappssi";
local abbr_n_sibappnum "sibappnum";
local abbr_n_totapp "totapp";
local abbr_n_totapp0206 "totapp0206";
local abbr_pardeathtot "pardeath";
local abbr_pardeathtot0206 "pardeath0206";
local abbr_kiddeath "kiddeath";
local abbr_anydeath "anydeath";
local abbr_anydeath0206 "anydeath0206";
local abbr_pardeath0206_1yr "pardeath0206_1yr";
local abbr_pardeath0206_5yr "pardeath0206_5yr";
local abbr_kiddeath_1yr "kiddeath_1yr";
local abbr_kiddeath_5yr "kiddeath_5yr";
local abbr_anydeath0206_1yr "anydeath0206_1yr";
local abbr_anydeath0206_5yr "anydeath0206_5yr";
local abbr_n_totapp0206pre "totapp0206pre";
local abbr_n_hhunearnwokid0206pre "hhunearnwokid0206pre";
forval yr=1985(1)2012 {; 
	local abbr_n_paymon_`yr' "month`yr'";
	local abbr_n_combpay_`yr' "pay`yr'";
	local abbr_n_hhcombpay_`yr' "hhssi`yr'";
	local abbr_n_hhcombpay0206_`yr' "hhssi0206`yr'";
	local abbr_n_sibpayall_`yr' "sibssi`yr'";
	local abbr_n_par831di_`yr' "hhappdi`yr'";
	local abbr_n_par831di0206_`yr' "hhappdi0206`yr'";
	local abbr_n_par831ssi_`yr' "hhappssi`yr'";
	local abbr_n_par831ssi0206_`yr' "hhappssi0206`yr'";
	local abbr_n_kid831_di_`yr' "kidappdi`yr'";
	local abbr_n_kid831_ssi_`yr' "kidappssi`yr'";
};

local abbr_n_male "male";
local abbr_n_fam_singmom "singmom";
local abbr_n_fam_youngpar "youngpar";
local abbr_cdr_dobyy "yob";
local abbr_n_fiscalyob "fyob";
forval yr=1991(1)2004 {;
	local abbr_n_yob_`yr' "yob`yr'";
	local abbr_n_fiscalyob_`yr' "fyob`yr'";
};
local abbr_cdr_dob_sas "exactdob";
local abbr_n_firstage "firstage";
forval i=0(1)11 {;
	local abbr_n_firstage_`i' "firstage`i'";
};
local abbr_n_diag1_none "nodiag";
local abbr_n_diag1_infec "infec";
local abbr_n_diag1_neo "neo";
local abbr_n_diag1_endo "endo";
local abbr_n_diag1_blood "blood";
local abbr_n_diag1_mental "ment";
local abbr_n_diag1_nerv "nerv";
local abbr_n_diag1_sense "sense";
local abbr_n_diag1_circ "circ";
local abbr_n_diag1_resp "resp";
local abbr_n_diag1_dig "dig";
local abbr_n_diag1_gu "gu";
local abbr_n_diag1_skin "skin";
local abbr_n_diag1_musc "musc";
local abbr_n_diag1_cong "cong";
local abbr_n_diag1_nat "nat";
local abbr_n_diag1_ill "ill";
local abbr_n_diag1_inj "inj";

local abbr_n_hhearn18 "hhearn18";
local abbr_n_hhearnpost "hhearnpost";
local abbr_n_hhearn0206post "hhearn0206post";
local abbr_n_tothhincpost "tothhincpost";
local abbr_n_tothhinc0206post "tothhinc0206post";
forval yr=1985(1)2011 {;
	local abbr_n_hhearns_`yr' "hhearns`yr'";
	local abbr_n_hhearns0206_`yr' "hhearns0206`yr'";
	local abbr_n_hhearngt0_`yr' "hhearngt0`yr'";
	local abbr_n_hhearngt20_`yr' "hhearngt20`yr'";
	local abbr_n_tothhinc_`yr' "tothhinc`yr'";
	local abbr_n_tothhinc0206_`yr' "tothhinc0206`yr'";
	local abbr_n_hhunearninc_`yr' "hhunearn`yr'";
	local abbr_n_hhunearninc0206_`yr' "hhunearn0206`yr'";
	local abbr_n_hhunearnwokid_`yr' "hhunearnwokid`yr'";
	local abbr_n_hhunearnwokid0206_`yr' "hhunearnwokid0206`yr'";
};

local ysc_fy_2004 "r(0 1)";
local ysc_n_cdr_rel "r(0 1)";
local ysc_n_cdrunfav_18 "r(0 .2)";
local ysc_n_paymon18 "r(105 125)";
local ysc_n_combpay18 "r(68000 82000)";
local ysc_n_avgpay18 "r(4600 5800)";
local ysc_n_paymonpre "r(1 2.1)";
local ysc_n_paymon_2yr "r(40 60)";
local ysc_n_paymon_5yr "r(70 90)";
local ysc_n_paymon_9yr "r(105 125)";
local ysc_n_paymonlife "r(105 125)";
local ysc_n_paymonpost "r(9.4 11.2)";
local ysc_n_paymoncum "r(80 95)";
local ysc_n_combpaypre "r(600 1470)";
local ysc_n_combpay_2yr "r(30000 42000)";
local ysc_n_combpay_5yr "r(50000 62000)";
local ysc_n_combpay_9yr "r(70000 82000)";
local ysc_n_combpaylife "r(70000 82000)";
local ysc_n_combpaypost "r(6000 7200)";
local ysc_n_combpaycum "r(50000 62000)";
local ysc_n_onssipost "r(.8 .95)";
local ysc_n_hhunearn "r(10000 13300)";
local ysc_n_hhunearnwokid "r(4000 6200)";
local ysc_n_hhdiamt "r(600 1300)";
local ysc_n_hhnumdi "r(.09 .17)";
local ysc_n_hhssipay "r(900 1700)";
local ysc_n_hhnumssi "r(.2 .31)";
local ysc_n_sibssipay "r(2000 4000)";
local ysc_n_sibnumssi "r(.35 .53)";
local ysc_n_hhappdi "r(.025 .055)";
local ysc_n_hhappssi "r(.05 .08)";
local ysc_n_kidappssi "r(.002 .014)";
local ysc_n_sibappnum "r(.04 .082)";
local ysc_n_totapp "r(.08 .14)";
local ysc_n_totapp0206 "r(.08 .14)";
local ysc_pardeathtot "r(.02 .07)";
local ysc_pardeathtot0206 "r(.02 .07)";
local ysc_kiddeath "r(0 .032)";
local ysc_anydeath "r(.02 .085)";
local ysc_anydeath0206 "r(.02 .085)";
local ysc_pardeath0206_1yr "r(0 .023)";
local ysc_pardeath0206_5yr "r(.01 .04)";
local ysc_kiddeath_1yr "r(0 .02)";
local ysc_kiddeath_5yr "r(0 .023)";
local ysc_anydeath0206_1yr "r(0 .032)";
local ysc_anydeath0206_5yr "r(.018 .06)";
forval yr=2003(1)2011 {;
	local ysc_n_paymon_`yr' "r(8 12.5)";
	local ysc_n_combpay_`yr' "r(5000 8300)";
};

local ysc_n_hhunearn0206 "r(9000 13000)";
local ysc_n_hhunearnwokid0206 "r(3500 6000)";
local ysc_n_hhdiamt0206 "r(400 1000)";
local ysc_n_hhnumdi0206 "r(.06 .14)";
local ysc_n_hhssipay0206 "r(600 1400)";
local ysc_n_hhnumssi0206 "r(.14 .24)";
local ysc_n_hhappdi0206 "r(.01 .025)";
local ysc_n_hhappssi0206 "r(.015 .04)";

local ylabel_fy_2004 "0(.2)1";
local ylabel_n_cdr_rel "0(.2)1";
local ylabel_n_cdrunfav_18 "0(.05).2";
local ylabel_n_paymon18 "105(5)125";
local ylabel_n_combpay18 "70000 75000 80000";
local ylabel_n_avgpay18 "4600(400)5800";
local ylabel_n_paymonpre "1(0.2)2.0";
local ylabel_n_paymon_2yr "40(5)60";
local ylabel_n_paymon_5yr "70(5)90";
local ylabel_n_paymon_9yr "105(5)125";
local ylabel_n_paymonlife "105(5)125";
local ylabel_n_paymonpost "9.5(.5)11";
local ylabel_n_paymoncum "80(5)95";
local ylabel_n_combpaypre "600(200)1470";
local ylabel_n_combpay_2yr "30000(3000)42000";
local ylabel_n_combpay_5yr "50000(3000)62000";
local ylabel_n_combpay_9yr "70000(3000)82000";
local ylabel_n_combpaylife "70000(3000)82000";
local ylabel_n_combpaypost "6000(400)7200";
local ylabel_n_combpaycum "50000(3000)62000";
local ylabel_n_onssipost ".8(.05).95";
local ylabel_n_hhunearn "10000(1000)13000";
local ylabel_n_hhunearnwokid "4000(500)6000";
local ylabel_n_hhdiamt "600(200)1200";
local ylabel_n_hhnumdi ".09(.02).17";
local ylabel_n_hhssipay "900(200)1700";
local ylabel_n_hhnumssi ".2(0.02).3";
local ylabel_n_sibssipay "2000(500)4000";
local ylabel_n_sibnumssi ".35(.05).5";
local ylabel_n_hhappdi ".025(.01).055";
local ylabel_n_hhappssi ".05(0.01).08";
local ylabel_n_kidappssi ".002(.004).014";
local ylabel_n_sibappnum ".04(.01).08";
local ylabel_n_totapp ".08(.02).14";
local ylabel_n_totapp0206 ".08(.02).14";
local ylabel_pardeathtot ".02(.01).07";
local ylabel_pardeathtot0206 ".02(.01).07";
local ylabel_kiddeath "0(.01).03";
local ylabel_anydeath ".02(.02).08";
local ylabel_anydeath0206 ".02(.02).08";
local ylabel_pardeath0206_1yr "0(.005).02";
local ylabel_pardeath0206_5yr ".01(.01).04";
local ylabel_kiddeath_1yr "0(.005).02";
local ylabel_kiddeath_5yr "0(.005).02";
local ylabel_anydeath0206_1yr "0(.01).03";
local ylabel_anydeath0206_5yr ".02(.02).06";
forval yr=2003(1)2011 {;
	local ylabel_n_paymon_`yr' "8(1)12";
	local ylabel_n_combpay_`yr' "5000(1000)8000";
};

local ylabel_n_hhunearn0206 "9000(1000)13000";
local ylabel_n_hhunearnwokid0206 "3500(500)6000";
local ylabel_n_hhdiamt0206 "400(200)1000";
local ylabel_n_hhnumdi0206 ".06(.02).14";
local ylabel_n_hhssipay0206 "600(200)1400";
local ylabel_n_hhnumssi0206 ".14(0.02).24";
local ylabel_n_hhappdi0206 ".01(.005).025";
local ylabel_n_hhappssi0206 ".015(0.005).04";

local ttext1_fy_2004 "";
local ttext1_n_cdr_rel "";
local ttext1_n_cdrunfav_18 "ttext(.192 2001w20 "Review more likely", color(black))";
local ttext1_n_paymon18 "ttext(124.2 2001w20 "Review more likely", color(black))";
local ttext1_n_combpay18 "ttext(81500 2001w20 "Review more likely", color(black))";
local ttext1_n_avgpay18 "ttext(5750 2001w20 "Review more likely", color(black))";
local ttext1_n_paymon_2yr "ttext(59 2001w20 "Review more likely", color(black))";
local ttext1_n_paymon_5yr "ttext(89 2001w20 "Review more likely", color(black))";
local ttext1_n_paymon_9yr "ttext(124 2001w20 "Review more likely", color(black))";
local ttext1_n_paymonlife "ttext(124 2001w20 "Review more likely", color(black))";
local ttext1_n_paymonpre "ttext(2.07 2001w20 "Review more likely", color(black))";
local ttext1_n_paymonpost "ttext(11.15 2001w20 "Review more likely", color(black))";
local ttext1_n_paymoncum "ttext(94.5 2001w20 "Review more likely", color(black))";
local ttext1_n_combpaypre "ttext(1450 2001w20 "Review more likely", color(black))";
local ttext1_n_combpay_2yr "ttext(41500 2001w20 "Review more likely", color(black))";
local ttext1_n_combpay_5yr "ttext(61500 2001w20 "Review more likely", color(black))";
local ttext1_n_combpay_9yr "ttext(81500 2001w20 "Review more likely", color(black))";
local ttext1_n_combpaylife "ttext(81500 2001w20 "Review more likely", color(black))";
local ttext1_n_combpaypost "ttext(7150 2001w20 "Review more likely", color(black))";
local ttext1_n_combpaycum "ttext(61500 2001w20 "Review more likely", color(black))";
local ttext1_n_onssipost "ttext(.945 2001w20 "Review more likely", color(black))";
local ttext1_n_hhunearn "ttext(13200 2001w20 "Review more likely (less SSI)", color(black))";
local ttext1_n_hhunearnwokid "ttext(6150 2001w20 "Review more likely (less SSI)", color(black))";
local ttext1_n_hhdiamt "ttext(1275 2001w20 "Review more likely (less SSI)", color(black))";
local ttext1_n_hhnumdi "ttext(.166 2001w20 "Review more likely (less SSI)", color(black))";
local ttext1_n_hhssipay "ttext(1670 2001w20 "Review more likely (less SSI)", color(black))";
local ttext1_n_hhnumssi "ttext(.305 2001w20 "Review more likely (less SSI)", color(black))";
local ttext1_n_sibssipay "ttext(3950 2001w20 "Review more likely (less SSI)", color(black))";
local ttext1_n_sibnumssi "ttext(.525 2001w20 "Review more likely (less SSI)", color(black))";
local ttext1_n_hhappdi "ttext(.054 2001w20 "Review more likely (less SSI)", color(black))";
local ttext1_n_hhappssi "ttext(.079 2001w20 "Review more likely (less SSI)", color(black))";
local ttext1_n_kidappssi "ttext(.0135 2001w20 "Review more likely (less SSI)", color(black))";
local ttext1_n_sibappnum "ttext(.081 2001w20 "Review more likely (less SSI)", color(black))";
local ttext1_n_totapp "ttext(.137 2001w20 "Review more likely (less SSI)", color(black))";
local ttext1_n_totapp0206 "ttext(.137 2001w20 "Review more likely (less SSI)", color(black))";
local ttext1_pardeathtot "ttext(.068 2001w20 "Review more likely (less SSI)", color(black))";
local ttext1_pardeathtot0206 "ttext(.068 2001w20 "Review more likely (less SSI)", color(black))";
local ttext1_kiddeath "ttext(.031 2001w20 "Review more likely (less SSI)", color(black))";
local ttext1_anydeath "ttext(.084 2001w20 "Review more likely (less SSI)", color(black))";
local ttext1_anydeath0206 "ttext(.084 2001w20 "Review more likely (less SSI)", color(black))";
forval yr=2003(1)2011 {;
	local ttext1_n_paymon_`yr' "ttext(12.4 2001w20 "Review more likely (less SSI)", color(black))";
	local ttext1_n_combpay_`yr' "ttext(8200 2001w20 "Review more likely (less SSI)", color(black))";
};

local ttext1_pardeath0206_1yr "ttext(.0225 2001w20 "Review more likely (less SSI)", color(black))";
local ttext1_pardeath0206_5yr "ttext(.039 2001w20 "Review more likely (less SSI)", color(black))";
local ttext1_kiddeath_1yr "ttext(.019 2001w20 "Review more likely (less SSI)", color(black))";
local ttext1_kiddeath_5yr "ttext(.0225 2001w20 "Review more likely (less SSI)", color(black))";
local ttext1_anydeath0206_1yr "ttext(.031 2001w20 "Review more likely (less SSI)", color(black))";
local ttext1_anydeath0206_5yr "ttext(.059 2001w20 "Review more likely (less SSI)", color(black))";

local ttext1_n_hhunearn0206 "ttext(12800 2001w20 "Review more likely (less SSI)", color(black))";
local ttext1_n_hhunearnwokid0206 "ttext(5900 2001w20 "Review more likely (less SSI)", color(black))";
local ttext1_n_hhdiamt0206 "ttext(975 2001w20 "Review more likely (less SSI)", color(black))";
local ttext1_n_hhnumdi0206 "ttext(.136 2001w20 "Review more likely (less SSI)", color(black))";
local ttext1_n_hhssipay0206 "ttext(1370 2001w20 "Review more likely (less SSI)", color(black))";
local ttext1_n_hhnumssi0206 "ttext(.237 2001w20 "Review more likely (less SSI)", color(black))";
local ttext1_n_hhappdi0206 "ttext(.0245 2001w20 "Review more likely (less SSI)", color(black))";
local ttext1_n_hhappssi0206 "ttext(.039 2001w20 "Review more likely (less SSI)", color(black))";

local ttext2_fy_2004 "";
local ttext2_n_cdr_rel "";
local ttext2_n_cdrunfav_18 "ttext(.192 2002w7 "Review less likely", color(black))";
local ttext2_n_paymon18 "ttext(124.2 2002w7 "Review less likely", color(black))";
local ttext2_n_combpay18 "ttext(81500 2002w7 "Review less likely", color(black))";
local ttext2_n_avgpay18 "ttext(5750 2002w7 "Review less likely", color(black))";
local ttext2_n_paymonpre "ttext(2.07 2002w7 "Review less likely", color(black))";
local ttext2_n_paymon_2yr "ttext(59 2002w7 "Review less likely", color(black))";
local ttext2_n_paymon_5yr "ttext(89 2002w7 "Review less likely", color(black))";
local ttext2_n_paymon_9yr "ttext(124 2002w7 "Review less likely", color(black))";
local ttext2_n_paymonlife "ttext(124 2002w7 "Review less likely", color(black))";
local ttext2_n_paymonpost "ttext(11.15 2002w7 "Review less likely", color(black))";
local ttext2_n_paymoncum "ttext(94.5 2002w7 "Review less likely", color(black))";
local ttext2_n_combpaypre "ttext(1450 2002w7 "Review less likely", color(black))";
local ttext2_n_combpay_2yr "ttext(41500 2002w7 "Review less likely", color(black))";
local ttext2_n_combpay_5yr "ttext(61500 2002w7 "Review less likely", color(black))";
local ttext2_n_combpay_9yr "ttext(81500 2002w7 "Review less likely", color(black))";
local ttext2_n_combpaylife "ttext(81500 2002w7 "Review less likely", color(black))";
local ttext2_n_combpaypost "ttext(7150 2002w7 "Review less likely", color(black))";
local ttext2_n_combpaycum "ttext(61500 2002w7 "Review less likely", color(black))";
local ttext2_n_onssipost "ttext(.945 2002w7 "Review less likely", color(black))";
local ttext2_n_hhunearn "ttext(13200 2002w7 "Review less likely (more SSI)", color(black))";
local ttext2_n_hhunearnwokid "ttext(6150 2002w7 "Review less likely (more SSI)", color(black))";
local ttext2_n_hhdiamt "ttext(1275 2002w7 "Review less likely (more SSI)", color(black))";
local ttext2_n_hhnumdi "ttext(.166 2002w7 "Review less likely (more SSI)", color(black))";
local ttext2_n_hhssipay "ttext(1670 2002w7 "Review less likely (more SSI)", color(black))";
local ttext2_n_hhnumssi "ttext(.305 2002w7 "Review less likely (more SSI)", color(black))";
local ttext2_n_sibssipay "ttext(3950 2002w7 "Review less likely (more SSI)", color(black))";
local ttext2_n_sibnumssi "ttext(.525 2002w7 "Review less likely (more SSI)", color(black))";
local ttext2_n_hhappdi "ttext(.054 2002w7 "Review less likely (more SSI)", color(black))";
local ttext2_n_hhappssi "ttext(.079 2002w7 "Review less likely (more SSI)", color(black))";
local ttext2_n_kidappssi "ttext(.0135 2002w7 "Review less likely (more SSI)", color(black))";
local ttext2_n_sibappnum "ttext(.081 2002w7 "Review less likely (more SSI)", color(black))";
local ttext2_n_totapp "ttext(.137 2002w7 "Review less likely (more SSI)", color(black))";
local ttext2_n_totapp0206 "ttext(.137 2002w7 "Review less likely (more SSI)", color(black))";
local ttext2_pardeathtot "ttext(.068 2002w7 "Review less likely (more SSI)", color(black))";
local ttext2_pardeathtot0206 "ttext(.068 2002w7 "Review less likely (more SSI)", color(black))";
local ttext2_kiddeath "ttext(.031 2002w7 "Review less likely (more SSI)", color(black))";
local ttext2_anydeath "ttext(.084 2002w7 "Review less likely (more SSI)", color(black))";
local ttext2_anydeath0206 "ttext(.084 2002w7 "Review less likely (more SSI)", color(black))";
forval yr=2003(1)2011 {;
	local ttext2_n_paymon_`yr' "ttext(12.4 2002w7 "Review less likely (more SSI)", color(black))";
	local ttext2_n_combpay_`yr' "ttext(8200 2002w7 "Review less likely (more SSI)", color(black))";
};

local ttext2_pardeath0206_1yr "ttext(.0225 2002w7 "Review less likely (more SSI)", color(black))";
local ttext2_pardeath0206_5yr "ttext(.039 2002w7 "Review less likely (more SSI)", color(black))";
local ttext2_kiddeath_1yr "ttext(.019 2002w7 "Review less likely (more SSI)", color(black))";
local ttext2_kiddeath_5yr "ttext(.0225 2002w7 "Review less likely (more SSI)", color(black))";
local ttext2_anydeath0206_1yr "ttext(.031 2002w7 "Review less likely (more SSI)", color(black))";
local ttext2_anydeath0206_5yr "ttext(.059 2002w7 "Review less likely (more SSI)", color(black))";

local ttext2_n_hhunearn0206 "ttext(12800 2002w7 "Review less likely (more SSI)", color(black))";
local ttext2_n_hhunearnwokid0206 "ttext(5900 2002w7 "Review less likely (more SSI)", color(black))";
local ttext2_n_hhdiamt0206 "ttext(975 2002w7 "Review less likely (more SSI)", color(black))";
local ttext2_n_hhnumdi0206 "ttext(.136 2002w7 "Review less likely (more SSI)", color(black))";
local ttext2_n_hhssipay0206 "ttext(1370 2002w7 "Review less likely (more SSI)", color(black))";
local ttext2_n_hhnumssi0206 "ttext(.237 2002w7 "Review less likely (more SSI)", color(black))";
local ttext2_n_hhappdi0206 "ttext(.0245 2002w7 "Review less likely (more SSI)", color(black))";
local ttext2_n_hhappssi0206 "ttext(.039 2002w7 "Review less likely (more SSI)", color(black))";


/* ******************* */
/* **** RD GRAPHS **** */
/* ******************* */
use "`data'\statsby\restat_analysis_rd_graphs.dta", clear;
keep if abs(awdwk_run)<35;

/* Plot running variable (award date) against... */
tsset awd`time'_stata, `unit';
gen cutoff_dte=mdy(10,01,2001);
gen cutoff_wk=wofd(mdy(10,01,2001));

/* RD graphs for outcomes */
foreach var of varlist 
					n_cdr_rel n_cdrunfav_18 n_paymoncum n_combpaycum
					n_totapp0206 n_hhunearnwokid0206 n_paymonpre
					
					 fy_2004 n_cdr_rel n_timetocdr n_cdrunfav_18
					 n_paymon18 n_combpay18 n_avgpay18 
					 n_paymon_2yr n_paymon_5yr n_paymon_9yr n_paymonlife 
					 n_combpay_2yr n_combpay_5yr n_combpay_9yr n_combpaylife
					 n_paymon_2002-n_paymon_2011
					 n_combpay_2002-n_combpay_2011
					 n_paymonpost n_combpaypost n_onssipost 
					 n_paymoncum n_combpaycum

					 n_paymonpre n_combpaypre n_totapp0206pre n_hhunearnwokid0206pre
					 n_hhunearn0206 n_hhunearnwokid0206
					 n_hhappdi0206 n_hhdiamt0206 
					 n_hhappssi0206 n_hhssipay0206 
					 n_sibssipay n_sibappnum 
					 n_kidappssi n_totapp0206
					 pardeathtot0206 kiddeath anydeath0206
					 pardeath0206_1yr pardeath0206_5yr kiddeath_1yr kiddeath_5yr 
					 anydeath0206_1yr anydeath0206_5yr
	{;
	twoway  (scatter `var' awd`time'_stata if awdwk_run<0 | awdwk_run>=5, mcolor(black)) 
			(scatter `var' awd`time'_stata if awdwk_run>=0 & awdwk_run<5, mcolor(gs10)) 
			(qfit `var' awd`time'_stata if awd`time'_stata<cutoff_`time', lcolor(black)) 
			(qfit `var' awd`time'_stata if awd`time'_stata>=cutoff_`time' & (awdwk_run<0 | awdwk_run>=5), lcolor(black)), 
			title("`title_`var''", size(medsmall)) 
			xtitle("Award date", size(medsmall)) 
			ytitle("`ytitle_`var''", size(medsmall))
			ysc(`ysc_`var'') ylabel(`ylabel_`var'',nogrid)
			legend(off) 
			tlabel(`tlabel_`time'') 
			tline(`tline_`time'')
			`ttext1_`var''
			`ttext2_`var''
			graphregion(color(white))
			bgcolor(white)
			;
	graph save "`output'\restat_`exp'_`abbr_`var''", replace;
	pause;
};

/* ***************************************************************** */
/* **** CHECK THAT COVARIATES ARE BALANCED ACROSS DISCONTINUITY **** */
/* ***************************************************************** */

/* RD graphs for covariates */
foreach var of varlist
	n_male n_fam_singmom n_fam_youngpar
	n_fiscalyob cdr_dobyy n_firstage 
	n_diag1_none n_diag1_infec n_diag1_neo n_diag1_endo n_diag1_blood n_diag1_mental n_diag1_nerv
	n_diag1_sense n_diag1_circ n_diag1_resp n_diag1_dig n_diag1_gu n_diag1_skin n_diag1_musc
	n_diag1_cong n_diag1_nat n_diag1_ill n_diag1_inj 
	{;

	twoway  (scatter `var' awd`time'_stata, mcolor(black)) 
			(qfit `var' awd`time'_stata if awd`time'_stata<cutoff_`time', lcolor(black)) 
			(qfit `var' awd`time'_stata if awd`time'_stata>=cutoff_`time', lcolor(black)), 
			title("`title_`var''", size(medsmall)) 
			xtitle("Award date", size(medsmall)) 
			ytitle("`ytitle_`var''", size(medsmall))
			legend(off) 
			tlabel(`tlabel_`time'') 
			tline(`tline_`time'')
			graphregion(color(white))
			bgcolor(white)
			ylab(,nogrid);
	graph save "`output'\restat_`exp'_covbal`abbr_`var''", replace;
	pause;
};

log close;

