**Note: State 14 version used
**Note: This do file provides details on how to transfor the dataset based on the executive order as 
	*the unit of analysis into an expanded dataset based on the executive order-year as the unit of analysis.
	
*****************************Table of Contents***********************************
	*Section 1: Create expanded dataset for main analysis (thrower_ajps_replication_main.dta)
	*Section 2: Create expanded dataset for robustness check, only including fully revoked orders as a revocation (thrower_ajps_replication_tableb5.dta)
	*Section 3: Create expanded dataset for robustenss check, only including rejection of authority orders as revocation (thrower_ajps_replication_tableb6.dta)
	*Section 4: Creating independent variables for all of the expanded datasets
*********************************************************************************


*******************Section 1: Create dataset for main analysis*******************
*Load eo_original_list.csv dataset into Stata

*Create a variable measuring the number of years until an order is revoked
gen years_revoke = 2014 - year
replace years_revoke = revoke_year - year if revoked==1
replace years_revoke = years_revoke + 1

*Expand dataset to executive order-year observations
expand years_revoke

*Create episode year identifier for each subject
bysort id: ge seqvar = _n

*Create new dependent variable coded as 1 if order is revoked and it's the last row of that EO
bysort id: ge time_revoked = revoked == 1 & _n==_N 

*Make survival dataset for Stata
stset years_revoke, failure(time_revoked == 1)
*********************************************************************************


**********Section 2: Create dataset for Table B5 (fully revoked orders)**********
*Load eo_original_list.csv dataset into Stata

*Create a variable indicating if an executive order is revoked in full (not in part)
gen full_revoked = 0
replace full_revoked = 1 if revoked == 1 & partrevoked == 0

*Create a variable measuring the number of years until an order is fully revoked
gen years_fullrevoke = 2014 - year
replace years_fullrevoke = revoke_year - year if full_revoke == 1
replace years_fullrevoke = years_fullrevoke + 1

*Expand dataset to executive order-year observation
expand years_fullrevoke

*Create episode year identifier for each subject*
bysort id: ge seqvar = _n

*Create new dependent variable coded as 1 if order is revoked and it's the last row of that EO
bysort id: ge time_fullrevoked = full_revoked == 1 & _n==_N 

*Make survival dataset for Stata
stset years_fullrevoke, failure(time_fullrevoked == 1)
*********************************************************************************


*****Section 3: Create dataset for Table B6 (rejection of authority orders)******
*Load eo_original_list.csv dataset into Stata

*Create a variable indicating if an executive order is revoked by a rejection of authority, excluding amendments
gen general_rejecteo2 = 0 
replace general_rejecteo2 = 1 if reject_revoke_eo == 1 | transfer_rv == 1 | abolish_rv == 1 | other_auth_rv == 1 & amend_rv == 0

*Create a variable measuring the number of years until an order is revoked by authority rejection
gen years_genreject2 = 2014 - year
replace years_genreject2 = revoke_year - year if general_rejecteo2 == 1
replace years_genreject2 = years_genreject2 + 1

*expand dataset to executive order-year observation*
expand years_genreject2

*Create episode year identifier for each subject*
bysort id: ge seqvar = _n

*Create new dependent variable coded as 1 if order is revoked and it's the last row of that EO*
bysort id: ge time_genreject2 = general_rejecteo2 == 1 & _n==_N 

*Make survival dataset for Stata
stset years_genreject2, failure(time_genreject2 == 1)
*********************************************************************************


*************Generate independent variables for expanded datasets****************
*load any of the expanded datasets (thrower_ajps_replication_main.dta, thrower_ajps_replication_tableb5, thrower_ajps_replication_tableb6)

*Create variable indicating the current year within an EO's life
gen current_year = year + seqvar - 1

*Create numerical variable representing each current president
gen current_president = .
replace current_president = 1 if current_year == 1937 | current_year == 1938 | current_year == 1939 | current_year == 1940 | current_year == 1941 | current_year == 1941 | current_year == 1942 | current_year == 1943 | current_year == 1944
	*FDR
replace current_president = 2 if current_year == 1945 | current_year == 1946 | current_year == 1947 | current_year == 1948 | current_year == 1949 | current_year == 1950 | current_year == 1951 | current_year == 1952
	*Truman
replace current_president = 3 if current_year == 1953 | current_year == 1954 | current_year == 1955 | current_year == 1956 | current_year == 1957 | current_year == 1958 | current_year == 1959 | current_year == 1960
	*Ike
replace current_president = 4 if current_year == 1961 | current_year == 1962 | current_year == 1963
	*JFK
