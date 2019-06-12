*****"Better Angels of Our Nature" (American Journal of Political Science) replication code**** 
 *****Study 1: The Citizenship Experiment Conducted using the British Comparative Campaign Analysis Project data****
***Study 1 robustness checks do file (see Online Appendix)***
***Code compiled by Robert Ford (rob.ford@manchester.ac.uk)
***This version: 29th January 2013
****Run using "better angels study 1 bccap final.dta", which is in the "Better Angels of Our Nature" folder at dataverse****

***Robustness checks

***1: Tests of main effects (MCP and citizenship manipulation)

****Model 1: MCP and citizenship condition only

xi: nestreg: reg grant (asycit) (mcp01) if nonwhite==0
xi: nestreg: ologit grant (asycit) (mcp01) if nonwhite==0

***Model 2: 1 + immigration attitudes

xi: nestreg: reg grant (asycit) (mcp01) (immscale01) if nonwhite==0
xi: nestreg: ologit grant (asycit) (mcp01) (immscale01) if nonwhite==0

****Model 3: 2 + controls for message conditions

xi: nestreg: reg grant (asycit mcp01) (newsonly pakasy rusasy newscorrect supmin estasy) (immscale01) if nonwhite==0
xi: nestreg: ologit grant (asycit mcp01) (newsonly pakasy rusasy newscorrect supmin estasy) (immscale01) if nonwhite==0

***Model 4: 3 + full demographics

#delimit ;
xi: nestreg: reg grant (asycit mcp01) ( i.gender) (newsonly pakasy rusasy newscorrect supmin estasy) 
(gcse alevel degree othqual edumiss ageunder30 age30s age40s age50s profman rnonm petbou skilman unionmember incbens rentpriv rentla north mids) (immscale01) if nonwhite==0 ;

#delimit ;
xi: nestreg: ologit grant (asycit mcp01) ( i.gender) (newsonly pakasy rusasy newscorrect supmin estasy) 
(gcse alevel degree othqual edumiss ageunder30 age30s age40s age50s profman rnonm petbou skilman unionmember incbens rentpriv rentla north mids) (immscale01) if nonwhite==0 ;

****Model 5: 4 + full political controls (excluding government performance on asylum owing to collinearity) 

#delimit ;
reg grant asycit mcp01  i.gender newsonly pakasy rusasy newscorrect supmin estasy gcse alevel degree othqual edumiss 
ageunder30 age30s age40s age50s profman rnonm petbou skilman unionmember incbens rentpriv rentla north mids immscale01
gbcompw2 dccompw2 nccompw2 crimeupw2 nhsworsew2 govperfcrimw2 govperfnhsw2 govperfterw2  
lrselfplacew2 lrlabplacew2 lrldplacew2 lrconplacew2 natecoretw2 natecoprospw2 perecoretw2 perecoprospw2 polintw2 satdemw2 
conIDw1 labIDw1 ldIDw1 if nonwhite==0 ;

#delimit ;
ologit grant asycit mcp01  i.gender newsonly pakasy rusasy newscorrect supmin estasy gcse alevel degree othqual edumiss 
ageunder30 age30s age40s age50s profman rnonm petbou skilman unionmember incbens rentpriv rentla north mids immscale01
gbcompw2 dccompw2 nccompw2 crimeupw2 nhsworsew2 govperfcrimw2 govperfnhsw2 govperfterw2  
lrselfplacew2 lrlabplacew2 lrldplacew2 lrconplacew2 natecoretw2 natecoprospw2 perecoretw2 perecoprospw2 polintw2 satdemw2 
conIDw1 labIDw1 ldIDw1 if nonwhite==0 ;


***1: Tests of main and interaction effects (MCP and citizenship manipulation)


****Model 1: MCP and citizenship condition only


xi: nestreg: reg grant01 (asycit) (mcpmediansplit) (mcpXasy) if nonwhite==0
xi: nestreg: ologit grant (asycit) (mcpmediansplit) (mcpXasy) if nonwhite==0

***Model 2: 1 + immigration attitudes

xi: nestreg: reg grant (asycit) (mcpmediansplit) (mcpXasy) (immscale01) if nonwhite==0
xi: nestreg: ologit grant (asycit) (mcpmediansplit) (mcpXasy) (immscale01) if nonwhite==0


****Model 3: 2 + controls for message conditions

xi: nestreg: reg grant (asycit) (mcpmediansplit) (mcpXasy) (newsonly pakasy rusasy newscorrect supmin estasy) (immscale01) if nonwhite==0
xi: nestreg: ologit grant (asycit) (mcpmediansplit) (mcpXasy) (newsonly pakasy rusasy newscorrect supmin estasy) (immscale01) if nonwhite==0

***Model 4: 3 + full demographics

#delimit ;
xi: nestreg: reg grant (asycit) (mcpmediansplit) (mcpXasy)( i.gender) (newsonly pakasy rusasy newscorrect supmin estasy) 
(gcse alevel degree othqual edumiss ageunder30 age30s age40s age50s profman rnonm petbou skilman unionmember incbens rentpriv rentla north mids) (immscale01) if nonwhite==0 ;

#delimit ;
xi: nestreg: ologit grant (asycit) (mcpmediansplit) (mcpXasy)( i.gender) (newsonly pakasy rusasy newscorrect supmin estasy) 
(gcse alevel degree othqual edumiss ageunder30 age30s age40s age50s profman rnonm petbou skilman unionmember incbens rentpriv rentla north mids) (immscale01) if nonwhite==0 ;


****Model 5: 4 + full political controls

#delimit ;
reg grant asycit mcpmediansplit mcpXasy  i.gender newsonly pakasy rusasy newscorrect supmin estasy gcse alevel degree othqual edumiss 
ageunder30 age30s age40s age50s profman rnonm petbou skilman unionmember incbens rentpriv rentla north mids immscale01
gbcompw2 dccompw2 nccompw2 crimeupw2 nhsworsew2 govperfcrimw2 govperfnhsw2 govperfterw2  
lrselfplacew2 lrlabplacew2 lrldplacew2 lrconplacew2 natecoretw2 natecoprospw2 perecoretw2 perecoprospw2 polintw2 satdemw2 
conIDw1 labIDw1 ldIDw1 if nonwhite==0 ;

#delimit ;
ologit grant asycit mcpmediansplit mcpXasy  i.gender newsonly pakasy rusasy newscorrect supmin estasy gcse alevel degree othqual edumiss 
ageunder30 age30s age40s age50s profman rnonm petbou skilman unionmember incbens rentpriv rentla north mids immscale01
gbcompw2 dccompw2 nccompw2 crimeupw2 nhsworsew2 govperfcrimw2 govperfnhsw2 govperfterw2  
lrselfplacew2 lrlabplacew2 lrldplacew2 lrconplacew2 natecoretw2 natecoprospw2 perecoretw2 perecoprospw2 polintw2 satdemw2 
conIDw1 labIDw1 ldIDw1 if nonwhite==0 ;


