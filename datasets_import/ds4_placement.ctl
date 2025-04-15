OPTIONS (READSIZE=10000000)
load data 
CHARACTERSET UTF8
infile 'ds4_placement.csv' "str '\r\n'"
append
into table ds4_placement
fields terminated by ','
OPTIONALLY ENCLOSED BY '"' AND '"'
trailing nullcols
           ( id,
             cost,
             PlacementDate DATE "YYYY-MM-DD HH24:MI:SS",
             exclusives,
             placement_type CHAR(4000),
             type_description CHAR(4000),
             ads,
             building CHAR(4000),
             programme CHAR(4000),
             post
           )
