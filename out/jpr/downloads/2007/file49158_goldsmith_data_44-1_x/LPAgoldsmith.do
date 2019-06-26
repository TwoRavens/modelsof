


****do file for key models

*model 3

#del;

cdsimeq (lntradeab lnpolity21 lnpolity22 lncgdpa lncgdpb lndistance lntradeablag) (cwfataldmy  pol2low pol2lowAsia 
	lngleddeplow lngleddeplowAsia lnnumigofill lnnumigofillAsia Asia minpwrdyad paritysqrt 
	colcont24 contig24 lndistance lcwfataldmy)if year >1949 & year < 2001;


*model 4

#del;

cdsimeq (lntradeab lnpolity21 lnpolity22 lncgdpa lncgdpb lndistance lntradeablag) (cwwar  pol2low pol2lowAsia 
	lngleddeplow lngleddeplowAsia lnnumigofill lnnumigofillAsia Asia minpwrdyad paritysqrt 
	colcont24 contig24 lndistance lcwwar)if year >1949 & year < 2001;


*model 6

#del;

cdsimeq (lntradeab lnpolity21 lnpolity22 lncgdpa lncgdpb lndistance lntradeablag) (cwfataldmy  pol2low pol2lowAsia 
	lngleddeplow lngleddeplowAsia lnnumigofill lnnumigofillAsia Asia minpwrdyad paritysqrt 
	colcont24 contig24 lndistance lcwfataldmy)if year >1949 & year < 1976;


*model 7

#del;

cdsimeq (lntradeab lnpolity21 lnpolity22 lncgdpa lncgdpb lndistance lntradeablag) (cwwar  pol2low pol2lowAsia 
	lngleddeplow lngleddeplowAsia lnnumigofill lnnumigofillAsia Asia minpwrdyad paritysqrt 
	colcont24 contig24 lndistance lcwwar)if year >1949 & year < 1976;


*asian dyads
*model 11


#del;

cdsimeq (lntradeab lnpolity21 lnpolity22 lncgdpa lncgdpb lndistance lntradeablag) (cwfataldmy  pol2low 
	lngleddeplow lnnumigofill minpwrdyad paritysqrt colcont24 contig24 lndistance lcwfataldmy) 
	if year > 1949 & year < 2001 & Asia==1;

*model 12

***asian dyads 1950-75


#del;

cdsimeq (lntradeab lnpolity21 lnpolity22 lncgdpa lncgdpb lndistance lntradeablag) (cwmid  pol2low 
	lngleddeplow lnnumigofill minpwrdyad paritysqrt colcont24 contig24 lndistance lcwmid) 
	if year > 1949 & year < 1976 & Asia==1;



****model 13 and marginal effects
*marginal effects must be multipled by standard deviations as found in Table A1

***asian dyads 1950-75


#del;

cdsimeq (lntradeab lnpolity21 lnpolity22 lncgdpa lncgdpb lndistance lntradeablag) (cwfataldmy  pol2low 
	lngleddeplow lnnumigofill minpwrdyad paritysqrt colcont24 contig24 lndistance lcwfataldmy) 
	if year > 1949 & year < 1976 & Asia==1, est;

#del;

_estimates unhold model_2;


mfx if year >1949 & year<1976 & Asia==1, at(median);



*model 14

#del;

cdsimeq (lntradeab lnpolity21 lnpolity22 lncgdpa lncgdpb lndistance lntradeablag) (cwwar  pol2low 
	lngleddeplow lnnumigofill minpwrdyad paritysqrt colcont24 contig24 lndistance lcwwar) 
	if year > 1949 & year < 1976 & Asia==1;

*model 15
***asian dyads 1976-2000


#del;

cdsimeq (lntradeab lnpolity21 lnpolity22 lncgdpa lncgdpb lndistance lntradeablag) (cwmid  pol2low 
	lngleddeplow lnnumigofill minpwrdyad paritysqrt contig24 lndistance lcwmid) 
	if year > 1975 & year < 2001 & Asia==1;





****model 16 and marginal effects

***asian dyads 1976-2000
***



#del;

cdsimeq (lntradeab lnpolity21 lnpolity22 lncgdpa lncgdpb lndistance lntradeablag) (cwfataldmy  pol2low 
	lngleddeplow lnnumigofill minpwrdyad paritysqrt contig24 lndistance lcwfataldmy) 
	if year > 1975 & year < 2001 & Asia==1, est;

_estimates unhold model_2;


mfx if year >1975 & year<2001 & Asia==1, at(median);


*model 17


#del;

cdsimeq (lntradeab lnpolity21 lnpolity22 lncgdpa lncgdpb lndistance lntradeablag) (cwwar  pol2low 
	lngleddeplow lnnumigofill minpwrdyad paritysqrt lndistance lcwwar) 
	if year > 1975 & year < 2001 & Asia==1;

*model 23

#del;

cdsimeq (lntradeab lnpolity21 lnpolity22 lncgdpa lncgdpb lndistance lntradeablag) (cwmid  pol2low 
	lngleddeplow lnnumigofill apec minpwrdyad paritysqrt colcont24 contig24 lndistance lcwmid) 
	if year > 1949 & year < 2001 & (region1==4 | region2==4) & Asia~=1;





