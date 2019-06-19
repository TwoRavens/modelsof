* portall.do FILE

* This do-file constructs portfolios from SCF2004

* Alessandro Bucciol (alessandro.bucciol@univr.it)
* University of Verona
* March 2010

********************************************************************



* GENERATE WEIGHTS
gen irahead = x6551 + x6552 + x6553 + x6554 /* IRA-KEOGH accounts of the head */
gen irapart = x6559 + x6560 + x6561 + x6562 /* IRA-KEOGH accounts of the partner */
gen iraother = x6567 + x6568 + x6569 + x6570 /* IRA-KEOGH accounts of other household members */
gen retacc = x6462 + x6467 + x6472 + x6477 + x6482 + x6487 + x5604 + x5612 + x5620 + x5628 + x5636 + x5644 /* Retirement accounts */
gen ann = x6577 + x6587 /* Annuities */



********************************************************************
* CONSTRUCT THE AGGREGATES TO BE CONSIDERED IN THE ANALYSIS


* TRANSACTION ACCOUNTS (DEPOSITS)
* includes checking accounts, savings accounts, brokerage accounts,
* and part of IRA-KEOGH and retirement accounts, annuities, and trust-managed accounts

gen tranchk = x3506 + x3510 + x3514 + x3518 + x3522 + x3526 + x3529 /* Checking accounts */
gen transav = x3730 + x3736 + x3742 + x3748 + x3754 + x3760 + x3765 /* Savings-money market accounts */
gen tranbrok = x3930 /* Brokerage accounts */
gen tranira = 0
replace tranira = tranira + irahead if x6555==2 /* IRA-KEOGH accounts invested in int. earning assets */
replace tranira = tranira + irapart if x6563==2 /* IRA-KEOGH accounts invested in int. earning assets */
replace tranira = tranira + iraother if x6571==2 /* IRA-KEOGH accounts invested in int. earning assets */
gen tranret = 0
replace tranret = tranret + x6462 if x6933==2 /* Retirement accounts invested in int. earning assets */
replace tranret = tranret + x6467 if x6937==2 /* Retirement accounts invested in int. earning assets */
replace tranret = tranret + x6472 if x6941==2 /* Retirement accounts invested in int. earning assets */
replace tranret = tranret + x6477 if x6945==2 /* Retirement accounts invested in int. earning assets */
replace tranret = tranret + x6482 if x6949==2 /* Retirement accounts invested in int. earning assets */
replace tranret = tranret + x6487 if x6953==2 /* Retirement accounts invested in int. earning assets */
replace tranret = tranret + x5604 if x6962==2 /* Previous retirement accounts invested in int. earning assets */
replace tranret = tranret + x5612 if x6968==2 /* Previous retirement accounts invested in int. earning assets */
replace tranret = tranret + x5620 if x6974==2 /* Previous retirement accounts invested in int. earning assets */
replace tranret = tranret + x5628 if x6980==2 /* Previous retirement accounts invested in int. earning assets */
replace tranret = tranret + x5636 if x6986==2 /* Previous retirement accounts invested in int. earning assets */
replace tranret = tranret + x5644 if x6992==2 /* Previous retirement accounts invested in int. earning assets */
gen tranann = 0
replace tranann = tranann + x6577 if x6581==2 /* Annuities invested in int. earning assets */
gen trantru = 0
replace trantru = trantru + x6587 if x6591==2 /* Trust-managed accounts invested in int. earning assets */

gen tran = tranchk + transav + tranbrok + tranira + tranret + tranann + trantru



* BONDS
* Includes government bonds, corporate bonds, debt and credit card balance

* Government bonds
* includes certificates of deposits, savings bonds, bond mutual funds, life insurance, mortgage, and lines of credit
* mortgage and lines of credit are negative
gen govcrt = x3721 /* Certificates of deposit */
gen govsav = x3902 /* Savings bonds (Gov't bonds) */
gen govtax = 0
replace govtax = govtax + x3824 /* Tax-free bond mutual funds */
gen govmut = 0
replace govmut = govmut + x3826 /* Gov't bond mutual funds */
gen govlif = x4006-x4010 /* Life insurance */
gen govbond = govcrt + govsav + govtax + govmut + govlif

