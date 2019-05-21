******************
***** INCOME *****
******************

* This do file first calculates income midpoints, uses the formula in Hout 2004 for open-eded top-incomes
* and then converts them to PPP values.

* Mid-points for 2002-2006 (in Euros), they can be found in ESS Source Showcards

gen income=.
replace income=900    	if hinctnt==1  // range Less than €1800, mid-point €900
replace income=2700   	if hinctnt==2  // range €1800 to under €3600, mid-point €2700
replace income=4800   	if hinctnt==3  // range €3600 to under €6000, mid-point €4800
replace income=9000   	if hinctnt==4  // range €6000 to under €12000, mid-point €9000
replace income=15000  	if hinctnt==5  // range €12000 to under €18000, mid-point €15000
replace income=21000  	if hinctnt==6  // range €18000 to under €24000, mid-point €21000
replace income=27000  	if hinctnt==7  // range €24000 to under €30000, mid-point €27000
replace income=33000  	if hinctnt==8  // range €30000 to under €36000, mid-point €33000
replace income=48000  	if hinctnt==9  // range €36000 to under €60000, mid-point €48000
replace income=75000  	if hinctnt==10 // range €60000 to under €90000, mid-point €75000
replace income=105000 	if hinctnt==11 // range €90000 to under €120000, mid-point €105000

* ESS round 4
* See ESS4 Appendix A.5

