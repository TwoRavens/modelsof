

/*
clear
input year month
1920 01 ;
1920 02 ;
1920 03 ;
1920 04 ;
1920 05 ;
1920 06 ;
1920 07 ;
1920 08 ;
1920 09 ;
1920 10 ;
1920 11 ;
1920 12 ;
1921 . ;
1922 . ;
1923 . ;
1924 . ;
1925 . ;
1926 . ;
1927 . ;
1928 . ;
1929 . ;
1930 . ;
1931 . ;
1932 . ;
1933 . ;
1934 . ;
1935 . ;
1936 . ;
1937 . ;
1938 . ;
1939 . ;
1940 . ;
1941 . ;
1942 . ;
1943 . ;
1944 . ;
1945 . ;
1946 . ;
1947 . ;
1948 . ;
1949 . ;
1950 . ;
1951 . ;
1952 . ;
1953 . ;
1954 . ;
1955 . ;
1956 . ;
1957 . ;
1958 . ;
1959 . ;
1960 . ;
1961 . ;
1962 . ;
1963 . ;
1964 . ;
1965 . ;
1966 . ;
1967 . ;
1968 . ;
1969 . ;
1970 . ;
1971 . ;
1972 . ;
1973 . ;
1974 . ;
1975 . ;
1976 . ;
1977 . ;
1978 . ;
1979 . ;
1980 . ;
1981 . ;
1982 . ;
1983 . ;
1984 . ;
1985 . ;
1986 . ;
1987 . ;
1988 . ;
1989 . ;
1990 . ;
1991 . ;
1992 . ;
1993 . ;
1994 . ;
1995 . ;
1996 . ;
1997 . ;
1998 . ;
1999 . ;
2000 . ;
2001 . ;
2002 . ;
2003 . ;
2004 . ;
2005 . ;
2006 . ;
2007 . ;
2008 . ;
end;

replace month=9 if month==.

fillin year month
gen date= ym(year,month)
format date %tm

gen recbymonth=0
replace recbymonth=1 if year==1920
replace recbymonth=1 if year==1921 & month<=7
replace recbymonth=1 if year==1923 & month>=5
replace recbymonth=1 if year==1924 & month<=7
replace recbymonth=1 if year==1926 & month>=10
replace recbymonth=1 if year==1927 & month<=11
replace recbymonth=1 if year==1929 & month>=8
replace recbymonth=1 if year==1930
replace recbymonth=1 if year==1931
replace recbymonth=1 if year==1932
replace recbymonth=1 if year==1933 & month<=3
replace recbymonth=1 if year==1937 & month>=5
replace recbymonth=1 if year==1938 & month<=6
replace recbymonth=1 if year==1945 & month>=2 & month<=10
replace recbymonth=1 if year==1948 & month>=11
replace recbymonth=1 if year==1949 & month<=10
replace recbymonth=1 if year==1953 & month>=7
replace recbymonth=1 if year==1954 & month<=5
replace recbymonth=1 if year==1957 & month>=8
replace recbymonth=1 if year==1958 & month<=4
replace recbymonth=1 if year==1960 & month>=4
replace recbymonth=1 if year==1961 & month<=2
replace recbymonth=1 if year==1969 & month==12
replace recbymonth=1 if year==1970 & month<=11
replace recbymonth=1 if year==1973 & month>=11
replace recbymonth=1 if year==1974
replace recbymonth=1 if year==1975 & month<=3
replace recbymonth=1 if year==1980 & month<=7
replace recbymonth=1 if year==1981 & month>=7
replace recbymonth=1 if year==1982 & month<=11
replace recbymonth=1 if year==1990 & month>=7
replace recbymonth=1 if year==1991 & month<=3
replace recbymonth=1 if year==2001 & month>=3 & month<=11
replace recbymonth=1 if year==2007 & month>=12
replace recbymonth=1 if year==2008


sort date
drop _fillin
save "$startdir/$outputdata\recbymonth.dta", replace
clear

#delimit;
drop _all;
set memory 300m;

clear;

input year nipadgdp recsty   recmonth repub unemp;
1930            -8.6    1   12   1 .;
1931            -6.4    1   12   1 .;
1932            -13     1   12   1 .;
1933            -1.3    0 2.5    0 .;
1934            10.8    0   0    0 .;
1935            8.9     0   0    0 .;
1936            13      0   0    0 .;
1937            5.1     1 7.5    0 .;
1938            -3.4    1 5.5    0 .;
1939            8.1     0   0    0 .;
1940            8.8     0   0    0    14.6  ;
1941            17.1    0   0    0    9.9   ;
1942            18.5    0   0    0    4.7   ;
1943            16.4    0   0    0    1.9   ;
1944            8.1     0   0    0    1.2   ;
1945            -1.1    1   9    0    1.9   ;
1946            -11     0   0    0    3.9   ;
1947            -0.9    0   0    0    3.9   ;
1948            4.4     1 1.5    0  3.8     ;
1949            -0.5    0  9.5   0   5.9    ;
1950            8.7     0    0   0     5.3  ;
1951            7.7     0    0   0     3.3  ;
1952            3.8     0    0   0     3    ;
1953            4.6     1  5.5   1   2.9    ;
1954            -0.7    0  4.5   1   5.5    ;
1955            7.1     0    0   1     4.4  ;
1956            1.9     0    0   1     4.1  ;
1957            2       1  4.5   1   4.3    ;
1958            -1      0  3.5   1   6.8    ;
1959            7.1     0    0   1     5.5  ;
1960            2.5     1  8.5   1   5.5    ;
1961            2.3     0  1.5   0   6.7    ;
1962            6.1     0    0   0     5.5  ;
1963            4.4     0    0   0     5.7  ;
1964            5.8     0    0   0     5.2  ;
1965            6.4     0    0   0     4.5  ;
1966            6.5     0    0   0     3.8  ;
1967            2.5     0    0   0     3.8  ;
1968            4.8     0    0   0     3.6  ;
1969            3.1     1  0.5   1   3.5    ;
1970            0.2     0  10.5  1   4.9    ;
1971            3.4     0     0  1      5.9 ;
1972            5.3     0     0  1      5.6 ;
1973            5.8     0   1.5  1    4.9   ;
1974            -0.5    1    12  1     5.6  ;
1975            -0.2    0   2.5  1    8.5   ;
1976            5.3     0     0  1      7.7 ;
1977            4.6     0     0  0      7.1 ;
1978            5.6     0     0  0      6.1 ;
1979            3.2     0     0  0      5.8 ;
1980            -0.2    1    6   0     7.1  ;
1981            2.5     1  5.5   1   7.6    ;
1982            -1.9    1  10.5  1   9.7    ;
1983            4.5     0    0   1     9.6  ;
1984            7.2     0    0   1     7.5  ;
1985            4.1     0    0   1     7.2  ;
1986            3.5     0    0   1     7    ;
1987            3.4     0    0   1     6.2  ;
1988            4.1     0    0   1     5.5  ;
1989            3.5     0    0   1     5.3  ;
1990            1.9     1  6.5   1   5.6    ;
1991            -0.2    0  2.5   1   6.8    ;
1992            3.3     0    0   1     7.5  ;
1993            2.7     0    0   0     6.9  ;
1994            4       0    0   0     6.1  ;
1995            2.5     0    0   0     5.6  ;
1996            3.7     0    0   0     5.4  ;
1997            4.5     0    0   0     4.9  ;
1998            4.2     0    0   0     4.5  ;
1999            4.5     0    0   0     4.2  ;
2000            3.7     0    0   0     4    ;
2001            0.8     1    8   1     4.7  ;
2002		    1.6     0	0  1     5.8  ;
2003		    2.5     0	0  1     6.0  ;
2004            3.6    	0	0  1	   5.5  ;
2005		    2.9     0	0  1     5.1  ;
2006		    2.8     0	0  1     4.6  ;
2007		    2.0	0	.5 1     4.6  ;
2008		    1.1	1	12  1    5.8  ;

/*recsty is based on the storesletten telmer yaron definition of an nber recession.
That paper gives a 1 to any year in which the majority of the year was in an nber
recession (peak to trough period).  For recessions lasting 6 to 12 months spanning two
calendar years the first year gets the 1 and the second a 0.

recmonth is the number of months in a given year in an nber recession.
The "peak" and "trough" months are counted as 0.5, as if the recession began or started
midmonth.
This means that a June to June recession lasts 12 months not 13.

*/;


