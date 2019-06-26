#delimit;
clear;
set memory 400m;
set more off;
capture log close;
log using E:\Articles&Chapters\JPR\movcountjprgls.log, replace;
use E:\Articles&Chapters\JPR\jprbalancednopartynoexp.dta, clear;

***************************************************************;
* Project: movement-countermovement for JPR                   *;
* Data comes from movement counter movement data revisited    *;
* Panel data municipio per month without zeros for gls models *;
***************************************************************;

describe;
summarize;

*****************;
* Generate lags *;
*****************;

tsset municipio month;

rename zapprots zaprot;
rename nozaprot nozap;
generate lagzaprot = L1.zaprot;
generate lagnozap = L1.nozap;
generate lag1pri = L1.prilocal;
generate lag2pri = L2.prilocal;
generate lag3pri = L3.prilocal;
generate lag4pri = L4.prilocal;
generate lag5pri = L5.prilocal;
generate lag6pri = L6.prilocal;
generate lag7pri = L7.prilocal;
generate lag8pri = L8.prilocal;
generate lag9pri = L9.prilocal;
generate lag10pri = L10.prilocal;
generate lag11pri = L11.prilocal;
generate lag12pri = L12.prilocal;
generate lag1prd = L1.prdlocal;
generate lag2prd = L2.prdlocal;
generate lag3prd = L3.prdlocal;
generate lag4prd = L4.prdlocal;
generate lag5prd = L5.prdlocal;
generate lag6prd = L6.prdlocal;
generate lag7prd = L7.prdlocal;
generate lag8prd = L8.prdlocal;
generate lag9prd = L9.prdlocal;
generate lag10prd = L10.prdlocal;
generate lag11prd = L11.prdlocal;
generate lag12prd = L12.prdlocal;
generate lagpan = L1.panlocal;
generate lagother = L1.leftlocal;
generate lagconce = L1.concess;

*************************;
*Generate new variables *;
*************************;

generate exp100th = expends/100000;
generate lagexp = L12.exp100th;
generate prinat = 1 if year==1994 | year==1995 | year==1996 | year==1997 |
year==1998 | year==1999;
recode prinat .=0;
generate pannat = 1 if year==2000 | year==2001 | year==2002 | year==2003;
recode pannat .=0;

generate pripri = prinat*prilocal;
generate priprd = prinat*prdlocal;
generate pripan = prinat*panlocal;
generate panpan = pannat*panlocal;
generate panpri = pannat*prilocal;
generate panprd = pannat*prdlocal;

generate priexp = prilocal*expend;
generate prdexp = prdlocal*expend;
generate panexp = panlocal*expend;

generate election = 1 if month==21 | month==22 | month==23 | month==59 | 
month==60 | month==61 | month==93 | month==94 | month==95;
recode election .=0;


summarize;

**********;
* Models *;
**********;

#delimit;
xtset municipio month;

* first models *;
xtnbreg zaprot lagnozap lag5pri lag11prd concess exp100th, i(municipio) re;

xtnbreg nozap lagzaprot lag6pri lag7pri lag8prd concess exp100th, i(municipio) re;

* final models with population elections and divided govt with pripri as base *;
xtnbreg zaprot lagnozap lag5pri lag11prd concess lagexp election priprd 
panpri panprd lagzaprot, exposure (population) i (municipio) re;

xtnbreg nozap lagzaprot lag6pri lag7pri lag8prd concess lagexp election priprd 
panpri panprd lagnozap, exposure (population) i (municipio) re;

* models for gls revisions *;

xtgls zaprot lagnozap lag5pri lag11prd concess lagexp election priprd panpri panprd lagzaprot, panels (correlated);

xtgls nozap lagzaprot lag6pri lag7pri lag8prd concess lagexp election priprd panpri panprd lagnozap, panels (correlated);


xtgls zaprot lagnozap lag5pri lag11prd concess lagexp election priprd panpri panprd lagzaprot, panels (hetero);

xtgls nozap lagzaprot lag6pri lag7pri lag8prd concess lagexp election priprd panpri panprd lagnozap, panels (hetero);


* models without zeros *;
bysort municipio : egen totzapro = sum (zaprot);
xtnbreg zaprot lagnozap lag5pri lag11prd concess lagexp election 
priprd panpri panprd lagzaprot if totzapro~=0, exposure (population) i(municipio) re;

xtset municipio month;
xtgls zaprot lagnozap lag5pri lag11prd concess lagexp election priprd
panpri panprd lagzaprot, if totzapro~=0, panels(correlated);


bysort municipio : egen totnozap = sum (nozap);
xtnbreg nozap lagzaprot lag6pri lag7pri lag8prd concess lagexp election priprd 
panpri panprd lagnozap if totnozap~=0, exposure (population) i(municipio) re;

* marginal effects = margins, dydx(*) *;
