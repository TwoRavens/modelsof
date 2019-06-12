set more off 

/* Table B in Appendix */
mlogit immpolinew protest_period pprhispx ppehhscx latcomm generation american national_origin language_skills knowledge catholic community_participate attend_church cuba pr dr south central age female edu incomeq_dummy1 incomeq_dummy3 incomeq_dummy4 incomeq_dummy5 perfin samplestate1- samplestate16  [pw=wt_nation_rev], cluster (metro_county_code)

/* Table 1 in Article  and Table F in Appendix*/
prvalue, x(protest_period=0) rest(mean) save level(99)
prvalue, x(protest_period=1) rest(mean) diff level(99)

/* Table C in Appendix */
mlogit immpolinew protest_period protest_generation pprhispx ppehhscx latcomm generation american national_origin language_skills knowledge catholic community_participate attend_church cuba pr dr south central age female edu incomeq_dummy1 incomeq_dummy3 incomeq_dummy4 incomeq_dummy5 perfin samplestate1- samplestate16  [pw=wt_nation_rev], cluster (metro_county_code)

/* Table 2 in Article  and Table G in Appendix*/
prvalue, x(protest_period=0 protest_generation=0 generation=0) rest(mean) save
prvalue, x(protest_period=1 protest_generation=0 generation=0) rest(mean) diff

prvalue, x(protest_period=0 protest_generation=0 generation=1) rest(mean) save
prvalue, x(protest_period=1 protest_generation=1 generation=1) rest(mean) diff

prvalue, x(protest_period=0 protest_generation=0 generation=2) rest(mean) save
prvalue, x(protest_period=1 protest_generation=2 generation=2) rest(mean) diff

prvalue, x(protest_period=0 protest_generation=0 generation=3) rest(mean) save
prvalue, x(protest_period=1 protest_generation=3 generation=3) rest(mean) diff

prvalue, x(protest_period=0 protest_generation=0 generation=4) rest(mean) save
prvalue, x(protest_period=1 protest_generation=4 generation=4) rest(mean) diff

#delimit ;
set more off ;
/* Table D in Appendix */
mlogit immpolinew metro_county_protest metco_generation  pprhispx ppehhscx latcomm generation american national_origin language_skills knowledge catholic community_participate attend_church  cuba pr dr south central age female edu incomeq_dummy1 incomeq_dummy3 incomeq_dummy4 incomeq_dummy5 perfin samplestate1- samplestate16 if protest_period==1  [pw=wt_nation_rev], cluster (metro_county_code);

/* Table 3 in Article  and Table H in Appendix*/
prvalue, x(metro_county_protest=0 metco_generation=0 generation=0) rest(mean) save;
prvalue, x(metro_county_protest=1 metco_generation=0 generation=0) rest(mean) diff;

prvalue, x(metro_county_protest=0 metco_generation=0 generation=1) rest(mean) save;
prvalue, x(metro_county_protest=1 metco_generation=1 generation=1) rest(mean) diff;

prvalue, x(metro_county_protest=0 metco_generation=0 generation=2) rest(mean)  save;
prvalue, x(metro_county_protest=1 metco_generation=2 generation=2) rest(mean)  diff;

prvalue, x(metro_county_protest=0 metco_generation=0 generation=3) rest(mean)  save;
prvalue, x(metro_county_protest=1 metco_generation=3 generation=3) rest(mean)  diff;

prvalue, x(metro_county_protest=0 metco_generation=0 generation=4) rest(mean)  save;
prvalue, x(metro_county_protest=1 metco_generation=4 generation=4) rest(mean)  diff;

#delimit ;
set more off ;
/* Table E in Appendix */
mlogit immpolinew co_met_num_protest pprhispx ppehhscx comet_numprot_generation  latcomm generation american national_origin language_skills knowledge catholic community_participate attend_church  cuba pr dr south central age female edu incomeq_dummy1 incomeq_dummy3 incomeq_dummy4 incomeq_dummy5 perfin samplestate1- samplestate16 if protest_period==1 & co_met_num_protest [pw=wt_nation_rev], cluster (metro_county_code);

/* Table 4 in Article  and Table I in Appendix*/
prvalue, x(co_met_num_protest=1  comet_numprot_generation=0 generation=0) rest(mean)  save;
prvalue, x(co_met_num_protest=13 comet_numprot_generation=0 generation=0) rest(mean)  diff;

prvalue, x(co_met_num_protest=1  comet_numprot_generation=1  generation=1) rest(mean) save;
prvalue, x(co_met_num_protest=13 comet_numprot_generation=13 generation=1) rest(mean) diff;

prvalue, x(co_met_num_protest=1  comet_numprot_generation=2  generation=2) rest(mean)  save;
prvalue, x(co_met_num_protest=13 comet_numprot_generation=26 generation=2) rest(mean) diff;

prvalue, x(co_met_num_protest=1  comet_numprot_generation=3  generation=3) rest(mean)  save;
prvalue, x(co_met_num_protest=13 comet_numprot_generation=39 generation=3) rest(mean) diff;

prvalue, x(co_met_num_protest=1  comet_numprot_generation=4  generation=4) rest(mean)  save;
prvalue, x(co_met_num_protest=13 comet_numprot_generation=52 generation=4) rest(mean) diff;


