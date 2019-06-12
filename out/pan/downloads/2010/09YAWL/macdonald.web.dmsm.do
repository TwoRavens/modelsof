version 6.0 
#delimit ;

/* if first call initialize relevant variables */
if (calldmsm==0) {;
    initvar  
      dmlfrt1 dmagri1 dmenvi1 dmimmi1 dmpriv1 dmalco1 dmcrim1 
      dmlfrt2 dmagri2 dmenvi2 dmimmi2 dmpriv2 dmalco2 dmcrim2 
      dmlfrt3 dmagri3 dmenvi3 dmimmi3 dmpriv3 dmalco3 dmcrim3 
      dmlfrt4 dmagri4 dmenvi4 dmimmi4 dmpriv4 dmalco4 dmcrim4 
      dmlfrt5 dmagri5 dmenvi5 dmimmi5 dmpriv5 dmalco5 dmcrim5 
      dmlfrt6 dmagri6 dmenvi6 dmimmi6 dmpriv6 dmalco6 dmcrim6 
      dmlfrt7 dmagri7 dmenvi7 dmimmi7 dmpriv7 dmalco7 dmcrim7 ;
    initvar 
      dmxlfrt1 dmxagri1 dmxenvi1 dmximmi1 dmxpriv1 dmxalco1 dmxcrim1 
      dmxlfrt2 dmxagri2 dmxenvi2 dmximmi2 dmxpriv2 dmxalco2 dmxcrim2 
      dmxlfrt3 dmxagri3 dmxenvi3 dmximmi3 dmxpriv3 dmxalco3 dmxcrim3 
      dmxlfrt4 dmxagri4 dmxenvi4 dmximmi4 dmxpriv4 dmxalco4 dmxcrim4 
      dmxlfrt5 dmxagri5 dmxenvi5 dmximmi5 dmxpriv5 dmxalco5 dmxcrim5 
      dmxlfrt6 dmxagri6 dmxenvi6 dmximmi6 dmxpriv6 dmxalco6 dmxcrim6 
      dmxlfrt7 dmxagri7 dmxenvi7 dmximmi7 dmxpriv7 dmxalco7 dmxcrim7 ;
    initvar
      smlfrt1 smagri1 smenvi1 smimmi1 smpriv1 smalco1 smcrim1 
      smlfrt2 smagri2 smenvi2 smimmi2 smpriv2 smalco2 smcrim2 
      smlfrt3 smagri3 smenvi3 smimmi3 smpriv3 smalco3 smcrim3 
      smlfrt4 smagri4 smenvi4 smimmi4 smpriv4 smalco4 smcrim4 
      smlfrt5 smagri5 smenvi5 smimmi5 smpriv5 smalco5 smcrim5 
      smlfrt6 smagri6 smenvi6 smimmi6 smpriv6 smalco6 smcrim6 
      smlfrt7 smagri7 smenvi7 smimmi7 smpriv7 smalco7 smcrim7 ;
    initvar
      sm2lfrt1 sm2agri1 sm2envi1 sm2immi1 sm2priv1 sm2alco1 sm2crim1 
      sm2lfrt2 sm2agri2 sm2envi2 sm2immi2 sm2priv2 sm2alco2 sm2crim2 
      sm2lfrt3 sm2agri3 sm2envi3 sm2immi3 sm2priv3 sm2alco3 sm2crim3 
      sm2lfrt4 sm2agri4 sm2envi4 sm2immi4 sm2priv4 sm2alco4 sm2crim4 
      sm2lfrt5 sm2agri5 sm2envi5 sm2immi5 sm2priv5 sm2alco5 sm2crim5 
      sm2lfrt6 sm2agri6 sm2envi6 sm2immi6 sm2priv6 sm2alco6 sm2crim6 
      sm2lfrt7 sm2agri7 sm2envi7 sm2immi7 sm2priv7 sm2alco7 sm2crim7 ;
    initvar
      mlnlfrt1 mlnagri1 mlnenvi1 mlnimmi1 mlnpriv1 mlnalco1 mlncrim1 
      mlnlfrt2 mlnagri2 mlnenvi2 mlnimmi2 mlnpriv2 mlnalco2 mlncrim2 
      mlnlfrt3 mlnagri3 mlnenvi3 mlnimmi3 mlnpriv3 mlnalco3 mlncrim3 
      mlnlfrt4 mlnagri4 mlnenvi4 mlnimmi4 mlnpriv4 mlnalco4 mlncrim4 
      mlnlfrt5 mlnagri5 mlnenvi5 mlnimmi5 mlnpriv5 mlnalco5 mlncrim5 
      mlnlfrt6 mlnagri6 mlnenvi6 mlnimmi6 mlnpriv6 mlnalco6 mlncrim6 
      mlnlfrt7 mlnagri7 mlnenvi7 mlnimmi7 mlnpriv7 mlnalco7 mlncrim7  ;
};
/* count the number of calls */
scalar calldmsm=calldmsm+1;