replace income=2500 	if hinctnta==1&cntry=="BE"&essround==4 // range less than €5000mid-point €2500
replace income=7500 	if hinctnta==2&cntry=="BE"&essround==4 // range €5000 to under €10000 mid-point €7500
replace income=11000 	if hinctnta==3&cntry=="BE"&essround==4 // range €10000 to under €12000 mid-point €11000
replace income=13000 	if hinctnta==4&cntry=="BE"&essround==4 // range €12000 to under €14000 mid-point €13000
replace income=15000 	if hinctnta==5&cntry=="BE"&essround==4 // range €14000 to under €16000 mid-point €15000
replace income=17000 	if hinctnta==6&cntry=="BE"&essround==4 // range €16000 to under €18000 mid-point €17000
replace income=19500 	if hinctnta==7&cntry=="BE"&essround==4 // range €18000 to under €21000 mid-point €19500
replace income=23500 	if hinctnta==8&cntry=="BE"&essround==4 // range €21000 to under €26000 mid-point €23500
replace income=30500 	if hinctnta==9&cntry=="BE"&essround==4 // range €26000 to under €35000 mid-point €30500
replace	income=55000	if hinctnta==1&cntry=="DK"&essround==4 // range	0		to	under	110000	mid-point	55000
replace	income=129000	if hinctnta==2&cntry=="DK"&essround==4 // range	110000	to	under	148000	mid-point	129000
replace	income=167000	if hinctnta==3&cntry=="DK"&essround==4 // range	148000	to	under	186000	mid-point	167000
replace	income=206000	if hinctnta==4&cntry=="DK"&essround==4 // range	186000	to	under	226000	mid-point	206000
replace	income=251500	if hinctnta==5&cntry=="DK"&essround==4 // range	226000	to	under	277000	mid-point	251500
replace	income=307500	if hinctnta==6&cntry=="DK"&essround==4 // range	277000	to	under	338000	mid-point	307500
replace	income=365500	if hinctnta==7&cntry=="DK"&essround==4 // range	338000	to	under	393000	mid-point	365500
replace	income=421500	if hinctnta==8&cntry=="DK"&essround==4 // range	393000	to	under	450000	mid-point	421500
replace	income=492000	if hinctnta==9&cntry=="DK"&essround==4 // range	450000	to	under	534000	mid-point	492000
replace income=5400 	if hinctnta==1&cntry=="FI"&essround==4 // range less than €10800mid-point €5400
replace income=12600 	if hinctnta==2&cntry=="FI"&essround==4 // range €10800 to under €14400 mid-point €12600
replace income=16200 	if hinctnta==3&cntry=="FI"&essround==4 // range €14400 to under €18000 mid-point €16200
replace income=19800 	if hinctnta==4&cntry=="FI"&essround==4 // range €18000 to under €21600 mid-point €19800
replace income=24000 	if hinctnta==5&cntry=="FI"&essround==4 // range €21600 to under €26400 mid-point €24000
replace income=28800 	if hinctnta==6&cntry=="FI"&essround==4 // range €26400 to under €31200 mid-point €28800
replace income=34200 	if hinctnta==7&cntry=="FI"&essround==4 // range €31200 to under €37200 mid-point €34200
replace income=40800 	if hinctnta==8&cntry=="FI"&essround==4 // range €37200 to under €44400 mid-point €40800
replace income=49800 	if hinctnta==9&cntry=="FI"&essround==4 // range €44400 to under €55200 mid-point €49800
replace income=5700 	if hinctnta==1&cntry=="FR"&essround==4 // range less than €11400mid-point €5700
replace income=12900 	if hinctnta==2&cntry=="FR"&essround==4 // range €11400 to under €14400 mid-point €12900
replace income=16200 	if hinctnta==3&cntry=="FR"&essround==4 // range €14400 to under €18000 mid-point €16200
replace income=19500 	if hinctnta==4&cntry=="FR"&essround==4 // range €18000 to under €21000 mid-point €19500
replace income=22500 	if hinctnta==5&cntry=="FR"&essround==4 // range €21000 to under €24000 mid-point €22500
replace income=26400 	if hinctnta==6&cntry=="FR"&essround==4 // range €24000 to under €28800 mid-point €26400
replace income=31200 	if hinctnta==7&cntry=="FR"&essround==4 // range €28800 to under €33600 mid-point €31200
replace income=36600 	if hinctnta==8&cntry=="FR"&essround==4 // range €33600 to under €39600 mid-point €36600
replace income=44400 	if hinctnta==9&cntry=="FR"&essround==4 // range €39600 to under €49200 mid-point €44400
replace income=6600 	if hinctnta==1&cntry=="DE"&essround==4 // range less than €13200mid-point €6600
replace income=15350 	if hinctnta==2&cntry=="DE"&essround==4 // range €13200 to under €17500 mid-point €15350
replace income=19800 	if hinctnta==3&cntry=="DE"&essround==4 // range €17500 to under €22100 mid-point €19800
replace income=24550 	if hinctnta==4&cntry=="DE"&essround==4 // range €22100 to under €27000 mid-point €24550
replace income=29750 	if hinctnta==5&cntry=="DE"&essround==4 // range €27000 to under €32500 mid-point €29750
replace income=35400 	if hinctnta==6&cntry=="DE"&essround==4 // range €32500 to under €38300 mid-point €35400
replace income=41750 	if hinctnta==7&cntry=="DE"&essround==4 // range €38300 to under €45200 mid-point €41750
replace income=49900 	if hinctnta==8&cntry=="DE"&essround==4 // range €45200 to under €54600 mid-point €49900
replace income=62500 	if hinctnta==9&cntry=="DE"&essround==4 // range €54600 to under €70400 mid-point €62500
replace	income=62500	if hinctnta==1&cntry=="NO"&essround==4 // range	0	to	under	125000	mid-point	62500
replace	income=147500	if hinctnta==2&cntry=="NO"&essround==4 // range	125000	to	under	170000	mid-point	147500
replace	income=195000	if hinctnta==3&cntry=="NO"&essround==4 // range	170000	to	under	220000	mid-point	195000
replace	income=245000	if hinctnta==4&cntry=="NO"&essround==4 // range	220000	to	under	270000	mid-point	245000
replace	income=297500	if hinctnta==5&cntry=="NO"&essround==4 // range	270000	to	under	325000	mid-point	297500
replace	income=362500	if hinctnta==6&cntry=="NO"&essround==4 // range	325000	to	under	400000	mid-point	362500
replace	income=437500	if hinctnta==7&cntry=="NO"&essround==4 // range	400000	to	under	475000	mid-point	437500
replace	income=512500	if hinctnta==8&cntry=="NO"&essround==4 // range	475000	to	under	550000	mid-point	512500
replace	income=610000	if hinctnta==9&cntry=="NO"&essround==4 // range	550000	to	under	670000	mid-point	610000
replace income=2500 	if hinctnta==1&cntry=="PT"&essround==4 // range less than €5000mid-point €2500
replace income=6000 	if hinctnta==2&cntry=="PT"&essround==4 // range €5000 to under €7000 mid-point €6000
replace income=8000 	if hinctnta==3&cntry=="PT"&essround==4 // range €7000 to under €9000 mid-point €8000
replace income=10000 	if hinctnta==4&cntry=="PT"&essround==4 // range €9000 to under €11000 mid-point €10000
replace income=12400 	if hinctnta==5&cntry=="PT"&essround==4 // range €11000 to under €13800 mid-point €12400
replace income=14900 	if hinctnta==6&cntry=="PT"&essround==4 // range €13800 to under €16000 mid-point €14900
replace income=17750 	if hinctnta==7&cntry=="PT"&essround==4 // range €16000 to under €19500 mid-point €17750
replace income=22000 	if hinctnta==8&cntry=="PT"&essround==4 // range €19500 to under €24500 mid-point €22000
replace income=29750 	if hinctnta==9&cntry=="PT"&essround==4 // range €24500 to under €35000 mid-point €29750
replace income=4000 	if hinctnta==1&cntry=="ES"&essround==4 // range less than €8000mid-point €4000
replace income=9500 	if hinctnta==2&cntry=="ES"&essround==4 // range €8000 to under €11000 mid-point €9500
replace income=12500 	if hinctnta==3&cntry=="ES"&essround==4 // range €11000 to under €14000 mid-point €12500
replace income=15500 	if hinctnta==4&cntry=="ES"&essround==4 // range €14000 to under €17000 mid-point €15500
replace income=18500 	if hinctnta==5&cntry=="ES"&essround==4 // range €17000 to under €20000 mid-point €18500
replace income=21500 	if hinctnta==6&cntry=="ES"&essround==4 // range €20000 to under €23000 mid-point €21500
replace income=25000 	if hinctnta==7&cntry=="ES"&essround==4 // range €23000 to under €27000 mid-point €25000
replace income=30000 	if hinctnta==8&cntry=="ES"&essround==4 // range €27000 to under €33000 mid-point €30000
replace income=37000 	if hinctnta==9&cntry=="ES"&essround==4 // range €33000 to under €41000 mid-point €37000
replace	income=15750	if hinctnta==1&cntry=="CH"&essround==4 // range	0	to	under	31500	mid-point	15750
replace	income=38250	if hinctnta==2&cntry=="CH"&essround==4 // range	31500	to	under	45000	mid-point	38250
replace	income=50250	if hinctnta==3&cntry=="CH"&essround==4 // range	45000	to	under	55500	mid-point	50250
replace	income=60250	if hinctnta==4&cntry=="CH"&essround==4 // range	55500	to	under	65000	mid-point	60250
replace	income=70250	if hinctnta==5&cntry=="CH"&essround==4 // range	65000	to	under	75500	mid-point	70250
replace	income=81500	if hinctnta==6&cntry=="CH"&essround==4 // range	75500	to	under	87500	mid-point	81500
replace	income=94750	if hinctnta==7&cntry=="CH"&essround==4 // range	87500	to	under	102000	mid-point	94750
replace	income=112000	if hinctnta==8&cntry=="CH"&essround==4 // range	102000	to	under	122000	mid-point	112000
replace	income=139250	if hinctnta==9&cntry=="CH"&essround==4 // range	122000	to	under	156500	mid-point	139250
replace	income=4275		if hinctnta==1&cntry=="GB"&essround==4 // range	0	to	under	8550	mid-point	4275
replace	income=10010	if hinctnta==2&cntry=="GB"&essround==4 // range	8550	to	under	11470	mid-point	10010
replace	income=12955	if hinctnta==3&cntry=="GB"&essround==4 // range	11470	to	under	14440	mid-point	12955
replace	income=15900	if hinctnta==4&cntry=="GB"&essround==4 // range	14440	to	under	17360	mid-point	15900
replace	income=19240	if hinctnta==5&cntry=="GB"&essround==4 // range	17360	to	under	21120	mid-point	19240
replace	income=23385	if hinctnta==6&cntry=="GB"&essround==4 // range	21120	to	under	25650	mid-point	23385
replace	income=28260	if hinctnta==7&cntry=="GB"&essround==4 // range	25650	to	under	30870	mid-point	28260
replace	income=40490	if hinctnta==8&cntry=="GB"&essround==4 // range	30870	to	under	50110	mid-point	40490
replace	income=52015	if hinctnta==9&cntry=="GB"&essround==4 // range	50110	to	under	53920	mid-point	52015
replace	income=48600	if hinctnta==1&cntry=="SE"&essround==4 // range	0	to	under	97200	mid-point	48600
replace	income=109800	if hinctnta==2&cntry=="SE"&essround==4 // range	97200	to	under	122400	mid-point	109800
replace	income=135600	if hinctnta==3&cntry=="SE"&essround==4 // range	122400	to	under	148800	mid-point	135600
replace	income=164400	if hinctnta==4&cntry=="SE"&essround==4 // range	148800	to	under	180000	mid-point	164400
replace	income=196200	if hinctnta==5&cntry=="SE"&essround==4 // range	180000	to	under	212400	mid-point	196200
replace	income=232200	if hinctnta==6&cntry=="SE"&essround==4 // range	212400	to	under	252000	mid-point	232200
replace	income=283800	if hinctnta==7&cntry=="SE"&essround==4 // range	252000	to	under	315600	mid-point	283800
replace	income=356400	if hinctnta==8&cntry=="SE"&essround==4 // range	315600	to	under	397200	mid-point	356400
replace	income=445800	if hinctnta==9&cntry=="SE"&essround==4 // range	397200	to	under	494400	mid-point	445800
replace income=5850 	if hinctnta==1&cntry=="NL"&essround==4 // range €0 or more mid-point €5850
replace income=13350 	if hinctnta==2&cntry=="NL"&essround==4 // range €11700 or more mid-point €13350
replace income=16600 	if hinctnta==3&cntry=="NL"&essround==4 // range €15000 or more mid-point €16600
replace income=19850 	if hinctnta==4&cntry=="NL"&essround==4 // range €18200 or more mid-point €19850
replace income=23400 	if hinctnta==5&cntry=="NL"&essround==4 // range €21500 or more mid-point €23400
replace income=27400 	if hinctnta==6&cntry=="NL"&essround==4 // range €25300 or more mid-point €27400
replace income=31850 	if hinctnta==7&cntry=="NL"&essround==4 // range €29500 or more mid-point €31850
replace income=37200 	if hinctnta==8&cntry=="NL"&essround==4 // range €34200 or more mid-point €37200
replace income=45250 	if hinctnta==9&cntry=="NL"&essround==4 // range €40200 or more mid-point €45250
replace	income=3000		if hinctnta==1&cntry=="GR"&essround==4 // range	0	to	under	6000	mid-point	3000
replace	income=7200		if hinctnta==2&cntry=="GR"&essround==4 // range	6000	to	under	8400	mid-point	7200
replace	income=9600		if hinctnta==3&cntry=="GR"&essround==4 // range	8400	to	under	10800	mid-point	9600
replace	income=11880	if hinctnta==4&cntry=="GR"&essround==4 // range	10800	to	under	12960	mid-point	11880
replace	income=14280	if hinctnta==5&cntry=="GR"&essround==4 // range	12960	to	under	15600	mid-point	14280
replace	income=17160	if hinctnta==6&cntry=="GR"&essround==4 // range	15600	to	under	18720	mid-point	17160
replace	income=20760	if hinctnta==7&cntry=="GR"&essround==4 // range	18720	to	under	22800	mid-point	20760
replace	income=25200	if hinctnta==8&cntry=="GR"&essround==4 // range	22800	to	under	27600	mid-point	25200
replace	income=31800	if hinctnta==9&cntry=="GR"&essround==4 // range	27600	to	under	36000	mid-point	31800


