*Regression of Table IV

*Model 1
reg TI Llevel65 if USAwithoutBLA==1, robust
*Model 2
reg TI Llevel65 Dictatorship if USAwithoutBLA==1, robust
*Model 3
reg  TI  Meangrowth6570 Educdif7065 if  USAwithoutBLA==1, robust
*Model 4
reg  TI  Meangrowth6570 Educdif7065 Dictatorship if  USAwithoutBLA==1, robust
*Model 5
reg  TI   Strikevol7080 Demon7080 if  USAwithoutBLA==1, robust
*Model 6
reg  TI   Strikevol7080 Demon7080  Dictatorship if  USAwithoutBLA==1, robust
*Model 7
reg  TI    Staterev65  if  USAwithoutBLA==1, robust
*Model 8
reg  TI    Staterev65  Dictatorship  if  USAwithoutBLA==1, robust
*Model 9
reg  TI     Communist7579 Dictatorship  if  USAwithoutBLA==1, robust
*Model 10
reg  TI     Communist7579 Dictatorship   Lpopulation70  if  USAwithoutBLA==1, robust




*Alternative regressions to those of Table IV with Fatalities as dependent variabel instead of TI

*Model 1'
reg Fatalities Llevel65 if USAwithoutBLA==1, robust
*Model 2'
reg Fatalities Llevel65 Dictatorship if USAwithoutBLA==1, robust
*Model 3'
reg  Fatalities  Meangrowth6570 Educdif7065 if  USAwithoutBLA==1, robust
*Model 4'
reg  Fatalities  Meangrowth6570 Educdif7065 Dictatorship if  USAwithoutBLA==1, robust
*Model 5'
reg  Fatalities   Strikevol7080 Demon7080 if  USAwithoutBLA==1, robust
*Model 6'
reg  Fatalities   Strikevol7080 Demon7080  Dictatorship if  USAwithoutBLA==1, robust
*Model 7'
reg  Fatalities    Staterev65  if  USAwithoutBLA==1, robust
*Model 8'
reg  Fatalities    Staterev65  Dictatorship  if  USAwithoutBLA==1, robust
*Model 9'
reg  Fatalities     Communist7579 Dictatorship  if  USAwithoutBLA==1, robust
*Model 10'
reg  Fatalities     Communist7579 Dictatorship   Lpopulation70  if  USAwithoutBLA==1, robust



*The effect of democracy in 1970 and past dictatorship
reg   TI SIP1970  if  USAwithoutBLA==1, robust

reg   TI SIP1970   Dictatorship if  USAwithoutBLA==1, robust

reg   TI  ACLPreg1970  if  USAwithoutBLA==1, robust

reg   TI  ACLPreg1970  Dictatorship if  USAwithoutBLA==1, robust


*Alternative regressions to those of Table IV with TI as dependent variable including Black Liberation Army's victims in the USA
*Model 1''
reg TI Llevel65 if USAwithBLA==1, robust
*Model 2''
reg TI Llevel65 Dictatorship if USAwithBLA==1, robust
*Model 3''
reg  TI  Meangrowth6570 Educdif7065 if  USAwithBLA==1, robust
*Model 4''
reg  TI Meangrowth6570 Educdif7065 Dictatorship if  USAwithBLA==1, robust
*Model 5''
reg  TI   Strikevol7080 Demon7080 if  USAwithBLA==1, robust
*Model 6''
reg  TI   Strikevol7080 Demon7080  Dictatorship if  USAwithBLA==1, robust
*Model 7''
reg  TI    Staterev65  if  USAwithBLA==1, robust
*Model 8''
reg  TI    Staterev65  Dictatorship  if  USAwithBLA==1, robust
*Model 9''
reg  TI     Communist7579 Dictatorship  if  USAwithBLA==1, robust
*Model 10''
reg  TI     Communist7579 Dictatorship   Lpopulation70  if  USAwithBLA==1, robust


*Regressions with TI as dependent variable and concurrent independent variables measured in the 1970s
*Model 1'''
reg TI Llevel75 if USAwithoutBLA==1, robust
*Model 2'''
reg TI Llevel75 Dictatorship if USAwithoutBLA==1, robust
*Model 3'''
reg  TI  Meangrowth7080 Educdif7570 if  USAwithoutBLA==1, robust
*Model 4'''
reg  TI Meangrowth7080 Educdif7570 Dictatorship if  USAwithoutBLA==1, robust
*Model 7'''
reg  TI    Staterev75  if  USAwithoutBLA==1, robust
*Model 8'''
reg  TI    Staterev65  Dictatorship  if  USAwithoutBLA==1, robust







