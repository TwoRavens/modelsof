clear
clear matrix
set more off
set virtual on
set trace off
set matsize 800
set mem 5000m

global data "G:/data"
global root "G:/data"

cd "$data"
program drop _all

* STEP 1: SETUP DATA
*-----------------------
global dp "$root/JPP/brazspil/programs/%stata/%1setup"

* do $dp/rais-data-clean.do
    /* PREPARE RAIS WORKER 1-PERCENT SAMPLE FOR MERGE */
    /* GENERATES SIMPLE DESCRIPTIVE STATISTICS */
    /* INPUT:  "rais/draws/natl/wid-draw-workers-natl.csv"
               "rais/cbo/grupo2cbo.dta"
               "rais/cbo/cbogrp2occagg.dta"
               "rais/auxil/minwage.dta" 
           do: "rais/auxil/`lblfile'.do" (`lblfile' in sexo instr vinc desl nacional etaria adm estbl jurid)
               "rais/cnae/`lblfile'.do" (`lblfile' in ibge cnae_95)
               "rais/cbo/`lblfile'.do" (`lblfile' in cbogrp) */
    /* OUTPUT: "JPP/brazspil/data/rais-draw-natl.dta"
               "JPP/brazspil/auxil/minwage.dta" */
    /*    Log: "JPP/brazspil/logs/%stata/%1setup/rais-data-clean.log" */ 

* do $dp/rais-data-clean-metro.do
    /* PREPARE RAIS WORKER 5-PERCENT METRO MALE SAMPLE FOR MERGE */
    /* GENERATES SIMPLE DESCRIPTIVE STATISTICS */
    /* INPUT:  "rais/draws/metro/wid-draw-workers-metro-male.csv"
               "rais/cbo/grupo2cbo.dta"
               "rais/cbo/cbogrp2occagg.dta"
               "rais/auxil/minwage.dta" 
           do: "rais/auxil/`lblfile'.do" (`lblfile' in sexo instr vinc desl nacional etaria adm estbl jurid)
               "rais/cnae/`lblfile'.do" (`lblfile' in ibge cnae_95)
               "rais/cbo/`lblfile'.do" (`lblfile' in cbogrp) */
    /* OUTPUT: "JPP/brazspil/data/rais-draw-metro.dta"
               "JPP/brazspil/auxil/minwage.dta" */
    /*    Log: "JPP/brazspil/logs/%stata/%1setup/rais-data-clean-metro.log" */ 

* do $dp/prep-auxil.do
  /* PREPARES AUXILIARY DATA */
    /* INPUT:  "rais/base-agg/cnae/aggsec.csv"
               "JPP/brazhetw/auxil/compadv-cnae.csv"
               "JPP/brazhetw/auxil/union.csv"
               "JPP/brazspil/auxil/fdi/fdi.csv"
               "JPP/brazspil/data/rais-draw-natl.dta"
               "rais/base-agg/cnpj/aggcnpj_`let'.dta" (where `let' is a-j) 
               "JPP/brazhetw/secex/exp-firms.dta" 
               "JPP/brazhetw/auxil/pia.dta" 
               "JPP/brazspil/auxil/minwage.dta" */
    /* OUTPUT: "JPP/brazspil/auxil/cnae-agg.dta"
               "JPP/brazspil/auxil/compadv.dta"
		   "JPP/brazspil/auxil/union.dta"
               "JPP/brazspil/auxil/fdi.dta" 
               "JPP/brazspil/data/cnpj/aggcnpj_`let'.dta" (where `let' is a-j) 
               "JPP/brazspil/data/cnpj/aggcnpj.dta" 
               "JPP/brazspil/data/cnpj/aggcnpj-secex-match.dta" 
               "JPP/brazspil/data/cnpj/aggcnpj-secex-fdi-match.dta" */
    /*    Log: "JPP/brazspil/logs/%stata/%1setup/prep-auxil.log" */ 

* do $dp/prep-auxil-metro.do
  /* PREPARES AUXILIARY DATA FOR METRO MALE SAMPLE */
    /* INPUT:  "JPP/brazspil/data/rais-draw-metro.dta"
               "rais/base-agg/cnpj/aggcnpj_`let'.dta" (where `let' is a-j) 
               "JPP/brazhetw/secex/exp-firms.dta" 
               "JPP/brazhetw/auxil/pia.dta" 
               "JPP/brazspil/auxil/minwage.dta" 
               "JPP/brazspil/auxil/cnae-agg.dta"
               "JPP/brazspil/auxil/compadv.dta"
		   "JPP/brazspil/auxil/union.dta"
               "JPP/brazspil/auxil/fdi.dta" */
    /* OUTPUT: "JPP/brazspil/data/cnpj/aggcnpj_`let'-metro.dta" (where `let' is a-j) 
               "JPP/brazspil/data/cnpj/aggcnpj-metro.dta" 
               "JPP/brazspil/data/cnpj/aggcnpj-secex-match-metro.dta" 
               "JPP/brazspil/data/cnpj/aggcnpj-secex-fdi-match-metro.dta" */
    /*    Log: "JPP/brazspil/logs/%stata/%1setup/prep-auxil-metro.log" */ 

