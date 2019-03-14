
* UK LGBT SUR - APSR RE-SUBMISSION

*ENGLAND (501 districts)

gen Depriv_real = 100 - Deprivation

* with Conservative as reference

*1 
tlogit Votes_perc_lib ylib Votes_perc_lab ylab Votes_perc_ukip yukip /// 
Votes_perc_gre ygre Votes_perc_other yother, base(Votes_perc_con) percent

tlogit X2010_Vote_perc_lib ylib2010 X2010_Vote_perc_lab ylab2010 ///
X2010_Vote_perc_ukip yukip2010 X2010_Vote_perc_gre ygre2010 ///
X2010_Vote_perc_other yother2010, base(X2010_Vote_perc_con) percent

gen LGB_lab_SSM = LGB_lab_con*SSM_const
gen LGB_lib_SSM = LGB_lib_con*SSM_const
gen LGB_ukip_SSM = LGB_ukip_con*SSM_const
gen LGB_gre_SSM = LGB_gre_con*SSM_const

gen LGB_lab_Urban = LGB_lab_con*Urban
gen LGB_lib_Urban = LGB_lib_con*Urban
gen LGB_ukip_Urban = LGB_ukip_con*Urban
gen LGB_gre_Urban = LGB_gre_con*Urban

gen LGB_lab_Muslim = LGB_lab_con*Muslim
gen LGB_lib_Muslim = LGB_lib_con*Muslim
gen LGB_ukip_Muslim = LGB_ukip_con*Muslim
gen LGB_gre_Muslim = LGB_gre_con*Muslim

gen LGB_lab_white = LGB_lab_con*white_const
gen LGB_lib_white = LGB_lib_con*white_const
gen LGB_ukip_white = LGB_ukip_con*white_const
gen LGB_gre_white = LGB_gre_con*white_const

gen y_lab_con2010 = X2010_Vote_perc_lab/X2010_Vote_perc_con
gen y_lib_con2010 = X2010_Vote_perc_lib/X2010_Vote_perc_con
gen y_ukip_con2010 = X2010_Vote_perc_ukip/X2010_Vote_perc_con
gen y_gre_con2010 = X2010_Vote_perc_gre/X2010_Vote_perc_con


*YES
estsimp sureg (ylab Incumbent_lab_con LGB_lab_con Female_lab_con BME_lab_con ///
Urban Depriv_real white_const Muslim Ukborn SSM_const ///
y_lab_con2010 region_partyvote_15_10_con region_partyvote_15_10_lab) ///
(ylib Incumbent_lib_con LGB_lib_con Female_lib_con BME_lib_con ///
Urban Depriv_real white_const Muslim Ukborn SSM_const ///
y_lib_con2010 region_partyvote_15_10_con region_partyvote_15_10_lib) ///
(yukip Incumbent_ukip_con LGB_ukip_con Female_ukip_con BME_ukip_con ///
Urban Depriv_real white_const Muslim Ukborn SSM_const ///
y_ukip_con2010 region_partyvote_15_10_con region_partyvote_15_10_ukip) ///
(ygre Incumbent_gre_con LGB_gre_con Female_gre_con BME_gre_con ///
Urban Depriv_real white_const Muslim Ukborn SSM_const ///
y_gre_con2010 region_partyvote_15_10_con region_partyvote_15_10_gre)

*YES with INTERACTIONS
estsimp sureg (ylab Incumbent_lab_con LGB_lab_con Female_lab_con BME_lab_con ///
Urban Depriv_real white_const Muslim Ukborn SSM_const LGB_lab_SSM ///
y_lab_con2010 region_partyvote_15_10_con region_partyvote_15_10_lab) ///
(ylib Incumbent_lib_con LGB_lib_con Female_lib_con BME_lib_con ///
Urban Depriv_real white_const Muslim Ukborn SSM_const LGB_lib_SSM ///
y_lib_con2010 region_partyvote_15_10_con region_partyvote_15_10_lib) ///
(yukip Incumbent_ukip_con LGB_ukip_con Female_ukip_con BME_ukip_con ///
Urban Depriv_real white_const Muslim Ukborn SSM_const LGB_ukip_SSM ///
y_ukip_con2010 region_partyvote_15_10_con region_partyvote_15_10_ukip) ///
(ygre Incumbent_gre_con LGB_gre_con Female_gre_con BME_gre_con ///
Urban Depriv_real white_const Muslim Ukborn SSM_const LGB_gre_SSM ///
y_gre_con2010 region_partyvote_15_10_con region_partyvote_15_10_gre)

