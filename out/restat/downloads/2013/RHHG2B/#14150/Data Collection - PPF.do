/* Data Collection For PPF - US Firms*/

/* This file describes the steps taken in collecting the data for patent production function regressions */
/* In order for the file to be executed in its entirety, access to Development Bank of Japan's full firm-level
database is needed. The name of this file in the do-file below is "dbj1_tantai.dta" */


/* 

/* Compustat Query */

Data Request ID	ba099b4dcca2c3b7
Libraries/Data Sets	 comp/funda  /
Frequency/Date Range	ann / Jan 1983 - Dec 2004
Search Variable	GVKEY
Input Codes 
296 item(s)	
1013
1055
1098
1111
1161
-etc-
Conditional Statements	n/a
Output format/Compression	csv /
Variables Selected	CONSOL INDFMT DATAFMT POPSRC CURCD COSTAT CONM CUSIP FYR REVT XRD SICH
Extra Variables and Parameters Selected	 C  INDL  STD

/* Import Into Stata */

insheet using "C:/Stata/#14150/Compustat Query Outcome - US Firms.csv", comma
drop if fyear<1983
drop if fyear>2004
saveold "C:/Stata/#14150/US Sample PPF Raw.dta", replace
label variable gvkey "Compustat Firm Identifier"
label variable datadate "Data Date"
label variable fyear "Fiscal Year"
label variable indfmt "Format Indicator"
label variable consol "Consolidated Data Indicator"
label variable popsrc "Population Source"
label variable datafmt "Data Format"
label variable cusip "CUSIP Firm Identifier"
label variable conm "Firm Name"
label variable curcd "Currency"
label variable fyr "Fiscal Year End"
label variable revt "Revenue - Total"
label variable xrd "Research and Development Expense"
label variable costat "Company Status (Active/Inactive)"
label variable sich "SIC Code - Historical"
label variable revt_fn "Revenue Footnote"
label variable xrd_fn "R&D Footnote"
label variable revt_dc "Revenue Data Code"
label variable xrd_dc "R&D Data Code"
label variable ggroup "GIC Group"
label variable gind "GIC Industry"
label variable gsector "GIC Sector"
label variable gsubind "GIC Sub-industry"
label variable idbflag "International, Domestic, Both Indicator"
label variable loc "Headquarters ISO Country Code"
label variable sic "SIC Code - Current"
label variable spcindcd "S&P Industry Sector Code"
label variable spcseccd "S&P Economic Sector Code"

/* Trim Dataset */

drop datadate indfmt consol popsrc datafmt curcd fyr costat revt_fn xrd_fn revt_dc xrd_dc ggroup gind gsector idbflag sic spcindcd spcseccd
gen year=fyear
sort gvkey year
saveold "C:/Stata/#14150/US Sample PPF Intermediate.dta", replace

/* Create Grid

keep year
duplicates drop
sort year
saveold "C:/Stata/#14150/Time Period Grid.dta", replace

use "C:/Stata/#14150/US Sample PPF Intermediate.dta", clear
keep gvkey
duplicates drop
sort gvkey
saveold "C:/Stata/#14150/Gvkey Code Grid.dta", replace

use "C:/Stata/#14150/Gvkey Code Grid.dta", clear
cross using ""C:/Stata/#14150/Time Period Grid.dta"
sort gvkey year
saveold "C:/Stata/#14150/US Sample PPF Grid.dta", replace

/* Use Grid to Create US Sample Dataset

use "C:/Stata/#14150/US Sample PPF Grid.dta", clear
merge gvkey year using "C:/Stata/#14150/US Sample PPF Intermediate.dta" 
drop _merge
sort year
merge year using "C:/Stata/#14150/R&D Deflator - US.dta"
sort gvkey year
drop _merge

gen positive_sales=0
replace positive_sales=1 if revt>0 & revt!=.
gen positive_rd=0
replace positive_rd=1 if xrd>0 & xrd!=.
sort gvkey
by gvkey: egen no_positive_sales_years=sum(positive_sales)
sort gvkey
by gvkey: egen no_positive_rd_years=sum(positive_rd)
gen firm_for_analysis=0
replace firm_for_analysis=1 if no_positive_sales_years>=3 & no_positive_rd_years>=3
keep if firm_for_analysis==1
drop  positive_sales positive_rd no_positive_sales_years no_positive_rd_years firm_for_analysis
saveold "C:/Stata/#14150/US Sample PPF Intermediate 2.dta", replace

/* Add Patent Data */

