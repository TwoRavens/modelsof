   /*To replicate the empirical analyses, you will need the following dataset:
   replication.dta*/
      
   /*Data used to replicate Tables A.3 and A.4 in the Online Appendix;
   Survey-level data comes from the Comparative Study of Electoral Systems (Modules 1-3);
   See variable labels for how specific variables were generated.*/
   
   /*Data was stacked at the individual per party level using .case2alt (Long & Freese 2006; pp. 294-297)*/
   
   /*Input the location of the directory where you have saved the datafiles (e.g., C:\Users\username\Downloads)*/
   cd "C:\Users\d.marinova\Dropbox\Publication\PI_data\Replication"
   
   use replication.dta, clear
   describe
   
   /*Models include fixed effects for country (A1006) and year (A1008) and robust clustered errors around individual (_id)*/
   
   *Western Europe only* 
   preserve
   drop if Region_1==0
   /*Replicates Column 1 "Western Europe"  of Table A.3*/
   reg know_Exp c.A2001##c.A2001 male bachelor LRdist_e b001 d001 e001 d002 e002 age_party EIP lnenep mdm pr_sm mj_sm bicameral months seat_vote_disparity i.A1006 i.A1008, vce(cluster _id)
   /*Replicates Column 1 "Western Europe"  of Table A.4*/
   reg know_Exp c.A2001##c.A2001 male bachelor LRdist_e age_party TotalVol lnenep mdm pr_sm mj_sm bicameral months compulsory seat_vote_disparity i.A1006 i.A1008, vce(cluster _id)
   restore
   
   *Eastern Europe only*
   drop if Region_1==1
   /*Replicates Column 2 "Central and Eastern Europe" of Table A.3*/
   reg know_Exp c.A2001##c.A2001 male bachelor LRdist_e b001 d001 e001 d002 e002 age_party EIP lnenep mdm pr_sm mj_sm bicameral months seat_vote_disparity i.A1006 i.A1008, vce(cluster _id)
   /*Replicates Column 2 "Central and Eastern Europe" of Table A.4*/
   reg know_Exp c.A2001##c.A2001 male bachelor LRdist_e age_party TotalVol lnenep mdm pr_sm mj_sm bicameral months compulsory seat_vote_disparity i.A1006 i.A1008, vce(cluster _id)
