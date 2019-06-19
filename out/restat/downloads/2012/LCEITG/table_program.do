log using table, replace

* "Varying Heterogeneity among U.S. Firms: Facts and Implications," by Chun, Kim, and Morck
* Stata program to generate Tables 1-8

set more off


* =========================================================================
* Table 1. Annualized volatility growth
* =========================================================================

use table_1_2, clear

* Table 1
* Panel A. Firm-specific volatility

* value weight: 2000s-1970s  1990s-1970s 2000s-1990s 
foreach var in "lsem" "lye" "lte" "lle" "lke" {  
reg d`var'p61a if d`var'p21a ~=. [aweight=ttap7180], r 
reg d`var'p21a if d`var'p21a ~=. [aweight=ttap7180], r   
reg d`var'p62a if d`var'p21a ~=. [aweight=ttap7180], r   
}           

* equal weight:  2000s-1970s 1990s-1970s 2000s-1990s
foreach var in "lsem" "lye" "lte" "lle"  "lke" {  
reg d`var'p61a if d`var'p21a ~=. , r 
reg d`var'p21a if d`var'p21a ~=. , r   
reg d`var'p62a if d`var'p21a ~=. , r   
}

* Table 1
* Panel B. Relative firm-specific volatility

* value weight: 2000s-1970s  1990s-1970s 2000s-1990s   
foreach var in "lsrm" "lyrr" "ltr" "llr" "lkr"  {      
reg d`var'p61a if d`var'p21a ~=. [aweight=ttap7180], r 
reg d`var'p21a if d`var'p21a ~=. [aweight=ttap7180], r 
reg d`var'p62a if d`var'p21a ~=. [aweight=ttap7180], r 
}         
          
* equal weight:  2000s-1970s 1990s-1970s 2000s-1990s   
foreach var in "lsrm" "lyrr" "ltr" "llr" "lkr"   {      
reg d`var'p61a if d`var'p21a ~=. , r          
reg d`var'p21a if d`var'p21a ~=. , r          
reg d`var'p62a if d`var'p21a ~=. , r          
}      


* =========================================================================   
* Table 2. Firm-specific TFP volatility explaining firm-spec Y&S vol.          
* =========================================================================   

use table_1_2, clear

* Table 2
* Panel A. reg of y on t l k       
reg dlyep21  dltep21 dllep21 dlkep21 [aweight=ttap7180], r   
dis "adjusted R-squared: " `e(r2_a)'
reg dlyep62  dltep62 dllep62 dlkep62 [aweight=ttap7180], r   
dis "adjusted R-squared: " `e(r2_a)'
reg dlyrrp21 dltrp21 dllrp21 dlkrp21 [aweight=ttap7180], r   
dis "adjusted R-squared: " `e(r2_a)'
reg dlyrrp62 dltrp62 dllrp62 dlkrp62 [aweight=ttap7180], r   
dis "adjusted R-squared: " `e(r2_a)'

* Table 2
* Panel B. reg of s on t l k
reg dlsemp21 dltep21 dllep21 dlkep21 [aweight=ttap7180], r
dis "adjusted R-squared: " `e(r2_a)'
reg dlsemp62 dltep62 dllep62 dlkep62 [aweight=ttap7180], r
dis "adjusted R-squared: " `e(r2_a)'
reg dlsrmp21 dltrp21 dllrp21 dlkrp21 [aweight=ttap7180], r
dis "adjusted R-squared: " `e(r2_a)'
reg dlsrmp62 dltrp62 dllrp62 dlkrp62 [aweight=ttap7180], r
dis "adjusted R-squared: " `e(r2_a)'


* =========================================================================   
* Table 3A. Summary statistics for variables used in regressions: annual data           
* =========================================================================   

use table_3a_4_6_8, replace

* Table 3
* Panel A. 1971-2006
* summary stat for variables used in regressions

su lsem lsrm lsmml litl lrdl lagel lsizel herfl [aweight=wttalg]

*su lsem lsrm lsmml litl lrdl lagel lsizel herfl [aweight=wttalg], d


* =========================================================================   
* Table 3B. Summary statistics for variables used in regressions: long-difference data          
* =========================================================================   

use table_3b_5_7, clear

* Table 3
* Panel B. (1991-2006) minus (1971-1980)

su dltep31 dltrp31 dltmp31 dlitp31 dlrdp31 dlagep31 dlsizep31 dherfp31 dereg  [weight=ttap7180]

