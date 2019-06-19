/* Tobin's Q Results */

/* This do-file allows for the replication of Tobin's Q based results. The first part allows for the user to replicate the dataset
and variable construction steps, while the second part replicates the Figures and Tables from the paper. */

/* The dataset and variable construction steps are currently "commented out" in the do-file below */

/* All results are collected into the joint log file named "results-log" */


/* 

/* Selecting the Sample */

/* US Sample */
/* Broad Sample */
use "C:/Stata/#14150/Gvkey Code Grid.dta", clear
sort gvkey
saveold "C:/Stata/#14150/Gvkey Code Grid.dta", replace

/* JP Sample */
/* Broad Sample */

use "C:/Stata/#14150/JP Base Sample.dta", clear
keep tsecode
sort tsecode
saveold "C:/Stata/#14150/Tsecode Code Grid.dta", replace



/* Select Variables Needed */


/* US Sample */

/* From Compustat - "C:/Stata/#14150/Downloaded Variables - US.dta" */
/* R&D Investment - "xrd" */
/* Year - "fyear" */
/* Revenue - Total - "revt" */
/* Year-Close Number of Outstanding Common Shares - "csho" */
/* Year-Close Price of Outstanding Common Shares - "prcc_c" */
/* Year-Close Liquidating Value of Preferred Capital - "pstkl" */
/* Total Long-Term Debt - "dltt" */
/* Short-Term Debt - Debt in Current Liabilities - "dlc" */
/* Year-End Book Value of Total Assets - "at" */

/* Own Construction */
/* R&D Deflator - "C:/Stata/#14150/R&D Deflator - US.dta" */
/* R&D Stocks - Calculated Using Perpetual Inventory Method - 15% Depreciation Rate - Excel Spreadsheet */
/* Capital Goods Deflator - BLS Series WPSSOP3200 - Stage of Processing - Capital Equipment Price Index - "C:/Stata/#14150/Goods Deflator - US.dta" */
/* Software Intensity - Share of Software Patents - "C:/Stata/#14150/Software Intensity - US.dta" */
/* Revenue Deflator - BLS Series WPU117 - PPI for Electrical Machinery & Equipment - "C:/Stata/#14150/Revenue Deflator 1 - US.dta" */
/* Revenue Deflator - BLS Series WPU11 - PPI for Machinery and Equipment - "C:/Stata/#14150/Revenue Deflator 2 - US.dta" */


/* JP Sample */

/* From DBJ - "C:/Stata/#14150/Downloaded Variables - JP.dta" */
/* Data Year - "year" */
/* Gross Sales - "k2820" */
/* Outstanding Amount of Stocks Issued - in 1000 Stocks - "k5440" */ 
/* Year-Low and Year-High Stock Price - "k0370" + "k0380" + "k0360" (information) */
/* Year-Close Liquidating Value of Preferred Capital - not available */
/* Long-Term Debt - Fixed Liabilities - "k2520" */
/* Long-Term Debt Due in One Year - Long-Term Borrowings of Current Maturity - "k2000" + "k2010" */
/* Short-term Debt - Short-term Borrowings - "k1960" + "k1970" */
/* Book Value of Total Assets - Total Assets - "k1880" */

/* Own Construction */
/* R&D Investment - From Kaisha Shiki Ho Survey - Excel Spreadsheet */
/* R&D Stocks - Calculated Using Perpetual Inventory Method - 15% Depreciation Rate - Excel Spreadsheet */
/* R&D Deflator - "C:/Stata/#14150/R&D Deflator - JP.dta" */
/* Capital Goods Deflator - BOJ Corporate Goods Average Price Index - Capital Goods (Domestic) - "C:/Stata/#14150/Capital Goods Deflator - JP.dta" */
/* Software Intensity - Share of Software Patents - "C:/Stata/#14150/Software Intensity - JP.dta" */
/* Revenue Deflator 1 - BOJ Corporate Goods Average Price Index for Electrical Machinery & Equipment - "C:/Stata/#14150/Revenue Deflator 1 - JP.dta" */
/* Revenue Deflator 2 - BOJ Corporate Goods Average Price Index for Manufacturing Industry Products - "C:/Stata/#14150/Revenue Deflator 2 - JP.dta" */




/* Construct R&D Stocks */

/* US Sample */
/* Explained in the attached Excel file - "R&D Stock Construction - US.xlsx" */
/* Contained in the following Stata Files: */
/* "C:/Stata/#14150/R&D Data Range - US.dta" */
/* "C:/Stata/#14150/R&D Stocks - US.dta" */

/* JP Sample */
/* Explained in the attached Excel file - "R&D Stock Construction - JP.xlsx" */
/* Contained in the following Stata Files: */
/* "C:/Stata/#14150/R&D Data Range - JP.dta" */
/* "C:/Stata/#14150/R&D Stocks - JP.dta" */



/* Constructing the Data File */

