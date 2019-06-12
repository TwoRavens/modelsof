version 6.0 
#delimit ;
/* read data */
infix 
   idnum 1-5
   rlfrt 6-7
   ragri 8-9
   renvi 10-11
   rimmi 12-13
   rpriv 14-15
   ralco 16-17
   rcrim 18-19
   plfrt1 20-21
   pagri1 22-23
   penvi1 24-25
   pimmi1 26-27
   ppriv1 28-29
   palco1 30-31                                   
   pcrim1 32-33
   plfrt2 34-35
   pagri2 36-37
   penvi2 38-39
   pimmi2 40-41
   ppriv2 42-43
   palco2 44-45
   pcrim2 46-47
   plfrt3 48-49
   pagri3 50-51
   penvi3 52-53
   pimmi3 54-55
   ppriv3 56-57
   palco3 58-59
   pcrim3 60-61
   plfrt4 62-63
   pagri4 64-65
   penvi4 66-67
   pimmi4 68-69
   ppriv4 70-71
   palco4 72-73
   pcrim4 74-75
   plfrt5 76-77
   pagri5 78-79
   penvi5 80-81
   pimmi5 82-83
   ppriv5 84-85
   palco5 86-87
   pcrim5 88-89
   plfrt6 90-91
   pagri6 92-93
   penvi6 94-95
   pimmi6 96-97
   ppriv6 98-99
   palco6 100-101
   pcrim6 102-103
   plfrt7 104-105
   pagri7 106-107
   penvi7 108-109
   pimmi7 110-111
   ppriv7 112-113
   palco7 114-115
   pcrim7 116-117
   symp1 118-120
   symp2 121-123
   symp3 124-126
   symp4 127-129
   symp5 130-132
   symp6 133-135
   symp7 136-138
using c:\stata\data\valg89STATAV1.raw;

scalar mnlfrt1=2.5012684 - 5.5 ; 
scalar mnagri1=6.7368090 - 5.5 ; 
scalar mnenvi1=2.6573876 - 5.5 ; 
scalar mnimmi1=3.3641240 - 5.5 ; 
scalar mnpriv1=8.6602899 - 5.5 ; 
scalar mnalco1=6.5128527 - 5.5 ;
scalar mncrim1=6.0648267 - 5.5 ; 

scalar mnlfrt2=3.9909684 - 5.5 ; 
scalar mnagri2=7.0469723 - 5.5 ; 
scalar mnenvi2=4.8977395 - 5.5 ; 
scalar mnimmi2=4.9988987 - 5.5 ; 
scalar mnpriv2=8.5048596 - 5.5 ; 
scalar mnalco2=6.4705552 - 5.5 ;
scalar mncrim2=5.5906158 - 5.5 ; 

scalar mnlfrt3=4.3097713 - 5.5 ; 
scalar mnagri3=6.1753585 - 5.5 ; 
scalar mnenvi3=2.8603382 - 5.5 ; 
scalar mnimmi3=4.5491071 - 5.5 ; 
scalar mnpriv3=6.1001292 - 5.5 ; 
scalar mnalco3=6.5691824 - 5.5 ;
scalar mncrim3=5.0835044 - 5.5 ; 

scalar mnlfrt4=5.3863755 - 5.5 ; 
scalar mnagri4=9.2883772 - 5.5 ; 
scalar mnenvi4=5.0276680 - 5.5 ; 
scalar mnimmi4=5.5052910 - 5.5 ; 
scalar mnpriv4=5.8761118 - 5.5 ; 
scalar mnalco4=6.1601033 - 5.5 ;
scalar mncrim4=4.5370879 - 5.5 ; 

scalar mnlfrt5=6.5467480 - 5.5 ; 
scalar mnagri5=6.2015834 - 5.5 ; 
scalar mnenvi5=5.1584327 - 5.5 ; 
scalar mnimmi5=4.7241784 - 5.5 ; 
scalar mnpriv5=5.5015069 - 5.5 ; 
scalar mnalco5=9.5279404 - 5.5 ;
scalar mncrim5=5.0200125 - 5.5 ; 

scalar mnlfrt6=8.2091046 - 5.5 ; 
scalar mnagri6=5.3600234 - 5.5 ; 
scalar mnenvi6=6.0340472 - 5.5 ; 
scalar mnimmi6=6.3846154 - 5.5 ; 
scalar mnpriv6=3.3167396 - 5.5 ; 
scalar mnalco6=4.3503691 - 5.5 ;
scalar mncrim6=3.8951757 - 5.5 ; 

scalar mnlfrt7=8.9091371 - 5.5 ; 
scalar mnagri7=2.1274397 - 5.5 ; 
scalar mnenvi7=7.4254958 - 5.5 ; 
scalar mnimmi7=9.3623566 - 5.5 ; 
scalar mnpriv7=1.7302526 - 5.5 ; 
scalar mnalco7=2.0365651 - 5.5 ;
scalar mncrim7=1.8280722 - 5.5 ; 

replace rlfrt=rlfrt - 5.5 ;
replace ragri=ragri - 5.5 ;
replace renvi=renvi - 5.5 ;
replace rimmi=rimmi - 5.5 ;
replace rpriv=rpriv - 5.5 ;
replace ralco=ralco - 5.5 ;
replace rcrim=rcrim - 5.5 ;

gen penalty1=1.541; 
gen penalty2=0.0;
gen penalty3=0.0;
gen penalty4=0.0;
gen penalty5=0.0;
gen penalty6=0.0;
gen penalty7=3.931; 

