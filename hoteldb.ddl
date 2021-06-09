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