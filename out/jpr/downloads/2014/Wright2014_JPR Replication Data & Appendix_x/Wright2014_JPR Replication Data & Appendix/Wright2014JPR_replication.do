********************************************************************************************************
*Thorin M. Wright
*"Territorial Revision and State Repression"
*2014. Journal of Peace Research, 51 (3): 375-87
*Replication File
*Includes Table 1 & Figure 1 in article
*Appendix Robustness Checks 
********************************************************************************************************
set more off

*reset working directory for replication files folder

*cd 

use "Wright2014JPR_replication.dta"

*Table 1, Article

ologit ainew ai1 ai2 ai3 ai4 terrrev fatality   lpop_lag lgdppc_lag  civconflict nonfatal dem_lag , cluster(ccode)

ologit ainew ai1 ai2 ai3 ai4 terrrev fatality terrXfatality   lpop_lag lgdppc_lag  civconflict nonfatal dem_lag ,  cluster(ccode)

ologit ainew ai1 ai2 ai3 ai4 terrrev fatality   lpop_lag lgdppc_lag  civconflict nonfatal  if (dem_lag==1) , cluster(ccode)

ologit ainew ai1 ai2 ai3 ai4 terrrev fatality terrXfatality   lpop_lag lgdppc_lag  civconflict nonfatal  if (dem_lag==1) ,  cluster(ccode)

ologit ainew ai1 ai2 ai3 ai4 terrrev fatality  lpop_lag lgdppc_lag civconflict nonfatal if (dem_lag==0) , cluster(ccode)

ologit ainew ai1 ai2 ai3 ai4 terrrev fatality terrXfatality lpop_lag lgdppc_lag civconflict nonfatal if (dem_lag==0) , cluster(ccode)

*Figure 1, Article

*Democratic territorial revisionists and pred probs
*predicted probs in graph are the sum of probabilities for all categories higher than 1.

estsimp ologit ainew ai1 ai2 ai3 ai4   terrrev fatality terrXfatality  lpop_lag lgdppc_lag civconflict  nonfatal  if (dem_lag==1)  , cluster(ccode)


setx ai1 1  ai2 0 ai3 0  ai4 0  lpop_lag (mean)  lgdppc_lag (mean)   civconflict 0 fatality 0 terrrev 0 terrXfatality 0 nonfatal 0
simqi, pr level(90)
setx ai1 1  ai2 0 ai3 0  ai4 0  lpop_lag (mean)  lgdppc_lag (mean)   civconflict 0 fatality 0 terrrev 1 terrXfatality 0 nonfatal 1
simqi, pr level(90)
setx ai1 1  ai2 0 ai3 0  ai4 0  lpop_lag (mean)  lgdppc_lag (mean)   civconflict 0 fatality 1 terrrev 1 terrXfatality 1 nonfatal 0
simqi, pr level(90)
setx ai1 1  ai2 0 ai3 0  ai4 0  lpop_lag (mean)  lgdppc_lag (mean)   civconflict 0 fatality 2 terrrev 1 terrXfatality 2 nonfatal 0  
simqi, pr level(90)
setx ai1 1  ai2 0 ai3 0  ai4 0  lpop_lag (mean)  lgdppc_lag (mean)   civconflict 0 fatality 3 terrrev 1 terrXfatality 3 nonfatal 0 
simqi, pr level(90)
setx ai1 1  ai2 0 ai3 0  ai4 0  lpop_lag (mean)  lgdppc_lag (mean)   civconflict 0 fatality 4 terrrev 1 terrXfatality 4 nonfatal 0  
simqi, pr level(90)
setx ai1 1  ai2 0 ai3 0  ai4 0  lpop_lag (mean)  lgdppc_lag (mean)   civconflict 0 fatality 5 terrrev 1 terrXfatality 5 nonfatal 0 
simqi, pr level(90)
setx ai1 1  ai2 0 ai3 0  ai4 0  lpop_lag (mean)  lgdppc_lag (mean)   civconflict 0 fatality 6 terrrev 1 terrXfatality 6 nonfatal 0  
simqi, pr level(90)

drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13 b14 b15

*autocratic territorial revisionists and pred probs
*predicted probs in graph are the sum of probabilities for all categories higher than 3.

estsimp ologit ainew ai1 ai2 ai3 ai4   terrrev fatality terrXfatality  lpop_lag lgdppc_lag civconflict  nonfatal  if (dem_lag==0)  , cluster(ccode)


setx ai1 0  ai2 0 ai3 1  ai4 0  lpop_lag (mean)  lgdppc_lag (mean)   civconflict 0 fatality 0 terrrev 0 terrXfatality 0 nonfatal 0
simqi, pr level(90)
setx ai1 0  ai2 0 ai3 1  ai4 0  lpop_lag (mean)  lgdppc_lag (mean)   civconflict 0 fatality 0 terrrev 1 terrXfatality 0 nonfatal 1
simqi, pr level(90)
setx ai1 0  ai2 0 ai3 1  ai4 0  lpop_lag (mean)  lgdppc_lag (mean)   civconflict 0 fatality 1 terrrev 1 terrXfatality 1 nonfatal 0
simqi, pr level(90)
setx ai1 0  ai2 0 ai3 1  ai4 0  lpop_lag (mean)  lgdppc_lag (mean)   civconflict 0 fatality 2 terrrev 1 terrXfatality 2 nonfatal 0  
simqi, pr level(90)
setx ai1 0  ai2 0 ai3 1  ai4 0  lpop_lag (mean)  lgdppc_lag (mean)   civconflict 0 fatality 3 terrrev 1 terrXfatality 3 nonfatal 0 
simqi, pr level(90)
setx ai1 0  ai2 0 ai3 1  ai4 0  lpop_lag (mean)  lgdppc_lag (mean)   civconflict 0 fatality 4 terrrev 1 terrXfatality 4 nonfatal 0  
simqi, pr level(90)
setx ai1 0  ai2 0 ai3 1  ai4 0  lpop_lag (mean)  lgdppc_lag (mean)   civconflict 0 fatality 5 terrrev 1 terrXfatality 5 nonfatal 0 
simqi, pr level(90)
setx ai1 0  ai2 0 ai3 1  ai4 0  lpop_lag (mean)  lgdppc_lag (mean)   civconflict 0 fatality 6 terrrev 1 terrXfatality 6 nonfatal 0  
simqi, pr level(90)

drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13 b14 b15



**descriptive stats, Table 1, Appendix

tab terrrev if (ainew!=. & ai_lag!=. &  dem_lag!=. &  terrrev!=. &  fatality!=. &   lpop_lag!=. &  lgdppc_lag!=. &  civconflict!=. & nonfatal!=. )

tab terrrev if (ainew!=. & ai_lag!=. &  dem_lag!=. &  terrrev!=. &  fatality!=. &   lpop_lag!=. &  lgdppc_lag!=. &  civconflict!=. & nonfatal!=.  & dem_lag==1)

tab terrrev if (ainew!=. & ai_lag!=. &  dem_lag!=. &  terrrev!=. &  fatality!=. &   lpop_lag!=. &  lgdppc_lag!=. &  civconflict!=. & nonfatal!=.  & dem_lag==0)

summarize ainew if (ainew!=. & ai_lag!=. &  dem_lag!=. &  terrrev!=. &  fatality!=. &   lpop_lag!=. &  lgdppc_lag!=. &  civconflict!=. & nonfatal!=. ), detail

summarize ainew if (ainew!=. & ai_lag!=. &  dem_lag!=. &  terrrev!=. &  fatality!=. &   lpop_lag!=. &  lgdppc_lag!=. &  civconflict!=. & nonfatal!=.  & dem_lag==1), detail

summarize ainew if (ainew!=. & ai_lag!=. &  dem_lag!=. &  terrrev!=. &  fatality!=. &   lpop_lag!=. &  lgdppc_lag!=. &  civconflict!=. & nonfatal!=.  & dem_lag==0), detail


