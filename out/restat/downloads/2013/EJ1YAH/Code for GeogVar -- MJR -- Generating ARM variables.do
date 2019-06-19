********************************
********************************
*** Generating ARM variables ***
********************************
********************************



*** NOTE:  Due to computer memory limits, the downloaded LoanPerformance data was split into 80 files based on MSA, ***
***        investment grade (subprime versus alt-A) and loan category (purchase FRM, refinance FRM, purchase ARM,   ***
***        and refinance ARM).  This do-file was run separately for each of the 40 ARM-related MSA data files.  The ***
***        house price index and unemployment rate data was also split into 10 files by MSA to correspond to the    ***
***        MSA-level treatment of the loan data.  Once the necessary variables were generated and the raw data that ***
***        were no longer needed were deleted, the data files for each loan category were reassembled.              ***



*** MSA:       "Pittsburgh\pittsburgh" ***
*** Category:  refinance_arm ***



*** Sort the MSA's hpi unempl interests data file ***
*****************************************************

use "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Data\MSA Level\Pittsburgh\pittsburgh hpi unempl interests.dta", clear
sort currmonth
save "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Data\MSA Level\Pittsburgh\pittsburgh hpi unempl interests.dta", replace



*** Open the MSA data file ***
******************************

use "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Data\MSA Level\Pittsburgh\pittsburgh_subp_refi_arm.dta", clear



*** Generate variables equalling the first and last dates in the loan-month ***
*******************************************************************************

generate monthstart = mdy(month,1,year)
generate monthend = .
replace monthend = mdy(month+1,1,year)-1 if month != 12
replace monthend = mdy(12,31,year) if month == 12



*** Drop pre-origination observations ***
*****************************************

drop if orig_date > monthend



*** Generate time variables     ***
*** -- January 2002 is month #1 ***
***********************************