replace current_president = 5 if current_year == 1964 | current_year == 1965 | current_year == 1966 | current_year == 1967 | current_year == 1968
	*LBJ
replace current_president = 6 if current_year == 1969 | current_year == 1970 | current_year == 1971 | current_year == 1972 | current_year == 1973 | current_year == 1974
	*Nixon
replace current_president = 7 if current_year == 1975 | current_year == 1976
	*Ford
replace current_president = 8 if current_year == 1977 | current_year == 1978 | current_year == 1979 | current_year == 1980
	*Carter
replace current_president = 9 if current_year == 1981 | current_year == 1982 | current_year == 1983 | current_year == 1984 | current_year == 1985 | current_year == 1986 | current_year == 1987 | current_year == 1988
	*Reagan
replace current_president = 10 if current_year == 1989 | current_year == 1990 | current_year == 1991 | current_year == 1992
	*HW. Bush
replace current_president = 11 if current_year == 1993 | current_year == 1994 | current_year == 1995 | current_year == 1996 | current_year == 1997 | current_year == 1998 | current_year == 1999 | current_year == 2000
	*Clinton
replace current_president = 12 if current_year == 2001 | current_year == 2002 | current_year == 2003 | current_year == 2004 | current_year == 2005 | current_year == 2006 | current_year == 2007 | current_year == 2008
	*W. Bush
replace current_president = 13 if current_year == 2009 | current_year == 2010 | current_year == 2011 | current_year == 2012 | current_year == 2013 | current_year == 2014
	*Obama
	
*Create fixed effects for issuing president
gen FDR = 0
replace FDR = 1 if issuingpresident=="Roosevelt"
gen Truman = 0 
replace Truman =1 if issuingpresident=="Truman"
gen IKE = 0
replace IKE = 1 if issuingpresident=="Eisenhower"
gen JFK = 0
replace JFK = 1 if issuingpresident=="Kennedy"
gen LBJ = 0
replace LBJ = 1 if issuingpresident=="Johnson"
gen Nixon = 0
replace Nixon = 1 if issuingpresident=="Nixon"
gen Ford = 0
replace Ford = 1 if issuingpresident=="Ford"
gen Carter = 0
replace Carter = 1 if issuingpresident=="Carter"
gen Reagan = 0
replace Reagan = 1 if issuingpresident=="Reagan"
gen Bush41 = 0
replace Bush41 = 1 if issuingpresident=="HW. Bush"
gen Clinton = 0
replace Clinton = 1 if issuingpresident=="Clinton"
gen Bush43 = 0
replace Bush43 = 1 if issuingpresident=="W. Bush"
gen Obama = 0
replace Obama = 1 if issuingpresident=="Obama"	
	
*Create fixed effects for current president
gen FDR2 = 0
replace FDR2 = 1 if current_president == 1
gen Truman2 = 0
replace Truma2n = 1 if current_president == 2
gen IKE2 = 0
replace IKE2 = 1 if current_president == 3
gen JFK2 = 0
replace JFK2 = 1 if current_president == 4
gen LBJ2 = 0
replace LBJ2 = 1 if current_president == 5
gen Nixon2 = 0
replace Nixon2 = 1 if current_president == 6
gen Ford2 = 0 
replace Ford2 = 1 if current_president == 7
gen Carter2 = 0
replace Carter2 = 1 if current_president == 8
gen Reagan2 = 0
replace Reagan2 = 1 if current_president == 9
gen Bush412 = 0
replace Bush412 = 1 if current_president == 10
gen Clinton2 = 0
replace Clinton2 = 1 if current_president == 11
gen Bush432 = 0
replace Bush432 = 1 if current_president == 12
gen Obama2 = 0
replace Obama2 = 1 if current_president == 13

*Create an indicator variable for party of the current president
gen current_GOP = 0
replace current_GOP = 1 if IKE==1 | Nixon==1 | Ford==1 | Reagan==1 | Bush41==1 | Bush43==1

*Create an indicator variable for party of the issuing president
gen issuing_GOP = 0
replace issuing_GOP = 1 if issuingpresident=="Eisenhower" | issuingpresident=="Nixon" | issuingpresident=="Ford" | issuingpresident=="Reagan" | issuingpresident=="HW. Bush" | issuingpresident=="W. Bush"

*Create an indicator variable for when current president if from a different party from the issuing president
gen opposing_pres = 0
replace opposing_pres = 1 if current_GOP != issuing_GOP

