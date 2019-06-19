* label.do FILE

* This do-file attaches a label to the relevant variables in SCF2004.

* Alessandro Bucciol (alessandro.bucciol@univr.it)
* University of Verona
* March 2010

********************************************************************



label variable id "observation id"
label variable imp "observation imputation"
label variable x42001 "(x42001) sampling weight"
label variable x5702 "(x5702) family income before taxes, from wages and salaries"
label variable x5704 "(x5704) family income before taxes, from businesses"
label variable x5706 "(x5706) family income before taxes, from non-taxable investments"
label variable x5708 "(x5708) family income before taxes, from other interests"
label variable x5710 "(x5710) family income before taxes, from dividends"
label variable x5712 "(x5712) family income before taxes, from funds-stock trading"
label variable x5714 "(x5714) family income before taxes, from net rents, trusts, etc."
label variable x5716 "(x5716) family income before taxes, from unemployment"
label variable x5718 "(x5718) family income before taxes, from child support"
label variable x5720 "(x5720) family income before taxes, from food stamps"
label variable x5722 "(x5722) family income before taxes, from Social Security"
label variable x5724 "(x5724) family income before taxes, from other sources"
label variable x5729 "(x5729) total family income before taxes"
label variable x101 "(x101) people in the household"
label variable x8021 "(x8021) sex head"
* 1.  Male
* 2.  Female
label variable x8022 "(x8022) age head"
label variable x8023 "(x8023) marital status head"
* 1.  Married
* 2.  Living with partner
* 3.  Separated
* 4.  Divorced
* 5.  Widowed
* 6.  Never married
label variable x5901 "(x5901) education head"
label variable x6809 "(x6809) race head"
* 1.  White (include middle eastern and arab)/Caucasian
* 2.  Black/African-American
* 3.  Hispanic/Latino
* 4.  Asian
* 5.  American indian/Alaska native
* 6.  Native Hawaiian/Pacific islander
* -7. Other
label variable x6030 "(x6030) self-assessed health head"
* 1.  Excellent
* 2.  Good
* 3.  Fair
* 4.  Poor
label variable x4100 "(x4100) work status of the head"
label variable x4106 "(x4106) employee or self-employed status of the head"
* 0.  Inappliable
* 1.  Employee
* 2.  Self-employed
label variable x7402 "(x7402) kind of business-industry of the head"
* 0.  Inappliable
* 1.  ~ Agricolture
* 2.  ~ Mining
* 3.  ~ Manifacturing
* 4.  ~ Trade
* 5.  ~ Finance
* 6.  ~ Services
* 7.  ~ Public administration
label variable x7401 "(x7401) primary job occupation title of the head"
* 0.  Inappliable
* 1.  ~ Executive/Manager/Scientist
* 2.  ~ Technician
* 3.  ~ Supervisor
* 4.  ~ Constructor/Producer
* 5.  ~ Operator
* 6.  ~ Farmer
label variable x4112 "(x4112)  income before taxes of the head"
label variable x4113 "(x4113) income frequency of the head"
label variable x5306 "(x5306) pension of the head"
label variable x5307 "(x5307) pension frequency of the head"
label variable x103 "(x103) sex partner"
* 1.  Male
* 2.  Female
label variable x104 "(x104) age partner"
label variable x105 "(x105) marital status partner"
* 1.  Married
* 2.  Living with partner
* 3.  Separated
* 4.  Divorced
* 5.  Widowed
* 6.  Never married
label variable x6101 "(x6101) education partner"
label variable x6810 "(x6810) race partner"
* 1.  White (include middle eastern and arab)/Caucasian
* 2.  Black/African-American
* 3.  Hispanic/Latino
* 4.  Asian
* 5.  American indian/Alaska native
* 6.  Native Hawaiian/Pacific islander
* -7. Other
label variable x6124 "(x6124) self-assessed health partner"
label variable x4700 "(x4700) work status of the partner"
* 11. Worker only
* 12. Worker + disabled
* 13. Worker + retired
* 14. Worker + student
* 15. Worker + homemaker
* 16. Worker + unemployed/looking for work
* 17. Worker + temporarily laid off
* 20. Temporarily laid off, expecting to return to work
* 21. Temporarily laid off, not expecting to return to job and no current work
* 22. On sick/maternity leave and expecting to return to work (also including disabled)
* 23. On sick/maternity leave, but not expecting to return to work
* 24. On sabbatical and expecting to go back to work
* 30. Unemployed and looking for work (also including homemaker, student, disabled)
* 50. Retired, retired + disabled, retired + unemployed, retired + homemaker, retired + student
* 52. Disabled (also including student, homemaker, and laid off but not expecting to return to work)
* 70. Student (also including homemaker)
* 80. Homemaker/other not in labor force only
* 85. Unpaid volunteer
* 90. Unpaid family workers: R's who volunteer that they work in a family business or farm and are unpaid.
*     (Do not include here "volunteer work" for charitable or non-profit organizations.)
* 96. Other combination incl. WORKER beside 11, 12, 13,14, 15 ,16, 17
* 97. Other (incl. combination) not including WORKER
label variable x4706 "(x4706) employee or self-employed status of the partner"
* 0.  Inappliable
* 1.  Employee
* 2.  Self-employed
label variable x7412 "(x7412) kind of business-industry of the partner"
* 0.  Inappliable
* 1.  ~ Agricolture
* 2.  ~ Mining
* 3.  ~ Manifacturing
* 4.  ~ Trade
* 5.  ~ Finance
* 6.  ~ Services
* 7.  ~ Public administration
label variable x7411 "(x7411) primary job position of the partner"
* 0.  Inappliable
* 1.  ~ Executive/Manager/Scientist
* 2.  ~ Technician
* 3.  ~ Supervisor
* 4.  ~ Constructor/Producer
* 5.  ~ Operator
* 6.  ~ Farmer
label variable x4712 "(x4712) income before taxes of the partner"
label variable x4713 "(x4713) income frequency of the partner"
label variable x5311 "(x5311) pension of the partner"
label variable x5312 "(x5312) pension frequency of the partner"
label variable x301 "(x301) expectations for the future"
* 1.  Better
* 2.  Worse
* 3.  About the same
label variable x3014 "(x3014) self-assessed risk aversion"
* 1.  modest risk aversion
* 2.  low risk aversion
* 3.  high risk aversion
* 4.  severe risk aversion
label variable x3008 "(x3008) time horizon planning"
* 1.  next few months
* 2.  next year
* 3.  next few years
* 4.  next 5-10 years
* 5.  longer than 10 years
label variable x7112 "(x7112) investment advisor"
* 1.  Call around
* 2.  Magazines / newspapers / books
* 3.  Material in the mail
* 4.  Television / radio
* 5.  Online services / internet
* 6.  Advertisements
* 7.  Friend / relative
* 8.  Lawyer
* 9.  Accountant
* 10. Banker
* 11. Broker
* 12. Financial planner
* 13. Self / spouse or partner
* 14. Do not save or invest
* 16. Do not shop around / always use same institution
* 17. Past experience
* 18. Material from work / business contacts
* 19. Investment clubs
* 20. Investment seminars
* 21. Other personal research
* 22. Shop around
* 23. Store / dealer
* 24. Insurance agent
* 32. Telemarketer
* -7. Other
label variable x3504 "(x3504) number of checking accounts"
label variable x7111 "(x7111) shop around for best rates on saving and investments"
* 1. almost no shopping
* 2.
* 3. moderate shopping
* 4.
* 5. a great deal of shopping
label variable x7100 "(x7100) shop around for best rates on credit and borrowing"
* 1. almost no shopping
* 2.
* 3. moderate shopping
* 4.
* 5. a great deal of shopping
label variable x6497 "(x6497) computer use to manage money"
* 0. no
* 1. yes
label variable x8300 "(x8300) number of institutions where doing business"
label variable x7132 "(x7132) interest rate on the main credit card"

