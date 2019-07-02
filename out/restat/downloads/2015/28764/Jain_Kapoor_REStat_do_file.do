clear
set more off


/* 1. Transform and scale basic explanatory variables */
/* 2. Generate variables characterizing study groups, sections, roommates and quads */
/* 3. Generate variables for geographically close study group members */
/* 4. Generate variables for heterogeneity in peer characteristics */

use Peers_Dataset.dta
/* Year fixed effects */
gen y2008=0
replace y2008 =1 if year==2008
gen y2009=0
replace y2009 =1 if year==2009
gen y2010=0
replace y2010 =1 if year==2010
gen y2011=0
replace y2011 =1 if year==2011

/* Groupwork component of course variables */
egen high_grpwork_gpa = rowmean(grade_cstr grade_mktg grade_inva grade_dmop grade_mkdm grade_entr grade_opmg) if year==2008
egen high_grpwork_gpa2 = rowmean(grade_mgec grade_cstr grade_mktg grade_inva grade_dmop grade_mkdm grade_entr grade_opmg) if year==2009
egen high_grpwork_gpa3 = rowmean(grade_mgec grade_cstr grade_sait grade_dmop grade_mkdm grade_entr grade_opmg grade_gsb) if year==2010
egen high_grpwork_gpa4 = rowmean(grade_mgec grade_cstr grade_mkdm grade_dmop grade_entr grade_opmg grade_sait) if year==2011
replace high_grpwork_gpa = high_grpwork_gpa2 if year == 2009
replace high_grpwork_gpa = high_grpwork_gpa3 if year == 2010
replace high_grpwork_gpa = high_grpwork_gpa4 if year == 2011

egen med_grpwork_gpa = rowmean(grade_madm grade_gsb grade_fadm grade_mgto) if year==2008
egen med_grpwork_gpa2 = rowmean(grade_cfin grade_madm grade_fadm grade_mgto) if year==2009
egen med_grpwork_gpa3 = rowmean(grade_glec grade_cfin grade_mgto grade_fadm grade_mktg grade_gsb grade_sait) if year==2010
egen med_grpwork_gpa4 = rowmean(grade_fadm grade_glec grade_cfin grade_mgec grade_mktg grade_mgto) if year==2011
replace med_grpwork_gpa = med_grpwork_gpa2 if year == 2009
replace med_grpwork_gpa = med_grpwork_gpa3 if year == 2010
replace med_grpwork_gpa = med_grpwork_gpa4 if year == 2011

egen low_grpwork_gpa = rowmean(grade_smmd grade_glec grade_inva grade_sait grade_mgec grade_cfin) if year==2008
egen low_grpwork_gpa2 = rowmean(grade_smmd grade_glec grade_inva grade_sait grade_gsb) if year==2009
egen low_grpwork_gpa3 = rowmean(grade_smmd grade_mgec grade_inva grade_madm grade_cfin) if year==2010
egen low_grpwork_gpa4 = rowmean(grade_smmd grade_madm grade_inva grade_cfin grade_gsb) if year==2011
replace low_grpwork_gpa = low_grpwork_gpa2 if year == 2009
replace low_grpwork_gpa = low_grpwork_gpa3 if year == 2010
replace low_grpwork_gpa = low_grpwork_gpa4 if year == 2011
drop high_grpwork_gpa2 high_grpwork_gpa3 high_grpwork_gpa4 med_grpwork_gpa2 med_grpwork_gpa3 med_grpwork_gpa4 low_grpwork_gpa2 low_grpwork_gpa3 low_grpwork_gpa4

replace gmat=gmat/100
gen studio = 0 if housing_type=="shared"
replace studio = 1 if housing_type=="studio"

/* Create section variables */

gen gmat_gtmean=0
replace gmat_gtmean =1 if gmat>=gmat_grp

gen gmat_roomgtmean=0
replace gmat_roomgtmean =1 if gmat>=gmat_room


reg studio gmat totalexpft preinc masters age single female citizen_India y2009 y2010 y2011
probit studio gmat totalexpft preinc masters age single female citizen_India y2009 y2010 y2011

/* Table 3: Randomization check in study group and roommate assignment */

