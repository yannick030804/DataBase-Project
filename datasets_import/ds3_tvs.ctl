load data 
CHARACTERSET UTF8
infile 'ds3_tvs.csv' "str '\n'"
append
into table ds3_tvs
fields terminated by ','
OPTIONALLY ENCLOSED BY '"' AND '"'
trailing nullcols
           ( name_of_media_group CHAR(4000),
             description_of_media_group CHAR(4000),
             headquarters_of_the_media_group CHAR(4000),
             title_of_the_tv_channel CHAR(4000),
             video_quality_of_the_tv_channel CHAR(4000),
             programme CHAR(4000),
             description CHAR(4000),
             programme_lssl CHAR(4000),
             schedule CHAR(4000),
             production_company CHAR(4000),
             FirstName CHAR(4000),
             LastName CHAR(4000),
             Birthdate DATE "RRRR-MM-DD",
             Gender CHAR(4000),
             Role CHAR(4000),
             Specialization CHAR(4000),
             Username_lssl CHAR(4000)
           )