estsimp sureg (ylab Incumbent_lab_con LGB_lab_con Female_lab_con BME_lab_con ///
Urban Depriv_real white_const Muslim Ukborn SSM_const LGB_lab_Urban ///
y_lab_con2010 region_partyvote_15_10_con region_partyvote_15_10_lab) ///
(ylib Incumbent_lib_con LGB_lib_con Female_lib_con BME_lib_con ///
Urban Depriv_real white_const Muslim Ukborn SSM_const LGB_lib_Urban ///
y_lib_con2010 region_partyvote_15_10_con region_partyvote_15_10_lib) ///
(yukip Incumbent_ukip_con LGB_ukip_con Female_ukip_con BME_ukip_con ///
Urban Depriv_real white_const Muslim Ukborn SSM_const LGB_ukip_Urban ///
y_ukip_con2010 region_partyvote_15_10_con region_partyvote_15_10_ukip) ///
(ygre Incumbent_gre_con LGB_gre_con Female_gre_con BME_gre_con ///
Urban Depriv_real white_const Muslim Ukborn SSM_const LGB_gre_Urban ///
y_gre_con2010 region_partyvote_15_10_con region_partyvote_15_10_gre)

estsimp sureg (ylab Incumbent_lab_con LGB_lab_con Female_lab_con BME_lab_con ///
Urban Depriv_real white_const Muslim Ukborn SSM_const LGB_lab_Muslim ///
y_lab_con2010 region_partyvote_15_10_con region_partyvote_15_10_lab) ///
(ylib Incumbent_lib_con LGB_lib_con Female_lib_con BME_lib_con ///
Urban Depriv_real white_const Muslim Ukborn SSM_const LGB_lib_Muslim ///
y_lib_con2010 region_partyvote_15_10_con region_partyvote_15_10_lib) ///
(yukip Incumbent_ukip_con LGB_ukip_con Female_ukip_con BME_ukip_con ///
Urban Depriv_real white_const Muslim Ukborn SSM_const LGB_ukip_Muslim ///
y_ukip_con2010 region_partyvote_15_10_con region_partyvote_15_10_ukip) ///
(ygre Incumbent_gre_con LGB_gre_con Female_gre_con BME_gre_con ///
Urban Depriv_real white_const Muslim Ukborn SSM_const LGB_gre_Muslim ///
y_gre_con2010 region_partyvote_15_10_con region_partyvote_15_10_gre)

estsimp sureg (ylab Incumbent_lab_con LGB_lab_con Female_lab_con BME_lab_con ///
Urban Depriv_real white_const Muslim Ukborn SSM_const LGB_lab_white ///
y_lab_con2010 region_partyvote_15_10_con region_partyvote_15_10_lab) ///
(ylib Incumbent_lib_con LGB_lib_con Female_lib_con BME_lib_con ///
Urban Depriv_real white_const Muslim Ukborn SSM_const LGB_lib_white ///
y_lib_con2010 region_partyvote_15_10_con region_partyvote_15_10_lib) ///
(yukip Incumbent_ukip_con LGB_ukip_con Female_ukip_con BME_ukip_con ///
Urban Depriv_real white_const Muslim Ukborn SSM_const LGB_ukip_white ///
y_ukip_con2010 region_partyvote_15_10_con region_partyvote_15_10_ukip) ///
(ygre Incumbent_gre_con LGB_gre_con Female_gre_con BME_gre_con ///
Urban Depriv_real white_const Muslim Ukborn SSM_const LGB_gre_white ///
y_gre_con2010 region_partyvote_15_10_con region_partyvote_15_10_gre)

drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13 b14 b15 b16 b17 b18 b19 b20
drop b21 b22 b23 b24 b25 b26 b27 b28 b29 b30 b31 b32 b33 b34 b35 b36 b37
drop b38 b39 b40 b41 b42 b43 b44 b45 b46 b47 b48 b49 b50 
drop b51 b52 b53 b54 b55 b56 b57 b58 b59 b60 b61 b62 b63 b64 b65 b66
drop b67 b68 b69 b70



* with Labour as reference

*1 
tlogit Votes_perc_lib ylib Votes_perc_con ycon Votes_perc_ukip yukip /// 
Votes_perc_gre ygre Votes_perc_other yother, base(Votes_perc_lab) percent

tlogit X2010_Vote_perc_lib ylib2010 X2010_Vote_perc_con ycon2010 ///
X2010_Vote_perc_ukip yukip2010 X2010_Vote_perc_gre ygre2010 ///
X2010_Vote_perc_other yother2010, base(X2010_Vote_perc_lab) percent

