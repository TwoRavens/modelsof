Choosing Lobbying Sides: The General Data Protection Regulation of the EU
Journal of Public Policy
Ece Özlem Atikcan & Adam William Chalmers

Replication Do file

************************************************************************
Table 1: Interest Groups by Economic Activity
************************************************************************

tab isic_division

ISIC_divisision
11	Manufacture of beverages
21	Manufacture of pharmaceuticals, medicinal chemical and botanical products
26	Manufacture of computer, electronic and optical products
47	Retail trade, except of motor vehicles and motorcycles
51	Air transport
53	Postal and courier activities
58	Publishing activities
59	Motion picture, video and television programme production, sound recording and music publishing activities
60	Programming and broadcasting activities
61	Telecommunications
62	Computer programming, consultancy and related activities
63	Information service activities
64	Financial service activities, except insurance and pension funding
65	Insurance, reinsurance and pension funding, except compulsory social security
66	Activities auxiliary to financial service and insurance activities
68	Real estate activities
69	Legal and accounting activities
70	Activities of head offices; management consultancy activities
72	Scientific research and development
73	Advertising and market research
77	Rental and leasing activities
79	Travel agency, tour operator, reservation service and related activities
82	Office administrative, office support and other business support activities
84	Public administration and defence; compulsory social security
85	Education
86	Human health activities
88	Social work activities without accommodation
90	Creative, arts and entertainment activities
92	Gambling and betting activities
93	Sports activities and amusement and recreation activities
94	Activities of membership organizations

************************************************************************
Table 2. Determinants of Interest Group Preferences
************************************************************************

*Model 1: Baseline
meologit position Salience staff national european , or || countries:|| consult:

*Model 2: H1 
eststo: quietly meologit position LateCompliers safehabor Salience staff national european , or || countries:|| consult:

*Model 3: H2 
meologit position ngos Concentrated  Salience staff national european, or || countries:|| consult:

*Model 4: H3
meologit position Finance Retail  Technology Entertainment  Salience staff national european , or || countries:|| consult:

*Model 5: Complete model
meologit position Finance Retail Technology Entertainment ngos Concentrated LateCompliers safehabor Salience staff national european , or || countries:|| consult:



************************************************************************
Figure 1. Effects of Late Compliers on Lobbying Preferences
************************************************************************

ologit position LateCompliers safehabor Salience staff national european
margins, at (LateCompliers =(0 1)) 
marginsplot, recast(scatter)  scheme(plotplain) 


************************************************************************
Figure 2. Effects of Concentrated interest groups on Lobbying Preferences
************************************************************************

ologit position ngos Concentrated  Salience staff national european
margins, at (Concentrated =(0 1))
marginsplot, recast(scatter) scheme(plotplain) 


************************************************************************
Figure 3. Effects of Sector-specific costs on Lobbying Preferences
************************************************************************

ologit position Finance Retail Technology Entertainment  Salience staff national european
margins, at (Finance =(0 1)) 
marginsplot,  recast(scatter)  scheme(plotplain) saving(GraphA)

ologit position Finance Retail Technology Entertainment  Salience staff national european
margins, at (Retail =(0  1)) 
marginsplot,  recast(scatter)  scheme(plotplain) saving(GraphB)

ologit position Finance Retail Technology Entertainment  Salience staff national european
margins, at (Technology =(0 1)) 
marginsplot,  recast(scatter)  scheme(plotplain) saving(GraphC)
 
ologit position Finance Retail Technology Entertainment  Salience staff national european
margins, at (Entertainment =(0  1)) 
marginsplot,  recast(scatter)  scheme(plotplain) saving(GraphD)

grc1leg GraphA.gph GraphB.gph GraphC.gph GraphD.gph, iscale(1)  ycommo legendfrom(GraphA.gph) 



************************************************************************
Table A1. Summary Statistics
************************************************************************

sum position Finance Retail Technology Entertainment ngos Concentrated LateCompliers safehabor Salience staff national european 


************************************************************************
Table A1. Logistic and Multinomial Logistic Regression Analyses 
Examining the Determinants of Interest Group Preferences
************************************************************************

*Model 1: Logistic Regresson
logit DV_binary Finance Retail Technology Entertainment ngos Concentrated LateCompliers safehabor Salience staff national european , or

*Model 2 and 3: Multinomial Logit
mlogit position Finance Retail Technology Entertainment ngos Concentrated LateCompliers safehabor Salience staff national european, rrr

eststo: quietly logit DV_binary Finance Retail Technology Entertainment ngos Concentrated LateCompliers safehabor Salience staff national european , or


eststo: quietly mlogit position Finance Retail Technology Entertainment ngos Concentrated LateCompliers safehabor Salience staff national european, rrr

esttab using Table_2.rtf, se compress eform  star  (* 0.05 ** 0.01 *** 0.001 ) 
eststo clear

************************************************************************
Figure A1. Distribution of Interest Groups by Country
************************************************************************

graph bar (count), over(countries)

************************************************************************
Table A2. Interest Groups Types
************************************************************************

tab ig_subtype

*ig_subtype
1	Professional consultancies
2	Law firms
3	Self-employed consultants
4	Companies & groups
5	Trade, business & professional associations
6	Trade unions
7	Other similar organisations
8	Non-governmental organisations, platforms and networks and similar
9	Think tanks and research institutions
10	Academic institutions
11	Organisations representing churches and religious communities
12	Local, regional and municipal authorities (at sub-national level)
13	Other public or mixed entities, etc.
14	other

************************************************************************
Table A3. Correlation Matrix
************************************************************************

pwcorr Finance Retail Technology Entertainment ngos Concentrated LateCompliers safehabor Salience staff national european 

