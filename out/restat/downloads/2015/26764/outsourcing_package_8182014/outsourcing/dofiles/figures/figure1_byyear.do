global x "$masterpath/datafiles/"
global y "$masterpath/trade/"
global z "$masterpath/outfiles/"

# delimit ;

capture log close;
clear;
set mem 1400m;
set more off;
set matsize 800;

use ${x}table6_norpiship.dta;

xi I.year I.educ I.ind7090;

keep lwage p_llowincemp_effective_occ p_lhigh_effective_occ p_expmod_effective_occ p_penmod_effective_occ age female union exper nonwhite year _Iyear* _Ieduc* _Iind7090* ihwt ind7090;

log using figure2_byyear.log, replace;
***********;
* By Year *;
***********;
reg lwage p_llowincemp_effective_occ p_lhigh_effective_occ p_expmod_effective_occ p_penmod_effective_occ age female union exper nonwhite _Ieduc* _Iind7090* if year==1983 [weight=ihwt], robust cluster(ind7090);
reg lwage p_llowincemp_effective_occ p_lhigh_effective_occ p_expmod_effective_occ p_penmod_effective_occ age female union exper nonwhite _Ieduc* _Iind7090* if year==1984 [weight=ihwt], robust cluster(ind7090);
reg lwage p_llowincemp_effective_occ p_lhigh_effective_occ p_expmod_effective_occ p_penmod_effective_occ age female union exper nonwhite _Ieduc* _Iind7090* if year==1985 [weight=ihwt], robust cluster(ind7090);
reg lwage p_llowincemp_effective_occ p_lhigh_effective_occ p_expmod_effective_occ p_penmod_effective_occ age female union exper nonwhite _Ieduc* _Iind7090* if year==1986 [weight=ihwt], robust cluster(ind7090);
reg lwage p_llowincemp_effective_occ p_lhigh_effective_occ p_expmod_effective_occ p_penmod_effective_occ age female union exper nonwhite _Ieduc* _Iind7090* if year==1987 [weight=ihwt], robust cluster(ind7090);
reg lwage p_llowincemp_effective_occ p_lhigh_effective_occ p_expmod_effective_occ p_penmod_effective_occ age female union exper nonwhite _Ieduc* _Iind7090* if year==1988 [weight=ihwt], robust cluster(ind7090);
reg lwage p_llowincemp_effective_occ p_lhigh_effective_occ p_expmod_effective_occ p_penmod_effective_occ age female union exper nonwhite _Ieduc* _Iind7090* if year==1989 [weight=ihwt], robust cluster(ind7090);
reg lwage p_llowincemp_effective_occ p_lhigh_effective_occ p_expmod_effective_occ p_penmod_effective_occ age female union exper nonwhite _Ieduc* _Iind7090* if year==1990 [weight=ihwt], robust cluster(ind7090);
reg lwage p_llowincemp_effective_occ p_lhigh_effective_occ p_expmod_effective_occ p_penmod_effective_occ age female union exper nonwhite _Ieduc* _Iind7090* if year==1991 [weight=ihwt], robust cluster(ind7090);
reg lwage p_llowincemp_effective_occ p_lhigh_effective_occ p_expmod_effective_occ p_penmod_effective_occ age female union exper nonwhite _Ieduc* _Iind7090* if year==1992 [weight=ihwt], robust cluster(ind7090);
reg lwage p_llowincemp_effective_occ p_lhigh_effective_occ p_expmod_effective_occ p_penmod_effective_occ age female union exper nonwhite _Ieduc* _Iind7090* if year==1993 [weight=ihwt], robust cluster(ind7090);
reg lwage p_llowincemp_effective_occ p_lhigh_effective_occ p_expmod_effective_occ p_penmod_effective_occ age female union exper nonwhite _Ieduc* _Iind7090* if year==1994 [weight=ihwt], robust cluster(ind7090);
reg lwage p_llowincemp_effective_occ p_lhigh_effective_occ p_expmod_effective_occ p_penmod_effective_occ age female union exper nonwhite _Ieduc* _Iind7090* if year==1995 [weight=ihwt], robust cluster(ind7090);
reg lwage p_llowincemp_effective_occ p_lhigh_effective_occ p_expmod_effective_occ p_penmod_effective_occ age female union exper nonwhite _Ieduc* _Iind7090* if year==1996 [weight=ihwt], robust cluster(ind7090);
reg lwage p_llowincemp_effective_occ p_lhigh_effective_occ p_expmod_effective_occ p_penmod_effective_occ age female union exper nonwhite _Ieduc* _Iind7090* if year==1997 [weight=ihwt], robust cluster(ind7090);
reg lwage p_llowincemp_effective_occ p_lhigh_effective_occ p_expmod_effective_occ p_penmod_effective_occ age female union exper nonwhite _Ieduc* _Iind7090* if year==1998 [weight=ihwt], robust cluster(ind7090);
reg lwage p_llowincemp_effective_occ p_lhigh_effective_occ p_expmod_effective_occ p_penmod_effective_occ age female union exper nonwhite _Ieduc* _Iind7090* if year==1999 [weight=ihwt], robust cluster(ind7090);
reg lwage p_llowincemp_effective_occ p_lhigh_effective_occ p_expmod_effective_occ p_penmod_effective_occ age female union exper nonwhite _Ieduc* _Iind7090* if year==2000 [weight=ihwt], robust cluster(ind7090);
reg lwage p_llowincemp_effective_occ p_lhigh_effective_occ p_expmod_effective_occ p_penmod_effective_occ age female union exper nonwhite _Ieduc* _Iind7090* if year==2001 [weight=ihwt], robust cluster(ind7090);
reg lwage p_llowincemp_effective_occ p_lhigh_effective_occ p_expmod_effective_occ p_penmod_effective_occ age female union exper nonwhite _Ieduc* _Iind7090* if year==2002 [weight=ihwt], robust cluster(ind7090);

log close;
exit;
