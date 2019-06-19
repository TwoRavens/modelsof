* datalabel.do FILE

* This do-file adds labels

* Alessandro Bucciol (alessandro.bucciol@univr.it)
* University of Verona
* March 2010

********************************************************************



* DEMOGRAPHICS


* Keys
label variable id "observation id"
label variable imp "internal id (each of the 5 imputations per household)"
label variable x42001 "weight"

* Household
label variable x101 "people in the household"

* Head
label variable x8021 "sex head"
label variable x8022 "age head"
label variable x8023 "marital status head"
label variable x5901 "education head"
label variable x6809 "race head"
label variable x6030 "self-assessed health head"

* Partner
label variable x103 "sex partner"
label variable x104 "age partner"
label variable x105 "marital status partner"
label variable x6101 "education partner"
label variable x6810 "race partner"
label variable x6124 "self-assessed health partner"

* Household
label variable x3008 "Time horizon"
label variable x3014 "Self-assessed risk aversion"
label variable x301 "Expectations for the future"

* Financial sophistication
label variable x7112 "Decisions about saving and investments"
label variable x8300 "N. financial institutions"
label variable x6497 "Use of computer"
label variable x7100 "Level of shopping for credit"
label variable x7111 "Level of shopping for investment"
label variable x3504 "N. checking accounts"


********************************************************************
* BEQUEST



label variable x5801 "=1 if ever received bequest"
label variable x5802 "Number of rReceived bequest"
label variable x5819 "=1 if expect to leave bequest"
label variable x5821 "Expected bequest to leave"
label variable x5824 "Important to leave assets"
label variable x5825 "Expect to leave estate"


********************************************************************
* INCOME



* Head
label variable x4100 "work status of the head"
label variable x4106 "employed or self-employed status of the head"
label variable x7402 "kind of business-industry of the head"
label variable x7401 "primary job position of the head"
label variable x4112 "income before taxes of the head"
label variable x4113 "income frequency of the head"
label variable x5306 "pension of the head"
label variable x5307 "pension frequency of the head"

* Partner
label variable x4700 "work status of the partner"
label variable x4706 "employed or self-employed status of the partner"
label variable x7412 "kind of business-industry of the partner"
label variable x7411 "primary job position of the partner"
label variable x4712 "income before taxes of the partner"
label variable x4713 "income frequency of the partner"
label variable x5311 "pension of the partner"
label variable x5312 "pension frequency of the partner"

* Household
label variable x5702 "family income before taxes, from wages and salaries"
label variable x5704 "family income before taxes, from businesses"
label variable x5706 "family income before taxes, from non-taxable investments"
label variable x5708 "family income before taxes, from other interests"
label variable x5710 "family income before taxes, from dividends"
label variable x5712 "family income before taxes, from funds-stock trading"
label variable x5714 "family income before taxes, from net rents, trusts, etc."
label variable x5716 "family income before taxes, from unemployment"
label variable x5718 "family income before taxes, from child support"
label variable x5720 "family income before taxes, from food stamps"
label variable x5722 "family income before taxes, from Social Security"
label variable x5724 "family income before taxes, from other sources"
label variable x5729 "total family income before taxes"



********************************************************************
* PORTFOLIO ASSETS (BY AGGREGATE)


* RISK FREE ASSETS

* Checking accounts
label variable x3506 "value checking account n.1"
label variable x3510 "value checking account n.2"
label variable x3514 "value checking account n.3"
label variable x3518 "value checking account n.4"
label variable x3522 "value checking account n.5"
label variable x3526 "value checking account n.6"
label variable x3529 "value checking account n.7"

* Savings-money market accounts
label variable x3730 "value savings-money market account n.1"
label variable x3736 "value savings-money market account n.2"
label variable x3742 "value savings-money market account n.3"
label variable x3748 "value savings-money market account n.4"
label variable x3754 "value savings-money market account n.5"
label variable x3760 "value savings-money market account n.6"
label variable x3765 "value savings-money market account n.7"