* ESS round 5
* See ESS5 Appendix A.2

replace	income=	5520	if hinctnta==1&cntry=="BE"&essround==5	//	range	0		to	under	11040	mid-point	5520
replace	income=	12600	if hinctnta==2&cntry=="BE"&essround==5	//	range	11040	to	under	14160	mid-point	12600
replace	income=	15900	if hinctnta==3&cntry=="BE"&essround==5	//	range	14160	to	under	17640	mid-point	15900
replace	income=	19500	if hinctnta==4&cntry=="BE"&essround==5	//	range	17640	to	under	21360	mid-point	19500
replace	income=	23460	if hinctnta==5&cntry=="BE"&essround==5	//	range	21360	to	under	25560	mid-point	23460
replace	income=	28080	if hinctnta==6&cntry=="BE"&essround==5	//	range	25560	to	under	30600	mid-point	28080
replace	income=	34020	if hinctnta==7&cntry=="BE"&essround==5	//	range	30600	to	under	37440	mid-point	34020
replace	income=	41160	if hinctnta==8&cntry=="BE"&essround==5	//	range	37440	to	under	44880	mid-point	41160
replace	income=	50820	if hinctnta==9&cntry=="BE"&essround==5	//	range	44880	to	under	56760	mid-point	50820
replace	income=	60500	if hinctnta==1&cntry=="DK"&essround==5	//	range	0		to	under	121000	mid-point	60500
replace	income=	140500	if hinctnta==2&cntry=="DK"&essround==5	//	range	121000	to	under	160000	mid-point	140500
replace	income=	179500	if hinctnta==3&cntry=="DK"&essround==5	//	range	160000	to	under	199000	mid-point	179500
replace	income=	220500	if hinctnta==4&cntry=="DK"&essround==5	//	range	199000	to	under	242000	mid-point	220500
replace	income=	270000	if hinctnta==5&cntry=="DK"&essround==5	//	range	242000	to	under	298000	mid-point	270000
replace	income=	331000	if hinctnta==6&cntry=="DK"&essround==5	//	range	298000	to	under	364000	mid-point	331000
replace	income=	394000	if hinctnta==7&cntry=="DK"&essround==5	//	range	364000	to	under	424000	mid-point	394000
replace	income=	455000	if hinctnta==8&cntry=="DK"&essround==5	//	range	424000	to	under	486000	mid-point	455000
replace	income=	532000	if hinctnta==9&cntry=="DK"&essround==5	//	range	486000	to	under	578000	mid-point	532000
replace	income=	5754	if hinctnta==1&cntry=="FI"&essround==5	//	range	0		to	under	11508	mid-point	5754
replace	income=	13140	if hinctnta==2&cntry=="FI"&essround==5	//	range	11508	to	under	14772	mid-point	13140
replace	income=	17076	if hinctnta==3&cntry=="FI"&essround==5	//	range	14772	to	under	19380	mid-point	17076
replace	income=	21510	if hinctnta==4&cntry=="FI"&essround==5	//	range	19380	to	under	23640	mid-point	21510
replace	income=	26040	if hinctnta==5&cntry=="FI"&essround==5	//	range	23640	to	under	28440	mid-point	26040
replace	income=	31536	if hinctnta==6&cntry=="FI"&essround==5	//	range	28440	to	under	34632	mid-point	31536
replace	income=	38220	if hinctnta==7&cntry=="FI"&essround==5	//	range	34632	to	under	41808	mid-point	38220
replace	income=	45858	if hinctnta==8&cntry=="FI"&essround==5	//	range	41808	to	under	49908	mid-point	45858
replace	income=	55806	if hinctnta==9&cntry=="FI"&essround==5	//	range	49908	to	under	61704	mid-point	55806
replace	income=	6600	if hinctnta==1&cntry=="FR"&essround==5	//	range	0		to	under	13200	mid-point	6600
replace	income=	15000	if hinctnta==2&cntry=="FR"&essround==5	//	range	13200	to	under	16800	mid-point	15000
replace	income=	18900	if hinctnta==3&cntry=="FR"&essround==5	//	range	16800	to	under	21000	mid-point	18900
replace	income=	23100	if hinctnta==4&cntry=="FR"&essround==5	//	range	21000	to	under	25200	mid-point	23100
replace	income=	27600	if hinctnta==5&cntry=="FR"&essround==5	//	range	25200	to	under	30000	mid-point	27600
replace	income=	32400	if hinctnta==6&cntry=="FR"&essround==5	//	range	30000	to	under	34800	mid-point	32400
replace	income=	37200	if hinctnta==7&cntry=="FR"&essround==5	//	range	34800	to	under	39600	mid-point	37200
replace	income=	43800	if hinctnta==8&cntry=="FR"&essround==5	//	range	39600	to	under	48000	mid-point	43800
replace	income=	54600	if hinctnta==9&cntry=="FR"&essround==5	//	range	48000	to	under	61200	mid-point	54600
replace	income=	5670	if hinctnta==1&cntry=="DE"&essround==5	//	range	0		to	under	11340	mid-point	5670
replace	income=	13380	if hinctnta==2&cntry=="DE"&essround==5	//	range	11340	to	under	15420	mid-point	13380
replace	income=	17185	if hinctnta==3&cntry=="DE"&essround==5	//	range	15420	to	under	18950	mid-point	17185
replace	income=	20790	if hinctnta==4&cntry=="DE"&essround==5	//	range	18950	to	under	22630	mid-point	20790
replace	income=	24565	if hinctnta==5&cntry=="DE"&essround==5	//	range	22630	to	under	26500	mid-point	24565
replace	income=	28600	if hinctnta==6&cntry=="DE"&essround==5	//	range	26500	to	under	30700	mid-point	28600
replace	income=	33205	if hinctnta==7&cntry=="DE"&essround==5	//	range	30700	to	under	35710	mid-point	33205
replace	income=	39045	if hinctnta==8&cntry=="DE"&essround==5	//	range	35710	to	under	42380	mid-point	39045
replace	income=	48075	if hinctnta==9&cntry=="DE"&essround==5	//	range	42380	to	under	53770	mid-point	48075
replace	income=	102500	if hinctnta==1&cntry=="NO"&essround==5	//	range	0		to	under	205000	mid-point	102500
replace	income=	250000	if hinctnta==2&cntry=="NO"&essround==5	//	range	205000	to	under	295000	mid-point	250000
replace	income=	332500	if hinctnta==3&cntry=="NO"&essround==5	//	range	295000	to	under	370000	mid-point	332500
replace	income=	410000	if hinctnta==4&cntry=="NO"&essround==5	//	range	370000	to	under	450000	mid-point	410000
replace	income=	490000	if hinctnta==5&cntry=="NO"&essround==5	//	range	450000	to	under	530000	mid-point	490000
replace	income=	565000	if hinctnta==6&cntry=="NO"&essround==5	//	range	530000	to	under	600000	mid-point	565000
replace	income=	637500	if hinctnta==7&cntry=="NO"&essround==5	//	range	600000	to	under	675000	mid-point	637500
replace	income=	725000	if hinctnta==8&cntry=="NO"&essround==5	//	range	675000	to	under	775000	mid-point	725000
replace	income=	855000	if hinctnta==9&cntry=="NO"&essround==5	//	range	775000	to	under	935000	mid-point	855000
replace	income=	4000	if hinctnta==1&cntry=="ES"&essround==5	//	range	0		to	under	8000	mid-point	4000
replace	income=	9500	if hinctnta==2&cntry=="ES"&essround==5	//	range	8000	to	under	11000	mid-point	9500
replace	income=	12500	if hinctnta==3&cntry=="ES"&essround==5	//	range	11000	to	under	14000	mid-point	12500
replace	income=	15500	if hinctnta==4&cntry=="ES"&essround==5	//	range	14000	to	under	17000	mid-point	15500
replace	income=	18500	if hinctnta==5&cntry=="ES"&essround==5	//	range	17000	to	under	20000	mid-point	18500
replace	income=	21500	if hinctnta==6&cntry=="ES"&essround==5	//	range	20000	to	under	23000	mid-point	21500
replace	income=	25000	if hinctnta==7&cntry=="ES"&essround==5	//	range	23000	to	under	27000	mid-point	25000
replace	income=	30000	if hinctnta==8&cntry=="ES"&essround==5	//	range	27000	to	under	33000	mid-point	30000
replace	income=	37000	if hinctnta==9&cntry=="ES"&essround==5	//	range	33000	to	under	41000	mid-point	37000
replace	income=	16250	if hinctnta==1&cntry=="CH"&essround==5	//	range	0		to	under	32500	mid-point	16250
replace	income=	39000	if hinctnta==2&cntry=="CH"&essround==5	//	range	32500	to	under	45500	mid-point	39000
replace	income=	51000	if hinctnta==3&cntry=="CH"&essround==5	//	range	45500	to	under	56500	mid-point	51000
replace	income=	62250	if hinctnta==4&cntry=="CH"&essround==5	//	range	56500	to	under	68000	mid-point	62250
replace	income=	73750	if hinctnta==5&cntry=="CH"&essround==5	//	range	68000	to	under	79500	mid-point	73750
replace	income=	85500	if hinctnta==6&cntry=="CH"&essround==5	//	range	79500	to	under	91500	mid-point	85500
replace	income=	98750	if hinctnta==7&cntry=="CH"&essround==5	//	range	91500	to	under	106000	mid-point	98750
replace	income=	116750	if hinctnta==8&cntry=="CH"&essround==5	//	range	106000	to	under	127500	mid-point	116750
replace	income=	146500	if hinctnta==9&cntry=="CH"&essround==5	//	range	127500	to	under	165500	mid-point	146500
replace	income=	4695	if hinctnta==1&cntry=="GB"&essround==5	//	range	0		to	under	9390	mid-point	4695
replace	income=	10950	if hinctnta==2&cntry=="GB"&essround==5	//	range	9390	to	under	12510	mid-point	10950
replace	income=	14050	if hinctnta==3&cntry=="GB"&essround==5	//	range	12510	to	under	15590	mid-point	14050
replace	income=	17235	if hinctnta==4&cntry=="GB"&essround==5	//	range	15590	to	under	18880	mid-point	17235
replace	income=	20910	if hinctnta==5&cntry=="GB"&essround==5	//	range	18880	to	under	22940	mid-point	20910
replace	income=	25235	if hinctnta==6&cntry=="GB"&essround==5	//	range	22940	to	under	27530	mid-point	25235
replace	income=	30295	if hinctnta==7&cntry=="GB"&essround==5	//	range	27530	to	under	33060	mid-point	30295
replace	income=	37075	if hinctnta==8&cntry=="GB"&essround==5	//	range	33060	to	under	41090	mid-point	37075
replace	income=	47505	if hinctnta==9&cntry=="GB"&essround==5	//	range	41090	to	under	53920	mid-point	47505
replace	income=	69000	if hinctnta==1&cntry=="SE"&essround==5	//	range	0		to	under	138000	mid-point	69000
replace	income=	153000	if hinctnta==2&cntry=="SE"&essround==5	//	range	138000	to	under	168000	mid-point	153000
replace	income=	186000	if hinctnta==3&cntry=="SE"&essround==5	//	range	168000	to	under	204000	mid-point	186000
replace	income=	222000	if hinctnta==4&cntry=="SE"&essround==5	//	range	204000	to	under	240000	mid-point	222000
replace	income=	264000	if hinctnta==5&cntry=="SE"&essround==5	//	range	240000	to	under	288000	mid-point	264000
replace	income=	312000	if hinctnta==6&cntry=="SE"&essround==5	//	range	288000	to	under	336000	mid-point	312000
replace	income=	360000	if hinctnta==7&cntry=="SE"&essround==5	//	range	336000	to	under	384000	mid-point	360000
replace	income=	408000	if hinctnta==8&cntry=="SE"&essround==5	//	range	384000	to	under	432000	mid-point	408000
replace	income=	480000	if hinctnta==9&cntry=="SE"&essround==5	//	range	432000	to	under	528000	mid-point	480000
replace	income=	6600	if hinctnta==1&cntry=="NL"&essround==5	//	range	0		to	under	13200	mid-point	6600
replace	income=	15100	if hinctnta==2&cntry=="NL"&essround==5	//	range	13200	to	under	17000	mid-point	15100
replace	income=	18750	if hinctnta==3&cntry=="NL"&essround==5	//	range	17000	to	under	20500	mid-point	18750
replace	income=	22350	if hinctnta==4&cntry=="NL"&essround==5	//	range	20500	to	under	24200	mid-point	22350
replace	income=	26400	if hinctnta==5&cntry=="NL"&essround==5	//	range	24200	to	under	28600	mid-point	26400
replace	income=	31050	if hinctnta==6&cntry=="NL"&essround==5	//	range	28600	to	under	33500	mid-point	31050
replace	income=	36300	if hinctnta==7&cntry=="NL"&essround==5	//	range	33500	to	under	39100	mid-point	36300
replace	income=	42750	if hinctnta==8&cntry=="NL"&essround==5	//	range	39100	to	under	46400	mid-point	42750
replace	income=	49600	if hinctnta==9&cntry=="NL"&essround==5	//	range	46400	to	under	52800	mid-point	49600
replace	income=	3450	if hinctnta==1&cntry=="GR"&essround==5	//	range	0		to	under	6900	mid-point	3450
replace	income=	8100	if hinctnta==2&cntry=="GR"&essround==5	//	range	6900	to	under	9300	mid-point	8100
replace	income=	10530	if hinctnta==3&cntry=="GR"&essround==5	//	range	9300	to	under	11760	mid-point	10530
replace	income=	13020	if hinctnta==4&cntry=="GR"&essround==5	//	range	11760	to	under	14280	mid-point	13020
replace	income=	15690	if hinctnta==5&cntry=="GR"&essround==5	//	range	14280	to	under	17100	mid-point	15690
replace	income=	18750	if hinctnta==6&cntry=="GR"&essround==5	//	range	17100	to	under	20400	mid-point	18750
replace	income=	22440	if hinctnta==7&cntry=="GR"&essround==5	//	range	20400	to	under	24480	mid-point	22440
replace	income=	27240	if hinctnta==8&cntry=="GR"&essround==5	//	range	24480	to	under	30000	mid-point	27240
replace	income=	34380	if hinctnta==9&cntry=="GR"&essround==5	//	range	30000	to	under	38760	mid-point	34380
replace	income=	7086.5	if hinctnta==1&cntry=="IE"&essround==5	//	range	0		to	under	14173	mid-point	7086.5
replace	income=	17474	if hinctnta==2&cntry=="IE"&essround==5	//	range	14173	to	under	20775	mid-point	17474
replace	income=	23176	if hinctnta==3&cntry=="IE"&essround==5	//	range	20775	to	under	25577	mid-point	23176
replace	income=	29177	if hinctnta==4&cntry=="IE"&essround==5	//	range	25577	to	under	32777	mid-point	29177
replace	income=	35475.5	if hinctnta==5&cntry=="IE"&essround==5	//	range	32777	to	under	38174	mid-point	35475.5
replace	income=	41905	if hinctnta==6&cntry=="IE"&essround==5	//	range	38174	to	under	45636	mid-point	41905
replace	income=	50243.5	if hinctnta==7&cntry=="IE"&essround==5	//	range	45636	to	under	54851	mid-point	50243.5
replace	income=	59901	if hinctnta==8&cntry=="IE"&essround==5	//	range	54851	to	under	64951	mid-point	59901
replace	income=	75238.5	if hinctnta==9&cntry=="IE"&essround==5	//	range	64951	to	under	85526	mid-point	75238.5




