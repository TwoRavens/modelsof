***Last Updated: 12/14/2018 Stata14
/*==========================================*
Paper:			Breaking the Cycle? Education and the Intergenerational Transmission of Violence

Purpose:        Data cleaning for the HLFS 2014 data

To re-run our analysis, please install a folder "Domestic Violence". There should be 5 subfolders in order for do-files to run:

"originals"
"created"
"do files"
"graphs"
"output"

To run the do file all you need to do is to change the path of the working directory in line 34.

The dataset used in this do file is provided by the Turkish Statistical Institute (TSI). Their data availability policy 
prohibits the distribution of data to non-registered users. Researchers have to complete a form 
(http://www.turkstat.gov.tr/UstMenu/body/bilgitalep/MVKullaniciTalepFormu_ENG.pdf), and send it 
to bilgi@tuik.gov.tr by e-mail. Upon receipt of this form, the TSI sends 
the datasets through an ftp server electronically. 

The name of the dataset sent by the TSI will be data2014.csv. Please convert this data in csv format
into Stata format, and save it as "Domestic Violence/originals/hlfs2014.dta" before you run this
do file.
*==========================================*/
clear
set more off 
set matsize 8000
cap log close
#delimit ;

global dir="XXX\Domestic Violence";
cd "$dir";

use "originals/hlfs2014.dta", clear

*AGE VARIABLE AND DIFFERENCES
drop if dogum_ay==99
rename dogum_ay month
rename dogum_yil birth_year

label variable month "Month of birth"
label variable birth_year "Year of birth"

gen dif=.
replace dif = (-1)*[(12*(1987-birth_year-1))+(12-month)+1] if birth_year<1987
replace dif = [(12*(birth_year-1987-1))+month+11] if birth_year>1987
replace dif = (-1)*[1-month] if birth_year==1987&month<1
replace dif = month - 1 if birth_year==1987&month>=1

label variable dif "Born after January 1987 (in months)"

gen di1=dif
gen di1_i=dif
replace di1_i=0 if dif<0
gen di2=dif^2
gen di2_i=dif^2
replace di2_i=0 if dif<0
gen di3=dif^3
gen di3_i=dif^3
replace di3_i=0 if dif<0

gen dif2=.
replace dif2 = (-1)*[(12*(1993-birth_year-1))+(12-month)+1] if birth_year<1993
replace dif2 = [(12*(birth_year-1993-1))+month+11] if birth_year>1993
replace dif2 = (-1)*[1-month] if birth_year==1993&month<1
replace dif2 = month - 1 if birth_year==1993&month>=1

label variable dif2 "Born after January 1993 (in months)"

gen jhighschool = 0
replace jhighschool = 1 if s13>2
replace jhighschool =. if s13==.

gen highschool = 0
replace highschool = 1 if s13>3
replace highschool =. if s13==.

gen primaryschool = 0
replace primaryschool = 1 if s13>1
replace primaryschool =. if s13==.

label variable jhighschool "Dummy:1 if last degree is junior high"
label variable highschool "Dummy:1 if last degree is high school"
label variable primaryschool "Dummy:1 if last degree is primary school"

gen schooling=.
replace schooling = 5 if s13==2
replace schooling = 8 if s13==3
replace schooling = 11 if s13==4
replace schooling = 15 if s13==5
replace schooling = 17 if s13==6

label variable schooling "Years of schooling"

gen after1986=0
replace after1986=1 if dif>=0

label variable after1986 "Dummy:1 if born after January 1987"

gen modate = ym(birth_year, month)
format modate %tm

label variable modate "Birth month and year variables"

*GENERATE OTHER IMPORTANT CONTROL VARIABLES
*Regions and birth month dummies
tab nuts2, gen(region26_)
tab nuts1, gen(region12_)
tab month, gen(month_)

label variable nuts1 "12 regions of residence"
label variable nuts2 "26 regions of residence"

foreach num of numlist 1(1)12{
label variable region12_`num' "Region dummies for 12 regions"
}

foreach num of numlist 1(1)26{
label variable region26_`num' "Region dummies for 26 regions"
}

foreach num of numlist 1(1)12{
label variable month_`num' "Birth month dummies"
}

gen male=s3
replace male=0 if s3==2

label variable male "Dummy:1 if male"

gen rural=0
replace rural=1 if s10b==3

label variable rural "Dummy:1 if current residence is rural"

label variable faktor "Sampling weight"
label variable formno "Household ID"

rename s1 z1

drop year enroll school teacher student population sch_per tch_per _merge schooled open_high vocational academic employed neet a0_5 a6_17 a18_44 a45_64 a65p s6_2 s6test oldest s6_2f s6testf oldest_female N_05 N_05_1 N_05_2 N_05_3 N_05_4 N_05_5 N_05_6 N_05_7 N_05_8 N_05_9 N_05_10 NSA N_1 N_2 N_3 N_4 N_5 N_6 N_7 N_8 N_9 N_10 N_11 N_12 N_13 N_14 N_15 M0t5_0 M6t17_0 M18t44_0 M45t64_0 M65p_0 F0t5_0 F6t17_0 F18t44_0 F45t64_0 F65p_0 hour lhour enroll_2011
drop hh_buyukluk gelir_gecenay_k isbasi_isbulan faal_durum durum ido_neden yakinlik kirkent wave
drop s6 s6_grup s7 s9a s9b s10a s10b s8a s8b s11 s12a s12b s12c s13 s14 s15kod s17 s18 s19 s21 s24 s26 s27 s28 s29 s39 s33kod s34 s35 s37a s38kod s41 s42 s43a s44 s45 s46 s48 s49 s51 s52 s53kod s54 s55a s56a_top s56b_top s57 s58 s60a s60b s61 s62 s63 s64a s64b s65 s66 s67 s75 s77 s78a s78b s78c s78d s78e s78f s78g s78h s78İ s78j s78k s78l s78m s79kod s80a s80b s81 s83 s84 s85 s91 s92a s92b s93 s94kod s95kod s96 s97 s98kod s99
drop s3 s22 s33kodr2 s33kodr1 s69 s76 s78i s70 s71 s38kod88 s38kod08 year_birth z1 referans_yil

save "created/hlfs2014_for_graphs.dta", replace
