***********************

 /* Researchers interested in replicating the results should obtain the required authorization (see Campa_Serafinelli_ReSTAT_Replication-README.pdf) */
   /* If you have any questions on this do file do not hesitate to contact us */
   

****FIGURE 1***
rdplot imp_succ_job_binary near_distc1 if Female==1, c(0) p(1) numbinl(30) numbinr(30) graph_options(title("Women") legend(off) ytitle(Job success important) /*
*/ xtitle(Distance from border (Km)) yscale(range(0.4 1)) ylabel(0.2(0.2)1) graphregion(color(white)))
graph save "attitudes_women", replace

rdplot imp_succ_job_binary near_distc1 if Female==0, c(0) p(1) numbinl(30) numbinr(30) graph_options(title("Men") legend(off) ytitle(Job success important) /*
*/ xtitle(Distance from border (Km)) yscale(range(0.4 1)) ylabel(0.2(0.2)1) graphregion(color(white)))
graph save "attitudes_men", replace

graph combine "attitudes_women" "attitudes_men", rows(1) xsize(10) graphregion(color(white))
