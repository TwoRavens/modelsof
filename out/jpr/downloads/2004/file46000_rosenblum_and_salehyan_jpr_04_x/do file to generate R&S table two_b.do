*recursive residuals for R&S table two; final command generates data reported in table two

use jpr1

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year if year <1986 , c(a)
predict yhat86
predict stdreg86, stdp
gen vt86 = asmprn-yhat86 if year==1986

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year if year <1987, c(a)
predict yhat87
predict stdreg87, stdp
gen vt87 = asmprn-yhat87 if year==1987

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year if year <1988, c(a)
predict yhat88
predict stdreg88, stdp
gen vt88 = asmprn-yhat88 if year==1988

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year if year <1989, c(a)
predict yhat89
predict stdreg89, stdp
gen vt89 = asmprn-yhat89 if year==1989

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year if year <1990, c(a)
predict yhat90
predict stdreg90, stdp
gen vt90 = asmprn-yhat87 if year==1990

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year  if year <1991, c(a)
predict yhat91
predict stdreg91, stdp
gen vt91 = asmprn-yhat91 if year==1991

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year if year <1992, c(a)
predict yhat92
predict stdreg92, stdp
gen vt92 = asmprn-yhat92 if year==1992

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year if year < 1993, c(a)
predict yhat93
predict stdreg93, stdp
gen vt93 = asmprn-yhat93 if year==1993

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year  if year <1994, c(a)
predict yhat94
predict stdreg94, stdp
gen vt94 = asmprn-yhat94 if year==1994

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year if year <1995, c(a)
predict yhat95
predict stdreg95, stdp
gen vt95 = asmprn-yhat95 if year==1995

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year if year <1996, c(a)
predict yhat96
predict stdreg96, stdp
gen vt96 = asmprn-yhat96 if year==1996

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year if year <1997, c(a)
predict yhat97
predict stdreg97, stdp
gen vt97 = asmprn-yhat97 if year==1997

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year if year <1998, c(a)
predict yhat98
predict stdreg98, stdp
gen vt98 = asmprn-yhat98 if year==1998

drop yhat*
save jpr1, replace

**************
use jpr2
drop vt*

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year if year <1986 , c(a)
predict yhat86
predict stdreg86, stdp
gen vt86 = asmprn-yhat86 if year==1986

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year if year <1987, c(a)
predict yhat87
predict stdreg87, stdp
gen vt87 = asmprn-yhat87 if year==1987

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year if year <1988, c(a)
predict yhat88
predict stdreg88, stdp
gen vt88 = asmprn-yhat88 if year==1988

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year if year <1989, c(a)
predict yhat89
predict stdreg89, stdp
gen vt89 = asmprn-yhat89 if year==1989

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year if year <1990, c(a)
predict yhat90
predict stdreg90, stdp
gen vt90 = asmprn-yhat87 if year==1990

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year  if year <1991, c(a)
predict yhat91
predict stdreg91, stdp
gen vt91 = asmprn-yhat91 if year==1991

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year if year <1992, c(a)
predict yhat92
predict stdreg92, stdp
gen vt92 = asmprn-yhat92 if year==1992

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year if year < 1993, c(a)
predict yhat93
predict stdreg93, stdp
gen vt93 = asmprn-yhat93 if year==1993

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year  if year <1994, c(a)
predict yhat94
predict stdreg94, stdp
gen vt94 = asmprn-yhat94 if year==1994

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year if year <1995, c(a)
predict yhat95
predict stdreg95, stdp
gen vt95 = asmprn-yhat95 if year==1995

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year if year <1996, c(a)
predict yhat96
predict stdreg96, stdp
gen vt96 = asmprn-yhat96 if year==1996

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year if year <1997, c(a)
predict yhat97
predict stdreg97, stdp
gen vt97 = asmprn-yhat97 if year==1997

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year if year <1998, c(a)
predict yhat98
predict stdreg98, stdp
gen vt98 = asmprn-yhat98 if year==1998

drop yhat*
save jpr2, replace

**************
use jpr3