use "C:/Stata/#14150/US Sample PPF Intermediate 2.dta", clear
sort gvkey year
merge gvkey year using "C:/Stata/#14150/Patent Counts for US Sample Firms by Application Year.dta"
drop _merge
sort gvkey year
merge gvkey year using "C:/Stata/#14150/Patent Counts for US Sample Firms by Grant Year.dta"
drop _merge
sort gvkey year
by gvkey: egen total_patent_count=sum(total_count_byappyear)
keep if total_patent_count>=10
saveold "C:/Stata/#14150/US Sample PPF Final.dta", replace



/* Assign Industry */

use "C:/Stata/#14150/US Sample PPF Final.dta", clear

gen electronics=0
gen semiconductors=0
gen IThardware=0

replace electronics=1 if gvkey==1608
replace electronics=1 if gvkey==4194
replace electronics=1 if gvkey==7506
replace electronics=1 if gvkey==8889
replace electronics=1 if gvkey==8960
replace electronics=1 if gvkey==9602
replace electronics=1 if gvkey==9965
replace electronics=1 if gvkey==11678
replace electronics=1 if gvkey==12581
replace electronics=1 if gvkey==12788
replace electronics=1 if gvkey==31607
replace electronics=1 if gvkey==65554


replace IThardware=1 if gvkey==1013
replace IThardware=1 if gvkey==1055
replace IThardware=1 if gvkey==1392
replace IThardware=1 if gvkey==1651
replace IThardware=1 if gvkey==1690
replace IThardware=1 if gvkey==3282
replace IThardware=1 if gvkey==3532
replace IThardware=1 if gvkey==3586
replace IThardware=1 if gvkey==3705
replace IThardware=1 if gvkey==3760
replace IThardware=1 if gvkey==3946
replace IThardware=1 if gvkey==3955
replace IThardware=1 if gvkey==5063
replace IThardware=1 if gvkey==5492
replace IThardware=1 if gvkey==5606
replace IThardware=1 if gvkey==6066
replace IThardware=1 if gvkey==6856
replace IThardware=1 if gvkey==7182
replace IThardware=1 if gvkey==7585
replace IThardware=1 if gvkey==7648
replace IThardware=1 if gvkey==8867
replace IThardware=1 if gvkey==9483
replace IThardware=1 if gvkey==9545
replace IThardware=1 if gvkey==10097
replace IThardware=1 if gvkey==10107
replace IThardware=1 if gvkey==10329
replace IThardware=1 if gvkey==10420
replace IThardware=1 if gvkey==10553
replace IThardware=1 if gvkey==11278
replace IThardware=1 if gvkey==12053
replace IThardware=1 if gvkey==12136
replace IThardware=1 if gvkey==12654
replace IThardware=1 if gvkey==12679
replace IThardware=1 if gvkey==13315
replace IThardware=1 if gvkey==14264
replace IThardware=1 if gvkey==14377
replace IThardware=1 if gvkey==14489
replace IThardware=1 if gvkey==14630
replace IThardware=1 if gvkey==15354
replace IThardware=1 if gvkey==16729
replace IThardware=1 if gvkey==19854
replace IThardware=1 if gvkey==20779
replace IThardware=1 if gvkey==23528
replace IThardware=1 if gvkey==24357
replace IThardware=1 if gvkey==24548
replace IThardware=1 if gvkey==24800
replace IThardware=1 if gvkey==25563
replace IThardware=1 if gvkey==29241
replace IThardware=1 if gvkey==30203
replace IThardware=1 if gvkey==30237
replace IThardware=1 if gvkey==30576
replace IThardware=1 if gvkey==61513
replace IThardware=1 if gvkey==61552
replace IThardware=1 if gvkey==61591
replace IThardware=1 if gvkey==62599
replace IThardware=1 if gvkey==62730
replace IThardware=1 if gvkey==63138
replace IThardware=1 if gvkey==64103
replace IThardware=1 if gvkey==64356
replace IThardware=1 if gvkey==65142
replace IThardware=1 if gvkey==1692
replace IThardware=1 if gvkey==3253
replace IThardware=1 if gvkey==5791
replace IThardware=1 if gvkey==6169
replace IThardware=1 if gvkey==7123
replace IThardware=1 if gvkey==7333
replace IThardware=1 if gvkey==7431
replace IThardware=1 if gvkey==11399
replace IThardware=1 if gvkey==13369
replace IThardware=1 if gvkey==13588
replace IThardware=1 if gvkey==24608
replace IThardware=1 if gvkey==25622
replace IThardware=1 if gvkey==25658