*Create a variable for the current president's ideal point (DW-NOMINATE)
gen current_ID = .
replace current_ID = -0.366 if current_president==1
replace current_ID = -0.376 if current_president==2
replace current_ID = 0.312 if current_president==3
replace current_ID = -0.495 if current_president==4
replace current_ID = -0.345 if current_president==5
replace current_ID = 0.568 if current_president==6
replace current_ID = 0.542 if current_president==7
replace current_ID = -0.547 if current_president==8
replace current_ID = 0.702 if current_president==9
replace current_ID = 0.581 if current_president==10
replace current_ID = -0.471 if current_president==11
replace current_ID = 0.724 if current_president == 12
replace current_ID = -0.311 if current_president == 13

*Create a variable for the issuing president's ideal point (DW-NOMINATE)
gen issuing_ID = .
replace issuing_ID = -0.366 if issuingpresident=="Roosevelt"
replace issuing_ID = -0.376 if issuingpresident=="Truman"
replace issuing_ID = 0.312 if issuingpresident=="Eisenhower"
replace issuing_ID = -0.495 if issuingpresident=="Kennedy"
replace issuing_ID = -0.345 if issuingpresident=="Johnson"
replace issuing_ID = 0.568 if issuingpresident=="Nixon"
replace issuing_ID = 0.542 if issuingpresident=="Ford"
replace issuing_ID = -0.547 if issuingpresident=="Carter"
replace issuing_ID = 0.702 if issuingpresident=="Reagan"
replace issuing_ID = 0.581 if issuingpresident=="HW. Bush"
replace issuing_ID = -0.471 if issuingpresident=="Clinton"
replace issuing_ID = 0.724 if issuingpresident=="W. Bush"
replace issuing_ID = -0.311 if issuingpresident=="Obama"

*Create a variable measuring the ideological distance between current and issuing president's ideal points (DW-NOMINATE)
gen pres_dist = abs(current_ID - issuing_ID)

*Create a variable indicating current divided government
gen current_divdgovt = 0
replace current_divdgovt = 1 if current_year == 1947 | current_year == 1948 | current_year == 1955 | current_year == 1956 | current_year == 1957 | current_year == 1958 | current_year == 1959 | current_year == 1960 | current_year == 1969 | current_year == 1970 | current_year == 1971 | current_year == 1972 | current_year == 1973 | current_year == 1974 | current_year == 1975 | current_year == 1976 | current_year == 1981 | current_year == 1982 | current_year == 1983 | current_year == 1984 | current_year == 1985 | current_year == 1986 | current_year == 1987 | current_year == 1988 | current_year == 1989 | current_year == 1990 | current_year == 1991 | current_year == 1992 | current_year == 1995 | current_year == 1996 | current_year == 1997 | current_year == 1998 | current_year == 1999 | current_year == 2000 | current_year == 2001 | current_year == 2002 | current_year == 2007 | current_year == 2008 | current_year == 2011 | current_year == 2012 | current_year == 2013 | current_year == 2014

*Create a variable measuring the current median member of Congress's ideal point, averaged across the House and the Senate (DW-NOMINATE)
gen current_avgcong = .
replace current_avgcong = -0.0965 if current_year == 1937 | current_year == 1938
replace current_avgcong = -0.0255 if current_year == 1939 | current_year == 1940
replace current_avgcong = -0.016 if current_year == 1941 | current_year == 1942
replace current_avgcong = 0.0655 if current_year == 1943 | current_year == 1944
replace current_avgcong = 0.053 if current_year == 1945 | current_year == 1946
replace current_avgcong = 0.1195 if current_year == 1947 | current_year == 1948
replace current_avgcong = 0.0205 if current_year == 1949 | current_year == 1950
replace current_avgcong = 0.079 if current_year == 1951 | current_year == 1952
replace current_avgcong = 0.111 if current_year == 1953 | current_year == 1954
replace current_avgcong = 0.0645 if current_year == 1955 | current_year == 1956
replace current_avgcong = 0.0625 if current_year == 1957 | current_year == 1958
replace current_avgcong = -0.0975 if current_year == 1959 | current_year == 1960
replace current_avgcong = -0.053 if current_year == 1961 | current_year == 1962
replace current_avgcong = -0.089 if current_year == 1963 | current_year == 1964
replace current_avgcong = -0.1635 if current_year == 1965 | current_year == 1966
replace current_avgcong = -0.0935 if current_year == 1967 | current_year == 1968
replace current_avgcong = -0.0655 if current_year == 1969 | current_year == 1970
replace current_avgcong = -0.067 if current_year == 1971 | current_year == 1972
replace current_avgcong = -0.0845 if current_year == 1973 | current_year == 1974
replace current_avgcong = -0.1855 if current_year == 1975 | current_year == 1976
replace current_avgcong = -0.1765 if current_year == 1977 | current_year == 1978
replace current_avgcong = -0.1395 if current_year == 1979 | current_year == 1980
replace current_avgcong = -0.0345 if current_year == 1981 | current_year == 1982
replace current_avgcong = -0.0685 if current_year == 1983 | current_year == 1984
replace current_avgcong = -0.0565 if current_year == 1985 | current_year == 1986
replace current_avgcong = -0.133 if current_year == 1987 | current_year == 1988
replace current_avgcong = -0.1615 if current_year == 1989 | current_year == 1990
replace current_avgcong = -0.1755 if current_year == 1991 | current_year == 1992
replace current_avgcong = -0.185 if current_year == 1993 | current_year == 1994
replace current_avgcong = 0.11 if current_year == 1995 | current_year == 1996
replace current_avgcong = 0.1665 if current_year == 1997 | current_year == 1998
replace current_avgcong = 0.1425 if current_year == 1999 | current_year == 2000
replace current_avgcong = 0.0885 if current_year == 2001 | current_year == 2002
replace current_avgcong = 0.179 if current_year == 2003 | current_year == 2004
replace current_avgcong = 0.234 if current_year == 2005 | current_year == 2006
replace current_avgcong = -0.0795 if current_year == 2007 | current_year == 2008
replace current_avgcong = -0.2295 if current_year == 2009 | current_year == 2010
replace current_avgcong = 0.133 if current_year == 2011 | current_year == 2012
replace current_avgcong = 0.1055 if current_year == 2013 | current_year == 2014