* Corporate bonds
* includes market value of bonds, bond mutual funds, 1/2 balanced mutual funds,
* and part of IRA-KEOGH and retirement accounts, annuities and trust-managed accounts
gen cormkt = x7635 + x7636 + x7637 + x7638 + x7639 /* Market value corporate bonds */
gen coroth = x3828 /* Other bond mutual funds */
gen corbal = x3830/2 /* Balanced mutual funds */
gen corotm = x7787/2 /* Other mutual funds */
gen corira = 0
replace corira = corira + irahead*(1-x6556/10000) if x6555==3 /* IRA-KEOGH accounts invested in stocks and other assets */
replace corira = corira + irapart*(1-x6564/10000) if x6563==3 /* IRA-KEOGH accounts invested in stocks and other assets */
replace corira = corira + iraother*(1-x6572/10000) if x6571==3 /* IRA-KEOGH accounts invested in stocks and other assets */
replace corira = corira + irahead if x6555==6 /* IRA-KEOGH accounts invested in annuities */
replace corira = corira + irapart if x6563==6 /* IRA-KEOGH accounts invested in annuities */
replace corira = corira + iraother if x6571==6 /* IRA-KEOGH accounts invested in annuities */
replace corira = corira + irahead if x6555==-7 /* IRA-KEOGH accounts invested in other assets */
replace corira = corira + irapart if x6563==-7 /* IRA-KEOGH accounts invested in other assets */
replace corira = corira + iraother if x6571==-7 /* IRA-KEOGH accounts invested in other assets */
gen corret = 0
replace corret = corret + x6462*(1-x6934/10000) if x6933==3 /* Retirement accounts invested in stocks and other assets */
replace corret = corret + x6467*(1-x6938/10000) if x6937==3 /* Retirement accounts invested in stocks and other assets */
replace corret = corret + x6472*(1-x6942/10000) if x6941==3 /* Retirement accounts invested in stocks and other assets */
replace corret = corret + x6477*(1-x6946/10000) if x6945==3 /* Retirement accounts invested in stocks and other assets */
replace corret = corret + x6482*(1-x6950/10000) if x6949==3 /* Retirement accounts invested in stocks and other assets */
replace corret = corret + x6487*(1-x6954/10000) if x6953==3 /* Retirement accounts invested in stocks and other assets */
replace corret = corret + x6462 if x6933==6 /* Retirement accounts invested in annuities */
replace corret = corret + x6467 if x6937==6 /* Retirement accounts invested in annuities */
replace corret = corret + x6472 if x6941==6 /* Retirement accounts invested in annuities */
replace corret = corret + x6477 if x6945==6 /* Retirement accounts invested in annuities */
replace corret = corret + x6482 if x6949==6 /* Retirement accounts invested in annuities */
replace corret = corret + x6487 if x6953==6 /* Retirement accounts invested in annuities */
replace corret = corret + x6462 if x6933==-7 /* Retirement accounts invested in other assets */
replace corret = corret + x6467 if x6937==-7 /* Retirement accounts invested in other assets */
replace corret = corret + x6472 if x6941==-7 /* Retirement accounts invested in other assets */
replace corret = corret + x6477 if x6945==-7 /* Retirement accounts invested in other assets */
replace corret = corret + x6482 if x6949==-7 /* Retirement accounts invested in other assets */
replace corret = corret + x6487 if x6953==-7 /* Retirement accounts invested in other assets */
replace corret = corret + x5604*(1-x6963/10000) if x6962==3 /* Previous retirement accounts invested in stocks and other assets */
replace corret = corret + x5612*(1-x6969/10000) if x6968==3 /* Previous retirement accounts invested in stocks and other assets */
replace corret = corret + x5620*(1-x6975/10000) if x6974==3 /* Previous retirement accounts invested in stocks and other assets */
replace corret = corret + x5628*(1-x6981/10000) if x6980==3 /* Previous retirement accounts invested in stocks and other assets */
replace corret = corret + x5636*(1-x6987/10000) if x6986==3 /* Previous retirement accounts invested in stocks and other assets */
replace corret = corret + x5644*(1-x6993/10000) if x6992==3 /* Previous retirement accounts invested in stocks and other assets */
replace corret = corret + x5604 if x6962==6 /* Previous retirement accounts invested in annuities */
replace corret = corret + x5612 if x6968==6 /* Previous retirement accounts invested in annuities */
replace corret = corret + x5620 if x6974==6 /* Previous retirement accounts invested in annuities */
replace corret = corret + x5628 if x6980==6 /* Previous retirement accounts invested in annuities */
replace corret = corret + x5636 if x6986==6 /* Previous retirement accounts invested in annuities */
replace corret = corret + x5644 if x6992==6 /* Previous retirement accounts invested in annuities */
replace corret = corret + x5604 if x6962==-7 /* Previous retirement accounts invested in other assets */
replace corret = corret + x5612 if x6968==-7 /* Previous retirement accounts invested in other assets */
replace corret = corret + x5620 if x6974==-7 /* Previous retirement accounts invested in other assets  */
replace corret = corret + x5628 if x6980==-7 /* Previous retirement accounts invested in other assets  */
replace corret = corret + x5636 if x6986==-7 /* Previous retirement accounts invested in other assets  */
replace corret = corret + x5644 if x6992==-7 /* Previous retirement accounts invested in other assets */
gen corann = 0
replace corann = corann + x6577*(1-x6582/10000) if x6581==3 /* Annuities invested in stocks and other assets */
replace corann = corann + x6577 if x6581==6 /* Annuities invested in annuities */
replace corann = corann + x6577 if x6581==-7 /* Annuities invested in other assets */
gen cortru = 0
replace cortru = cortru + x6587*(1-x6592/10000) if x6591==3 /* Trust-managed accounts invested in stocks and other assets */
replace cortru = cortru + x6587 if x6591==6 /* Trust-managed accounts invested in annuities */
replace cortru = cortru + x6587 if x6591==-7 /* Trust-managed accounts invested in other assets */
gen corbond = cormkt + coroth + corbal + corotm + corira + corret + corann + cortru