drop vt*

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year if year <1986 , c(a)
predict yhat86
predict stdreg86, stdp
gen vt86 = asmprn-yhat86 if year==1986

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year if year <1987, c(a)
predict yhat87
predict stdreg87, stdp
gen vt87 = asmprn-yhat87 if year==1987

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year if year <1988, c(a)
predict yhat88
predict stdreg88, stdp
gen vt88 = asmprn-yhat88 if year==1988

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year if year <1989, c(a)
predict yhat89
predict stdreg89, stdp
gen vt89 = asmprn-yhat89 if year==1989

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year if year <1990, c(a)
predict yhat90
predict stdreg90, stdp
gen vt90 = asmprn-yhat87 if year==1990

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year  if year <1991, c(a)
predict yhat91
predict stdreg91, stdp
gen vt91 = asmprn-yhat91 if year==1991

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year if year <1992, c(a)
predict yhat92
predict stdreg92, stdp
gen vt92 = asmprn-yhat92 if year==1992

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year if year < 1993, c(a)
predict yhat93
predict stdreg93, stdp
gen vt93 = asmprn-yhat93 if year==1993

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year  if year <1994, c(a)
predict yhat94
predict stdreg94, stdp
gen vt94 = asmprn-yhat94 if year==1994

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year if year <1995, c(a)
predict yhat95
predict stdreg95, stdp
gen vt95 = asmprn-yhat95 if year==1995

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year if year <1996, c(a)
predict yhat96
predict stdreg96, stdp
gen vt96 = asmprn-yhat96 if year==1996

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year if year <1997, c(a)
predict yhat97
predict stdreg97, stdp
gen vt97 = asmprn-yhat97 if year==1997

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year if year <1998, c(a)
predict yhat98
predict stdreg98, stdp
gen vt98 = asmprn-yhat98 if year==1998

drop yhat*
save jpr3, replace

**************
use jpr4
drop vt*

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year if year <1986 , c(a)
predict yhat86
predict stdreg86, stdp
gen vt86 = asmprn-yhat86 if year==1986

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year if year <1987, c(a)
predict yhat87
predict stdreg87, stdp
gen vt87 = asmprn-yhat87 if year==1987

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year if year <1988, c(a)
predict yhat88
predict stdreg88, stdp
gen vt88 = asmprn-yhat88 if year==1988

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year if year <1989, c(a)
predict yhat89
predict stdreg89, stdp
gen vt89 = asmprn-yhat89 if year==1989

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year if year <1990, c(a)
predict yhat90
predict stdreg90, stdp
gen vt90 = asmprn-yhat87 if year==1990

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year  if year <1991, c(a)
predict yhat91
predict stdreg91, stdp
gen vt91 = asmprn-yhat91 if year==1991

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year if year <1992, c(a)
predict yhat92
predict stdreg92, stdp
gen vt92 = asmprn-yhat92 if year==1992

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year if year < 1993, c(a)
predict yhat93
predict stdreg93, stdp
gen vt93 = asmprn-yhat93 if year==1993

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year  if year <1994, c(a)
predict yhat94
predict stdreg94, stdp
gen vt94 = asmprn-yhat94 if year==1994

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year if year <1995, c(a)
predict yhat95
predict stdreg95, stdp
gen vt95 = asmprn-yhat95 if year==1995

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year if year <1996, c(a)
predict yhat96
predict stdreg96, stdp
gen vt96 = asmprn-yhat96 if year==1996

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year if year <1997, c(a)
predict yhat97
predict stdreg97, stdp
gen vt97 = asmprn-yhat97 if year==1997

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year if year <1998, c(a)
predict yhat98
predict stdreg98, stdp
gen vt98 = asmprn-yhat98 if year==1998

drop yhat*
save jpr4, replace

**************
use jpr5
drop vt*

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year if year <1986 , c(a)
predict yhat86
predict stdreg86, stdp
gen vt86 = asmprn-yhat86 if year==1986

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year if year <1987, c(a)
predict yhat87
predict stdreg87, stdp
gen vt87 = asmprn-yhat87 if year==1987

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year if year <1988, c(a)
predict yhat88
predict stdreg88, stdp
gen vt88 = asmprn-yhat88 if year==1988

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year if year <1989, c(a)
predict yhat89
predict stdreg89, stdp
gen vt89 = asmprn-yhat89 if year==1989

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year if year <1990, c(a)
predict yhat90
predict stdreg90, stdp
gen vt90 = asmprn-yhat87 if year==1990

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year  if year <1991, c(a)
predict yhat91
predict stdreg91, stdp
gen vt91 = asmprn-yhat91 if year==1991

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year if year <1992, c(a)
predict yhat92
predict stdreg92, stdp
gen vt92 = asmprn-yhat92 if year==1992

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year if year < 1993, c(a)
predict yhat93
predict stdreg93, stdp
gen vt93 = asmprn-yhat93 if year==1993

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year  if year <1994, c(a)
predict yhat94
predict stdreg94, stdp
gen vt94 = asmprn-yhat94 if year==1994

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year if year <1995, c(a)
predict yhat95
predict stdreg95, stdp
gen vt95 = asmprn-yhat95 if year==1995

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year if year <1996, c(a)
predict yhat96
predict stdreg96, stdp
gen vt96 = asmprn-yhat96 if year==1996

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year if year <1997, c(a)
predict yhat97
predict stdreg97, stdp
gen vt97 = asmprn-yhat97 if year==1997

quietly xtpcse asmprn communist hri_2  polity    mildum trade2 sanctions  topund year if year <1998, c(a)
predict yhat98
predict stdreg98, stdp
gen vt98 = asmprn-yhat98 if year==1998

drop yhat*
save jpr5, replace
*************
misum jpr vt* stdreg*

