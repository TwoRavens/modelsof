cd c:\DATA\timeuse
use surveys, clear

/*NSSE*/
replace study = .5*(studybin==1)+ 3*(studybin==2)+8*(studybin==3)+13*(studybin==4)+18*(studybin==5)+23*(studybin==6)+28*(studybin==7)+ 32*(studybin==8) if !missing(studybin) &NSSE==1
gen workon1=.5*(workonbin==1)+ 3*(workonbin==2)+8*(workonbin==3)+13*(workonbin==4)+18*(workonbin==5)+23*(workonbin==6)+28*(workonbin==7)+ 32*(workonbin==8) if !missing(workonbin)&NSSE==1
gen workof1=.5*(workofbin==1)+ 3*(workofbin==2)+8*(workofbin==3)+13*(workofbin==4)+18*(workofbin==5)+23*(workofbin==6)+28*(workofbin==7)+ 32*(workofbin==8) if !missing(workofbin)&NSSE==1
replace work=workon1+workof1 if NSSE==1

/* NLSY */
gen studyon=stdyon_hr+stdyon_min/60 if NLSY==1
gen class=class_hr+class_min/60 if NLSY==1
gen studyoff=stdyoff_hr+stdyoff_min/60  if NLSY==1
replace study=studyon+studyoff  if NLSY==1


/* HERI*/
replace study = .5*(studybin==2)+ 1.5*(studybin==3)+4*(studybin==4)+8*(studybin==5)+13*(studybin==6)+18*(studybin==7)+24*(studybin==8) if HERI==1
replace work= .5*(workbin==2)+ 1.5*(workbin==3)+4*(workbin==4)+8*(workbin==5)+13*(workbin==6)+18*(workbin==7)+24*(workbin==8) if HERI==1
replace class = .5*(classbin==2)+ 1.5*(classbin==3)+4*(classbin==4)+8*(classbin==5)+13*(classbin==6)+18*(classbin==7)+24*(classbin==8) if HERI==1

/*ALL*/
gen hrstr=study if Talent2==1
gen hrsny=study if NLSY==1
gen hrsn=study if NSSE==1
gen hrsh=study if HERI==1
gen hrst=study if Talent==1

/*TABLE 3*/
ttest hrst = hrsn, unp unequal
ttest hrst = hrsh, unp unequal
ttest hrstr = hrsny, unp unequal
