

// 1992 ANES
use "/Users/dbroock/Google Drive/Broockman/Datasets/ANES/NES in STATA/nes1992_first_11.dta", clear


// abortion
tab VAR900479 if inlist(VAR900479, 1, 2, 3, 4) [aw=VAR923008]
// median = established reasons only (3)


// helping blacks
tab VAR900447 if inrange(VAR900447, 1, 7) [aw=VAR923008]
// median = 5, but knife edge at 4


// women's rights
tab VAR900438 if inrange(VAR900438, 1, 7) [aw=VAR923008]
// median = 2, but knife edge at 1


// solve int'l problems
tab VAR912402 if inrange(VAR912402, 1, 5) [aw=VAR923008]
// median = 3


// services
tab VAR900452 if inrange(VAR900452, 1, 7) [aw=VAR923008]
// median = 4


// sexual harrassment
tab VAR923741 if inrange(VAR923741, 1, 3) [aw=VAR923008]
// median = 2



// 1992 CDS
use "~/Dropbox/Broockman-Skovron/Elite perceptions 2/1992 Convention Delegate Study/06353-0001.DTA", clear


// keep elected office holders only
keep if V0410 == 1


// define party label
label define party 1 "D" 2 "R"
label values party party 

/* abortion
            [1] By law, abortion should never be permitted                     
            [2] The law should permit abortion only in case of rape ...        
            [3] The law should permit abortion for reasons other/clearly       
                 established                                                   
            [4] By law, a woman should always be able to/by choice      
			*/
tab V0111
recode V0111 (1/2 = -1) (3 = 0) (4 = 1) (nonmis=.)


/* helping blacks      V0127      (141)       The national electorate                           
                                                                               
            [1] Government should help blacks                                  
            [2]                                                                
            [3]                                                                
            [4]                                                                
            [5]                                                                
            [6]                                                                
            [7] Blacks should help themselves    */
tab V0127
recode V0127 (1/4=1) (5=0) (6/7=-1) (nonmis=.)

			
/* Recently there has been a lot of talk about women's                        
    rights. Some people feel that women should have an equal role with         
    men in running business, industry, and government. Others feel that        
    women's place is in the home. First, where would you place yourself        
    on the following scale? Then, we're interested where you would place       
    other groups on this scale. (Mark one for each row)                        
                                                                                                    
      V0133      (147)       The national electorate                           
                                                                               
            [1] Women and men should have an equal role                        
            [2]                                                                
            [3]                                                                
            [4]                                                                
            [5]                                                                
            [6]                                                                
            [7] Women's place is in the home                                   
                                                                               
            [9] Missing    */
tab V0133
recode V0133 (1 = 1) (2 = 0) (3/7 = -1) (nonmis = .)


/*	In the future, how willing should the United States be                     
    to use military force to solve international problems. Would               
    you say extremely willing, very willing, somewhat willing, not very        
    willing, or never willing? First, where would you place yourself on        
    this scale. Then, we're interested where you would place other persons     
    and groups on this same scale. (Mark one for each row).                    
                                                                                                   
      V0139      (153)       The national electorate                                                                
                                                                               
            [1] Extremely willing      - More Rs                                     
            [2] Very willing                                                   
            [3] Somewhat willing                                               
            [4] Not very willing                                               
            [5] Never willing           - More Ds                                        
                                                                               
            [9] Missing  */ 
tab V0139
recode V0139 (1/2=1) (3=0) (4/5=-1) (nonmis = .)
                                                                               
/*29. Some people think the government should provide fewer                      
    services, even in areas such as health and education in order to           
    reduce spending.                                                           
                                                                                                   
      V0148      (162)       The national electorate                                                           
                                                                               
            [1] Government provide many fewer services                         
            [2]                                                                
            [3]                                                                
            [4]                                                                
            [5]                                                                
            [6]                                                                
            [7] Government provide many more services                          
                                                                               
            [9] Missing    */                                                    
tab V0148
recode V0148 (1/3=-1) (4=0) (5/7=1) (nonmis = .)
	
                                                                               
/* 31. Recently there has been a lot of discussion about sexual                   
    harassment. How serious a problem do you think sexual harassment           
    in the work place is? Is it very serious, somewhat serious, or not         
    too serious?  First, where would you place yourself on this scale?         
    Then, we're interested where you would place other groups on this          
    scale. (Mark one in each row)                                              
                      
      V0158      (172)       The national electorate                           
                                                                               
            [1] Very serious                                                   
            [2] Somewhat serious                                               
            [3] Not too serious                                                
                                                                               
            [9] Missing    */
tab V0158
recode V0158 (1=1) (2=0) (3=-1) (nonmis = .)

// results
tab party V0111, ro // abortion
tab party V0127, ro // helping blacks
// tab party V0133, ro // women's rights -- not really a policy issue
// tab party V0139, ro // military solve int'l problems - no clear partisan side
tab party V0148, ro // services
// tab party V0158, ro // sexual harrassment -- not really a policy issue
			
			
