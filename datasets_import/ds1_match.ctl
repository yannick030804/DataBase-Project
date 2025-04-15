load data 
CHARACTERSET UTF8
infile 'ds1_match.csv' "str '\r\n'"
append
into table ds1_match
fields terminated by ','
OPTIONALLY ENCLOSED BY '"' AND '"'
trailing nullcols
           ( match_id CHAR(4000),
             match_date DATE "YYYY-MM-DD HH24:MI",
             home CHAR(4000),
             away CHAR(4000),
             home_poss "translate(:home_poss, '.', ',' ) " ,
             away_poss "translate(:away_poss, '.', ',' ) " ,
             home_manager CHAR(4000),
             home_gender CHAR(4000),
             home_date DATE "YYYY-MM-DD",
             home_manager_city CHAR(4000),
             home_style CHAR(4000),
             home_tactics CHAR(4000),
             away_manager CHAR(4000),
             away_gender CHAR(4000),
             away_date DATE "YYYY-MM-DD",
             away_manager_city CHAR(4000),
             away_style CHAR(4000),
             away_tactics CHAR(4000),
             venue CHAR(4000),
             attendance "translate(:attendance, '.', ',' ) " ,
             city CHAR(4000),
             referee CHAR(4000),
             ar1 CHAR(4000),
             ar2 CHAR(4000),
             fourth CHAR(4000),
             var CHAR(4000),
             league CHAR(4000),
             gender CHAR(4000),
             season CHAR(4000),
             referee_cert CHAR(4000),
             ar1_cert CHAR(4000),
             ar2_cert CHAR(4000),
             fourth_cert CHAR(4000),
             var_cert CHAR(4000),
			 home_city CHAR(4000),
			 away_city CHAR(4000)
           )