*Create a variable measuring the ideological distance between the current president and current median of Congress (DW-NOMINATE)
gen current_pcong_dist = abs(current_ID - current_avgcong)

*Create a variable measuring the issuing median of Congress's ideal point, averaged across the House and the Senate (DW-NOMINATE)
gen issuing_avgcong = .
replace issuing_avgcong = -0.0965 if year == 1937 | year == 1938
replace issuing_avgcong = -0.0255 if year == 1939 | year == 1940
replace issuing_avgcong = -0.016 if year == 1941 | year == 1942
replace issuing_avgcong = 0.0655 if year == 1943 | year == 1944
replace issuing_avgcong = 0.053 if year == 1945 | year == 1946
replace issuing_avgcong = 0.1195 if year == 1947 | year == 1948
replace issuing_avgcong = 0.0205 if year == 1949 | year == 1950
replace issuing_avgcong = 0.079 if year == 1951 | year == 1952
replace issuing_avgcong = 0.111 if year == 1953 | year == 1954
replace issuing_avgcong = 0.0645 if year == 1955 | year == 1956
replace issuing_avgcong = 0.0625 if year == 1957 | year == 1958
replace issuing_avgcong = -0.0975 if year == 1959 | year == 1960
replace issuing_avgcong = -0.053 if year == 1961 | year == 1962
replace issuing_avgcong = -0.089 if year == 1963 | year == 1964
replace issuing_avgcong = -0.1635 if year == 1965 | year == 1966
replace issuing_avgcong = -0.0935 if year == 1967 | year == 1968
replace issuing_avgcong = -0.0655 if year == 1969 | year == 1970
replace issuing_avgcong = -0.067 if year == 1971 | year == 1972
replace issuing_avgcong = -0.0845 if year == 1973 | year == 1974
replace issuing_avgcong = -0.1855 if year == 1975 | year == 1976
replace issuing_avgcong = -0.1765 if year == 1977 | year == 1978
replace issuing_avgcong = -0.1395 if year == 1979 | year == 1980
replace issuing_avgcong = -0.0345 if year == 1981 | year == 1982
replace issuing_avgcong = -0.0685 if year == 1983 | year == 1984
replace issuing_avgcong = -0.0565 if year == 1985 | year == 1986
replace issuing_avgcong = -0.133 if year == 1987 | year == 1988
replace issuing_avgcong = -0.1615 if year == 1989 | year == 1990
replace issuing_avgcong = -0.1755 if year == 1991 | year == 1992
replace issuing_avgcong = -0.185 if year == 1993 | year == 1994
replace issuing_avgcong = 0.11 if year == 1995 | year == 1996
replace issuing_avgcong = 0.1665 if year == 1997 | year == 1998
replace issuing_avgcong = 0.1425 if year == 1999 | year == 2000
replace issuing_avgcong = 0.0885 if year == 2001 | year == 2002
replace issuing_avgcong = 0.179 if year == 2003 | year == 2004
replace issuing_avgcong = 0.234 if year == 2005 | year == 2006
replace issuing_avgcong = -0.0795 if year == 2007 | year == 2008
replace issuing_avgcong = -0.2295 if year == 2009 | year == 2010
replace issuing_avgcong = 0.133 if year == 2011 | year == 2012
replace issuing_avgcong = 0.1055 if year == 2013 | year == 2014

