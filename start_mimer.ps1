docker run  -e MIMER_DATABASE=hotel_db -e MIMER_SYSADM_PASSWORD=SYSADM -p 1360:1360 mimersql/mimersql_v11.0:latest
bsql -pSYSADM -uSYSADM hotel_db -q "read input from 'C:\Users\richa\IdeaProjects\hotel_db\crehotdb.sql'"
bsql -pHOTELADM -uHOTELADM hotel_db