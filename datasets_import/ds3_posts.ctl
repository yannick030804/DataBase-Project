load data 
CHARACTERSET UTF8
infile 'ds3_posts.csv' "str '\r\n'"
append
into table ds3_posts
fields terminated by ','
OPTIONALLY ENCLOSED BY '"' AND '"'
trailing nullcols
           ( post_id,
             post CHAR(4000),
             post_date DATE "RRRR-MM-DD",
             likes,
             reposts,
             reply_to,
             hashtag CHAR(4000),
             hashtag_desc CHAR(4000),
             trending_status CHAR(4000),
             image CHAR(4000),
             path CHAR(4000),
             mime CHAR(4000),
             nickname CHAR(4000),
             creation_date DATE "RRRR-MM-DD",
             verified,
             localization CHAR(4000)
           )