* Debt
gen govmorthous = 0 /* Mortgage on the house where the household lives */
replace govmorthous = x805 if x6723<=2
replace govmorthous = govmorthous + x905 if x918<=2
replace govmorthous = govmorthous + x1005 if x1018<=2
replace govmorthous = govmorthous + x1044
gen govlineshous = 0 /* Lines of credit on the house where the household lives */
replace govlineshous = govlineshous + x1108 if x1106<=2
replace govlineshous = govlineshous + x1119 if x1117<=2
replace govlineshous = govlineshous + x1130 if x1128<=2
gen govmortrest = x1715 + x1815 + x1915 + x2006 + x2016 /* Loans on other real estate */
replace govmortrest = govmortrest + x1417 + x1517 + x1617 + x1621
replace govmortrest = govmortrest - (x1409 + x1509 + x1609 + x1619) /* Money lent */

gen govdebt = govmorthous + govlineshous + govmortrest
replace govdebt = -govdebt

* Credit card balance
gen ccard = x413 + x421 + x424 + x427 + x430 /* Credit card balance */
replace ccard = -ccard



* STOCKS
* includes directly held stocks, stock mutual funds, 1/2 balanced mutual funds,
* and part of IRA-KEOGH and retirement accounts, annuities and trust-managed accounts

