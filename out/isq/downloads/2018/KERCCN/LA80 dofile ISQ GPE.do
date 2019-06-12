Table 2 - models 1-4
xtlogit newagr lntotdbt lnintgnp rsvsimqt1 lninflt1 govorient burqual regime gdpcap prevprogtyt1 y82 y83 y84 y85 y86 y87 y88  nagdur agspline1 agspline2 agspline3 if elig2==1&lnimfquot>0
xtlogit newagr burqual  rsvsimqt1  lnintgnp lntotimpt1 regime govorient lninflt1 gdpcap prevprogtyt1 y82 y83 y84 y85 y86 y87 y88  nagdur agspline1 agspline2 agspline3 if elig2==1&lnimfquot>0
xtlogit newagr burqual rsvsimqt1 lnintgnp bigdesp lntotdbt  regime govorient lninflt1 gdpcap prevprogtyt1 y82 y83 y84 y85 y86 y87 y88  nagdur agspline1 agspline2 agspline3 if elig2==1&lnimfquot>0
xtlogit newagr burqual  rsvsimqt1 lnintgnp imptotdesp lntotimpt1  regime govorient lninflt1 gdpcap prevprogtyt1 y82 y83 y84 y85 y86 y87 y88  nagdur agspline1 agspline2 agspline3 if elig2==1&lnimfquot>0


Table 3 - models 1-2
xtlogit newagr lnusimpt1 unvot1 lnintgnp rsvsimqt1 lninflt1  govorient burqual regime gdpcap prevprogtyt1 y82 y83 y84 y85 y86 y87 y88  nagdur agspline1 agspline2 agspline3 if elig2==1&lnimfquot>0
xtlogit newagr  lnodaust1 unvot1 unvot12 lnintgnp rsvsimqt1 lninflt1  govorient burqual regime gdpcap prevprogtyt1 y82 y83 y84 y85 y86 y87 y88  nagdur agspline1 agspline2 agspline3 if elig2==1&lnimfquot>0

Table 3 - models 1-3
xtpcse bcpromquot lntotdbt lnintgnp rsvsimqt1 lninflt1 regime govorient burqual gdpcap prevprogtyt1 y82-y88 if newagr==1, hetonly
xtpcse bcpromquot lntotdbt  bigdesp  lnintgnp rsvsimqt1 lninflt1 regime govorient burqual gdpcap prevprogtyt1 y82-y88 if newagr==1, hetonly
xtpcse bcpromquot lnusimpt1 lnodaus unvot1 lnintgnp rsvsimqt1 lninflt1 regime govorient burqual gdpcap prevprogtyt1 y82-y88 if newagr==1, hetonly

Table 4 - models 1-3
xtlogit active lntotdbt unvot1  lnintgnp rsvsimqt1 lninflt1 lninflt12 regime govorient burqual gdpcap mills5d y82-y88  faildur failspline1 failspline2 failspline3 if agr==1
xtlogit active  rsvsimqt1  lnintgnp bigdesp  lntotdbt burqual  regime govorient lninflt1 lninflt12 gdpcap mills5f y82-y88  faildur failspline1 failspline2 failspline3 if agr==1
xtlogit active  rsvsimqt1  lnintgnp lnodaus lnusimpt1 burqual  regime govorient lninflt1 lninflt12 gdpcap mills5cu y82-y88  faildur failspline1 failspline2 failspline3 if agr==1
 