*su dltep31 dltrp31 dltmp31 dlitp31 dlrdp31 dlagep31 dlsizep31 dherfp31 dereg  [weight=ttap7180], d



* =========================================================================   
* Table 4. Panel regression of firm-specific stock return volatility           
* =========================================================================   

use table_3a_4_6_8, replace

* Tabel 4

* (1)-(4): Firm-specific stock return volatility
* (1) 
areg lsem litl                                     lsmml dy2-dy36 [aweight=wttalg], absorb(id) cluster(id)   
* (2) 
areg lsem litl  lrdl lagel lsizel herfl            lsmml dy2-dy36 [aweight=wttalg], absorb(id) cluster(id)   
* (3) 
areg lsem litl  litldt2001                         lsmml dy2-dy36 [aweight=wttalg], absorb(id) cluster(id)        
* (4) 
areg lsem litl  litldt2001 lrdl lagel lsizel herfl lsmml dy2-dy36 [aweight=wttalg], absorb(id) cluster(id)  
      
* (5)-(8): Relative  firm-specific stock return volatility        
* (5) 
areg lsrm litl                                           dy2-dy36 [aweight=wttalg], absorb(id) cluster(id)   
* (6) 
areg lsrm litl lrdl lagel lsizel herfl                   dy2-dy36 [aweight=wttalg], absorb(id) cluster(id)   
* (7) 
areg lsrm litl  litldt2001                               dy2-dy36 [aweight=wttalg], absorb(id) cluster(id)        
* (8) 
areg lsrm litl  litldt2001 lrdl lagel lsizel herfl       dy2-dy36 [aweight=wttalg], absorb(id) cluster(id)  



* =========================================================================   
* Table 5. Long-difference regression of firm-specific TFP volatility           
* =========================================================================   

use table_3b_5_7, clear

* Table 5

* (1)-(4): Firm-specific TFP volatility
* (1)
reg dltep31 dlitp31       dltmp31 [aweight=ttap7180],r    
dis "adjusted R-squared: " `e(r2_a)'
* (2)
reg dltep31 dlitp31 dlrdp31 dlagep31 dlsizep31 dherfp31 dereg dltmp31 [aweight=ttap7180],r    
dis "adjusted R-squared: " `e(r2_a)'
* (3)
reg dltep21 dlitp21 dlrdp21 dlagep21 dlsizep21 dherfp21 dereg dltmp21 [aweight=ttap7180],r    
dis "adjusted R-squared: " `e(r2_a)'
* (4)
reg dltep61 dlitp61 dlrdp61 dlagep61 dlsizep61 dherfp61 dereg dltmp61 [aweight=ttap7180],r        
dis "adjusted R-squared: " `e(r2_a)'
                 
* (5)-(8): Relative  firm-specific TFP volatility              
* (5)
reg dltrp31 dlitp31       [aweight=ttap7180],r    
dis "adjusted R-squared: " `e(r2_a)'
* (6)
reg dltrp31 dlitp31 dlrdp31 dlagep31 dlsizep31 dherfp31 dereg [aweight=ttap7180],r    
dis "adjusted R-squared: " `e(r2_a)'
* (7)
reg dltrp21 dlitp21 dlrdp21 dlagep21 dlsizep21 dherfp21 dereg [aweight=ttap7180],r          
dis "adjusted R-squared: " `e(r2_a)'
* (8)
reg dltrp61 dlitp61 dlrdp61 dlagep61 dlsizep61 dherfp61 dereg [aweight=ttap7180],r    
dis "adjusted R-squared: " `e(r2_a)'



* =========================================================================         
* Table 6. 2SLS panel regression of firm-specific stock return volatility      
* =========================================================================         

use table_3a_4_6_8, replace


* (1)-(4): Firm-specific stock return volatility  
* (1)                                             
xi: ivreg lsem (litl=titl) lsmml i.yr i.id  [aweight=wttalg] if ditp==0 , cluster(id)   
dis "adjusted R-squared: " `e(r2_a)'
qui xi: reg litl titl lsmml i.yr i.id [aweight=wttalg] if ditp==0    
test titl

* (2)
xi: ivreg lsem (litl=titl) lrdl  lagel lsizel herfl lsmml i.yr i.id [aweight=wttalg] if ditp==0, cluster(id)   
dis "adjusted R-squared: " `e(r2_a)'
qui xi: reg litl titl lrdl  lagel lsizel herfl lsmml i.yr i.id [aweight=wttalg] if ditp==0
test titl