label variable x7132 "Credit card interest rate"


* DEBT

* Mortgages and lines of credit referred to the house where they live
label variable x6723 "purpose of mortgage n.1"
label variable x805 "value still owed of mortgage n.1"
label variable x905 "value still owed of mortgage n.2"
label variable x1005 "value still owed of mortgage n.3"
label variable x1044 "value still owed of other loans (from relatives or the seller)"
label variable x1106 "purpose of line of credit n.1"
label variable x1117 "purpose of line of credit n.2"
label variable x1128 "purpose of line of credit n.3"
label variable x1108 "value currently owed of line of credit n.1"
label variable x1119 "value currently owed of line of credit n.2"
label variable x1130 "value currently owed of line of credit n.3"
label variable x1136 "value currently owed of other lines of credit"

* Mortgages and loans referred to real estate
label variable x1715 "loan-mortgage n.1 still owed (investment)"
label variable x1815 "loan-mortgage n.2 still owed (investment)"
label variable x1915 "loan-mortgage n.3 still owed (investment)"
label variable x2006 "loan-mortgage n.4 still owed (investment)"
label variable x2016 "loan-mortgage n.5 still owed (investment)"
label variable x1409 "loan-mortgage n.1 to be owed (land contracts)"
label variable x1509 "loan-mortgage n.2 to be owed (land contracts)"
label variable x1609 "loan-mortgage n.3 to be owed (land contracts)"
label variable x1619 "loan-mortgage n.4 to be owed (land contracts)"
label variable x1417 "loan-mortgage n.1 to owe (land contracts)"
label variable x1517 "loan-mortgage n.2 to owe (land contracts)"
label variable x1617 "loan-mortgage n.3 to owe (land contracts)"
label variable x1621 "loan-mortgage n.4 to owe (land contracts)"


* GOVERNMENT BONDS

* Certificates of deposit
label variable x3721 "value of certificates of deposit"

* US gov't savings bonds
label variable x3902 "face value US gov't bonds"

* life insurance
label variable x4003 "face value of life insurances"
label variable x4005 "face value of life insurances that build up a cash value" /* to be paid in the event of death */
label variable x4006 "cash value of life insurances if cancelled now" /* USE THIS IN CASE */
label variable x4010 "value borrowed against life insurance policies"


* CORPORATE BONDS

* Other bonds (no savings bonds)
label variable x3906 "face value mortgage-backed bonds"
label variable x7635 "market value mortgage-backed bonds"
label variable x3908 "face value US gov't bonds or T-bills"
label variable x7636 "market value US gov't bonds or T-bills"
label variable x3910 "face value other tax-free bonds"
label variable x7637 "market value other tax-free bonds"
label variable x7633 "face value foreign bonds"
label variable x7638 "market value foreign bonds"
label variable x7634 "face value corporate bonds"
label variable x7639 "market value corporate bonds"
label variable x6705 "self-reported total face value other bonds"
label variable x6706 "self-reported total market value other bonds"

* annuities, trusts, managed investment accounts
label variable x6577 "annuity value if cashed now"
label variable x6581 "investment composition annuity"
label variable x6582 "% in stocks annuity"
label variable x6587 "trust-managed account if cashed now"
label variable x6591 "investment composition trust-managed account"
label variable x6592 "% in stocks trust-managed accounts"


* MUTUAL FUNDS

label variable x3822 "value stock mutual funds"
label variable x3824 "value tax-free bond mutual funds"
label variable x3826 "value gov't bond mutual funds"
label variable x3828 "value other bond mutual funds"
label variable x3830 "value balanced funds"
label variable x7787 "value other funds"
label variable x6704 "self-reported total value all mutual funds"


* RETIREMENT AND PENSION ACCOUNTS

* brokerage accounts (cash-call money accounts)
label variable x3930 "value of brokerage accounts"