/**** replace dm,dmx,sm ****/

/* SV */
replace dmlfrt1=abs(rlfrt-mlfrt1);
replace dmagri1=abs(ragri-magri1);
replace dmenvi1=abs(renvi-menvi1);
replace dmimmi1=abs(rimmi-mimmi1);
replace dmpriv1=abs(rpriv-mpriv1);
replace dmalco1=abs(ralco-malco1);
replace dmcrim1=abs(rcrim-mcrim1);

replace dmxlfrt1=dmlfrt1*dmlfrt1;
replace dmxagri1=dmagri1*dmagri1;
replace dmxenvi1=dmenvi1*dmenvi1;
replace dmximmi1=dmimmi1*dmimmi1;
replace dmxpriv1=dmpriv1*dmpriv1;
replace dmxalco1=dmalco1*dmalco1;
replace dmxcrim1=dmcrim1*dmcrim1;

replace smlfrt1=rlfrt*mlfrt1;
replace smagri1=ragri*magri1;
replace smenvi1=renvi*menvi1;
replace smimmi1=rimmi*mimmi1;
replace smpriv1=rpriv*mpriv1;
replace smalco1=ralco*malco1;
replace smcrim1=rcrim*mcrim1;

replace sm2lfrt1=2*smlfrt1;
replace sm2agri1=2*smagri1;
replace sm2envi1=2*smenvi1;
replace sm2immi1=2*smimmi1;
replace sm2priv1=2*smpriv1;
replace sm2alco1=2*smalco1;
replace sm2crim1=2*smcrim1;

replace mlnlfrt1=mlfrt1*mlfrt1 ;
replace mlnagri1=magri1*magri1 ;
replace mlnenvi1=menvi1*menvi1 ;
replace mlnimmi1=mimmi1*mimmi1 ;
replace mlnpriv1=mpriv1*mpriv1 ;
replace mlnalco1=malco1*malco1 ;
replace mlncrim1=mcrim1*mcrim1 ;


/* AP */
replace dmlfrt2=abs(rlfrt-mlfrt2);
replace dmagri2=abs(ragri-magri2);
replace dmenvi2=abs(renvi-menvi2);
replace dmimmi2=abs(rimmi-mimmi2);
replace dmpriv2=abs(rpriv-mpriv2);
replace dmalco2=abs(ralco-malco2);
replace dmcrim2=abs(rcrim-mcrim2);

replace dmxlfrt2=dmlfrt2*dmlfrt2;
replace dmxagri2=dmagri2*dmagri2;
replace dmxenvi2=dmenvi2*dmenvi2;
replace dmximmi2=dmimmi2*dmimmi2;
replace dmxpriv2=dmpriv2*dmpriv2;
replace dmxalco2=dmalco2*dmalco2;
replace dmxcrim2=dmcrim2*dmcrim2;

replace smlfrt2=rlfrt*mlfrt2;
replace smagri2=ragri*magri2;
replace smenvi2=renvi*menvi2;
replace smimmi2=rimmi*mimmi2;
replace smpriv2=rpriv*mpriv2;
replace smalco2=ralco*malco2;
replace smcrim2=rcrim*mcrim2;

replace sm2lfrt2=2*smlfrt2;
replace sm2agri2=2*smagri2;
replace sm2envi2=2*smenvi2;
replace sm2immi2=2*smimmi2;
replace sm2priv2=2*smpriv2;
replace sm2alco2=2*smalco2;
replace sm2crim2=2*smcrim2;

replace mlnlfrt2=mlfrt2*mlfrt2 ;
replace mlnagri2=magri2*magri2 ;
replace mlnenvi2=menvi2*menvi2 ;
replace mlnimmi2=mimmi2*mimmi2 ;
replace mlnpriv2=mpriv2*mpriv2 ;
replace mlnalco2=malco2*malco2 ;
replace mlncrim2=mcrim2*mcrim2 ;

/* VE */
replace dmlfrt3=abs(rlfrt-mlfrt3);
replace dmagri3=abs(ragri-magri3);
replace dmenvi3=abs(renvi-menvi3);
replace dmimmi3=abs(rimmi-mimmi3);
replace dmpriv3=abs(rpriv-mpriv3);
replace dmalco3=abs(ralco-malco3);
replace dmcrim3=abs(rcrim-mcrim3);