/*The following continues the data series above using NBER and the STY definition
of a recession for 1900-1930.  NBER source: http://www.nber.org/cycles/cyclesmain.html

GDP growth data is from Historical Statistics of the United States.  "Table Ca9-19.
Gross domestic product: 1790-2002" Figures from 1930 onwards are very close to,
but not exactly, the NIPA figures, perhaps due to revisions.


Unemployment data is from HSUS "Table Ba470-477.  Labor force, employment, and unemployment:
1890-1990 [Weir]"  Figures from series Ba475, which expresses unemployment as a fraction
of the total civilian labor force seem closest to the BLS data used above for 1940 to now.
I backfill for 1930s as well. Many caveats apply; see documentation.
7.4
2.0
-3.3
-5.4
15.4
-1.5
5.7
2.8
9.9


year nipadgdp recsty   recmonth repub unemp;
*/
1890  .     1    5.5    .    3.97;
1891 7.4    0    4.5    .    4.49;
1892 2      0     0     .    4.31;
1893 -3.3   1    11.5   .    6.77;
1894 -5.4   1    6.5    .    9.28;
1895 15.4   0    0.5    .    8.48;
1896 -1.5   1    12     .    9.27;
1897 5.7    0    5.5    .    8.51;
1898 2.8    0     0     .    7.79;
1899 9.9    1   6.5     .    5.85;
1900	2.1	1	11.5	.	5;
1901	11.5	0	0	.	4.1;
1902	1.1	0	3.5	.	3.5;
1903	6.5	1	12	.	3.5;
1904	-5	1	7.5	.	4.9;
1905	10.2	0	0	.	3.9;
1906	13.8	0	0	.	2.5;
1907	-1.9	1	7.5	.	3.1;
1908	-13.2	0	5.5	.	7.5;
1909	16.6	0	0	.	5.7;
1910	-0.9	1	11.5	.	5.9;
1911	3.4	1	12	.	7;
1912	4.8	0	0.5	.	5.9;
1913	4	1	11.5	.	5.7;
1914	-7.9	1	11.5	.	8.5;
1915	2.7	0	0	.	9;
1916	13.9	0	0	.	6.5;
1917	-2.7	0	0	.	5.2;
1918	9.3	1	4.5	.	1.2;
1919	0.4	0	2.5	.	2.3;
1920	-1.5	1	11.5	.	5.2;
1921	-2.4	1	6.5	.	11.3;
1922	6	0	0	.	8.6;
1923	13.3	1	7.5	.	4.3;
1924	2.5	1	6.5	.	5.3;
1925	3.1	0	0	.	4.7;
1926	6.1	0	2.5	.	2.9;
1927	1.1	1	10.5	.	3.9;
1928	0.8	0	0	.	4.7;
1929	6.8	0	4.5	.	2.9;