summarize ainew if (ainew!=. & ai_lag!=. &  dem_lag!=. &  terrrev!=. &  fatality!=. &   lpop_lag!=. &  lgdppc_lag!=. &  civconflict!=. & nonfatal!=.  & terrrev==1), detail

summarize ainew if (ainew!=. & ai_lag!=. &  dem_lag!=. &  terrrev!=. &  fatality!=. &   lpop_lag!=. &  lgdppc_lag!=. &  civconflict!=. & nonfatal!=.  & dem_lag==1 & terrrev==1), detail

summarize ainew if (ainew!=. & ai_lag!=. &  dem_lag!=. &  terrrev!=. &  fatality!=. &   lpop_lag!=. &  lgdppc_lag!=. &  civconflict!=. & nonfatal!=.  & dem_lag==0 & terrrev==1), detail


tab ainew if (ainew!=. & ai_lag!=. &  dem_lag!=. &  terrrev!=. &  fatality!=. &   lpop_lag!=. &  lgdppc_lag!=. &  civconflict!=. & nonfatal!=.  )

tab ainew if (ainew!=. & ai_lag!=. &  dem_lag!=. &  terrrev!=. &  fatality!=. &   lpop_lag!=. &  lgdppc_lag!=. &  civconflict!=. & nonfatal!=.   & dem_lag==1)

tab ainew if (ainew!=. & ai_lag!=. &  dem_lag!=. &  terrrev!=. &  fatality!=. &   lpop_lag!=. &  lgdppc_lag!=. &  civconflict!=. & nonfatal!=.   & dem_lag==0)


tab ainew if (ainew!=. & ai_lag!=. &  dem_lag!=. &  terrrev!=. &  fatality!=. &   lpop_lag!=. &  lgdppc_lag!=. &  civconflict!=. & nonfatal!=.   & terrrev==1)

tab ainew if (ainew!=. & ai_lag!=. &  dem_lag!=. &  terrrev!=. &  fatality!=. &   lpop_lag!=. &  lgdppc_lag!=. &  civconflict!=. & nonfatal!=.   & dem_lag==1 & terrrev==1)

tab ainew if (ainew!=. & ai_lag!=. &  dem_lag!=. &  terrrev!=. &  fatality!=. &   lpop_lag!=. &  lgdppc_lag!=. &  civconflict!=. & nonfatal!=.   & dem_lag==0 & terrrev==1)


tab civconflict if (ainew!=. & ai_lag!=. &  dem_lag!=. &  terrrev!=. &  fatality!=. &   lpop_lag!=. &  lgdppc_lag!=. &  civconflict!=. & nonfatal!=.  )

tab civconflict if (ainew!=. & ai_lag!=. &  dem_lag!=. &  terrrev!=. &  fatality!=. &   lpop_lag!=. &  lgdppc_lag!=. &  civconflict!=. & nonfatal!=.   & dem_lag==1)

tab civconflict if (ainew!=. & ai_lag!=. &  dem_lag!=. &  terrrev!=. &  fatality!=. &   lpop_lag!=. &  lgdppc_lag!=. &  civconflict!=. & nonfatal!=.   & dem_lag==0)


tab terrXfatality if (ainew!=. & ai_lag!=. &  dem_lag!=. &  terrrev!=. &  fatality!=. &   lpop_lag!=. &  lgdppc_lag!=. &  civconflict!=. & nonfatal!=.  )

tab terrXfatality if (ainew!=. & ai_lag!=. &  dem_lag!=. &  terrrev!=. &  fatality!=. &   lpop_lag!=. &  lgdppc_lag!=. &  civconflict!=. & nonfatal!=.   & dem_lag==1)

tab terrXfatality if (ainew!=. & ai_lag!=. &  dem_lag!=. &  terrrev!=. &  fatality!=. &   lpop_lag!=. &  lgdppc_lag!=. &  civconflict!=. & nonfatal!=.   & dem_lag==0)