*Create a variable measuring the ideological distance between the issuing president and issuing median of Congress (DW-NOMINATE)
gen issuing_pcong_dist = abs(issuing_ID - issuing_avgcong)
 
*Create a variable indicating if the current year is during a presidential election
gen current_electyr = 0
replace current_electyr = 1 if current_year == 2012 | current_year == 2008 | current_year == 2004 | current_year == 2000 | current_year == 1996 | current_year == 1992 | current_year == 1988 | current_year == 1984 | current_year == 1980 | current_year == 1976 | current_year == 1972 | current_year == 1968 | current_year == 1964 | current_year == 1960 | current_year == 1956 | current_year == 1952 | current_year == 1948 | current_year == 1944 | current_year == 1940

*Create a variable indicating if the current year is an administration change
gen current_admchg = 0
replace current_admchg = 1 if current_year == 1953 | current_year == 1961 | current_year == 1969 | current_year == 1977 | current_year == 1981 | current_year == 1993 | current_year == 2001 | current_year == 2009

*Create a variable indicating if the current year is the last year in a president's term
gen current_endterm = 0
replace current_year = 1 if current_year == 1952 | current_year == 1960 | current_year == 1968 | current_year == 1976 | current_year == 1980 | current_year == 1992 | current_year == 2000 | current_year == 2008

*Create a variable indicating if the current year is during a war
gen current_war = 0
replace current_war = 1 if current_year == 1942 | current_year == 1943 | current_year == 1944 | current_year == 1945 | current_year ==  1950 | current_year == 1951 | current_year == 1952 | current_year == 1953 | current_year == 1964 | current_year == 1965 | current_year == 1966 | current_year == 1967 | current_year == 1968 | current_year == 1969 | current_year == 1970 | current_year == 1971 | current_year == 1972 | current_year == 1973 | current_year == 1974 | current_year == 1975 | current_year == 1990 | current_year == 1991 | current_year == 2001 | current_year == 2002 | current_year == 2003

*Create a variable measuring the president's approval rating during the current year (Gallup Poll)
gen current_presapprove = .
replace current_presapprove = 67.71 if current_year == 1941
replace current_presapprove = 76.22 if current_year == 1942
replace current_presapprove = 71.5 if current_year == 1943
replace current_presapprove = 71.5 if current_year == 1944
replace current_presapprove = 71.5 if current_year == 1945
replace current_presapprove = 43.125 if current_year == 1946
replace current_presapprove = 57 if current_year == 1947
replace current_presapprove = 37.33 if current_year == 1948
replace current_presapprove = 54.17 if current_year == 1949
replace current_presapprove = 38.5 if current_year == 1950
replace current_presapprove = 25.5 if current_year == 1951
replace current_presapprove = 28.67 if current_year == 1952
replace current_presapprove = 68 if current_year == 1953
replace current_presapprove = 65.63 if current_year == 1954
replace current_presapprove = 71.07 if current_year == 1955
replace current_presapprove = 72.69 if current_year == 1956
replace current_presapprove = 64.33 if current_year == 1957
replace current_presapprove = 54.75 if current_year == 1958
replace current_presapprove = 63.79 if current_year == 1959
replace current_presapprove = 61.24 if current_year == 1960
replace current_presapprove = 75.77 if current_year == 1961
replace current_presapprove = 72.15 if current_year == 1962
replace current_presapprove = 63.54 if current_year == 1963
replace current_presapprove = 74.71 if current_year == 1964
replace current_presapprove = 66.11 if current_year == 1965
replace current_presapprove = 50.75 if current_year == 1966
replace current_presapprove = 44.06 if current_year == 1967
replace current_presapprove = 42.14 if current_year == 1968
replace current_presapprove = 61.11 if current_year == 1969
replace current_presapprove = 56.83 if current_year == 1970
replace current_presapprove = 50.15 if current_year == 1971
replace current_presapprove = 56.4 if current_year == 1972
replace current_presapprove = 41.8 if current_year == 1973
replace current_presapprove = 42.95 if current_year == 1974
replace current_presapprove = 42.95 if current_year == 1975
replace current_presapprove = 62.46 if current_year == 1976
replace current_presapprove = 62.46 if current_year == 1977
replace current_presapprove = 45.6 if current_year == 1978
replace current_presapprove = 36.76 if current_year == 1979
replace current_presapprove = 40.65 if current_year == 1980
replace current_presapprove = 57.52 if current_year == 1981
replace current_presapprove = 43.79 if current_year == 1982
replace current_presapprove = 43.86 if current_year == 1983
replace current_presapprove = 55.29 if current_year == 1984
replace current_presapprove = 60.33 if current_year == 1985
replace current_presapprove = 60.62 if current_year == 1986
replace current_presapprove = 41.18 if current_year == 1987
replace current_presapprove = 51.88 if current_year == 1988
replace current_presapprove = 63.35 if current_year == 1989
replace current_presapprove = 66.41 if current_year == 1990
replace current_presapprove = 71.77 if current_year == 1991
replace current_presapprove = 40.04 if current_year == 1992
replace current_presapprove = 48.67 if current_year == 1993
replace current_presapprove = 46.61 if current_year == 1994
replace current_presapprove = 47.54 if current_year == 1995
replace current_presapprove = 54.46 if current_year == 1996
replace current_presapprove = 58.14 if current_year == 1997
replace current_presapprove = 63.68 if current_year == 1998
replace current_presapprove = 61.39 if current_year == 1999
replace current_presapprove = 60.42 if current_year == 2000
replace current_presapprove = 67.04 if current_year == 2001
replace current_presapprove = 71.86 if current_year == 2002
replace current_presapprove = 60.38 if current_year == 2003
replace current_presapprove = 50.69 if current_year == 2004
replace current_presapprove = 46.12 if current_year == 2005
replace current_presapprove = 37.9 if current_year == 2006
replace current_presapprove = 33.65 if current_year == 2007
replace current_presapprove = 30.03 if current_year == 2008
replace current_presapprove = 57.2289467 if current_year == 2009
replace current_presapprove = 46.9372553 if current_year == 2010
replace current_presapprove = 44.65 if current_year == 2011
replace current_presapprove = 47.58 if current_year == 2012
replace current_presapprove = 50.11 if current_year == 2013
replace current_presapprove = 41.3 if current_year == 2014

