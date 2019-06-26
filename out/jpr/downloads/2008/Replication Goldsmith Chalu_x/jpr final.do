

****1, 2

#del;

set more off;

xtgee  fcwfataldinit lowdemst lnlowdep lnnumigofill contigland  majmaj  lndistance 
	lnparity   if year > 1885 & year < 2001 & rgroups <6, 
      family(binomial) link(logit) corr(ar1) force robust nolog;


#del;

xtgee  fcwfataldinit lowdemst hidemst  lnnumigofill contigland  majmaj  lndistance 
	lnparity   if year > 1885 & year < 2001 & rgroups <6, 
      family(binomial) link(logit) corr(ar1) force robust nolog;


****3, 4

#del;

set more off;

xtgee  fcwfataldinit jntdem poldisabst lnlowdep lnnumigofill contigland  majmaj  lndistance 
	lnparity   if year > 1885 & year < 2001 & rgroups <6, 
      family(binomial) link(logit) corr(ar1) force robust nolog;


#del;

xtgee  fcwfataldinit jntdem poldisabst  lnnumigofill contigland  majmaj  lndistance 
	lnparity   if year > 1885 & year < 2001 & rgroups <6, 
      family(binomial) link(logit) corr(ar1) force robust nolog;



*****5, 6



#del;

xtgee  fcwfataldinit jntdem jntaut lnlowdep lnnumigofill contigland  majmaj  lndistance 
	lnparity   if year > 1885 & year < 2001 & rgroups <6, 
      family(binomial) link(logit) corr(ar1) force robust nolog;


#del;

xtgee  fcwfataldinit jntdem jntaut lnnumigofill contigland  majmaj  lndistance 
	lnparity   if year > 1885 & year < 2001 & rgroups <6, 
      family(binomial) link(logit) corr(ar1) force robust nolog;


*****7, 8


#del;

xtgee  fcwfataldinit jntdemint poldisabst lnlowdep lnnumigofill contigland  majmaj  lndistance 
	lnparity   if year > 1885 & year < 2001 & rgroups <6, 
      family(binomial) link(logit) corr(ar1) force robust nolog;


#del;

xtgee  fcwfataldinit jntdem polsim3 lnlowdep lnnumigofill contigland  majmaj  lndistance 
	lnparity   if year > 1885 & year < 2001 & rgroups <6, 
      family(binomial) link(logit) corr(ar1) force robust nolog;



*****9, 10


#del;

xtgee  fcwfataldinit jntdem jntaut jntanoc lnlowdep lnnumigofill contigland  majmaj  lndistance 
	lnparity   if year > 1885 & year < 2001 & rgroups <6, 
      family(binomial) link(logit) corr(ar1) force robust nolog;


#del;

xtgee  fcwfataldinit jntdem jntaut polsim3 lnlowdep lnnumigofill contigland  majmaj  lndistance 
	lnparity   if year > 1885 & year < 2001 & rgroups <6, 
      family(binomial) link(logit) corr(ar1) force robust nolog;