gen stosh = x3915 /* Directly-held stocks */
gen stomut = x3822 /* Stock mutual funds */
gen stobal = x3830/2 /* Balanced mutual funds */
gen stooth = x7787/2 /* Other mutual funds */
gen stoira = 0
replace stoira = stoira + irahead if x6555==1 /* IRA-KEOGH accounts invested in stocks */
replace stoira = stoira + irapart if x6563==1 /* IRA-KEOGH accounts invested in stocks */
replace stoira = stoira + iraother if x6571==1 /* IRA-KEOGH accounts invested in stocks */
replace stoira = stoira + irahead*x6556/10000 if x6555==3 /* IRA-KEOGH accounts invested in stocks and other assets */
replace stoira = stoira + irapart*x6564/10000 if x6563==3 /* IRA-KEOGH accounts invested in stocks and other assets */
replace stoira = stoira + iraother*x6572/10000 if x6571==3 /* IRA-KEOGH accounts invested in stocks and other assets */
replace stoira = stoira + irahead if x6555==5 /* IRA-KEOGH accounts invested in hedge funds */
replace stoira = stoira + irapart if x6563==5 /* IRA-KEOGH accounts invested in hedge funds */
replace stoira = stoira + iraother if x6571==5 /* IRA-KEOGH accounts invested in hedge funds */
replace stoira = stoira + irahead if x6555==8 /* IRA-KEOGH accounts invested in mineral rights */
replace stoira = stoira + irapart if x6563==8 /* IRA-KEOGH accounts invested in mineral rights */
replace stoira = stoira + iraother if x6571==8 /* IRA-KEOGH accounts invested in mineral rights */
gen storet = 0
replace storet = storet + x6462 if x6933==1 /* Retirement accounts invested in stocks */
replace storet = storet + x6467 if x6937==1 /* Retirement accounts invested in stocks */
replace storet = storet + x6472 if x6941==1 /* Retirement accounts invested in stocks */
replace storet = storet + x6477 if x6945==1 /* Retirement accounts invested in stocks */
replace storet = storet + x6482 if x6949==1 /* Retirement accounts invested in stocks */
replace storet = storet + x6487 if x6953==1 /* Retirement accounts invested in stocks */
replace storet = storet + x6462*x6934/10000 if x6933==3 /* Retirement accounts invested in stocks and other assets */
replace storet = storet + x6467*x6938/10000 if x6937==3 /* Retirement accounts invested in stocks and other assets */
replace storet = storet + x6472*x6942/10000 if x6941==3 /* Retirement accounts invested in stocks and other assets */
replace storet = storet + x6477*x6946/10000 if x6945==3 /* Retirement accounts invested in stocks and other assets */
replace storet = storet + x6482*x6950/10000 if x6949==3 /* Retirement accounts invested in stocks and other assets */
replace storet = storet + x6487*x6954/10000 if x6953==3 /* Retirement accounts invested in stocks and other assets */
replace storet = storet + x6462 if x6933==5 /* Retirement accounts invested in hedge funds */
replace storet = storet + x6467 if x6937==5 /* Retirement accounts invested in hedge funds */
replace storet = storet + x6472 if x6941==5 /* Retirement accounts invested in hedge funds */
replace storet = storet + x6477 if x6945==5 /* Retirement accounts invested in hedge funds */
replace storet = storet + x6482 if x6949==5 /* Retirement accounts invested in hedge funds */
replace storet = storet + x6487 if x6953==5 /* Retirement accounts invested in hedge funds */
replace storet = storet + x6462 if x6933==8 /* Retirement accounts invested in mineral rights */
replace storet = storet + x6467 if x6937==8 /* Retirement accounts invested in mineral rights */
replace storet = storet + x6472 if x6941==8 /* Retirement accounts invested in mineral rights */
replace storet = storet + x6477 if x6945==8 /* Retirement accounts invested in mineral rights */
replace storet = storet + x6482 if x6949==8 /* Retirement accounts invested in mineral rights */
replace storet = storet + x6487 if x6953==8 /* Retirement accounts invested in mineral rights */
replace storet = storet + x5604 if x6962==1 /* Previous retirement accounts invested in stocks */
replace storet = storet + x5612 if x6968==1 /* Previous retirement accounts invested in stocks */
replace storet = storet + x5620 if x6974==1 /* Previous retirement accounts invested in stocks */
replace storet = storet + x5628 if x6980==1 /* Previous retirement accounts invested in stocks */
replace storet = storet + x5636 if x6986==1 /* Previous retirement accounts invested in stocks */
replace storet = storet + x5644 if x6992==1 /* Previous retirement accounts invested in stocks */
replace storet = storet + x5604*x6963/10000 if x6962==3 /* Previous retirement accounts invested in stocks and other assets */
replace storet = storet + x5612*x6969/10000 if x6968==3 /* Previous retirement accounts invested in stocks and other assets */
replace storet = storet + x5620*x6975/10000 if x6974==3 /* Previous retirement accounts invested in stocks and other assets */
replace storet = storet + x5628*x6981/10000 if x6980==3 /* Previous retirement accounts invested in stocks and other assets */
replace storet = storet + x5636*x6987/10000 if x6986==3 /* Previous retirement accounts invested in stocks and other assets */
replace storet = storet + x5644*x6993/10000 if x6992==3 /* Previous retirement accounts invested in stocks and other assets */
replace storet = storet + x5604 if x6962==5 /* Previous retirement accounts invested in hedge funds */
replace storet = storet + x5612 if x6968==5 /* Previous retirement accounts invested in hedge funds */
replace storet = storet + x5620 if x6974==5 /* Previous retirement accounts invested in hedge funds */
replace storet = storet + x5628 if x6980==5 /* Previous retirement accounts invested in hedge funds */
replace storet = storet + x5636 if x6986==5 /* Previous retirement accounts invested in hedge funds */
replace storet = storet + x5644 if x6992==5 /* Previous retirement accounts invested in hedge funds */
replace storet = storet + x5604 if x6962==8 /* Previous retirement accounts invested in mineral rights */
replace storet = storet + x5612 if x6968==8 /* Previous retirement accounts invested in mineral rights */
replace storet = storet + x5620 if x6974==8 /* Previous retirement accounts invested in mineral rights */
replace storet = storet + x5628 if x6980==8 /* Previous retirement accounts invested in mineral rights */
replace storet = storet + x5636 if x6986==8 /* Previous retirement accounts invested in mineral rights */
replace storet = storet + x5644 if x6992==8 /* Previous retirement accounts invested in mineral rights */
gen stoann = 0
replace stoann = stoann + x6577 if x6581==1 /* Annuities invested in stocks */
replace stoann = stoann + x6577*x6582/10000 if x6581==3 /* Annuities invested in stocks and other assets */
replace stoann = stoann + x6577 if x6581==5 /* Annuities invested in hedge funds */
replace stoann = stoann + x6577 if x6581==8 /* Annuities invested in mineral rights */
gen stotru = 0
replace stotru = stotru + x6587 if x6591==1 /* Trust-managed accounts invested in stocks */
replace stotru = stotru + x6587*x6592/10000 if x6591==3 /* Trust-managed invested in stocks and other assets */
replace stotru = stotru + x6587 if x6591==5 /* Trust-managed accounts invested in hedge funds */
replace stotru = stotru + x6587 if x6591==8 /* Trust-managed accounts invested in mineral rights */