replace dmxlfrt3=dmlfrt3*dmlfrt3;
replace dmxagri3=dmagri3*dmagri3;
replace dmxenvi3=dmenvi3*dmenvi3;
replace dmximmi3=dmimmi3*dmimmi3;
replace dmxpriv3=dmpriv3*dmpriv3;
replace dmxalco3=dmalco3*dmalco3;
replace dmxcrim3=dmcrim3*dmcrim3;

replace smlfrt3=rlfrt*mlfrt3;
replace smagri3=ragri*magri3;
replace smenvi3=renvi*menvi3;
replace smimmi3=rimmi*mimmi3;
replace smpriv3=rpriv*mpriv3;
replace smalco3=ralco*malco3;
replace smcrim3=rcrim*mcrim3;

replace sm2lfrt3=2*smlfrt3;
replace sm2agri3=2*smagri3;
replace sm2envi3=2*smenvi3;
replace sm2immi3=2*smimmi3;
replace sm2priv3=2*smpriv3;
replace sm2alco3=2*smalco3;
replace sm2crim3=2*smcrim3;

replace mlnlfrt3=mlfrt3*mlfrt3 ;
replace mlnagri3=magri3*magri3 ;
replace mlnenvi3=menvi3*menvi3 ;
replace mlnimmi3=mimmi3*mimmi3 ;
replace mlnpriv3=mpriv3*mpriv3 ;
replace mlnalco3=malco3*malco3 ;
replace mlncrim3=mcrim3*mcrim3 ;

/* SP */
replace dmlfrt4=abs(rlfrt-mlfrt4);
replace dmagri4=abs(ragri-magri4);
replace dmenvi4=abs(renvi-menvi4);
replace dmimmi4=abs(rimmi-mimmi4);
replace dmpriv4=abs(rpriv-mpriv4);
replace dmalco4=abs(ralco-malco4);
replace dmcrim4=abs(rcrim-mcrim4);

replace dmxlfrt4=dmlfrt4*dmlfrt4;
replace dmxagri4=dmagri4*dmagri4;
replace dmxenvi4=dmenvi4*dmenvi4;
replace dmximmi4=dmimmi4*dmimmi4;
replace dmxpriv4=dmpriv4*dmpriv4;
replace dmxalco4=dmalco4*dmalco4;
replace dmxcrim4=dmcrim4*dmcrim4;

replace smlfrt4=rlfrt*mlfrt4;
replace smagri4=ragri*magri4;
replace smenvi4=renvi*menvi4;
replace smimmi4=rimmi*mimmi4;
replace smpriv4=rpriv*mpriv4;
replace smalco4=ralco*malco4;
replace smcrim4=rcrim*mcrim4;

replace sm2lfrt4=2*smlfrt4;
replace sm2agri4=2*smagri4;
replace sm2envi4=2*smenvi4;
replace sm2immi4=2*smimmi4;
replace sm2priv4=2*smpriv4;
replace sm2alco4=2*smalco4;
replace sm2crim4=2*smcrim4;

replace mlnlfrt4=mlfrt4*mlfrt4 ;
replace mlnagri4=magri4*magri4 ;
replace mlnenvi4=menvi4*menvi4 ;
replace mlnimmi4=mimmi4*mimmi4 ;
replace mlnpriv4=mpriv4*mpriv4 ;
replace mlnalco4=malco4*malco4 ;
replace mlncrim4=mcrim4*mcrim4 ;

/* KR */
replace dmlfrt5=abs(rlfrt-mlfrt5);
replace dmagri5=abs(ragri-magri5);
replace dmenvi5=abs(renvi-menvi5);
replace dmimmi5=abs(rimmi-mimmi5);
replace dmpriv5=abs(rpriv-mpriv5);
replace dmalco5=abs(ralco-malco5);
replace dmcrim5=abs(rcrim-mcrim5);

replace dmxlfrt5=dmlfrt5*dmlfrt5;
replace dmxagri5=dmagri5*dmagri5;
replace dmxenvi5=dmenvi5*dmenvi5;
replace dmximmi5=dmimmi5*dmimmi5;
replace dmxpriv5=dmpriv5*dmpriv5;
replace dmxalco5=dmalco5*dmalco5;
replace dmxcrim5=dmcrim5*dmcrim5;

replace smlfrt5=rlfrt*mlfrt5;
replace smagri5=ragri*magri5;
replace smenvi5=renvi*menvi5;
replace smimmi5=rimmi*mimmi5;
replace smpriv5=rpriv*mpriv5;
replace smalco5=ralco*malco5;
replace smcrim5=rcrim*mcrim5;

