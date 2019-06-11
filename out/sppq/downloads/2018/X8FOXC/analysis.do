****************************
*All analysis in Stata 14.1*
****************************

*clear contents

clear

*load data 

use "/Users/goelzhauser/Box Sync/Research/classifying selection institutions/sppq replication/analysis.dta"

*set delimiter

#delimit;

*install package 'regsave' to save coefficients and confidence intervals needed to produce figures 2-4;

*ssc install regsave;

**********************************************************************;
*Figure 2: Results using Gulati, and Posner (2010)                    ;
*Relevant coefficients and 90% CIs input into figure2.dta for plotting;
**********************************************************************;

*merit as baseline (e.g., coefficient for appointed_cgp = "merit vs appointed" comparison for the "cgp" observation in figure2.dta;

reg lntotnum
appointed_cgp nonpartisan_cgp partisan_cgp
chiefcyr ctexperience experience retired00 retired01 retired02 retired03 age gender privatepractice elecspend pajid
ajcola partner stable numactivejudge nomandret ltclerk numclerk lawclerkopp lntrialcases intermapp mandpub
stateage lnpop lnpopborn crime medstateage lngsp income2000 frac_black citideo
yr1999 yr2000
, cluster(state) level(90);

*save results for figure 2;

regsave appointed_cgp nonpartisan_cgp partisan_cgp 
using "/Users/goelzhauser/Box Sync/Research/classifying selection institutions/sppq replication/figure2.dta"
, ci level(90) autoid replace;


*appointment baseline for comparison w/ partisan and nonpartisan elections;

reg lntotnum
merit_cgp nonpartisan_cgp partisan_cgp
chiefcyr ctexperience experience retired00 retired01 retired02 retired03 age gender privatepractice elecspend pajid
ajcola partner stable numactivejudge nomandret ltclerk numclerk lawclerkopp lntrialcases intermapp mandpub
stateage lnpop lnpopborn crime medstateage lngsp income2000 frac_black citideo
yr1999 yr2000
, cluster(state) level(90);

*save results for figure 2;

regsave nonpartisan_cgp partisan_cgp 
using "/Users/goelzhauser/Box Sync/Research/classifying selection institutions/sppq replication/figure2.dta"
, ci level(90) autoid append;

*nonpartisan elections baseline for comparison w/ partisan elections;

reg lntotnum
merit_cgp appointed_cgp partisan_cgp
chiefcyr ctexperience experience retired00 retired01 retired02 retired03 age gender privatepractice elecspend pajid
ajcola partner stable numactivejudge nomandret ltclerk numclerk lawclerkopp lntrialcases intermapp mandpub
stateage lnpop lnpopborn crime medstateage lngsp income2000 frac_black citideo
yr1999 yr2000
, cluster(state) level(90);

*save results for figure 2;

regsave partisan_cgp 
using "/Users/goelzhauser/Box Sync/Research/classifying selection institutions/sppq replication/figure2.dta"
, ci level(90) autoid append;

**********************************************************************;
*Figure 2: Results using Sheperd (2009) 				              ;
*Relevant coefficients and 90% CIs input into figure2.dta for plotting;
**********************************************************************;

*merit as baseline;

reg lntotnum
appointed_s nonpartisan_s partisan_s
chiefcyr ctexperience experience retired00 retired01 retired02 retired03 age gender privatepractice elecspend pajid
ajcola partner stable numactivejudge nomandret ltclerk numclerk lawclerkopp lntrialcases intermapp mandpub
stateage lnpop lnpopborn crime medstateage lngsp income2000 frac_black citideo
yr1999 yr2000
, cluster(state) level(90);

*save results for figure 2;

regsave appointed_s nonpartisan_s partisan_s 
using "/Users/goelzhauser/Box Sync/Research/classifying selection institutions/sppq replication/figure2.dta"
, ci level(90) autoid append;

*appointment baseline for comparison w/ partisan and nonpartisan elections;

reg lntotnum
merit_s nonpartisan_s partisan_s
chiefcyr ctexperience experience retired00 retired01 retired02 retired03 age gender privatepractice elecspend pajid
ajcola partner stable numactivejudge nomandret ltclerk numclerk lawclerkopp lntrialcases intermapp mandpub
stateage lnpop lnpopborn crime medstateage lngsp income2000 frac_black citideo
yr1999 yr2000
, cluster(state) level(90);

*save results for figure 2;

regsave nonpartisan_s partisan_s 
using "/Users/goelzhauser/Box Sync/Research/classifying selection institutions/sppq replication/figure2.dta"
, ci level(90) autoid append;

*nonpartisan elections baseline for comparison w/ partisan elections;

reg lntotnum
merit_s appointed_s partisan_s
chiefcyr ctexperience experience retired00 retired01 retired02 retired03 age gender privatepractice elecspend pajid
ajcola partner stable numactivejudge nomandret ltclerk numclerk lawclerkopp lntrialcases intermapp mandpub
stateage lnpop lnpopborn crime medstateage lngsp income2000 frac_black citideo
yr1999 yr2000
, cluster(state) level(90);

*save results for figure 2;

regsave partisan_s 
using "/Users/goelzhauser/Box Sync/Research/classifying selection institutions/sppq replication/figure2.dta"
, ci level(90) autoid append;

**********************************************************************;
*Figure 2: Results using Book of the States 			              ;
*Relevant coefficients and 90% CIs input into figure2.dta for plotting;
**********************************************************************;

*merit as baseline;

reg lntotnum
appointed_bos nonpartisan_bos partisan_bos
chiefcyr ctexperience experience retired00 retired01 retired02 retired03 age gender privatepractice elecspend pajid
ajcola partner stable numactivejudge nomandret ltclerk numclerk lawclerkopp lntrialcases intermapp mandpub
stateage lnpop lnpopborn crime medstateage lngsp income2000 frac_black citideo
yr1999 yr2000
, cluster(state) level(90);

*save results for figure 2;

regsave appointed_bos nonpartisan_bos partisan_bos 
using "/Users/goelzhauser/Box Sync/Research/classifying selection institutions/sppq replication/figure2.dta"
, ci level(90) autoid append;

*appointment baseline for comparison w/ partisan and nonpartisan elections;

reg lntotnum
merit_bos nonpartisan_bos partisan_bos
chiefcyr ctexperience experience retired00 retired01 retired02 retired03 age gender privatepractice elecspend pajid
ajcola partner stable numactivejudge nomandret ltclerk numclerk lawclerkopp lntrialcases intermapp mandpub
stateage lnpop lnpopborn crime medstateage lngsp income2000 frac_black citideo
yr1999 yr2000
, cluster(state) level(90);

*save results for figure 2;

regsave nonpartisan_bos partisan_bos 
using "/Users/goelzhauser/Box Sync/Research/classifying selection institutions/sppq replication/figure2.dta"
, ci level(90) autoid append;

*nonpartisan elections baseline for comparison w/ partisan elections;

reg lntotnum
merit_bos appointed_bos partisan_bos
chiefcyr ctexperience experience retired00 retired01 retired02 retired03 age gender privatepractice elecspend pajid
ajcola partner stable numactivejudge nomandret ltclerk numclerk lawclerkopp lntrialcases intermapp mandpub
stateage lnpop lnpopborn crime medstateage lngsp income2000 frac_black citideo
yr1999 yr2000
, cluster(state) level(90);

*save results for figure 2;

regsave partisan_bos 
using "/Users/goelzhauser/Box Sync/Research/classifying selection institutions/sppq replication/figure2.dta"
, ci level(90) autoid append;

**********************************************************************;
*Figure 2: Results using American Judicature Society 	              ;
*Relevant coefficients and 90% CIs input into figure2.dta for plotting;
**********************************************************************;

*merit as baseline;

reg lntotnum
appointed_ajs nonpartisan_ajs partisan_ajs
chiefcyr ctexperience experience retired00 retired01 retired02 retired03 age gender privatepractice elecspend pajid
ajcola partner stable numactivejudge nomandret ltclerk numclerk lawclerkopp lntrialcases intermapp mandpub
stateage lnpop lnpopborn crime medstateage lngsp income2000 frac_black citideo
yr1999 yr2000
, cluster(state) level(90);

*save results for figure 2;

regsave appointed_ajs nonpartisan_ajs partisan_ajs 
using "/Users/goelzhauser/Box Sync/Research/classifying selection institutions/sppq replication/figure2.dta"
, ci level(90) autoid append;

*appointment baseline for comparison w/ partisan and nonpartisan elections;

reg lntotnum
merit_ajs nonpartisan_ajs partisan_ajs
chiefcyr ctexperience experience retired00 retired01 retired02 retired03 age gender privatepractice elecspend pajid
ajcola partner stable numactivejudge nomandret ltclerk numclerk lawclerkopp lntrialcases intermapp mandpub
stateage lnpop lnpopborn crime medstateage lngsp income2000 frac_black citideo
yr1999 yr2000
, cluster(state) level(90);

*save results for figure 2;

regsave nonpartisan_ajs partisan_ajs 
using "/Users/goelzhauser/Box Sync/Research/classifying selection institutions/sppq replication/figure2.dta"
, ci level(90) autoid append;

*nonpartisan elections baseline for comparison w/ partisan elections;

reg lntotnum
merit_ajs appointed_ajs partisan_ajs
chiefcyr ctexperience experience retired00 retired01 retired02 retired03 age gender privatepractice elecspend pajid
ajcola partner stable numactivejudge nomandret ltclerk numclerk lawclerkopp lntrialcases intermapp mandpub
stateage lnpop lnpopborn crime medstateage lngsp income2000 frac_black citideo
yr1999 yr2000
, cluster(state) level(90);

*save results for figure 2;

regsave partisan_ajs 
using "/Users/goelzhauser/Box Sync/Research/classifying selection institutions/sppq replication/figure2.dta"
, ci level(90) autoid append;

**********************************************************************;
*Figure 2: Results using statutory and constitutional Rules           ;
*Relevant coefficients and 90% CIs input into figure2.dta for plotting;
**********************************************************************;

*merit as baseline;

reg lntotnum
appointed_formal nonpartisan_formal partisan_formal
chiefcyr ctexperience experience retired00 retired01 retired02 retired03 age gender privatepractice elecspend pajid
ajcola partner stable numactivejudge nomandret ltclerk numclerk lawclerkopp lntrialcases intermapp mandpub
stateage lnpop lnpopborn crime medstateage lngsp income2000 frac_black citideo
yr1999 yr2000
, cluster(state) level(90);

*save results for figure 2;

regsave appointed_formal nonpartisan_formal partisan_formal 
using "/Users/goelzhauser/Box Sync/Research/classifying selection institutions/sppq replication/figure2.dta"
, ci level(90) autoid append;

*appointment baseline for comparison w/ partisan and nonpartisan elections;

reg lntotnum
merit_formal nonpartisan_formal partisan_formal
chiefcyr ctexperience experience retired00 retired01 retired02 retired03 age gender privatepractice elecspend pajid
ajcola partner stable numactivejudge nomandret ltclerk numclerk lawclerkopp lntrialcases intermapp mandpub
stateage lnpop lnpopborn crime medstateage lngsp income2000 frac_black citideo
yr1999 yr2000
, cluster(state) level(90);

*save results for figure 2;

regsave nonpartisan_formal partisan_formal 
using "/Users/goelzhauser/Box Sync/Research/classifying selection institutions/sppq replication/figure2.dta"
, ci level(90) autoid append;

*nonpartisan elections baseline for comparison w/ partisan elections;

reg lntotnum
merit_formal appointed_formal partisan_formal
chiefcyr ctexperience experience retired00 retired01 retired02 retired03 age gender privatepractice elecspend pajid
ajcola partner stable numactivejudge nomandret ltclerk numclerk lawclerkopp lntrialcases intermapp mandpub
stateage lnpop lnpopborn crime medstateage lngsp income2000 frac_black citideo
yr1999 yr2000
, cluster(state) level(90);

*save results for figure 2;

regsave partisan_formal
using "/Users/goelzhauser/Box Sync/Research/classifying selection institutions/sppq replication/figure2.dta"
, ci level(90) autoid append;

**********************************************************************;
*Figure 2: Results using voluntary merit selection plans              ;
*Relevant coefficients and 90% CIs input into figure2.dta for plotting;
**********************************************************************;

*merit as baseline;

reg lntotnum
appointed_voluntary nonpartisan_voluntary partisan_voluntary
chiefcyr ctexperience experience retired00 retired01 retired02 retired03 age gender privatepractice elecspend pajid
ajcola partner stable numactivejudge nomandret ltclerk numclerk lawclerkopp lntrialcases intermapp mandpub
stateage lnpop lnpopborn crime medstateage lngsp income2000 frac_black citideo
yr1999 yr2000
, cluster(state) level(90);

*save results for figure 2;

regsave appointed_voluntary nonpartisan_voluntary partisan_voluntary 
using "/Users/goelzhauser/Box Sync/Research/classifying selection institutions/sppq replication/figure2.dta"
, ci level(90) autoid append;

*appointment baseline for comparison w/ partisan and nonpartisan elections;

reg lntotnum
merit_voluntary nonpartisan_voluntary partisan_voluntary
chiefcyr ctexperience experience retired00 retired01 retired02 retired03 age gender privatepractice elecspend pajid
ajcola partner stable numactivejudge nomandret ltclerk numclerk lawclerkopp lntrialcases intermapp mandpub
stateage lnpop lnpopborn crime medstateage lngsp income2000 frac_black citideo
yr1999 yr2000
, cluster(state) level(90);

*save results for figure 2;

regsave nonpartisan_voluntary partisan_voluntary 
using "/Users/goelzhauser/Box Sync/Research/classifying selection institutions/sppq replication/figure2.dta"
, ci level(90) autoid append;

*nonpartisan elections baseline for comparison w/ partisan elections;

reg lntotnum
merit_voluntary appointed_voluntary partisan_voluntary
chiefcyr ctexperience experience retired00 retired01 retired02 retired03 age gender privatepractice elecspend pajid
ajcola partner stable numactivejudge nomandret ltclerk numclerk lawclerkopp lntrialcases intermapp mandpub
stateage lnpop lnpopborn crime medstateage lngsp income2000 frac_black citideo
yr1999 yr2000
, cluster(state) level(90);

*save results for figure 2;

regsave partisan_voluntary 
using "/Users/goelzhauser/Box Sync/Research/classifying selection institutions/sppq replication/figure2.dta"
, ci level(90) autoid append;

**********************************************************************;
*Figure 3: Results using Gulati, and Posner (2010)                    ;
*Relevant coefficients and 90% CIs input into figure3.dta for plotting;
**********************************************************************;

*merit as baseline;

reg lntotnum
appointed_cgp nonpartisan_cgp partisan_cgp
chiefcyr ctexperience experience retired00 retired01 retired02 retired03 age gender privatepractice elecspend pajid
ajcola partner stable numactivejudge nomandret ltclerk numclerk lawclerkopp lntrialcases intermapp mandpub
stateage lnpop lnpopborn crime medstateage lngsp income2000 frac_black citideo
yr1999 yr2000
, cluster(state) level(90);

*save results for figure 3;

regsave appointed_cgp nonpartisan_cgp partisan_cgp 
using "/Users/goelzhauser/Box Sync/Research/classifying selection institutions/sppq replication/figure3.dta"
, ci level(90) autoid replace;

*appointment baseline for comparison w/ partisan and nonpartisan elections;

reg lntotnum
merit_cgp nonpartisan_cgp partisan_cgp
chiefcyr ctexperience experience retired00 retired01 retired02 retired03 age gender privatepractice elecspend pajid
ajcola partner stable numactivejudge nomandret ltclerk numclerk lawclerkopp lntrialcases intermapp mandpub
stateage lnpop lnpopborn crime medstateage lngsp income2000 frac_black citideo
yr1999 yr2000
, cluster(state) level(90);

*save results for figure 3;

regsave nonpartisan_cgp partisan_cgp 
using "/Users/goelzhauser/Box Sync/Research/classifying selection institutions/sppq replication/figure3.dta"
, ci level(90) autoid append;

*nonpartisan elections baseline for comparison w/ partisan elections;

reg lntotnum
merit_cgp appointed_cgp partisan_cgp
chiefcyr ctexperience experience retired00 retired01 retired02 retired03 age gender privatepractice elecspend pajid
ajcola partner stable numactivejudge nomandret ltclerk numclerk lawclerkopp lntrialcases intermapp mandpub
stateage lnpop lnpopborn crime medstateage lngsp income2000 frac_black citideo
yr1999 yr2000
, cluster(state) level(90);

*save results for figure 3;

regsave partisan_cgp 
using "/Users/goelzhauser/Box Sync/Research/classifying selection institutions/sppq replication/figure3.dta"
, ci level(90) autoid append;


*************************************************************************;
*Figure 3: Results using statutory and constitutional rules for retention;
*Relevant coefficients and 90% CIs input into figure3.dta for plotting   ;
*************************************************************************;

*retention as baseline;

reg lntotnum
reappointed nonpartisan partisan life
chiefcyr ctexperience experience retired00 retired01 retired02 retired03 age gender privatepractice elecspend pajid
ajcola partner stable numactivejudge nomandret ltclerk numclerk lawclerkopp lntrialcases intermapp mandpub
stateage lnpop lnpopborn crime medstateage lngsp income2000 frac_black citideo
yr1999 yr2000
, cluster(state) level(90);

*save results for figure 3;

regsave reappointed nonpartisan partisan  
using "/Users/goelzhauser/Box Sync/Research/classifying selection institutions/sppq replication/figure3.dta"
, ci level(90) autoid append;

*reappointed baseline for comparison with partisan and nonpartisan elections;

reg lntotnum
retention nonpartisan partisan life
chiefcyr ctexperience experience retired00 retired01 retired02 retired03 age gender privatepractice elecspend pajid
ajcola partner stable numactivejudge nomandret ltclerk numclerk lawclerkopp lntrialcases intermapp mandpub
stateage lnpop lnpopborn crime medstateage lngsp income2000 frac_black citideo
yr1999 yr2000
, cluster(state) level(90);

*save results for figure 3;

regsave nonpartisan partisan 
using "/Users/goelzhauser/Box Sync/Research/classifying selection institutions/sppq replication/figure3.dta"
, ci level(90) autoid append;

*nonpartisan elections baseline for comparison with partisan elections;

reg lntotnum
retention reappointed partisan life
chiefcyr ctexperience experience retired00 retired01 retired02 retired03 age gender privatepractice elecspend pajid
ajcola partner stable numactivejudge nomandret ltclerk numclerk lawclerkopp lntrialcases intermapp mandpub
stateage lnpop lnpopborn crime medstateage lngsp income2000 frac_black citideo
yr1999 yr2000
, cluster(state) level(90);

*save results for figure 3;

regsave partisan 
using "/Users/goelzhauser/Box Sync/Research/classifying selection institutions/sppq replication/figure3.dta"
, ci level(90) autoid append;


**********************************************************************;
*Figure 4: Results using Gulati, and Posner (2010)                    ;
*Relevant coefficients and 90% CIs input into figure4.dta for plotting;
**********************************************************************;

*merit as baseline;

reg lntotnum
appointed_cgp nonpartisan_cgp partisan_cgp
chiefcyr ctexperience experience retired00 retired01 retired02 retired03 age gender privatepractice elecspend pajid
ajcola partner stable numactivejudge nomandret ltclerk numclerk lawclerkopp lntrialcases intermapp mandpub
stateage lnpop lnpopborn crime medstateage lngsp income2000 frac_black citideo
yr1999 yr2000
, cluster(state) level(90);

*save results for figure 4;

regsave appointed_cgp nonpartisan_cgp partisan_cgp 
using "/Users/goelzhauser/Box Sync/Research/classifying selection institutions/sppq replication/figure4.dta"
, ci level(90) autoid replace;

*appointment baseline for comparison w/ partisan and nonpartisan elections;

reg lntotnum
merit_cgp nonpartisan_cgp partisan_cgp
chiefcyr ctexperience experience retired00 retired01 retired02 retired03 age gender privatepractice elecspend pajid
ajcola partner stable numactivejudge nomandret ltclerk numclerk lawclerkopp lntrialcases intermapp mandpub
stateage lnpop lnpopborn crime medstateage lngsp income2000 frac_black citideo
yr1999 yr2000
, cluster(state) level(90);

*save results for figure 4;

regsave nonpartisan_cgp partisan_cgp 
using "/Users/goelzhauser/Box Sync/Research/classifying selection institutions/sppq replication/figure4.dta"
, ci level(90) autoid append;

*nonpartisan elections baseline for comparison w/ partisan elections;

reg lntotnum
merit_cgp appointed_cgp partisan_cgp
chiefcyr ctexperience experience retired00 retired01 retired02 retired03 age gender privatepractice elecspend pajid
ajcola partner stable numactivejudge nomandret ltclerk numclerk lawclerkopp lntrialcases intermapp mandpub
stateage lnpop lnpopborn crime medstateage lngsp income2000 frac_black citideo
yr1999 yr2000
, cluster(state) level(90);

*save results for figure 4;

regsave partisan_cgp 
using "/Users/goelzhauser/Box Sync/Research/classifying selection institutions/sppq replication/figure4.dta"
, ci level(90) autoid append;


**********************************************************************;
*Figure 4: Results using Shepherd (2009)                              ;
*Relevant coefficients and 90% CIs input into figure4.dta for plotting;
**********************************************************************;

*merit as baseline;

reg lntotnum
appt_reappt_s npart_npart_s part_part_s misc_s
chiefcyr ctexperience experience retired00 retired01 retired02 retired03 age gender privatepractice elecspend pajid
ajcola partner stable numactivejudge nomandret ltclerk numclerk lawclerkopp lntrialcases intermapp mandpub
stateage lnpop lnpopborn crime medstateage lngsp income2000 frac_black citideo
yr1999 yr2000
, cluster(state) level(90);

*save results for figure 4;

regsave appt_reappt_s npart_npart_s part_part_s 
using "/Users/goelzhauser/Box Sync/Research/classifying selection institutions/sppq replication/figure4.dta"
, ci level(90) autoid append;

*appointment baseline for comparison w/ partisan and nonpartisan elections;

reg lntotnum
mplan_s npart_npart_s part_part_s misc_s
chiefcyr ctexperience experience retired00 retired01 retired02 retired03 age gender privatepractice elecspend pajid
ajcola partner stable numactivejudge nomandret ltclerk numclerk lawclerkopp lntrialcases intermapp mandpub
stateage lnpop lnpopborn crime medstateage lngsp income2000 frac_black citideo
yr1999 yr2000
, cluster(state) level(90);

*save results for figure 4;

regsave npart_npart_s part_part_s 
using "/Users/goelzhauser/Box Sync/Research/classifying selection institutions/sppq replication/figure4.dta"
, ci level(90) autoid append;

*nonpartisan elections baseline for comparison w/ partisan elections;

reg lntotnum
mplan_s appt_reappt_s part_part_s misc_s
chiefcyr ctexperience experience retired00 retired01 retired02 retired03 age gender privatepractice elecspend pajid
ajcola partner stable numactivejudge nomandret ltclerk numclerk lawclerkopp lntrialcases intermapp mandpub
stateage lnpop lnpopborn crime medstateage lngsp income2000 frac_black citideo
yr1999 yr2000
, cluster(state) level(90);

*save results for figure 4;

regsave part_part_s 
using "/Users/goelzhauser/Box Sync/Research/classifying selection institutions/sppq replication/figure4.dta"
, ci level(90) autoid append;

**********************************************************************;
*Figure 4: Results using Book of the States                           ;
*Relevant coefficients and 90% CIs input into figure4.dta for plotting;
**********************************************************************;

*merit as baseline;

reg lntotnum
appt_reappt_bos npart_npart_bos part_part_bos misc_bos
chiefcyr ctexperience experience retired00 retired01 retired02 retired03 age gender privatepractice elecspend pajid
ajcola partner stable numactivejudge nomandret ltclerk numclerk lawclerkopp lntrialcases intermapp mandpub
stateage lnpop lnpopborn crime medstateage lngsp income2000 frac_black citideo
yr1999 yr2000
, cluster(state) level(90);

*save results for figure 4;

regsave appt_reappt_bos npart_npart_bos part_part_bos
using "/Users/goelzhauser/Box Sync/Research/classifying selection institutions/sppq replication/figure4.dta"
, ci level(90) autoid append;

*appointment baseline for comparison w/ partisan and nonpartisan elections;

reg lntotnum
mplan_bos npart_npart_bos part_part_bos misc_bos
chiefcyr ctexperience experience retired00 retired01 retired02 retired03 age gender privatepractice elecspend pajid
ajcola partner stable numactivejudge nomandret ltclerk numclerk lawclerkopp lntrialcases intermapp mandpub
stateage lnpop lnpopborn crime medstateage lngsp income2000 frac_black citideo
yr1999 yr2000
, cluster(state) level(90);

*save results for figure 4;

regsave npart_npart_bos part_part_bos
using "/Users/goelzhauser/Box Sync/Research/classifying selection institutions/sppq replication/figure4.dta"
, ci level(90) autoid append;

*nonpartisan elections baseline for comparison w/ partisan elections;

reg lntotnum
mplan_bos appt_reappt_bos part_part_bos misc_bos
chiefcyr ctexperience experience retired00 retired01 retired02 retired03 age gender privatepractice elecspend pajid
ajcola partner stable numactivejudge nomandret ltclerk numclerk lawclerkopp lntrialcases intermapp mandpub
stateage lnpop lnpopborn crime medstateage lngsp income2000 frac_black citideo
yr1999 yr2000
, cluster(state) level(90);

*save results for figure 4;

regsave part_part_bos
using "/Users/goelzhauser/Box Sync/Research/classifying selection institutions/sppq replication/figure4.dta"
, ci level(90) autoid append;


**********************************************************************;
*Figure 4: Results using the American Judicature Society              ;
*Relevant coefficients and 90% CIs input into figure4.dta for plotting;
**********************************************************************;

*merit as baseline;

reg lntotnum
appt_reappt_ajs npart_npart_ajs part_part_ajs misc_ajs
chiefcyr ctexperience experience retired00 retired01 retired02 retired03 age gender privatepractice elecspend pajid
ajcola partner stable numactivejudge nomandret ltclerk numclerk lawclerkopp lntrialcases intermapp mandpub
stateage lnpop lnpopborn crime medstateage lngsp income2000 frac_black citideo
yr1999 yr2000
, cluster(state) level(90);

*save results for figure 4;

regsave appt_reappt_ajs npart_npart_ajs part_part_ajs
using "/Users/goelzhauser/Box Sync/Research/classifying selection institutions/sppq replication/figure4.dta"
, ci level(90) autoid append;

*appointment baseline for comparison w/ partisan and nonpartisan elections;

reg lntotnum
mplan_ajs npart_npart_ajs part_part_ajs misc_ajs
chiefcyr ctexperience experience retired00 retired01 retired02 retired03 age gender privatepractice elecspend pajid
ajcola partner stable numactivejudge nomandret ltclerk numclerk lawclerkopp lntrialcases intermapp mandpub
stateage lnpop lnpopborn crime medstateage lngsp income2000 frac_black citideo
yr1999 yr2000
, cluster(state) level(90);

*save results for figure 4;

regsave npart_npart_ajs part_part_ajs
using "/Users/goelzhauser/Box Sync/Research/classifying selection institutions/sppq replication/figure4.dta"
, ci level(90) autoid append;

*nonpartisan elections baseline for comparison w/ partisan elections;

reg lntotnum
mplan_ajs appt_reappt_ajs part_part_ajs misc_ajs
chiefcyr ctexperience experience retired00 retired01 retired02 retired03 age gender privatepractice elecspend pajid
ajcola partner stable numactivejudge nomandret ltclerk numclerk lawclerkopp lntrialcases intermapp mandpub
stateage lnpop lnpopborn crime medstateage lngsp income2000 frac_black citideo
yr1999 yr2000
, cluster(state) level(90);

*save results for figure 4;

regsave part_part_ajs
using "/Users/goelzhauser/Box Sync/Research/classifying selection institutions/sppq replication/figure4.dta"
, ci level(90) autoid append;

**********************************************************************;
*Figure 4: Results using statutory and constitutional rules           ;
*Relevant coefficients and 90% CIs input into figure4.dta for plotting;
**********************************************************************;

*merit as baseline;

reg lntotnum
appt_reappt_formal npart_npart_formal part_part_formal misc_formal
chiefcyr ctexperience experience retired00 retired01 retired02 retired03 age gender privatepractice elecspend pajid
ajcola partner stable numactivejudge nomandret ltclerk numclerk lawclerkopp lntrialcases intermapp mandpub
stateage lnpop lnpopborn crime medstateage lngsp income2000 frac_black citideo
yr1999 yr2000
, cluster(state) level(90);

*save results for figure 4;

regsave appt_reappt_formal npart_npart_formal part_part_formal
using "/Users/goelzhauser/Box Sync/Research/classifying selection institutions/sppq replication/figure4.dta"
, ci level(90) autoid append;

*appointment baseline for comparison w/ partisan and nonpartisan elections;

reg lntotnum
mplan_formal npart_npart_formal part_part_formal misc_formal
chiefcyr ctexperience experience retired00 retired01 retired02 retired03 age gender privatepractice elecspend pajid
ajcola partner stable numactivejudge nomandret ltclerk numclerk lawclerkopp lntrialcases intermapp mandpub
stateage lnpop lnpopborn crime medstateage lngsp income2000 frac_black citideo
yr1999 yr2000
, cluster(state) level(90);

*save results for figure 4;

regsave npart_npart_formal part_part_formal
using "/Users/goelzhauser/Box Sync/Research/classifying selection institutions/sppq replication/figure4.dta"
, ci level(90) autoid append;

*nonpartisan elections baseline for comparison w/ partisan elections;

reg lntotnum
mplan_formal appt_reappt_formal part_part_formal misc_formal
chiefcyr ctexperience experience retired00 retired01 retired02 retired03 age gender privatepractice elecspend pajid
ajcola partner stable numactivejudge nomandret ltclerk numclerk lawclerkopp lntrialcases intermapp mandpub
stateage lnpop lnpopborn crime medstateage lngsp income2000 frac_black citideo
yr1999 yr2000
, cluster(state) level(90);

*save results for figure 4;

regsave part_part_formal
using "/Users/goelzhauser/Box Sync/Research/classifying selection institutions/sppq replication/figure4.dta"
, ci level(90) autoid append;

**********************************************************************;
*Figure 4: Results using voluntary merit selection plans              ;
*Relevant coefficients and 90% CIs input into figure4.dta for plotting;
**********************************************************************;

*merit as baseline;

reg lntotnum
appt_reappt_voluntary npart_npart_voluntary part_part_voluntary misc_voluntary
chiefcyr ctexperience experience retired00 retired01 retired02 retired03 age gender privatepractice elecspend pajid
ajcola partner stable numactivejudge nomandret ltclerk numclerk lawclerkopp lntrialcases intermapp mandpub
stateage lnpop lnpopborn crime medstateage lngsp income2000 frac_black citideo
yr1999 yr2000
, cluster(state) level(90);

*save results for figure 4;

regsave appt_reappt_voluntary npart_npart_voluntary part_part_voluntary
using "/Users/goelzhauser/Box Sync/Research/classifying selection institutions/sppq replication/figure4.dta"
, ci level(90) autoid append;

*appointment baseline for comparison w/ partisan and nonpartisan elections;

reg lntotnum
mplan_voluntary npart_npart_voluntary part_part_voluntary misc_voluntary
chiefcyr ctexperience experience retired00 retired01 retired02 retired03 age gender privatepractice elecspend pajid
ajcola partner stable numactivejudge nomandret ltclerk numclerk lawclerkopp lntrialcases intermapp mandpub
stateage lnpop lnpopborn crime medstateage lngsp income2000 frac_black citideo
yr1999 yr2000
, cluster(state) level(90);

*save results for figure 4;

regsave npart_npart_voluntary part_part_voluntary
using "/Users/goelzhauser/Box Sync/Research/classifying selection institutions/sppq replication/figure4.dta"
, ci level(90) autoid append;

*nonpartisan elections baseline for comparison w/ partisan elections;

reg lntotnum
mplan_voluntary appt_reappt_voluntary part_part_voluntary misc_voluntary
chiefcyr ctexperience experience retired00 retired01 retired02 retired03 age gender privatepractice elecspend pajid
ajcola partner stable numactivejudge nomandret ltclerk numclerk lawclerkopp lntrialcases intermapp mandpub
stateage lnpop lnpopborn crime medstateage lngsp income2000 frac_black citideo
yr1999 yr2000
, cluster(state) level(90);

*save results for figure 4;

regsave part_part_voluntary
using "/Users/goelzhauser/Box Sync/Research/classifying selection institutions/sppq replication/figure4.dta"
, ci level(90) autoid append;


*******************;
*Appendix: Table 1*;
*******************;

*model 1;

reg lntotnum
appointed_cgp nonpartisan_cgp partisan_cgp
chiefcyr ctexperience experience retired00 retired01 retired02 retired03 age gender privatepractice elecspend pajid
ajcola partner stable numactivejudge nomandret ltclerk numclerk lawclerkopp lntrialcases intermapp mandpub
stateage lnpop lnpopborn crime medstateage lngsp income2000 frac_black citideo
yr1999 yr2000
, cluster(state);

estat ic;

*model 2;

reg lntotnum
appointed_s nonpartisan_s partisan_s
chiefcyr ctexperience experience retired00 retired01 retired02 retired03 age gender privatepractice elecspend pajid
ajcola partner stable numactivejudge nomandret ltclerk numclerk lawclerkopp lntrialcases intermapp mandpub
stateage lnpop lnpopborn crime medstateage lngsp income2000 frac_black citideo
yr1999 yr2000
, cluster(state);

estat ic;

*model 3;

reg lntotnum
appointed_bos nonpartisan_bos partisan_bos
chiefcyr ctexperience experience retired00 retired01 retired02 retired03 age gender privatepractice elecspend pajid
ajcola partner stable numactivejudge nomandret ltclerk numclerk lawclerkopp lntrialcases intermapp mandpub
stateage lnpop lnpopborn crime medstateage lngsp income2000 frac_black citideo
yr1999 yr2000
, cluster(state);

estat ic;

*model 4;

reg lntotnum
appointed_ajs nonpartisan_ajs partisan_ajs
chiefcyr ctexperience experience retired00 retired01 retired02 retired03 age gender privatepractice elecspend pajid
ajcola partner stable numactivejudge nomandret ltclerk numclerk lawclerkopp lntrialcases intermapp mandpub
stateage lnpop lnpopborn crime medstateage lngsp income2000 frac_black citideo
yr1999 yr2000
, cluster(state);

estat ic;

*model 5;

reg lntotnum
appointed_formal nonpartisan_formal partisan_formal
chiefcyr ctexperience experience retired00 retired01 retired02 retired03 age gender privatepractice elecspend pajid
ajcola partner stable numactivejudge nomandret ltclerk numclerk lawclerkopp lntrialcases intermapp mandpub
stateage lnpop lnpopborn crime medstateage lngsp income2000 frac_black citideo
yr1999 yr2000
, cluster(state);

estat ic;

*model 6;

reg lntotnum
appointed_voluntary nonpartisan_voluntary partisan_voluntary
chiefcyr ctexperience experience retired00 retired01 retired02 retired03 age gender privatepractice elecspend pajid
ajcola partner stable numactivejudge nomandret ltclerk numclerk lawclerkopp lntrialcases intermapp mandpub
stateage lnpop lnpopborn crime medstateage lngsp income2000 frac_black citideo
yr1999 yr2000
, cluster(state);

estat ic;

 
*******************;
*Appendix: Table 2*;
*******************;

*model 1;

reg lntotnum
appointed_cgp nonpartisan_cgp partisan_cgp
chiefcyr ctexperience experience retired00 retired01 retired02 retired03 age gender privatepractice elecspend pajid
ajcola partner stable numactivejudge nomandret ltclerk numclerk lawclerkopp lntrialcases intermapp mandpub
stateage lnpop lnpopborn crime medstateage lngsp income2000 frac_black citideo
yr1999 yr2000
, cluster(state);

estat ic;

*model 2;

reg lntotnum
reappointed nonpartisan partisan life
chiefcyr ctexperience experience retired00 retired01 retired02 retired03 age gender privatepractice elecspend pajid
ajcola partner stable numactivejudge nomandret ltclerk numclerk lawclerkopp lntrialcases intermapp mandpub
stateage lnpop lnpopborn crime medstateage lngsp income2000 frac_black citideo
yr1999 yr2000
, cluster(state);

estat ic;


*******************;
*Appendix: Table 3*;
*******************;

*model 1;

reg lntotnum
appointed_cgp nonpartisan_cgp partisan_cgp
chiefcyr ctexperience experience retired00 retired01 retired02 retired03 age gender privatepractice elecspend pajid
ajcola partner stable numactivejudge nomandret ltclerk numclerk lawclerkopp lntrialcases intermapp mandpub
stateage lnpop lnpopborn crime medstateage lngsp income2000 frac_black citideo
yr1999 yr2000
, cluster(state);

estat ic;

*model 2;

reg lntotnum
appt_reappt_s npart_npart_s part_part_s misc_s
chiefcyr ctexperience experience retired00 retired01 retired02 retired03 age gender privatepractice elecspend pajid
ajcola partner stable numactivejudge nomandret ltclerk numclerk lawclerkopp lntrialcases intermapp mandpub
stateage lnpop lnpopborn crime medstateage lngsp income2000 frac_black citideo
yr1999 yr2000
, cluster(state);

estat ic;

*model 3;

reg lntotnum
appt_reappt_bos npart_npart_bos part_part_bos misc_bos
chiefcyr ctexperience experience retired00 retired01 retired02 retired03 age gender privatepractice elecspend pajid
ajcola partner stable numactivejudge nomandret ltclerk numclerk lawclerkopp lntrialcases intermapp mandpub
stateage lnpop lnpopborn crime medstateage lngsp income2000 frac_black citideo
yr1999 yr2000
, cluster(state);

estat ic;

*model 4;

reg lntotnum
appt_reappt_ajs npart_npart_ajs part_part_ajs misc_ajs
chiefcyr ctexperience experience retired00 retired01 retired02 retired03 age gender privatepractice elecspend pajid
ajcola partner stable numactivejudge nomandret ltclerk numclerk lawclerkopp lntrialcases intermapp mandpub
stateage lnpop lnpopborn crime medstateage lngsp income2000 frac_black citideo
yr1999 yr2000
, cluster(state);

estat ic;

*model 5;

reg lntotnum
appt_reappt_formal npart_npart_formal part_part_formal misc_formal
chiefcyr ctexperience experience retired00 retired01 retired02 retired03 age gender privatepractice elecspend pajid
ajcola partner stable numactivejudge nomandret ltclerk numclerk lawclerkopp lntrialcases intermapp mandpub
stateage lnpop lnpopborn crime medstateage lngsp income2000 frac_black citideo
yr1999 yr2000
, cluster(state);

estat ic;

*model 6;

reg lntotnum
appt_reappt_voluntary npart_npart_voluntary part_part_voluntary misc_voluntary
chiefcyr ctexperience experience retired00 retired01 retired02 retired03 age gender privatepractice elecspend pajid
ajcola partner stable numactivejudge nomandret ltclerk numclerk lawclerkopp lntrialcases intermapp mandpub
stateage lnpop lnpopborn crime medstateage lngsp income2000 frac_black citideo
yr1999 yr2000
, cluster(state);

estat ic;