gen LGB_con_SSM = LGB_con_lab*SSM_const
gen LGB_lib_SSM = LGB_lib_lab*SSM_const
gen LGB_ukip_SSM = LGB_ukip_lab*SSM_const
gen LGB_gre_SSM = LGB_gre_lab*SSM_const

gen LGB_con_Urban = LGB_con_lab*Urban
gen LGB_lib_Urban = LGB_lib_lab*Urban
gen LGB_ukip_Urban = LGB_ukip_lab*Urban
gen LGB_gre_Urban = LGB_gre_lab*Urban

gen LGB_con_Muslim = LGB_con_lab*Muslim
gen LGB_lib_Muslim = LGB_lib_lab*Muslim
gen LGB_ukip_Muslim = LGB_ukip_lab*Muslim
gen LGB_gre_Muslim = LGB_gre_lab*Muslim

gen LGB_con_white = LGB_con_lab*white_const
gen LGB_lib_white = LGB_lib_lab*white_const
gen LGB_ukip_white = LGB_ukip_lab*white_const
gen LGB_gre_white = LGB_gre_lab*white_const

gen LGB_labonly_SSM = LGB_lab*SSM_const

gen y_con_lab2010 = X2010_Vote_perc_con/X2010_Vote_perc_lab
gen y_lib_lab2010 = X2010_Vote_perc_lib/X2010_Vote_perc_lab
gen y_ukip_lab2010 = X2010_Vote_perc_ukip/X2010_Vote_perc_lab
gen y_gre_lab2010 = X2010_Vote_perc_gre/X2010_Vote_perc_lab

*YES
estsimp sureg (ycon Incumbent_con_lab LGB_con_lab Female_con_lab BME_con_lab ///
Urban Depriv_real white_const Muslim Ukborn SSM_const ///
y_con_lab2010 region_partyvote_15_10_lab region_partyvote_15_10_con) ///
(ylib Incumbent_lib_lab LGB_lib_lab Female_lib_lab BME_lib_lab /// 
Urban Depriv_real white_const Muslim Ukborn SSM_const ///
y_lib_lab2010 region_partyvote_15_10_lab region_partyvote_15_10_lib) ///
(yukip Incumbent_ukip_lab LGB_ukip_lab Female_ukip_lab BME_ukip_lab /// 
Urban Depriv_real white_const Muslim Ukborn SSM_const ///
y_ukip_lab2010 region_partyvote_15_10_lab region_partyvote_15_10_ukip) ///
(ygre Incumbent_gre_lab LGB_gre_lab Female_gre_lab BME_gre_lab /// 
Urban Depriv_real white_const Muslim Ukborn SSM_const ///
y_gre_lab2010 region_partyvote_15_10_lab region_partyvote_15_10_gre)

*YES WITH INTERACTIONS
estsimp sureg (ycon Incumbent_con_lab LGB_con_lab Female_con_lab BME_con_lab ///
Urban Depriv_real white_const Muslim Ukborn SSM_const LGB_con_white ///
y_con_lab2010 region_partyvote_15_10_lab region_partyvote_15_10_con) ///
(ylib Incumbent_lib_lab LGB_lib_lab Female_lib_lab BME_lib_lab /// 
Urban Depriv_real white_const Muslim Ukborn SSM_const LGB_lib_white ///
y_lib_lab2010 region_partyvote_15_10_lab region_partyvote_15_10_lib) ///
(yukip Incumbent_ukip_lab LGB_ukip_lab Female_ukip_lab BME_ukip_lab /// 
Urban Depriv_real white_const Muslim Ukborn SSM_const LGB_ukip_white ///
y_ukip_lab2010 region_partyvote_15_10_lab region_partyvote_15_10_ukip) ///
(ygre Incumbent_gre_lab LGB_gre_lab Female_gre_lab BME_gre_lab /// 
Urban Depriv_real white_const Muslim Ukborn SSM_const LGB_gre_white ///
y_gre_lab2010 region_partyvote_15_10_lab region_partyvote_15_10_gre)

drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13 b14 b15 b16 b17 b18 b19 b20
drop b21 b22 b23 b24 b25 b26 b27 b28 b29 b30 b31 b32 b33 b34 b35 b36 b37
drop b38 b39 b40 b41 b42 b43 b44 b45 b46 b47 b48 b49 b50 
drop b51 b52 b53 b54 b55 b56 b57 b58 b59 b60 b61 b62 b63 b64 b65 b66
drop b67 b68 b69 b70


* with LibDem as reference

*1 
tlogit Votes_perc_lab ylab Votes_perc_con ycon Votes_perc_ukip yukip /// 
Votes_perc_gre ygre Votes_perc_other yother, base(Votes_perc_lib) percent

