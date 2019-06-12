version 6.0 
#delimit ;

/* if first call initialize relevant variables */
if (calldisi==0) {;
    initvar  
      dilfrt1 diagri1 dienvi1 diimmi1 dipriv1 dialco1 dicrim1 
      dilfrt2 diagri2 dienvi2 diimmi2 dipriv2 dialco2 dicrim2 
      dilfrt3 diagri3 dienvi3 diimmi3 dipriv3 dialco3 dicrim3 
      dilfrt4 diagri4 dienvi4 diimmi4 dipriv4 dialco4 dicrim4 
      dilfrt5 diagri5 dienvi5 diimmi5 dipriv5 dialco5 dicrim5 
      dilfrt6 diagri6 dienvi6 diimmi6 dipriv6 dialco6 dicrim6 
      dilfrt7 diagri7 dienvi7 diimmi7 dipriv7 dialco7 dicrim7 ;
    initvar
      dixlfrt1 dixagri1 dixenvi1 diximmi1 dixpriv1 dixalco1 dixcrim1 
      dixlfrt2 dixagri2 dixenvi2 diximmi2 dixpriv2 dixalco2 dixcrim2 
      dixlfrt3 dixagri3 dixenvi3 diximmi3 dixpriv3 dixalco3 dixcrim3 
      dixlfrt4 dixagri4 dixenvi4 diximmi4 dixpriv4 dixalco4 dixcrim4 
      dixlfrt5 dixagri5 dixenvi5 diximmi5 dixpriv5 dixalco5 dixcrim5 
      dixlfrt6 dixagri6 dixenvi6 diximmi6 dixpriv6 dixalco6 dixcrim6 
      dixlfrt7 dixagri7 dixenvi7 diximmi7 dixpriv7 dixalco7 dixcrim7 ;
    initvar
      silfrt1 siagri1 sienvi1 siimmi1 sipriv1 sialco1 sicrim1 
      silfrt2 siagri2 sienvi2 siimmi2 sipriv2 sialco2 sicrim2 
      silfrt3 siagri3 sienvi3 siimmi3 sipriv3 sialco3 sicrim3 
      silfrt4 siagri4 sienvi4 siimmi4 sipriv4 sialco4 sicrim4 
      silfrt5 siagri5 sienvi5 siimmi5 sipriv5 sialco5 sicrim5 
      silfrt6 siagri6 sienvi6 siimmi6 sipriv6 sialco6 sicrim6 
      silfrt7 siagri7 sienvi7 siimmi7 sipriv7 sialco7 sicrim7 ;
    initvar
      si2lfrt1 si2agri1 si2envi1 si2immi1 si2priv1 si2alco1 si2crim1 
      si2lfrt2 si2agri2 si2envi2 si2immi2 si2priv2 si2alco2 si2crim2 
      si2lfrt3 si2agri3 si2envi3 si2immi3 si2priv3 si2alco3 si2crim3 
      si2lfrt4 si2agri4 si2envi4 si2immi4 si2priv4 si2alco4 si2crim4 
      si2lfrt5 si2agri5 si2envi5 si2immi5 si2priv5 si2alco5 si2crim5 
      si2lfrt6 si2agri6 si2envi6 si2immi6 si2priv6 si2alco6 si2crim6 
      si2lfrt7 si2agri7 si2envi7 si2immi7 si2priv7 si2alco7 si2crim7 ;
    initvar
      plnlfrt1 plnagri1 plnenvi1 plnimmi1 plnpriv1 plnalco1 plncrim1 
      plnlfrt2 plnagri2 plnenvi2 plnimmi2 plnpriv2 plnalco2 plncrim2 
      plnlfrt3 plnagri3 plnenvi3 plnimmi3 plnpriv3 plnalco3 plncrim3 
      plnlfrt4 plnagri4 plnenvi4 plnimmi4 plnpriv4 plnalco4 plncrim4 
      plnlfrt5 plnagri5 plnenvi5 plnimmi5 plnpriv5 plnalco5 plncrim5 
      plnlfrt6 plnagri6 plnenvi6 plnimmi6 plnpriv6 plnalco6 plncrim6 
      plnlfrt7 plnagri7 plnenvi7 plnimmi7 plnpriv7 plnalco7 plncrim7  ;
};
/* count the number of calls */
scalar calldisi=calldisi+1;