* ESS round 6
* See ESS6 Appendix A.2

replace income= 6059.5 		if hinctnta==1 & cntry=="BE"&essround==6 // range 0 		to 12119 	midpoint 6059.5
replace income= 13724.5 	if hinctnta==2 & cntry=="BE"&essround==6 // range 12120 	to 15329 	midpoint 13724.5
replace income= 17104.5 	if hinctnta==3 & cntry=="BE"&essround==6 // range 15330 	to 18879 	midpoint 17104.5
replace income= 20799.5 	if hinctnta==4 & cntry=="BE"&essround==6 // range 18880 	to 22719 	midpoint 20799.5
replace income= 25009.5 	if hinctnta==5 & cntry=="BE"&essround==6 // range 22720 	to 27299 	midpoint 25009.5
replace income= 30364.5 	if hinctnta==6 & cntry=="BE"&essround==6 // range 27300 	to 33429 	midpoint 30364.5
replace income= 36839.5 	if hinctnta==7 & cntry=="BE"&essround==6 // range 33430 	to 40249 	midpoint 36839.5
replace income= 44124.5 	if hinctnta==8 & cntry=="BE"&essround==6 // range 40250 	to 47999 	midpoint 44124.5
replace income= 54114.5 	if hinctnta==9 & cntry=="BE"&essround==6 // range 48000 	to 60229 	midpoint 54114.5
replace income= 66000 		if hinctnta==1 & cntry=="DK"&essround==6 // range 0 		to 132000 	midpoint 66000
replace income= 153000 		if hinctnta==2 & cntry=="DK"&essround==6 // range 132001 	to 173999 	midpoint 153000
replace income= 195499.5	if hinctnta==3 & cntry=="DK"&essround==6 // range 174000 	to 216999 	midpoint 195499.5
replace income= 240499.5 	if hinctnta==4 & cntry=="DK"&essround==6 // range 217000 	to 263999 	midpoint 240499.5
replace income= 294499.5 	if hinctnta==5 & cntry=="DK"&essround==6 // range 264000 	to 324999 	midpoint 294499.5
replace income= 360499.5	if hinctnta==6 & cntry=="DK"&essround==6 // range 325000 	to 395999 	midpoint 360499.5
replace income= 428999.5	if hinctnta==7 & cntry=="DK"&essround==6 // range 396000 	to 461999 	midpoint 428999.5
replace income= 495999.5 	if hinctnta==8 & cntry=="DK"&essround==6 // range 462000 	to 529999 	midpoint 495999.5
replace income= 579999.5 	if hinctnta==9 & cntry=="DK"&essround==6 // range 530000 	to 629999 	midpoint 579999.5
replace income= 6054 		if hinctnta==1 & cntry=="FI"&essround==6 // range 0 		to 12108 	midpoint 6054
replace income= 13806.5		if hinctnta==2 & cntry=="FI"&essround==6 // range 12109 	to 15504 	midpoint 13806.5
replace income= 17916.5		if hinctnta==3 & cntry=="FI"&essround==6 // range 15505 	to 20328 	midpoint 17916.5
replace income= 22584.5 	if hinctnta==4 & cntry=="FI"&essround==6 // range 20329 	to 24840 	midpoint 22584.5
replace income= 27294.5 	if hinctnta==5 & cntry=="FI"&essround==6 // range 24841 	to 29748 	midpoint 27294.5
replace income= 32790.5 	if hinctnta==6 & cntry=="FI"&essround==6 // range 29749 	to 35832 	midpoint 32790.5
replace income= 39618.5 	if hinctnta==7 & cntry=="FI"&essround==6 // range 35833 	to 43404 	midpoint 39618.5
replace income= 47568.5 	if hinctnta==8 & cntry=="FI"&essround==6 // range 43405 	to 51732 	midpoint 47568.5
replace income= 58032.5 	if hinctnta==9 & cntry=="FI"&essround==6 // range 51733 	to 64332 	midpoint 58032.5
replace income= 6600 		if hinctnta==1 & cntry=="FR"&essround==6 // range 0 		to 13200 	midpoint 6600
replace income= 15600.5 	if hinctnta==2 & cntry=="FR"&essround==6 // range 13201 	to 18000 	midpoint 15600.5
replace income= 19800.5 	if hinctnta==3 & cntry=="FR"&essround==6 // range 18001 	to 21600 	midpoint 19800.5
replace income= 23400.5 	if hinctnta==4 & cntry=="FR"&essround==6 // range 21601 	to 25200 	midpoint 23400.5
replace income= 27600.5 	if hinctnta==5 & cntry=="FR"&essround==6 // range 25201 	to 30000 	midpoint 27600.5
replace income= 33000.5 	if hinctnta==6 & cntry=="FR"&essround==6 // range 30001 	to 36000 	midpoint 33000.5
replace income= 39000.5 	if hinctnta==7 & cntry=="FR"&essround==6 // range 36001 	to 42000 	midpoint 39000.5
replace income= 45600.5 	if hinctnta==8 & cntry=="FR"&essround==6 // range 42001 	to 49200 	midpoint 45600.5
replace income= 56400.5 	if hinctnta==9 & cntry=="FR"&essround==6 // range 49201 	to 63600 	midpoint 56400.5
replace income= 5880 		if hinctnta==1 & cntry=="DE"&essround==6 // range 0 		to 11760 	midpoint 5880
replace income= 13980.5 	if hinctnta==2 & cntry=="DE"&essround==6 // range 11761 	to 16200 	midpoint 13980.5
replace income= 18060.5 	if hinctnta==3 & cntry=="DE"&essround==6 // range 16201 	to 19920 	midpoint 18060.5
replace income= 21900.5 	if hinctnta==4 & cntry=="DE"&essround==6 // range 19921 	to 23880 	midpoint 21900.5
replace income= 25980.5 	if hinctnta==5 & cntry=="DE"&essround==6 // range 23881 	to 28080 	midpoint 25980.5
replace income= 30420.5 	if hinctnta==6 & cntry=="DE"&essround==6 // range 28081 	to 32760 	midpoint 30420.5
replace income= 35580.5 	if hinctnta==7 & cntry=="DE"&essround==6 // range 32761 	to 38400 	midpoint 35580.5
replace income= 42120.5 	if hinctnta==8 & cntry=="DE"&essround==6 // range 38401 	to 45840 	midpoint 42120.5
replace income= 51960.5 	if hinctnta==9 & cntry=="DE"&essround==6 // range 45841 	to 58080 	midpoint 51960.5
replace income= 108000 		if hinctnta==1 & cntry=="NO"&essround==6 // range 0 		to 216000 	midpoint 108000
replace income= 263500.5 	if hinctnta==2 & cntry=="NO"&essround==6 // range 216001 	to 311000 	midpoint 263500.5
replace income= 350500.5 	if hinctnta==3 & cntry=="NO"&essround==6 // range 311001 	to 390000 	midpoint 350500.5
replace income= 430000.5 	if hinctnta==4 & cntry=="NO"&essround==6 // range 390001 	to 470000 	midpoint 430000.5
replace income= 510000.5 	if hinctnta==5 & cntry=="NO"&essround==6 // range 470001 	to 550000 	midpoint 510000.5
replace income= 588000.5 	if hinctnta==6 & cntry=="NO"&essround==6 // range 550001 	to 626000 	midpoint 588000.5
replace income= 666000.5 	if hinctnta==7 & cntry=="NO"&essround==6 // range 626001 	to 706000 	midpoint 666000.5
replace income= 756500.5 	if hinctnta==8 & cntry=="NO"&essround==6 // range 706001 	to 807000 	midpoint 756500.5
replace income= 890000.5 	if hinctnta==9 & cntry=="NO"&essround==6 // range 807001 	to 973000 	midpoint 890000.5
replace income= 4560 		if hinctnta==1 & cntry=="ES"&essround==6 // range 0 		to 9120 	midpoint 4560
replace income= 11520.5 	if hinctnta==2 & cntry=="ES"&essround==6 // range 9121 		to 13920 	midpoint 11520.5
replace income= 14520.5 	if hinctnta==3 & cntry=="ES"&essround==6 // range 13921 	to 15120 	midpoint 14520.5
replace income= 17400.5 	if hinctnta==4 & cntry=="ES"&essround==6 // range 15121 	to 19680 	midpoint 17400.5
replace income= 20340.5 	if hinctnta==5 & cntry=="ES"&essround==6 // range 19681 	to 21000 	midpoint 20340.5
replace income= 23340.5 	if hinctnta==6 & cntry=="ES"&essround==6 // range 21001 	to 25680 	midpoint 23340.5
replace income= 27240.5 	if hinctnta==7 & cntry=="ES"&essround==6 // range 25681 	to 28800 	midpoint 27240.5
replace income= 30960.5 	if hinctnta==8 & cntry=="ES"&essround==6 // range 28801 	to 33120 	midpoint 30960.5
replace income= 38760.5 	if hinctnta==9 & cntry=="ES"&essround==6 // range 33121 	to 44400 	midpoint 38760.5
replace income= 17249.5 	if hinctnta==1 & cntry=="CH"&essround==6 // range 0 		to 34499 	midpoint 17249.5
replace income= 41999.5 	if hinctnta==2 & cntry=="CH"&essround==6 // range 34500 	to 49499 	midpoint 41999.5
replace income= 55499.5 	if hinctnta==3 & cntry=="CH"&essround==6 // range 49500 	to 61499 	midpoint 55499.5
replace income= 68249.5 	if hinctnta==4 & cntry=="CH"&essround==6 // range 61500 	to 74999 	midpoint 68249.5
replace income= 81499.5 	if hinctnta==5 & cntry=="CH"&essround==6 // range 75000 	to 87999 	midpoint 81499.5
replace income= 96499.5		if hinctnta==6 & cntry=="CH"&essround==6 // range 88000 	to 104999 	midpoint 96499.5
replace income= 113749.5 	if hinctnta==7 & cntry=="CH"&essround==6 // range 105000 	to 122499 	midpoint 113749.5
replace income= 133749.5 	if hinctnta==8 & cntry=="CH"&essround==6 // range 122500	to 144999 	midpoint 133749.5
replace income= 164749.5 	if hinctnta==9 & cntry=="CH"&essround==6 // range 145000 	to 184499 	midpoint 164749.5
replace	income=	4940	if	hinctnta==1	&	cntry=="GB"&essround==6	//	range	0	to	9880	midpoint	4940
replace	income=	11440	if	hinctnta==2	&	cntry=="GB"&essround==6	//	range	9880	to	13000	midpoint	11440
replace	income=	14560	if	hinctnta==3	&	cntry=="GB"&essround==6	//	range	13000	to	16120	midpoint	14560
replace	income=	17940	if	hinctnta==4	&	cntry=="GB"&essround==6	//	range	16120	to	19760	midpoint	17940
replace	income=	21580	if	hinctnta==5	&	cntry=="GB"&essround==6	//	range	19760	to	23400	midpoint	21580
replace	income=	25740	if	hinctnta==6	&	cntry=="GB"&essround==6	//	range	23400	to	28080	midpoint	25740
replace	income=	30940	if	hinctnta==7	&	cntry=="GB"&essround==6	//	range	28080	to	33800	midpoint	30940
replace	income=	37440	if	hinctnta==8	&	cntry=="GB"&essround==6	//	range	33800	to	41080	midpoint	37440
replace	income=	47840	if	hinctnta==9	&	cntry=="GB"&essround==6	//	range	41080	to	54600	midpoint	47840
replace income= 65994 		if hinctnta==1 & cntry=="SE"&essround==6 // range 0			to 131988 	midpoint 65994
replace income= 155988.5 	if hinctnta==2 & cntry=="SE"&essround==6 // range 131989 	to 179988 	midpoint 155988.5
replace income= 203988.5 	if hinctnta==3 & cntry=="SE"&essround==6 // range 179989 	to 227988 	midpoint 203988.5
replace income= 245988.5 	if hinctnta==4 & cntry=="SE"&essround==6 // range 227989 	to 263988 	midpoint 245988.5
replace income= 281988.5 	if hinctnta==5 & cntry=="SE"&essround==6 // range 263989 	to 299988 	midpoint 281988.5
replace income= 323988.5 	if hinctnta==6 & cntry=="SE"&essround==6 // range 299989 	to 347988 	midpoint 323988.5
replace income= 371988.5 	if hinctnta==7 & cntry=="SE"&essround==6 // range 347989 	to 395988 	midpoint 371988.5
replace income= 437988.5 	if hinctnta==8 & cntry=="SE"&essround==6 // range 395989 	to 479988 	midpoint 437988.5
replace income= 533988.5 	if hinctnta==9 & cntry=="SE"&essround==6 // range 479989 	to 587988 	midpoint 533988.5
replace income= 6500 		if hinctnta==1 & cntry=="NL"&essround==6 // range 0 		to 13000 	midpoint 6500
replace income= 15000.5 	if hinctnta==2 & cntry=="NL"&essround==6 // range 13001 	to 17000 	midpoint 15000.5
replace income= 18700.5 	if hinctnta==3 & cntry=="NL"&essround==6 // range 17001 	to 20400 	midpoint 18700.5
replace income= 22250.5 	if hinctnta==4 & cntry=="NL"&essround==6 // range 20401 	to 24100 	midpoint 22250.5
replace income= 26250.5 	if hinctnta==5 & cntry=="NL"&essround==6 // range 24101 	to 28400 	midpoint 26250.5
replace income= 30950.5 	if hinctnta==6 & cntry=="NL"&essround==6 // range 28401 	to 33500 	midpoint 30950.5
replace income= 36300.5 	if hinctnta==7 & cntry=="NL"&essround==6 // range 33501 	to 39100 	midpoint 36300.5
replace income= 42750.5 	if hinctnta==8 & cntry=="NL"&essround==6 // range 39101 	to 46400 	midpoint 42750.5
replace income= 52600.5 	if hinctnta==9 & cntry=="NL"&essround==6 // range 46401 	to 58800 	midpoint 52600.5
replace income= 6786 		if hinctnta==1 & cntry=="IE"&essround==6 // range 0 		to 13572 	midpoint 6786
replace income= 15704.5 	if hinctnta==2 & cntry=="IE"&essround==6 // range 13573 	to 17836 	midpoint 15704.5
replace income= 21190.5 	if hinctnta==3 & cntry=="IE"&essround==6 // range 17837 	to 24544 	midpoint 21190.5
replace income= 27274.5 	if hinctnta==4 & cntry=="IE"&essround==6 // range 24545 	to 30004 	midpoint 27274.5
replace income= 32838.5 	if hinctnta==5 & cntry=="IE"&essround==6 // range 30005 	to 35672 	midpoint 32838.5
replace income= 39000.5 	if hinctnta==6 & cntry=="IE"&essround==6 // range 35673 	to 42328	midpoint 39000.5
replace income= 47060.5 	if hinctnta==7 & cntry=="IE"&essround==6 // range 42329 	to 51792 	midpoint 47060.5
replace income= 57278.5 	if hinctnta==8 & cntry=="IE"&essround==6 // range 51793 	to 62764 	midpoint 57278.5
replace income= 73294.5 	if hinctnta==9 & cntry=="IE"&essround==6 // range 62765 	to 83824 	midpoint 73294.5
replace income=	2750		if hinctnta==1 & cntry=="PT"&essround==6 // range 0			to	5500	midpoint 2750
replace income=	6500.5		if hinctnta==2 & cntry=="PT"&essround==6 // range 5501		to	7500	midpoint 6500.5
replace income=	8750.5		if hinctnta==3 & cntry=="PT"&essround==6 // range 7501		to	10000	midpoint 8750.5
replace income=	11000.5		if hinctnta==4 & cntry=="PT"&essround==6 // range 10001		to	12000	midpoint 11000.5
replace income=	13000.5		if hinctnta==5 & cntry=="PT"&essround==6 // range 12001		to	14000	midpoint 13000.5
replace income=	15500.5		if hinctnta==6 & cntry=="PT"&essround==6 // range 14001		to	17000	midpoint 15500.5
replace income=	18500.5		if hinctnta==7 & cntry=="PT"&essround==6 // range 17001		to	20000	midpoint 18500.5
replace income=	22500.5		if hinctnta==8 & cntry=="PT"&essround==6 // range 20001		to	25000	midpoint 22500.5
replace income=	30000.5		if hinctnta==9 & cntry=="PT"&essround==6 // range 25001		to	35000	midpoint 30000.5