* IRA - keogh accounts (retirement assets)
label variable x6551 "value roth IRA account of head"
label variable x6559 "value roth IRA account of partner"
label variable x6567 "value roth IRA account of other members"
label variable x6552 "value roll-over IRA account of head"
label variable x6560 "value roll-over IRA account of partner"
label variable x6568 "value roll-over IRA account of other members"
label variable x6553 "value regular-other IRA account of head"
label variable x6561 "value regular-other IRA account of partner"
label variable x6569 "value regular-other IRA account of other members"
label variable x6554 "value keogh account of head"
label variable x6562 "value keogh account of partner"
label variable x6570 "value keogh account of other members"
label variable x6756 "self-reported total value accounts of head"
label variable x6757 "self-reported total value accounts of partner"
label variable x6758 "self-reported total value accounts of other members"
label variable x6555 "investment composition IRA-keogh account of head"
label variable x6563 "investment composition IRA-keogh account of partner"
label variable x6571 "investment composition IRA-keogh account of other members"
label variable x6556 "% in stocks IRA-keogh account of head"
label variable x6564 "% in stocks IRA-keogh account of partner"
label variable x6572 "% in stocks IRA-keogh account of other members"

* retirement accounts
* the whole balance may be taken as one payment
label variable x6462 "balance retirement account n.1"
label variable x6467 "balance retirement account n.2"
label variable x6472 "balance retirement account n.3"
label variable x6477 "balance retirement account n.4"
label variable x6482 "balance retirement account n.5"
label variable x6487 "balance retirement account n.6"
label variable x6933 "investment composition retirement account n.1"
label variable x6937 "investment composition retirement account n.2"
label variable x6941 "investment composition retirement account n.3"
label variable x6945 "investment composition retirement account n.4"
label variable x6949 "investment composition retirement account n.5"
label variable x6953 "investment composition retirement account n.6"
label variable x6934 "% in stocks retirement account n.1"
label variable x6938 "% in stocks retirement account n.2"
label variable x6942 "% in stocks retirement account n.3"
label variable x6946 "% in stocks retirement account n.4"
label variable x6950 "% in stocks retirement account n.5"
label variable x6954 "% in stocks retirement account n.6"

* pension accounts from previous employer
label variable x5604 "value previous pension account n.1"
label variable x5612 "value previous pension account n.2"
label variable x5620 "value previous pension account n.3"
label variable x5628 "value previous pension account n.4"
label variable x5636 "value previous pension account n.5"
label variable x5644 "value previous pension account n.6"
label variable x6962 "investment composition previous pension account n.1"
label variable x6968 "investment composition previous pension account n.2"
label variable x6974 "investment composition previous pension account n.3"
label variable x6980 "investment composition previous pension account n.4"
label variable x6986 "investment composition previous pension account n.5"
label variable x6992 "investment composition previous pension account n.6"
label variable x6963 "% in stocks previous pension account n.1"
label variable x6969 "% in stocks previous pension account n.2"
label variable x6975 "% in stocks previous pension account n.3"
label variable x6981 "% in stocks previous pension account n.4"
label variable x6987 "% in stocks previous pension account n.5"
label variable x6993 "% in stocks previous pension account n.6"


* STOCKS

label variable x3915 "market value publicly traded stocks"


* HOUSING (where the household lives)

label variable x501 "where do you live"
label variable x508 "ownership of farm-ranch"
label variable x513 "value of farm-ranch if all owned"
label variable x523 "% of farm-ranch owned"
label variable x526 "value of portion of farm-ranch owned"
label variable x601 "ownership of mobile home"
label variable x604 "current value of the site if owned"
label variable x614 "current value of mobile home if owned"
label variable x623 "current value of mobile home and site if both owned"
label variable x716 "current value of entire home if owned at least partly"


* REAL ESTATE (further real estate)

