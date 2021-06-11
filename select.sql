-- noinspection SqlNoDataSourceInspectionForFile

select * from bill;
select BG.RESERVATION,CHECKIN,CHECKOUT,ARRIVE,DEPART,ON_DATE from bill left join BOOK_GUEST BG on BILL.RESERVATION = BG.RESERVATION;
select count(*) from bill left join BOOK_GUEST BG on BILL.RESERVATION = BG.RESERVATION;
select count(*) from bill left join BOOK_GUEST BG on BILL.RESERVATION = BG.RESERVATION where cast(ON_DATE as DATE)=CHECKIN;

--Distinct
select count(distinct(RESERVED_FNAME)) as guest_names, count(RESERVED_FNAME) as guest_with_name from BOOK_GUEST b;

-- Where
select * from BILL where RESERVATION=1351;
select * from BILL where RESERVATION IN(1351,1352);
select * from BOOK_GUEST where RESERVED_FNAME LIKE '%AD%'
--Scalar
select trim(GUEST_FNAME)||' '|| trim(BOOK_GUEST.GUEST_LNAME) from BOOK_GUEST;
select current_date from system.onerow;
select EXTRACT (month from current_date) as currentMonth  from system.onerow;

-- Cast
select c.CHARGE_PRICE||'kr' from charges c;
select cast(c.CHARGE_PRICE as varchar (5))||'kr' from charges c;


--Case
select
    case when GUEST_FNAME IS NULL
        then RESERVED_FNAME
        else GUEST_FNAME
    end as f_name
from BOOK_GUEST;select
    case when GUEST_FNAME IS NULL
        then RESERVED_FNAME
        else GUEST_FNAME
    end as f_name
from BOOK_GUEST;

-- Group by /HAVING
select B.RESERVATION, count(*) from BOOK_GUEST left join BILL B on BOOK_GUEST.RESERVATION = B.RESERVATION group by B.RESERVATION;
select B.RESERVATION, count(b.CHARGE_CODE) from BOOK_GUEST left join BILL B on BOOK_GUEST.RESERVATION = B.RESERVATION group by B.RESERVATION having count(b.CHARGE_CODE)>10;


-- Joins
select count(*) from BOOK_GUEST BG left outer join BILL B on BG.RESERVATION = B.RESERVATION;
select count(*) from BOOK_GUEST BG inner join BILL B on BG.RESERVATION = B.RESERVATION;


--Subselect
select b.CHARGE_CODE  from BILL b left join CHARGES c on b.CHARGE_CODE = c.CHARGE_CODE order by c.CHARGE_PRICE;
select b.CHARGE_CODE from bill b where b.charge_code=(select c.charge_code from charges c order by c.charge_price fetch first row);

-- View simple
create view checked_in_guests as
select * from BOOK_GUEST BG where checkout is null and HOTELCODE='WIND'
with check option;

INSERT INTO checked_in_guests (
    RESERVATION, BOOKING_DATE, HOTELCODE, ROOMTYPE, COMPANY, TELEPHONE, RESERVED_FNAME, RESERVED_LNAME, ARRIVE, DEPART, GUEST_FNAME, GUEST_LNAME, ADDRESS, CHECKIN, CHECKOUT, ROOMNO, PAYMENT)
VALUES (2000, DATE'2001-03-18', 'WIND', 'NSDBLS', 'Mimer', '0187809200', 'Richard', 'Widén', DATE'2001-06-18', DATE'2001-06-19', '', '', '', DEFAULT, DEFAULT, 'LAP200', '');
select * from checked_in_guests;

-- View With on insert (fails)
create view checked_in_guests as
select BG.RESERVATION,BG.RESERVED_FNAME,BG.RESERVED_LNAME from BOOK_GUEST BG where checkout is null and HOTELCODE='WIND'
with check option;
--Fails:
INSERT INTO checked_in_guests (RESERVED_FNAME,RESERVED_LNAME) values('Richard','Widén')
select * from checked_in_guests;

-- Adding trigger
@delimiter %%%;
CREATE TRIGGER ins_check_in
    instead of INSERT
    on checked_in_guests
    referencing new table as new_tab
for each statement
begin atomic
insert into BOOK_GUEST(
    RESERVATION, BOOKING_DATE, HOTELCODE, ROOMTYPE, COMPANY, TELEPHONE,
    RESERVED_FNAME,RESERVED_LNAME,
    ARRIVE, DEPART, GUEST_FNAME, GUEST_LNAME, ADDRESS, CHECKIN, CHECKOUT, ROOMNO, PAYMENT)
    VALUES (
        (select max(reservation)+1 from BOOK_GUEST) , DATE'2001-03-18', 'WIND', 'NSDBLS', 'Mimer', '0187809200',
        (select RESERVED_FNAME from new_tab ), (select RESERVED_LNAME from new_tab),
        DATE'2001-06-18', DATE'2001-06-19', '', '', '', DEFAULT, DEFAULT, 'LAP200', '');
end%%%
@delimiter ;
%%%

INSERT INTO checked_in_guests (RESERVED_FNAME,RESERVED_LNAME) values('Richard','Widén');
select * from checked_in_guests;

-- At the desk of the hotel the staff use a view "free_rooms" to find free
--rooms, as it is a joinview it is not updatable.
-- Create a insteadof trigger that allows this!
create view FREE_ROOMS as
    select r.roomno,r.hotelcode,t.description from rooms r left join roomtypes t on r.ROOMTYPE = t.ROOMTYPE
    where r.roomtype=t.roomtype
    and r.status='FREE';
select * from FREE_ROOMS;

-- Procedures
-- Resultset
@delimiter %%%;
create procedure hotnames2()
values (char (15),char(15)) as ("Hotel Name","City")
reads sql data
begin
    declare hot cursor for select NAME,CITY from HOTEL;
    declare l_nam char (15);
    declare l_cit char (15);
    declare l_r integer;
    open hot;
    lab1:loop
        fetch hot into l_nam,l_cit;
        get diagnostics l_r = row_count;
        if l_r = 0 then
            leave lab1;
        else
            return l_nam,l_cit;
        end if;
    end loop lab1;
    close hot;
end%%%
@delimiter ;
%%%
call hotnames2();