/**** replace di,dix,si,pln ****/

/* SV */
replace dilfrt1=abs(rlfrt-plfrt1);
replace diagri1=abs(ragri-pagri1);
replace dienvi1=abs(renvi-penvi1);
replace diimmi1=abs(rimmi-pimmi1);
replace dipriv1=abs(rpriv-ppriv1);
replace dialco1=abs(ralco-palco1);
replace dicrim1=abs(rcrim-pcrim1);

replace dixlfrt1=dilfrt1*dilfrt1;
replace dixagri1=diagri1*diagri1;
replace dixenvi1=dienvi1*dienvi1;
replace diximmi1=diimmi1*diimmi1;
replace dixpriv1=dipriv1*dipriv1;
replace dixalco1=dialco1*dialco1;
replace dixcrim1=dicrim1*dicrim1;

replace silfrt1=rlfrt*plfrt1;
replace siagri1=ragri*pagri1;
replace sienvi1=renvi*penvi1;
replace siimmi1=rimmi*pimmi1;
replace sipriv1=rpriv*ppriv1;
replace sialco1=ralco*palco1;
replace sicrim1=rcrim*pcrim1;

replace si2lfrt1=2*silfrt1;
replace si2agri1=2*siagri1;
replace si2envi1=2*sienvi1;
replace si2immi1=2*siimmi1;
replace si2priv1=2*sipriv1;
replace si2alco1=2*sialco1;
replace si2crim1=2*sicrim1;

replace plnlfrt1=plfrt1*plfrt1 ;
replace plnagri1=pagri1*pagri1 ;
replace plnenvi1=penvi1*penvi1 ;
replace plnimmi1=pimmi1*pimmi1 ;
replace plnpriv1=ppriv1*ppriv1 ;
replace plnalco1=palco1*palco1 ;
replace plncrim1=pcrim1*pcrim1 ;

/* AP */
replace dilfrt2=abs(rlfrt-plfrt2);
replace diagri2=abs(ragri-pagri2);
replace dienvi2=abs(renvi-penvi2);
replace diimmi2=abs(rimmi-pimmi2);
replace dipriv2=abs(rpriv-ppriv2);
replace dialco2=abs(ralco-palco2);
replace dicrim2=abs(rcrim-pcrim2);

replace dixlfrt2=dilfrt2*dilfrt2;
replace dixagri2=diagri2*diagri2;
replace dixenvi2=dienvi2*dienvi2;
replace diximmi2=diimmi2*diimmi2;
replace dixpriv2=dipriv2*dipriv2;
replace dixalco2=dialco2*dialco2;
replace dixcrim2=dicrim2*dicrim2;

replace silfrt2=rlfrt*plfrt2;
replace siagri2=ragri*pagri2;
replace sienvi2=renvi*penvi2;
replace siimmi2=rimmi*pimmi2;
replace sipriv2=rpriv*ppriv2;
replace sialco2=ralco*palco2;
replace sicrim2=rcrim*pcrim2;

replace si2lfrt2=2*silfrt2;
replace si2agri2=2*siagri2;
replace si2envi2=2*sienvi2;
replace si2immi2=2*siimmi2;
replace si2priv2=2*sipriv2;
replace si2alco2=2*sialco2;
replace si2crim2=2*sicrim2;

replace plnlfrt2=plfrt2*plfrt2 ;
replace plnagri2=pagri2*pagri2 ;
replace plnenvi2=penvi2*penvi2 ;
replace plnimmi2=pimmi2*pimmi2 ;
replace plnpriv2=ppriv2*ppriv2 ;
replace plnalco2=palco2*palco2 ;
replace plncrim2=pcrim2*pcrim2 ;

/* VE */
replace dilfrt3=abs(rlfrt-plfrt3);
replace diagri3=abs(ragri-pagri3);
replace dienvi3=abs(renvi-penvi3);
replace diimmi3=abs(rimmi-pimmi3);
replace dipriv3=abs(rpriv-ppriv3);
replace dialco3=abs(ralco-palco3);
replace dicrim3=abs(rcrim-pcrim3);

