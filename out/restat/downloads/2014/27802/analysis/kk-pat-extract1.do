* William Kerr, TGG; 
* Patent Transfer File for RESTAT;

#delimit;
cd /export/projects/wkerr_h1b_project/kerr/mainwork-2009/programs/cite/kk-final;
cap n log close; log using kk-pat-extract1.log, replace;
clear all; set matsize 1000; set more off;

*** Extract patent working file (& ind==1);
!gunzip /export/projects/wkerr_h1b_project/kerr/mainwork-2009/svdata/p-work-pat_2009.dta;
use patent ayear scat uspc ctryn assignee ind msa1
    if ctryn=="US"  & (scat!=. & uspc!=.) & (ayear>=1990 & ayear<=1999) & msa1!=.
    using /export/projects/wkerr_h1b_project/kerr/mainwork-2009/svdata/p-work-pat_2009.dta, clear;
drop ctryn; compress; sort patent; drop if patent==patent[_n-1];
save kk-patent-data, replace;

*** End of program;
log close; 