* Using Hout 2004 to define top-incomes
* Creating a numerical country variable

encode cntry, generate(country)

* For 2002-2006 

gen hinctnt11=.
replace hinctnt11=1 if (hinctnt==11&essround<4)|(hinctnta==9&essround>3)
gen hinctnt12=.
replace hinctnt12=1 if (hinctnt==12&essround<4)|(hinctnta==10&essround>3)

by country essround, sort: egen freqtopminus1=count(hinctnt11)
by country essround, sort: egen freqtop=count(hinctnt12)


* Creating Top Income Category for ESS Rounds 1-3

gen v=((ln(freqtopminus1+freqtop))-ln(freqtop))/(ln(120000)-ln(90000))
replace income=120000*(v/(v-1)) if hinctnt==12 // range €120000 or more, mid-point Hout 2004

* For 2008-2012

gen topmax=.
gen topmin=.
replace topmax=35000  if cntry=="BE"&essround==4 // range 	€35000 
replace topmax=534000 if cntry=="DK"&essround==4 //	range	450000	to	under	534000 
replace topmax=55200  if cntry=="FI"&essround==4 // range 	€55200 
replace topmax=49200  if cntry=="FR"&essround==4 // range 	€49200 
replace topmax=70400  if cntry=="DE"&essround==4 // range 	€70400 
replace topmax=670000 if cntry=="NO"&essround==4 //	range	550000	to	under	670000
replace topmax=35000  if cntry=="PT"&essround==4 // range 	€35000
replace topmax=41000  if cntry=="ES"&essround==4 // range 	€41000
replace topmax=156500 if cntry=="CH"&essround==4 //	range	122000	to	under	156500
replace topmax=53920  if cntry=="GB"&essround==4 //	range	50110	to	under	53920
replace topmax=50300  if cntry=="NL"&essround==4 // range 	€50300
replace topmax=494400 if cntry=="SE"&essround==4 //	range	397200	to	under	494400
replace topmax=36000  if cntry=="GR"&essround==4 //	range	27600	to	under	36000

