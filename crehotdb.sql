-- noinspection SqlNoDataSourceInspectionForFile
--drop ident HOTELADM cascade;
create ident HOTELADM AS USER IDENTIFIED BY 'HOTELADM';
GRANT DATABANK TO HOTELADM;
GRANT BACKUP TO HOTELADM;
DISCONNECT;
CONNECT TO 'hotel_db' user 'HOTELADM' USING 'HOTELADM';
CREATE DATABANK HOTELDB
       OF 60 PAGES
       IN 'HOTELDB'
       WITH TRANS OPTION;


CREATE DOMAIN HOTELCODE
     AS CHARACTER(4);

CREATE DOMAIN STATUS
   AS CHARACTER(10)
DEFAULT 'UNKNOWN';

CREATE DOMAIN ROOMTYPE
   AS CHARACTER(6)
 DEFAULT '-ND-';

CREATE DOMAIN ROOMNO
 AS CHARACTER(7);

CREATE DOMAIN PERSONNAME
 AS CHARACTER(25);

CREATE DOMAIN NUMBER 
 AS INTEGER(3)
 DEFAULT 0;

CREATE DOMAIN BOOK_RATE
  AS DECIMAL(3,2)
  DEFAULT 1.10;

CREATE TABLE HOTEL (HOTELCODE   HOTELCODE      NOT NULL,
                    NAME        CHAR(15)       NOT NULL,
                    CITY        CHAR(15)       NOT NULL,
       PRIMARY KEY (HOTELCODE))
       IN HOTELDB;  

CREATE TABLE ROOMSTATUS (STATUS STATUS NOT NULL,
         PRIMARY KEY (STATUS)) IN HOTELDB;

CREATE TABLE ROOMTYPES (ROOMTYPE    ROOMTYPE  NOT NULL,
                        DESCRIPTION VARCHAR(40)  NOT NULL,
       PRIMARY KEY (ROOMTYPE))
       IN HOTELDB;
                               
CREATE TABLE ROOMS (ROOMNO      ROOMNO          NOT NULL,
                    HOTELCODE   HOTELCODE       NOT NULL,
                    ROOMTYPE    ROOMTYPE        NOT NULL,
                    STATUS      STATUS          NOT NULL,
       PRIMARY KEY (ROOMNO),
       FOREIGN KEY (HOTELCODE) REFERENCES HOTEL,
       FOREIGN KEY (ROOMTYPE)  REFERENCES ROOMTYPES,
       FOREIGN KEY (STATUS)    REFERENCES ROOMSTATUS)
       IN HOTELDB;                 
                                        
CREATE TABLE ROOM_PRICES (HOTELCODE     HOTELCODE  NOT NULL,
                          ROOMTYPE      ROOMTYPE   NOT NULL,
                          FROM_DATE     DATE       NOT NULL,
                          TO_DATE       DATE       NOT NULL,
                          PRICE         INTEGER(4),
       PRIMARY KEY (HOTELCODE,ROOMTYPE,FROM_DATE),
       FOREIGN KEY (HOTELCODE) REFERENCES HOTEL,
       FOREIGN KEY (ROOMTYPE)  REFERENCES ROOMTYPES)
       IN HOTELDB;

CREATE TABLE CHARGES (CHARGE_CODE  CHAR(4)  NOT NULL,
                      DESCRIPTION  CHAR(25) NOT NULL,
                      CHARGE_PRICE         INTEGER(4),
       PRIMARY KEY (CHARGE_CODE))
       IN HOTELDB;
                         
CREATE TABLE BOOK_GUEST (RESERVATION       INTEGER(5)   NOT NULL,
                         BOOKING_DATE      DATE          
                         DEFAULT CURRENT_DATE           NOT NULL,
                         HOTELCODE         HOTELCODE    NOT NULL,
                         ROOMTYPE          ROOMTYPE     NOT NULL,
                         COMPANY           VARCHAR(100) NOT NULL,
                         TELEPHONE         CHAR(15),
                         RESERVED_FNAME    PERSONNAME,
                         RESERVED_LNAME    PERSONNAME,
                         ARRIVE            DATE         NOT NULL,
                         DEPART            DATE         NOT NULL,
                         GUEST_FNAME       PERSONNAME,
                         GUEST_LNAME       PERSONNAME,
                         ADDRESS           VARCHAR(50),
                         CHECKIN           DATE,
                         CHECKOUT          DATE,
                         ROOMNO            ROOMNO,
                         PAYMENT           CHAR(10),
       PRIMARY KEY (RESERVATION),
       FOREIGN KEY (HOTELCODE) REFERENCES HOTEL,
       FOREIGN KEY (ROOMTYPE)  REFERENCES ROOMTYPES,
       FOREIGN KEY (ROOMNO)    REFERENCES ROOMS,
       CHECK (ARRIVE < DEPART AND CHECKIN <= CHECKOUT))
       IN HOTELDB;               
        
CREATE TABLE BILL (RESERVATION  INTEGER(5)   NOT NULL,
                   ON_DATE      TIMESTAMP(0) NOT NULL,
                   CHARGE_CODE  CHAR(4)      NOT NULL,
        FOREIGN KEY (RESERVATION) REFERENCES BOOK_GUEST,
        FOREIGN KEY (CHARGE_CODE) REFERENCES CHARGES)
        IN HOTELDB;     

CREATE TABLE EXCHANGE_RATE (CURRENCY CHAR(3)      NOT NULL,
                            RATE     DECIMAL(6,3),
        PRIMARY KEY (CURRENCY))
        IN HOTELDB;

CREATE TABLE WAKE_UP(ROOMNO      ROOMNO      NOT NULL,
                     WAKE_DATE   DATE        NOT NULL,
                     WAKE_TIME   TIME        NOT NULL,
        PRIMARY KEY (ROOMNO,WAKE_DATE),
        FOREIGN KEY (ROOMNO) REFERENCES ROOMS)
        IN HOTELDB;

INSERT INTO ROOMSTATUS VALUES ('UNKNOWN');
INSERT INTO ROOMSTATUS VALUES ('FREE');
INSERT INTO ROOMSTATUS VALUES ('KEY OUT');
INSERT INTO ROOMSTATUS VALUES ('MAINT');

INSERT INTO HOTEL VALUES ('LAP','LAPONIA','STOCKHOLM');
INSERT INTO HOTEL VALUES ('SKY','SKYLINE','UPPSALA');
INSERT INTO HOTEL VALUES ('STG','ST. GEORGE','STOCKHOLM');
INSERT INTO HOTEL VALUES ('WIND','WINSTON','COPENHAGEN');
INSERT INTO HOTEL VALUES ('WINS','WINSTON','GOTHENBURG');
INSERT INTO HOTEL VALUES ('WIN','Winston','London');

INSERT INTO ROOMTYPES VALUES ('NSDBLB','NO SMOKING - DOUBLE WITH BATH');
INSERT INTO ROOMTYPES VALUES ('NSDBLS','NO SMOKING - DOUBLE WITH SHOWER');
INSERT INTO ROOMTYPES VALUES ('NSSGLB','NO SMOKING - SINGLE WITH BATH');
INSERT INTO ROOMTYPES VALUES ('NSSGLS','NO SMOKING - SINGLE WITH SHOWER');
INSERT INTO ROOMTYPES VALUES ('SDBLB','SMOKING - DOUBLE WITH BATH');
INSERT INTO ROOMTYPES VALUES ('SDBLS','SMOKING - DOUBLE WITH SHOWER');
INSERT INTO ROOMTYPES VALUES ('SSGLB','SMOKING - SINGLE WITH BATH');
INSERT INTO ROOMTYPES VALUES ('SSGLS','SMOKING - SINGLE WITH SHOWER');

INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('LAP110','LAP','SSGLS','FREE');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('LAP111','LAP','SSGLB','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('LAP112','LAP','NSSGLB','FREE');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('LAP120','LAP','SDBLS','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('LAP121','LAP','SDBLS','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('LAP122','LAP','NSDBLS','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('LAP200','LAP','NSSGLB','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('LAP201','LAP','NSSGLB','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('LAP205','LAP','NSSGLB','FREE'); 
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('LAP206','LAP','SSGLS','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('LAP210','LAP','NSDBLB','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('LAP211','LAP','NSDBLB','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('LAP212','LAP','SSGLS','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('LAP301','LAP','SSGLS','FREE');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('LAP302','LAP','NSSGLS','FREE');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('LAP303','LAP','NSSGLS','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('LAP304','LAP','NSSGLS','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('LAP305','LAP','NSSGLS','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('LAP306','LAP','SSGLS','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('LAP307','LAP','SSGLS','FREE');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('LAP308','LAP','NSSGLS','KEY OUT');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('LAP309','LAP','NSSGLS','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('SKY101','SKY','NSSGLS','KEY OUT');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('SKY102','SKY','SSGLS','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('SKY103','SKY','SSGLS','FREE');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('SKY110','SKY','NSSGLB','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('SKY111','SKY','SSGLB','KEY OUT');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('SKY112','SKY','NSSGLB','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('SKY114','SKY','SSGLB','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('SKY115','SKY','NSSGLB','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('SKY116','SKY','SSGLS','KEY OUT');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('SKY117','SKY','NSSGLS','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('SKY121','SKY','NSDBLS','MAINT');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('SKY122','SKY','SDBLS','MAINT');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('SKY123','SKY','SDBLS','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('SKY124','SKY','NSDBLB','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('SKY125','SKY','NSDBLB','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('SKY201','SKY','SSGLS','KEY OUT');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('SKY202','SKY','NSSGLS','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('SKY203','SKY','NSSGLS','KEY OUT');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('SKY204','SKY','NSSGLS','FREE');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('SKY205','SKY','SSGLS','MAINT');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('SKY206','SKY','SSGLS','KEY OUT');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('SKY210','SKY','SSGLB','MAINT');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('SKY212','SKY','NSDBLB','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('STG001','STG','SSGLS','MAINT');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('STG002','STG','SSGLS','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('STG003','STG','NSSGLS','MAINT');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('STG004','STG','NSSGLS','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('STG005','STG','NSSGLS','KEY OUT');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('STG006','STG','NSSGLS','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('STG007','STG','NSSGLS','MAINT');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('STG008','STG','NSSGLS','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('STG009','STG','NSSGLS','FREE');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('STG010','STG','SSGLS','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('STG110','STG','NSDBLS','KEY OUT');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('STG111','STG','NSDBLS','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('STG112','STG','NSDBLS','MAINT');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('STG113','STG','NSDBLS','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('STG114','STG','NSDBLB','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('STG115','STG','NSDBLB','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('STG116','STG','SDBLB','MAINT');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('STG117','STG','SDBLB','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('STG142','STG','NSSGLB','MAINT');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('STG143','STG','SSGLB','KEY OUT');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('WIND301','WIND','NSSGLS','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('WIND302','WIND','SSGLB','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('WIND303','WIND','SSGLB','KEY OUT');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('WIND304','WIND','NSSGLB','MAINT');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('WIND305','WIND','NSSGLB','FREE');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('WIND306','WIND','NSSGLB','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('WIND307','WIND','NSDBLS','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('WIND308','WIND','NSDBLS','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('WIND309','WIND','NSSGLB','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('WIND310','WIND','NSSGLB','MAINT');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('WIND401','WIND','NSDBLS','MAINT');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('WIND402','WIND','NSDBLS','MAINT');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('WIND403','WIND','NSDBLS','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('WIND501','WIND','NSSGLB','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('WIND502','WIND','NSSGLB','MAINT');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('WIND503','WIND','SSGLB','FREE');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('WIND504','WIND','NSSGLB','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('WIND505','WIND','NSSGLB','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('WIND512','WIND','NSSGLB','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('WIND514','WIND','SSGLB','MAINT');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('WIND516','WIND','NSSGLB','KEY OUT');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('WIND518','WIND','NSSGLB','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('WIND520','WIND','NSDBLB','FREE');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('WIND522','WIND','NSDBLB','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('WIND524','WIND','SDBLB','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('WINS101','WINS','SSGLB','KEY OUT');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('WINS102','WINS','NSSGLB','FREE');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('WINS103','WINS','NSDBLB','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('WINS104','WINS','NSDBLB','MAINT');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('WINS105','WINS','NSSGLB','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('WINS106','WINS','NSSGLB','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('WINS107','WINS','NSDBLB','MAINT ');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('WINS108','WINS','NSDBLB','FREE');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('WINS109','WINS','NSSGLB','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('WINS110','WINS','SSGLB','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('WINS111','WINS','SDBLB','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('WINS112','WINS','NSDBLB','FREE');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('WINS113','WINS','NSSGLB','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('WINS114','WINS','NSSGLB','FREE');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('WINS115','WINS','NSDBLB','FREE');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('WINS116','WINS','NSDBLB','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('WINS117','WINS','NSSGLB','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('WINS118','WINS','NSDBLB','MAINT');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('WINS119','WINS','NSDBLB','FREE');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('WINS120','WINS','NSSGLB','MAINT');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('WINS121','WINS','NSSGLB','UNKNOWN');
INSERT INTO ROOMS (ROOMNO,HOTELCODE,ROOMTYPE,STATUS) 
VALUES ('WINS122','WINS','NSSGLB','FREE');

INSERT INTO ROOM_PRICES VALUES ('LAP','NSDBLB',current_date - interval '14' day (3),
current_date + interval '84' day (3),900);
INSERT INTO ROOM_PRICES VALUES ('LAP','NSDBLB',current_date + interval '85' day (3)
,current_date + interval '200' day (3),830);
INSERT INTO ROOM_PRICES VALUES ('LAP','NSDBLS',current_date - interval '14' day (3),
current_date + interval '84' day (3),760);
INSERT INTO ROOM_PRICES VALUES ('LAP','NSDBLS',current_date + interval '85' day (3),
current_date + interval '200' day (3),710);
INSERT INTO ROOM_PRICES VALUES ('LAP','NSSGLB',current_date - interval '14' day (3),
current_date + interval '84' day (3),800);
INSERT INTO ROOM_PRICES VALUES ('LAP','NSSGLB',current_date + interval '85' day (3),
current_date + interval '200' day (3),660);
INSERT INTO ROOM_PRICES VALUES ('LAP','NSSGLS',current_date - interval '14' day (3),
current_date+ interval '84' day (3),680);
INSERT INTO ROOM_PRICES VALUES ('LAP','NSSGLS',current_date + interval '85' day (3),
current_date + interval '200' day (3),640);
INSERT INTO ROOM_PRICES VALUES ('SKY','NSDBLB',current_date - interval '14' day (3),
current_date + interval '84' day (3),1080);
INSERT INTO ROOM_PRICES VALUES ('SKY','NSDBLS',current_date - interval '14' day (3),
current_date + interval '84' day (3),950);
INSERT INTO ROOM_PRICES VALUES ('SKY','NSSGLB',current_date - interval '14' day (3),
current_date + interval '84' day (3),870);
INSERT INTO ROOM_PRICES VALUES ('SKY','NSSGLS',current_date - interval '14' day (3),
current_date + interval '84' day (3),750);
INSERT INTO ROOM_PRICES VALUES ('STG','NSDBLB',current_date - interval '14' day (3),
current_date - interval '14' day (3),1090);
INSERT INTO ROOM_PRICES VALUES ('STG','NSDBLB',current_date + interval '85' day (3),
current_date + interval '200' day (3),830);
INSERT INTO ROOM_PRICES VALUES ('STG','NSDBLS',current_date - interval '14' day (3),
current_date + interval '84' day (3),760);
INSERT INTO ROOM_PRICES VALUES ('STG','NSDBLS',current_date + interval '85' day (3),
current_date + interval '200' day (3),710);
INSERT INTO ROOM_PRICES VALUES ('STG','NSSGLB',current_date - interval '14' day (3),
current_date + interval '84' day (3),600);
INSERT INTO ROOM_PRICES VALUES ('STG','NSSGLB',current_date + interval '85' day (3),
current_date + interval '200' day (3),660);
INSERT INTO ROOM_PRICES VALUES ('STG','NSSGLS',current_date - interval '14' day (3),
current_date+ interval '84' day (3),680);
INSERT INTO ROOM_PRICES VALUES ('STG','NSSGLS',current_date + interval '85' day (3),
current_date + interval '200' day (3),640);
INSERT INTO ROOM_PRICES VALUES ('WIND','NSDBLB', current_date - interval '14' day (3),
current_date + interval '84' day (3),1600);
INSERT INTO ROOM_PRICES VALUES ('WIND','NSDBLS', current_date - interval '14' day (3),
current_date + interval '84' day (3),1570);
INSERT INTO ROOM_PRICES VALUES ('WIND','NSSGLB', current_date - interval '14' day (3),
current_date + interval '84' day (3),1410);
INSERT INTO ROOM_PRICES VALUES ('WIND','NSSGLS', current_date - interval '14' day (3),
current_date + interval '84' day (3),1370);
INSERT INTO ROOM_PRICES VALUES ('WINS','NSDBLB', current_date - interval '14' day (3),
current_date + interval '84' day (3),1570);
INSERT INTO ROOM_PRICES VALUES ('WINS','NSSGLB', current_date - interval '14' day (3),
current_date + interval '84' day (3),1370);
INSERT INTO ROOM_PRICES VALUES ('LAP','SDBLB',current_date - interval '14' day (3),
current_date + interval '84' day (3),900);
INSERT INTO ROOM_PRICES VALUES ('LAP','SDBLB',current_date + interval '85' day (3),
current_date + interval '200' day (3),830);
INSERT INTO ROOM_PRICES VALUES ('LAP','SDBLS',current_date - interval '14' day (3),
current_date + interval '84' day (3),760);
INSERT INTO ROOM_PRICES VALUES ('LAP','SDBLS',current_date - interval '85' day (3),
current_date + interval '200' day (3),710);
INSERT INTO ROOM_PRICES VALUES ('LAP','SSGLB',current_date - interval '14' day (3),
current_date + interval '84' day (3),800);
INSERT INTO ROOM_PRICES VALUES ('LAP','SSGLB',current_date + interval '85' day (3),
current_date + interval '200' day (3),660);
INSERT INTO ROOM_PRICES VALUES ('LAP','SSGLS',current_date - interval '14' day (3),
current_date + interval '84' day (3),680);
INSERT INTO ROOM_PRICES VALUES ('LAP','SSGLS',current_date + interval '85' day (3),
current_date + interval '200' day (3),640);
INSERT INTO ROOM_PRICES VALUES ('SKY','SDBLB',current_date - interval '14' day (3),
current_date + interval '84' day (3),1080);
INSERT INTO ROOM_PRICES VALUES ('SKY','SDBLS',current_date - interval '14' day (3),
current_date + interval '84' day (3),950);
INSERT INTO ROOM_PRICES VALUES ('SKY','SSGLB',current_date - interval '138' day (3),
current_date + interval '84' day (3),870);
INSERT INTO ROOM_PRICES VALUES ('SKY','SSGLS',current_date - interval '14' day (3),
current_date + interval '84' day (3),750);
INSERT INTO ROOM_PRICES VALUES ('STG','SDBLB',current_date - interval '14' day (3),
current_date + interval '84' day (3),1090);
INSERT INTO ROOM_PRICES VALUES ('STG','SDBLB',current_date + interval '85' day (3),
current_date + interval '200' day (3),830);
INSERT INTO ROOM_PRICES VALUES ('STG','SDBLS',current_date - interval '14' day (3),
current_date + interval '84' day (3),760);
INSERT INTO ROOM_PRICES VALUES ('STG','SDBLS',current_date + interval '85' day (3),
current_date + interval '200' day (3),710);
INSERT INTO ROOM_PRICES VALUES ('STG','SSGLB',current_date - interval '14' day (3),
current_date + interval '84' day (3),600);
INSERT INTO ROOM_PRICES VALUES ('STG','SSGLB',current_date + interval '85' day (3),
current_date + interval '200' day (3),660);
INSERT INTO ROOM_PRICES VALUES ('STG','SSGLS',current_date - interval '14' day (3),
current_date + interval '84' day (3),680);
INSERT INTO ROOM_PRICES VALUES ('STG','SSGLS',current_date + interval '85' day (3),
current_date + interval '200' day (3),640);
INSERT INTO ROOM_PRICES VALUES ('WIND','SDBLB', current_date - interval '14' day (3),
current_date+ interval '84' day (3),1600);
INSERT INTO ROOM_PRICES VALUES ('WIND','SDBLS', current_date - interval '14' day (3),
current_date + interval '84' day (3),1570);
INSERT INTO ROOM_PRICES VALUES ('WIND','SSGLB', current_date - interval '14' day (3),
current_date + interval '84' day (3),1410);
INSERT INTO ROOM_PRICES VALUES ('WIND','SSGLS', current_date - interval '14' day (3),
current_date + interval '84' day (3),1370);
INSERT INTO ROOM_PRICES VALUES ('WINS','SDBLB', current_date- interval '14'  day (3),
current_date + interval '84' day (3),1570);
INSERT INTO ROOM_PRICES VALUES ('WINS','SSGLB', current_date - interval '14'  day (3),
current_date + interval '84' day (3),1370);

INSERT INTO CHARGES VALUES ('100','LODGING',100);
INSERT INTO CHARGES VALUES ('120','TELEPHONE',40);
INSERT INTO CHARGES VALUES ('170','CAR PARK',70);
INSERT INTO CHARGES VALUES ('200','RESTAURANT',250);
INSERT INTO CHARGES VALUES ('210','MINIBAR',70);
INSERT INTO CHARGES VALUES ('230','BAR',200);
INSERT INTO CHARGES VALUES ('270','ROOM SERVICE',95);
INSERT INTO CHARGES VALUES ('330','LAUNDRY',120);
INSERT INTO CHARGES VALUES ('720','EXTRA BED',370);
INSERT INTO CHARGES VALUES ('700','ROOM',NULL);
INSERT INTO CHARGES VALUES ('600','ROOM',600);
INSERT INTO CHARGES VALUES ('680','ROOM',680);
INSERT INTO CHARGES VALUES ('750','ROOM',750);
INSERT INTO CHARGES VALUES ('800','ROOM',800);
INSERT INTO CHARGES VALUES ('870','ROOM',870);
INSERT INTO CHARGES VALUES ('1080','ROOM',1080);
INSERT INTO CHARGES VALUES ('1090','ROOM',1090);
INSERT INTO CHARGES VALUES ('1370','ROOM',1370);
INSERT INTO CHARGES VALUES ('1410','ROOM',1410);
INSERT INTO CHARGES VALUES ('1570','ROOM',1570);
INSERT INTO CHARGES VALUES ('900','MISCELLANEOUS',30);

INSERT INTO BOOK_GUEST VALUES (1356,
current_date - interval '71' day (3),
'SKY',
'SDBLB',
'M & D AB',
'0350-19738',
'ERIK','ANDERSSON',
current_date - interval '1' day (3),
current_date + interval '2' day (3),                            
'ERIKA','ANDERSSON',
'PARKV. 126, SVEDALA',
current_date - interval '1' day (3),
NULL,
'SKY124',
NULL);

INSERT INTO BOOK_GUEST VALUES (1357,
current_date - interval '71' day (3),
'SKY',
'NSDBLB',
'M & D AB',
'0350-19738',
'ERIK','ANDERSSON',
current_date - interval '1' day (3),
current_date + interval '1' day (3),
'FRED','NILSSON',
'BLOMGATAN 15B, SVEDALA',
current_date,
NULL,
'SKY201',
NULL);

INSERT INTO BOOK_GUEST VALUES (1369,
current_date - interval '65' day (3),
'WIND',
'NSDBLS',
'ALEX OLSSON',
'018-298573',
'ALEX','OLSSON',
current_date,
current_date + interval '2' day (3),
'ALEX','OLSSON',
'TORSGATAN 12, UPPSALA',
current_date,
NULL,
'WIND401',
NULL);

INSERT INTO BOOK_GUEST VALUES (1370,
current_date - interval '65' day (3),
'WIND',
'NSDBLS',
'ALEX OLSSON',
'018-298573',
'ALEX','OLSSON',
current_date - interval '3' day (3),
current_date + interval '2' day (3),
'KERSTIN','OLSSON',
'TORSGATAN 12, UPPSALA',
current_date - interval '3' day (3),
NULL,
'WIND402',
NULL);

INSERT INTO BOOK_GUEST VALUES (1372,
current_date - interval '58' day (3),
'LAP',
'NSSGLB',
'STATEX',
'0640-34628',
'LOTTA','JOHNSSON',
current_date - interval '1' day (3),
current_date + interval '1' day (3),
'NILS','KRISTOFERSEN',
'RUBINSGATAN 37, LUND',
current_date - interval '1' day (3),
NULL,
'LAP112',
NULL);

INSERT INTO BOOK_GUEST VALUES (1382,
current_date - interval '51' day (3),
'WINS',
'NSDBLB',
'JULIO PEREZ',
'6-6549868',
'JULIO','PEREZ',
current_date - interval '17' day (3),
current_date - interval '11' day (3),
'JULIO','PEREZ',
'CARLOTA 7, MADRID, SPAIN',
current_date - interval '16' day (3),
NULL,
'WINS119',
NULL);

INSERT INTO BOOK_GUEST VALUES (1384,
current_date - interval '47' day (3),
'WINS',
'NSSGLB',
'PERSSON & NYQVIST AB',
'0125-14827',
'SIGWARD','PERSSON',
current_date - interval '5' day (3),
current_date + interval '5' day (3),
'SIGWARD','PERSSON',
'GROPGATAN 43A, VADSTENA',
current_date - interval '5' day (3),
NULL,
'WINS120',
NULL);

INSERT INTO BOOK_GUEST VALUES (1385,
current_date - interval '47' day (3),
'WINS',
'SSGLB',
'PERSSON & NYQVIST AB',
'0125-14827',
'RUNE','NYQVIST',
current_date - interval '4' day (3),
current_date + interval '2' day (3),
'RUNE','NYQVIST',
'KARPV. 33, NYBROVIK',
current_date - interval '4' day (3),
NULL,
'WINS121',
NULL);

INSERT INTO BOOK_GUEST VALUES (1389,
current_date - interval '43' day (3),
'LAP',
'SSGLB',
'ANFOTRONIX',
'006-4368853',
'JUDITH','SMITH',
current_date - interval '1' day (3),
current_date + interval '1' day (3),
'JUDITH','SMITH',
'HACKSTON 452, LONDON, UK',
current_date - interval '1' day (3),
NULL,
'LAP205',
NULL);

INSERT INTO BOOK_GUEST VALUES (1393,
current_date - interval '40' day (3),
'WIND',
'NSSGLB',
'FRANCOIS LE FEVRE',
'01823-98473',
'FRANCOIS','LE FEVRE',
current_date - interval '1' day (3),
current_date + interval '3' day (3),
'FRANCOIS','LE FEVRE',
'6 RUE PARISIEN, PARIS, FRANCE',
current_date - interval '1' day (3),
NULL,
'WIND514',
NULL);

INSERT INTO BOOK_GUEST VALUES (1397,
current_date - interval '38' day (3),
'SKY',
'NSSGLB',
'TEKNOGEN AB',
'0554-34522',
'BARBRA','LEIJON',
current_date - interval '1' day (3),
current_date + interval '2' day (3),
'DAG','GRANKVIST',
'BIKUPAGATAN 65, KIL',
current_date - interval '1' day (3),
NULL,
'SKY111',
NULL);

INSERT INTO BOOK_GUEST VALUES (1398,
current_date - interval '38' day (3),
'STG',
'NSSGLB',
'TEKNOGEN AB',
'0554-34522',
'BARBRA','LEIJON',
current_date - interval '2' day (3),
current_date + interval '3' day (3),
'LENNART','RYDELL',
'FISKAREV. 16, KIL',
current_date - interval '1' day (3),
NULL,
'STG142',
NULL);

INSERT INTO BOOK_GUEST VALUES (1412,
current_date - interval '25' day (3),
'WINS',
'NSDBLB',
'JOHAN TORP',
'048-879383',
'JOHAN','TORP',
current_date - interval '3' day (3),
current_date + interval '2' day (3),
'JOHAN','TORP',
'GRANDV. 77, KRISTIANSTAD',
current_date - interval '3' day (3),
NULL,
'WINS119',
NULL);

INSERT INTO BOOK_GUEST VALUES (1347,
current_date - interval '73' day (3),
'LAP',
'NSSGLS',
'CHRISTOPHER DATE',
'619-452-0171',
'CHRISTOPHER','DATE',
current_date - interval '1' day (3),
current_date + interval '1' day (3),
'CHRISTOPHER','DATE',
'10505 VALLEY RD,SAN DIEGO,USA',
current_date - interval '1' day (3),
current_date,
'LAP111',
NULL);

INSERT INTO BOOK_GUEST VALUES (1348,
current_date - interval '73' day (3),
'STG',
'NSSGLB',
'SYSDECO MIMER AB',
'018-185210',
'STEN','JOHANSEN',
current_date - interval '2' day (3),
current_date,
'STEN','JOHANSEN',
'MIMERGATAN 4, UPPSALA',
current_date - interval '2' day (3),
current_date,
'STG009',
'EUROCARD');

INSERT INTO BOOK_GUEST VALUES (1349,
current_date - interval '73' day (3),
'LAP',
'NSSGLS',
'MIMER AB',
'018-185210',
'MATS','LINDBLOM',
current_date - interval '53' day (3),
current_date - interval '52' day (3),
'STEFAN','HANSEN',
'IDUNGATAN 24, UPPSALA',
current_date - interval '53' day (3),
current_date - interval '52' day (3),
'LAP206',
'EUROCARD');

INSERT INTO BOOK_GUEST VALUES (1350,
current_date - interval '72' day (3),
'SKY',
'SDBLB',
'SALLY WEBERT',
'0760-57609',
'SALLY','WEBERT',
current_date - interval '1' day (3),
current_date + interval '2' day (3),
'SALLY','WEBERT',
'KRONPARKEN 44, JOKKMOKK',
current_date - interval '1' day (3),
current_date,
'SKY212',
'CASH');

INSERT INTO BOOK_GUEST VALUES (1351,
current_date - interval '72' day (3),
'SKY',
'NSDBLB',
'SALLY WEBERT',
'0760-57609',
'JOHN','ALBERTSON',
current_date - interval '72' day (3),
current_date - interval '68' day (3),
'ANNA','ALBERTSON',
'32 SPRING DRIVE, DENVER, USA',
current_date - interval '72' day (3),
current_date - interval '68' day (3),
'SKY125',
'AM.EXPR');

INSERT INTO BOOK_GUEST VALUES (1352,
current_date - interval '72' day (3),
'WINS',
'NSDBLB',
'MARK FRANCIS',
'08-320668',
'MARK','FRANCIS',
current_date - interval '64' day (3),
current_date - interval '63' day (3),
'MARK','FRANCIS',
'VIMPELGATAN 7, SKARA',
current_date - interval '64' day (3),
current_date - interval '63' day (3),
'WINS103',
'EUROCARD');

INSERT INTO BOOK_GUEST VALUES (1353,
current_date - interval '72' day (3),
'SKY',
'NSSGLB',
'ASATRON AB',
'08-135709',
'BASIL','FAWCETT',
current_date - interval '2' day (3),
current_date,
'ALFRED','FIMPLEY',
'23 BACK NELLY VIEW, ACKWORTH',
current_date - interval '2' day (3),
current_date,
'SKY110',
'CASH');

INSERT INTO BOOK_GUEST VALUES (1354,
current_date - interval '71' day (3),
'WIND',
'SSGLS',
'JAMES WEBB',
'011-101958',
'JAMES','WEBB',
current_date - interval '63' day (3),
current_date - interval '58' day (3),
'JAMES','WEBB',
'CIRCLE DR. 12, LONDON, UK',
current_date - interval '63' day (3),
current_date - interval '58' day (3),
'WIND301',
'CASH');

INSERT INTO BOOK_GUEST VALUES (1355,
current_date - interval '71' day (3),
'STG',
'SDBLS',
'AB X-TRA',
'08-529998',
'INGER','SVENSON',
current_date - interval '44' day (3),
current_date - interval '40' day (3),
'INGER','SVENSON',
'ERIKSGATAN 16, SOLNA',
current_date - interval '44' day (3),
current_date - interval '42' day (3),
'STG111',
'EUROCARD');

INSERT INTO BOOK_GUEST VALUES (1358,
current_date - interval '70' day (3),
'SKY',
'NSSGLS',
'EDWARD CODD',
'619-452-0171',
'EDWARD','CODD',
current_date - interval '1' day (3),
current_date,
'EDWARD','CODD',
'16555 SORENTO RD,SAN DIEGO,USA',
current_date - interval '1' day (3),
current_date,
'SKY201',
NULL);

INSERT INTO BOOK_GUEST VALUES (1359,
current_date - interval '67' day (3),
'LAP',
'NSSGLS',
'GUNNAR ALVE',
'0141-52993',
'GUNNAR','ALVE',
current_date - interval '64' day (3),
current_date - interval '62' day (3),
'GUNNAR','ALVE',
'FLEMMINGSALLE 444, FARLINGE',
current_date - interval '64' day (3),
current_date - interval '62' day (3),
'LAP206',
'EUROCARD');

INSERT INTO BOOK_GUEST VALUES (1360,
current_date - interval '67' day (3),
'SKY',
'NSSGLS',
'ZARDRON LTD.',
'004-2456784',
'SARA','WHITTAKER',
current_date - interval '43' day (3),
current_date - interval '42' day (3),
'SARA','WHITTAKER',
'14 MULBERRY RD, EXETER, UK',
current_date - interval '44' day (3),
current_date - interval '42' day (3),
'SKY202',
'CASH');

INSERT INTO BOOK_GUEST VALUES (1361,
current_date - interval '67' day (3),
'SKY',
'SSGLS',
'ZARDRON LTD.',
'004-2456784',
'MARTHA','HOLLINGSWORTH',
current_date - interval '43' day (3),
current_date - interval '42' day (3),
'MARTHA','HOLLINGSWORTH',
'34 KNOTT ST, EXETER, UK',
current_date - interval '44' day (3),
current_date - interval '42' day (3),
'SKY203',
'CASH');

INSERT INTO BOOK_GUEST VALUES (1362,
current_date - interval '67' day (3),
'WIND',
'NSDBLB',
'KJELLS TRANSPORT AB',
'025-846730',
'INGELA','SVANBERG',
current_date - interval '63' day (3),
current_date - interval '58' day (3),
'CHRISTOFER','SVENSON',
'YRKESV. 3, KALMAR',
current_date - interval '63' day (3),
current_date - interval '58' day (3),
'WIND520',
'EUROCARD');

INSERT INTO BOOK_GUEST VALUES (1363,
current_date - interval '66' day (3),
'WINS',
'NSSGLB',
'FRANCOIS LE FEVRE',
'01823-98473',
'FRANCOIS','LE FEVRE',
current_date - interval '56' day (3),
current_date - interval '50' day (3),
'FRANCOIS','LE FEVRE',
'6 RUE PARISIEN, PARIS, FRA',
current_date - interval '56' day (3),
current_date - interval '50' day (3),
'WINS117',
'VISA');

INSERT INTO BOOK_GUEST VALUES (1364,
current_date - interval '66' day (3),
'STG',
'NSDBLB',
'LARS HOLLSTEN',
'019-276584',
'LARS','HOLLSTEN',
current_date - interval '44' day (3),
current_date - interval '41' day (3),
'LARS','HOLLSTEN',
'GUNNAR NYSTROMSV. 44C, GUNSTA',
current_date - interval '44' day (3),
current_date - interval '41' day (3),
'STG116',
'CASH');

INSERT INTO BOOK_GUEST VALUES (1365,
current_date - interval '66' day (3),
'LAP',
'SDBLS',
'PROFILIUM AB',
'0340-53402',
'JENNY','LIND',
current_date - interval '9' day (3),
current_date - interval '3' day (3),
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL);

INSERT INTO BOOK_GUEST VALUES (1367,
current_date - interval '65' day (3),
'WINS',
'NSSGLB',
'EARNST JOHNSSON AB',
'016-673924',
'EARNST','JOHNSSON',
current_date - interval '39' day (3),
current_date - interval '38' day (3),
'EARNST','JOHNSSON',
'DALGATAN 51, SALA',
current_date - interval '39' day (3),
current_date - interval '38' day (3),
'WINS109',
'EUROCARD');

INSERT INTO BOOK_GUEST VALUES (1368,
current_date - interval '65' day (3),
'SKY',
'SSGLB',
'BERT SCHLAGER',
'0181-13227',
'BERT','SCHLAGER',
current_date - interval '65' day (3),
current_date - interval '64' day (3),
'BERT','SCHLAGER',
'VASAGATAN 34, MOTALA',
current_date - interval '65' day (3),
current_date - interval '64' day (3),
'SKY210',
'CASH');

INSERT INTO BOOK_GUEST VALUES (1371,
current_date - interval '64' day (3),
'STG',
'NSSGLS',
'QUARK AB',
'048-489674',
'MARY','TENMAR',
current_date - interval '47' day (3),
current_date - interval '40' day (3),
'MARY','TENMAR',
'GRUSV. 5 III, GOTHENBURG',
current_date - interval '47' day (3),
current_date - interval '40' day (3),
'STG010',
'VOUCHER');

INSERT INTO BOOK_GUEST VALUES (1373,
current_date - interval '58' day (3),
'LAP',
'NSSGLS',
'KONST GRUPPEN',
'018-529964',
'ANNETTE','BERG',
current_date - interval '1' day (3),
current_date + interval '1' day (3),
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL);

INSERT INTO BOOK_GUEST VALUES (1374,
current_date - interval '58' day (3),
'SKY',
'NSSGLB',
'DATAMATIC AB',
'08-2736707',
'EDDY','KARLSSON',
current_date - interval '22' day (3),
current_date - interval '17' day (3),
'EDDY','KARLSSON',
'GRINDV. 2, UPPSALA',
current_date - interval '22' day (3),
current_date - interval '16' day (3),
'SKY111',
'VOUCHER');

INSERT INTO BOOK_GUEST VALUES (1375,
current_date - interval '55' day (3),
'SKY',
'SSGLS',
'OMAR CHAFIR',
'005-3467245',
'OMAR','CHAFIR',
current_date - interval '1' day (3),
current_date + interval '8' day (3),
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL);

INSERT INTO BOOK_GUEST VALUES (1376,
current_date - interval '55' day (3),
'STG',
'NSDBLB',
'PEDER HERTSGAARD',
'4-840109',
'PEDER','HERTSGAARD',
current_date + interval '2' day (3),
current_date + interval '3' day (3),
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL);

INSERT INTO BOOK_GUEST VALUES (1379,
current_date - interval '54' day (3),
'LAP',
'SSGLS',
'LARS HOLMER',
'016-165498',
'LARS','HOLMER',
current_date - interval '40' day (3),
current_date - interval '36' day (3),
'LARS','HOLMER',
'KUNGSGATAN 45, SKRIKSTAD',
current_date - interval '40' day (3),
current_date - interval '36' day (3),
'LAP306',
'EUROCARD');

INSERT INTO BOOK_GUEST VALUES (1380,
current_date - interval '54' day (3),
'SKY',
'NSDBLB',
'BIRGITTA SALONG',
'0142-86499',
'BIRGITTA','SVENSON',
current_date - interval '46' day (3),
current_date - interval '43' day (3),
'BIRGITTA','SVENSON',
'KRANGATAN 34, SVIA',
current_date - interval '46' day (3),
current_date - interval '43' day (3),
'SKY125',
'CASH');

INSERT INTO BOOK_GUEST VALUES (1381,
current_date - interval '53' day (3),
'WIND',
'NSDBLB',
'JOHANNA LINDE',
'0420-52367',
'JOHANNA','LINDE',
current_date - interval '31' day (3),
current_date - interval '21' day (3),
'JOHANNA','LINDE',
'RINGV. 12, HALMSTAD',
current_date - interval '31' day (3),
current_date - interval '21' day (3),
'WIND522',
'VISA');

INSERT INTO BOOK_GUEST VALUES (1383,
current_date - interval '51' day (3),
'STG',
'NSSGLB',
'ROBERT LIND',
'015-759374',
'ROBERT','LIND',
current_date - interval '45' day (3),
current_date - interval '43' day (3),
'ROBERT','LIND',
'PARAPLYV. 18, KRAMFORS',
current_date - interval '45' day (3),
current_date - interval '43' day (3),
'STG142',
'CASH');

INSERT INTO BOOK_GUEST VALUES (1386,
current_date - interval '44' day (3),
'SKY',
'NSDBLB',
'RIKARD LUNDBECK',
'012-374055',
'RIKARD','LUNDBECK',
current_date - interval '25' day (3),
current_date - interval '23' day (3),
'RIKARD','LUNDBECK',
'DERRYGATAN 3 II, MORBYHUS',
current_date - interval '25' day (3),
current_date - interval '23' day (3),
'SKY212',
'CASH');

INSERT INTO BOOK_GUEST VALUES (1387,
current_date - interval '44' day (3),
'STG',
'NSSGLB',
'LUROX AB',
'09-475858',
'ANNA-MARIA','FALKNER',
current_date - interval '4' day (3),
current_date - interval '1' day (3),
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL);

INSERT INTO BOOK_GUEST VALUES (1388,
current_date - interval '44' day (3),
'LAP',
'NSSGLS',
'KNUTS BILBUD',
'0632-53573',
'KNUT','KULLMER',
current_date - interval '20' day (3),
current_date - interval '17' day (3),
'KNUT','KULLMER',
'SOLHAGV. 6, MORA',
current_date - interval '20' day (3),
current_date - interval '17' day (3),
'LAP306',
'EUROCARD');

INSERT INTO BOOK_GUEST VALUES (1391,
current_date - interval '42' day (3),
'WIND',
'NSDBLB',
'ANNIKA HESTMAN',
'018-309348',
'ANNIKA','HESTMAN',
current_date - interval '36' day (3),
current_date - interval '32' day (3),
'ANNIKA','HESTMAN',
'ODINSGATAN 32, UPPSALA',
current_date - interval '36' day (3),
current_date - interval '32' day (3),
'WIND522',
'VISA');

INSERT INTO BOOK_GUEST VALUES (1392,
current_date - interval '40' day (3),
'WIND',
'NSDBLS',
'NYA STOCKHOLMS BANKEN',
'08-1460000',
'MADELEINE','HASSELROT',
current_date - interval '17' day (3),
current_date - interval '15' day (3),
'BENGT','PERSSON',
'ISTERBANDSV. 47, STOCKHOLM',
current_date - interval '17' day (3),
current_date - interval '15' day (3),
'WIND402',
'VOUCHER');

INSERT INTO BOOK_GUEST VALUES (1395,
current_date - interval '39' day (3),
'LAP',
'NSDBLB',
'VIN IMPORT AB',
'017-907644',
'ADOLF','SCHMIDT',
current_date - interval '21' day (3),
current_date - interval '18' day (3),
'ADOLF','SCHMIDT',
'BERGSG. 88, GOTHENBURG',
current_date - interval '21' day (3),
current_date - interval '18' day (3),
'LAP210',
'CASH');

INSERT INTO BOOK_GUEST VALUES (1396,
current_date - interval '38' day (3),
'SKY',
'NSSGLB',
'TEKNOGEN AB',
'0554-34522',
'BARBRA','LEIJON',
current_date - interval '15' day (3),
current_date - interval '12' day (3),
'MATTI','LAHTINEN',
'ADELGR. 5, KIL',
current_date - interval '15' day (3),
NULL,
'SKY110',
NULL);

INSERT INTO BOOK_GUEST VALUES (1399,
current_date - interval '35' day (3),
'LAP',
'NSDBLS',
'LAILA ZETTERBERG',
'035-235757',
'LAILA','ZETTERBERG',
current_date - interval '18' day (3),
current_date - interval '15' day (3),
'LAILA','ZETTERBERG',
'YXPLOCKSV. 9, HUSKVARNA',
current_date - interval '18' day (3),
current_date - interval '15' day (3),
'LAP122',
'CASH');

INSERT INTO BOOK_GUEST VALUES (1400,
current_date - interval '34' day (3),
'WINS',
'NSSGLS',
'REVISORGRUPPEN',
'023-459804',
'ANDERS','WALLIN',
current_date + interval '8' day (3),
current_date + interval '10' day (3),
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL);

INSERT INTO BOOK_GUEST VALUES (1401,
current_date - interval '33' day (3),
'STG',
'NSSGLS',
'JAN BLOM',
'0753-40449',
'JAN','BLOM',
current_date - interval '22' day (3),
current_date - interval '16' day (3),
'JAN','BLOM',
'ANDERSTORP',
current_date - interval '22' day (3),
current_date - interval '16' day (3),
'STG001',
'VISA');

INSERT INTO BOOK_GUEST VALUES (1403,
current_date - interval '32' day (3),
'WIND',
'NSSGLB',
'CHRISTINA KARLSSON',
'08-4659865',
'CHRISTINA','KARLSSON',
current_date - interval '5' day (3),
current_date - interval '2' day (3),
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL);

INSERT INTO BOOK_GUEST VALUES (1404,
current_date - interval '31' day (3),
'LAP',
'NSSGLS',
'REKLAM KONTORET',
'0463-95876',
'MATS','HANSSON',
current_date - interval '25' day (3),
current_date - interval '19' day (3),
'MATS','HANSSON',
'BAKGATAN 64, LYCKSELE',
current_date - interval '25' day (3),
current_date - interval '19' day (3),
'LAP206',
'VOUCHER');

INSERT INTO BOOK_GUEST VALUES (1405,
current_date - interval '31' day (3),
'SKY',
'NSSGLB',
'FREDRIK SELLIN',
'0171-84653',
'FREDRIK','SELLIN',
current_date - interval '26' day (3),
current_date - interval '23' day (3),
'FREDRIK','SELLIN',
'TORGGATAN 36, YSTAD',
current_date - interval '26' day (3),
current_date - interval '23' day (3),
'SKY115',
'VISA');

INSERT INTO BOOK_GUEST VALUES (1406,
current_date - interval '30' day (3),
'SKY',
'NSDBLS',
'AGNETA ERIKSSON',
'045-3497843',
'AGNETA','ERIKSSON',
current_date - interval '12' day (3),
current_date - interval '9' day (3),
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL);

INSERT INTO BOOK_GUEST VALUES (1408,
current_date - interval '30' day (3),
'STG',
'SDBLB',
'B & F SEGLING AB',
'0345-54754',
'EINAR','SUNDMAN',
current_date - interval '3' day (3),
current_date,
'EINAR','SUNDMAN',
'BIRGERGATAN 32, GRUMS',
current_date - interval '3' day (3),
current_date,
'STG117',
'VISA');

INSERT INTO BOOK_GUEST VALUES (1409,
current_date - interval '27' day (3),
'STG',
'SDBLB',
'KARL MALMSTEN',
'017-487506',
'KARL','MALMSTEN',
current_date - interval '14' day (3),
current_date - interval '11' day (3),
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL);

INSERT INTO BOOK_GUEST VALUES (1410,
current_date - interval '26' day (3),
'LAP',
'NSDBLS',
'BERTIL GUSTAVSSON',
'0945-53785',
'BERTIL','GUSTAVSSON',
current_date,
current_date + interval '2' day (3),
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL);

INSERT INTO BOOK_GUEST VALUES (1413,
current_date - interval '22' day (3),
'SKY',
'NSSGLB',
'LEIF HEDIN',
'0394-29506',
'LEIF','HEDIN',
current_date - interval '20' day (3),
current_date - interval '16' day (3),
'LEIF','HEDIN',
'MISTAV. 74, UDDEVALA',
current_date - interval '20' day (3),
current_date - interval '16' day (3),
'SKY115',
'CASH');

INSERT INTO BOOK_GUEST VALUES (1414,
current_date - interval '22' day (3),
'WIND',
'NSDBLS',
'MARCUS SVENSSON',
'08-734950',
'MARCUS','SVENSSON',
current_date - interval '12' day (3),
current_date - interval '10' day (3),
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL);

INSERT INTO BOOK_GUEST VALUES (1415,
current_date - interval '22' day (3),
'WIND',
'NSDBLS',
'HANS KJELLGREN',
'018-984764',
'HANS','KJELLGREN',
current_date - interval '5' day (3),
current_date - interval '3' day (3),
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL);

INSERT INTO BOOK_GUEST VALUES (1416,
current_date - interval '20' day (3),
'STG',
'NSDBLS',
'BYGGNADSFIRMA OLSSON',
'038-432684',
'AXEL','THURESSON',
current_date + interval '4' day (3),
current_date + interval '5' day (3),
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL);

INSERT INTO BOOK_GUEST VALUES (1417,
current_date - interval '19' day (3),
'WIND',
'NSSGLB',
'ROBERT JONES',
'0045-345655',
'ROBERT','JONES',
current_date - interval '7' day (3),
current_date - interval '5' day (3),
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL);

INSERT INTO BOOK_GUEST VALUES (1418,
current_date - interval '16' day (3),
'LAP',
'NSSGLS',
'ANTIK HANDLAREN AB',
'0756-58984',
'ANNA','BERGMAN',
current_date - interval '1' day (3),
current_date,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL);

INSERT INTO BOOK_GUEST VALUES (1419,
current_date - interval '16' day (3),
'SKY',
'NSSGLB',
'SVEN LINDHOLM',
'054-978493',
'SVEN','LINDHOLM',
current_date - interval '1' day (3),
current_date,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL);

INSERT INTO BOOK_GUEST VALUES (1420,
current_date - interval '15' day (3),
'SKY',
'NSSGLS',
'HENRIK PIHL',
'064-589383',
'HENRIK','PIHL',
current_date + interval '14' day (3),
current_date + interval '20' day (3),
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL);

INSERT INTO BOOK_GUEST VALUES (1421,
current_date - interval '15' day (3),
'SKY',
'NSSGLS',
'URBAN FRANSSON',
'017-7482103',
'URBAN','FRANSSON',
current_date,
current_date + interval '3' day (3),
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL);

INSERT INTO BILL VALUES (1347,LOCALTIMESTAMP - interval '1' day (3),'100');
INSERT INTO BILL VALUES (1347,LOCALTIMESTAMP - interval '1' day (3),'120');
INSERT INTO BILL VALUES (1347,LOCALTIMESTAMP - interval '1' day (3),'210');
INSERT INTO BILL VALUES (1347,LOCALTIMESTAMP - interval '1' day (3),'680');
INSERT INTO BILL VALUES (1347,LOCALTIMESTAMP - interval '1' day (3),'120');
INSERT INTO BILL VALUES (1348,LOCALTIMESTAMP - interval '2' day (3),'800');
INSERT INTO BILL VALUES (1348,LOCALTIMESTAMP - interval '1' day (3),'800');
INSERT INTO BILL VALUES (1348,LOCALTIMESTAMP - interval '2' day (3),'200');
INSERT INTO BILL VALUES (1348,LOCALTIMESTAMP - interval '1' day (3),'230');
INSERT INTO BILL VALUES (1349,LOCALTIMESTAMP - interval '53' day (3),'700');
INSERT INTO BILL VALUES (1349,LOCALTIMESTAMP - interval '53' day (3),'170');
INSERT INTO BILL VALUES (1349,LOCALTIMESTAMP - interval '53' day (3),'900');
INSERT INTO BILL VALUES (1350,LOCALTIMESTAMP - interval '1' day (3),'1080');
INSERT INTO BILL VALUES (1350,LOCALTIMESTAMP - interval '1' day (3),'210');
INSERT INTO BILL VALUES (1350,LOCALTIMESTAMP - interval '1' day (3),'100' );
INSERT INTO BILL VALUES (1350,LOCALTIMESTAMP - interval '1' day (3),'200' );
INSERT INTO BILL VALUES (1350,LOCALTIMESTAMP - interval '1' day (3),'230' );
INSERT INTO BILL VALUES (1350,LOCALTIMESTAMP - interval '1' day (3),'330' );
INSERT INTO BILL VALUES (1350,LOCALTIMESTAMP - interval '1' day (3),'100' );
INSERT INTO BILL VALUES (1350,LOCALTIMESTAMP - interval '1' day (3),'120' );
INSERT INTO BILL VALUES (1350,LOCALTIMESTAMP - interval '1' day (3),'270' );
INSERT INTO BILL VALUES (1351,LOCALTIMESTAMP - interval '72' day (3),'700' );
INSERT INTO BILL VALUES (1351,LOCALTIMESTAMP - interval '72' day (3),'120' );
INSERT INTO BILL VALUES (1351,LOCALTIMESTAMP - interval '71' day (3),'100' );
INSERT INTO BILL VALUES (1351,LOCALTIMESTAMP - interval '71' day (3),'120' );
INSERT INTO BILL VALUES (1351,LOCALTIMESTAMP - interval '71' day (3),'200' );
INSERT INTO BILL VALUES (1351,LOCALTIMESTAMP - interval '70' day (3),'100' );
INSERT INTO BILL VALUES (1351,LOCALTIMESTAMP - interval '70' day (3),'120' );
INSERT INTO BILL VALUES (1351,LOCALTIMESTAMP - interval '70' day (3),'200' );
INSERT INTO BILL VALUES (1351,LOCALTIMESTAMP - interval '69' day (3),'100' );
INSERT INTO BILL VALUES (1351,LOCALTIMESTAMP - interval '69' day (3),'200' );
INSERT INTO BILL VALUES (1352,LOCALTIMESTAMP - interval '64' day (3),'700' );
INSERT INTO BILL VALUES (1353,LOCALTIMESTAMP - interval '1' day (3),'100' );
INSERT INTO BILL VALUES (1353,LOCALTIMESTAMP - interval '2' day (3),'170' );
INSERT INTO BILL VALUES (1353,LOCALTIMESTAMP - interval '41' day (3),'870' );
INSERT INTO BILL VALUES (1353,LOCALTIMESTAMP - interval '1' day (3),'170' );
INSERT INTO BILL VALUES (1353,LOCALTIMESTAMP,'100' );
INSERT INTO BILL VALUES (1353,LOCALTIMESTAMP - interval '1' day (3),'120' );
INSERT INTO BILL VALUES (1353,LOCALTIMESTAMP - interval '2' day (3),'170' );
INSERT INTO BILL VALUES (1353,LOCALTIMESTAMP - interval '1' day (3),'100' );
INSERT INTO BILL VALUES (1353,LOCALTIMESTAMP - interval '1' day (3),'170' );
INSERT INTO BILL VALUES (1353,LOCALTIMESTAMP - interval '2' day (3),'100' );
INSERT INTO BILL VALUES (1353,LOCALTIMESTAMP - interval '1' day (3),'170' );
INSERT INTO BILL VALUES (1354,LOCALTIMESTAMP - interval '63' day (3),'700' );
INSERT INTO BILL VALUES (1354,LOCALTIMESTAMP - interval '63' day (3),'200' );
INSERT INTO BILL VALUES (1354,LOCALTIMESTAMP - interval '63' day (3),'230' );
INSERT INTO BILL VALUES (1354,LOCALTIMESTAMP - interval '62' day (3),'100' );
INSERT INTO BILL VALUES (1354,LOCALTIMESTAMP - interval '62' day (3),'200' );
INSERT INTO BILL VALUES (1354,LOCALTIMESTAMP - interval '62' day (3),'230' );
INSERT INTO BILL VALUES (1354,LOCALTIMESTAMP - interval '61' day (3),'100' );
INSERT INTO BILL VALUES (1354,LOCALTIMESTAMP - interval '61' day (3),'270' );
INSERT INTO BILL VALUES (1355,LOCALTIMESTAMP - interval '44' day (3),'1080' );
INSERT INTO BILL VALUES (1355,LOCALTIMESTAMP - interval '44' day (3),'120' );
INSERT INTO BILL VALUES (1355,LOCALTIMESTAMP - interval '44' day (3),'900' );
INSERT INTO BILL VALUES (1355,LOCALTIMESTAMP - interval '43' day (3),'100' );
INSERT INTO BILL VALUES (1356,LOCALTIMESTAMP - interval '1' day (3),'700' );
INSERT INTO BILL VALUES (1356,LOCALTIMESTAMP - interval '1' day (3),'210' );
INSERT INTO BILL VALUES (1356,LOCALTIMESTAMP - interval '1' day (3),'100' );
INSERT INTO BILL VALUES (1356,LOCALTIMESTAMP - interval '1' day (3),'200' );
INSERT INTO BILL VALUES (1356,LOCALTIMESTAMP - interval '1' day (3),'100' );
INSERT INTO BILL VALUES (1356,LOCALTIMESTAMP - interval '1' day (3),'200' );
INSERT INTO BILL VALUES (1357,LOCALTIMESTAMP,'100' );
INSERT INTO BILL VALUES (1357,LOCALTIMESTAMP,'120' );
INSERT INTO BILL VALUES (1357,LOCALTIMESTAMP - interval '1' day (3),'330' );
INSERT INTO BILL VALUES (1357,LOCALTIMESTAMP - interval '1' day (3),'270' );
INSERT INTO BILL VALUES (1357,LOCALTIMESTAMP,'100' );
INSERT INTO BILL VALUES (1357,LOCALTIMESTAMP - interval '1' day (3),'1080' );
INSERT INTO BILL VALUES (1358,LOCALTIMESTAMP - interval '1' day (3),'750' );
INSERT INTO BILL VALUES (1358,LOCALTIMESTAMP - interval '1' day (3),'100' );
INSERT INTO BILL VALUES (1359,LOCALTIMESTAMP - interval '63' day (3),'700' );
INSERT INTO BILL VALUES (1359,LOCALTIMESTAMP - interval '64' day (3),'210' );
INSERT INTO BILL VALUES (1359,LOCALTIMESTAMP - interval '63' day (3),'100' );
INSERT INTO BILL VALUES (1360,LOCALTIMESTAMP - interval '44' day (3),'700' );
INSERT INTO BILL VALUES (1360,LOCALTIMESTAMP - interval '43' day (3),'100' );
INSERT INTO BILL VALUES (1361,LOCALTIMESTAMP - interval '44' day (3),'700' );
INSERT INTO BILL VALUES (1361,LOCALTIMESTAMP - interval '43' day (3),'100' );
INSERT INTO BILL VALUES (1362,LOCALTIMESTAMP - interval '63' day (3),'700' );
INSERT INTO BILL VALUES (1362,LOCALTIMESTAMP - interval '62' day (3),'100' );
INSERT INTO BILL VALUES (1362,LOCALTIMESTAMP - interval '62' day (3),'200' );
INSERT INTO BILL VALUES (1362,LOCALTIMESTAMP - interval '61' day (3),'100' );
INSERT INTO BILL VALUES (1362,LOCALTIMESTAMP - interval '61' day (3),'200' );
INSERT INTO BILL VALUES (1363,LOCALTIMESTAMP - interval '56' day (3),'700' );
INSERT INTO BILL VALUES (1363,LOCALTIMESTAMP - interval '55' day (3),'100' );
INSERT INTO BILL VALUES (1363,LOCALTIMESTAMP - interval '55' day (3),'230' );
INSERT INTO BILL VALUES (1363,LOCALTIMESTAMP - interval '54' day (3),'100' );
INSERT INTO BILL VALUES (1363,LOCALTIMESTAMP - interval '54' day (3),'210' );
INSERT INTO BILL VALUES (1363,LOCALTIMESTAMP - interval '53' day (3),'100' );
INSERT INTO BILL VALUES (1363,LOCALTIMESTAMP - interval '52' day (3),'100' );
INSERT INTO BILL VALUES (1363,LOCALTIMESTAMP - interval '52' day (3),'120' );
INSERT INTO BILL VALUES (1363,LOCALTIMESTAMP - interval '51' day (3),'100' );
INSERT INTO BILL VALUES (1364,LOCALTIMESTAMP - interval '44' day (3),'700' );
INSERT INTO BILL VALUES (1364,LOCALTIMESTAMP - interval '43' day (3),'100' );
INSERT INTO BILL VALUES (1364,LOCALTIMESTAMP - interval '43' day (3),'200' );
INSERT INTO BILL VALUES (1364,LOCALTIMESTAMP - interval '42' day (3),'100' );
INSERT INTO BILL VALUES (1367,LOCALTIMESTAMP - interval '39' day (3),'700' );
INSERT INTO BILL VALUES (1368,LOCALTIMESTAMP - interval '65' day (3),'870' );
INSERT INTO BILL VALUES (1368,LOCALTIMESTAMP - interval '65' day (3),'200' );
INSERT INTO BILL VALUES (1369,LOCALTIMESTAMP,'1570' );
INSERT INTO BILL VALUES (1369,LOCALTIMESTAMP,'120' );
INSERT INTO BILL VALUES (1369,LOCALTIMESTAMP,'100' );
INSERT INTO BILL VALUES (1370,LOCALTIMESTAMP - interval '2' day (3),'1570' );
INSERT INTO BILL VALUES (1370,LOCALTIMESTAMP - interval '3' day (3),'100' );
INSERT INTO BILL VALUES (1371,LOCALTIMESTAMP - interval '47' day (3),'700' );
INSERT INTO BILL VALUES (1371,LOCALTIMESTAMP - interval '47' day (3),'230' );
INSERT INTO BILL VALUES (1371,LOCALTIMESTAMP - interval '46' day (3),'100' );
INSERT INTO BILL VALUES (1371,LOCALTIMESTAMP - interval '45' day (3),'100' );
INSERT INTO BILL VALUES (1371,LOCALTIMESTAMP - interval '45' day (3),'200' );
INSERT INTO BILL VALUES (1371,LOCALTIMESTAMP - interval '45' day (3),'230' );
INSERT INTO BILL VALUES (1371,LOCALTIMESTAMP - interval '44' day (3),'100' );
INSERT INTO BILL VALUES (1371,LOCALTIMESTAMP - interval '44' day (3),'270' );
INSERT INTO BILL VALUES (1371,LOCALTIMESTAMP - interval '43' day (3),'100' );
INSERT INTO BILL VALUES (1371,LOCALTIMESTAMP - interval '43' day (3),'330' );
INSERT INTO BILL VALUES (1371,LOCALTIMESTAMP - interval '42' day (3),'100' );
INSERT INTO BILL VALUES (1371,LOCALTIMESTAMP - interval '42' day (3),'200' );
INSERT INTO BILL VALUES (1371,LOCALTIMESTAMP - interval '41' day (3),'100' );
INSERT INTO BILL VALUES (1372,LOCALTIMESTAMP - interval '1' day (3),'800' );
INSERT INTO BILL VALUES (1374,LOCALTIMESTAMP - interval '22' day (3),'100' );
INSERT INTO BILL VALUES (1374,LOCALTIMESTAMP - interval '21' day (3),'100' );
INSERT INTO BILL VALUES (1374,LOCALTIMESTAMP - interval '20' day (3),'100' );
INSERT INTO BILL VALUES (1374,LOCALTIMESTAMP - interval '19' day (3),'100' );
INSERT INTO BILL VALUES (1374,LOCALTIMESTAMP - interval '18' day (3),'100' );
INSERT INTO BILL VALUES (1374,LOCALTIMESTAMP - interval '17' day (3),'100' );
INSERT INTO BILL VALUES (1379,LOCALTIMESTAMP - interval '40' day (3),'700' );
INSERT INTO BILL VALUES (1379,LOCALTIMESTAMP - interval '39' day (3),'100' );
INSERT INTO BILL VALUES (1379,LOCALTIMESTAMP - interval '38' day (3),'100' );
INSERT INTO BILL VALUES (1379,LOCALTIMESTAMP - interval '37' day (3),'100' );
INSERT INTO BILL VALUES (1379,LOCALTIMESTAMP - interval '37' day (3),'200' );
INSERT INTO BILL VALUES (1380,LOCALTIMESTAMP - interval '46' day (3),'700' );
INSERT INTO BILL VALUES (1380,LOCALTIMESTAMP - interval '45' day (3),'100' );
INSERT INTO BILL VALUES (1380,LOCALTIMESTAMP - interval '45' day (3),'120' );
INSERT INTO BILL VALUES (1380,LOCALTIMESTAMP - interval '45' day (3),'230' );
INSERT INTO BILL VALUES (1380,LOCALTIMESTAMP - interval '44' day (3),'100' );
INSERT INTO BILL VALUES (1381,LOCALTIMESTAMP - interval '31' day (3),'700' );
INSERT INTO BILL VALUES (1381,LOCALTIMESTAMP - interval '30' day (3),'100' );
INSERT INTO BILL VALUES (1381,LOCALTIMESTAMP - interval '29' day (3),'100' );
INSERT INTO BILL VALUES (1381,LOCALTIMESTAMP - interval '28' day (3),'100' );
INSERT INTO BILL VALUES (1381,LOCALTIMESTAMP - interval '27' day (3),'100' );
INSERT INTO BILL VALUES (1381,LOCALTIMESTAMP - interval '26' day (3),'100' );
INSERT INTO BILL VALUES (1381,LOCALTIMESTAMP - interval '25' day (3),'100' );
INSERT INTO BILL VALUES (1381,LOCALTIMESTAMP - interval '24' day (3),'100' );
INSERT INTO BILL VALUES (1381,LOCALTIMESTAMP - interval '23' day (3),'100' );
INSERT INTO BILL VALUES (1381,LOCALTIMESTAMP - interval '22' day (3),'100' );
INSERT INTO BILL VALUES (1382,LOCALTIMESTAMP - interval '16' day (3),'700' );
INSERT INTO BILL VALUES (1382,LOCALTIMESTAMP - interval '16' day (3),'720' );
INSERT INTO BILL VALUES (1382,LOCALTIMESTAMP - interval '15' day (3),'100' );
INSERT INTO BILL VALUES (1382,LOCALTIMESTAMP - interval '15' day (3),'720' );
INSERT INTO BILL VALUES (1382,LOCALTIMESTAMP - interval '14' day (3),'100' );
INSERT INTO BILL VALUES (1382,LOCALTIMESTAMP - interval '14' day (3),'720' );
INSERT INTO BILL VALUES (1383,LOCALTIMESTAMP - interval '45' day (3),'700' );
INSERT INTO BILL VALUES (1383,LOCALTIMESTAMP - interval '45' day (3),'170' );
INSERT INTO BILL VALUES (1383,LOCALTIMESTAMP - interval '44' day (3),'100' );
INSERT INTO BILL VALUES (1383,LOCALTIMESTAMP - interval '44' day (3),'170' );
INSERT INTO BILL VALUES (1384,LOCALTIMESTAMP - interval '5' day (3),'1370' );
INSERT INTO BILL VALUES (1384,LOCALTIMESTAMP - interval '4' day (3),'100' );
INSERT INTO BILL VALUES (1384,LOCALTIMESTAMP - interval '3' day (3),'120' );
INSERT INTO BILL VALUES (1384,LOCALTIMESTAMP - interval '2' day (3),'100' );
INSERT INTO BILL VALUES (1384,LOCALTIMESTAMP - interval '3' day (3),'100' );
INSERT INTO BILL VALUES (1384,LOCALTIMESTAMP - interval '2' day (3),'120' );
INSERT INTO BILL VALUES (1384,LOCALTIMESTAMP - interval '1' day (3),'100' );
INSERT INTO BILL VALUES (1384,LOCALTIMESTAMP - interval '1' day (3),'100' );
INSERT INTO BILL VALUES (1384,LOCALTIMESTAMP - interval '1' day (3),'120' );
INSERT INTO BILL VALUES (1384,LOCALTIMESTAMP,'100' );
INSERT INTO BILL VALUES (1385,LOCALTIMESTAMP - interval '4' day (3),'1370' );
INSERT INTO BILL VALUES (1385,LOCALTIMESTAMP - interval '3' day (3),'100' );
INSERT INTO BILL VALUES (1385,LOCALTIMESTAMP - interval '2' day (3),'100' );
INSERT INTO BILL VALUES (1385,LOCALTIMESTAMP - interval '1' day (3),'100' );
INSERT INTO BILL VALUES (1385,LOCALTIMESTAMP - interval '1' day (3),'100' );
INSERT INTO BILL VALUES (1385,LOCALTIMESTAMP - interval '2' day (3),'100' );
INSERT INTO BILL VALUES (1385,LOCALTIMESTAMP - interval '3' day (3),'100' );
INSERT INTO BILL VALUES (1386,LOCALTIMESTAMP - interval '25' day (3),'700' );
INSERT INTO BILL VALUES (1386,LOCALTIMESTAMP - interval '25' day (3),'270' );
INSERT INTO BILL VALUES (1386,LOCALTIMESTAMP - interval '24' day (3),'100' );
INSERT INTO BILL VALUES (1386,LOCALTIMESTAMP - interval '24' day (3),'230' );
INSERT INTO BILL VALUES (1388,LOCALTIMESTAMP - interval '20' day (3),'700' );
INSERT INTO BILL VALUES (1388,LOCALTIMESTAMP - interval '19' day (3),'100' );
INSERT INTO BILL VALUES (1388,LOCALTIMESTAMP - interval '19' day (3),'200' );
INSERT INTO BILL VALUES (1388,LOCALTIMESTAMP - interval '19' day (3),'230' );
INSERT INTO BILL VALUES (1388,LOCALTIMESTAMP - interval '18' day (3),'100' );
INSERT INTO BILL VALUES (1388,LOCALTIMESTAMP - interval '18' day (3),'120' );
INSERT INTO BILL VALUES (1389,LOCALTIMESTAMP - interval '1' day (3),'800' );
INSERT INTO BILL VALUES (1389,LOCALTIMESTAMP - interval '1' day (3),'210' );
INSERT INTO BILL VALUES (1389,LOCALTIMESTAMP - interval '1' day (3),'100' );
INSERT INTO BILL VALUES (1391,LOCALTIMESTAMP - interval '36' day (3),'700' );
INSERT INTO BILL VALUES (1391,LOCALTIMESTAMP - interval '35' day (3),'100' );
INSERT INTO BILL VALUES (1391,LOCALTIMESTAMP - interval '35' day (3),'330' );
INSERT INTO BILL VALUES (1391,LOCALTIMESTAMP - interval '34' day (3),'100' );
INSERT INTO BILL VALUES (1391,LOCALTIMESTAMP - interval '34' day (3),'200' );
INSERT INTO BILL VALUES (1391,LOCALTIMESTAMP - interval '33' day (3),'100' );
INSERT INTO BILL VALUES (1392,LOCALTIMESTAMP - interval '17' day (3),'700' );
INSERT INTO BILL VALUES (1392,LOCALTIMESTAMP - interval '17' day (3),'720' );
INSERT INTO BILL VALUES (1392,LOCALTIMESTAMP - interval '16' day (3),'100' );
INSERT INTO BILL VALUES (1392,LOCALTIMESTAMP - interval '16' day (3),'120' );
INSERT INTO BILL VALUES (1392,LOCALTIMESTAMP - interval '16' day (3),'720' );
INSERT INTO BILL VALUES (1392,LOCALTIMESTAMP - interval '15' day (3),'100' );
INSERT INTO BILL VALUES (1392,LOCALTIMESTAMP - interval '15' day (3),'720' );
INSERT INTO BILL VALUES (1393,LOCALTIMESTAMP - interval '1' day (3),'100' );
INSERT INTO BILL VALUES (1393,LOCALTIMESTAMP - interval '17' day (3),'1410' );
INSERT INTO BILL VALUES (1393,LOCALTIMESTAMP - interval '17' day (3),'100' );
INSERT INTO BILL VALUES (1393,LOCALTIMESTAMP - interval '17' day (3),'100' );
INSERT INTO BILL VALUES (1393,LOCALTIMESTAMP - interval '17' day (3),'100' );
INSERT INTO BILL VALUES (1395,LOCALTIMESTAMP - interval '21' day (3),'700' );
INSERT INTO BILL VALUES (1395,LOCALTIMESTAMP - interval '20' day (3),'100' );
INSERT INTO BILL VALUES (1395,LOCALTIMESTAMP - interval '20' day (3),'900' );
INSERT INTO BILL VALUES (1395,LOCALTIMESTAMP - interval '19' day (3),'100' );
INSERT INTO BILL VALUES (1396,LOCALTIMESTAMP - interval '15' day (3),'100' );
INSERT INTO BILL VALUES (1396,LOCALTIMESTAMP - interval '15' day (3),'230' );
INSERT INTO BILL VALUES (1396,LOCALTIMESTAMP - interval '14' day (3),'700' );
INSERT INTO BILL VALUES (1396,LOCALTIMESTAMP - interval '14' day (3),'120' );
INSERT INTO BILL VALUES (1397,LOCALTIMESTAMP - interval '1' day (3),'870' );
INSERT INTO BILL VALUES (1397,LOCALTIMESTAMP - interval '1' day (3),'100' );
INSERT INTO BILL VALUES (1398,LOCALTIMESTAMP - interval '2' day (3),'600' );
INSERT INTO BILL VALUES (1398,LOCALTIMESTAMP - interval '1' day (3),'100' );
INSERT INTO BILL VALUES (1399,LOCALTIMESTAMP - interval '18' day (3),'700' );
INSERT INTO BILL VALUES (1399,LOCALTIMESTAMP - interval '17' day (3),'100' );
INSERT INTO BILL VALUES (1399,LOCALTIMESTAMP - interval '17' day (3),'270' );
INSERT INTO BILL VALUES (1399,LOCALTIMESTAMP - interval '16' day (3),'100' );
INSERT INTO BILL VALUES (1399,LOCALTIMESTAMP - interval '15' day (3),'100' );
INSERT INTO BILL VALUES (1399,LOCALTIMESTAMP - interval '15' day (3),'230' );
INSERT INTO BILL VALUES (1401,LOCALTIMESTAMP - interval '22' day (3),'700' );
INSERT INTO BILL VALUES (1401,LOCALTIMESTAMP - interval '21' day (3),'100' );
INSERT INTO BILL VALUES (1401,LOCALTIMESTAMP - interval '20' day (3),'100' );
INSERT INTO BILL VALUES (1401,LOCALTIMESTAMP - interval '19' day (3),'100' );
INSERT INTO BILL VALUES (1401,LOCALTIMESTAMP - interval '18' day (3),'100' );
INSERT INTO BILL VALUES (1401,LOCALTIMESTAMP - interval '17' day (3),'100' );
INSERT INTO BILL VALUES (1404,LOCALTIMESTAMP - interval '25' day (3),'700' );
INSERT INTO BILL VALUES (1404,LOCALTIMESTAMP - interval '24' day (3),'100' );
INSERT INTO BILL VALUES (1404,LOCALTIMESTAMP - interval '24' day (3),'200' );
INSERT INTO BILL VALUES (1404,LOCALTIMESTAMP - interval '23' day (3),'100' );
INSERT INTO BILL VALUES (1404,LOCALTIMESTAMP - interval '22' day (3),'100' );
INSERT INTO BILL VALUES (1404,LOCALTIMESTAMP - interval '21' day (3),'100' );
INSERT INTO BILL VALUES (1404,LOCALTIMESTAMP - interval '20' day (3),'100' );
INSERT INTO BILL VALUES (1405,LOCALTIMESTAMP - interval '26' day (3),'700' );
INSERT INTO BILL VALUES (1405,LOCALTIMESTAMP - interval '25' day (3),'100' );
INSERT INTO BILL VALUES (1405,LOCALTIMESTAMP - interval '25' day (3),'330' );
INSERT INTO BILL VALUES (1405,LOCALTIMESTAMP - interval '24' day (3),'100' );
INSERT INTO BILL VALUES (1408,LOCALTIMESTAMP - interval '3' day (3),'1090' );
INSERT INTO BILL VALUES (1408,LOCALTIMESTAMP - interval '2' day (3),'720' );
INSERT INTO BILL VALUES (1408,LOCALTIMESTAMP - interval '1' day (3),'100' );
INSERT INTO BILL VALUES (1408,LOCALTIMESTAMP - interval '1' day (3),'720' );
INSERT INTO BILL VALUES (1408,LOCALTIMESTAMP - interval '1' day (3),'100' );
INSERT INTO BILL VALUES (1408,LOCALTIMESTAMP - interval '1' day (3),'720' );
INSERT INTO BILL VALUES (1408,LOCALTIMESTAMP - interval '2' day (3),'100' );
INSERT INTO BILL VALUES (1408,LOCALTIMESTAMP - interval '3' day (3),'720' );
INSERT INTO BILL VALUES (1408,LOCALTIMESTAMP - interval '2' day (3),'100' );
INSERT INTO BILL VALUES (1408,LOCALTIMESTAMP - interval '1' day (3),'720' );
INSERT INTO BILL VALUES (1408,LOCALTIMESTAMP - interval '1' day (3),'100' );
INSERT INTO BILL VALUES (1408,LOCALTIMESTAMP - interval '1' day (3),'720' );
INSERT INTO BILL VALUES (1412,LOCALTIMESTAMP - interval '3' day (3),'1570' );
INSERT INTO BILL VALUES (1412,LOCALTIMESTAMP - interval '2' day (3),'200' );
INSERT INTO BILL VALUES (1412,LOCALTIMESTAMP - interval '1' day (3),'100' );
INSERT INTO BILL VALUES (1413,LOCALTIMESTAMP - interval '20' day (3),'700' );
INSERT INTO BILL VALUES (1413,LOCALTIMESTAMP - interval '19' day (3),'100' );
INSERT INTO BILL VALUES (1413,LOCALTIMESTAMP - interval '18' day (3),'100' );
INSERT INTO BILL VALUES (1413,LOCALTIMESTAMP - interval '17' day (3),'100' );

INSERT INTO EXCHANGE_RATE VALUES ('DEM',0.2230);
INSERT INTO EXCHANGE_RATE VALUES ('GBP',0.0810);
INSERT INTO EXCHANGE_RATE VALUES ('DKK',0.8495);
INSERT INTO EXCHANGE_RATE VALUES ('FIM',0.6560);
INSERT INTO EXCHANGE_RATE VALUES ('FRF',0.7420);
INSERT INTO EXCHANGE_RATE VALUES ('ITL',206.82);
INSERT INTO EXCHANGE_RATE VALUES ('JPY',16.38);
INSERT INTO EXCHANGE_RATE VALUES ('NOK',0.8815);
INSERT INTO EXCHANGE_RATE VALUES ('SEK',1.000);
INSERT INTO EXCHANGE_RATE VALUES ('USD',0.1330);

INSERT INTO WAKE_UP VALUES ('LAP112',current_date,time '06:00:00');
INSERT INTO WAKE_UP VALUES ('LAP112',current_date + interval '1' day (3),time '07:00:00');
INSERT INTO WAKE_UP VALUES ('LAP201',current_date + interval '1' day (3),time '06:45:00');
INSERT INTO WAKE_UP VALUES ('LAP205',current_date,time '08:00:00');
INSERT INTO WAKE_UP VALUES ('SKY101',current_date,time '09:00:00');
INSERT INTO WAKE_UP VALUES ('SKY110',current_date,time '07:30:00');
INSERT INTO WAKE_UP VALUES ('SKY111',current_date,time '06:00:00');
INSERT INTO WAKE_UP VALUES ('SKY124',current_date,time '06:15:00');
INSERT INTO WAKE_UP VALUES ('SKY124',current_date + interval '1' day (3),time '06:15:00');
INSERT INTO WAKE_UP VALUES ('SKY124',current_date + interval '2' day (3),time '06:15:00');
INSERT INTO WAKE_UP VALUES ('SKY201',current_date,time '10:00:00');
INSERT INTO WAKE_UP VALUES ('SKY212',current_date,time '04:30:00');
INSERT INTO WAKE_UP VALUES ('STG009',current_date,time '06:00:00');
INSERT INTO WAKE_UP VALUES ('STG117',current_date,time '07:00:00');
INSERT INTO WAKE_UP VALUES ('STG142',current_date,time '08:30:00');
INSERT INTO WAKE_UP VALUES ('WIND401',current_date + interval '1' day (3),time '06:00:00');
INSERT INTO WAKE_UP VALUES ('WIND402',current_date,time '06:20:00');
INSERT INTO WAKE_UP VALUES ('WIND514',current_date,time '07:00:00');
INSERT INTO WAKE_UP VALUES ('WINS119',current_date,time '08:00:00');
INSERT INTO WAKE_UP VALUES ('WINS120',current_date,time '07:30:00');
INSERT INTO WAKE_UP VALUES ('WINS121',current_date,time '06:20:00');




