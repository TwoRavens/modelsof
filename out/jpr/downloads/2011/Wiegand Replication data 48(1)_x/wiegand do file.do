logit terrmiddv othermid rivalry milbal majorpowerch contigdum strvalch ecovalch ethvalch netdemch y1920 y1921 y1922 y1923 y1924 y1925 y1926 y1927 y1928 y1929 y1930 y1931 y1932 y1933 y1934 y1935 y1936 y1937 y1938 y1939 y1940 y1941 y1942 y1943 y1944 y1945 y1946 y1947 y1948 y1949 y1950 y1951 y1952 y1953 y1954 y1955 y1956 y1957 y1958 y1959 y1960 y1961 y1962 y1963 y1964 y1965 y1966 y1967 y1968 y1969 y1970 y1971 y1972 y1973 y1974 y1975 y1976 y1977 y1978 y1979 y1980 y1981 y1982 y1983 y1984 y1985 y1986 y1987 y1988 y1989 y1990 y1991 y1992 y1993 y1994 y1995, cluster (challenger)
ologit terrmidesc othermid rivalry milbal majorpowerch contigdum strvalch ecovalch ethvalch netdemch y1920 y1921 y1922 y1923 y1924 y1925 y1926 y1927 y1928 y1929 y1930 y1931 y1932 y1933 y1934 y1935 y1936 y1937 y1938 y1939 y1940 y1941 y1942 y1943 y1944 y1945 y1946 y1947 y1948 y1949 y1950 y1951 y1952 y1953 y1954 y1955 y1956 y1957 y1958 y1959 y1960 y1961 y1962 y1963 y1964 y1965 y1966 y1967 y1968 y1969 y1970 y1971 y1972 y1973 y1974 y1975 y1976 y1977 y1978 y1979 y1980 y1981 y1982 y1983 y1984 y1985 y1986 y1987 y1988 y1989 y1990 y1991 y1992 y1993 y1994 y1995, cluster (challenger)

estsimp logit terrmiddv othermid netdemch rivalry contigdum ethvalch strvalch ecovalch majorpowerch milbal, cluster (challenger)
setx othermid 0 netdemch -1.979164 contigdum 0 strvalch 0 ecovalch 1 ethvalch 1 rivalry 0  majorpowerch 0 milbal  7.776558
simqi, pr
setx othermid 1 netdemch -1.979164 contigdum 0 strvalch 0 ecovalch 1 ethvalch 1 rivalry 0  majorpowerch 0  milbal 7.776558
simqi, pr
setx othermid 0 netdemch -10 contigdum 0 strvalch 0 ecovalch 1 ethvalch 1 rivalry 0  majorpowerch 0  milbal 7.776558
simqi, pr
setx othermid 0 netdemch 10 contigdum 0 strvalch 0 ecovalch 1 ethvalch 1 rivalry 0  majorpowerch 0  milbal 7.776558
simqi, pr
setx othermid 0 netdemch -1.979164 contigdum 0 strvalch 0 ecovalch 1 ethvalch 1 rivalry 0  majorpowerch 0  milbal 7.776558
simqi, pr
setx othermid 0 netdemch -1.979164 contigdum 1 strvalch 0 ecovalch 1 ethvalch 1 rivalry 0  majorpowerch 0  milbal 7.776558
simqi, pr
setx othermid 0 netdemch -1.979164 contigdum 0 strvalch 1 ecovalch 1 ethvalch 1 rivalry 0  majorpowerch 0  milbal 7.776558
simqi, pr
setx othermid 0 netdemch -1.979164 contigdum 0 strvalch 0 ecovalch 0 ethvalch 1 rivalry 0  majorpowerch 0  milbal 7.776558
simqi, pr
setx othermid 0 netdemch -1.979164 contigdum 0 strvalch 0 ecovalch 1 ethvalch 0 rivalry 0  majorpowerch 0  milbal 7.776558
simqi, pr
setx othermid 0 netdemch -1.979164 contigdum 0 strvalch 0 ecovalch 1 ethvalch 1 rivalry 1  majorpowerch 0  milbal 7.776558
simqi, pr
setx othermid 0 netdemch -1.979164 contigdum 0 strvalch 0 ecovalch 1 ethvalch 1 rivalry 0 majorpowerch 0  milbal 7.776558
simqi, pr
setx othermid 0 netdemch -1.979164 contigdum 0 strvalch 0 ecovalch 1 ethvalch 1 rivalry 0  majorpowerch 1  milbal 7.776558
simqi, pr
setx othermid 0 netdemch -1.979164 contigdum 0 strvalch 0 ecovalch 1 ethvalch 1 rivalry 0 majorpowerch 1  milbal 1.000014
simqi, pr
setx othermid 0 netdemch -1.979164 contigdum 0 strvalch 0 ecovalch 1 ethvalch 1 rivalry 0  majorpowerch 1  milbal 274.6595
simqi, pr

drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10

save,replace

estsimp ologit terrmidesc othermid netdemch rivalry contigdum ethvalch strvalch ecovalch majorpowerch milbal, cluster (challenger)
setx othermid 0 netdemch -1.979164 contigdum 0   strvalch 0 ecovalch 1 ethvalch 1 rivalry 0  majorpowerch 0 milbal  7.776558
simqi, pr
setx othermid 1 netdemch -1.979164 contigdum 0 strvalch 0 ecovalch 1 ethvalch 1 rivalry 0  majorpowerch 0  milbal 7.776558
simqi, pr
setx othermid 0 netdemch -10 contigdum 0 strvalch 0 ecovalch 1 ethvalch 1 rivalry 0  majorpowerch 0  milbal 7.776558
simqi, pr
setx othermid 0 netdemch 10 contigdum 0 strvalch 0 ecovalch 1 ethvalch 1 rivalry 0  majorpowerch 0  milbal 7.776558
simqi, pr
setx othermid 0 netdemch -1.979164 contigdum 0 strvalch 0 ecovalch 1 ethvalch 1 rivalry 0  majorpowerch 0  milbal 7.776558
simqi, pr
setx othermid 0 netdemch -1.979164 contigdum 1 strvalch 0 ecovalch 1 ethvalch 1 rivalry 0  majorpowerch 0  milbal 7.776558
simqi, pr
setx othermid 0 netdemch -1.979164 contigdum 0 strvalch 1 ecovalch 1 ethvalch 1 rivalry 0  majorpowerch 0  milbal 7.776558
simqi, pr
setx othermid 0 netdemch -1.979164 contigdum 0 strvalch 0 ecovalch 0 ethvalch 1 rivalry 0  majorpowerch 0  milbal 7.776558
simqi, pr
setx othermid 0 netdemch -1.979164 contigdum 0 strvalch 0 ecovalch 1 ethvalch 0 rivalry 0  majorpowerch 0  milbal 7.776558
simqi, pr
setx othermid 0 netdemch -1.979164 contigdum 0 strvalch 0 ecovalch 1 ethvalch 1 rivalry 1  majorpowerch 0  milbal 7.776558
simqi, pr
setx othermid 0 netdemch -1.979164 contigdum 0 strvalch 0 ecovalch 1 ethvalch 1 rivalry 0 majorpowerch 0  milbal 7.776558
simqi, pr
setx othermid 0 netdemch -1.979164 contigdum 0 strvalch 0 ecovalch 1 ethvalch 1 rivalry 0  majorpowerch 1  milbal 7.776558
simqi, pr
setx othermid 0 netdemch -1.979164 contigdum 0 strvalch 0 ecovalch 1 ethvalch 1 rivalry 0 majorpowerch 0  milbal 1.000014
simqi, pr
setx othermid 0 netdemch -1.979164 contigdum 0 strvalch 0 ecovalch 1 ethvalch 1 rivalry 0  majorpowerch 0  milbal 274.6595
simqi, pr

drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12

save,replace