replace semiconductors=1 if gvkey==1161
replace semiconductors=1 if gvkey==1632
replace semiconductors=1 if gvkey==1704
replace semiconductors=1 if gvkey==2498
replace semiconductors=1 if gvkey==6003
replace semiconductors=1 if gvkey==6008
replace semiconductors=1 if gvkey==6109
replace semiconductors=1 if gvkey==6304
replace semiconductors=1 if gvkey==6529
replace semiconductors=1 if gvkey==6532
replace semiconductors=1 if gvkey==6565
replace semiconductors=1 if gvkey==7343
replace semiconductors=1 if gvkey==7772
replace semiconductors=1 if gvkey==9599
replace semiconductors=1 if gvkey==10453
replace semiconductors=1 if gvkey==10499
replace semiconductors=1 if gvkey==12215
replace semiconductors=1 if gvkey==12216
replace semiconductors=1 if gvkey==13941
replace semiconductors=1 if gvkey==14256
replace semiconductors=1 if gvkey==14324
replace semiconductors=1 if gvkey==14623
replace semiconductors=1 if gvkey==16401
replace semiconductors=1 if gvkey==16597
replace semiconductors=1 if gvkey==22325
replace semiconductors=1 if gvkey==23767
replace semiconductors=1 if gvkey==23943
replace semiconductors=1 if gvkey==24803
replace semiconductors=1 if gvkey==27794
replace semiconductors=1 if gvkey==27965
replace semiconductors=1 if gvkey==29085
replace semiconductors=1 if gvkey==29386
replace semiconductors=1 if gvkey==29722
replace semiconductors=1 if gvkey==31147
replace semiconductors=1 if gvkey==31881
replace semiconductors=1 if gvkey==60846
replace semiconductors=1 if gvkey==64853
replace semiconductors=1 if gvkey==65643
replace semiconductors=1 if gvkey==65904
replace semiconductors=1 if gvkey==66708
replace semiconductors=1 if gvkey==112095
replace semiconductors=1 if gvkey==116526
replace semiconductors=1 if gvkey==117768


replace electronics=1 if gvkey==5245 /* or IThardware? */
replace electronics=1 if gvkey==7883 /* or IThardware? */
replace electronics=1 if gvkey==9313 /* or IThardware? */
replace electronics=1 if gvkey==10232 /* or IThardware? */
replace electronics=1 if gvkey==10391 /* or IThardware? */
replace electronics=1 if gvkey==11191 /* or IThardware? */
replace electronics=1 if gvkey==11636 /* or IThardware? */
replace electronics=1 if gvkey==28195 /* or IThardware? */
replace electronics=1 if gvkey==62738 /* or IThardware? */
replace electronics=1 if gvkey==126554 /* or IThardware? */
replace electronics=1 if gvkey==29791 /* or IThardware? */

