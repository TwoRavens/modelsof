use c:\data\WARDJPR.dta
regress regimecentrality1 loggnicap logpop democracy eu asia
correlate regimecentrality1 regimecentrality2 centrality
regress factor1 loggnicap logpop popgrow density centrality
regress factor1 loggnicap logpop popgrow density regimecentrality2
regress footprint gnicap gnicapsq popgrow density centrality capgov, robust
regress footprint gnicap gnicapsq popgrow density regimecentrality2 capgov,robust
regress factor2 loggnicap growth90s pop centrality democracy capgov cappri, robust
regress factor2 loggnicap growth90s pop regimecentrality1 democracy capgov cappri, robust
regress gensav gnicap gnicapsq trade pop centrality democracy corruption, robust
regress gensav gnicap gnicapsq trade pop regimecentrality1 democracy corruption, robust


