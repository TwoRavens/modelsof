
clear
#delimit ;
set more off;
*set maxvar 2500;
set mem 800m;
set matsize 800;
cd "F:\Abbie Drug Testing\NHSDU\drugdataallyears";



use MJ* MR*  *MJRC SUM* MO*   *MJ  RSKMJ* GRSKM* *MRJ BOOKED  MM* *MJ2 NOBOOKY2 SNFAMJEV YEPMJ* YEGMJ* QUESTID
YEFMJ* *YOSELL2 FRDM* PRVDRGO2 GRPCNSL2 INCOME QUESTID   POVERTY AGE2 NOMARR2 HEALTH WRK* JBSTATR2 IRPINC3
LOCSIZE DRGPLCY PLCYCOV WKDRGED DRGPRGM USALCTST TST* FIRSTPOS WORKRAND PDEN MOVESPY2 CATAG* NEWRACE2
EDUC* SCH* HSGED LF* COLL* SEX*  INHYR INHMON ANLYR ANLMON STMYR STMMON SEDYR SEDMON IEMFLAG 
IEMYR IEMMON EMPSTAT*  NEWRACE2 IRSEX* USDRGTST using sas06  ;
gen surveyyr=2006;








append using sas05, keep(MJ* MR*  *MJRC SUM* MO*   *MJ  RSKMJ* GRSKM* *MRJ BOOKED NOBOOKY2 MM* *MJ2  SNFAMJEV YEPMJ* YEGMJ* YEFMJ* *YOSELL2 FRDM* PRVDRGO2 GRPCNSL2 IRPINC3 QUESTID   AGE2 NOMARR2 HEALTH WRK* JBSTATR2
LOCSIZE DRGPLCY PLCYCOV WKDRGED DRGPRGM USALCTST TST* FIRSTPOS WORKRAND PDEN MOVESPY2 CATAG* NEWRACE2
EDUC* SCH*  HSGED LF* COLL* SEX* AGE2 INHYR INHMON ANLYR ANLMON STMYR STMMON SEDYR SEDMON IEMFLAG IEMYR IEMMON EMPSTAT*   NEWRACE2 IRSEX* USDRGTST );
replace surveyyr=2005 if surveyyr==.;


append using sas04, keep(MJ* MR*  *MJRC SUM* MO*   *MJ  RSKMJ* GRSKM* *MRJ BOOKED NOBOOKY2 MM* *MJ2  SNFAMJEV YEPMJ* YEGMJ* YEFMJ* *YOSELL2 FRDM* PRVDRGO2 GRPCNSL2 IRPINC3 QUESTID   POVERTY AGE2 NOMARR2 HEALTH WRK* JBSTATR2
LOCSIZE DRGPLCY PLCYCOV WKDRGED DRGPRGM USALCTST TST* FIRSTPOS WORKRAND PDEN MOVESPY2 CATAG* NEWRACE2
EDUC* SCH*  HSGED LF* COLL* SEX*  AGE2 INHYR INHMON ANLYR ANLMON STMYR STMMON SEDYR SEDMON IEMFLAG IEMYR IEMMON EMPSTAT*   NEWRACE2 IRSEX* USDRGTST );
replace surveyyr=2004 if surveyyr==.;


append using sas03, keep(MJ* MR*  *MJRC SUM* MO*   *MJ  RSKMJ* GRSKM* *MRJ BOOKED   NOBOOKY2 MM* *MJ2  SNFAMJEV YEPMJ* YEGMJ* YEFMJ* *YOSELL2 FRDM* PRVDRGO2 GRPCNSL2 IRPINC3 QUESTID   POVERTY AGE2 NOMARR2 HEALTH WRK* JBSTATR2
LOCSIZE DRGPLCY PLCYCOV WKDRGED DRGPRGM USALCTST TST* FIRSTPOS WORKRAND PDEN MOVESPY2 CATAG* NEWRACE2
EDUC* SCH*  HSGED LF* COLL* SEX*  AGE2  INHYR INHMON ANLYR ANLMON STMYR STMMON SEDYR SEDMON IEMFLAG IEMYR IEMMON EMPSTAT*   NEWRACE2 IRSEX* USDRGTST );
replace surveyyr=2003 if surveyyr==.;

*compress;

