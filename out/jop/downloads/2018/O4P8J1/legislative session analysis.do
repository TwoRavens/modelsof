	**********************************************************************
	* Inter-regional Inequality and the Dynamics of Government Spending 
	* Online Appendix -- Section 8. Sample Selection and Sensitivity
	**********************************************************************
	clear all
	set more off 
	set mem 600m
	cd "YOUR_DIRECTORY_PATH_HERE\supplements (online appendix)\appendix n"
	use "onlineappendix.dta"   

 	*************************************
	** Rescaling / Modifying Variables                              
	*************************************
	sort id year 
	sum ideal_pt_V1, meanonly
	gen jacoby_modified2 = ideal_pt_V1 - `r(mean)'
	replace adgini = adgini*100
	replace jacoby_modified2 = jacoby_modified2*100
	replace ineq_spns = ineq_spns*100
	gen log_pop = log(pop)	
	gen log_rgdpch = log(rgdpch)
	gen pop14_65 = popunder14 + popover65
	
	**********************************************************************************************
	** Lower House Legislative Election Date (Comparative Political Dataset I by Armingeon, et al.)
	**********************************************************************************************
	* Australia
	gen legislature_year = .
	replace legislature_year = 1  if year >=1980 & year<=1982 & countries=="Australia"
	replace legislature_year = 2  if year ==1983              & countries=="Australia"
	replace legislature_year = 3  if year >=1984 & year<=1986 & countries=="Australia"
	replace legislature_year = 4  if year >=1987 & year<=1989 & countries=="Australia"
	replace legislature_year = 5  if year >=1990 & year<=1992 & countries=="Australia"
	replace legislature_year = 6  if year >=1993 & year<=1995 & countries=="Australia"
	replace legislature_year = 7  if year >=1996 & year<=1997 & countries=="Australia"
	replace legislature_year = 8  if year >=1998 & year<=2000 & countries=="Australia"
	replace legislature_year = 9  if year >=2001 & year<=2003 & countries=="Australia"
	replace legislature_year = 10 if year >=2004 & year<=2006 & countries=="Australia"
	replace legislature_year = 11 if year >=2007 & year<=2009 & countries=="Australia"
	replace legislature_year = 12 if year >=2010 & year<=2011 & countries=="Australia"
	
	* Austria
	replace legislature_year = 1  if year >=1980 & year<=1982 & countries=="Austria"
	replace legislature_year = 2  if year >=1983 & year<=1985 & countries=="Austria"
	replace legislature_year = 3  if year >=1986 & year<=1989 & countries=="Austria"
	replace legislature_year = 4  if year >=1990 & year<=1993 & countries=="Austria"
	replace legislature_year = 5  if year ==1994              & countries=="Austria"
	replace legislature_year = 6  if year >=1995 & year<=1998 & countries=="Austria"
	replace legislature_year = 7  if year >=1999 & year<=2001 & countries=="Austria"
	replace legislature_year = 8  if year >=2002 & year<=2005 & countries=="Austria"
	replace legislature_year = 9  if year >=2006 & year<=2007 & countries=="Austria"
	replace legislature_year = 10 if year >=2008 & year<=2011 & countries=="Austria"
	
	* Belgium 
	replace legislature_year = 1  if year ==1980              & countries=="Belgium"
	replace legislature_year = 2  if year >=1981 & year<=1984 & countries=="Belgium"
	replace legislature_year = 3  if year >=1985 & year<=1986 & countries=="Belgium"
	replace legislature_year = 4  if year >=1987 & year<=1990 & countries=="Belgium"
	replace legislature_year = 5  if year >=1991 & year<=1994 & countries=="Belgium"
	replace legislature_year = 6  if year >=1995 & year<=1998 & countries=="Belgium"
	replace legislature_year = 7  if year >=1999 & year<=2002 & countries=="Belgium"
	replace legislature_year = 8  if year >=2003 & year<=2006 & countries=="Belgium"
	replace legislature_year = 9  if year >=2007 & year<=2009 & countries=="Belgium"
	replace legislature_year = 10 if year >=2010 & year<=2011 & countries=="Belgium"
	
	* Czech Republic
	replace legislature_year = 1  if year >=1990 & year<=1991 & countries=="Czech Republic"
	replace legislature_year = 2  if year >=1992 & year<=1995 & countries=="Czech Republic"
	replace legislature_year = 3  if year >=1996 & year<=1997 & countries=="Czech Republic"
	replace legislature_year = 4  if year >=1998 & year<=2001 & countries=="Czech Republic"
	replace legislature_year = 5  if year >=2002 & year<=2005 & countries=="Czech Republic"
	replace legislature_year = 6  if year >=2006 & year<=2009 & countries=="Czech Republic"
	replace legislature_year = 7  if year >=2010 & year<=2011 & countries=="Czech Republic"

	* Denmark 
	replace legislature_year = 1  if year ==1980              & countries=="Denmark"
	replace legislature_year = 2  if year >=1981 & year<=1983 & countries=="Denmark"
	replace legislature_year = 3  if year >=1984 & year<=1986 & countries=="Denmark"
	replace legislature_year = 4  if year ==1987              & countries=="Denmark"
	replace legislature_year = 5  if year >=1988 & year<=1989 & countries=="Denmark"
	replace legislature_year = 6  if year >=1990 & year<=1993 & countries=="Denmark"
	replace legislature_year = 7  if year >=1994 & year<=1997 & countries=="Denmark"
	replace legislature_year = 8  if year >=1998 & year<=2000 & countries=="Denmark"
	replace legislature_year = 9  if year >=2001 & year<=2004 & countries=="Denmark"
	replace legislature_year = 10 if year >=2005 & year<=2006 & countries=="Denmark"
    replace legislature_year = 11 if year >=2007 & year<=2010 & countries=="Denmark"
    replace legislature_year = 12 if year ==2011              & countries=="Denmark"	
	
	* Finland
	replace legislature_year = 1  if year >=1980 & year<=1982 & countries=="Finland"
	replace legislature_year = 2  if year >=1983 & year<=1986 & countries=="Finland"
	replace legislature_year = 3  if year >=1987 & year<=1990 & countries=="Finland"
	replace legislature_year = 4  if year >=1991 & year<=1994 & countries=="Finland"
	replace legislature_year = 5  if year >=1995 & year<=1998 & countries=="Finland"
	replace legislature_year = 6  if year >=1999 & year<=2002 & countries=="Finland"
	replace legislature_year = 7  if year >=2003 & year<=2006 & countries=="Finland"
	replace legislature_year = 8  if year >=2007 & year<=2010 & countries=="Finland"
	replace legislature_year = 9  if year ==2011              & countries=="Finland"

	* France
	replace legislature_year = 1  if year ==1980              & countries=="France"
	replace legislature_year = 2  if year >=1981 & year<=1985 & countries=="France"
	replace legislature_year = 3  if year >=1986 & year<=1987 & countries=="France"
	replace legislature_year = 4  if year >=1988 & year<=1992 & countries=="France"
	replace legislature_year = 5  if year >=1993 & year<=1996 & countries=="France"
	replace legislature_year = 6  if year >=1997 & year<=2001 & countries=="France"
	replace legislature_year = 7  if year >=2002 & year<=2006 & countries=="France"
	replace legislature_year = 8  if year >=2007 & year<=2011 & countries=="France"
	
	* Germany 
	replace legislature_year = 1  if year >=1980 & year<=1982 & countries=="Germany"
	replace legislature_year = 2  if year >=1983 & year<=1986 & countries=="Germany"
	replace legislature_year = 3  if year >=1987 & year<=1989 & countries=="Germany"
	replace legislature_year = 4  if year >=1990 & year<=1993 & countries=="Germany"
	replace legislature_year = 5  if year >=1994 & year<=1997 & countries=="Germany"
	replace legislature_year = 6  if year >=1998 & year<=2001 & countries=="Germany"
	replace legislature_year = 7  if year >=2002 & year<=2004 & countries=="Germany"
	replace legislature_year = 8  if year >=2005 & year<=2008 & countries=="Germany"
	replace legislature_year = 9  if year >=2009 & year<=2011 & countries=="Germany"
	
	* Greece
	replace legislature_year = 1  if year ==1980              & countries=="Greece"
	replace legislature_year = 2  if year >=1981 & year<=1984 & countries=="Greece"
	replace legislature_year = 3  if year >=1985 & year<=1988 & countries=="Greece"
	replace legislature_year = 4  if year ==1989              & countries=="Greece"
	replace legislature_year = 5  if year >=1990 & year<=1992 & countries=="Greece"
	replace legislature_year = 6  if year >=1993 & year<=1995 & countries=="Greece"
	replace legislature_year = 7  if year >=1996 & year<=1999 & countries=="Greece"
	replace legislature_year = 8  if year >=2000 & year<=2003 & countries=="Greece"
	replace legislature_year = 9  if year >=2004 & year<=2006 & countries=="Greece"	
	replace legislature_year = 10 if year >=2007 & year<=2008 & countries=="Greece"
	replace legislature_year = 11 if year >=2009 & year<=2011 & countries=="Greece"
	
	* Hungary 
	replace legislature_year = 1  if year >=1990 & year<=1993 & countries=="Hungary"
	replace legislature_year = 2  if year >=1994 & year<=1997 & countries=="Hungary"
	replace legislature_year = 3  if year >=1998 & year<=2001 & countries=="Hungary"
	replace legislature_year = 4  if year >=2002 & year<=2005 & countries=="Hungary"
	replace legislature_year = 5  if year >=2006 & year<=2009 & countries=="Hungary"
	replace legislature_year = 6  if year >=2010 & year<=2011 & countries=="Hungary"

	* Ireland 
	replace legislature_year = 1  if year ==1980              & countries=="Ireland"
	replace legislature_year = 2  if year ==1981              & countries=="Ireland"
	replace legislature_year = 3  if year >=1982 & year<=1986 & countries=="Ireland"
	replace legislature_year = 4  if year >=1987 & year<=1988 & countries=="Ireland"
	replace legislature_year = 5  if year >=1989 & year<=1991 & countries=="Ireland"
	replace legislature_year = 6  if year >=1992 & year<=1996 & countries=="Ireland"
	replace legislature_year = 7  if year >=1997 & year<=2001 & countries=="Ireland"
	replace legislature_year = 8  if year >=2002 & year<=2006 & countries=="Ireland"
	replace legislature_year = 9  if year >=2007 & year<=2010 & countries=="Ireland"	
	replace legislature_year = 10 if year ==2011              & countries=="Ireland"
	
	* Italy 
	replace legislature_year = 1  if year >=1980 & year<=1982 & countries=="Italy"
	replace legislature_year = 2  if year >=1983 & year<=1986 & countries=="Italy"
	replace legislature_year = 3  if year >=1987 & year<=1991 & countries=="Italy"
	replace legislature_year = 4  if year >=1992 & year<=1993 & countries=="Italy"
	replace legislature_year = 5  if year >=1994 & year<=1995 & countries=="Italy"
	replace legislature_year = 6  if year >=1996 & year<=2000 & countries=="Italy"
	replace legislature_year = 7  if year >=2001 & year<=2005 & countries=="Italy"
	replace legislature_year = 8  if year >=2006 & year<=2007 & countries=="Italy"
	replace legislature_year = 9  if year >=2008 & year<=2011 & countries=="Italy"	
	
    * Japan
	replace legislature_year = 1  if year >=1980 & year<=1982 & countries=="Japan"
	replace legislature_year = 2  if year >=1983 & year<=1985 & countries=="Japan"
	replace legislature_year = 3  if year >=1986 & year<=1989 & countries=="Japan"
	replace legislature_year = 4  if year >=1990 & year<=1992 & countries=="Japan"
	replace legislature_year = 5  if year >=1993 & year<=1995 & countries=="Japan"
	replace legislature_year = 6  if year >=1996 & year<=1999 & countries=="Japan"
	replace legislature_year = 7  if year >=2000 & year<=2002 & countries=="Japan"
	replace legislature_year = 8  if year >=2003 & year<=2004 & countries=="Japan"
	replace legislature_year = 9  if year >=2005 & year<=2008 & countries=="Japan"
    replace legislature_year = 10 if year >=2009 & year<=2011 & countries=="Japan"

    * Netherlands 
	replace legislature_year = 1  if year ==1980              & countries=="Netherlands"
	replace legislature_year = 2  if year ==1981              & countries=="Netherlands"
	replace legislature_year = 3  if year >=1982 & year<=1985 & countries=="Netherlands"
	replace legislature_year = 4  if year >=1986 & year<=1988 & countries=="Netherlands"
	replace legislature_year = 5  if year >=1989 & year<=1993 & countries=="Netherlands"
	replace legislature_year = 6  if year >=1994 & year<=1997 & countries=="Netherlands"
	replace legislature_year = 7  if year >=1998 & year<=2001 & countries=="Netherlands"
	replace legislature_year = 8  if year ==2002              & countries=="Netherlands"
	replace legislature_year = 9  if year >=2003 & year<=2005 & countries=="Netherlands"
    replace legislature_year = 10 if year >=2006 & year<=2009 & countries=="Netherlands"
    replace legislature_year = 11 if year >=2010 & year<=2011 & countries=="Netherlands"

    * Norway
	replace legislature_year = 1  if year ==1980              & countries=="Norway"
	replace legislature_year = 2  if year >=1981 & year<=1984 & countries=="Norway"
	replace legislature_year = 3  if year >=1985 & year<=1988 & countries=="Norway"
	replace legislature_year = 4  if year >=1989 & year<=1992 & countries=="Norway"
	replace legislature_year = 5  if year >=1993 & year<=1996 & countries=="Norway"
	replace legislature_year = 6  if year >=1997 & year<=2000 & countries=="Norway"
	replace legislature_year = 7  if year >=2001 & year<=2004 & countries=="Norway"
	replace legislature_year = 8  if year >=2005 & year<=2008 & countries=="Norway"
	replace legislature_year = 9  if year >=2009 & year<=2011 & countries=="Norway"

    * Poland
	replace legislature_year = 1  if year ==1990              & countries=="Poland"
	replace legislature_year = 2  if year >=1991 & year<=1992 & countries=="Poland"
	replace legislature_year = 3  if year >=1993 & year<=1996 & countries=="Poland"
	replace legislature_year = 4  if year >=1997 & year<=2000 & countries=="Poland"
	replace legislature_year = 5  if year >=2001 & year<=2004 & countries=="Poland"
	replace legislature_year = 6  if year >=2005 & year<=2006 & countries=="Poland"
	replace legislature_year = 7  if year >=2007 & year<=2010 & countries=="Poland"
	replace legislature_year = 8  if year ==2011              & countries=="Poland"
    	
    * Portugal
 	replace legislature_year = 1  if year >=1980 & year<=1982 & countries=="Portugal"
	replace legislature_year = 2  if year >=1983 & year<=1984 & countries=="Portugal"
	replace legislature_year = 3  if year >=1985 & year<=1986 & countries=="Portugal"
	replace legislature_year = 4  if year >=1987 & year<=1990 & countries=="Portugal"
	replace legislature_year = 5  if year >=1991 & year<=1994 & countries=="Portugal"
	replace legislature_year = 6  if year >=1995 & year<=1998 & countries=="Portugal"
	replace legislature_year = 7  if year >=1999 & year<=2001 & countries=="Portugal"
	replace legislature_year = 8  if year >=2002 & year<=2004 & countries=="Portugal"
	replace legislature_year = 9  if year >=2005 & year<=2008 & countries=="Portugal"
    replace legislature_year = 10 if year >=2009 & year<=2010 & countries=="Portugal"
    replace legislature_year = 11 if year ==2011              & countries=="Portugal"   	
	
	* Slovak Republic 
	replace legislature_year = 1  if year >=1990 & year<=1991 & countries=="Slovak Republic"
	replace legislature_year = 2  if year >=1992 & year<=1993 & countries=="Slovak Republic"
	replace legislature_year = 3  if year >=1994 & year<=1997 & countries=="Slovak Republic"
	replace legislature_year = 4  if year >=1998 & year<=2001 & countries=="Slovak Republic"
	replace legislature_year = 5  if year >=2002 & year<=2005 & countries=="Slovak Republic"
	replace legislature_year = 6  if year >=2006 & year<=2009 & countries=="Slovak Republic"
	replace legislature_year = 7  if year >=2010 & year<=2011 & countries=="Slovak Republic"
	
	* Slovenia
	replace legislature_year = 1  if year >=1990 & year<=1991 & countries=="Slovenia"
	replace legislature_year = 2  if year >=1992 & year<=1995 & countries=="Slovenia"
	replace legislature_year = 3  if year >=1996 & year<=1999 & countries=="Slovenia"
	replace legislature_year = 4  if year >=2000 & year<=2003 & countries=="Slovenia"
	replace legislature_year = 5  if year >=2004 & year<=2007 & countries=="Slovenia"
	replace legislature_year = 6  if year >=2008 & year<=2010 & countries=="Slovenia"
	replace legislature_year = 7  if year ==2011              & countries=="Slovenia"
		
    * Spain
   	replace legislature_year = 1  if year >=1980 & year<=1981 & countries=="Spain"
	replace legislature_year = 2  if year >=1982 & year<=1985 & countries=="Spain"
	replace legislature_year = 3  if year >=1986 & year<=1988 & countries=="Spain"
	replace legislature_year = 4  if year >=1989 & year<=1992 & countries=="Spain"
	replace legislature_year = 5  if year >=1993 & year<=1995 & countries=="Spain"
	replace legislature_year = 6  if year >=1996 & year<=1999 & countries=="Spain"
	replace legislature_year = 7  if year >=2000 & year<=2003 & countries=="Spain"
	replace legislature_year = 8  if year >=2004 & year<=2007 & countries=="Spain"
	replace legislature_year = 9  if year >=2008 & year<=2010 & countries=="Spain"
    replace legislature_year = 10 if year ==2011              & countries=="Spain"

    * Sweden 
 	replace legislature_year = 1  if year >=1980 & year<=1981 & countries=="Sweden"
	replace legislature_year = 2  if year >=1982 & year<=1984 & countries=="Sweden"
	replace legislature_year = 3  if year >=1985 & year<=1987 & countries=="Sweden"
	replace legislature_year = 4  if year >=1988 & year<=1990 & countries=="Sweden"
	replace legislature_year = 5  if year >=1991 & year<=1993 & countries=="Sweden"
	replace legislature_year = 6  if year >=1994 & year<=1997 & countries=="Sweden"
	replace legislature_year = 7  if year >=1998 & year<=2001 & countries=="Sweden"
	replace legislature_year = 8  if year >=2002 & year<=2005 & countries=="Sweden"
	replace legislature_year = 9  if year >=2006 & year<=2009 & countries=="Sweden"
    replace legislature_year = 10 if year >=2010 & year<=2011 & countries=="Sweden"
	   	
	* Switzerland
 	replace legislature_year = 1  if year >=1980 & year<=1982 & countries=="Switzerland"
	replace legislature_year = 2  if year >=1983 & year<=1986 & countries=="Switzerland"
	replace legislature_year = 3  if year >=1987 & year<=1990 & countries=="Switzerland"
	replace legislature_year = 4  if year >=1991 & year<=1994 & countries=="Switzerland"
	replace legislature_year = 5  if year >=1995 & year<=1998 & countries=="Switzerland"
	replace legislature_year = 6  if year >=1999 & year<=2002 & countries=="Switzerland"
	replace legislature_year = 7  if year >=2003 & year<=2006 & countries=="Switzerland"
	replace legislature_year = 8  if year >=2007 & year<=2010 & countries=="Switzerland"
	replace legislature_year = 9  if year ==2011              & countries=="Switzerland"

    * United Kingdom
 	replace legislature_year = 1  if year >=1980 & year<=1982 & countries=="United Kingdom"
	replace legislature_year = 2  if year >=1983 & year<=1986 & countries=="United Kingdom"
	replace legislature_year = 3  if year >=1987 & year<=1991 & countries=="United Kingdom"
	replace legislature_year = 4  if year >=1992 & year<=1996 & countries=="United Kingdom"
	replace legislature_year = 5  if year >=1997 & year<=2000 & countries=="United Kingdom"
	replace legislature_year = 6  if year >=2001 & year<=2004 & countries=="United Kingdom"
	replace legislature_year = 7  if year >=2005 & year<=2009 & countries=="United Kingdom"
	replace legislature_year = 8  if year >=2010 & year<=2011 & countries=="United Kingdom"
	   	
	* United States
	replace legislature_year = 1  if year >=1980 & year<=1981 & countries=="United States"
	replace legislature_year = 2  if year >=1982 & year<=1983 & countries=="United States"
	replace legislature_year = 3  if year >=1984 & year<=1985 & countries=="United States"
	replace legislature_year = 4  if year >=1986 & year<=1987 & countries=="United States"
	replace legislature_year = 5  if year >=1988 & year<=1989 & countries=="United States"
	replace legislature_year = 6  if year >=1990 & year<=1991 & countries=="United States"
	replace legislature_year = 7  if year >=1992 & year<=1993 & countries=="United States"
	replace legislature_year = 8  if year >=1994 & year<=1995 & countries=="United States"
	replace legislature_year = 9  if year >=1996 & year<=1997 & countries=="United States"	
	replace legislature_year = 10 if year >=1998 & year<=1999 & countries=="United States"
	replace legislature_year = 11 if year >=2000 & year<=2001 & countries=="United States"
	replace legislature_year = 12 if year >=2002 & year<=2003 & countries=="United States"
	replace legislature_year = 13 if year >=2004 & year<=2005 & countries=="United States"
	replace legislature_year = 14 if year >=2006 & year<=2007 & countries=="United States"	
	replace legislature_year = 15 if year >=2008 & year<=2009 & countries=="United States"
	replace legislature_year = 16 if year >=2010 & year<=2011 & countries=="United States"

	drop if legislature_year == . 

	collapse(mean) govexp_central_cofog2 jacoby_modified2 ///
	               log_pop pop14_65 a log_rgdpch gov_left2 adgini rpop_s1_rgdppc rgdppc_density ///
				   (max) PR Parl Unit2 (last) year, by(id countries legislature_year)
	
	tsset id legislature_year

 	foreach y of varlist govexp_central_cofog2 jacoby_modified2 ///
	               log_pop pop14_65 a log_rgdpch gov_left2 adgini rpop_s1_rgdppc rgdppc_density ///
				   PR Parl Unit2 {
	bysort id: gen diff_`y' = `y'-`y'[_n-1]
	bysort id: gen lag_`y' = `y'[_n-1]
	}
	
	drop if year<=1990
    tab countries, gen(kcountry_)
	
	***********************
	** Renaming Variables  
	***********************
	rename diff_jacoby_modified2 diff_policy_priority
	rename lag_jacoby_modified2 lag_policy_priority
    rename lag_adgini lag_rdgini
	rename lag_rpop_s1_rgdppc lag_mm_ratio
	rename lag_log_pop lag_population_logged
	rename lag_pop14_65 lag_dependent_population 
	rename lag_a lag_economic_globalization
	rename lag_log_rgdpch lag_ppp_gdppc_logged
	rename lag_gov_left2 lag_leftistgovt
	rename lag_Parl lag_parliamentary
	rename lag_Unit2 lag_nonfed_nonbicam	
	
    ********************************************************************
	* Appendix N. Robust to Country, Legislative Session Panel Data
	********************************************************************
	global baseline lag_population_logged lag_dependent_population lag_economic_globalization lag_ppp_gdppc_logged lag_leftistgovt lag_PR lag_parliamentary lag_nonfed_nonbicam kcountry_*
		
	* Model [1]
	xtgls diff_policy_priority lag_policy_priority lag_rdgini $baseline, noconst panels(hetero)

	* Model [2]
	xtgls diff_policy_priority lag_policy_priority lag_mm_ratio $baseline, noconst panels(hetero)

	* Model [3]
	xtpcse diff_policy_priority lag_policy_priority lag_rdgini $baseline, pairwise noconst corr(psar1)
	
	* Model [4]
	xtpcse diff_policy_priority lag_policy_priority lag_mm_ratio $baseline, pairwise noconst corr(psar1)

	* Model [5]
	xtscc diff_policy_priority lag_policy_priority lag_rdgini $baseline, noconst ase

	* Model [6]
	xtscc diff_policy_priority lag_policy_priority lag_mm_ratio $baseline, noconst ase