end;


replace unemp= 9 if year==1930;
replace unemp= 15.7 if year==1931;
replace unemp= 22.9 if year==1932;
replace unemp= 20.9 if year==1933;
replace unemp= 16.2 if year==1934;
replace unemp= 14.4 if year==1935;
replace unemp= 10 if year==1936;
replace unemp= 9.2 if year==1937;
replace unemp= 12.5 if year==1938;
replace unemp=  11.3 if year==1939;

*no need for repub, this is done in politicalvars.do;
drop repub;


recast int year;
sort year;
gen expansion=1-recsty;
gen nipadgdp_pos=0;
replace nipadgdp_pos=1 if nipadgdp>0;
gen nipadgdp_neg=0;
replace nipadgdp_neg=1 if nipadgdp<0;
gen nipadgdp_big=0;
replace nipadgdp_big=1 if nipadgdp>10;
egen meannipa=mean(nipadgdp);
gen nipadgdp_nsq2=(nipadgdp-meannipa)^2;

save "$startdir/$outputdata\natmacroconditions", replace;
*/

#delimit;
clear; clear matrix;
use "$startdir/$outputdata\natreturns.dta";
sort year;
********************************************;
replace lnRmkt=0 if year>=1890 & year<=1925;
replace lnR2mkt=0 if year>=1890 & year<=1925;
replace lnRpeople=0 if year>=1890 & year<=1925;
replace lnR2people=0 if year>=1890 & year<=1925;
********************************************;



