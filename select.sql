select * from bill;
select BG.RESERVATION,CHECKIN,CHECKOUT,ARRIVE,DEPART,ON_DATE from bill left join BOOK_GUEST BG on BILL.RESERVATION = BG.RESERVATION;
select count(*) from bill left join BOOK_GUEST BG on BILL.RESERVATION = BG.RESERVATION;
select count(*) from bill left join BOOK_GUEST BG on BILL.RESERVATION = BG.RESERVATION where cast(ON_DATE as DATE)=CHECKIN;

--Distinct
select distinct(RESERVED_FNAME )from BOOK_GUEST b;

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
from BOOK_GUEST;

-- Group by /HAVING
select B.RESERVATION, count(b.CHARGE_CODE) from BOOK_GUEST left join BILL B on BOOK_GUEST.RESERVATION = B.RESERVATION group by B.RESERVATION;
select B.RESERVATION, count(b.CHARGE_CODE) from BOOK_GUEST left join BILL B on BOOK_GUEST.RESERVATION = B.RESERVATION group by B.RESERVATION having count(b.CHARGE_CODE)>10;


select count(*) from BOOK_GUEST natural join BILL B;
select count(*) from BOOK_GUEST left join BILL B on BOOK_GUEST.RESERVATION = B.RESERVATION;