
*** Cold War Model ***


heckman lnEcAidk  GDP_lg1 BilTrade_lg1 polity2_lg1 HR_PTS_lg2 lnpop /*
*/ td1978 td1979 td1980 td1981 td1982 td1983 td1984 td1985 td1986 td1987 td1988 td1989 td1990 if year <1991, /*
*/ select(passgate = GDP_lg1 BilTrade_lg1 polity2_lg1 HR_PTS_lg2 lnpop tau_lead_lg1 AidlessYrsCW CWspline*) cluster(ccode)



*** Post Cold War Model ***


heckman lnEcAidk GDP_lg1 BilTrade_lg1 polity2_lg1 HR_PTS_lg2 lnpop /*
*/ td1992 td1993 td1994 td1995 td1996 td1997 td1998 td1999 td2000 td2001 td2002 td2003 td2004 if year >1990, /*
*/ select(passgate = GDP_lg1 BilTrade_lg1 polity2_lg1 HR_PTS_lg2 lnpop tau_lead_lg1 AidlessYrsPCW PCWspline*) cluster(ccode)




*** -- without Israel included --  ***
***  Appendix Tables II, III (column 2s and 5) 
 ** Cold War Model ***


heckman lnEcAidk  GDP_lg1 BilTrade_lg1 polity2_lg1 HR_PTS_lg2 lnpop /*
*/ td1978 td1979 td1980 td1981 td1982 td1983 td1984 td1985 td1986 td1987 td1988 td1989 td1990 if year <1991 & ccode!=666, /*
*/ select(passgate = GDP_lg1 BilTrade_lg1 polity2_lg1 HR_PTS_lg2 lnpop tau_lead_lg1 AidlessYrsCW CWspline*) cluster(ccode)



 ** Post Cold War Model ***

* A
heckman lnEcAidk GDP_lg1 BilTrade_lg1 polity2_lg1 HR_PTS_lg2 lnpop /*
*/ td1992 td1993 td1994 td1995 td1996 td1997 td1998 td1999 td2000 td2001 td2002 td2003 td2004 if year >1990 & ccode!=666, /*
*/ select(passgate = GDP_lg1 BilTrade_lg1 polity2_lg1 HR_PTS_lg2 lnpop tau_lead_lg1 AidlessYrsPCW PCWspline*) cluster(ccode)


*** -- with CIRI data in place of PTS --  ***
*** Appendix Tables II, III (columns 3 and 6)
 ** Cold War Model ***


heckman lnEcAidk  GDP_lg1 BilTrade_lg1 polity2_lg1 HR_CIRI_lg2 lnpop /*
*/ td1978 td1979 td1980 td1981 td1982 td1983 td1984 td1985 td1986 td1987 td1988 td1989 td1990 if year <1991, /*
*/ select(passgate = GDP_lg1 BilTrade_lg1 polity2_lg1 HR_CIRI_lg2 lnpop tau_lead_lg1 AidlessYrsCW CWspline*) cluster(ccode)



*** Post Cold War Model with CIRI***

* A
heckman lnEcAidk GDP_lg1 BilTrade_lg1 polity2_lg1 HR_CIRI_lg2 lnpop /*
*/ td1992 td1993 td1994 td1995 td1996 td1997 td1998 td1999 td2000 td2001 td2002 td2003 td2004 if year >1990, /*
*/ select(passgate = GDP_lg1 BilTrade_lg1 polity2_lg1 HR_CIRI_lg2 lnpop tau_lead_lg1 AidlessYrsPCW PCWspline*) cluster(ccode)



*** commands relating to Table A-IV ***

* original post Cold War model folowed by test of post 9/11 era...

heckman lnEcAidk GDP_lg1 BilTrade_lg1 polity2_lg1 HR_PTS_lg2 lnpop /*
*/ td1992 td1993 td1994 td1995 td1996 td1997 td1998 td1999 td2000 td2001 td2002 td2003 td2004 if year >1990, /*
*/ select(passgate = GDP_lg1 BilTrade_lg1 polity2_lg1 HR_PTS_lg2 lnpop tau_lead_lg1 AidlessYrsPCW PCWspline*) cluster(ccode)

*joint significance test of post 9/11, post Col War years
test td2002 td2003 td2004


* Model Run on Post 9/11 era only
heckman lnEcAidk GDP_lg1 BilTrade_lg1 polity2_lg1 HR_PTS_lg2 lnpop /*
*/ td2003 td2004 if year >2001, /*
*/ select(passgate = GDP_lg1 BilTrade_lg1 polity2_lg1 HR_PTS_lg2 lnpop tau_lead_lg1 AidlessYrsPCW PCWspline*) cluster(ccode)

* Model Run on PCW, pre-9/11 years
heckman lnEcAidk GDP_lg1 BilTrade_lg1 polity2_lg1 HR_PTS_lg2 lnpop /*
*/ td1992 td1993 td1994 td1995 td1996 td1997 td1998 td1999 td2000 if year >1990 & year< 2001, /*
*/ select(passgate = GDP_lg1 BilTrade_lg1 polity2_lg1 HR_PTS_lg2 lnpop tau_lead_lg1 AidlessYrsPCW PCWspline*) cluster(ccode)


