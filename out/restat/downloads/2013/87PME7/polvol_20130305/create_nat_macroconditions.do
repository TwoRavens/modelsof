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
clear; capture clear matrix;


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
***we have more data than we actually use;
egen meannipa=mean(nipadgdp) if year>1910 & year<2006;
gen nipadgdp_nsq2=(nipadgdp-meannipa)^2;

save "$startdir/$outputdata\natmacroconditions", replace;
