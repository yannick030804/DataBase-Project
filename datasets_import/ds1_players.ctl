load data 
CHARACTERSET UTF8
infile 'ds1_players.csv' "str '\r\n'"
append
into table ds1_players
fields terminated by ','
OPTIONALLY ENCLOSED BY '"' AND '"'
trailing nullcols
           ( name CHAR(4000),
             Height "translate(:Height, '.', ',' ) " ,
             Weight "translate(:Weight, '.', ',' ) " ,
             Footed CHAR(4000),
             BirthDate DATE "RRRR-MM-DD",
             City CHAR(4000),
             club CHAR(4000),
             match_id CHAR(4000),
             position CHAR(4000),
             goals,
             assists,
             shots,
             shots_on_target,
             yellow_cards,
             red_cards
           )
