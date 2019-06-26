oprobit  PHYSINT   LEGELEC  NATLOG_NEW_POPSZ NATLOG_NEW_GDPCAP  TYPE2  newdomcon , robust

oprobit  PHYSINT    elect1lag  NATLOG_NEW_POPSZ NATLOG_NEW_GDPCAP  TYPE2  newdomcon if YYEAR>1980, robust

prvalue, x( elect1lag=0) rest(mean)

prvalue, x( elect1lag=1) rest(mean)

oprobit  PHYSINT    elect2lag  NATLOG_NEW_POPSZ NATLOG_NEW_GDPCAP  TYPE2  newdomcon if YYEAR>1981, robust

oprobit  PHYSINT    elect3lag  NATLOG_NEW_POPSZ NATLOG_NEW_GDPCAP  TYPE2  newdomcon if YYEAR>1982, robust



oprobit  PHYSINT    PRESELEC  XCONST NATLOG_NEW_POPSZ NATLOG_NEW_GDPCAP  TYPE2  newdomcon if  INSTITUTION>1 , robust

oprobit  PHYSINT     preselect1lag  XCONST NATLOG_NEW_POPSZ NATLOG_NEW_GDPCAP  TYPE2  newdomcon if  INSTITUTION>1 & YYEAR>1980 , robust

prvalue, x( preselect1lag=0) rest(mean)

prvalue, x( preselect1lag=1) rest(mean)

oprobit  PHYSINT     preselect2lag  XCONST NATLOG_NEW_POPSZ NATLOG_NEW_GDPCAP  TYPE2  newdomcon if  INSTITUTION>1 & YYEAR>1981 , robust

oprobit  PHYSINT     preselect3lag  XCONST NATLOG_NEW_POPSZ NATLOG_NEW_GDPCAP  TYPE2  newdomcon if  INSTITUTION>1 & YYEAR>1982 , robust




oprobit  PHYSINT     PRESELEC LEGELEC  NATLOG_NEW_POPSZ NATLOG_NEW_GDPCAP  TYPE2  newdomcon if  INSTITUTION>1, robust

oprobit  PHYSINT    elect1lag preselect1lag  NATLOG_NEW_POPSZ NATLOG_NEW_GDPCAP  TYPE2  newdomcon if  INSTITUTION>1 &  YYEAR>1980, robust

oprobit  PHYSINT    elect2lag preselect2lag  NATLOG_NEW_POPSZ NATLOG_NEW_GDPCAP  TYPE2  newdomcon if  INSTITUTION>1 &  YYEAR>1981, robust

oprobit  PHYSINT    elect3lag preselect3lag  NATLOG_NEW_POPSZ NATLOG_NEW_GDPCAP  TYPE2  newdomcon if  INSTITUTION>1 &  YYEAR>1982, robust