/* US Sample - Data Asembly*/
use "C:/Stata/#14150/Gvkey Code Grid.dta", clear
cross using "C:/Stata/#14150/Time Period.dta"
sort gvkey year
merge gvkey year using "C:/Stata/#14150/Downloaded Variables - US.dta"
drop if _merge==2
drop _merge costat
label variable at "Assets - Total, mil USD"
label variable csho "Common Shares Outstanding, millions"
label variable dlc "Debt in Current Liabilities - Total, mil USD"
label variable dltt "Long-Term Debt - Total, mil USD"
label variable pstkl "Preferred Stock - Liquidating Value, mil USD"
label variable revt "Revenue - Total, mil USD"
label variable xrd "Research and Development Expense, mil USD"
label variable prcc_c "Price Close - Annual - Calendar, USD"
sort gvkey year
merge gvkey year using "C:/Stata/#14150/R&D Data Range - US.dta"
drop if _merge==2
drop _merge
sort gvkey year
merge gvkey year using "C:/Stata/#14150/R&D Stocks - US.dta"
drop if _merge==2
label variable rd_available "time range where rd_data reported, imputations included"
label variable rd_stock "deflated R&D stock, 15% dep.rate, mil USD"
drop _merge
sort gvkey year
merge gvkey year using "C:/Stata/#14150/Software Intensity - US.dta"
sort gvkey year
by gvkey: egen sum_patents1=mean(sum_patents)
by gvkey: egen sofshare_total1=mean(sofshare_total)
drop sum_patents sofshare_total
rename sum_patents1 sum_patents
rename sofshare_total1 sofshare_total
drop _merge
label variable sofshare_byyear "share of software patents by grant year"
label variable sofshare_total "total share of software patents across sample period"
label variable sum_patents "total uspto patents granted in sample period"
sort year
merge year using "C:/Stata/#14150/Capital Goods Deflator - US.dta"
drop _merge
sort year 
merge year using "C:/Stata/#14150/R&D Deflator - US.dta"
drop _merge
sort year
merge year using "C:/Stata/#14150/Revenue Deflator 1 - US.dta"
drop _merge
sort year
merge year using "C:/Stata/#14150/Revenue Deflator 2 - US.dta"
drop _merge
sort gvkey year
saveold "C:/Stata/#14150/Final Data Assembly - US.dta", replace

/* JP Sample - Data Assembly */
use "C:/Stata/#14150/Tsecode Code Grid.dta", clear
cross using "C:/Stata/#14150/Time Period.dta"
sort tsecode year
merge tsecode year using "C:/Stata/#14150/Downloaded Variables - JP.dta"
drop if _merge==2
drop _merge id
label variable k2820 "gross sales, 000 yen"
label variable k5440 "outstanding amount of stocks issued, 000 stocks"
label variable k0370 "year-low stock price, yen"
label variable k0380 "year-high stock price, yen"
label variable k0360 "stock price information"
label variable k2520 "long-term debt, 000 yen"
label variable k2000 "long-term debt due in one year, part1, 000 yen"
label variable k2010 "long-term debt due in one year, part2, 000 yen"
label variable k1960 "short-term debt, part1, 000 yen"
label variable k1970 "short-term debt, part2, 000 yen"
label variable k1880 "book value of total assets, 000 yen"
label variable ind "DBJ industry code"
drop k0360
sort tsecode year
merge tsecode year using "C:/Stata/#14150/R&D Data Range - JP.dta"
drop if _merge==2
drop _merge
sort tsecode year
merge tsecode year using "C:/Stata/#14150/R&D Stocks - JP.dta"
drop if _merge==2
label variable rd_available "time range where rd_data reported, imputations included"
label variable rd_stock "deflated R&D stock, 15% dep.rate, mil USD"
drop _merge
sort tsecode year
merge tsecode year using "C:/Stata/#14150/Software Intensity - JP.dta"
sort tsecode year
by tsecode: egen sum_patents1=mean(sum_patents)
by tsecode: egen sofshare_total1=mean(sofshare_total)
drop sum_patents sofshare_total
rename sum_patents1 sum_patents
rename sofshare_total1 sofshare_total
drop _merge
label variable sofshare_byyear "share of software patents by grant year"
label variable sofshare_total "total share of software patents across sample period"
label variable sum_patents "total uspto patents granted in sample period"
sort year
merge year using "C:/Stata/#14150/Capital Goods Deflator - JP.dta"
drop _merge
sort year 
merge year using "C:/Stata/#14150/R&D Deflator - JP.dta"
drop _merge
sort year
merge year using "C:/Stata/#14150/Revenue Deflator 1 - JP.dta"
drop _merge
sort year
merge year using "C:/Stata/#14150/Revenue Deflator 2 - JP.dta"
drop _merge
sort tsecode year
saveold "C:/Stata/#14150/Final Data Assembly - JP.dta", replace


/* US Sample - Final Variable Construction*/
use "C:/Stata/#14150/Final Data Assembly - US.dta", clear
gen assets_deflated=at/capital_goods_deflator_us*100
gen sales_deflated_1=revt/revenue_deflator_us_1*100
gen sales_deflated_2=revt/revenue_deflator_us_2*100
label variable assets_deflated "deflated book value of total assets, mil USD"
label variable sales_deflated_1 "deflated revenue, mil USD"
label variable sales_deflated_2 "deflated revenue, mil USD"
gen market_value = ((csho * prcc_c) + (pstkl)) + ((dltt) + (dlt))
gen tobin_q=market_value/assets_deflated
tostring gvkey, replace
gen firm_id="US"+gvkey
keep firm_id gvkey year rd_available rd_stock sofshare_byyear sum_patents sofshare_total assets_deflated sales_deflated_1 sales_deflated_2 market_value tobin_q
destring gvkey, replace
sort gvkey year
saveold "C:/Stata/#14150/Final Dataset - Tobin's Q - US.dta", replace