merge year using "$startdir/$outputdata\natmacroconditions";
drop _merge;
save "$startdir/$outputdata\natcohortswconditions", replace;


egen meanlnRmkt=mean(lnRmkt) if year<=2005;
gen lnRsqmkt=(lnRmkt-meanlnRmkt)^2;
gen lnvolRmkt=lnR2mkt;


sort year;
*define values;
gen cumsumlnRmkt=sum(lnRmkt);
gen recentcumsumlnRmkt=cumsumlnRmkt-cumsumlnRmkt[_n-5];

gen cumsumlnvolRmkt=sum(lnvolRmkt);
gen recentcumsumlnvolRmkt=cumsumlnvolRmkt-cumsumlnvolRmkt[_n-5];

gen cumsumlnRpeople=sum(lnRpeople);
gen recentcumsumlnRpeople=cumsumlnRpeople-cumsumlnRpeople[_n-5];

gen cumsumlnR2people=sum(lnR2people);
gen recentcumsumlnR2people=cumsumlnR2people-cumsumlnR2people[_n-5];

gen cumsumnipadgdp=sum(nipadgdp);
gen recentcumsumnipadgdp=cumsumnipadgdp-cumsumnipadgdp[_n-5];

gen cumsumrecsty=sum(recsty);
gen recentcumsumrecsty=cumsumrecsty-cumsumrecsty[_n-5];

gen cumsumrecmonth=sum(recmonth);
gen recentcumsumrecmonth=cumsumrecmonth-cumsumrecmonth[_n-5];

gen cumsumexpansion=sum(expansion);
gen recentcumsumexpansion=cumsumexpansion-cumsumexpansion[_n-5];

gen cumsumunemp=sum(unemp);
gen recentcumsumunemp=cumsumunemp-cumsumunemp[_n-5];

gen cumsumnipadgdp_pos=sum(nipadgdp_pos);
gen recentcumsumnipadgdp_pos=cumsumnipadgdp_pos-cumsumnipadgdp_pos[_n-5];

gen cumsumnipadgdp_nsq2=sum(nipadgdp_nsq2);
gen recentcumsumnipadgdp_nsq2=cumsumnipadgdp_nsq2-cumsumnipadgdp_nsq2[_n-5];


gen cumsumnipadgdp_neg=sum(nipadgdp_neg);
gen recentcumsumnipadgdp_neg=cumsumnipadgdp_neg-cumsumnipadgdp_neg[_n-5];


gen cumsumlnRsqmkt=sum(lnRsqmkt);
gen recentcumsumlnRsqmkt=cumsumlnRsqmkt-cumsumlnRsqmkt[_n-5];

save "$startdir/$outputdata\natreturnscumsum.dta", replace;


use "$startdir/$outputdata\natreturnscumsum.dta";
rename year curryear;
sort curryear;
save "$startdir/$outputdata\natreturnscurrcumsum.dta", replace;
clear;


use "$startdir/$outputdata\natreturnscumsum.dta";
rename year inityear;
sort inityear;
save "$startdir/$outputdata\natreturnsinitcumsum.dta", replace;
clear;

use "$startdir/$outputdata\natreturnscumsum.dta";
rename year in1year;
sort in1year;
save "$startdir/$outputdata\natreturnsin1cumsum.dta", replace;
clear;

use "$startdir/$outputdata\natreturnscumsum.dta";
rename year in2year;
sort in2year;
save "$startdir/$outputdata\natreturnsin2cumsum.dta", replace;
clear;

use "$startdir/$outputdata\natcohorts_fweight$control";
gen curryear=year;
sort curryear;
merge curryear using "$startdir/$outputdata\natreturnscurrcumsum.dta";
keep if year!=.;
drop if _merge!=3;
drop _merge;