replace topmin=26000  if cntry=="BE"&essround==4 // range 	€35000 
replace topmin=450000 if cntry=="DK"&essround==4 //	range	450000	to	under	534000
replace topmin=44400  if cntry=="FI"&essround==4 // range 	€55200 
replace topmin=39600  if cntry=="FR"&essround==4 // range 	€49200 
replace topmin=54600  if cntry=="DE"&essround==4 // range 	€70400 
replace topmin=550000 if cntry=="NO"&essround==4 //	range	550000	to	under	670000 
replace topmin=24500  if cntry=="PT"&essround==4 // range 	€35000
replace topmin=33000  if cntry=="ES"&essround==4 // range 	€41000
replace topmin=122000 if cntry=="CH"&essround==4 //	range	122000	to	under	156500
replace topmin=50110  if cntry=="GB"&essround==4 //	range	50110	to	under	53920
replace topmin=40200  if cntry=="NL"&essround==4 // range 	€50300
replace topmin=397200 if cntry=="SE"&essround==4 //	range	397200	to	under	494400
replace topmin=27600  if cntry=="GR"&essround==4 //	range	27600	to	under	36000

replace topmax=56760  if cntry=="BE"&essround==5 //	range	44880	to	under	56760 
replace topmax=578000 if cntry=="DK"&essround==5 //	range	486000	to	under	578000 
replace topmax=61704  if cntry=="FI"&essround==5 //	range	49908	to	under	61704 
replace topmax=61200  if cntry=="FR"&essround==5 //	range	48000	to	under	61200 
replace topmax=53770  if cntry=="DE"&essround==5 //	range	42380	to	under	53770
replace topmax=935000 if cntry=="NO"&essround==5 //	range	775000	to	under	935000
replace topmax=41000  if cntry=="ES"&essround==5 //	range	33000	to	under	41000
replace topmax=165500 if cntry=="CH"&essround==5 //	range	127500	to	under	165500
replace topmax=53920  if cntry=="GB"&essround==5 //	range	41090	to	under	53920
replace topmax=52800  if cntry=="NL"&essround==5 //	range	46400	to	under	52800
replace topmax=528000 if cntry=="SE"&essround==5 //	range	432000	to	under	528000
replace topmax=38760  if cntry=="GR"&essround==5 //	range	30000	to	under	38760
replace topmax=85526  if cntry=="IE"&essround==5 //	range	64951	to	under	85526