/* JP Sample - Final Variable Construction*/
use "C:/Stata/#14150/Final Data Assembly - JP.dta", clear
sort year
merge year using "C:/Stata/#14150/JPN-USD Exchange Rate.dta"
drop if _merge==2
drop _merge
gen assets_milUSD=k1880/1000/jpnusd_rate
gen assets_deflated=assets_milUSD/capital_goods_deflator_jp*100
gen sales_milUSD=k2820/1000/jpnusd_rate
gen sales_deflated_1=sales_milUSD/revenue_deflator_jp_1*100
gen sales_deflated_2=sales_milUSD/revenue_deflator_jp_2*100
label variable assets_deflated "deflated book value of total assets, mil USD"
label variable sales_deflated_1 "deflated revenue, mil USD"
label variable sales_deflated_2 "deflated revenue, mil USD"
gen k5440_mil=k5440/1000
gen price_avg=(k0370+k0380)/2
gen price_avg_USD=price_avg/jpnusd_rate
gen debt_long_milUSD=k2520/1000/jpnusd_rate
gen debt_short_milUSD=(k1960+k1970+k2000+k2010)/1000/jpnusd_rate
gen market_value = ((k5440_mil * price_avg_USD) + (0)) + ((debt_long_milUSD) + (debt_short_milUSD))
gen tobin_q=market_value/assets_deflated
tostring tsecode, replace
gen firm_id="JP"+tsecode
keep firm_id tsecode year rd_available rd_stock sofshare_byyear sum_patents sofshare_total assets_deflated sales_deflated_1 sales_deflated_2 market_value tobin_q
destring tsecode, replace
sort tsecode year
saveold "C:/Stata/#14150/Final Dataset - Tobin's Q - JP.dta", replace

*/



/* 
/* This Section Allows for Replication of Figure 6 */
use "C:/Stata/#14150/Final Dataset - Tobin's Q - US.dta", clear
gen electronics=0
gen semiconductors=0
gen IThardware=0
replace electronics=1 if gvkey==1608
replace electronics=1 if gvkey==4194
replace electronics=1 if gvkey==5245
replace electronics=1 if gvkey==7506
replace electronics=1 if gvkey==7883
replace electronics=1 if gvkey==8889
replace electronics=1 if gvkey==8960
replace electronics=1 if gvkey==9313
replace electronics=1 if gvkey==9602
replace electronics=1 if gvkey==9965
replace electronics=1 if gvkey==10232
replace electronics=1 if gvkey==10391
replace electronics=1 if gvkey==11191
replace electronics=1 if gvkey==11636
replace electronics=1 if gvkey==11678
replace electronics=1 if gvkey==12581
replace electronics=1 if gvkey==12788
replace electronics=1 if gvkey==29791
replace electronics=1 if gvkey==31607
replace electronics=1 if gvkey==62738
replace electronics=1 if gvkey==65554
replace electronics=1 if gvkey==126554
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
replace semiconductors=1 if gvkey==117768
replace IThardware=1 if gvkey==1013
replace IThardware=1 if gvkey==1055
replace IThardware=1 if gvkey==1392
replace IThardware=1 if gvkey==1651
replace IThardware=1 if gvkey==1690
replace IThardware=1 if gvkey==1692
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
replace IThardware=1 if gvkey==5791
replace IThardware=1 if gvkey==6066
replace IThardware=1 if gvkey==6169
replace IThardware=1 if gvkey==6856
replace IThardware=1 if gvkey==7123
replace IThardware=1 if gvkey==7182
replace IThardware=1 if gvkey==7333
replace IThardware=1 if gvkey==7431
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
replace IThardware=1 if gvkey==11399
replace IThardware=1 if gvkey==12053
replace IThardware=1 if gvkey==12136
replace IThardware=1 if gvkey==12654
replace IThardware=1 if gvkey==12679
replace IThardware=1 if gvkey==13315
replace IThardware=1 if gvkey==13369
replace IThardware=1 if gvkey==14264
replace IThardware=1 if gvkey==14377
replace IThardware=1 if gvkey==14489
replace IThardware=1 if gvkey==14630
replace IThardware=1 if gvkey==15354
replace IThardware=1 if gvkey==16729
replace IThardware=1 if gvkey==20779
replace IThardware=1 if gvkey==23528
replace IThardware=1 if gvkey==24357
replace IThardware=1 if gvkey==24548
replace IThardware=1 if gvkey==24608
replace IThardware=1 if gvkey==24800
replace IThardware=1 if gvkey==25563
replace IThardware=1 if gvkey==25622
replace IThardware=1 if gvkey==25658
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
drop if electronics==0 & semiconductors==0 & IThardware==0
gen industry=0
replace industry=1 if electronics==1
replace industry=2 if semiconductors==1
replace industry=3 if IThardware==1
keep gvkey year tobin_q industry
sort year industry
collapse (mean) tobin_q, by(year industry)
sort industry year
clear