*rename current values;
rename lnRmkt currlnRmkt;
rename cumsumlnRmkt currcumsumlnRmkt;
rename recentcumsumlnRmkt currrecentlnRmkt;

rename lnvolRmkt currlnvolRmkt;
rename cumsumlnvolRmkt currcumsumlnvolRmkt;
rename recentcumsumlnvolRmkt currrecentlnvolRmkt;

rename lnRpeople currlnRpeople;
rename cumsumlnRpeople currcumsumlnRpeople;
rename recentcumsumlnRpeople currrecentlnRpeople;

rename lnR2people currlnR2people;
rename cumsumlnR2people currcumsumlnR2people;
rename recentcumsumlnR2people currrecentlnR2people;


rename nipadgdp currnipadgdp;
rename cumsumnipadgdp currcumsumnipadgdp;
rename recentcumsumnipadgdp currrecentnipadgdp;

rename recsty currrecsty;
rename cumsumrecsty currcumsumrecsty;
rename recentcumsumrecsty currrecentrecsty;

rename recmonth currrecmonth;
rename cumsumrecmonth currcumsumrecmonth;
rename recentcumsumrecmonth currrecentrecmonth;

rename expansion currexpansion;
rename cumsumexpansion currcumsumexpansion;
rename recentcumsumexpansion currrecentexpansion;

rename nipadgdp_pos currnipadgdp_pos;
rename cumsumnipadgdp_pos currcumsumnipadgdp_pos;
rename recentcumsumnipadgdp_pos currrecentnipadgdp_pos;

rename nipadgdp_nsq2 currnipadgdp_nsq2;
rename cumsumnipadgdp_nsq2 currcumsumnipadgdp_nsq2;
rename recentcumsumnipadgdp_nsq2 currrecentnipadgdp_nsq2;

rename nipadgdp_neg currnipadgdp_neg;
rename cumsumnipadgdp_neg currcumsumnipadgdp_neg;
rename recentcumsumnipadgdp_neg currrecentnipadgdp_neg;

rename lnRsqmkt currlnRsqmkt;
rename cumsumlnRsqmkt currcumsumlnRsqmkt;
rename recentcumsumlnRsqmkt currrecentlnRsqmkt;

rename unemp currunemp;
rename cumsumunemp currcumsumunemp;
rename recentcumsumunemp currrecentunemp;



*note that this depends on 5-year age cohorts beginning with first bin 25-29 y/o;
*changed from "gen inityear=year-(A-1)5" 20090624 in hopes of making cumsum at A1 be equal to currrecent at A1 (cc);
gen inityear=year-A*5;
sort inityear;
merge inityear using "$startdir/$outputdata\natreturnsinitcumsum.dta";
keep if year!=.;
drop if _merge!=3;
drop _merge;

*rename initial values;
rename lnRmkt initlnRmkt;
rename cumsumlnRmkt initcumsumlnRmkt;
rename recentcumsumlnRmkt initrecentlnRmkt;

rename lnvolRmkt initlnvolRmkt;
rename cumsumlnvolRmkt initcumsumlnvolRmkt;
rename recentcumsumlnvolRmkt initrecentlnvolRmkt;

rename lnRpeople initlnRpeople;
rename cumsumlnRpeople initcumsumlnRpeople;
rename recentcumsumlnRpeople initrecentlnRpeople;

rename lnR2people initlnR2people;
rename cumsumlnR2people initcumsumlnR2people;
rename recentcumsumlnR2people initrecentlnR2people;

rename nipadgdp initnipadgdp;
rename cumsumnipadgdp initcumsumnipadgdp;
rename recentcumsumnipadgdp initrecentnipadgdp;

rename recsty initrecsty;
rename cumsumrecsty initcumsumrecsty;
rename recentcumsumrecsty initrecentrecsty;

rename recmonth initrecmonth;
rename cumsumrecmonth initcumsumrecmonth;
rename recentcumsumrecmonth initrecentrecmonth;

rename expansion initexpansion;
rename cumsumexpansion initcumsumexpansion;
rename recentcumsumexpansion initrecentexpansion;

rename nipadgdp_pos initnipadgdp_pos;
rename cumsumnipadgdp_pos initcumsumnipadgdp_pos;
rename recentcumsumnipadgdp_pos initrecentnipadgdp_pos;