append using sas02, keep(MJ* MR*  *MJRC SUM* MO*   *MJ  RSKMJ* GRSKM* *MRJ BOOKED NOBOOKY2 MM* *MJ2  SNFAMJEV YEPMJ* YEGMJ* YEFMJ* *YOSELL2 FRDM* PRVDRGO2 GRPCNSL2 IRPINC3 QUESTID   AGE2 NOMARR2 HEALTH WRK* JBSTATR2
LOCSIZE DRGPLCY PLCYCOV WKDRGED DRGPRGM USALCTST TST* FIRSTPOS WORKRAND PDEN MOVESPY2 CATAG* NEWRACE2
EDUC* SCH*  HSGED LF* COLL* SEX* AGE2  INHYR INHMON ANLYR ANLMON STMYR STMMON SEDYR SEDMON IEMFLAG IEMYR IEMMON EMPSTAT*   NEWRACE2 IRSEX* USDRGTST );
replace surveyyr=2002 if surveyyr==.;


append using sas01, keep(MJ* MR*  *MJRC SUM* MO*   *MJ  RSKMJ* GRSKM* *MRJ BOOKED NOBOOKY2 MM* *MJ2  SNFAMJEV YEPMJ* YEGMJ* YEFMJ* *YOSELL2 FRDM* PRVDRGO2 GRPCNSL2 *INC* QUESTID    AGE2 NOMARR2 HEALTH WRK* JBSTATR2
LOCSIZE DRGPLCY PLCYCOV WKDRGED DRGPRGM USALCTST TST* FIRSTPOS WORKRAND PDEN MOVESPY2 CATAG* NEWRACE2
EDUC* SCH*  HSGED LF* COLL*  AGE2  INHYR INHMON ANLYR ANLMON STMYR STMMON SEDYR SEDMON IEMFLAG IEMYR IEMMON EMPSTAT*   NEWRACE2 IRSEX* USDRGTST );
replace surveyyr=2001 if surveyyr==.;


append using sas00, keep(MJ* MR*  *MJRC SUM* MO*   *MJ  RSKMJ* GRSKM* *MRJ BOOKED NOBOOKY2  *MJ2  SNFAMJEV YEPMJ* YEGMJ*  *YOSELL2  PRVDRGO2 GRPCNSL2 *INC* QUESTID    AGE2 NOMARR2 HEALTH WRK* JBSTATR2
LOCSIZE DRGPLCY PLCYCOV WKDRGED DRGPRGM USALCTST TST* FIRSTPOS WORKRAND PDEN MOVESPY2 CATAG* NEWRACE2
EDUC* SCH*  HSGED LF* COLL*  AGE2  INHYR INHMON ANLYR ANLMON STMYR STMMON SEDYR SEDMON IEMFLAG IEMYR IEMMON EMPSTAT*   NEWRACE2 IRSEX* USDRGTST );
replace surveyyr=2000 if surveyyr==.;

*RENAMING VARIABLES*;
do renamenoIR.do;





append using sas99, keep( mj* mr*  *mjrc *mjfm sum* mo*  *mj  rskmj* grskm* *mrj booked nobooky2    snfamjev  questid
yepmj* yegmj* yefmj*   frdm*   age* nomarr2 health wrk* jbstatr2 
locsize drgplcy plcycov wkdrged drgprgm usalctst usdrgtst tst* firstpos workrand pden  movespy2 catag* newrace2 
educ* sch*  hsged lf* coll* inhyr inhmon anlyr anlmon stmyr stmmon sedyr sedmon iemflag iemyr iemmon *inc* questid   age2 irsex newrace2 empstat* bus*);
replace surveyyr=1999 if surveyyr==.;

*compress;

append using sas98, keep( mj* mr*  *mjrc sum* mo*  *mj  rskmj*  *mrj booked    snfamjev  *inc* respid  region divis2
yepmj* yegmj* yefmj*   frdm*  nomarr2 health wrk* 
locsize drgplcy plcycov drgprgm usalctst usdrgtst tst*  pden  movespy2 catag*  
educ* sch*  lf* inhyr inhmon anlyr anlmon stmyr stmmon sedyr sedmon iemflag iemyr iemmon irage* irsex irrace empstat* busines* irhoind);
replace surveyyr=1998 if surveyyr==.;