gen stock = stosh + stomut + stobal + stooth + stoira + storet + stoann + stotru



* HUMAN WEALTH

do "do\hwealth"



* REAL ESTATE
* includes the value of the primary residence, the value of other real estate,
* and part of IRA-KEOGH and retirement accounts, annuities and trust-managed accounts

gen reshous = x716 /* Primary household value */
replace reshous = reshous + x513 + x526 + x604 + x614 + x623 /* Ranch, farm or mobile home */
gen resoth = x1706*x1705/10000 + x1806*x1805/10000 + x1906*x1905/10000 + x2002 + x2012 /* Other real estate */
gen resira = 0
replace resira = resira + irahead if x6555==4 /* IRA-KEOGH accounts invested in real estate */
replace resira = resira + irapart if x6563==4 /* IRA-KEOGH accounts invested in real estate */
replace resira = resira + iraother if x6571==4 /* IRA-KEOGH accounts invested in real estate */
gen resret = 0
replace resret = resret + x6462 if x6933==4 /* Retirement accounts invested in real estate */
replace resret = resret + x6467 if x6937==4 /* Retirement accounts invested in real estate */
replace resret = resret + x6472 if x6941==4 /* Retirement accounts invested in real estate */
replace resret = resret + x6477 if x6945==4 /* Retirement accounts invested in real estate */
replace resret = resret + x6482 if x6949==4 /* Retirement accounts invested in real estate */
replace resret = resret + x6487 if x6953==4 /* Retirement accounts invested in real estate */
replace resret = resret + x5604 if x6962==4 /* Previous retirement accounts invested in real estate */
replace resret = resret + x5612 if x6968==4 /* Previous retirement accounts invested in real estate */
replace resret = resret + x5620 if x6974==4 /* Previous retirement accounts invested in real estate */
replace resret = resret + x5628 if x6980==4 /* Previous retirement accounts invested in real estate */
replace resret = resret + x5636 if x6986==4 /* Previous retirement accounts invested in real estate */
replace resret = resret + x5644 if x6992==4 /* Previous retirement accounts invested in real estate */
gen resann = 0
replace resann = resann + x6577 if x6581==4 /* Annuities invested in real estate */
gen restru = 0
replace restru = restru + x6587 if x6591==4 /* Trust-managed accounts invested in real estate */
gen restate = reshous + resoth + resira + resret + resann + restru