*Create a variable measuring the inflation rate in the current year (Bureau of Census)
gen current_inflation = .
replace current_inflation = 3.61 if current_year == 1937
replace current_inflation = -1.88 if current_year == 1938
replace current_inflation = -1.42 if current_year == 1939
replace current_inflation = 1.01 if current_year == 1940
replace current_inflation = 4.99 if current_year == 1941
replace current_inflation = 10.66 if current_year == 1942
replace current_inflation = 6.13 if current_year == 1943
replace current_inflation = 1.73 if current_year == 1944
replace current_inflation = 2.27 if current_year == 1945
replace current_inflation = 8.56 if current_year == 1946
replace current_inflation = 14.33 if current_year == 1947
replace current_inflation = 7.79 if current_year == 1948
replace current_inflation = -0.96 if current_year == 1949
replace current_inflation = 0.96 if current_year == 1950
replace current_inflation = 7.89 if current_year == 1951
replace current_inflation = 2.19 if current_year == 1952
replace current_inflation = 0.75 if current_year == 1953
replace current_inflation = 0.49 if current_year == 1954
replace current_inflation = -0.37 if current_year == 1955
replace current_inflation = 1.49 if current_year == 1956
replace current_inflation = 3.57 if current_year == 1957
replace current_inflation = 2.74 if current_year == 1958
replace current_inflation = 0.83 if current_year == 1959
replace current_inflation = 1.58 if current_year == 1960
replace current_inflation = 1.01 if current_year == 1961
replace current_inflation = 1.14 if current_year == 1962
replace current_inflation = 1.19 if current_year == 1963
replace current_inflation = 1.34 if current_year == 1964
replace current_inflation = 1.71 if current_year == 1965
replace current_inflation = 2.85 if current_year == 1966
replace current_inflation = 2.9 if current_year == 1967
replace current_inflation = 4.19 if current_year == 1968
replace current_inflation = 5.37 if current_year == 1969
replace current_inflation = 5.92 if current_year == 1970
replace current_inflation = 4.3 if current_year == 1971
replace current_inflation = 3.31 if current_year == 1972
replace current_inflation = 6.21 if current_year == 1973
replace current_inflation = 10.98 if current_year == 1974
replace current_inflation = 9.14 if current_year == 1975
replace current_inflation = 5.76 if current_year == 1976
replace current_inflation = 6.45 if current_year == 1977
replace current_inflation = 7.61 if current_year == 1978
replace current_inflation = 11.27 if current_year == 1979
replace current_inflation = 13.52 if current_year == 1980
replace current_inflation = 10.38 if current_year == 1981
replace current_inflation = 6.13 if current_year == 1982
replace current_inflation = 3.21 if current_year == 1983
replace current_inflation = 4.32 if current_year == 1984
replace current_inflation = 3.56 if current_year == 1985
replace current_inflation = 1.86 if current_year == 1986
replace current_inflation = 3.65 if current_year == 1987
replace current_inflation = 4.14 if current_year == 1988
replace current_inflation = 4.82 if current_year == 1989
replace current_inflation = 5.4 if current_year == 1990
replace current_inflation = 4.21 if current_year == 1991
replace current_inflation = 3.01 if current_year == 1992
replace current_inflation = 2.99 if current_year == 1993
replace current_inflation = 2.56 if current_year == 1994
replace current_inflation = 2.83 if current_year == 1995
replace current_inflation = 2.95 if current_year == 1996
replace current_inflation = 2.29 if current_year == 1997
replace current_inflation = 1.56 if current_year == 1998
replace current_inflation = 2.21 if current_year == 1999
replace current_inflation = 3.36 if current_year == 2000
replace current_inflation = 2.85 if current_year == 2001
replace current_inflation = 1.58 if current_year == 2002
replace current_inflation = 2.28 if current_year == 2003
replace current_inflation = 2.66 if current_year == 2004
replace current_inflation = 3.39 if current_year == 2005
replace current_inflation = 3.23 if current_year == 2006
replace current_inflation = 2.85 if current_year == 2007
replace current_inflation = 3.84 if current_year == 2008
replace current_inflation = -0.36 if current_year == 2009
replace current_inflation = 1.64 if current_year == 2010
replace current_inflation = 3.16 if current_year == 2011
replace current_inflation = 2.07 if current_year == 2012
replace current_inflation = 1.46 if current_year == 2013