use "C:/Stata/#14150/Final Dataset - Tobin's Q - JP.dta", clear
gen electronics=0
gen semiconductors=0
gen IThardware=0
replace electronics=1 if tsecode==4902
replace electronics=1 if tsecode==6504
replace electronics=1 if tsecode==6506
replace electronics=1 if tsecode==6507
replace electronics=1 if tsecode==6508
replace electronics=1 if tsecode==6581
replace electronics=1 if tsecode==6641
replace electronics=1 if tsecode==6705
replace electronics=1 if tsecode==6744
replace electronics=1 if tsecode==6745
replace electronics=1 if tsecode==6753
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
replace electronics=1 if tsecode==6816
replace electronics=1 if tsecode==6849
replace electronics=1 if tsecode==6856
replace electronics=1 if tsecode==6924
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
replace semiconductors=1 if tsecode==6503
replace semiconductors=1 if tsecode==6584
replace semiconductors=1 if tsecode==6707
replace semiconductors=1 if tsecode==6746
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
replace IThardware=1 if tsecode==6703
replace IThardware=1 if tsecode==6704
replace IThardware=1 if tsecode==6708
replace IThardware=1 if tsecode==6754
replace IThardware=1 if tsecode==6758
replace IThardware=1 if tsecode==6762
replace IThardware=1 if tsecode==6764
replace IThardware=1 if tsecode==6792
replace IThardware=1 if tsecode==6845
replace IThardware=1 if tsecode==6910
replace IThardware=1 if tsecode==6952
replace IThardware=1 if tsecode==7750
replace IThardware=1 if tsecode==7751
replace IThardware=1 if tsecode==7752
drop if electronics==0 & semiconductors==0 & IThardware==0
gen industry=0
replace industry=1 if electronics==1
replace industry=2 if semiconductors==1
replace industry=3 if IThardware==1
keep tsecode year tobin_q industry
sort year industry
collapse (mean) tobin_q, by(year industry)
sort industry year
clear

*/


/*

/* Preparing the Final Regression Dataset */

/* US Sample */
use "C:/Stata/#14150/Final Dataset - Tobin's Q - US.dta", clear
gen electronics=0
gen semiconductors=0
gen IThardware=0
replace electronics=1 if gvkey==1608
replace electronics=1 if gvkey==4194
replace electronics=1 if gvkey==5245
replace electronics=1 if gvkey==7506
replace electronics=1 if gvkey==7883
replace electronics=1 if gvkey==8889
replace electronics=1 if gvkey==8960
replace electronics=1 if gvkey==9313
replace electronics=1 if gvkey==9602
replace electronics=1 if gvkey==9965
replace electronics=1 if gvkey==10232
replace electronics=1 if gvkey==10391
replace electronics=1 if gvkey==11191
replace electronics=1 if gvkey==11636
replace electronics=1 if gvkey==11678
replace electronics=1 if gvkey==12581
replace electronics=1 if gvkey==12788
replace electronics=1 if gvkey==29791
replace electronics=1 if gvkey==31607
replace electronics=1 if gvkey==62738
replace electronics=1 if gvkey==65554
replace electronics=1 if gvkey==126554
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
replace semiconductors=1 if gvkey==117768
replace IThardware=1 if gvkey==1013
replace IThardware=1 if gvkey==1055
replace IThardware=1 if gvkey==1392
replace IThardware=1 if gvkey==1651
replace IThardware=1 if gvkey==1690
replace IThardware=1 if gvkey==1692
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
replace IThardware=1 if gvkey==5791
replace IThardware=1 if gvkey==6066
replace IThardware=1 if gvkey==6169
replace IThardware=1 if gvkey==6856
replace IThardware=1 if gvkey==7123
replace IThardware=1 if gvkey==7182
replace IThardware=1 if gvkey==7333
replace IThardware=1 if gvkey==7431
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
replace IThardware=1 if gvkey==11399
replace IThardware=1 if gvkey==12053
replace IThardware=1 if gvkey==12136
replace IThardware=1 if gvkey==12654
replace IThardware=1 if gvkey==12679
replace IThardware=1 if gvkey==13315
replace IThardware=1 if gvkey==13369
replace IThardware=1 if gvkey==14264
replace IThardware=1 if gvkey==14377
replace IThardware=1 if gvkey==14489
replace IThardware=1 if gvkey==14630
replace IThardware=1 if gvkey==15354
replace IThardware=1 if gvkey==16729
replace IThardware=1 if gvkey==20779
replace IThardware=1 if gvkey==23528
replace IThardware=1 if gvkey==24357
replace IThardware=1 if gvkey==24548
replace IThardware=1 if gvkey==24608
replace IThardware=1 if gvkey==24800
replace IThardware=1 if gvkey==25563
replace IThardware=1 if gvkey==25622
replace IThardware=1 if gvkey==25658
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
drop if electronics==0 & semiconductors==0 & IThardware==0
gen Q=tobin_q
gen RD_A=rd_stock/assets_deflated
gen lnQ=ln(Q)
gen lnRD_A=ln(RD_A)
gen y_8388=0
replace y_8388=1 if year==1983
replace y_8388=1 if year==1984
replace y_8388=1 if year==1985
replace y_8388=1 if year==1986
replace y_8388=1 if year==1987
replace y_8388=1 if year==1988
gen y_8993=0
replace y_8993=1 if year==1989
replace y_8993=1 if year==1990
replace y_8993=1 if year==1991
replace y_8993=1 if year==1992
replace y_8993=1 if year==1993
gen y_9499=0
replace y_9499=1 if year==1994
replace y_9499=1 if year==1995
replace y_9499=1 if year==1996
replace y_9499=1 if year==1997
replace y_9499=1 if year==1998
replace y_9499=1 if year==1999
gen y_0004=0
replace y_0004=1 if year==2000
replace y_0004=1 if year==2001
replace y_0004=1 if year==2002
replace y_0004=1 if year==2003
replace y_0004=1 if year==2004
gen lnRD_A_8993=lnRD_A*y_8993
gen lnRD_A_9499=lnRD_A*y_9499
gen lnRD_A_0004=lnRD_A*y_0004
gen lnY1=ln(sales_deflated_1)
gen RD_A_8993=RD_A*y_8993
gen RD_A_9499=RD_A*y_9499
gen RD_A_0004=RD_A*y_0004
sort gvkey
by gvkey: egen sum_rd_available=sum(rd_available)
saveold "C:/Stata/#14150/Regression Dataset - Tobin's Q - US.dta", replace