rename nipadgdp_nsq2 initnipadgdp_nsq2;
rename cumsumnipadgdp_nsq2 initcumsumnipadgdp_nsq2;
rename recentcumsumnipadgdp_nsq2 initrecentnipadgdp_nsq2;

rename nipadgdp_neg initnipadgdp_neg;
rename cumsumnipadgdp_neg initcumsumnipadgdp_neg;
rename recentcumsumnipadgdp_neg initrecentnipadgdp_neg;

rename lnRsqmkt initlnRsqmkt;
rename cumsumlnRsqmkt initcumsumlnRsqmkt;
rename recentcumsumlnRsqmkt initrecentlnRsqmkt;

rename unemp initunemp;
rename cumsumunemp initcumsumunemp;
rename recentcumsumunemp initrecentunemp;

*note that this depends on 5-year age cohorts beginning with first bin 15-19 y/o;
gen in2year=year-(A-1)*5-10;
sort in2year;
merge in2year using "$startdir/$outputdata\natreturnsin2cumsum.dta";
keep if year!=.;
drop if _merge!=3;
drop _merge;

*rename in2ial values;
rename lnRmkt in2lnRmkt;
rename cumsumlnRmkt in2cumsumlnRmkt;
rename recentcumsumlnRmkt in2recentlnRmkt;

rename lnvolRmkt in2lnvolRmkt;
rename cumsumlnvolRmkt in2cumsumlnvolRmkt;
rename recentcumsumlnvolRmkt in2recentlnvolRmkt;

rename lnRpeople in2lnRpeople;
rename cumsumlnRpeople in2cumsumlnRpeople;
rename recentcumsumlnRpeople in2recentlnRpeople;

rename lnR2people in2lnR2people;
rename cumsumlnR2people in2cumsumlnR2people;
rename recentcumsumlnR2people in2recentlnR2people;

rename nipadgdp in2nipadgdp;
rename cumsumnipadgdp in2cumsumnipadgdp;
rename recentcumsumnipadgdp in2recentnipadgdp;

rename recsty in2recsty;
rename cumsumrecsty in2cumsumrecsty;
rename recentcumsumrecsty in2recentrecsty;

rename recmonth in2recmonth;
rename cumsumrecmonth in2cumsumrecmonth;
rename recentcumsumrecmonth in2recentrecmonth;

rename expansion in2expansion;
rename cumsumexpansion in2cumsumexpansion;
rename recentcumsumexpansion in2recentexpansion;

rename nipadgdp_pos in2nipadgdp_pos;
rename cumsumnipadgdp_pos in2cumsumnipadgdp_pos;
rename recentcumsumnipadgdp_pos in2recentnipadgdp_pos;

rename nipadgdp_nsq2 in2nipadgdp_nsq2;
rename cumsumnipadgdp_nsq2 in2cumsumnipadgdp_nsq2;
rename recentcumsumnipadgdp_nsq2 in2recentnipadgdp_nsq2;

rename lnRsqmkt in2lnRsqmkt;
rename cumsumlnRsqmkt in2cumsumlnRsqmkt;
rename recentcumsumlnRsqmkt in2recentlnRsqmkt;

rename nipadgdp_neg in2nipadgdp_neg;
rename cumsumnipadgdp_neg in2cumsumnipadgdp_neg;
rename recentcumsumnipadgdp_neg in2recentnipadgdp_neg;

rename unemp in2unemp;
rename cumsumunemp in2cumsumunemp;
rename recentcumsumunemp in2recentunemp;

*note that this depends on 5-year age cohorts beginning with first bin 0-4 y/o;
gen in1year=year-(A-1)*5-25;
sort in1year;
merge in1year using "$startdir/$outputdata\natreturnsin1cumsum.dta";
keep if year!=.;
drop if _merge!=3;
drop _merge;

*rename in1ial values;
rename lnRmkt in1lnRmkt;
rename cumsumlnRmkt in1cumsumlnRmkt;
rename recentcumsumlnRmkt in1recentlnRmkt;