tab nonfatal if (ainew!=. & ai_lag!=. &  dem_lag!=. &  terrrev!=. &  fatality!=. &   lpop_lag!=. &  lgdppc_lag!=. &  civconflict!=. & nonfatal!=.  )

tab nonfatal if (ainew!=. & ai_lag!=. &  dem_lag!=. &  terrrev!=. &  fatality!=. &   lpop_lag!=. &  lgdppc_lag!=. &  civconflict!=. & nonfatal!=.   & dem_lag==1)

tab nonfatal if (ainew!=. & ai_lag!=. &  dem_lag!=. &  terrrev!=. &  fatality!=. &   lpop_lag!=. &  lgdppc_lag!=. &  civconflict!=. & nonfatal!=.   & dem_lag==0)



tab fatality if (ainew!=. & ai_lag!=. &  dem_lag!=. &  terrrev!=. &  fatality!=. &   lpop_lag!=. &  lgdppc_lag!=. &  civconflict!=. & nonfatal!=.  )

tab fatality if (ainew!=. & ai_lag!=. &  dem_lag!=. &  terrrev!=. &  fatality!=. &   lpop_lag!=. &  lgdppc_lag!=. &  civconflict!=. & nonfatal!=.   & dem_lag==1)

tab fatality if (ainew!=. & ai_lag!=. &  dem_lag!=. &  terrrev!=. &  fatality!=. &   lpop_lag!=. &  lgdppc_lag!=. &  civconflict!=. & nonfatal!=.   & dem_lag==0)

summarize fatality if (ainew!=. & ai_lag!=. &  dem_lag!=. &  terrrev!=. &  fatality!=. &   lpop_lag!=. &  lgdppc_lag!=. &  civconflict!=. & nonfatal!=.  ), detail

summarize fatality if (ainew!=. & ai_lag!=. &  dem_lag!=. &  terrrev!=. &  fatality!=. &   lpop_lag!=. &  lgdppc_lag!=. &  civconflict!=. & nonfatal!=.   & dem_lag==1), detail

summarize fatality if (ainew!=. & ai_lag!=. &  dem_lag!=. &  terrrev!=. &  fatality!=. &   lpop_lag!=. &  lgdppc_lag!=. &  civconflict!=. & nonfatal!=.   & dem_lag==0), detail


summarize lpop_lag if (ainew!=. & ai_lag!=. &  dem_lag!=. &  terrrev!=. &  fatality!=. &   lpop_lag!=. &  lgdppc_lag!=. &  civconflict!=. & nonfatal!=.  ), detail

summarize lpop_lag if (ainew!=. & ai_lag!=. &  dem_lag!=. &  terrrev!=. &  fatality!=. &   lpop_lag!=. &  lgdppc_lag!=. &  civconflict!=. & nonfatal!=.   & dem_lag==1), detail

summarize lpop_lag if (ainew!=. & ai_lag!=. &  dem_lag!=. &  terrrev!=. &  fatality!=. &   lpop_lag!=. &  lgdppc_lag!=. &  civconflict!=. & nonfatal!=.   & dem_lag==0), detail

summarize lgdppc_lag if (ainew!=. & ai_lag!=. &  dem_lag!=. &  terrrev!=. &  fatality!=. &   lpop_lag!=. &  lgdppc_lag!=. &  civconflict!=. & nonfatal!=.  ), detail

summarize lgdppc_lag if (ainew!=. & ai_lag!=. &  dem_lag!=. &  terrrev!=. &  fatality!=. &   lpop_lag!=. &  lgdppc_lag!=. &  civconflict!=. & nonfatal!=.   & dem_lag==1), detail

summarize lgdppc_lag if (ainew!=. & ai_lag!=. &  dem_lag!=. &  terrrev!=. &  fatality!=. &   lpop_lag!=. &  lgdppc_lag!=. &  civconflict!=. & nonfatal!=.   & dem_lag==0), detail