/* JP Sample */
use "C:/Stata/#14150/Final Dataset - Tobin's Q - JP.dta", clear
gen electronics=0
gen semiconductors=0
gen IThardware=0
replace electronics=1 if tsecode==4902
replace electronics=1 if tsecode==6504
replace electronics=1 if tsecode==6506
replace electronics=1 if tsecode==6507
replace electronics=1 if tsecode==6508
replace electronics=1 if tsecode==6581
replace electronics=1 if tsecode==6641
replace electronics=1 if tsecode==6705
replace electronics=1 if tsecode==6744
replace electronics=1 if tsecode==6745
replace electronics=1 if tsecode==6753
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
replace electronics=1 if tsecode==6816
replace electronics=1 if tsecode==6849
replace electronics=1 if tsecode==6856
replace electronics=1 if tsecode==6924
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
replace semiconductors=1 if tsecode==6503
replace semiconductors=1 if tsecode==6584
replace semiconductors=1 if tsecode==6707
replace semiconductors=1 if tsecode==6746
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
replace IThardware=1 if tsecode==6703
replace IThardware=1 if tsecode==6704
replace IThardware=1 if tsecode==6708
replace IThardware=1 if tsecode==6754
replace IThardware=1 if tsecode==6758
replace IThardware=1 if tsecode==6762
replace IThardware=1 if tsecode==6764
replace IThardware=1 if tsecode==6792
replace IThardware=1 if tsecode==6845
replace IThardware=1 if tsecode==6910
replace IThardware=1 if tsecode==6952
replace IThardware=1 if tsecode==7750
replace IThardware=1 if tsecode==7751
replace IThardware=1 if tsecode==7752
drop if electronics==0 & semiconductors==0 & IThardware==0
gen Q=tobin_q
gen RD_A=rd_stock/assets_deflated
gen lnQ=ln(Q)
gen lnRD_A=ln(RD_A)
gen y_8388=0
replace y_8388=1 if year==1983
replace y_8388=1 if year==1984
replace y_8388=1 if year==1985
replace y_8388=1 if year==1986
replace y_8388=1 if year==1987
replace y_8388=1 if year==1988
gen y_8993=0
replace y_8993=1 if year==1989
replace y_8993=1 if year==1990
replace y_8993=1 if year==1991
replace y_8993=1 if year==1992
replace y_8993=1 if year==1993
gen y_9499=0
replace y_9499=1 if year==1994
replace y_9499=1 if year==1995
replace y_9499=1 if year==1996
replace y_9499=1 if year==1997
replace y_9499=1 if year==1998
replace y_9499=1 if year==1999
gen y_0004=0
replace y_0004=1 if year==2000
replace y_0004=1 if year==2001
replace y_0004=1 if year==2002
replace y_0004=1 if year==2003
replace y_0004=1 if year==2004
gen lnRD_A_8993=lnRD_A*y_8993
gen lnRD_A_9499=lnRD_A*y_9499
gen lnRD_A_0004=lnRD_A*y_0004
gen lnY1=ln(sales_deflated_1)
gen RD_A_8993=RD_A*y_8993
gen RD_A_9499=RD_A*y_9499
gen RD_A_0004=RD_A*y_0004
sort tsecode
by tsecode: egen sum_rd_available=sum(rd_available)
saveold "C:/Stata/#14150/Regression Dataset - Tobin's Q - JP.dta", replace

*/



/* Replicating Tables 5-8 */

use "C:/Stata/#14150/Regression Dataset - Tobin's Q - US.dta", clear
append using "C:/Stata/#14150/Regression Dataset - Tobin's Q - JP.dta"

egen firm_id_string = group(firm_id)
xtset firm_id_string year

gen japan=0
replace japan=1 if tsecode!=.

gen RD_A_japan = RD_A * japan
gen RD_A_sof_total = RD_A * sofshare_total
gen RD_A_sof_byyear = RD_A * sofshare_byyear


log using "C:/Stata/#14150/results-log.smcl", append

/* Table 8 */

