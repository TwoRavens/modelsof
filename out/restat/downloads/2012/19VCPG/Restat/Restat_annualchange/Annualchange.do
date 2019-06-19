/*** 
		Jesper Roine and Daniel Waldenström, 
"Common Trends and Breaks in Top Incomes: A Structural Breaks Approach"
		Review of Economics and Statistics


** Country-specific break trends: generating graphs

** Generate break trend dataset

use QP_long2.dta, clear
keep year *pred
sort year
save anchange.dta, replace

use BP_new2_top1.dta, clear
keep year *pred
sort year
save anchange2.dta, replace

use BP_new2_top1_extra.dta, clear
keep year *pred
sort year
save anchange3.dta, replace

use QP_postwar2.dta, clear
keep year *pred
sort year
save anchange4.dta, replace

use BP_new2_top1_cg.dta, clear
keep year *cgpred
sort year
save anchange5.dta, replace

use anchange.dta, clear
sort year
merge year using anchange2.dta
drop _merge
sort year
merge year using anchange3.dta
drop _merge
sort year
merge year using anchange4.dta
drop _merge
sort year
merge year using anchange5.dta
drop _merge
save annualchange.dta, replace


*** 
use annualchange.dta, clear
log using annualchange.log, replace

list year allpred if year == 1903 | year == 1944 | year == 1945 | year == 1979 | year == 1980 | year == 2006
list year allpwpred if year == 1950 | year == 1982 | year == 1983 | year == 2006
list year anglopred if year == 1920 | year == 1936 | year == 1937 | year == 1952 | year == 1953 | year == 1981 | year == 1982 | year == 2005
list year anglopwpred if year == 1950 | year == 1973 | year == 1974 | year == 1986 | year == 1987 | year == 2005
list year contpred if year == 1920 | year == 1942 | year == 1943 | year == 1973 | year == 1974 | year == 1999
list year contpwpred if year == 1950 | year == 1967 | year == 1968 | year == 1980 | year == 1981 | year == 1996
list year nordicpred if year == 1920 | year == 1938 | year == 1939 | year == 1960 | year == 1961 | year == 1990 | year == 1991 | year == 2004
list year nordicpwpred if year == 1950 | year == 1964 | year == 1965 | year == 1980 | year == 1981 | year == 1991 | year == 1992 | year == 2004
list year asiapred if year == 1922 | year == 1944 | year == 1945 | year == 1958 | year == 1959 | year == 1982 | year == 1983 | year == 2005
list year asiapwpred if year == 1950 | year == 1960 | year == 1961 | year == 1973 | year == 1974 | year == 1983 | year == 1984 | year == 2005
list year aus99pred if year == 1950 | year == 1984 | year == 1985 | year == 2002
list year can99pred if year == 1950 | year == 1976 | year == 1977 | year == 1993 | year == 1994 | year == 2000
list year fin99pred if year == 1950 | year == 1970 | year == 1971 | year == 1983 | year == 1984 | year == 1996 | year == 1997 | year == 2004
list year fra99pred if year == 1950 | year == 1959 | year == 1960 | year == 1981 | year == 1982 | year == 1989 | year == 1990 | year == 1997 | year == 1998 | year == 2005
list year gerpred if year == 1950 | year == 1959 | year == 1960 | year == 1986 | year == 1987 | year == 1998
list year ind99pred if year == 1950 | year == 1970 | year == 1971 | year == 1982 | year == 1983 | year == 1999
list year irl01pred if year == 1950 | year == 1978 | year == 1979 | year == 1985 | year == 1986 | year == 2000
list year jap99pred if year == 1950 | year == 1973 | year == 1974 | year == 2005
list year net99pred if year == 1950 | year == 1968 | year == 1969 | year == 1975 | year == 1976 | year == 1999
list year nze99pred if year == 1950 | year == 1988 | year == 1989 | year == 2005
list year nor99pred if year == 1950 | year == 1992 | year == 1993 | year == 2006
list year por01pred if year == 1950 | year == 1970 | year == 1971 | year == 1980 | year == 1981 | year == 1989 | year == 1990 | year == 2003
list year sin99pred if year == 1950 | year == 1969 | year == 1970 | year == 1997 | year == 1998 | year == 2005
list year esp01pred if year == 1954 | year == 1960 | year == 1961 | year == 1973 | year == 1974 | year == 1985 | year == 1986 | year == 1997 | year == 1998 | year == 2005
list year swe99pred if year == 1950 | year == 1967 | year == 1968 | year == 1980 | year == 1981 | year == 1990 | year == 1991 | year == 2006
list year che99pred if year == 1950 | year == 1972 | year == 1973 | year == 1996
list year uk99pred if year == 1950 | year == 1959 | year == 1960 | year == 1977 | year == 1978 | year == 1995 | year == 1996 | year == 2005
list year us99pred if year == 1950 | year == 1962 | year == 1963 | year == 1977 | year == 1978 | year == 1987 | year == 1988 | year == 1996 | year == 1997 | year == 2006
list year cancgpred if year == 1950 | year == 1982 | year == 1983 | year == 1989 | year == 1990 | year == 2000
list year fin_cgpred if year == 1950 | year == 1970 | year == 1971 | year == 1983 | year == 1984 | year == 1996 | year == 1997 | year == 2004
list year gercgpred if year == 1950 | year == 1959 | year == 1960 | year == 1973 | year == 1974 | year == 1998
list year esp01cgpred if year == 1954 | year == 1961 | year == 1962 | year == 1985 | year == 1986 | year == 1993 | year == 1994 | year == 2005
list year swe_cgpred if year == 1950 | year == 1967 | year == 1968 | year == 1990 | year == 1991 | year == 2006
list year us_cgpred if year == 1950 | year == 1978 | year == 1979 | year == 2006

log close