label variable x5801 "=1 if ever received bequest"
* 0. no
* 1. yes
label variable x5802 "Number of received bequest"
label variable x5819 "=1 if expect to leave bequest"
* 0. no
* 1. yes
label variable x5821 "Expected bequest to leave"
label variable x5824 "Important to leave assets"
* 1. very important
* 2. important
* 3. R and SP/PARTNER DIFFER
* 4. somewhat important
* 5. not important
label variable x5825 "Expect to leave estate"
* 1. yes
* 3. possibly
* 5. no

label variable finwth "household financial wealth"
label variable flagfin ">0 if risk free financial portfolio"
label variable wftran "financial weight transaction accounts"
label variable wfbond "financial weight bonds"
label variable wfstok "financial weight stocks"
label variable totwth "household total wealth"
label variable flagtot ">0 if risk free total portfolio"
label variable wttran "total weight trasaction accounts"
label variable wtbond "total weight bonds"
label variable wtstok "total weight stocks"
label variable wthcap "total weight human capital"
label variable wtrest "total weight real estate"
label variable wthous "total weight housing"

label variable portsd0 "observed narrow portfolio standard deviation"
label variable opt0_tran "optimal narrow portfolio (unconstrained) - transaction accounts"
label variable opt0_bond "optimal narrow portfolio (unconstrained) - bonds"
label variable opt0_stok "optimal narrow portfolio (unconstrained) - stocks"
label variable rtol0 "optimal narrow portfolio (unconstrained) - risk tolerance"
label variable bias0 "optimal narrow portfolio (unconstrained) - optimization bias"

label variable opt1_tran "optimal narrow portfolio (constrained) - transaction accounts"
label variable opt1_bond "optimal narrow portfolio (constrained) - bonds"
label variable opt1_stok "optimal narrow portfolio (constrained) - stocks"
label variable rtol1 "optimal narrow portfolio (constrained) - risk tolerance"
label variable bias1 "optimal narrow portfolio (constrained) - optimization bias"

label variable portsd2 "observed broad portfolio standard deviation"
label variable opt2_tran "optimal broad portfolio (unconstrained) - transaction accounts"
label variable opt2_bond "optimal broad portfolio (unconstrained) - bonds"
label variable opt2_stok "optimal broad portfolio (unconstrained) - stocks"
label variable opt2_hcap "optimal broad portfolio (unconstrained) - human capital"
label variable opt2_rest "optimal broad portfolio (unconstrained) - real estate"
label variable rtol2 "optimal broad portfolio (unconstrained) - risk tolerance"
label variable bias2 "optimal broad portfolio (unconstrained) - optimization bias"

label variable opt3_tran "optimal broad portfolio (constrained) - transaction accounts"
label variable opt3_bond "optimal broad portfolio (constrained) - bonds"
label variable opt3_stok "optimal broad portfolio (constrained) - stocks"
label variable opt3_hcap "optimal broad portfolio (constrained) - human capital"
label variable opt3_rest "optimal broad portfolio (constrained) - real estate"
label variable rtol3 "optimal broad portfolio (constrained) - risk tolerance"
label variable bias3 "optimal broad portfolio (constrained) - optimization bias"