generate currmonth = .
replace currmonth = 1 if monthstart == mdy(1,1,2002)
replace currmonth = 2 if monthstart == mdy(2,1,2002)
replace currmonth = 3 if monthstart == mdy(3,1,2002)
replace currmonth = 4 if monthstart == mdy(4,1,2002)
replace currmonth = 5 if monthstart == mdy(5,1,2002)
replace currmonth = 6 if monthstart == mdy(6,1,2002)
replace currmonth = 7 if monthstart == mdy(7,1,2002)
replace currmonth = 8 if monthstart == mdy(8,1,2002)
replace currmonth = 9 if monthstart == mdy(9,1,2002)
replace currmonth = 10 if monthstart == mdy(10,1,2002)
replace currmonth = 11 if monthstart == mdy(11,1,2002)
replace currmonth = 12 if monthstart == mdy(12,1,2002)
replace currmonth = 13 if monthstart == mdy(1,1,2003)
replace currmonth = 14 if monthstart == mdy(2,1,2003)
replace currmonth = 15 if monthstart == mdy(3,1,2003)
replace currmonth = 16 if monthstart == mdy(4,1,2003)
replace currmonth = 17 if monthstart == mdy(5,1,2003)
replace currmonth = 18 if monthstart == mdy(6,1,2003)
replace currmonth = 19 if monthstart == mdy(7,1,2003)
replace currmonth = 20 if monthstart == mdy(8,1,2003)
replace currmonth = 21 if monthstart == mdy(9,1,2003)
replace currmonth = 22 if monthstart == mdy(10,1,2003)
replace currmonth = 23 if monthstart == mdy(11,1,2003)
replace currmonth = 24 if monthstart == mdy(12,1,2003)
replace currmonth = 25 if monthstart == mdy(1,1,2004)
replace currmonth = 26 if monthstart == mdy(2,1,2004)
replace currmonth = 27 if monthstart == mdy(3,1,2004)
replace currmonth = 28 if monthstart == mdy(4,1,2004)
replace currmonth = 29 if monthstart == mdy(5,1,2004)
replace currmonth = 30 if monthstart == mdy(6,1,2004)
replace currmonth = 31 if monthstart == mdy(7,1,2004)
replace currmonth = 32 if monthstart == mdy(8,1,2004)
replace currmonth = 33 if monthstart == mdy(9,1,2004)
replace currmonth = 34 if monthstart == mdy(10,1,2004)
replace currmonth = 35 if monthstart == mdy(11,1,2004)
replace currmonth = 36 if monthstart == mdy(12,1,2004)
replace currmonth = 37 if monthstart == mdy(1,1,2005)
replace currmonth = 38 if monthstart == mdy(2,1,2005)
replace currmonth = 39 if monthstart == mdy(3,1,2005)
replace currmonth = 40 if monthstart == mdy(4,1,2005)
replace currmonth = 41 if monthstart == mdy(5,1,2005)
replace currmonth = 42 if monthstart == mdy(6,1,2005)
replace currmonth = 43 if monthstart == mdy(7,1,2005)
replace currmonth = 44 if monthstart == mdy(8,1,2005)
replace currmonth = 45 if monthstart == mdy(9,1,2005)
replace currmonth = 46 if monthstart == mdy(10,1,2005)
replace currmonth = 47 if monthstart == mdy(11,1,2005)
replace currmonth = 48 if monthstart == mdy(12,1,2005)
replace currmonth = 49 if monthstart == mdy(1,1,2006)
replace currmonth = 50 if monthstart == mdy(2,1,2006)
replace currmonth = 51 if monthstart == mdy(3,1,2006)
replace currmonth = 52 if monthstart == mdy(4,1,2006)
replace currmonth = 53 if monthstart == mdy(5,1,2006)
replace currmonth = 54 if monthstart == mdy(6,1,2006)
replace currmonth = 55 if monthstart == mdy(7,1,2006)
replace currmonth = 56 if monthstart == mdy(8,1,2006)
replace currmonth = 57 if monthstart == mdy(9,1,2006)
replace currmonth = 58 if monthstart == mdy(10,1,2006)
replace currmonth = 59 if monthstart == mdy(11,1,2006)
replace currmonth = 60 if monthstart == mdy(12,1,2006)
replace currmonth = 61 if monthstart == mdy(1,1,2007)
replace currmonth = 62 if monthstart == mdy(2,1,2007)
replace currmonth = 63 if monthstart == mdy(3,1,2007)
replace currmonth = 64 if monthstart == mdy(4,1,2007)
replace currmonth = 65 if monthstart == mdy(5,1,2007)
replace currmonth = 66 if monthstart == mdy(6,1,2007)
replace currmonth = 67 if monthstart == mdy(7,1,2007)
replace currmonth = 68 if monthstart == mdy(8,1,2007)
replace currmonth = 69 if monthstart == mdy(9,1,2007)
replace currmonth = 70 if monthstart == mdy(10,1,2007)
replace currmonth = 71 if monthstart == mdy(11,1,2007)
replace currmonth = 72 if monthstart == mdy(12,1,2007)
replace currmonth = 73 if monthstart == mdy(1,1,2008)
replace currmonth = 74 if monthstart == mdy(2,1,2008)
replace currmonth = 75 if monthstart == mdy(3,1,2008)
replace currmonth = 76 if monthstart == mdy(4,1,2008)
replace currmonth = 77 if monthstart == mdy(5,1,2008)
replace currmonth = 78 if monthstart == mdy(6,1,2008)
replace currmonth = 79 if monthstart == mdy(7,1,2008)
replace currmonth = 80 if monthstart == mdy(8,1,2008)
replace currmonth = 81 if monthstart == mdy(9,1,2008)
replace currmonth = 82 if monthstart == mdy(10,1,2008)
replace currmonth = 83 if monthstart == mdy(11,1,2008)
replace currmonth = 84 if monthstart == mdy(12,1,2008)