replace topmin=44880  if cntry=="BE"&essround==5 //	range	44880	to	under	56760 
replace topmin=486000 if cntry=="DK"&essround==5 //	range	486000	to	under	578000 
replace topmin=49908  if cntry=="FI"&essround==5 //	range	49908	to	under	61704 
replace topmin=48000  if cntry=="FR"&essround==5 //	range	48000	to	under	61200 
replace topmin=42380  if cntry=="DE"&essround==5 //	range	42380	to	under	53770
replace topmin=775000 if cntry=="NO"&essround==5 //	range	775000	to	under	935000
replace topmin=33000  if cntry=="ES"&essround==5 //	range	33000	to	under	41000
replace topmin=127500 if cntry=="CH"&essround==5 //	range	127500	to	under	165500
replace topmin=41090  if cntry=="GB"&essround==5 //	range	41090	to	under	53920
replace topmin=46400  if cntry=="NL"&essround==5 //	range	46400	to	under	52800
replace topmin=432000 if cntry=="SE"&essround==5 //	range	432000	to	under	528000
replace topmin=30000  if cntry=="GR"&essround==5 //	range	30000	to	under	38760
replace topmin=64951  if cntry=="IE"&essround==5 //	range	64951	to	under	85526

replace topmax=60229  if cntry=="BE"&essround==6 // range 	48000 	to 60229
replace topmax=629999 if cntry=="DK"&essround==6 // range 	530000 	to 629999
replace topmax=64332  if cntry=="FI"&essround==6 // range 	51733 	to 64332
replace topmax=63600  if cntry=="FR"&essround==6 // range 	49201 	to 63600
replace topmax=58080  if cntry=="DE"&essround==6 // range 	45841 	to 58080
replace topmax=973000 if cntry=="NO"&essround==6 // range 	807001 	to 973000
replace topmax=44400  if cntry=="ES"&essround==6 // range 	33121 	to 44400
replace topmax=184499 if cntry=="CH"&essround==6 // range 	145000 	to 184499
replace topmax=54600  if cntry=="GB"&essround==6 //	range	41080	to	54600
replace topmax=587988 if cntry=="SE"&essround==6 // range 	479989 	to 587988
replace topmax=58800  if cntry=="NL"&essround==6 // range 	46401 	to 58800
replace topmax=83824  if cntry=="IE"&essround==6 // range 	62765 	to 83824
replace topmax=35000  if cntry=="PT"&essround==6 // range 	25001	to 35000

