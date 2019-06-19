* datakeep.do FILE

* This do-file defines (and corrects) the variables to keep in the analysis

* Alessandro Bucciol (alessandro.bucciol@univr.it)
* University of Verona
* March 2010

********************************************************************



* Variables to keep

rename yy1 id
gen imp = y1-id*10

keep id imp x42001 x101 x8021 x103 x8022 x104 x8023 x105 x5901 x6101 x6809 x6810 x6030 x6124 x501 x508 ///
x513 x523 x526 x601 x604 x614 x623 x716 x6723 x805 x905 x1005 x1044 x1106 x1117 x1128 x1108 x1119 x1130 ///
x1136 x1703 x1803 x1903 x1704 x1804 x1904 x1705 x1805 x1905 x1706 x1806 x1906 x2002 x2012 x1715 x1815 ///
x1915 x2006 x2016 x3506 x3510 x3514 x3518 x3522 x3526 x3529 x6551 x6559 x6567 x6552 x6560 x6568 x6553 ///
x6561 x6569 x6554 x6562 x6570 x6756 x6757 x6758 x6555 x6563 x6571 x6556 x6564 x6572 x3721 x3730 x3736 ///
x3742 x3748 x3754 x3760 x3765 x3822 x3824 x3826 x3828 x3830 x7787 x6704 x3902 x3906 x7635 x3908 x7636 ///
x3910 x7637 x7633 x7638 x7634 x7639 x6705 x6706 x3915 x3930 x6577 x6581 x6582 x6587 x6591 x6592 x4003 ///
x4005 x4006 x4010 x4100 x4700 x4106 x4706 x7402 x7412 x7401 x7411 x4112 x4712 x4113 x4713 x5306 x5311 ///
x5307 x5312 x6462 x6467 x6472 x6477 x6482 x6487 x6933 x6937 x6941 x6945 x6949 x6953 x6934 x6938 x6942 ///
x6946 x6950 x6954 x5604 x5612 x5620 x5628 x5636 x5644 x6962 x6968 x6974 x6980 x6986 x6992 x6963 x6969 ///
x6975 x6981 x6987 x6993 x5702 x5704 x5706 x5708 x5710 x5712 x5714 x5716 x5718 x5720 x5722 x5724 x5729 ///
x301 x7112 x1409 x1509 x1609 x1619 x1417 x1517 x1617 x1621 x413 x421 x424 x427 x430 x918 x1018 x7132 ///
x3014 x3008 x3504 x7111 x7100 x6497 x8300 x5801 x5802 x5819 x5821 x5824 x5825


* Compute the number of cases in which a missing value is found
* macro def allvars x6551 x6552 x6553 x6554 x6559 x6560 x6561 x6562 x6567 x6568 x6569 x6570 ///
* x6462 x6467 x6472 x6477 x6482 x6487 x5604 x5612 x5620 x5628 x5636 x5644 ///
* x6577 x6587 x3506 x3510 x3514 x3518 x3522 x3526 x3529 x3730 x3736 x3742 ///
* x3748 x3754 x3760 x3765 x3930 x3721 x3902 x3824 x3826 x4006 x4010 x6556 ///
* x6564 x6572 x6555 x805 x905 x1005 x1044 x1108 x1119 x1130 x1715 ///
* x1815 x1915 x2006 x2016 x1417 x1517 x1617 x1621 x1409 x1509 x1609 x1619 ///
* x3915 x3822 x3830 x7787 x5702 x5704 x5716 x5718 x5720 x5722 x5724 ///
* x716 x513 x526 x604 x614 x623 x1706 x1806 x1906 x2002 x2012