*Create a trend variable for the issuing year 
gen trend37 = year - 1937
gen trend49 = year - 1949

*Create a trend variable for the current year
gen current_trend37 = current_year - 1937
gen current_trend49 = current_year - 1949

*Create a variable measuring the total number of executive orders issued each year
gen eo_total = .
replace eo_total = 253 if current_year == 1937
replace eo_total = 247 if current_year == 1938
replace eo_total = 287 if current_year == 1939
replace eo_total = 309 if current_year == 1940
replace eo_total = 383 if current_year == 1941
replace eo_total = 289 if current_year == 1942
replace eo_total = 122 if current_year == 1943
replace eo_total = 100 if current_year == 1944
replace eo_total = 168 if current_year == 1945
replace eo_total = 148 if current_year == 1946
replace eo_total = 100 if current_year == 1947
replace eo_total = 117 if current_year == 1948
replace eo_total = 69 if current_year == 1949
replace eo_total = 95 if current_year == 1950
replace eo_total = 118 if current_year == 1951
replace eo_total = 115 if current_year == 1952
replace eo_total = 80 if current_year == 1953
replace eo_total = 73 if current_year == 1954
replace eo_total = 65 if current_year == 1955
replace eo_total = 44 if current_year == 1956
replace eo_total = 55 if current_year == 1957
replace eo_total = 50 if current_year == 1958
replace eo_total = 60 if current_year == 1959
replace eo_total = 56 if current_year == 1960
replace eo_total = 70 if current_year == 1961
replace eo_total = 89 if current_year == 1962
replace eo_total = 62 if current_year == 1963
replace eo_total = 56 if current_year == 1964
replace eo_total = 74 if current_year == 1965
replace eo_total = 57 if current_year == 1966
replace eo_total = 66 if current_year == 1967
replace eo_total = 65 if current_year == 1968
replace eo_total = 52 if current_year == 1969
replace eo_total = 72 if current_year == 1970
replace eo_total = 63 if current_year == 1971
replace eo_total = 54 if current_year == 1972
replace eo_total = 64 if current_year == 1973
replace eo_total = 69 if current_year == 1974
replace eo_total = 67 if current_year == 1975
replace eo_total = 73 if current_year == 1976
replace eo_total = 66 if current_year == 1977
replace eo_total = 78 if current_year == 1978
replace eo_total = 77 if current_year == 1979
replace eo_total = 99 if current_year == 1980
replace eo_total = 50 if current_year == 1981
replace eo_total = 63 if current_year == 1982
replace eo_total = 57 if current_year == 1983
replace eo_total = 41 if current_year == 1984
replace eo_total = 45 if current_year == 1985
replace eo_total = 37 if current_year == 1986
replace eo_total = 43 if current_year == 1987
replace eo_total = 45 if current_year == 1988
replace eo_total = 31 if current_year == 1989
replace eo_total = 43 if current_year == 1990
replace eo_total = 46 if current_year == 1991
replace eo_total = 46 if current_year == 1992
replace eo_total = 57 if current_year == 1993
replace eo_total = 54 if current_year == 1994
replace eo_total = 42 if current_year == 1995
replace eo_total = 49 if current_year == 1996
replace eo_total = 38 if current_year == 1997
replace eo_total = 38 if current_year == 1998
replace eo_total = 35 if current_year == 1999
replace eo_total = 53 if current_year == 2000
replace eo_total = 54 if current_year == 2001
replace eo_total = 31 if current_year == 2002
replace eo_total = 41 if current_year == 2003
replace eo_total = 45 if current_year == 2004
replace eo_total = 26 if current_year == 2005
replace eo_total = 27 if current_year == 2006
replace eo_total = 32 if current_year == 2007
replace eo_total = 35 if current_year == 2008
replace eo_total = 39 if current_year == 2009
replace eo_total = 35 if current_year == 2010
replace eo_total = 34 if current_year == 2011
replace eo_total = 39 if current_year == 2012
replace eo_total = 20 if current_year == 2013
replace eo_total = 31 if current_year == 2014