drop if electronics==0 & semiconductors==0 & IThardware==0

saveold "C:/Stata/#14150/US Sample PPF Final.dta", replace



/* ---------------------------------------------------------------- */

/* Data Collection For PPF - JP Firms*/

/* JP Firm List from DBJ JSIC, Prior Work, and Google Finance Survey */

use "C:/Stata/#14150/JP Base Sample.dta", clear
clear

/* Collect DBJ Data */

use "C:/Stata/#14150/R&D Data Available - JP.dta", clear
keep if year>1982 & year<2005
sort tsecode year
merge tsecode year using "C:/Stata/#14150/dbj1_tantai.dta", nokeep keep(id ind k2820)
/* k2820 = Gross Sales */
drop _merge
label variable tsecode /* Tokyo Stock Exchange firm identifier */
label variable year /* year - fiscal or data year */
label variable rd_expenditure /* nominal rd expenditure in 100 million Yen */
label variable id /* DBJ database firm identifier */
label variable ind /* DBJ database firm JSIC industry code */
label variable k2820 /* DBJ nominal gross sales in thousand Yen */
sort tsecode year
merge tsecode using "C:/Stata/#14150/JP Base Sample.dta", nokeep
drop _merge rd_data_available id
gen positive_sales=0
replace positive_sales=1 if k2820>0 & k2820!=.
gen positive_rd=0
replace positive_rd=1 if rd_expenditure>0 & rd_expenditure!=.
sort tsecode
by tsecode: egen no_positive_sales_years=sum(positive_sales)
sort tsecode
by tsecode: egen no_positive_rd_years=sum(positive_rd)
gen firm_for_analysis=0
replace firm_for_analysis=1 if no_positive_sales_years>=3 & no_positive_rd_years>=3
drop if tsecode==7974
drop if tsecode==9613
drop if tsecode==9766
drop if tsecode==9697
drop if tsecode==9432
drop if tsecode==9737
drop if tsecode==9984
drop if tsecode==9715
drop if tsecode==4901
keep if firm_for_analysis==1
drop positive_sales positive_rd 
drop no_positive_sales_years no_positive_rd_years firm_for_analysis finance_google_survey from_lee_stata sp_japan_it_03

rename rd_expenditure rd1
gen rd_expenditure=rd1*100
label variable rd_expenditure "nominal rd expenditure in million Yen"
drop rd1
gen sales=k2820/1000
label variable sales "DBJ nominal gross sales in million Yen"
sort year
merge year using "C:/Stata/#14150/R&D Deflator - JP.dta"
drop _merge
sort year
merge year using "C:/Stata/#14150/JPN-USD Exchange Rate.dta"
drop _merge
saveold "C:/Stata/#14150/JP Sample PPF Intermediate.dta", replace

/* Add Patent Data */
use "C:/Stata/#14150/JP Sample PPF Intermediate.dta", clear
sort tsecode year
merge tsecode year using "C:/Stata/#14150/Patent Counts for JP Sample Firms by Application Year.dta"
drop _merge
sort tsecode year
merge tsecode year using "C:/Stata/#14150/Patent Counts for JP Sample Firms by Grant Year.dta"
drop _merge
sort tsecode year
by tsecode: egen total_patent_count=sum(total_count_byappyear)
keep if total_patent_count>=10
saveold "C:/Stata/#14150/JP Sample PPF Final.dta", replace



/* Assign Sub-industry */

use "C:/Stata/#14150/JP Sample PPF Final.dta", clear

gen electronics=0
gen semiconductors=0
gen IThardware=0

