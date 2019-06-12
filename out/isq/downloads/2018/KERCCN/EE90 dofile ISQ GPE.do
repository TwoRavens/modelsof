
Table 2 - models 9-12
xtlogit newagr lntotdbt lnintgni rsvsimqt1 lninflt3 pcnat burqual  regime gdpcap prevprogtyt1 y1990-y2000 nagdur agspline1 agspline2 agspline3 if elig==1&lnimfquot>0
xtlogit newagr lntotimp lnintgni rsvsimqt1 lninflt3 pcnat burqual  regime gdpcap prevprogtyt1 y1990-y2000 nagdur agspline1 agspline2 agspline3 if elig==1&lnimfquot>0
xtlogit newagr lntotdbt bigrsvs rsvsimqt1 lnintgni burqual gdpcap regime pcnat lninflt3 prevprogtyt1 y1990-y2000  nagdur agspline1 agspline2 agspline3 if elig==1&lnimfquot>0
xtlogit newagr imprsvs lntotimp burqual rsvsimqt1 gdpcap lnintgni regime pcnat lninflt3 prevprogtyt1 y1990-y2000  nagdur agspline1 agspline2 agspline3 if elig==1&lnimfquot>0


Table 3 - models 5-6
xtlogit newagr lneuimpt1 unvot1 lnintgni rsvsimqt1 lninflt3  pcnat burqual  regime gdpcap prevprogtyt1 y1990-y2000 nagdur agspline1 agspline2 agspline3 if elig==1&lnimfquot>0
xtlogit newagr  lnodaust1 unvot1 unvot12imp unvot12mis lnintgni rsvsimqt1 lninflt3  pcnat burqual  regime gdpcap prevprogtyt1 y1990-y2000 nagdur agspline1 agspline2 agspline3 if elig==1&lnimfquot>0


Table 4 - models 7-11
xtpcse bcpromquot lntotdbt lnintgni rsvsimqt1 lninflt1 regime pcnat burqual gdpcap prevprogtyt1 y1990-y2000 if newagr==1, hetonly
xtpcse bcpromquot lntotdbt bigrsvs lnintgni rsvsimqt1 lninflt1 regime pcnat burqual gdpcap prevprogtyt1 y1990-y2000 if newagr==1, hetonly
xtpcse bcpromquot lneuimpt1 lnodaus unvot1 lnintgni rsvsimqt1 lninflt1 regime pcnat burqual gdpcap prevprogtyt1 y1990-y2000 if newagr==1, hetonly
zip numwav numtotcon lntotdbt unvot1 lnintgni rsvsimqt1 lninflt1 regime pcnat burqual gdpcap prevprogtyt1 y1993-y1997, inflate (burqual regime lninflt1 pcnat y1993-y1997) cluster(ctry)robust
zip numwav numtotcon unvot1 lninflt1 rsvsimqt1 lnintgni lneuimpt1 lnodaus regime pcnat burqual gdpcap prevprogtyt1 y1993-y1997, inflate (burqual regime lninflt1 pcnat y1993-y1995) cluster(ctry)robust

Table 5 - models 7-8
xtlogit active lntotdbt unvot1 lnintgni rsvsimqt1 lninflt1 lninflchg12 regime pcnat burqual gdpcap mills3c2 y1990-y2000  faildur failspline1 failspline2 failspline3 if agr==1
xtlogit active  rsvsimqt1  lnintgni lneuimpt1 lnodaus burqual  regime pcnat lninflt1 lninflchg12 gdpcap mills4h y1990-y2000  faildur failspline1 failspline2 failspline3 if agr==1
