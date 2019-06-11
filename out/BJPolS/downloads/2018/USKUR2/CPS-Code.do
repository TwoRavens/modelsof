
** APPENDIX A **	
* TABLE A1, margins (used in Fig. 3) *
	foreach i in 1974 1990 1992 1994 1996 1998 2000 2002 2004 2006 2008 2010 2012 2014{

probit vote unem_lf  weeks weeks2  income ed2  age age2   ageunmar sex south black  student   if year==`i'
	outreg2 using prob-w.xls,  ctitle(`i')
	margins,dydx(unem_lf)
	}
	
	
	
	
		foreach i in 1976 1978 1980 1982 1984 1986 {

probit vote unem_lf xrate weeks  income ed2  age age2   ageunmar sex south black  student   if year==`i'
	outreg2 using prob-cat.xls,  ctitle(`i')
	margins,dydx(unem_lf)
	}
	
* Truncated Weeks *
gen weekst=weeks
replace weekst=52 if weekst>52
gen weekst2=weekst*weekst

	foreach i in 1974 1990 1992 1994 1996 1998 2000 2002 2004 2006 2008 2010 2012 2014{

probit vote unem_lf  weekst weekst2  income ed2  age age2   ageunmar sex south black  student   if year==`i'
	outreg2 using prob-trunc.xls,  ctitle(`i')
	}
	

* Logged Specification *
gen lnweeks=log(weeks+1)
	foreach i in 1974 1990 1992 1994 1996 1998 2000 2002 2004 2006 2008 2010 2012 2014{

probit vote unem_lf  lnweeks  income ed2  age age2   ageunmar sex south black  student   if year==`i'
	outreg2 using prob-logg.xls,  ctitle(`i')
	}
	
* Logged, Truncated *
gen lnweekst=log(weekst+1)
	foreach i in 1974 1990 1992 1994 1996 1998 2000 2002 2004 2006 2008 2010 2012 2014{

probit vote unem_lf  lnweeks  income ed2  age age2   ageunmar sex south black  student   if year==`i'
	outreg2 using prob-logg-trunc.xls,  ctitle(`i')
	}
	


** APPENDIX B **
* TABLE B1 *

	foreach i in 1974 1990 1992  2002  2010  2014{

probit vote unem_lf xrate weeks weeks2  income ed2  age age2   ageunmar sex south black  student   if year==`i'
	outreg2 using unob-w2.xls,  ctitle(`i')
	}
	
	
	
	
		foreach i in 1976 1978  1982 1984 1986 {

probit vote unem_lf xrate weeks  income ed2  age age2   ageunmar sex south black  student   if year==`i'
	outreg2 using unob-cat2.xls,  ctitle(`i')
	}
	
	
** APPENDIX D **
* TABLE D1 *
*gen weeksun=weeks*unrate
*gen weekscatun=weekscat*unrate
probit vote unem_lf weekscat weekscatun incterc edterc  age age2   ageunmar sex south black  student i.year, cluster(year)