replace electronics=1 if tsecode==4902
replace electronics=1 if tsecode==6504
replace electronics=1 if tsecode==6505
replace electronics=1 if tsecode==6506
replace electronics=1 if tsecode==6507
replace electronics=1 if tsecode==6508
replace electronics=1 if tsecode==6581
replace electronics=1 if tsecode==6641
replace electronics=1 if tsecode==6644
replace electronics=1 if tsecode==6705
replace electronics=1 if tsecode==6744
replace electronics=1 if tsecode==6745
replace electronics=1 if tsecode==6756
replace electronics=1 if tsecode==6759
replace electronics=1 if tsecode==6763
replace electronics=1 if tsecode==6765
replace electronics=1 if tsecode==6768
replace electronics=1 if tsecode==6770
replace electronics=1 if tsecode==6773
replace electronics=1 if tsecode==6794
replace electronics=1 if tsecode==6798
replace electronics=1 if tsecode==6800
replace electronics=1 if tsecode==6806
replace electronics=1 if tsecode==6807
replace electronics=1 if tsecode==6810
replace electronics=1 if tsecode==6818
replace electronics=1 if tsecode==6848
replace electronics=1 if tsecode==6849
replace electronics=1 if tsecode==6850
replace electronics=1 if tsecode==6853
replace electronics=1 if tsecode==6856
replace electronics=1 if tsecode==6859
replace electronics=1 if tsecode==6924
replace electronics=1 if tsecode==6925
replace electronics=1 if tsecode==6926
replace electronics=1 if tsecode==6934
replace electronics=1 if tsecode==6951
replace electronics=1 if tsecode==6954
replace electronics=1 if tsecode==6955
replace electronics=1 if tsecode==6971
replace electronics=1 if tsecode==6988
replace electronics=1 if tsecode==6991
replace electronics=1 if tsecode==7721
replace electronics=1 if tsecode==7726
replace electronics=1 if tsecode==7729
replace electronics=1 if tsecode==7731
replace electronics=1 if tsecode==7733
replace electronics=1 if tsecode==7762
replace electronics=1 if tsecode==7769
replace electronics=1 if tsecode==6808


replace semiconductors=1 if tsecode==6584
replace semiconductors=1 if tsecode==6707
replace semiconductors=1 if tsecode==6746
replace semiconductors=1 if tsecode==6767
replace semiconductors=1 if tsecode==6772
replace semiconductors=1 if tsecode==6801
replace semiconductors=1 if tsecode==6844
replace semiconductors=1 if tsecode==6857
replace semiconductors=1 if tsecode==6901
replace semiconductors=1 if tsecode==6902
replace semiconductors=1 if tsecode==6923
replace semiconductors=1 if tsecode==6963
replace semiconductors=1 if tsecode==8035

replace IThardware=1 if tsecode==6448
replace IThardware=1 if tsecode==6501 
replace IThardware=1 if tsecode==6502
replace IThardware=1 if tsecode==6588
replace IThardware=1 if tsecode==6645
replace IThardware=1 if tsecode==6701
replace IThardware=1 if tsecode==6702
replace IThardware=1 if tsecode==6704
replace IThardware=1 if tsecode==6708
replace IThardware=1 if tsecode==6754
replace IThardware=1 if tsecode==6758
replace IThardware=1 if tsecode==6762
replace IThardware=1 if tsecode==6764
replace IThardware=1 if tsecode==6771
replace IThardware=1 if tsecode==6792
replace IThardware=1 if tsecode==6815
replace IThardware=1 if tsecode==6845
replace IThardware=1 if tsecode==6910
replace IThardware=1 if tsecode==6952
replace IThardware=1 if tsecode==7750
replace IThardware=1 if tsecode==7751
replace IThardware=1 if tsecode==7752

replace electronics=1 if tsecode==6753 /* or IThardware? */
replace electronics=1 if tsecode==6816 /* or semiconductors? */
replace IThardware=1 if tsecode==6703 /* or semiconductors? */
replace semiconductors=1 if tsecode==6503 /* or electronics? */
replace semiconductors=1 if tsecode==8140 /* or electronics? */

drop if electronics==0 & semiconductors==0 & IThardware==0

saveold "C:/Stata/#14150/JP Sample PPF Final.dta", replace

*/