* ge pippo=0
* qui foreach var of varlist $allvars {
*	replace pippo=pippo+1 if `var'==-1
* }



********************************************************************
* Clean the variables

* Use of computer
replace x6497 = 0 if x6497 == 5

* Bequest
replace x5801 = 0 if x5801 == 5
replace x5819 = 0 if x5819 == 5

* Number of institutions
replace x8300 = 0 if x8300 < 0

* Income variables
replace x4113 = 0 if x4113 < 0
replace x5307 = 0 if x5307 < 0
replace x4713 = 0 if x4713 < 0
replace x5312 = 0 if x5312 < 0

replace x5702 = 0 if x5702 < 0
replace x5704 = 0 if x5704 < 0
replace x5706 = 0 if x5706 < 0
replace x5708 = 0 if x5708 < 0
replace x5710 = 0 if x5710 < 0
replace x5712 = 0 if x5712 < 0
replace x5714 = 0 if x5714 < 0
replace x5716 = 0 if x5716 < 0
replace x5718 = 0 if x5718 < 0
replace x5720 = 0 if x5720 < 0
replace x5722 = 0 if x5722 < 0
replace x5724 = 0 if x5724 < 0

* Credit card interest rate
replace x7132 = 0 if x7132 < 0
replace x7132 = x7132/10000

* Checking accounts
replace x3506 = 0 if x3506 < 0
replace x3510 = 0 if x3510 < 0
replace x3514 = 0 if x3514 < 0
replace x3518 = 0 if x3518 < 0
replace x3522 = 0 if x3522 < 0
replace x3526 = 0 if x3526 < 0
replace x3529 = 0 if x3529 < 0

* Savings-money market accounts
replace x3730 = 0 if x3730 < 0
replace x3736 = 0 if x3736 < 0
replace x3742 = 0 if x3742 < 0
replace x3748 = 0 if x3748 < 0
replace x3754 = 0 if x3754 < 0
replace x3760 = 0 if x3760 < 0
replace x3765 = 0 if x3765 < 0

* Credit card balance
replace x413 = 0 if x413 < 0
replace x421 = 0 if x421 < 0
replace x424 = 0 if x424 < 0
replace x427 = 0 if x427 < 0
replace x430 = 0 if x430 < 0

* Certificates of deposit
replace x3721 = 0 if x3721 < 0

* Savings bonds (gov't bonds)
replace x3902 = 0 if x3902 < 0

* Corporate bonds
replace x3906 = 0 if x3906 < 0
replace x3908 = 0 if x3908 < 0
replace x3910 = 0 if x3910 < 0
replace x7633 = 0 if x7633 < 0
replace x7634 = 0 if x7634 < 0
replace x7635 = 0 if x7635 < 0
replace x7636 = 0 if x7636 < 0
replace x7637 = 0 if x7637 < 0
replace x7638 = 0 if x7638 < 0
replace x7639 = 0 if x7639 < 0

* Annuities
replace x6577 = 0 if x6577 < 0
replace x6587 = 0 if x6587 < 0

* Life insurance
replace x4003 = 0 if x4003 < 0
replace x4005 = 0 if x4005 < 0
replace x4006 = 0 if x4006 < 0
replace x4010 = 0 if x4010 < 0

* Mortgage on the house where the household lives
replace x805 = 0 if x805 < 0
replace x905 = 0 if x905 < 0
replace x1005 = 0 if x1005 < 0
replace x1044 = 0 if x1044 < 0

* Lines of credit on the house where the household lives
replace x1108 = 0 if x1108 < 0
replace x1119 = 0 if x1119 < 0
replace x1130 = 0 if x1130 < 0
replace x1136 = 0 if x1136 < 0

* Mortgages on other real estate
replace x1715 = 0 if x1715 < 0
replace x1815 = 0 if x1815 < 0
replace x1915 = 0 if x1915 < 0
replace x2006 = 0 if x2006 < 0
replace x2016 = 0 if x2016 < 0
replace x1409 = 0 if x1409 < 0
replace x1509 = 0 if x1509 < 0
replace x1609 = 0 if x1609 < 0
replace x1619 = 0 if x1619 < 0
replace x1417 = 0 if x1417 < 0
replace x1517 = 0 if x1517 < 0
replace x1617 = 0 if x1617 < 0
replace x1621 = 0 if x1621 < 0

* Brokerage accounts
replace x3930 = 0 if x3930 < 0

* Aggregate IRA-KEOGH accounts
replace x6551 = 0 if x6551 < 0
replace x6552 = 0 if x6552 < 0
replace x6553 = 0 if x6553 < 0
replace x6554 = 0 if x6554 < 0
replace x6559 = 0 if x6559 < 0
replace x6560 = 0 if x6560 < 0
replace x6561 = 0 if x6561 < 0
replace x6562 = 0 if x6562 < 0
replace x6567 = 0 if x6567 < 0
replace x6568 = 0 if x6568 < 0
replace x6569 = 0 if x6569 < 0
replace x6570 = 0 if x6570 < 0

* Stocks
replace x3915 = 0 if x3915 < 0

* House where the household lives
replace x716 = 0 if x716 < 0
replace x513 = 0 if x513 < 0
replace x526 = 0 if x526 < 0
replace x604 = 0 if x604 < 0
replace x614 = 0 if x614 < 0
replace x623 = 0 if x623 < 0

* Other real estate
replace x1706 = 0 if x1706 < 0
replace x1806 = 0 if x1806 < 0
replace x1906 = 0 if x1906 < 0
replace x2002 = 0 if x2002 < 0
replace x2012 = 0 if x2012 < 0