generate origmonth = .
replace origmonth = 1 if orig_date >= mdy(1,1,2002) & orig_date < mdy(2,1,2002)
replace origmonth = 2 if orig_date >= mdy(2,1,2002) & orig_date < mdy(3,1,2002)
replace origmonth = 3 if orig_date >= mdy(3,1,2002) & orig_date < mdy(4,1,2002)
replace origmonth = 4 if orig_date >= mdy(4,1,2002) & orig_date < mdy(5,1,2002)
replace origmonth = 5 if orig_date >= mdy(5,1,2002) & orig_date < mdy(6,1,2002)
replace origmonth = 6 if orig_date >= mdy(6,1,2002) & orig_date < mdy(7,1,2002)
replace origmonth = 7 if orig_date >= mdy(7,1,2002) & orig_date < mdy(8,1,2002)
replace origmonth = 8 if orig_date >= mdy(8,1,2002) & orig_date < mdy(9,1,2002)
replace origmonth = 9 if orig_date >= mdy(9,1,2002) & orig_date < mdy(10,1,2002)
replace origmonth = 10 if orig_date >= mdy(10,1,2002) & orig_date < mdy(11,1,2002)
replace origmonth = 11 if orig_date >= mdy(11,1,2002) & orig_date < mdy(12,1,2002)
replace origmonth = 12 if orig_date >= mdy(12,1,2002) & orig_date < mdy(1,1,2003)
replace origmonth = 13 if orig_date >= mdy(1,1,2003) & orig_date < mdy(2,1,2003)
replace origmonth = 14 if orig_date >= mdy(2,1,2003) & orig_date < mdy(3,1,2003)
replace origmonth = 15 if orig_date >= mdy(3,1,2003) & orig_date < mdy(4,1,2003)
replace origmonth = 16 if orig_date >= mdy(4,1,2003) & orig_date < mdy(5,1,2003)
replace origmonth = 17 if orig_date >= mdy(5,1,2003) & orig_date < mdy(6,1,2003)
replace origmonth = 18 if orig_date >= mdy(6,1,2003) & orig_date < mdy(7,1,2003)
replace origmonth = 19 if orig_date >= mdy(7,1,2003) & orig_date < mdy(8,1,2003)
replace origmonth = 20 if orig_date >= mdy(8,1,2003) & orig_date < mdy(9,1,2003)
replace origmonth = 21 if orig_date >= mdy(9,1,2003) & orig_date < mdy(10,1,2003)
replace origmonth = 22 if orig_date >= mdy(10,1,2003) & orig_date < mdy(11,1,2003)
replace origmonth = 23 if orig_date >= mdy(11,1,2003) & orig_date < mdy(12,1,2003)
replace origmonth = 24 if orig_date >= mdy(12,1,2003) & orig_date < mdy(1,1,2004)
replace origmonth = 25 if orig_date >= mdy(1,1,2004) & orig_date < mdy(2,1,2004)
replace origmonth = 26 if orig_date >= mdy(2,1,2004) & orig_date < mdy(3,1,2004)
replace origmonth = 27 if orig_date >= mdy(3,1,2004) & orig_date < mdy(4,1,2004)
replace origmonth = 28 if orig_date >= mdy(4,1,2004) & orig_date < mdy(5,1,2004)
replace origmonth = 29 if orig_date >= mdy(5,1,2004) & orig_date < mdy(6,1,2004)
replace origmonth = 30 if orig_date >= mdy(6,1,2004) & orig_date < mdy(7,1,2004)
replace origmonth = 31 if orig_date >= mdy(7,1,2004) & orig_date < mdy(8,1,2004)
replace origmonth = 32 if orig_date >= mdy(8,1,2004) & orig_date < mdy(9,1,2004)
replace origmonth = 33 if orig_date >= mdy(9,1,2004) & orig_date < mdy(10,1,2004)
replace origmonth = 34 if orig_date >= mdy(10,1,2004) & orig_date < mdy(11,1,2004)
replace origmonth = 35 if orig_date >= mdy(11,1,2004) & orig_date < mdy(12,1,2004)
replace origmonth = 36 if orig_date >= mdy(12,1,2004) & orig_date < mdy(1,1,2005)
replace origmonth = 37 if orig_date >= mdy(1,1,2005) & orig_date < mdy(2,1,2005)
replace origmonth = 38 if orig_date >= mdy(2,1,2005) & orig_date < mdy(3,1,2005)
replace origmonth = 39 if orig_date >= mdy(3,1,2005) & orig_date < mdy(4,1,2005)
replace origmonth = 40 if orig_date >= mdy(4,1,2005) & orig_date < mdy(5,1,2005)
replace origmonth = 41 if orig_date >= mdy(5,1,2005) & orig_date < mdy(6,1,2005)
replace origmonth = 42 if orig_date >= mdy(6,1,2005) & orig_date < mdy(7,1,2005)
replace origmonth = 43 if orig_date >= mdy(7,1,2005) & orig_date < mdy(8,1,2005)
replace origmonth = 44 if orig_date >= mdy(8,1,2005) & orig_date < mdy(9,1,2005)
replace origmonth = 45 if orig_date >= mdy(9,1,2005) & orig_date < mdy(10,1,2005)
replace origmonth = 46 if orig_date >= mdy(10,1,2005) & orig_date < mdy(11,1,2005)
replace origmonth = 47 if orig_date >= mdy(11,1,2005) & orig_date < mdy(12,1,2005)
replace origmonth = 48 if orig_date >= mdy(12,1,2005) & orig_date < mdy(1,1,2006)
replace origmonth = 49 if orig_date >= mdy(1,1,2006) & orig_date < mdy(2,1,2006)
replace origmonth = 50 if orig_date >= mdy(2,1,2006) & orig_date < mdy(3,1,2006)
replace origmonth = 51 if orig_date >= mdy(3,1,2006) & orig_date < mdy(4,1,2006)
replace origmonth = 52 if orig_date >= mdy(4,1,2006) & orig_date < mdy(5,1,2006)
replace origmonth = 53 if orig_date >= mdy(5,1,2006) & orig_date < mdy(6,1,2006)
replace origmonth = 54 if orig_date >= mdy(6,1,2006) & orig_date < mdy(7,1,2006)
replace origmonth = 55 if orig_date >= mdy(7,1,2006) & orig_date < mdy(8,1,2006)
replace origmonth = 56 if orig_date >= mdy(8,1,2006) & orig_date < mdy(9,1,2006)
replace origmonth = 57 if orig_date >= mdy(9,1,2006) & orig_date < mdy(10,1,2006)
replace origmonth = 58 if orig_date >= mdy(10,1,2006) & orig_date < mdy(11,1,2006)
replace origmonth = 59 if orig_date >= mdy(11,1,2006) & orig_date < mdy(12,1,2006)
replace origmonth = 60 if orig_date >= mdy(12,1,2006) & orig_date < mdy(1,1,2007)