replace dixlfrt3=dilfrt3*dilfrt3;
replace dixagri3=diagri3*diagri3;
replace dixenvi3=dienvi3*dienvi3;
replace diximmi3=diimmi3*diimmi3;
replace dixpriv3=dipriv3*dipriv3;
replace dixalco3=dialco3*dialco3;
replace dixcrim3=dicrim3*dicrim3;

replace silfrt3=rlfrt*plfrt3;
replace siagri3=ragri*pagri3;
replace sienvi3=renvi*penvi3;
replace siimmi3=rimmi*pimmi3;
replace sipriv3=rpriv*ppriv3;
replace sialco3=ralco*palco3;
replace sicrim3=rcrim*pcrim3;

replace si2lfrt3=2*silfrt3;
replace si2agri3=2*siagri3;
replace si2envi3=2*sienvi3;
replace si2immi3=2*siimmi3;
replace si2priv3=2*sipriv3;
replace si2alco3=2*sialco3;
replace si2crim3=2*sicrim3;

replace plnlfrt3=plfrt3*plfrt3 ;
replace plnagri3=pagri3*pagri3 ;
replace plnenvi3=penvi3*penvi3 ;
replace plnimmi3=pimmi3*pimmi3 ;
replace plnpriv3=ppriv3*ppriv3 ;
replace plnalco3=palco3*palco3 ;
replace plncrim3=pcrim3*pcrim3 ;

/* SP */
replace dilfrt4=abs(rlfrt-plfrt4);
replace diagri4=abs(ragri-pagri4);
replace dienvi4=abs(renvi-penvi4);
replace diimmi4=abs(rimmi-pimmi4);
replace dipriv4=abs(rpriv-ppriv4);
replace dialco4=abs(ralco-palco4);
replace dicrim4=abs(rcrim-pcrim4);

replace dixlfrt4=dilfrt4*dilfrt4;
replace dixagri4=diagri4*diagri4;
replace dixenvi4=dienvi4*dienvi4;
replace diximmi4=diimmi4*diimmi4;
replace dixpriv4=dipriv4*dipriv4;
replace dixalco4=dialco4*dialco4;
replace dixcrim4=dicrim4*dicrim4;

replace silfrt4=rlfrt*plfrt4;
replace siagri4=ragri*pagri4;
replace sienvi4=renvi*penvi4;
replace siimmi4=rimmi*pimmi4;
replace sipriv4=rpriv*ppriv4;
replace sialco4=ralco*palco4;
replace sicrim4=rcrim*pcrim4;

replace si2lfrt4=2*silfrt4;
replace si2agri4=2*siagri4;
replace si2envi4=2*sienvi4;
replace si2immi4=2*siimmi4;
replace si2priv4=2*sipriv4;
replace si2alco4=2*sialco4;
replace si2crim4=2*sicrim4;

replace plnlfrt4=plfrt4*plfrt4 ;
replace plnagri4=pagri4*pagri4 ;
replace plnenvi4=penvi4*penvi4 ;
replace plnimmi4=pimmi4*pimmi4 ;
replace plnpriv4=ppriv4*ppriv4 ;
replace plnalco4=palco4*palco4 ;
replace plncrim4=pcrim4*pcrim4 ;

/* KR */
replace dilfrt5=abs(rlfrt-plfrt5);
replace diagri5=abs(ragri-pagri5);
replace dienvi5=abs(renvi-penvi5);
replace diimmi5=abs(rimmi-pimmi5);
replace dipriv5=abs(rpriv-ppriv5);
replace dialco5=abs(ralco-palco5);
replace dicrim5=abs(rcrim-pcrim5);

replace dixlfrt5=dilfrt5*dilfrt5;
replace dixagri5=diagri5*diagri5;
replace dixenvi5=dienvi5*dienvi5;
replace diximmi5=diimmi5*diimmi5;
replace dixpriv5=dipriv5*dipriv5;
replace dixalco5=dialco5*dialco5;
replace dixcrim5=dicrim5*dicrim5;

replace silfrt5=rlfrt*plfrt5;
replace siagri5=ragri*pagri5;
replace sienvi5=renvi*penvi5;
replace siimmi5=rimmi*pimmi5;
replace sipriv5=rpriv*ppriv5;
replace sialco5=ralco*palco5;
replace sicrim5=rcrim*pcrim5;