rename lnvolRmkt in1lnvolRmkt;
rename cumsumlnvolRmkt in1cumsumlnvolRmkt;
rename recentcumsumlnvolRmkt in1recentlnvolRmkt;

rename lnRpeople in1lnRpeople;
rename cumsumlnRpeople in1cumsumlnRpeople;
rename recentcumsumlnRpeople in1recentlnRpeople;

rename lnR2people in1lnR2people;
rename cumsumlnR2people in1cumsumlnR2people;
rename recentcumsumlnR2people in1recentlnR2people;

rename nipadgdp in1nipadgdp;
rename cumsumnipadgdp in1cumsumnipadgdp;
rename recentcumsumnipadgdp in1recentnipadgdp;

rename recsty in1recsty;
rename cumsumrecsty in1cumsumrecsty;
rename recentcumsumrecsty in1recentrecsty;

rename recmonth in1recmonth;
rename cumsumrecmonth in1cumsumrecmonth;
rename recentcumsumrecmonth in1recentrecmonth;

rename expansion in1expansion;
rename cumsumexpansion in1cumsumexpansion;
rename recentcumsumexpansion in1recentexpansion;

rename nipadgdp_pos in1nipadgdp_pos;
rename cumsumnipadgdp_pos in1cumsumnipadgdp_pos;
rename recentcumsumnipadgdp_pos in1recentnipadgdp_pos;

rename nipadgdp_nsq2 in1nipadgdp_nsq2;
rename cumsumnipadgdp_nsq2 in1cumsumnipadgdp_nsq2;
rename recentcumsumnipadgdp_nsq2 in1recentnipadgdp_nsq2;

rename nipadgdp_neg in1nipadgdp_neg;
rename cumsumnipadgdp_neg in1cumsumnipadgdp_neg;
rename recentcumsumnipadgdp_neg in1recentnipadgdp_neg;

rename lnRsqmkt in1lnRsqmkt;
rename cumsumlnRsqmkt in1cumsumlnRsqmkt;
rename recentcumsumlnRsqmkt in1recentlnRsqmkt;

rename unemp in1unemp;
rename cumsumunemp in1cumsumunemp;
rename recentcumsumunemp in1recentunemp;

*make cumulatives;
gen cumsumlnRmkt=currcumsumlnRmkt-initcumsumlnRmkt;
gen cumsumlnvolRmkt=currcumsumlnvolRmkt-initcumsumlnvolRmkt;
gen cumsumlnRpeople=currcumsumlnRpeople-initcumsumlnRpeople;
gen cumsumlnR2people=currcumsumlnR2people-initcumsumlnR2people;
gen cumsumnipadgdp=currcumsumnipadgdp-initcumsumnipadgdp;
gen cumsumrecsty=currcumsumrecsty-initcumsumrecsty;
gen cumsumrecmonth=currcumsumrecmonth-initcumsumrecmonth;
gen cumsumexpansion=currcumsumexpansion-initcumsumexpansion;
gen cumsumnipadgdp_pos=currcumsumnipadgdp_pos-initcumsumnipadgdp_pos;
gen cumsumnipadgdp_nsq2=currcumsumnipadgdp_nsq2-initcumsumnipadgdp_nsq2;
gen cumsumlnRsqmkt=currcumsumlnRsqmkt-initcumsumlnRsqmkt;
gen cumsumnipadgdp_neg=currcumsumnipadgdp_neg-initcumsumnipadgdp_neg;
gen cumsumunemp=currcumsumunemp-initcumsumunemp;

gen cumin1lnRmkt=in2cumsumlnRmkt-in1cumsumlnRmkt;
gen cumin1lnvolRmkt=in2cumsumlnvolRmkt-in1cumsumlnvolRmkt;
gen cumin1lnRpeople=in2cumsumlnRpeople-in1cumsumlnRpeople;
gen cumin1lnR2people=in2cumsumlnR2people-in1cumsumlnR2people;
gen cumin1nipadgdp=in2cumsumnipadgdp-in1cumsumnipadgdp;
gen cumin1recsty=in2cumsumrecsty-in1cumsumrecsty;
gen cumin1recmonth=in2cumsumrecmonth-in1cumsumrecmonth;
gen cumin1expansion=in2cumsumexpansion-in1cumsumexpansion;
gen cumin1nipadgdp_pos=in2cumsumnipadgdp_pos-in1cumsumnipadgdp_pos;
gen cumin1nipadgdp_nsq2=in2cumsumnipadgdp_nsq2-in1cumsumnipadgdp_nsq2;
gen cumin1nipadgdp_neg=in2cumsumnipadgdp_neg-in1cumsumnipadgdp_neg;
gen cumin1lnRsqmkt=in2cumsumlnRsqmkt-in1cumsumlnRsqmkt;
gen cumin1unemp=in2cumsumunemp-in1cumsumunemp;