append using sas97, keep( mj* mr*  *mjrc  sum* mo*  *mj  rskmj*  *mrj booked     *inc* respid  region division
  health wrk* locsize drgplcy plcycov  drgprgm usalctst usdrgtst tst*   pden catag*  
educ* sch*  lf*  inhyr inhmon anlyr anlmon stmyr stmmon sedyr sedmon iemflag iemyr iemmon irage* irsex* irrace* empstat* busines* irhoind);
replace surveyyr=1997 if surveyyr==.;


append using sas96, keep( mj* mr*  *mjrc  sum* mo*  *mj  rskmj*  *mrj booked  *inc* respid    region division 
  health w*       pden catag*  
educ* inhyr inhmon anlyr anlmon stmyr stmmon sedyr sedmon iemflag iemyr iemmon irage* irsex* irrace* empstat*  irhoind);
replace surveyyr=1996 if surveyyr==.;


append using sas95, keep( mj* mr*  *mjrc  sum* mo*  *mj     booked   *inc* respid    region division
   w*    pden catag*  
educ*    inhyr inhmon anlyr anlmon stmyr stmmon sedyr sedmon iemflag iemyr iemmon irage* irsex* irrace* empstat* busines* irhoind);
replace surveyyr=1995 if surveyyr==.;

*compress;

append using sas94, keep( mj* mr*  *mjrc  sum* mo*  *mj     booked     *inc* respid  region division
   w*    pden catag*  
educ*   inhyr inhmon anlyr anlmon stmyr stmmon sedyr sedmon iemflag iemyr iemmon irage* irsex* irrace* empstat* busines* irhoind);
replace surveyyr=1994 if surveyyr==.;

append using sas93, keep( mj* mr*  *mjrc  sum* mo*  *mj     booked    *inc* respid   region division
   w*    pden catag*  
educ*   inhyr inhmon anlyr anlmon stmyr stmmon sedyr sedmon iemflag iemyr iemmon irage* irsex* irrace* empstat* busines* irhoind);
replace surveyyr=1993 if surveyyr==.;

append using sas92, keep( mj* mr*  *mjrc  sum* mo*  *mj     booked     *inc* respid  region division
   w*    pden catag*  
educ*   inhyr inhmon anlyr anlmon stmyr stmmon sedyr sedmon iemflag iemyr iemmon irage* irsex* irrace* empstat* busines* irhoind);
replace surveyyr=1992 if surveyyr==.;

append using sas91, keep( mj* mr*  *mjrc  sum* mo*  *mj     booked   w*  *inc* respid  region division  pden catag*  educ*    inhyr inhmon anlyr anlmon stmyr stmmon sedyr sedmon iemflag iemyr iemmon irage* irsex* irrace* empstat* busines* irhoind);
replace surveyyr=1991 if surveyyr==.;

append using sas90, keep( mj* mr*  *mjrc  sum* mo*  *mj        w*    catag*  educ*  *inc* respid  region division   inhyr inhmon anlyr anlmon stmyr stmmon sedyr sedmon  irage* irsex* irrace* empstat* busines* irhoind);
replace surveyyr=1990 if surveyyr==.;


append using sas88, keep( mj* mr*  *mjrc  sum* mo*  *mj      w*    catag*  educ*  *inc* respid  region division  inhyr inhmon anlyr anlmon stmyr stmmon sedyr sedmon   irage* sex irrace* empstat* busines* irhoind);
replace surveyyr=1988 if surveyyr==.;

append using sas85, keep( mj* mr*  *mjrc  sum* mo*  *mj      w*    catag*  educ* *inc* respid   region division  inhyr inhmon anlyr anlmon stmyr stmmon sedyr sedmon   irage* sex irrace* empstat* busines* irhoind);
replace surveyyr=1985 if surveyyr==.;

append using sas82, keep( mj* mr*  *mjrc  sum* mo*  *mj      w*    catag*  educ*  *inc* respid   region division  anlyr anlmon stmyr stmmon sedyr sedmon   irage* sex irrace* nolabor employ30 irhoind);
replace surveyyr=1982 if surveyyr==.;





append using sas79, keep( mj* mr*  *mjrc  sum* mo*  *mj  nolabor employed    w*    catag*  educ*  *inc* respid  region division  inhyr inhmon anlyr anlmon stmyr stmmon sedyr sedmon   irage* sex irrace* nolabor irhoind);
replace surveyyr=1979 if surveyyr==.;

compress;


save ALLYEARS12_1_10.dta, replace;