*Table 2, Appendix:
tab year ccode if ptsincrease==1 & (ainew!=. & ai_lag!=. &  dem_lag!=. &  terrrev==1 &  fatality!=. &  terrXfatality>=0 & lpop_lag!=. &  lgdppc_lag!=. &  civconflict!=. & nonfatal!=.   & dem_lag==1)
*Table 3, Appendix:
tab year ccode if ptsincrease==1 & terrXfatality>0 & (ainew!=. & ai_lag!=. &  dem_lag!=. &  terrrev==1 &  fatality!=. &  terrXfatality!=. & lpop_lag!=. &  lgdppc_lag!=. &  civconflict!=. & nonfatal!=.   & dem_lag==1)
*Table 4, Appendix:
tab year ccode if ptsdecrease==1 & terrXfatality>0 & (ainew!=. & ai_lag!=. &  dem_lag!=. &  terrrev==1 &  fatality!=. &   lpop_lag!=. &  lgdppc_lag!=. &  civconflict!=. & nonfatal!=.   & dem_lag==0)

*Table 5, Appendix
ologit ainew ai1 ai2 ai3 ai4 terrrev fatality   lpop_lag lgdppc_lag  civconflict anymid dem_lag , cluster(ccode)

ologit ainew ai1 ai2 ai3 ai4 terrrev fatality terrXfatality   lpop_lag lgdppc_lag  civconflict anymid dem_lag ,  cluster(ccode)

ologit ainew ai1 ai2 ai3 ai4 terrrev fatality   lpop_lag lgdppc_lag  civconflict anymid  if (dem_lag==1), cluster(ccode)

ologit ainew ai1 ai2 ai3 ai4 terrrev fatality terrXfatality   lpop_lag lgdppc_lag  civconflict anymid  if (dem_lag==1) ,  cluster(ccode)

ologit ainew ai1 ai2 ai3 ai4 terrrev fatality  lpop_lag lgdppc_lag civconflict anymid if (dem_lag==0) , cluster(ccode)

ologit ainew ai1 ai2 ai3 ai4 terrrev fatality terrXfatality lpop_lag lgdppc_lag civconflict anymid if (dem_lag==0) , cluster(ccode)


*Table 6, Appendix

ologit sdnew sd1 sd2 sd3 sd4 terrrev fatality terrXfatality  lpop_lag lgdppc_lag civconflict nonfatal dem_lag  , cluster(ccode)

ologit sdnew sd1 sd2 sd3 sd4 terrrev fatality terrXfatality  lpop_lag lgdppc_lag civconflict nonfatal if (dem_lag==1)  , cluster(ccode)

ologit sdnew sd1 sd2 sd3 sd4  terrrev fatality terrXfatality  lpop_lag lgdppc_lag civconflict nonfatal if (dem_lag==0)  , cluster(ccode)

*Table 7, Appendix

ologit ainew ai1 ai2 ai3 ai4 terrrev fatality terrXfatality  lpop_lag lgdppc_lag  civconflict nonfatal cdem_lag  , cluster(ccode)

ologit ainew ai1 ai2 ai3 ai4 terrrev fatality terrXfatality  lpop_lag lgdppc_lag  civconflict nonfatal  if (cdem_lag==1) , cluster(ccode)

ologit ainew ai1 ai2 ai3 ai4   terrrev fatality terrXfatality  lpop_lag lgdppc_lag civconflict  nonfatal  if (cdem_lag==0)  , cluster(ccode)

*Table 8, Appendix
ologit ainew ai1 ai2 ai3 ai4  terrrev fatality terrXfatality  lpop_lag lgdppc_lag  civconflict nonfatal  dem7_lag  , cluster(ccode)

ologit ainew ai1 ai2 ai3 ai4  terrrev fatality terrXfatality  lpop_lag lgdppc_lag  civconflict nonfatal if (dem7_lag==1)  , cluster(ccode)

ologit ainew ai1 ai2 ai3 ai4  terrrev fatality terrXfatality  lpop_lag lgdppc_lag civconflict  nonfatal if (dem7_lag==0)  , cluster(ccode)


*Table 9, Appendix