gen rlnlfrt=rlfrt*rlfrt ;
gen rlnagri=ragri*ragri ;
gen rlnenvi=renvi*renvi ;
gen rlnimmi=rimmi*rimmi ;
gen rlnpriv=rpriv*rpriv ;
gen rlnalco=ralco*ralco ;
gen rlncrim=rcrim*rcrim ;

replace plfrt1=plfrt1 - 5.5 ;
replace pagri1=pagri1 - 5.5 ;
replace penvi1=penvi1 - 5.5 ;
replace pimmi1=pimmi1 - 5.5 ;
replace ppriv1=ppriv1 - 5.5 ;
replace palco1=palco1 - 5.5 ;
replace pcrim1=pcrim1 - 5.5 ;

replace plfrt2=plfrt2 - 5.5 ;
replace pagri2=pagri2 - 5.5 ;
replace penvi2=penvi2 - 5.5 ;
replace pimmi2=pimmi2 - 5.5 ;
replace ppriv2=ppriv2 - 5.5 ;
replace palco2=palco2 - 5.5 ;
replace pcrim2=pcrim2 - 5.5 ;

replace plfrt3=plfrt3 - 5.5 ;
replace pagri3=pagri3 - 5.5 ;
replace penvi3=penvi3 - 5.5 ;
replace pimmi3=pimmi3 - 5.5 ;
replace ppriv3=ppriv3 - 5.5 ;
replace palco3=palco3 - 5.5 ;
replace pcrim3=pcrim3 - 5.5 ;

replace plfrt4=plfrt4 - 5.5 ;
replace pagri4=pagri4 - 5.5 ;
replace penvi4=penvi4 - 5.5 ;
replace pimmi4=pimmi4 - 5.5 ;
replace ppriv4=ppriv4 - 5.5 ;
replace palco4=palco4 - 5.5 ;
replace pcrim4=pcrim4 - 5.5 ;

replace plfrt5=plfrt5 - 5.5 ;
replace pagri5=pagri5 - 5.5 ;
replace penvi5=penvi5 - 5.5 ;
replace pimmi5=pimmi5 - 5.5 ;
replace ppriv5=ppriv5 - 5.5 ;
replace palco5=palco5 - 5.5 ;
replace pcrim5=pcrim5 - 5.5 ;

replace plfrt6=plfrt6 - 5.5 ;
replace pagri6=pagri6 - 5.5 ;
replace penvi6=penvi6 - 5.5 ;
replace pimmi6=pimmi6 - 5.5 ;
replace ppriv6=ppriv6 - 5.5 ;
replace palco6=palco6 - 5.5 ;
replace pcrim6=pcrim6 - 5.5 ;

replace plfrt7=plfrt7 - 5.5 ;
replace pagri7=pagri7 - 5.5 ;
replace penvi7=penvi7 - 5.5 ;
replace pimmi7=pimmi7 - 5.5 ;
replace ppriv7=ppriv7 - 5.5 ;
replace palco7=palco7 - 5.5 ;
replace pcrim7=pcrim7 - 5.5 ;


/* Initialize gsymp variables */
gen gsymp1=symp1 ;
gen gsymp2=symp2 ;
gen gsymp3=symp3 ;
gen gsymp4=symp4 ;
gen gsymp5=symp5 ;
gen gsymp6=symp6 ;
gen gsymp7=symp7 ;


/* called do routines set to 0 before first call and make first call*/
scalar calldmsm=0;
scalar calldisi=0;

do c:\stata\do\updatemn;
do c:\stata\do\dmsm ;
do c:\stata\do\disi ;


/* set up wide-long data structures */
   reshape j /*groups*/ party 1-7 ;
   reshape xij /*vars*/
      symp gsymp g7symp penalty
      plfrt pagri penvi pimmi ppriv palco pcrim
      dilfrt diagri dienvi diimmi dipriv dialco dicrim
      dixlfrt dixagri dixenvi diximmi dixpriv dixalco dixcrim
      silfrt siagri sienvi siimmi sipriv sialco sicrim
      si2lfrt si2agri si2envi si2immi si2priv si2alco si2crim
      plnlfrt plnagri plnenvi plnimmi plnpriv plnalco plncrim
      dmlfrt dmagri dmenvi dmimmi dmpriv dmalco dmcrim
      dmxlfrt dmxagri dmxenvi dmximmi dmxpriv dmxalco dmxcrim
      smlfrt smagri smenvi smimmi smpriv smalco smcrim
      sm2lfrt sm2agri sm2envi sm2immi sm2priv sm2alco sm2crim
      mlnlfrt mlnagri mlnenvi mlnimmi mlnpriv mlnalco mlncrim
     ;
   reshape i /*cons*/
      idnum 
      ;


/* conduct test regressions */
reshape long ;
regress gsymp  si2lfrt  si2agri  si2envi  si2immi  si2priv  si2alco
               rlnlfrt  rlnagri  rlnenvi  rlnimmi  rlnpriv  rlnalco 
               plnlfrt  plnagri  plnenvi  plnimmi  plnpriv  plnalco ;
regress gsymp  sm2lfrt  sm2agri  sm2envi  sm2immi  sm2priv  sm2alco
               rlnlfrt  rlnagri  rlnenvi  rlnimmi  rlnpriv  rlnalco 
               mlnlfrt  mlnagri  mlnenvi  mlnimmi  mlnpriv  mlnalco ;

reshape wide ;

/* end regression test */