label variable x1703 "property type of real estate n.1"
label variable x1803 "property type of real estate n.2"
label variable x1903 "property type of real estate n.3"
label variable x1704 "property ownership of real estate n.1"
label variable x1804 "property ownership of real estate n.2"
label variable x1904 "property ownership of real estate n.3"
label variable x1705 "% owned of real estate n.1"
label variable x1805 "% owned of real estate n.2"
label variable x1905 "% owned of real estate n.3"
label variable x1706 "total value of real estate n.1 (also what is now owned)"
label variable x1806 "total value of real estate n.2 (also what is now owned)"
label variable x1906 "total value of real estate n.3 (also what is now owned)"
label variable x2002 "total value of vacation or recreational properties"
label variable x2012 "total value of remaining properties"
* Labels: demographics


* KEYS
label variable id "observation id"
label variable imp "internal id (each of the 5 imputations per household)"
label variable x42001 "weight"


* DEMOGRAPHIC AND ECONOMIC VARIABLES
label variable x101 "people in the household"

* Head
label variable x8021 "sex head"
label variable x8022 "age head"
label variable x8023 "marital status head"
label variable x5901 "education head"
label variable x6809 "race head"
label variable x6030 "self-assessed health head"
* Job position
label variable x4100 "work status of the head"
label variable x4106 "employed or self-employed status of the head"
label variable x7402 "kind of business-industry of the head"
label variable x7401 "primary job position of the head"
label variable x4112 "income before taxes of the head"
label variable x4113 "income frequency of the head"
label variable x5306 "pension of the head"
label variable x5307 "pension frequency of the head"

* Partner
label variable x103 "sex partner"
label variable x104 "age partner"
label variable x105 "marital status partner"
label variable x6101 "education partner"
label variable x6810 "race partner"
label variable x6124 "self-assessed health partner"
* Job position
label variable x4700 "work status of the partner"
label variable x4706 "employed or self-employed status of the partner"
label variable x7412 "kind of business-industry of the partner"
label variable x7411 "primary job position of the partner"
label variable x4712 "income before taxes of the partner"
label variable x4713 "income frequency of the partner"
label variable x5311 "pension of the partner"
label variable x5312 "pension frequency of the partner"

* Household
label variable x3014 "Self-assessed risk aversion"
label variable x301 "Expectations for the future"
label variable x7112 "Decisions about saving and investments"
label variable x5702 "family income before taxes, from wages and salaries"
label variable x5704 "family income before taxes, from businesses"
label variable x5706 "family income before taxes, from non-taxable investments"
label variable x5708 "family income before taxes, from other interests"
label variable x5710 "family income before taxes, from dividends"
label variable x5712 "family income before taxes, from funds-stock trading"
label variable x5714 "family income before taxes, from net rents, trusts, etc."
label variable x5716 "family income before taxes, from unemployment"
label variable x5718 "family income before taxes, from child support"
label variable x5720 "family income before taxes, from food stamps"
label variable x5722 "family income before taxes, from Social Security"
label variable x5724 "family income before taxes, from other sources"
label variable x5729 "total family income before taxes"



********************************************************************
* Portfolio assets (by aggregate)


* RISK FREE ASSETS

* Checking accounts
label variable x3506 "value checking account n.1"
label variable x3510 "value checking account n.2"
label variable x3514 "value checking account n.3"
label variable x3518 "value checking account n.4"
label variable x3522 "value checking account n.5"
label variable x3526 "value checking account n.6"
label variable x3529 "value checking account n.7"

* Savings-money market accounts
label variable x3730 "value savings-money market account n.1"
label variable x3736 "value savings-money market account n.2"
label variable x3742 "value savings-money market account n.3"
label variable x3748 "value savings-money market account n.4"
label variable x3754 "value savings-money market account n.5"
label variable x3760 "value savings-money market account n.6"
label variable x3765 "value savings-money market account n.7"

label variable x7132 "Credit card interest rate"


* DEBT

* Mortgages and lines of credit referred to the house where they live
label variable x6723 "purpose of mortgage n.1"
label variable x805 "value still owed of mortgage n.1"
label variable x905 "value still owed of mortgage n.2"
label variable x1005 "value still owed of mortgage n.3"
label variable x1044 "value still owed of other loans (from relatives or the seller)"
label variable x1106 "purpose of line of credit n.1"
label variable x1117 "purpose of line of credit n.2"
label variable x1128 "purpose of line of credit n.3"
label variable x1108 "value currently owed of line of credit n.1"
label variable x1119 "value currently owed of line of credit n.2"
label variable x1130 "value currently owed of line of credit n.3"
label variable x1136 "value currently owed of other lines of credit"