reg core_gpa gmat preinc totalexpft age female single citizen_India 																																																																						y2008 y2009 y2010 if housing_type=="shared"
reg core_gpa gmat preinc totalexpft age female single citizen_India gmat_grp preinc_grp totalexpft_grp age_grp female_grp single_grp citizen_India_grp gmat_var preinc_var totalexpft_var age_var 																																							y2008 y2009 y2010 if housing_type=="shared"
reg core_gpa gmat preinc totalexpft age female single citizen_India 																																gmat_room preinc_room totalexpft_room age_room female_room single_room citizen_India_room gmat_roomvar preinc_roomvar totalexpft_roomvar age_roomvar	y2008 y2009 y2010 if housing_type=="shared"
reg core_gpa gmat preinc totalexpft age female single citizen_India gmat_grp preinc_grp totalexpft_grp age_grp female_grp single_grp citizen_India_grp gmat_var preinc_var totalexpft_var age_var 	gmat_room preinc_room totalexpft_room age_room female_room single_room citizen_India_room gmat_roomvar preinc_roomvar totalexpft_roomvar age_roomvar 	y2008 y2009 y2010 if housing_type=="shared"

/* Table 6: Impact of study group and roommates GMAT scores by groupwork component in course */
reg high_grpwork_gpa gmat preinc totalexpft age female single citizen_India gmat_grp preinc_grp totalexpft_grp age_grp female_grp single_grp citizen_India_grp gmat_var preinc_var totalexpft_var age_var gmat_room preinc_room totalexpft_room age_room female_room single_room citizen_India_room gmat_roomvar preinc_roomvar totalexpft_roomvar age_roomvar y2008 y2009 y2010 if housing_type=="shared"
reg med_grpwork_gpa gmat preinc totalexpft age female single citizen_India gmat_grp preinc_grp totalexpft_grp age_grp female_grp single_grp citizen_India_grp gmat_var preinc_var totalexpft_var age_var gmat_room preinc_room totalexpft_room age_room female_room single_room citizen_India_room gmat_roomvar preinc_roomvar totalexpft_roomvar age_roomvar y2008 y2009 y2010 if housing_type=="shared"
reg low_grpwork_gpa gmat preinc totalexpft age female single citizen_India gmat_grp preinc_grp totalexpft_grp age_grp female_grp single_grp citizen_India_grp gmat_var preinc_var totalexpft_var age_var gmat_room preinc_room totalexpft_room age_room female_room single_room citizen_India_room gmat_roomvar preinc_roomvar totalexpft_roomvar age_roomvar y2008 y2009 y2010 if housing_type=="shared"

/* Table 7: Heterogenous impact of peer GMAT scores */
reg core_gpa totalexpft female single gmat citizen_India preinc age totalexpft_grp female_grp single_grp gmat_grp citizen_India_grp preinc_grp age_grp totalexpft_var gmat_var preinc_var age_var totalexpft_room female_room single_room gmat_room citizen_India_room preinc_room age_room totalexpft_roomvar gmat_roomvar preinc_roomvar age_roomvar y2008 y2009 y2010 if gmat_gtmean==0
reg core_gpa totalexpft female single gmat citizen_India preinc age totalexpft_grp female_grp single_grp gmat_grp citizen_India_grp preinc_grp age_grp totalexpft_var gmat_var preinc_var age_var totalexpft_room female_room single_room gmat_room citizen_India_room preinc_room age_room totalexpft_roomvar gmat_roomvar preinc_roomvar age_roomvar y2008 y2009 y2010 if gmat_gtmean==1
reg core_gpa totalexpft female single gmat citizen_India preinc age totalexpft_grp female_grp single_grp gmat_grp citizen_India_grp preinc_grp age_grp totalexpft_var gmat_var preinc_var age_var totalexpft_room female_room single_room gmat_room citizen_India_room preinc_room age_room totalexpft_roomvar gmat_roomvar preinc_roomvar age_roomvar y2008 y2009 y2010 if gmat_roomgtmean==0
reg core_gpa totalexpft female single gmat citizen_India preinc age totalexpft_grp female_grp single_grp gmat_grp citizen_India_grp preinc_grp age_grp totalexpft_var gmat_var preinc_var age_var totalexpft_room female_room single_room gmat_room citizen_India_room preinc_room age_room totalexpft_roomvar gmat_roomvar preinc_roomvar age_roomvar y2008 y2009 y2010 if gmat_roomgtmean==1

/* Table B.1: Impact of core GPA on earnings */
reg core_gpa gmat preinc totalexpft age female single citizen_India gmat_grp preinc_grp totalexpft_grp age_grp female_grp single_grp citizen_India_grp gmat_grp_same_sv preinc_grp_same_sv totalexpft_grp_same_sv gmat_var preinc_var totalexpft_var age_var gmat_var_same_sv preinc_var_same_sv totalexpft_var_same_sv gmat_room preinc_room totalexpft_room age_room female_room single_room citizen_India_room gmat_roomvar preinc_roomvar totalexpft_roomvar age_roomvar y2008 y2009 y2010 if housing_type=="shared"

