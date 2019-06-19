/*cities with lead or mixed*/

/*unknown*/ gen masslead = 0

/*none*/ replace masslead = 1 if cityd==2710 | cityd==4030 | cityd==4530 | cityd==7250 | cityd==3550 | cityd==5510 | cityd==850
replace masslead = 1 if cityd==870 | cityd==930 | cityd==2250  | cityd==2510 | cityd==3810  | cityd==3990 | cityd==4690 | cityd==5390 | cityd==6510 | cityd==6570
replace masslead = 1 if cityd==6670 | cityd==6910 | cityd==7170 | cityd==7570 | cityd==1490 | cityd==4390 | cityd==4730 | cityd==7210 | cityd==370 | cityd==2050
replace masslead = 1 if cityd==7010 | cityd==390 | cityd==750 | cityd==2070 | cityd==4290 | cityd==150 | cityd==1170 | cityd==2090 | cityd==7470 | cityd==4210
replace masslead = 1 if cityd==2170 | cityd==2270 | cityd==5470 | cityd==10 | cityd==990 | cityd==4650 | cityd==2550 | cityd==3370 | cityd==7270 | cityd==3260 | cityd==6690
replace masslead = 1 if cityd==5910 | cityd==4170 | cityd==3110 | cityd==6890 | cityd==410 | cityd==7510 | cityd==1410 | cityd==2350 | cityd==2890
replace masslead = 1 if cityd==530 | cityd==4990 | cityd==3330 | cityd==4970 | cityd==30 | cityd==710 | cityd==4930 | cityd==5150 | cityd==6030

replace masslead = 1 if cityd==190 | cityd==230 | cityd==270 | cityd==430 | cityd==550 | cityd==570 | cityd==670 | cityd==740 | cityd==905
replace masslead = 1 if cityd==970 | cityd==1070 | cityd==1430 | cityd==1850 | cityd==2400 | cityd==2570 | cityd==2590 | cityd==3090 | cityd==3680
replace masslead = 1 if cityd==3690 | cityd==3850 | cityd==3930 | cityd==3950 | cityd==4330 | cityd==4840 | cityd==4870 
replace masslead = 1 if cityd==5070 | cityd==5110 | cityd==5250 | cityd==5350 | cityd==5450 | cityd==5890 | cityd==6150 | cityd==6250 | cityd==6330
replace masslead = 1 if cityd==6350 | cityd==7150 

/*mixed*/ replace masslead = 2 if cityd==830 | cityd==4470 | cityd==4770 | cityd==5230 | cityd==5050 | cityd==5290 | cityd==3310 | cityd==4610 | cityd==7030
replace masslead = 2 if cityd==730 | cityd==2690 | cityd==2750 | cityd==3170 | cityd==3450 | cityd==4510 | cityd==5330 | cityd==5790 | cityd==6410 | cityd==6470
replace masslead = 2 if cityd==1190 | cityd==5690 | cityd==3230 | cityd==2630 | cityd==4430 | cityd==610 | cityd==1450 | cityd==3610 | cityd==7190 | cityd==7650
replace masslead = 2 if cityd==5090 | cityd==1370 | cityd==1730 | cityd==3250 | cityd==6990 | cityd==3210 | cityd==3790 | cityd==4750 | cityd==5590 | cityd==4250 
replace masslead = 2 if cityd==6370 | cityd==7530 | cityd==1050 | cityd==2410 | cityd==4010 | cityd==1390 | cityd==910 | cityd==3730 | cityd==6290 | cityd==6430 | cityd==7230

replace masslead = 2 if cityd==590 | cityd==900 | cityd==1230 | cityd==1400 | cityd==2970 | cityd==3520 | cityd==4230 | cityd==4370 | cityd==4490 | cityd==5410 | cityd==5490
replace masslead = 2 if cityd==5570 | cityd==5610 | cityd==5850 

/*lead*/ replace masslead = 3 if cityd==4890 | cityd==6730 | cityd==810 | cityd==1130 | cityd==1210 | cityd==2190 | cityd==2230 | cityd==2730 | cityd==2850 | cityd==3510 | cityd==3770
replace masslead = 3 if cityd==3890 | cityd==4450 | cityd==5710 | cityd==3910 | cityd==5650 | cityd==7550 | cityd==7490 | cityd==650 | cityd==950 | cityd==2810 | cityd==4630
replace masslead = 3 if cityd==7330 | cityd==50 | cityd==170 | cityd==890 | cityd==4590 | cityd==4670 | cityd==4790 | cityd==5630 | cityd==5930 | cityd==6390 | cityd==6850 | cityd==7590
replace masslead = 3 if cityd==110 | cityd==130 | cityd==3970 | cityd==4830 | cityd==5370 | cityd==7610 | cityd==470 | cityd==2030 | cityd==3190 | cityd==5270 | cityd==5950 | cityd==5970
replace masslead = 3 if cityd==6650 | cityd==1870 | cityd==2330 | cityd==2990 | cityd==6590 | cityd==630 | cityd==1750 | cityd==2530 | cityd==3070 | cityd==3470 | cityd==6050
replace masslead = 3 if cityd==1290 | cityd==1330 | cityd==1670 | cityd==2610 | cityd==3710 | cityd==6710 | cityd==6970 | cityd==7630 | cityd==3870 | cityd==4130 | cityd==5730
replace masslead = 3 if cityd==6830 | cityd==1010 | cityd==1510 | cityd==6510 | cityd==4150 | cityd==6110
replace masslead = 3 if cityd==6090 | cityd==3630 | cityd==5010 | cityd==6610 | cityd==4810 | cityd==5870 | cityd==770 | cityd==350 | cityd==4570 | cityd==1530 | cityd==3570
replace masslead = 3 if cityd==3750 | cityd==4710 | cityd==4410 | cityd==4411 | cityd==7390 | cityd==1710 | cityd==6210 | cityd==6630


replace masslead = 3 if cityd==70 | cityd==1420 | cityd==2220 | cityd==2280 | cityd==3050 | cityd==3270 | cityd==3290 | cityd==4550
replace masslead = 3 if cityd==5750 | cityd==5990 | cityd==6280 | cityd==6770 | cityd==7120 