* Mortgages and loans referred to real estate
label variable x1715 "loan-mortgage n.1 still owed (investment)"
label variable x1815 "loan-mortgage n.2 still owed (investment)"
label variable x1915 "loan-mortgage n.3 still owed (investment)"
label variable x2006 "loan-mortgage n.4 still owed (investment)"
label variable x2016 "loan-mortgage n.5 still owed (investment)"
label variable x1409 "loan-mortgage n.1 to be owed (land contracts)"
label variable x1509 "loan-mortgage n.2 to be owed (land contracts)"
label variable x1609 "loan-mortgage n.3 to be owed (land contracts)"
label variable x1619 "loan-mortgage n.4 to be owed (land contracts)"
label variable x1417 "loan-mortgage n.1 to owe (land contracts)"
label variable x1517 "loan-mortgage n.2 to owe (land contracts)"
label variable x1617 "loan-mortgage n.3 to owe (land contracts)"
label variable x1621 "loan-mortgage n.4 to owe (land contracts)"


* GOVERNMENT BONDS

* Certificates of deposit
label variable x3721 "value of certificates of deposit"

* US gov't savings bonds
label variable x3902 "face value US gov't bonds"

* life insurance
label variable x4003 "face value of life insurances"
label variable x4005 "face value of life insurances that build up a cash value" /* to be paid in the event of death */
label variable x4006 "cash value of life insurances if cancelled now" /* USE THIS IN CASE */
label variable x4010 "value borrowed against life insurance policies"


* CORPORATE BONDS

* Other bonds (no savings bonds)
label variable x3906 "face value mortgage-backed bonds"
label variable x7635 "market value mortgage-backed bonds"
label variable x3908 "face value US gov't bonds or T-bills"
label variable x7636 "market value US gov't bonds or T-bills"
label variable x3910 "face value other tax-free bonds"
label variable x7637 "market value other tax-free bonds"
label variable x7633 "face value foreign bonds"
label variable x7638 "market value foreign bonds"
label variable x7634 "face value corporate bonds"
label variable x7639 "market value corporate bonds"
label variable x6705 "self-reported total face value other bonds"
label variable x6706 "self-reported total market value other bonds"

* annuities, trusts, managed investment accounts
label variable x6577 "annuity value if cashed now"
label variable x6581 "investment composition annuity"
label variable x6582 "% in stocks annuity"
label variable x6587 "trust-managed account if cashed now"
label variable x6591 "investment composition trust-managed account"
label variable x6592 "% in stocks trust-managed accounts"


* MUTUAL FUNDS

label variable x3822 "value stock mutual funds"
label variable x3824 "value tax-free bond mutual funds"
label variable x3826 "value gov't bond mutual funds"
label variable x3828 "value other bond mutual funds"
label variable x3830 "value balanced funds"
label variable x7787 "value other funds"
label variable x6704 "self-reported total value all mutual funds"


* RETIREMENT AND PENSION ACCOUNTS

* brokerage accounts (cash-call money accounts)
label variable x3930 "value of brokerage accounts"