replace topmin=48000  if cntry=="BE"&essround==6 // range 	48000 	to 60229
replace topmin=530000 if cntry=="DK"&essround==6 // range 	530000 	to 629999
replace topmin=51733  if cntry=="FI"&essround==6 // range 	51733 	to 64332
replace topmin=49201  if cntry=="FR"&essround==6 // range 	49201 	to 63600
replace topmin=45841  if cntry=="DE"&essround==6 // range 	45841 	to 58080
replace topmin=807001 if cntry=="NO"&essround==6 // range 	807001 	to 973000
replace topmin=33121  if cntry=="ES"&essround==6 // range 	33121 	to 44400
replace topmin=145000 if cntry=="CH"&essround==6 // range 	145000 	to 184499
replace topmin=41080 if cntry=="GB"&essround==6 // range	41080	to	54600
replace topmin=479989 if cntry=="SE"&essround==6 // range 	479989 	to 587988
replace topmin=46401  if cntry=="NL"&essround==6 // range 	46401 	to 58800
replace topmin=62765  if cntry=="IE"&essround==6 // range 	62765 	to 83824
replace topmin=25001  if cntry=="PT"&essround==6 // range 	25001	to 35000


gen v4=((ln(freqtopminus1+freqtop))-ln(freqtop))/(ln(topmax)-ln(topmin)) if essround>3
replace income=topmax*(v4/(v4-1)) if hinctnta==10

* PPP 2010 conversion
* cpi 2010 from OECD.stat (extracted 17/07/2016), Consumer Price Index all items
* cpi 2010 from OECD.stat (extracted 17/07/2016), Purchasing Power Parities for private consumption (national currency per US dollar)

merge m:1 cntry year using ppp_cpi
drop if _merge==2
drop _merge

* Converting Euros into national currency for non-EU countries 2002-2006, 
* using national income ESS exchange rates 2002-2006

gen natincome=income
replace natincome=income*(7.4) if cntry=="DK" & (essround==1 | essround==2 | essround==3)
replace natincome=income*(7.17) if cntry=="NO" & (essround==1 | essround==2 | essround==3)
replace natincome=income*(9.4) if cntry=="SE" & (essround==1 | essround==2 | essround==3)
replace natincome=income*(1.5) if cntry=="CH" & (essround==1 | essround==2 | essround==3)
replace natincome=income*(.66) if cntry=="GB" & (essround==1 | essround==2 | essround==3)

* Turn into national currency, year 2010

gen natincome2010=natincome*100/cpi2010

* Turn into PPP corrected US dollars 2010

gen income_ppp2010=natincome2010/ppp2010

* Create income mean per country and year

sort country essround
by country essround: egen mpppincome=mean(income_ppp2010)


* Create difference between individual income and country specific mean income
* And divide by 1000 so that the unit is thousands of 2010 PPP-corrected dollars


gen incomedif=(income_ppp2010-mpppincome)/10000