generate ageofloan = currmonth - origmonth
drop if ageofloan == 0
generate ageofloan_2 = ageofloan^2





*****************************************
*** Generate ARM adjustment variables ***
*****************************************

bysort loan_id_num (currmonth): generate new_sch_mnth_p = sch_mnth_p[_n+1]

bysort loan_id_num (currmonth): replace new_sch_mnth_p = sch_mnth_p[_n+2] if sch_mnth_p != sch_mnth_p[_n+1] & sch_mnth_p[_n+1] != sch_mnth_p[_n+2] & sch_mnth_p[_n+2] != .
   /* smooths over instances in which payment changes in two loan-months in a row                      */
   /* two scenarios:                                                                                   */
   /* -- one-loan-month blips in payments that are likely mistakes                                     */
   /* -- adjustment periods in which the payment adjusts then adjusts again the next month as well     */
   /*    -- in most cases, the initial new payment appears to be a mistake (e.g., payment of under $1) */

generate temp_payment_adj = (new_sch_mnth_p - sch_mnth_p)/sch_mnth_p
   /* last observation for each loan will have temp_payment_adj == . */

bysort loan_id_num (currmonth): replace temp_payment_adj = 0 if sch_mnth_p[_n-1] != sch_mnth_p & sch_mnth_p != sch_mnth_p[_n+1] & sch_mnth_p[_n+1] != .
   /* completes the smoothing that was begun above two steps above                                       */
   /* -- could have been corrected above, but I don't want to change the original sch_mnth_p data values */