* (3)                                                                                          
xi: ivreg lsem (litl=titl citl) lsmml i.yr i.id [aweight=wttalg] if ditp==0 & yr <= 2000, cluster(id)   
dis "adjusted R-squared: " `e(r2_a)'
qui xi: reg litl titl citl lsmml i.yr i.id  [aweight=wttalg] if ditp==0 & yr <= 2000
test titl citl 
qui xi: ivreg lsem (litl=titl citl) lsmml i.yr i.id [aweight=wttalg] if ditp==0 & yr <= 2000   
overid

* (4)
xi: ivreg lsem (litl=titl citl) lrdl lagel lsizel herfl lsmml i.yr i.id if ditp==0 & yr <= 2000 [aweight=wttalg], cluster(id)   
dis "adjusted R-squared: " `e(r2_a)'                                                                                          
qui xi: reg litl titl citl lrdl lagel lsizel herfl lsmml i.yr i.id [aweight=wttalg] if ditp==0 & yr <= 2000
test titl citl 
qui xi: ivreg lsem (litl=titl citl) lrdl lagel lsizel herfl lsmml i.yr i.id if ditp==0 & yr <= 2000  [aweight=wttalg]   
overid


* (5)-(8): Relative  firm-specific stock return volatility     
* (5)
xi: ivreg lsrm (litl=titl) i.yr i.id [aweight=wttalg] if ditp==0, cluster(id)   
dis "adjusted R-squared: " `e(r2_a)'
qui xi: reg litl titl i.yr i.id [aweight=wttalg] if ditp==0
test titl

* (6)
xi: ivreg lsrm (litl=titl) lrdl  lagel lsizel herfl i.yr i.id [aweight=wttalg] if ditp==0, cluster(id)   
dis "adjusted R-squared: " `e(r2_a)'
qui xi: reg litl titl lrdl  lagel lsizel herfl i.yr i.id [aweight=wttalg] if ditp==0
test titl

* (7)                                                                                          
xi: ivreg lsrm (litl=titl citl) i.yr i.id [aweight=wttalg] if ditp==0, cluster(id)   
dis "adjusted R-squared: " `e(r2_a)'
qui xi: reg litl titl citl i.yr i.id [aweight=wttalg] if ditp==0 & yr <= 2000
test titl citl 
qui xi: ivreg lsrm (litl=titl citl) i.yr i.id [aweight=wttalg] if ditp==0 & yr <= 2000   
overid

* (8)
xi: ivreg lsrm (litl=titl citl) lrdl lagel lsizel herfl i.yr i.id  [aweight=wttalg] if ditp==0 & yr <= 2000, cluster(id)   
dis "adjusted R-squared: " `e(r2_a)'                                                                                          
qui xi: reg litl titl citl lrdl lagel lsizel herfl i.yr i.id [aweight=wttalg] if ditp==0 & yr <= 2000
test titl citl 
qui xi: ivreg lsrm (litl=titl citl) lrdl lagel lsizel herfl i.yr i.id  [aweight=wttalg] if ditp==0 & yr <= 2000   
overid



* =========================================================================         
* Table 7. 2SLS long-difference regression of firm-specific TFP volatility      
* =========================================================================         

use table_3b_5_7, clear

* Table 7

* (1)-(4): Firm-specific TFP volatility
* (1) 
ivreg2 dltep31 (dlitp31=titp7180) dltmp31 [aweight=ttap7180] if ditp==0,r
dis "adjusted R-squared: " `e(r2_a)'
qui reg dlitp31 titp7180 dltmp31 [aweight=ttap7180] if ditp==0
test titp7180


* (2)
ivreg2 dltep31 (dlitp31=titp7180) dlrdp31 dlagep31 dlsizep31 dherfp31 dereg dltmp31 [aweight=ttap7180] if ditp==0,r
dis "adjusted R-squared: " `e(r2_a)'
qui reg dlitp31 titp7180 dlrdp31 dlagep31 dlsizep31 dherfp31 dereg dltmp31 [aweight=ttap7180] if ditp==0
test titp7180

