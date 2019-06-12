use hawkdaughter.dta

/* Table 1 regressions */
probit isolate propg age educ female partyid attend south urban veteran income_hh1, r                                            /* Column 1 */
probit isolate hhboyd hhgirld age educ female partyid attend south urban veteran income_hh1, r                                   /* Column 2 */
probit isolate hhboys hhgirls age educ female partyid attend south urban veteran income_hh1, r                                   /* Column 3 */

/* Table 2 regressions */
oprobit interven propg age educ female partyid attend south urban veteran income_hh1, r                                          /* Column 1 */
oprobit interven hhboyd hhgirld age educ female partyid attend south urban veteran income_hh1, r                                 /* Column 2 */
oprobit interven hhboys hhgirls age educ female partyid attend south urban veteran income_hh1, r                                 /* Column 3 */

/* Table 3 regressions */
probit iraqworth propg age educ female partyid attend south urban veteran income_hh1, r                                          /* Column 1 */
probit iraqworth hhboyd hhgirld age educ female partyid attend south urban veteran income_hh1, r                                 /* Column 2 */
probit iraqworth hhboys hhgirls age educ female partyid attend south urban veteran income_hh1, r                                 /* Column 3 */
probit afghworth propg age educ female partyid attend south urban veteran income_hh1, r                                          /* Column 4 */
probit afghworth hhboyd hhgirld age educ female partyid attend south urban veteran income_hh1, r                                 /* Column 5 */
probit afghworth hhboys hhgirls age educ female partyid attend south urban veteran income_hh1, r                                 /* Column 6 */
     
/* Table 4 regressions */
probit iraqworth fempropg malpropg age educ female partyid attend south urban veteran income_hh1, r                              /* Column 1 */
probit iraqworth femboyd femgirld malboyd malgirld age educ female partyid attend south urban veteran income_hh1, r              /* Column 2 */
probit iraqworth femboys femgirls malboys malgirls age educ female partyid attend south urban veteran income_hh1, r              /* Column 3 */
probit afghworth fempropg malpropg age educ female partyid attend south urban veteran income_hh1, r                              /* Column 4 */
probit afghworth femboyd femgirld malboyd malgirld age educ female partyid attend south urban veteran income_hh1, r              /* Column 5 */
probit afghworth femboys femgirls malboys malgirls age educ female partyid attend south urban veteran income_hh1, r              /* Column 6 */

/* Table 5 regressions */
probit iraqworth poorpropg richpropg age educ female partyid attend south urban veteran income_hh1, r                            /* Column 1 */
probit iraqworth poorboyd poorgirld richboyd richgirld age educ female partyid attend south urban veteran income_hh1, r          /* Column 2 */
probit iraqworth poorboyd poorgirld richboys richgirls age educ female partyid attend south urban veteran income_hh1, r          /* Column 3 */
probit afghworth poorpropg richpropg age educ female partyid attend south urban veteran income_hh1, r                            /* Column 4 */
probit afghworth poorboyd poorgirld richboyd richgirld age educ female partyid attend south urban veteran income_hh1, r          /* Column 5 */
probit afghworth poorboyd poorgirld richboys richgirls age educ female partyid attend south urban veteran income_hh1, r          /* Column 6 */

/* Table 6 regressions */
probit iraqworth nonpartpropg partpropg age educ female partyid attend south urban veteran income_hh1, r                         /* Column 1 */
probit iraqworth nonpartboyd nonpartgirld partboyd partgirld age educ female partyid attend south urban veteran income_hh1, r    /* Column 2 */
probit iraqworth nonpartboyd nonpartgirld partboys partgirls age educ female partyid attend south urban veteran income_hh1, r    /* Column 3 */
probit afghworth nonpartpropg partpropg age educ female partyid attend south urban veteran income_hh1, r                         /* Column 4 */
probit afghworth nonpartboyd nonpartgirld partboyd partgirld age educ female partyid attend south urban veteran income_hh1, r    /* Column 5 */
probit afghworth nonpartboyd nonpartgirld partboys partgirls age educ female partyid attend south urban veteran income_hh1, r    /* Column 6 */

/* Appendix regressions */

/* Table 1.1 regressions */
probit isolate excgirls age educ female partyid attend south urban veteran income_hh1, r                                         /* Column 1 */
probit isolate lnboys lngirls age educ female partyid attend south urban veteran income_hh1, r                                   /* Column 2 */
probit isolate hhrboys hhrgirls age educ female partyid attend south urban veteran income_hh1, r                                 /* Column 3 */