gen cumin2lnRmkt=initcumsumlnRmkt-in2cumsumlnRmkt;
gen cumin2lnvolRmkt=initcumsumlnvolRmkt-in2cumsumlnvolRmkt;
gen cumin2lnRpeople=initcumsumlnRpeople-in2cumsumlnRpeople;
gen cumin2lnR2people=initcumsumlnR2people-in2cumsumlnR2people;
gen cumin2nipadgdp=initcumsumnipadgdp-in2cumsumnipadgdp;
gen cumin2recsty=initcumsumrecsty-in2cumsumrecsty;
gen cumin2recmonth=initcumsumrecmonth-in2cumsumrecmonth;
gen cumin2expansion=initcumsumexpansion-in2cumsumexpansion;
gen cumin2nipadgdp_pos=initcumsumnipadgdp_pos-in2cumsumnipadgdp_pos;
gen cumin2nipadgdp_nsq2=initcumsumnipadgdp_nsq2-in2cumsumnipadgdp_nsq2;
gen cumin2lnRsqmkt=initcumsumlnRsqmkt-in2cumsumlnRsqmkt;
gen cumin2nipadgdp_neg=initcumsumnipadgdp_neg-in2cumsumnipadgdp_neg;
gen cumin2unemp=initcumsumunemp-in2cumsumunemp;




drop inityear                  in1year               in2year                curryear;
drop initcumsumlnRmkt          in1cumsumlnRmkt       in2cumsumlnRmkt        currcumsumlnRmkt;
drop initcumsumlnvolRmkt         in1cumsumlnvolRmkt      in2cumsumlnvolRmkt       currcumsumlnvolRmkt;
drop initcumsumlnRpeople       in1cumsumlnRpeople    in2cumsumlnRpeople     currcumsumlnRpeople;
drop initcumsumlnR2people      in1cumsumlnR2people   in2cumsumlnR2people    currcumsumlnR2people;
drop initcumsumnipadgdp        in1cumsumnipadgdp     in2cumsumnipadgdp      currcumsumnipadgdp;
drop initcumsumrecsty          in1cumsumrecsty       in2cumsumrecsty        currcumsumrecsty;
drop initcumsumrecmonth          in1cumsumrecmonth       in2cumsumrecmonth        currcumsumrecmonth;
drop initcumsumexpansion       in1cumsumexpansion    in2cumsumexpansion     currcumsumexpansion;
drop initcumsumunemp           in1cumsumunemp        in2cumsumunemp         currcumsumunemp;
drop initcumsumnipadgdp_pos    in1cumsumnipadgdp_pos in2cumsumnipadgdp_pos  currcumsumnipadgdp_pos;
drop initcumsumnipadgdp_nsq2    in1cumsumnipadgdp_nsq2 in2cumsumnipadgdp_nsq2  currcumsumnipadgdp_nsq2;
drop initcumsumnipadgdp_neg    in1cumsumnipadgdp_neg in2cumsumnipadgdp_neg  currcumsumnipadgdp_neg;
drop initcumsumlnRsqmkt    in1cumsumlnRsqmkt in2cumsumlnRsqmkt  currcumsumlnRsqmkt;

sort year;

save "$startdir/$outputdata\natcohortswconditionsOLD$control", replace;

!erase "$startdir/$outputdata\natreturnscumsum.dta";
!erase "$startdir/$outputdata\natreturnscurrcumsum.dta";
!erase "$startdir/$outputdata\natreturnsinitcumsum.dta";
!erase "$startdir/$outputdata\natcohortswconditions.dta";