tlogit X2010_Vote_perc_lab ylab2010 X2010_Vote_perc_con ycon2010 ///
X2010_Vote_perc_ukip yukip2010 X2010_Vote_perc_gre ygre2010 ///
X2010_Vote_perc_other yother2010, base(X2010_Vote_perc_lib) percent

gen LGB_con_SSM = LGB_con_lib*SSM_const
gen LGB_lab_SSM = LGB_lab_lib*SSM_const
gen LGB_ukip_SSM = LGB_ukip_lib*SSM_const
gen LGB_gre_SSM = LGB_gre_lib*SSM_const

gen LGB_con_Urban = LGB_con_lib*Urban
gen LGB_lab_Urban = LGB_lab_lib*Urban
gen LGB_ukip_Urban = LGB_ukip_lib*Urban
gen LGB_gre_Urban = LGB_gre_lib*Urban

gen LGB_con_Muslim = LGB_con_lib*Muslim
gen LGB_lab_Muslim = LGB_lab_lib*Muslim
gen LGB_ukip_Muslim = LGB_ukip_lib*Muslim
gen LGB_gre_Muslim = LGB_gre_lib*Muslim

gen LGB_con_white = LGB_con_lib*white_const
gen LGB_lab_white = LGB_lab_lib*white_const
gen LGB_ukip_white = LGB_ukip_lib*white_const
gen LGB_gre_white = LGB_gre_lib*white_const

gen y_con_lib2010 = X2010_Vote_perc_con/X2010_Vote_perc_lib
gen y_lab_lib2010 = X2010_Vote_perc_lab/X2010_Vote_perc_lib
gen y_ukip_lib2010 = X2010_Vote_perc_ukip/X2010_Vote_perc_lib
gen y_gre_lib2010 = X2010_Vote_perc_gre/X2010_Vote_perc_lib

*YES
estsimp sureg (ycon Incumbent_con_lib LGB_con_lib Female_con_lib BME_con_lib ///
Urban Depriv_real white_const Muslim Ukborn SSM_const ///
y_con_lib2010 region_partyvote_15_10_lib region_partyvote_15_10_con) ///
(ylab Incumbent_lab_lib LGB_lab_lib Female_lab_lib BME_lab_lib /// 
Urban Depriv_real white_const Muslim Ukborn SSM_const ///
y_lab_lib2010 region_partyvote_15_10_lib region_partyvote_15_10_lab) ///
(yukip Incumbent_ukip_lib LGB_ukip_lib Female_ukip_lib BME_ukip_lib /// 
Urban Depriv_real white_const Muslim Ukborn SSM_const ///
y_ukip_lib2010 region_partyvote_15_10_lib region_partyvote_15_10_ukip) ///
(ygre Incumbent_gre_lib LGB_gre_lib Female_gre_lib BME_gre_lib /// 
Urban Depriv_real white_const Muslim Ukborn SSM_const ///
y_gre_lib2010 region_partyvote_15_10_lib region_partyvote_15_10_gre)

*YES with INTERACTIONS
estsimp sureg (ycon Incumbent_con_lib LGB_con_lib Female_con_lib BME_con_lib ///
Urban Depriv_real white_const Muslim Ukborn SSM_const LGB_con_white ///
y_con_lib2010 region_partyvote_15_10_lib region_partyvote_15_10_con) ///
(ylab Incumbent_lab_lib LGB_lab_lib Female_lab_lib BME_lab_lib /// 
Urban Depriv_real white_const Muslim Ukborn SSM_const LGB_lab_white ///
y_lab_lib2010 region_partyvote_15_10_lib region_partyvote_15_10_lab) ///
(yukip Incumbent_ukip_lib LGB_ukip_lib Female_ukip_lib BME_ukip_lib /// 
Urban Depriv_real white_const Muslim Ukborn SSM_const LGB_ukip_white ///
y_ukip_lib2010 region_partyvote_15_10_lib region_partyvote_15_10_ukip) ///
(ygre Incumbent_gre_lib LGB_gre_lib Female_gre_lib BME_gre_lib /// 
Urban Depriv_real white_const Muslim Ukborn SSM_const LGB_gre_white ///
y_gre_lib2010 region_partyvote_15_10_lib region_partyvote_15_10_gre)

drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13 b14 b15 b16 b17 b18 b19 b20
drop b21 b22 b23 b24 b25 b26 b27 b28 b29 b30 b31 b32 b33 b34 b35 b36 b37
drop b38 b39 b40 b41 b42 b43 b44 b45 b46 b47 b48 b49 b50 
drop b51 b52 b53 b54 b55 b56 b57 b58 b59 b60 b61 b62 b63 b64 b65 b66
drop b67 b68 b69 b70