*Create a logged measure of total EOs issued in that year 
gen log_eo_total = ln(eo_total)

*Create a variable measuring the age of an executive order in each current year
gen age_eo = seqvar - 1

*Create a categorial variable indicating whether an executive order is substantively amended, superseded, or revoked in a given year
gen all_cats = 0
replace all_cats = 1 if time_amended == 1 & time_revoked == 0 & time_superseded == 0
replace all_cats = 2 if time_superseded == 1 & time_amended == 0 & time_revoked == 0
replace all_cats = 3 if time_revoked == 1 & time_amended == 0 & time_superseded == 0

*Create non-proportionality controls (interactions between IDVs and age of EO for IDVs violating the non-proportional hazards assumption)
gen y_div1 = age_eo*divdgovt
gen y_pcong1 = age_eo*issuing_pcong_dist
gen y_words = age_eo*log_words
gen y_adm1 = age_eo*admchg
gen y_last1 = age_eo*lastyr
gen y_elect1 = age_eo*electyr
gen y_war1 = age_eo*war
gen y_infl1 = age_eo*inflation
gen y_approve1 = age_eo*presapprove_year
gen y_fds = age_eo*fds
gen y_nyt = age_eo*nyt
gen y_pub = age_eo*public_mention
gen y_trend1a = age_eo*trend37
gen y_trend1b = age_eo*trend49
gen y_truman = age_eo*Truman
gen y_ike = age_eo*IKE
gen y_jfk = age_eo*JFK
gen y_lbj = age_eo*LBJ
gen y_nix = age_eo*Nixon
gen y_ford = age_eo*Ford
gen y_carter = age_eo*Carter
gen y_reagan = age_eo*Reagan
gen y_bush41 = age_eo*Bush41
gen y_clinton = age_eo*Clinton
gen y_bush43 = age_eo*Bush43
gen y_obama = age_eo*Obama

gen y_div2 = age_eo*current_divdgovt
gen y_pcong2 = age_eo*current_pcong_dist
gen y_opp2 = age_eo*opposing_pres
gen y_pdist = age_eo*pres_dist
gen y_eo2 = age_eo*log_eo_total
gen y_adm2 = age_eo*current_admchg
gen y_last2 = age_eo*current_lastyr
gen y_elect2 = age_eo*current_electyr
gen y_war2 = age_eo*current_war
gen y_infl2 = age_eo*current_inflation
gen y_approve2 = age_eo*current_presapprove
gen y_trend2a = age_eo*current_trend37
gen y_trend2b = age_eo*current_trend49
gen y_truman2 = age_eo*Truman2
gen y_ike2 = age_eo*IKE2
gen y_jfk2 = age_eo*JFK2
gen y_lbj2 = age_eo*LBJ2
gen y_nix2 = age_eo*Nixon2
gen y_ford2 = age_eo*Ford2
gen y_carter2 = age_eo*Carter2
gen y_reagan2 = age_eo*Reagan2
gen y_bush412 = age_eo*Bush412
gen y_clinton2 = age_eo*Clinton2
gen y_bush432 = age_eo*Bush432
gen y_obama2 = age_eo*Obama2

*********************************************************************************