* (3)
ivreg2 dltep31 (dlitp31=titp7180 citp7180) dltmp31 [aweight=ttap7180] if ditp==0,r          
dis "adjusted R-squared: " `e(r2_a)'
qui reg dlitp31 titp7180 citp7180 dltmp31 [aweight=ttap7180] if ditp==0
test titp7180 citp7180 
qui ivreg dltep31 (dlitp31=titp7180 citp7180) dltmp31 [aweight=ttap7180] if ditp==0          
overid

* (4)
ivreg2 dltep31 (dlitp31=titp7180 citp7180) dlrdp31 dlagep31 dlsizep31 dherfp31 dereg dltmp31 [aweight=ttap7180] if ditp==0,r   
dis "adjusted R-squared: " `e(r2_a)'
qui reg dlitp31 titp7180  citp7180 dlrdp31 dlagep31 dlsizep31 dherfp31 dereg dltmp31 [aweight=ttap7180] if ditp==0
test titp7180 citp7180
qui ivreg dltep31 (dlitp31=titp7180 citp7180) dlrdp31 dlagep31 dlsizep31 dherfp31 dereg dltmp31 [aweight=ttap7180] if ditp==0
overid

* (5)-(8): Relative  firm-specific TFP volatility              
* (5)
ivreg2 dltrp31 (dlitp31=titp7180) [aweight=ttap7180] if ditp==0,r 
dis "adjusted R-squared: " `e(r2_a)'
qui reg dlitp31 titp7180 [aweight=ttap7180] if ditp==0
test titp7180

* (6)
ivreg2 dltrp31 (dlitp31=titp7180) dlrdp31 dlagep31 dlsizep31 dherfp31 dereg         [aweight=ttap7180] if ditp==0,r      
dis "adjusted R-squared: " `e(r2_a)'
qui reg dlitp31 titp7180 dlrdp31 dlagep31 dlsizep31 dherfp31 dereg [aweight=ttap7180] if ditp==0
test titp7180

* (7)
ivreg2 dltrp31 (dlitp31=titp7180 citp7180)      [aweight=ttap7180] if ditp==0,r  
dis "adjusted R-squared: " `e(r2_a)'
qui reg dlitp31 titp7180 citp7180 [aweight=ttap7180] if ditp==0
test titp7180 citp7180 
qui ivreg dltrp31 (dlitp31=titp7180 citp7180)      [aweight=ttap7180] if ditp==0
overid
  
* (8)
ivreg2 dltrp31 (dlitp31=titp7180 citp7180) dlrdp31 dlagep31 dlsizep31 dherfp31 dereg         [aweight=ttap7180] if ditp==0,r  
dis "adjusted R-squared: " `e(r2_a)'
qui reg dlitp31 titp7180 citp7180 dlrdp31 dlagep31 dlsizep31 dherfp31 dereg [aweight=ttap7180] if ditp==0
test titp7180 citp7180       
qui ivreg dltrp31 (dlitp31=titp7180 citp7180) dlrdp31 dlagep31 dlsizep31 dherfp31 dereg         [aweight=ttap7180] if ditp==0  
overid



* =========================================================================  
* Table 8. Panel regression of firm-specific stock return volatility: IPO         
* =========================================================================  

use table_3a_4_6_8, replace

* Tabel 8      
                            
* (1)-(4): Firm-specific stock return volatility    
* (1)                                                                                                                                                  
areg lsem litl       ipo10l                     lsmml dy2-dy36 [aweight=wttalg], absorb(id) cluster(id) 
* (2) 
areg lsem litl lrdl  ipo10l        lsizel herfl lsmml dy2-dy36 [aweight=wttalg], absorb(id) cluster(id)                                                                                                                                  
* (3) 
areg lsem litl       ipo20l                     lsmml dy2-dy36 [aweight=wttalg], absorb(id) cluster(id) 
* (4) 
areg lsem litl lrdl  ipo20l        lsizel herfl lsmml dy2-dy36 [aweight=wttalg], absorb(id) cluster(id) 

* (5)-(8): Relative  firm-specific stock return volatility     
* (5)                                                                                                        
areg lsrm litl       ipo10l                           dy2-dy36 [aweight=wttalg], absorb(id) cluster(id) 
* (6) 
areg lsrm litl lrdl  ipo10l        lsizel herfl       dy2-dy36 [aweight=wttalg], absorb(id) cluster(id)                                                                                                                                     
* (7)
areg lsrm litl       ipo20l                           dy2-dy36 [aweight=wttalg], absorb(id) cluster(id) 
* (8)
areg lsrm litl lrdl  ipo20l        lsizel herfl       dy2-dy36 [aweight=wttalg], absorb(id) cluster(id) 


translate table.smcl table.txt, replace   
exit         