replace temp_payment_adj = 0 if (new_sch_mnth_p - sch_mnth_p) >= -1 & (new_sch_mnth_p - sch_mnth_p) <= 1
   /* payment changes of less than $1 are not considered changes */

generate payment_adj = .



*** Assign the value zero to payment_adj for the first observation of each loan                                               ***
*** -- due to the dropping of late-entering loans above, payment_adj can be fairly assumed to equal 0 for the remaining loans ***
*** -- note that some loans, generally those that go into serious delinquency, foreclosure, or REO, do have payments          ***
***    adjusted prior to the scheduled first rate reset.  If this occurred for a loan prior to it entering the data set, then ***
***    setting payment_adj = 0 will be inaccurate.                                                                            ***
*** -- based on Atlanta's purchase ARMs, for only 1% of pre-first-rate-reset observations with payment_adj = 0 (meaning there ***
***    is no prior change in sch_mnth_p in the sample data) does init_rate != int_rate, indicating a prior change in payment. ***
***    One might be able to back into an initial payment amount, but even this would be of no use if the payment changed      ***
***    twice prior to entering the data set (and there is no way to know if this is the case.)                                ***
*********************************************************************************************************************************

bysort loan_id_num (currmonth): replace payment_adj = 0 if currmonth == currmonth[1] 



*** Assign payment_adj values for observations between the first and last for each loan ***
*** -- there is almost certainly a more elegant way to do this, but it eludes me        ***
*******************************************************************************************

bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 1
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 1
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 2
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 2
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 3
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 3
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 4
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 4
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 5
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 5
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 6
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 6
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 7
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 7
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 8
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 8
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 9
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 9
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 10
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 10
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 11
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 11
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 12
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 12
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 13
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 13
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 14
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 14
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 15
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 15
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 16
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 16
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 17
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 17
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 18
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 18
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 19
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 19
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 20
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 20
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 21
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 21
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 22
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 22
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 23
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 23
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 24
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 24
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 25
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 25
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 26
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 26
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 27
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 27
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 28
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 28
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 29
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 29
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 30
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 30
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 31
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 31
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 32
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 32
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 33
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 33
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 34
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 34
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 35
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 35
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 36
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 36
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 37
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 37
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 38
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 38
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 39
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 39
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 40
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 40
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 41
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 41
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 42
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 42
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 43
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 43
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 44
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 44
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 45
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 45
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 46
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 46
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 47
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 47
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 48
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 48
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 49
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 49
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 50
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 50
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 51
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 51
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 52
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 52
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 53
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 53
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 54
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 54
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 55
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 55
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 56
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 56
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 57
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 57
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 58
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 58
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 59
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 59
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 60
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 60
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 61
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 61
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 62
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 62
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 63
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 63
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 64
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 64
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 65
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 65
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 66
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 66
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 67
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 67
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 68
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 68
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 69
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 69
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 70
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 70
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 71
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 71
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 72
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 72
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 73
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 73
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 74
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 74
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 75
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 75
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 76
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 76
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 77
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 77
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 78
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 78
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 79
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 79
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 80
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 80
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 81
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 81
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 82
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 82
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 83
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 83
bysort loan_id_num (currmonth): replace payment_adj = temp_payment_adj if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj != 0 & currmonth == 84
bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth != currmonth[1] & currmonth != currmonth[_N] & temp_payment_adj == 0 & currmonth == 84



*** Assign payment_adj value of next-to-last observation to last observation for each loan ***
*** -- observations subsequent to a payoff will be dropped below, so in most cases a       ***
***    loan's current final observation will be dropped.  For such loans, how the current  ***
***    final observation is handled is irrelevant.                                         ***
*** -- based on Atlanta's purchase ARMs, after dropping observations subsequent to a       ***
***    payoff, 31% of loans still have a final observation for which payment_adj is        ***
***    assigned here.                                                                      ***
*** -- of these, the only loans for which the approach here is relevant are those for      ***
***    which in the loan-month in which they exit the sample, (a) mba_stat != "0", and (b) ***
***    there is an change in payment (which is unobserved due to the way payment changes   ***
***    are identified).                                                                    ***
*** -- in these cases, in the final observed loan-month the loan remains active and the    ***
***    observed value of payment_adj does not change, but in reality it does change.  This ***
***    presumably will bias the results for payment_adj away from zero.                    ***
***    -- i.e., some loan-months in which variation in payment_adj should be associated    ***
***       with no change in loan status are not considered accurately                      ***
**********************************************************************************************