replace si2lfrt5=2*silfrt5;
replace si2agri5=2*siagri5;
replace si2envi5=2*sienvi5;
replace si2immi5=2*siimmi5;
replace si2priv5=2*sipriv5;
replace si2alco5=2*sialco5;
replace si2crim5=2*sicrim5;

replace plnlfrt5=plfrt5*plfrt5 ;
replace plnagri5=pagri5*pagri5 ;
replace plnenvi5=penvi5*penvi5 ;
replace plnimmi5=pimmi5*pimmi5 ;
replace plnpriv5=ppriv5*ppriv5 ;
replace plnalco5=palco5*palco5 ;
replace plncrim5=pcrim5*pcrim5 ;

/* HP */
replace dilfrt6=abs(rlfrt-plfrt6);
replace diagri6=abs(ragri-pagri6);
replace dienvi6=abs(renvi-penvi6);
replace diimmi6=abs(rimmi-pimmi6);
replace dipriv6=abs(rpriv-ppriv6);
replace dialco6=abs(ralco-palco6);
replace dicrim6=abs(rcrim-pcrim6);

replace dixlfrt6=dilfrt6*dilfrt6;
replace dixagri6=diagri6*diagri6;
replace dixenvi6=dienvi6*dienvi6;
replace diximmi6=diimmi6*diimmi6;
replace dixpriv6=dipriv6*dipriv6;
replace dixalco6=dialco6*dialco6;
replace dixcrim6=dicrim6*dicrim6;

replace silfrt6=rlfrt*plfrt6;
replace siagri6=ragri*pagri6;
replace sienvi6=renvi*penvi6;
replace siimmi6=rimmi*pimmi6;
replace sipriv6=rpriv*ppriv6;
replace sialco6=ralco*palco6;
replace sicrim6=rcrim*pcrim6;

replace si2lfrt6=2*silfrt6;
replace si2agri6=2*siagri6;
replace si2envi6=2*sienvi6;
replace si2immi6=2*siimmi6;
replace si2priv6=2*sipriv6;
replace si2alco6=2*sialco6;
replace si2crim6=2*sicrim6;

replace plnlfrt6=plfrt6*plfrt6 ;
replace plnagri6=pagri6*pagri6 ;
replace plnenvi6=penvi6*penvi6 ;
replace plnimmi6=pimmi6*pimmi6 ;
replace plnpriv6=ppriv6*ppriv6 ;
replace plnalco6=palco6*palco6 ;
replace plncrim6=pcrim6*pcrim6 ;
                                                       
/* FR */
replace dilfrt7=abs(rlfrt-plfrt7);
replace diagri7=abs(ragri-pagri7);
replace dienvi7=abs(renvi-penvi7);
replace diimmi7=abs(rimmi-pimmi7);
replace dipriv7=abs(rpriv-ppriv7);
replace dialco7=abs(ralco-palco7);
replace dicrim7=abs(rcrim-pcrim7);

replace dixlfrt7=dilfrt7*dilfrt7;
replace dixagri7=diagri7*diagri7;
replace dixenvi7=dienvi7*dienvi7;
replace diximmi7=diimmi7*diimmi7;
replace dixpriv7=dipriv7*dipriv7;
replace dixalco7=dialco7*dialco7;
replace dixcrim7=dicrim7*dicrim7;

replace silfrt7=rlfrt*plfrt7;
replace siagri7=ragri*pagri7;
replace sienvi7=renvi*penvi7;
replace siimmi7=rimmi*pimmi7;
replace sipriv7=rpriv*ppriv7;
replace sialco7=ralco*palco7;
replace sicrim7=rcrim*pcrim7;

replace si2lfrt7=2*silfrt7;
replace si2agri7=2*siagri7;
replace si2envi7=2*sienvi7;
replace si2immi7=2*siimmi7;
replace si2priv7=2*sipriv7;
replace si2alco7=2*sialco7;
replace si2crim7=2*sicrim7;

replace plnlfrt7=plfrt7*plfrt7 ;
replace plnagri7=pagri7*pagri7 ;
replace plnenvi7=penvi7*penvi7 ;
replace plnimmi7=pimmi7*pimmi7 ;
replace plnpriv7=ppriv7*ppriv7 ;
replace plnalco7=palco7*palco7 ;
replace plncrim7=pcrim7*pcrim7 ;