replace sm2lfrt5=2*smlfrt5;
replace sm2agri5=2*smagri5;
replace sm2envi5=2*smenvi5;
replace sm2immi5=2*smimmi5;
replace sm2priv5=2*smpriv5;
replace sm2alco5=2*smalco5;
replace sm2crim5=2*smcrim5;

replace mlnlfrt5=mlfrt5*mlfrt5 ;
replace mlnagri5=magri5*magri5 ;
replace mlnenvi5=menvi5*menvi5 ;
replace mlnimmi5=mimmi5*mimmi5 ;
replace mlnpriv5=mpriv5*mpriv5 ;
replace mlnalco5=malco5*malco5 ;
replace mlncrim5=mcrim5*mcrim5 ;

/* HP */
replace dmlfrt6=abs(rlfrt-mlfrt6);
replace dmagri6=abs(ragri-magri6);
replace dmenvi6=abs(renvi-menvi6);
replace dmimmi6=abs(rimmi-mimmi6);
replace dmpriv6=abs(rpriv-mpriv6);
replace dmalco6=abs(ralco-malco6);
replace dmcrim6=abs(rcrim-mcrim6);

replace dmxlfrt6=dmlfrt6*dmlfrt6;
replace dmxagri6=dmagri6*dmagri6;
replace dmxenvi6=dmenvi6*dmenvi6;
replace dmximmi6=dmimmi6*dmimmi6;
replace dmxpriv6=dmpriv6*dmpriv6;
replace dmxalco6=dmalco6*dmalco6;
replace dmxcrim6=dmcrim6*dmcrim6;

replace smlfrt6=rlfrt*mlfrt6;
replace smagri6=ragri*magri6;
replace smenvi6=renvi*menvi6;
replace smimmi6=rimmi*mimmi6;
replace smpriv6=rpriv*mpriv6;
replace smalco6=ralco*malco6;
replace smcrim6=rcrim*mcrim6;

replace sm2lfrt6=2*smlfrt6;
replace sm2agri6=2*smagri6;
replace sm2envi6=2*smenvi6;
replace sm2immi6=2*smimmi6;
replace sm2priv6=2*smpriv6;
replace sm2alco6=2*smalco6;
replace sm2crim6=2*smcrim6;

replace mlnlfrt6=mlfrt6*mlfrt6 ;
replace mlnagri6=magri6*magri6 ;
replace mlnenvi6=menvi6*menvi6 ;
replace mlnimmi6=mimmi6*mimmi6 ;
replace mlnpriv6=mpriv6*mpriv6 ;
replace mlnalco6=malco6*malco6 ;
replace mlncrim6=mcrim6*mcrim6 ;

/* FR */
replace dmlfrt7=abs(rlfrt-mlfrt7);
replace dmagri7=abs(ragri-magri7);
replace dmenvi7=abs(renvi-menvi7);
replace dmimmi7=abs(rimmi-mimmi7);
replace dmpriv7=abs(rpriv-mpriv7);
replace dmalco7=abs(ralco-malco7);
replace dmcrim7=abs(rcrim-mcrim7);

replace dmxlfrt7=dmlfrt7*dmlfrt7;
replace dmxagri7=dmagri7*dmagri7;
replace dmxenvi7=dmenvi7*dmenvi7;
replace dmximmi7=dmimmi7*dmimmi7;
replace dmxpriv7=dmpriv7*dmpriv7;
replace dmxalco7=dmalco7*dmalco7;
replace dmxcrim7=dmcrim7*dmcrim7;

replace smlfrt7=rlfrt*mlfrt7;
replace smagri7=ragri*magri7;
replace smenvi7=renvi*menvi7;
replace smimmi7=rimmi*mimmi7;
replace smpriv7=rpriv*mpriv7;
replace smalco7=ralco*malco7;
replace smcrim7=rcrim*mcrim7;

replace sm2lfrt7=2*smlfrt7;
replace sm2agri7=2*smagri7;
replace sm2envi7=2*smenvi7;
replace sm2immi7=2*smimmi7;
replace sm2priv7=2*smpriv7;
replace sm2alco7=2*smalco7;
replace sm2crim7=2*smcrim7;

replace mlnlfrt7=mlfrt7*mlfrt7 ;
replace mlnagri7=magri7*magri7 ;
replace mlnenvi7=menvi7*menvi7 ;
replace mlnimmi7=mimmi7*mimmi7 ;
replace mlnpriv7=mpriv7*mpriv7 ;
replace mlnalco7=malco7*malco7 ;
replace mlncrim7=mcrim7*mcrim7 ;