********************************************************************
* CONSTRUCT THE WEIGHTS FROM THESE AGGREGATES

* gen finwth = tran + ccard + govbond + corbond + stock
* gen totwth = tran + ccard + govbond + govdebt + corbond + stock + restate
gen finwth = tran + govbond + corbond + stock
gen totwth = tran + govbond + govdebt + corbond + stock + restate + hc

* Financial weights
gen wftran = tran/finwth
gen wfbond = (govbond + corbond)/finwth
gen wfstok = stock/finwth

* Financial and real weights
gen wttran = tran/totwth
gen wtbond = (govbond + govdebt + corbond)/totwth
gen wtstok = stock/totwth
gen wtrest = restate/totwth
gen wthous = reshous/totwth
gen wthcap = hc/totwth



********************************************************************
* DEFINE PORTFOLIO LABELS

label variable tran "Transaction accounts"
label variable ccard "Credit card balance"
label variable govbond "Government bonds"
label variable govdebt "Debt"
label variable corbond "Corporate bonds"
label variable stock "Stocks"
label variable restate "Real estate assets"
label variable reshous "Primary residence"
label variable hc "Human capital"

label variable finwth "Household financial wealth"
label variable totwth "Household financial and real wealth"

label variable wftran "Deposits financial weight"
label variable wfbond "Bond financial weight"
label variable wfstok "Stock financial weight"

label variable wttran "Deposits financial and real weight"
label variable wtbond "Bond financial and real weight"
label variable wtstok "Stock financial and real weight"
label variable wtrest "Real estate financial and real weight"
label variable wthous "Primary residence financial and real weight"
label variable wthcap "Human capital financial and real weight"


********************************************************************
* Drop (and count) observations that do not respect the constraints

gen finflag1 = 0
replace finflag1 = 1 if wftran < 0
bysort id: egen efinflag1 = sum(finflag1)
* Negative deposits in financial portfolio
count if efinflag1 > 0 & imp == 3

gen finflag2 = 0
replace finflag2 = 1 if wfbond < 0
bysort id: egen efinflag2 = sum(finflag2)
* Negative bonds in financial portfolio
count if efinflag2 > 0 & imp == 3

gen finflag3 = 0
replace finflag3 = 1 if wfstok < 0
bysort id: egen efinflag3 = sum(finflag3)
* Negative stocks in financial portfolio
count if efinflag3 > 0 & imp == 3