* with UKIP as reference

*1 
tlogit Votes_perc_lib ylib Votes_perc_con ycon Votes_perc_lab ylab /// 
Votes_perc_gre ygre Votes_perc_other yother, base(Votes_perc_ukip) percent

tlogit X2010_Vote_perc_lib ylib2010 X2010_Vote_perc_con ycon2010 ///
X2010_Vote_perc_lab ylab2010 X2010_Vote_perc_gre ygre2010 ///
X2010_Vote_perc_other yother2010, base(X2010_Vote_perc_ukip) percent

gen LGB_con_SSM = LGB_con_ukip*SSM_const
gen LGB_lab_SSM = LGB_lab_ukip*SSM_const
gen LGB_lib_SSM = LGB_lib_ukip*SSM_const
gen LGB_gre_SSM = LGB_gre_ukip*SSM_const

gen LGB_con_Urban = LGB_con_ukip*Urban
gen LGB_lab_Urban = LGB_lab_ukip*Urban
gen LGB_lib_Urban = LGB_lib_ukip*Urban
gen LGB_gre_Urban = LGB_gre_ukip*Urban

gen LGB_con_Muslim = LGB_con_ukip*Muslim
gen LGB_lab_Muslim = LGB_lab_ukip*Muslim
gen LGB_lib_Muslim = LGB_lib_ukip*Muslim
gen LGB_gre_Muslim = LGB_gre_ukip*Muslim

gen LGB_con_white = LGB_con_ukip*white_const
gen LGB_lab_white = LGB_lab_ukip*white_const
gen LGB_lib_white = LGB_lib_ukip*white_const
gen LGB_gre_white = LGB_gre_ukip*white_const

gen y_con_ukip2010 = X2010_Vote_perc_con/X2010_Vote_perc_ukip
gen y_lab_ukip2010 = X2010_Vote_perc_lab/X2010_Vote_perc_ukip
gen y_lib_ukip2010 = X2010_Vote_perc_lib/X2010_Vote_perc_ukip
gen y_gre_ukip2010 = X2010_Vote_perc_gre/X2010_Vote_perc_ukip



*YES
estsimp sureg (ycon Incumbent_con_ukip LGB_con_ukip Female_con_ukip BME_con_ukip ///
Urban Depriv_real white_const Muslim Ukborn SSM_const ///
y_con_ukip2010 region_partyvote_15_10_ukip region_partyvote_15_10_con) ///
(ylab Incumbent_lab_ukip LGB_lab_ukip Female_lab_ukip BME_lab_ukip /// 
Urban Depriv_real white_const Muslim Ukborn SSM_const ///
y_lab_ukip2010 region_partyvote_15_10_ukip region_partyvote_15_10_lab) ///
(ylib Incumbent_lib_ukip LGB_lib_ukip Female_lib_ukip BME_lib_ukip /// 
Urban Depriv_real white_const Muslim Ukborn SSM_const ///
y_lib_ukip2010 region_partyvote_15_10_ukip region_partyvote_15_10_lib) ///
(ygre Incumbent_gre_ukip LGB_gre_ukip Female_gre_ukip BME_gre_ukip /// 
Urban Depriv_real white_const Muslim Ukborn SSM_const ///
y_gre_ukip2010 region_partyvote_15_10_ukip region_partyvote_15_10_gre)


*YES with INTERACTIONS
estsimp sureg (ycon Incumbent_con_ukip LGB_con_ukip Female_con_ukip BME_con_ukip ///
Urban Depriv_real white_const Muslim Ukborn SSM_const LGB_con_white ///
y_con_ukip2010 region_partyvote_15_10_ukip region_partyvote_15_10_con) ///
(ylab Incumbent_lab_ukip LGB_lab_ukip Female_lab_ukip BME_lab_ukip /// 
Urban Depriv_real white_const Muslim Ukborn SSM_const LGB_lab_white ///
y_lab_ukip2010 region_partyvote_15_10_ukip region_partyvote_15_10_lab) ///
(ylib Incumbent_lib_ukip LGB_lib_ukip Female_lib_ukip BME_lib_ukip /// 
Urban Depriv_real white_const Muslim Ukborn SSM_const LGB_lib_white ///
y_lib_ukip2010 region_partyvote_15_10_ukip region_partyvote_15_10_lib) ///
(ygre Incumbent_gre_ukip LGB_gre_ukip Female_gre_ukip BME_gre_ukip /// 
Urban Depriv_real white_const Muslim Ukborn SSM_const LGB_gre_white ///
y_gre_ukip2010 region_partyvote_15_10_ukip region_partyvote_15_10_gre)


drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13 b14 b15 b16 b17 b18 b19 b20
drop b21 b22 b23 b24 b25 b26 b27 b28 b29 b30 b31 b32 b33 b34 b35 b36 b37
drop b38 b39 b40 b41 b42 b43 b44 b45 b46 b47 b48 b49 b50 
drop b51 b52 b53 b54 b55 b56 b57 b58 b59 b60 b61 b62 b63 b64 b65 b66
drop b67 b68 b69 b70



* with Green as reference

*1 
tlogit Votes_perc_lib ylib Votes_perc_con ycon Votes_perc_lab ylab /// 
Votes_perc_ukip yukip Votes_perc_other yother, base(Votes_perc_gre) percent

tlogit X2010_Vote_perc_lib ylib2010 X2010_Vote_perc_con ycon2010 ///
X2010_Vote_perc_lab ylab2010 X2010_Vote_perc_ukip yukip2010 ///
X2010_Vote_perc_other yother2010, base(X2010_Vote_perc_gre) percent

gen LGB_con_SSM = LGB_con_gre*SSM_const
gen LGB_lab_SSM = LGB_lab_gre*SSM_const
gen LGB_lib_SSM = LGB_lib_gre*SSM_const
gen LGB_ukip_SSM = LGB_ukip_gre*SSM_const

gen LGB_con_Urban = LGB_con_gre*Urban
gen LGB_lab_Urban = LGB_lab_gre*Urban
gen LGB_lib_Urban = LGB_lib_gre*Urban
gen LGB_ukip_Urban = LGB_ukip_gre*Urban

gen LGB_con_Muslim = LGB_con_gre*Muslim
gen LGB_lab_Muslim = LGB_lab_gre*Muslim
gen LGB_lib_Muslim = LGB_lib_gre*Muslim
gen LGB_ukip_Muslim = LGB_ukip_gre*Muslim

gen LGB_con_white = LGB_con_gre*white_const
gen LGB_lab_white = LGB_lab_gre*white_const
gen LGB_lib_white = LGB_lib_gre*white_const
gen LGB_ukip_white = LGB_ukip_gre*white_const

gen y_con_gre2010 = X2010_Vote_perc_con/X2010_Vote_perc_gre
gen y_lab_gre2010 = X2010_Vote_perc_lab/X2010_Vote_perc_gre
gen y_lib_gre2010 = X2010_Vote_perc_lib/X2010_Vote_perc_gre
gen y_ukip_gre2010 = X2010_Vote_perc_ukip/X2010_Vote_perc_gre

summ y_lib_gre2010

*Yes
estsimp sureg (ycon Incumbent_con_gre LGB_con_gre Female_con_gre BME_con_gre ///
Urban Depriv_real white_const Muslim Ukborn SSM_const ///
y_con_gre2010 region_partyvote_15_10_gre region_partyvote_15_10_con) ///
(ylab Incumbent_lab_gre LGB_lab_gre Female_lab_gre BME_lab_gre /// 
Urban Depriv_real white_const Muslim Ukborn SSM_const ///
y_lab_gre2010 region_partyvote_15_10_gre region_partyvote_15_10_lab) ///
(ylib Incumbent_lib_gre LGB_lib_gre Female_lib_gre BME_lib_gre /// 
Urban Depriv_real white_const Muslim Ukborn SSM_const ///
y_lib_gre2010 region_partyvote_15_10_gre region_partyvote_15_10_lib) ///
(yukip Incumbent_ukip_gre LGB_ukip_gre Female_ukip_gre BME_ukip_gre /// 
Urban Depriv_real white_const Muslim Ukborn SSM_const ///
y_ukip_gre2010 region_partyvote_15_10_gre region_partyvote_15_10_ukip)

*Yes with interactions
estsimp sureg (ycon Incumbent_con_gre LGB_con_gre Female_con_gre BME_con_gre ///
Urban Depriv_real white_const Muslim Ukborn SSM_const LGB_con_white ///
y_con_gre2010 region_partyvote_15_10_gre region_partyvote_15_10_con) ///
(ylab Incumbent_lab_gre LGB_lab_gre Female_lab_gre BME_lab_gre /// 
Urban Depriv_real white_const Muslim Ukborn SSM_const LGB_lab_white ///
y_lab_gre2010 region_partyvote_15_10_gre region_partyvote_15_10_lab) ///
(ylib Incumbent_lib_gre LGB_lib_gre Female_lib_gre BME_lib_gre /// 
Urban Depriv_real white_const Muslim Ukborn SSM_const LGB_lib_white ///
y_lib_gre2010 region_partyvote_15_10_gre region_partyvote_15_10_lib) ///
(yukip Incumbent_ukip_gre LGB_ukip_gre Female_ukip_gre BME_ukip_gre /// 
Urban Depriv_real white_const Muslim Ukborn SSM_const LGB_ukip_white ///
y_ukip_gre2010 region_partyvote_15_10_gre region_partyvote_15_10_ukip)



drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13 b14 b15 b16 b17 b18 b19 b20
drop b21 b22 b23 b24 b25 b26 b27 b28 b29 b30 b31 b32 b33 b34 b35 b36 b37
drop b38 b39 b40 b41 b42 b43 b44 b45 b46 b47 b48 b49 b50 
drop b51 b52 b53 b54 b55 b56 b57 b58 b59 b60 b61 b62 b63 b64 b65 b66
drop b67 b68 b69 b70


* Including EDUCATION and PARTY SPENDING

* UK LGBT SUR - APSR RE-SUBMISSION

*ENGLAND (501 districts)

gen Depriv_real = 100 - Deprivation

* with Conservative as reference

*1 
tlogit Votes_perc_lib ylib Votes_perc_lab ylab Votes_perc_ukip yukip /// 
Votes_perc_gre ygre Votes_perc_other yother, base(Votes_perc_con) percent

gen y_lab_con2010 = X2010_Vote_perc_lab/X2010_Vote_perc_con
gen y_lib_con2010 = X2010_Vote_perc_lib/X2010_Vote_perc_con

gen LGB_lab_SSM = LGB_lab_con*SSM_const
gen LGB_lib_SSM = LGB_lib_con*SSM_const

gen LGB_lab_Urban = LGB_lab_con*Urban
gen LGB_lib_Urban = LGB_lib_con*Urban

gen LGB_lab_Muslim = LGB_lab_con*Muslim
gen LGB_lib_Muslim = LGB_lib_con*Muslim

gen LGB_lab_white = LGB_lab_con*white_const
gen LGB_lib_white = LGB_lib_con*white_const

*Base
estsimp sureg (ylab Incumbent_lab_con LGB_lab_con Female_lab_con BME_lab_con ///
Educ_con Educ_lab Party_Spend_con Party_Spend_lab ///
Urban Depriv_real white_const Muslim Ukborn SSM_const ///
y_lab_con2010 region_partyvote_15_10_con region_partyvote_15_10_lab) ///
(ylib Incumbent_lib_con LGB_lib_con Female_lib_con BME_lib_con ///
Educ_con Educ_lib Party_Spend_con Party_Spend_lib ///
Urban Depriv_real white_const Muslim Ukborn SSM_const ///
y_lib_con2010 region_partyvote_15_10_con region_partyvote_15_10_lib)

*Interactions
estsimp sureg (ylab Incumbent_lab_con LGB_lab_con Female_lab_con BME_lab_con ///
Educ_con Educ_lab Party_Spend_con Party_Spend_lab ///
Urban Depriv_real white_const Muslim Ukborn SSM_const LGB_lab_white ///
y_lab_con2010 region_partyvote_15_10_con region_partyvote_15_10_lab) ///
(ylib Incumbent_lib_con LGB_lib_con Female_lib_con BME_lib_con ///
Educ_con Educ_lib Party_Spend_con Party_Spend_lib ///
Urban Depriv_real white_const Muslim Ukborn SSM_const LGB_lib_white ///
y_lib_con2010 region_partyvote_15_10_con region_partyvote_15_10_lib)

drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13 b14 b15 b16 b17 b18 b19 b20
drop b21 b22 b23 b24 b25 b26 b27 b28 b29 b30 b31 b32 b33 b34 b35 b36 b37
drop b38 b39 b40 b41 


* with Labour as reference

*1 
tlogit Votes_perc_lib ylib Votes_perc_con ycon Votes_perc_ukip yukip /// 
Votes_perc_gre ygre Votes_perc_other yother, base(Votes_perc_lab) percent

gen y_con_lab2010 = X2010_Vote_perc_con/X2010_Vote_perc_lab
gen y_lib_lab2010 = X2010_Vote_perc_lib/X2010_Vote_perc_lab

gen LGB_con_SSM = LGB_con_lab*SSM_const
gen LGB_lib_SSM = LGB_lib_lab*SSM_const

gen LGB_con_Urban = LGB_con_lab*Urban
gen LGB_lib_Urban = LGB_lib_lab*Urban

gen LGB_con_Muslim = LGB_con_lab*Muslim
gen LGB_lib_Muslim = LGB_lib_lab*Muslim