xtreg lnQ RD_A RD_A_8993 RD_A_9499 RD_A_0004 lnY1 y_8993 y_9499 y_0004 semiconductors IThardware if sum_patents>=10 & sum_rd_available>=3 & sales_deflated_1>=0 & sales_deflated_1!=. & rd_available==1 & lnQ!=., fe i(firm_id_string) robust
xtreg lnQ RD_A RD_A_8993 RD_A_9499 RD_A_0004 lnY1 y_8993 y_9499 y_0004 semiconductors IThardware if sum_patents>=10 & sum_rd_available>=3 & sales_deflated_1>=0 & sales_deflated_1!=. & rd_available==1 & lnQ!=. & japan==0, fe i(firm_id_string) robust
xtreg lnQ RD_A RD_A_8993 RD_A_9499 RD_A_0004 lnY1 y_8993 y_9499 y_0004 semiconductors IThardware if sum_patents>=10 & sum_rd_available>=3 & sales_deflated_1>=0 & sales_deflated_1!=. & rd_available==1 & lnQ!=. & japan==1, fe i(firm_id_string) robust

nl (lnQ = ln(1+ ({a=0}) * RD_A + ({b=0}) * RD_A_8993 + ({c=0}) * RD_A_9499 + ({d=0}) * RD_A_0004) + ({e=0}) * y_8993 + ({f=0}) * y_9499 + ({g=0}) * y_0004 + ({h=0}) * lnY1 + ({i=0}) * electronics + ({j=0}) * semiconductors + ({k=0}) * IThardware) if sum_patents>=10 & sum_rd_available>=3 & sales_deflated_1>=0 & sales_deflated_1!=. & rd_available==1 & lnQ!=.
nl (lnQ = ln(1+ ({a=0}) * RD_A + ({b=0}) * RD_A_8993 + ({c=0}) * RD_A_9499 + ({d=0}) * RD_A_0004) + ({e=0}) * y_8993 + ({f=0}) * y_9499 + ({g=0}) * y_0004 + ({h=0}) * lnY1 + ({i=0}) * electronics + ({j=0}) * semiconductors + ({k=0}) * IThardware) if sum_patents>=10 & sum_rd_available>=3 & sales_deflated_1>=0 & sales_deflated_1!=. & rd_available==1 & lnQ!=. & japan==0
nl (lnQ = ln(1+ ({a=0}) * RD_A + ({b=0}) * RD_A_8993 + ({c=0}) * RD_A_9499 + ({d=0}) * RD_A_0004) + ({e=0}) * y_8993 + ({f=0}) * y_9499 + ({g=0}) * y_0004 + ({h=0}) * lnY1 + ({i=0}) * electronics + ({j=0}) * semiconductors + ({k=0}) * IThardware) if sum_patents>=10 & sum_rd_available>=3 & sales_deflated_1>=0 & sales_deflated_1!=. & rd_available==1 & lnQ!=. & japan==1


/* Table 5-A */

nl (lnQ = ln(1+ ({a=0}) * RD_A + ({b=0}) * RD_A_japan) + ({c=0}) * y_8993 + ({d=0}) * y_9499 + ({e=0}) * y_0004 + ({f=0}) * lnY1 + ({g=0}) * japan) if sum_patents>=10 & sum_rd_available>=3 & sales_deflated_1>=0 & sales_deflated_1!=. & rd_available==1 & lnQ!=.
nl (lnQ = ln(1+ ({a=0}) * RD_A + ({b=0}) * RD_A_japan) + ({f=0}) * lnY1 + ({g=0}) * japan) if sum_patents>=10 & sum_rd_available>=3 & sales_deflated_1>=0 & sales_deflated_1!=. & rd_available==1 & lnQ!=. & y_8388==1
nl (lnQ = ln(1+ ({a=0}) * RD_A + ({b=0}) * RD_A_japan) + ({f=0}) * lnY1 + ({g=0}) * japan) if sum_patents>=10 & sum_rd_available>=3 & sales_deflated_1>=0 & sales_deflated_1!=. & rd_available==1 & lnQ!=. & y_8993==1
nl (lnQ = ln(1+ ({a=0}) * RD_A + ({b=0}) * RD_A_japan) + ({f=0}) * lnY1 + ({g=0}) * japan) if sum_patents>=10 & sum_rd_available>=3 & sales_deflated_1>=0 & sales_deflated_1!=. & rd_available==1 & lnQ!=. & y_9499==1
nl (lnQ = ln(1+ ({a=0}) * RD_A + ({b=0}) * RD_A_japan) + ({f=0}) * lnY1 + ({g=0}) * japan) if sum_patents>=10 & sum_rd_available>=3 & sales_deflated_1>=0 & sales_deflated_1!=. & rd_available==1 & lnQ!=. & y_0004==1

/* Table 5-B */