gen finflag = 0
replace finflag = 1 if finwth <= 0
replace finflag = 1 if wftran < 0 | wfbond < 0 | wfstok < 0
bysort id: egen efinflag = sum(finflag)
* Negative financial wealth
count if efinflag > 0 & imp == 3

gen totflag1 = 0
replace totflag1 = 1 if wttran < 0
bysort id: egen etotflag1 = sum(totflag1)
* Negative deposits in broad wealth
count if etotflag1 > 0 & imp == 3

gen totflag2 = 0
replace totflag2 = 1 if wtbond < -wtrest
bysort id: egen etotflag2 = sum(totflag2)
* Too low bonds in broad wealth
count if etotflag2 > 0 & imp == 3

gen totflag3 = 0
replace totflag3 = 1 if wtstok < 0
bysort id: egen etotflag3 = sum(totflag3)
* Negative stocks in broad wealth
count if etotflag3 > 0 & imp == 3

gen totflag4 = 0
replace totflag4 = 1 if wtrest < 0
bysort id: egen etotflag4 = sum(totflag4)
* Negative real estate in broad wealth
count if etotflag4 > 0 & imp == 3

gen totflag5 = 0
replace totflag5 = 1 if wthcap <= 0
bysort id: egen etotflag5 = sum(totflag5)
* Negative human capital in broad wealth
count if etotflag5 > 0 & imp == 3

gen totflag = 0
replace totflag = 1 if totwth <= 0
replace totflag = 1 if wttran < 0 | wtbond < -wtrest | wtstok < 0 | wtrest < 0 | wthcap <= 0
bysort id: egen etotflag = sum(totflag)
* Negative broad wealth
count if etotflag > 0 & imp == 3

gen findum = (finwth == 0)
bysort id: egen efindum = sum(findum)
count if efindum > 0 & imp == 3

count if efinflag > 0 | etotflag > 0
drop if efinflag > 0 | etotflag > 0

keep id imp x42001 x5702 x5704 x5706 x5708 x5710 x5712 x5714 x5716 x5718 x5720 x5722 x5724 x5729 x101 x8021 ///
x8022 x8023 x5901 x6809 x6030 x4100 x4106 x7402 x7401 x4112 x4113 x5306 x5307 x103 x104 x105 x6101 x6810 ///
x6124 x4700 x4706 x7412 x7411 x4712 x4713 x5311 x5312 x301 x3014 x3008 x7112 x3504 x7111 x7100 x6497 x8300 ///
tran ccard govbond govdebt corbond stock restate reshous hc x7132 x5801 x5802 x5819 x5821 x5824 x5825 ///
finwth wftran wfbond wfstok totwth wttran wtbond wtstok wtrest wthous wthcap ///
tran* gov* cor* sto* res*

* This dataset includes all the single asset categories
save SCF04all, replace

* Dummy =1 if risk free portfolio
gen finflag = 0
replace finflag = 1 if wfbond == 0 & wfstok == 0
bysort id: egen flagfin = sum(finflag)

gen totflag = 0
replace totflag = 1 if wtbond == 0 & wtstok == 0 & wtrest == 0 & wthcap <= 0
bysort id: egen flagtot = sum(totflag)

macro def allvars id imp x42001 x5702 x5704 x5706 x5708 x5710 x5712 x5714 x5716 x5718 x5720 x5722 x5724 x5729 x101 x8021 ///
x8022 x8023 x5901 x6809 x6030 x4100 x4106 x7402 x7401 x4112 x4113 x5306 x5307 x103 x104 x105 x6101 x6810 ///
x6124 x4700 x4706 x7412 x7411 x4712 x4713 x5311 x5312 x301 x3014 x3008 x7112 x3504 x7111 x7100 x6497 x8300 x7132 ///
x5801 x5802 x5819 x5821 x5824 x5825 ///
finwth flagfin wftran wfbond wfstok totwth flagtot wttran wtbond wtstok wtrest wthous wthcap

keep $allvars

* This dataset includes all demographic characteristics and portfolio information
save SCF04, replace