bysort loan_id_num (currmonth): replace payment_adj = payment_adj[_n-1] if currmonth == currmonth[_N]



generate payment_adj2 = payment_adj
replace payment_adj2 = 0 if payment_adj < 0
replace payment_adj2 = 0 if ageofloan < 24 & first_rate == 24
replace payment_adj2 = 0 if ageofloan < 36 & first_rate == 36
/*
payment_adj2 matches the definition used by Pennington-Cross and Ho (2006)
*/



generate adj_1st = 0
replace adj_1st = 1 if first_rate == 24 & (ageofloan >= 24 & ageofloan <= 26)
replace adj_1st = 1 if first_rate == 36 & (ageofloan >= 36 & ageofloan <= 38)

generate post_adj_1st = 0
replace post_adj_1st = 1 if first_rate == 24 & ageofloan >= 27
replace post_adj_1st = 1 if first_rate == 36 & ageofloan >= 39






**********************************
*** Generate OUTCOME variables ***
**********************************



bysort loan_id_num (currmonth): generate mba_stat_lead1 = mba_stat[_n+1]



*** Remove loans that are neither current nor delinquent when they enter the sample ***
*** -- I examined several of these loans, and there is not enough information to    ***
***    construct some or all of the three outcome measures for each one             ***
***************************************************************************************

bysort loan_id_num (currmonth): generate mba_stat_1st = mba_stat[1]
drop if mba_stat_1st == "0" | mba_stat_1st == "F" | mba_stat_1st == "R"



*** Remove loans which become re-active after appearing as prepaid ***
*** -- In the entire sample, there were 278 observations for which ***
***    went from pre-paid to not pre-paid                          ***
**********************************************************************

generate extra_payoff = 2
replace extra_payoff = 1 if mba_stat == "0" & mba_stat_lead1 != "0" & mba_stat_lead1 != ""
bysort loan_id_num: egen remove = min(extra_payoff)
drop if remove == 1
drop extra_payoff remove



*** Remove observations trailing after a loan is prepaid ***
************************************************************

drop if mba_stat == "0" & mba_stat_lead1 == "0"



*** Generate OUTCOME_A ***
**************************
/* OUTCOME_A codes:
	0 = loan is active
	1 = first foreclosure start or property first becomes REO
	2 = loan is prepaid
*/

bysort loan_id_num (currmonth): egen fc_start_1st = min(fc_start_d)
bysort loan_id_num (currmonth): egen reo_1st = min(reo_date)
bysort loan_id_num (currmonth): egen payoff_1st = min(payoff_d)

bysort loan_id_num (currmonth): generate fc_start_lead1 = fc_start_d[_n+1]
bysort loan_id_num (currmonth): generate reo_lead1 = reo_date[_n+1]
bysort loan_id_num (currmonth): generate payoff_lead1 = payoff_d[_n+1]

generate outcome_a = 0
replace outcome_a = 1 if (fc_start_1st <= payoff_1st & fc_start_lead1 != .) | (reo_1st <= payoff_1st & reo_lead1 != .)
replace outcome_a = 2 if payoff_1st < fc_start_1st & payoff_1st < reo_1st & payoff_lead1 != .

generate outsample_a = 0
replace outsample_a = 1 if outcome_a == 1 & (monthstart > fc_start_1st | monthstart > reo_1st)
replace outsample_a = 1 if outcome_a == 2 & monthstart > payoff_1st

label define outcome_a_lbl 0 "Active_A" 1 "Default_A" 2 "Payoff_A"
label values outcome_a outcome_a_lbl
drop fc_start_1st reo_1st payoff_1st fc_start_lead1 reo_lead1 payoff_lead1



