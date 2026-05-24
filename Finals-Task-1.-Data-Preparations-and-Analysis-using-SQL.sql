USE project;

CREATE TABLE calls (
    ID CHAR(50),
    cust_name CHAR (50),
    sentiment CHAR (20),
    csat_score INT,
    call_timestamp CHAR(10),
    reason CHAR (20),
    city CHAR(20),
    state CHAR (20),
    channel CHAR (20),
    response_time CHAR (20),
    call_duration_minutes INT,
   call_center CHAR (20)
);

ALTER TABLE calls
CHANGE call_date call_timestamp DATE;