ologit ainew ai1 ai2 ai3 ai4 terrsq fatality terrsqXfatality  lpop_lag lgdppc_lag civconflict  nonfatal dem_lag , cluster(ccode)

ologit ainew ai1 ai2 ai3 ai4 terrsq fatality terrsqXfatality  lpop_lag lgdppc_lag civconflict  nonfatal if (dem_lag==1) , cluster(ccode)

ologit  ainew ai1 ai2 ai3 ai4  terrsq fatality terrsqXfatality  lpop_lag lgdppc_lag civconflict  nonfatal if (dem_lag==0) , cluster(ccode)


*Table 10, Appendix 

*MID participant data
ologit ainew ai1 ai2 ai3 ai4  dem_lag terrrev demXterr fatality demXfatality terrXfatality demXterrXfatality  lpop_lag lgdppc_lag civconflict  nonfatal , cluster(ccode)
*Maoz MID data
ologit ainew ai1 ai2 ai3 ai4  dem_lag m_terrrev m_demXterr m_fatality m_demXfatality m_terrXfatality m_demXterrXfatality  lpop_lag lgdppc_lag civconflict  m_nonfatal , cluster(ccode)
*EUGene output
ologit ainew ai1 ai2 ai3 ai4  dem_lag e_terrrev e_demXterr e_fatality e_demXfatality e_terrXfatality e_demXterrXfatality  lpop_lag lgdppc_lag civconflict  e_nonfatal, cluster(ccode)


*Table 11, Appendix
ologit ainew ai1 ai2 ai3 ai4 terrrev fatality terrXfatality  lpop_lag lgdppc_lag  civconflict nonfatal transborder terrXtrans dem_lag  , cluster(ccode)

ologit ainew ai1 ai2 ai3 ai4 terrrev fatality terrXfatality  lpop_lag lgdppc_lag  civconflict nonfatal transborder terrXtrans if (dem_lag==1) , cluster(ccode)

ologit ainew ai1 ai2 ai3 ai4   terrrev fatality terrXfatality  lpop_lag lgdppc_lag civconflict  nonfatal transborder terrXtrans if (dem_lag==0)  , cluster(ccode)


*Table 12, Appendix
ologit ciri ciri1 ciri2 ciri3 ciri4 ciri5 ciri6 ciri7 ciri8 terrrev demXterr  lpop_lag lgdppc_lag civconflict  nonfatal  dem_lag , cluster(ccode)

ologit ciri ciri1 ciri2 ciri3 ciri4 ciri5 ciri6 ciri7 ciri8 terrrev fatality terrXfatality  lpop_lag lgdppc_lag  civconflict nonfatal dem_lag  , cluster(ccode)

ologit ciri ciri1 ciri2 ciri3 ciri4 ciri5 ciri6 ciri7 ciri8 terrrev fatality terrXfatality  lpop_lag lgdppc_lag  civconflict nonfatal if (dem_lag==0)   , cluster(ccode)

ologit ciri ciri1 ciri2 ciri3 ciri4 ciri5 ciri6 ciri7 ciri8 terrrev fatality terrXfatality  lpop_lag lgdppc_lag  civconflict nonfatal  if (dem_lag==1)   , cluster(ccode)

*Table 13, Appendix
ologit ainew ai1 ai2 ai3 ai4 rev fatality revXfatality  lpop_lag lgdppc_lag  civconflict nonfatal if (dem_lag==1)  , cluster(ccode)

ologit ainew ai1 ai2 ai3 ai4 ntrev fatality ntrevXfatal  lpop_lag lgdppc_lag  civconflict nonfatal if (dem_lag==1) , cluster(ccode)

ologit ainew ai1 ai2 ai3 ai4 rev fatality revXfatality  lpop_lag lgdppc_lag civconflict  nonfatal  if (dem_lag==0)  , cluster(ccode)

ologit ainew ai1 ai2 ai3 ai4 ntrev fatality ntrevXfatal  lpop_lag lgdppc_lag civconflict  nonfatal  if (dem_lag==0)  , cluster(ccode)