*** Generate OUTCOME_B ***
**************************
/* OUTCOME_B codes:
	0 = loan is active
	1 = start of a foreclosure or REO that gets completed (i.e., leads to mba_stat = "0")
	2 = loan is prepaid
   Note:  if a loan goes from "F" to "R" to "0" with no intervening period of the loan being
          current or delinquent, then the foreclosure start date is used as the default date
*/

generate badswitch = 0
replace badswitch = currmonth if mba_stat == "C" & mba_stat_lead1 == "F"
replace badswitch = currmonth if mba_stat == "3" & mba_stat_lead1 == "F"
replace badswitch = currmonth if mba_stat == "6" & mba_stat_lead1 == "F"
replace badswitch = currmonth if mba_stat == "9" & mba_stat_lead1 == "F"
replace badswitch = currmonth if mba_stat == "C" & mba_stat_lead1 == "R"
replace badswitch = currmonth if mba_stat == "3" & mba_stat_lead1 == "R"
replace badswitch = currmonth if mba_stat == "6" & mba_stat_lead1 == "R"
replace badswitch = currmonth if mba_stat == "9" & mba_stat_lead1 == "R"
   /* badswitch indicates loan-months in which a loan goes from current/delinquent to foreclosure/REO */

generate goodswitch = 0
replace goodswitch = currmonth if mba_stat == "F" & mba_stat_lead1 == "C"
replace goodswitch = currmonth if mba_stat == "F" & mba_stat_lead1 == "3"
replace goodswitch = currmonth if mba_stat == "F" & mba_stat_lead1 == "6"
replace goodswitch = currmonth if mba_stat == "F" & mba_stat_lead1 == "9"
replace goodswitch = currmonth if mba_stat == "R" & mba_stat_lead1 == "C"
replace goodswitch = currmonth if mba_stat == "R" & mba_stat_lead1 == "3"
replace goodswitch = currmonth if mba_stat == "R" & mba_stat_lead1 == "6"
replace goodswitch = currmonth if mba_stat == "R" & mba_stat_lead1 == "9"
   /* goodswitch indicates loan-months in which a loan goes from foreclosure/REO to current/delinquent */

bysort loan_id_num: egen lastbadswitch = max(badswitch)
bysort loan_id_num: egen lastgoodswitch = max(goodswitch)
bysort loan_id_num (currmonth): generate end_mba_stat = mba_stat[_N]
   /* end_mba_stat is needed to account for loans in "F" or "R" at the end of the sample
      -- no foreclosure or REO is completed within the sample, so the loan should be considered active
   */
generate ends_badly = 0
replace ends_badly = 1 if lastbadswitch > lastgoodswitch & end_mba_stat == "0"

generate outcome_b = 0
replace outcome_b = 1 if ends_badly == 1 & currmonth >= lastbadswitch
replace outcome_b = 2 if ends_badly == 0 & mba_stat_lead1 == "0"

generate outsample_b = 0
replace outsample_b = 1 if ends_badly == 1 & currmonth > lastbadswitch

label define outcome_b_lbl 0 "Active_B" 1 "Default_B" 2 "Payoff_B"
label values outcome_b outcome_b_lbl
drop badswitch goodswitch lastbadswitch lastgoodswitch end_mba_stat ends_badly



*** Generate OUTCOME_C ***
**************************
/* OUTCOME_C codes:
	0 = loan is active
	1 = completion of a foreclosure or REO
	2 = loan is prepaid
*/

generate outcome_c = 0
replace outcome_c = 1 if mba_stat_lead1 == "0" & (mba_stat == "F" | mba_stat == "R")
replace outcome_c = 2 if mba_stat_lead1 == "0" & (mba_stat != "F" & mba_stat != "R")

/* Note that because observations with mba_stat = mba_stat_lead1 = "0" were already 
   dropped above, there are no outsample observations under this default definition  */

label define outcome_c_lbl 0 "Active_C" 1 "Default_C" 2 "Payoff_C"
label values outcome_c outcome_c_lbl



drop if mba_stat_lead1 == ""