nl (lnQ = ln(1+ ({a=0}) * RD_A + ({b=0}) * RD_A_japan + ({c=0}) * RD_A_sof_total) + ({d=0}) * y_8993 + ({e=0}) * y_9499 + ({f=0}) * y_0004 + ({g=0}) * lnY1 + ({h=0}) * japan) if sum_patents>=10 & sum_rd_available>=3 & sales_deflated_1>=0 & sales_deflated_1!=. & rd_available==1 & lnQ!=. & sofshare_total!=.
nl (lnQ = ln(1+ ({a=0}) * RD_A + ({b=0}) * RD_A_japan + ({c=0}) * RD_A_sof_total) + ({g=0}) * lnY1 + ({h=0}) * japan) if sum_patents>=10 & sum_rd_available>=3 & sales_deflated_1>=0 & sales_deflated_1!=. & rd_available==1 & lnQ!=. & y_8388==1 & sofshare_total!=.
nl (lnQ = ln(1+ ({a=0}) * RD_A + ({b=0}) * RD_A_japan + ({c=0}) * RD_A_sof_total) + ({g=0}) * lnY1 + ({h=0}) * japan) if sum_patents>=10 & sum_rd_available>=3 & sales_deflated_1>=0 & sales_deflated_1!=. & rd_available==1 & lnQ!=. & y_8993==1 & sofshare_total!=.
nl (lnQ = ln(1+ ({a=0}) * RD_A + ({b=0}) * RD_A_japan + ({c=0}) * RD_A_sof_total) + ({g=0}) * lnY1 + ({h=0}) * japan) if sum_patents>=10 & sum_rd_available>=3 & sales_deflated_1>=0 & sales_deflated_1!=. & rd_available==1 & lnQ!=. & y_9499==1 & sofshare_total!=.
nl (lnQ = ln(1+ ({a=0}) * RD_A + ({b=0}) * RD_A_japan + ({c=0}) * RD_A_sof_total) + ({g=0}) * lnY1 + ({h=0}) * japan) if sum_patents>=10 & sum_rd_available>=3 & sales_deflated_1>=0 & sales_deflated_1!=. & rd_available==1 & lnQ!=. & y_0004==1 & sofshare_total!=.

nl (lnQ = ln(1+ ({a=0}) * RD_A + ({b=0}) * RD_A_japan + ({c=0}) * RD_A_sof_total) + ({h=0}) * japan + ({j=0}) * sofshare_total + ({d=0}) * y_8993 + ({e=0}) * y_9499 + ({f=0}) * y_0004 + ({g=0}) * lnY1) if sum_patents>=10 & sum_rd_available>=3 & sales_deflated_1>=0 & sales_deflated_1!=. & rd_available==1 & lnQ!=. & sofshare_total!=.
nl (lnQ = ln(1+ ({a=0}) * RD_A + ({b=0}) * RD_A_japan + ({c=0}) * RD_A_sof_total) + ({h=0}) * japan + ({j=0}) * sofshare_total + ({g=0}) * lnY1) if sum_patents>=10 & sum_rd_available>=3 & sales_deflated_1>=0 & sales_deflated_1!=. & rd_available==1 & lnQ!=. & y_8388==1 & sofshare_total!=.
nl (lnQ = ln(1+ ({a=0}) * RD_A + ({b=0}) * RD_A_japan + ({c=0}) * RD_A_sof_total) + ({h=0}) * japan + ({j=0}) * sofshare_total + ({g=0}) * lnY1) if sum_patents>=10 & sum_rd_available>=3 & sales_deflated_1>=0 & sales_deflated_1!=. & rd_available==1 & lnQ!=. & y_8993==1 & sofshare_total!=.
nl (lnQ = ln(1+ ({a=0}) * RD_A + ({b=0}) * RD_A_japan + ({c=0}) * RD_A_sof_total) + ({h=0}) * japan + ({j=0}) * sofshare_total + ({g=0}) * lnY1) if sum_patents>=10 & sum_rd_available>=3 & sales_deflated_1>=0 & sales_deflated_1!=. & rd_available==1 & lnQ!=. & y_9499==1 & sofshare_total!=.
nl (lnQ = ln(1+ ({a=0}) * RD_A + ({b=0}) * RD_A_japan + ({c=0}) * RD_A_sof_total) + ({h=0}) * japan + ({j=0}) * sofshare_total + ({g=0}) * lnY1) if sum_patents>=10 & sum_rd_available>=3 & sales_deflated_1>=0 & sales_deflated_1!=. & rd_available==1 & lnQ!=. & y_0004==1 & sofshare_total!=.

/* Table V-B Robustness Check - Fixed Effects Estimation */

xtreg lnQ RD_A RD_A_japan RD_A_sof_total sofshare_total japan lnY1 y_8993 y_9499 y_0004 if sum_patents>=10 & sum_rd_available>=3 & sales_deflated_1>=0 & sales_deflated_1!=. & rd_available==1 & lnQ!=., fe i(firm_id_string) robust
xtreg lnQ RD_A RD_A_japan RD_A_sof_total sofshare_total japan lnY1 if sum_patents>=10 & sum_rd_available>=3 & sales_deflated_1>=0 & sales_deflated_1!=. & rd_available==1 & lnQ!=. & y_8388==1, fe i(firm_id_string) robust
xtreg lnQ RD_A RD_A_japan RD_A_sof_total sofshare_total japan lnY1 if sum_patents>=10 & sum_rd_available>=3 & sales_deflated_1>=0 & sales_deflated_1!=. & rd_available==1 & lnQ!=. & y_8993==1, fe i(firm_id_string) robust
xtreg lnQ RD_A RD_A_japan RD_A_sof_total sofshare_total japan lnY1 if sum_patents>=10 & sum_rd_available>=3 & sales_deflated_1>=0 & sales_deflated_1!=. & rd_available==1 & lnQ!=. & y_9499==1, fe i(firm_id_string) robust
xtreg lnQ RD_A RD_A_japan RD_A_sof_total sofshare_total japan lnY1 if sum_patents>=10 & sum_rd_available>=3 & sales_deflated_1>=0 & sales_deflated_1!=. & rd_available==1 & lnQ!=. & y_0004==1, fe i(firm_id_string) robust