/* Table D.1: Impact of extended networks */
reg core_gpa totalexpft female single gmat citizen_India preinc age totalexpft_grp female_grp single_grp gmat_grp citizen_India_grp preinc_grp age_grp totalexpft_var gmat_var preinc_var age_var totalexpft_section female_section single_section gmat_section citizen_India_section preinc_section age_section totalexpft_secvar gmat_secvar preinc_secvar age_secvar totalexpft_room female_room single_room gmat_room citizen_India_room preinc_room age_room totalexpft_roomvar gmat_roomvar preinc_roomvar age_roomvar totalexpft_block female_block single_block gmat_block citizen_India_block preinc_block age_block totalexpft_blockvar gmat_blockvar preinc_blockvar age_blockvar y2008 y2009 y2010, vce (cluster sv)
reg t1_gpa totalexpft female single gmat citizen_India preinc age totalexpft_grp female_grp single_grp gmat_grp citizen_India_grp preinc_grp age_grp totalexpft_var gmat_var preinc_var age_var totalexpft_section female_section single_section gmat_section citizen_India_section preinc_section age_section totalexpft_secvar gmat_secvar preinc_secvar age_secvar totalexpft_room female_room single_room gmat_room citizen_India_room preinc_room age_room totalexpft_roomvar gmat_roomvar preinc_roomvar age_roomvar totalexpft_block female_block single_block gmat_block citizen_India_block preinc_block age_block totalexpft_blockvar gmat_blockvar preinc_blockvar age_blockvar y2008 y2009 y2010, vce (cluster sv)
reg t2_gpa totalexpft female single gmat citizen_India preinc age totalexpft_grp female_grp single_grp gmat_grp citizen_India_grp preinc_grp age_grp totalexpft_var gmat_var preinc_var age_var totalexpft_section female_section single_section gmat_section citizen_India_section preinc_section age_section totalexpft_secvar gmat_secvar preinc_secvar age_secvar totalexpft_room female_room single_room gmat_room citizen_India_room preinc_room age_room totalexpft_roomvar gmat_roomvar preinc_roomvar age_roomvar totalexpft_block female_block single_block gmat_block citizen_India_block preinc_block age_block totalexpft_blockvar gmat_blockvar preinc_blockvar age_blockvar y2008 y2009 y2010, vce (cluster sv)
reg t3_gpa totalexpft female single gmat citizen_India preinc age totalexpft_grp female_grp single_grp gmat_grp citizen_India_grp preinc_grp age_grp totalexpft_var gmat_var preinc_var age_var totalexpft_section female_section single_section gmat_section citizen_India_section preinc_section age_section totalexpft_secvar gmat_secvar preinc_secvar age_secvar totalexpft_room female_room single_room gmat_room citizen_India_room preinc_room age_room totalexpft_roomvar gmat_roomvar preinc_roomvar age_roomvar totalexpft_block female_block single_block gmat_block citizen_India_block preinc_block age_block totalexpft_blockvar gmat_blockvar preinc_blockvar age_blockvar y2008 y2009 y2010, vce (cluster sv)
reg t4_gpa totalexpft female single gmat citizen_India preinc age totalexpft_grp female_grp single_grp gmat_grp citizen_India_grp preinc_grp age_grp totalexpft_var gmat_var preinc_var age_var totalexpft_section female_section single_section gmat_section citizen_India_section preinc_section age_section totalexpft_secvar gmat_secvar preinc_secvar age_secvar totalexpft_room female_room single_room gmat_room citizen_India_room preinc_room age_room totalexpft_roomvar gmat_roomvar preinc_roomvar age_roomvar totalexpft_block female_block single_block gmat_block citizen_India_block preinc_block age_block totalexpft_blockvar gmat_blockvar preinc_blockvar age_blockvar y2008 y2009 y2010, vce (cluster sv)

/* Table E.1: Impact of GMAT scores over terms */
reg t1_gpa gmat preinc totalexpft age female single citizen_India gmat_grp preinc_grp totalexpft_grp age_grp female_grp single_grp citizen_India_grp gmat_var preinc_var totalexpft_var age_var gmat_room preinc_room totalexpft_room age_room female_room single_room citizen_India_room gmat_roomvar preinc_roomvar totalexpft_roomvar age_roomvar y2008 y2009 y2010 if housing_type=="shared"
reg elec_gpa gmat preinc totalexpft age female single citizen_India gmat_grp preinc_grp totalexpft_grp age_grp female_grp single_grp citizen_India_grp gmat_var preinc_var totalexpft_var age_var gmat_room preinc_room totalexpft_room age_room female_room single_room citizen_India_room gmat_roomvar preinc_roomvar totalexpft_roomvar age_roomvar y2008 y2009 y2010 if housing_type=="shared"