/* Table 1.2 regressions */
probit isolate propg age educ female partyid attend south urban veteran income_hh1 vetinfam migrant minority, r                  /* Column 1 */
probit isolate hhboyd hhgirld age educ female partyid attend south urban veteran income_hh1 vetinfam migrant minority, r         /* Column 2 */
probit isolate hhboys hhgirls age educ female partyid attend south urban veteran income_hh1 vetinfam migrant minority, r         /* Column 3 */

/* Table 1.3 regressions */
logit isolate propg age educ female partyid attend south urban veteran income_hh1, r                                             /* Column 1 */
logit isolate hhboyd hhgirld age educ female partyid attend south urban veteran income_hh1, r                                    /* Column 2 */
logit isolate hhboys hhgirls age educ female partyid attend south urban veteran income_hh1, r                                    /* Column 3 */

/* Table 2.1 regressions */
oprobit interven excgirls age educ female partyid attend south urban veteran income_hh1, r                                       /* Column 1 */
oprobit interven lnboys lngirls age educ female partyid attend south urban veteran income_hh1, r                                 /* Column 2 */
oprobit interven hhrboys hhrgirls age educ female partyid attend south urban veteran income_hh1, r                               /* Column 3 */

/* Table 2.2 regressions */
oprobit interven propg age educ female partyid attend south urban veteran income_hh1 vetinfam migrant minority, r                /* Column 1 */
oprobit interven hhboyd hhgirld age educ female partyid attend south urban veteran income_hh1 vetinfam migrant minority, r       /* Column 2 */
oprobit interven hhboys hhgirls age educ female partyid attend south urban veteran income_hh1 vetinfam migrant minority, r       /* Column 3 */

/* Table 2.3 regressions */
regress interven propg age educ female partyid attend south urban veteran income_hh1, r                                          /* Column 1 */
regress interven hhboyd hhgirld age educ female partyid attend south urban veteran income_hh1, r                                 /* Column 2 */
regress interven hhboys hhgirls age educ female partyid attend south urban veteran income_hh1, r                                 /* Column 3 */

/* Table 3.1 regressions */
probit iraqworth excgirls age educ female partyid attend south urban veteran income_hh1, r                                       /* Column 1 */
probit iraqworth lnboys lngirls age educ female partyid attend south urban veteran income_hh1, r                                 /* Column 2 */
probit iraqworth hhrboys hhrgirls age educ female partyid attend south urban veteran income_hh1, r                               /* Column 3 */
probit afghworth excgirls age educ female partyid attend south urban veteran income_hh1, r                                       /* Column 4 */
probit afghworth lnboys lngirls age educ female partyid attend south urban veteran income_hh1, r                                 /* Column 5 */
probit afghworth hhrboys hhrgirls age educ female partyid attend south urban veteran income_hh1, r                               /* Column 6 */

/* Table 3.2 regressions */
probit iraqworth propg age educ female partyid attend south urban veteran income_hh1 vetinfam migrant minority, r                /* Column 1 */
probit iraqworth hhboyd hhgirld age educ female partyid attend south urban veteran income_hh1 vetinfam migrant minority, r       /* Column 2 */
probit iraqworth hhboys hhgirls age educ female partyid attend south urban veteran income_hh1 vetinfam migrant minority, r       /* Column 3 */
probit afghworth propg age educ female partyid attend south urban veteran income_hh1 vetinfam migrant minority, r                /* Column 4 */
probit afghworth hhboyd hhgirld age educ female partyid attend south urban veteran income_hh1 vetinfam migrant minority, r       /* Column 5 */
probit afghworth hhboys hhgirls age educ female partyid attend south urban veteran income_hh1 vetinfam migrant minority, r       /* Column 6 */

/* Table 3.3 regressions */
logit iraqworth propg age educ female partyid attend south urban veteran income_hh1, r                                           /* Column 1 */
logit iraqworth hhboyd hhgirld age educ female partyid attend south urban veteran income_hh1, r                                  /* Column 2 */
logit iraqworth hhboys hhgirls age educ female partyid attend south urban veteran income_hh1, r                                  /* Column 3 */
logit afghworth propg age educ female partyid attend south urban veteran income_hh1, r                                           /* Column 4 */
logit afghworth hhboyd hhgirld age educ female partyid attend south urban veteran income_hh1, r                                  /* Column 5 */
logit afghworth hhboys hhgirls age educ female partyid attend south urban veteran income_hh1, r                                  /* Column 6 */