*** Generate PLP variables ***
******************************
/* Note that due to the dearth of balloon ARMs before 2005, balloon ARMs were already
   dropped from the main data files and balloon will not be used in ARM models        */

generate prepay_pen = 0
replace prepay_pen = . if pp_pen != 0 & (pp_term == 0 | pp_term == .)
replace prepay_pen = 1 if pp_term > 0 & pp_term != . & ageofloan < pp_term

generate prepay_pen_end = 0
replace prepay_pen_end = . if prepay_pen == .
replace prepay_pen_end = 1 if pp_term > 0 & pp_term != . & ageofloan >= pp_term & ageofloan <= (pp_term+2)
   /* equals 1 in the month the penalty period ends and for the following two months */

generate lownodoc = .
replace lownodoc = 1 if document == 2 | document == 3
replace lownodoc = 0 if document == 1






sort currmonth
save "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Data\MSA Level\Pittsburgh\pittsburgh_subp_refi_arm generated.dta", replace



*** Merge the MSA's "hpi unempl interests" data file and generate related variables ***
***************************************************************************************

merge currmonth using "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Data\MSA Level\Pittsburgh\pittsburgh hpi unempl interests.dta", keep(curr_hpi var_hpi curr_unempl spread var_6molibor)
summ _merge, detail
drop _merge
sort origmonth
save "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Data\MSA Level\Pittsburgh\pittsburgh_subp_refi_arm generated.dta", replace

use "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Data\MSA Level\Pittsburgh\pittsburgh hpi unempl interests.dta", clear
sort origmonth
save "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Data\MSA Level\Pittsburgh\pittsburgh hpi unempl interests.dta", replace

use "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Data\MSA Level\Pittsburgh\pittsburgh_subp_refi_arm generated.dta", clear
merge origmonth using "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Data\MSA Level\Pittsburgh\pittsburgh hpi unempl interests.dta", keep(orig_hpi orig_unempl)
summ _merge, detail
drop _merge

generate chg_unempl = curr_unempl - orig_unempl

generate hpa = (curr_hpi - orig_hpi)/orig_hpi
generate cltv = (balance*ltv)/(orig_amt*(1+hpa))

generate orig_risk_prem = init_rate - curr1yrarm



*** Generate remaining variables ***
************************************

bysort loan_id_num (currmonth): generate loan_size = orig_amt if currmonth == currmonth[_N]
generate orig_year = .
replace orig_year = 2002 if vint2002 == 1
replace orig_year = 2003 if vint2003 == 1
replace orig_year = 2004 if vint2004 == 1
replace orig_year = 2005 if vint2005 == 1
replace orig_year = 2006 if vint2006 == 1
bysort orig_year: egen loansbyyear = count(loan_size)
bysort orig_year: egen totalbyyear = sum(loan_size)
generate avg_loan_size = totalbyyear/loansbyyear
generate rel_loan_size = orig_amt / avg_loan_size
drop loan_size orig_year loansbyyear totalbyyear avg_loan_size

generate judicial = .
replace judicial = 0 if state == "GA" | state == "CA" | state == "MN" | state == "AZ" | state == "TX"
replace judicial = 1 if state == "MD" | state == "IL" | state == "FL" | state == "WI" | state == "NY" | state == "NJ" | state == "PA"



*** Re-generate loan_id_num                                                      ***
*** -- some loans were dropped since loan_id_num was originally generated        ***
*** -- need to re-generate loan_id_num for it to provide the new number of loans ***
************************************************************************************

drop loan_id_num
egen loan_id_num = group(loan_id)



*** Drop variables no longer needed and compress number formats ***
*******************************************************************

drop year month app_value document index_id ltv occupancy orig_amt orig_date prop_type prop_zip rate_reset term fc_end_d fc_start_d int_rate payoff_d reo_date monthstart monthend new_sch_mnth_p temp_payment_adj mba_stat_1st curr_hpi curr_unempl orig_hpi orig_unempl
compress



sort loan_id_num currmonth



save "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Data\MSA Level\Pittsburgh\pittsburgh_subp_refi_arm generated.dta", replace