* IRA - keogh accounts (retirement assets)
label variable x6551 "value roth IRA account of head"
label variable x6559 "value roth IRA account of partner"
label variable x6567 "value roth IRA account of other members"
label variable x6552 "value roll-over IRA account of head"
label variable x6560 "value roll-over IRA account of partner"
label variable x6568 "value roll-over IRA account of other members"
label variable x6553 "value regular-other IRA account of head"
label variable x6561 "value regular-other IRA account of partner"
label variable x6569 "value regular-other IRA account of other members"
label variable x6554 "value keogh account of head"
label variable x6562 "value keogh account of partner"
label variable x6570 "value keogh account of other members"
label variable x6756 "self-reported total value accounts of head"
label variable x6757 "self-reported total value accounts of partner"
label variable x6758 "self-reported total value accounts of other members"
label variable x6555 "investment composition IRA-keogh account of head"
label variable x6563 "investment composition IRA-keogh account of partner"
label variable x6571 "investment composition IRA-keogh account of other members"
label variable x6556 "% in stocks IRA-keogh account of head"
label variable x6564 "% in stocks IRA-keogh account of partner"
label variable x6572 "% in stocks IRA-keogh account of other members"

* retirement accounts
* the whole balance may be taken as one payment
label variable x6462 "balance retirement account n.1"
label variable x6467 "balance retirement account n.2"
label variable x6472 "balance retirement account n.3"
label variable x6477 "balance retirement account n.4"
label variable x6482 "balance retirement account n.5"
label variable x6487 "balance retirement account n.6"
label variable x6933 "investment composition retirement account n.1"
label variable x6937 "investment composition retirement account n.2"
label variable x6941 "investment composition retirement account n.3"
label variable x6945 "investment composition retirement account n.4"
label variable x6949 "investment composition retirement account n.5"
label variable x6953 "investment composition retirement account n.6"
label variable x6934 "% in stocks retirement account n.1"
label variable x6938 "% in stocks retirement account n.2"
label variable x6942 "% in stocks retirement account n.3"
label variable x6946 "% in stocks retirement account n.4"
label variable x6950 "% in stocks retirement account n.5"
label variable x6954 "% in stocks retirement account n.6"

* pension accounts from previous employer
label variable x5604 "value previous pension account n.1"
label variable x5612 "value previous pension account n.2"
label variable x5620 "value previous pension account n.3"
label variable x5628 "value previous pension account n.4"
label variable x5636 "value previous pension account n.5"
label variable x5644 "value previous pension account n.6"
label variable x6962 "investment composition previous pension account n.1"
label variable x6968 "investment composition previous pension account n.2"
label variable x6974 "investment composition previous pension account n.3"
label variable x6980 "investment composition previous pension account n.4"
label variable x6986 "investment composition previous pension account n.5"
label variable x6992 "investment composition previous pension account n.6"
label variable x6963 "% in stocks previous pension account n.1"
label variable x6969 "% in stocks previous pension account n.2"
label variable x6975 "% in stocks previous pension account n.3"
label variable x6981 "% in stocks previous pension account n.4"
label variable x6987 "% in stocks previous pension account n.5"
label variable x6993 "% in stocks previous pension account n.6"


* STOCKS

label variable x3915 "market value publicly traded stocks"


* HOUSING (where the household lives)

label variable x501 "where do you live"
label variable x508 "ownership of farm-ranch"
label variable x513 "value of farm-ranch if all owned"
label variable x523 "% of farm-ranch owned"
label variable x526 "value of portion of farm-ranch owned"
label variable x601 "ownership of mobile home"
label variable x604 "current value of the site if owned"
label variable x614 "current value of mobile home if owned"
label variable x623 "current value of mobile home and site if both owned"
label variable x716 "current value of entire home if owned at least partly"


* REAL ESTATE (further real estate)

label variable x1703 "property type of real estate n.1"
label variable x1803 "property type of real estate n.2"
label variable x1903 "property type of real estate n.3"
label variable x1704 "property ownership of real estate n.1"
label variable x1804 "property ownership of real estate n.2"
label variable x1904 "property ownership of real estate n.3"
label variable x1705 "% owned of real estate n.1"
label variable x1805 "% owned of real estate n.2"
label variable x1905 "% owned of real estate n.3"
label variable x1706 "total value of real estate n.1 (also what is now owned)"
label variable x1806 "total value of real estate n.2 (also what is now owned)"
label variable x1906 "total value of real estate n.3 (also what is now owned)"
label variable x2002 "total value of vacation or recreational properties"
label variable x2012 "total value of remaining properties"
