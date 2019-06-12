***************************************
* Calculation of the average earnings *
***************************************

* use data

use "Extended data"

* session 1: rounds 2 and 7 have an effect on payment

generate efonpayment = 1 if session == 1 & round == 2
replace efonpayment = 1 if session == 1 & round == 7

* session 2: rounds 3 and 8 have an effect on payment

replace efonpayment = 1 if session == 2 & round == 3
replace efonpayment = 1 if session == 2 & round == 8

* session 3: rounds 1 and 9 have an effect on payment

replace efonpayment = 1 if session == 3 & round == 1
replace efonpayment = 1 if session == 3 & round == 9

* session 4: rounds 1 and 8 have an effect on payment

replace efonpayment = 2 if session == 4 & round == 1
replace efonpayment = 2 if session == 4 & round == 8

replace efonpayment = 0 if efonpayment == .

* decision makers' variable payment in ECU

generate dmvaripay = mpfirst + mpsec

* decision makers' and non-decision makers' variable payment in ECU

generate dmndmvaripay = efonpayment * dmvaripay

* decision makers' and non-decision makers' flat payment in ECU (9 EUR = 180 ECU -> 2 * 90 ECU)

generate dmndmflatpay = efonpayment * 2 * 90

* decision makers' and non-decision makers' total payment in ECU

generate dmndmtopay = dmndmvaripay + dmndmflatpay

* decision makers' and non-decision makers' total payment in EUR (1 ECU = 1/20 EUR)

generate dmndmtopayeur = (dmndmvaripay + dmndmflatpay) / 20

* total earnings

total dmndmtopayeur

* average earnings (120 participants)

display 1766.1 / 120

* clear data

clear