* do $dp/pull-mne-workers.do
    /* PULL MNE WORKERS (BASELINE SAMPLE: ONLY HIRING FIRMS, BALANCED) */
    /* INPUT:  "JPP/brazspil/data/rais-draw-natl.dta" 
               "JPP/brazspil/data/cnpj/aggcnpj-secex-fdi-match.dta" */
    /* OUTPUT: "JPP/brazspil/data/all-workers.dta"
               "JPP/brazspil/data/switchers.dta"
               "JPP/brazspil/data/hiremne.dta"
               "JPP/brazspil/data/hiredom.dta"
               "JPP/brazspil/data/wid/aggcnpj-workers.dta" */
    /*    Log: "JPP/brazspil/logs/%stata/%1setup/pull-mne-workers.log" */ 

* do $dp/pull-mne-workers-metro.do
    /* PULL MNE WORKERS FROM METRO SAMPLE */
    /* INPUT:  "JPP/brazspil/data/rais-draw-metro.dta" 
               "JPP/brazspil/data/cnpj/aggcnpj-secex-fdi-match-metro.dta" */
    /* OUTPUT: "JPP/brazspil/data/all-workers-metro.dta"
               "JPP/brazspil/data/switchers-metro.dta"
               "JPP/brazspil/data/hiremne-metro.dta"
               "JPP/brazspil/data/hiredom-metro.dta"
               "JPP/brazspil/data/wid/aggcnpj-workers-metro.dta" */
    /*    Log: "JPP/brazspil/logs/%stata/%1setup/pull-mne-workers-metro.log" */ 

* do $dp/pull-mne-workers-robust1.do
    /* PULL MNE WORKERS (ONLY HIRING FIRMS, UNBALANCED) */
    /* INPUT:  "JPP/brazspil/data/all-workers.dta" 
               "JPP/brazspil/data/hiremne.dta"
               "JPP/brazspil/data/hiredom.dta" */
    /* OUTPUT: "JPP/brazspil/data/wid/aggcnpj-workers-robust1.dta" */
    /*    Log: "JPP/brazspil/logs/%stata/%1setup/pull-mne-workers-robust1.log" */ 

* do $dp/pull-mne-workers-robust2.do
    /* PULL MNE WORKERS (ALL FIRMS, UNBALANCED) */
    /* INPUT:  "JPP/brazspil/data/all-workers.dta" 
               "JPP/brazspil/data/hiremne.dta"
               "JPP/brazspil/data/hiredom.dta" */
    /* OUTPUT: "JPP/brazspil/data/wid/aggcnpj-workers-robust2.dta" */
    /*    Log: "JPP/brazspil/logs/%stata/%1setup/pull-mne-workers-robust2.log" */ 

* STEP 2: WORKER-LEVEL REGRESSIONS
*-----------------------
global dp "$root/JPP/brazspil/programs/%stata/%2workregs"

do $dp/worker-level-regs.do
    /* MAIN REGRESSIONS TABLES 4.1-5.2 */
    /* INPUT:  "JPP/brazspil/data/wid/aggcnpj-workers.dta" */
    /*    Log: "JPP/brazspil/logs/%stata/%2workregs/worker-level-regs.log" */ 

* do $dp/worker-level-regs-metro.do
    /* REGRESSIONS USING METRO DATA */
    /* INPUT:  "JPP/brazspil/data/wid/aggcnpj-workers-metro.dta" */
    /*    Log: "JPP/brazspil/logs/%stata/%2workregs/worker-level-regs-metro.log" */ 

* do $dp/worker-level-regs-robust1.do
    /* REGRESSIONS USING ROBUST SAMPLE 1 */
    /* INPUT:  "JPP/brazspil/data/wid/aggcnpj-workers-robust1.dta" */
    /*    Log: "JPP/brazspil/logs/%stata/%2workregs/worker-level-regs-robust1.log" */ 

* do $dp/worker-level-regs-robust2.do
    /* REGRESSIONS USING ROBUST SAMPLE 2 */
    /* INPUT:  "JPP/brazspil/data/wid/aggcnpj-workers-robust2.dta" */
    /*    Log: "JPP/brazspil/logs/%stata/%2workregs/worker-level-regs-robust2.log" */ 

log close