/* Tables 6 and 7 */

gen y_8393=0
replace y_8393=1 if year==1983
replace y_8393=1 if year==1984
replace y_8393=1 if year==1985
replace y_8393=1 if year==1986
replace y_8393=1 if year==1987
replace y_8393=1 if year==1988
replace y_8393=1 if year==1989
replace y_8393=1 if year==1990
replace y_8393=1 if year==1991
replace y_8393=1 if year==1992
replace y_8393=1 if year==1993
gen y_9404=0
replace y_9404=1 if year==1994
replace y_9404=1 if year==1995
replace y_9404=1 if year==1996
replace y_9404=1 if year==1997
replace y_9404=1 if year==1998
replace y_9404=1 if year==1999
replace y_9404=1 if year==2000
replace y_9404=1 if year==2001
replace y_9404=1 if year==2002
replace y_9404=1 if year==2003
replace y_9404=1 if year==2004

gen RD_A_9404=RD_A*y_9404


/* electronics */ 

xtreg lnQ RD_A RD_A_japan japan lnY1 if sum_patents>=10 & sum_rd_available>=3 & sales_deflated_1>=0 & sales_deflated_1!=. & rd_available==1 & lnQ!=. & y_8393==1 & electronics==1, fe i(firm_id_string) robust
xtreg lnQ RD_A RD_A_japan japan lnY1 if sum_patents>=10 & sum_rd_available>=3 & sales_deflated_1>=0 & sales_deflated_1!=. & rd_available==1 & lnQ!=. & y_9404==1 & electronics==1, fe i(firm_id_string) robust

nl (lnQ = ln(1+ ({a=0}) * RD_A + ({b=0}) * RD_A_japan) + ({c=0}) * lnY1 + ({d=0}) * japan) if sum_patents>=10 & sum_rd_available>=3 & sales_deflated_1>=0 & sales_deflated_1!=. & rd_available==1 & lnQ!=. & electronics==1 & y_8393==1
nl (lnQ = ln(1+ ({a=0}) * RD_A + ({b=0}) * RD_A_japan) + ({c=0}) * lnY1 + ({d=0}) * japan) if sum_patents>=10 & sum_rd_available>=3 & sales_deflated_1>=0 & sales_deflated_1!=. & rd_available==1 & lnQ!=. & electronics==1 & y_9404==1

/* semiconductors */ 

xtreg lnQ RD_A RD_A_japan lnY1 if sum_patents>=10 & sum_rd_available>=3 & sales_deflated_1>=0 & sales_deflated_1!=. & rd_available==1 & lnQ!=. & y_8393==1 & semiconductors==1, fe i(firm_id_string) robust
xtreg lnQ RD_A RD_A_japan lnY1 if sum_patents>=10 & sum_rd_available>=3 & sales_deflated_1>=0 & sales_deflated_1!=. & rd_available==1 & lnQ!=. & y_9404==1 & semiconductors==1, fe i(firm_id_string) robust

nl (lnQ = ln(1+ ({a=0}) * RD_A + ({b=0}) * RD_A_japan) + ({c=0}) * lnY1 + ({d=0}) * japan) if sum_patents>=10 & sum_rd_available>=3 & sales_deflated_1>=0 & sales_deflated_1!=. & rd_available==1 & lnQ!=. & semiconductors==1 & y_8393==1
nl (lnQ = ln(1+ ({a=0}) * RD_A + ({b=0}) * RD_A_japan) + ({c=0}) * lnY1 + ({d=0}) * japan) if sum_patents>=10 & sum_rd_available>=3 & sales_deflated_1>=0 & sales_deflated_1!=. & rd_available==1 & lnQ!=. & semiconductors==1 & y_9404==1

/* IThardware */

xtreg lnQ RD_A RD_A_japan lnY1 if sum_patents>=10 & sum_rd_available>=3 & sales_deflated_1>=0 & sales_deflated_1!=. & rd_available==1 & lnQ!=. & y_8393==1 & IThardware==1, fe i(firm_id_string) robust
xtreg lnQ RD_A RD_A_japan lnY1 if sum_patents>=10 & sum_rd_available>=3 & sales_deflated_1>=0 & sales_deflated_1!=. & rd_available==1 & lnQ!=. & y_9404==1 & IThardware==1, fe i(firm_id_string) robust

nl (lnQ = ln(1+ ({a=0}) * RD_A + ({b=0}) * RD_A_japan) + ({c=0}) * lnY1 + ({d=0}) * japan) if sum_patents>=10 & sum_rd_available>=3 & sales_deflated_1>=0 & sales_deflated_1!=. & rd_available==1 & lnQ!=. & IThardware==1 & y_8393==1
nl (lnQ = ln(1+ ({a=0}) * RD_A + ({b=0}) * RD_A_japan) + ({c=0}) * lnY1 + ({d=0}) * japan) if sum_patents>=10 & sum_rd_available>=3 & sales_deflated_1>=0 & sales_deflated_1!=. & rd_available==1 & lnQ!=. & IThardware==1 & y_9404==1

log off
log close