gen LGB_con_white = LGB_con_lab*white_const
gen LGB_lib_white = LGB_lib_lab*white_const


*Base
estsimp sureg (ycon Incumbent_con_lab LGB_con_lab Female_con_lab BME_con_lab ///
Educ_lab Educ_con Party_Spend_lab Party_Spend_con ///
Urban Depriv_real white_const Muslim Ukborn SSM_const ///
y_con_lab2010 region_partyvote_15_10_lab region_partyvote_15_10_con) ///
(ylib Incumbent_lib_lab LGB_lib_lab Female_lib_lab BME_lib_lab /// 
Educ_lab Educ_lib Party_Spend_lab Party_Spend_lib ///
Urban Depriv_real white_const Muslim Ukborn SSM_const ///
y_lib_lab2010 region_partyvote_15_10_lab region_partyvote_15_10_lib)

*Interaction
estsimp sureg (ycon Incumbent_con_lab LGB_con_lab Female_con_lab BME_con_lab ///
Educ_lab Educ_con Party_Spend_lab Party_Spend_con LGB_con_white ///
Urban Depriv_real white_const Muslim Ukborn SSM_const ///
y_con_lab2010 region_partyvote_15_10_lab region_partyvote_15_10_con) ///
(ylib Incumbent_lib_lab LGB_lib_lab Female_lib_lab BME_lib_lab /// 
Educ_lab Educ_lib Party_Spend_lab Party_Spend_lib LGB_lib_white ///
Urban Depriv_real white_const Muslim Ukborn SSM_const ///
y_lib_lab2010 region_partyvote_15_10_lab region_partyvote_15_10_lib)

drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13 b14 b15 b16 b17 b18 b19 b20
drop b21 b22 b23 b24 b25 b26 b27 b28 b29 b30 b31 b32 b33 b34 b35 b36 b37
drop b38 b39 b40 b41 


* with LibDem as reference

*1 
tlogit Votes_perc_lab ylab Votes_perc_con ycon Votes_perc_ukip yukip /// 
Votes_perc_gre ygre Votes_perc_other yother, base(Votes_perc_lib) percent

gen y_con_lib2010 = X2010_Vote_perc_con/X2010_Vote_perc_lib
gen y_lab_lib2010 = X2010_Vote_perc_lab/X2010_Vote_perc_lib

gen LGB_con_SSM = LGB_con_lib*SSM_const
gen LGB_lab_SSM = LGB_lab_lib*SSM_const

gen LGB_con_Urban = LGB_con_lib*Urban
gen LGB_lab_Urban = LGB_lab_lib*Urban

gen LGB_con_Muslim = LGB_con_lib*Muslim
gen LGB_lab_Muslim = LGB_lab_lib*Muslim

gen LGB_con_white = LGB_con_lib*white_const
gen LGB_lab_white = LGB_lab_lib*white_const


*YES
estsimp sureg (ycon Incumbent_con_lib LGB_con_lib Female_con_lib BME_con_lib ///
Educ_lib Educ_con Party_Spend_lib Party_Spend_con ///
Urban Depriv_real white_const Muslim Ukborn SSM_const ///
y_con_lib2010 region_partyvote_15_10_lib region_partyvote_15_10_con) ///
(ylab Incumbent_lab_lib LGB_lab_lib Female_lab_lib BME_lab_lib /// 
Educ_lib Educ_lab Party_Spend_lib Party_Spend_lab ///
Urban Depriv_real white_const Muslim Ukborn SSM_const ///
y_lab_lib2010 region_partyvote_15_10_lib region_partyvote_15_10_lab)

*Interaction
estsimp sureg (ycon Incumbent_con_lib LGB_con_lib Female_con_lib BME_con_lib ///
Educ_lib Educ_con Party_Spend_lib Party_Spend_con LGB_con_white ///
Urban Depriv_real white_const Muslim Ukborn SSM_const ///
y_con_lib2010 region_partyvote_15_10_lib region_partyvote_15_10_con) ///
(ylab Incumbent_lab_lib LGB_lab_lib Female_lab_lib BME_lab_lib /// 
Educ_lib Educ_lab Party_Spend_lib Party_Spend_lab LGB_lab_white ///
Urban Depriv_real white_const Muslim Ukborn SSM_const ///
y_lab_lib2010 region_partyvote_15_10_lib region_partyvote_15_10_lab)




drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13 b14 b15 b16 b17 b18 b19 b20
drop b21 b22 b23 b24 b25 b26 b27 b28 b29 b30 b31 b32 b33 b34 b35 b36 b37
drop b38 b39 b40 b41 


