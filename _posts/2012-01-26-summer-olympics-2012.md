---
layout: post
status: publish
published: true
title: Summer Olympics 2012
author: Edward Andrews
date: "2012-01-26 15:44:43 +0000"
date_gmt: "2012-01-26 15:44:43 +0000"
categories:
  - oracle
  - database
tags:
  - database
  - oracle
  - apex
  - university
  - trigger
  - model
comments: []
---

<p>My Database Design and Implementation module involved thinking about the organisation of the London Olympics.  First we modelled the data that would be needed.</p>

[![First QSEE Olympic games model](/assets/olympics/First-QSEE-Olympic-games-model-300x197.jpg)](/assets/olympics/First-QSEE-Olympic-games-model.jpg)
[![Composite QSEE Olympic games model](/assets/olympics/Composite-QSEE-Olympic-games-model-300x180.jpg)](/assets/olympics/Composite-QSEE-Olympic-games-model.jpg)

<p>Then we implemented parts of the system in Oracle Apex to produce a web accessible database.</p>
<p>The most complicated thing I made was a trigger that would check to see if an official already had something in their schedule 2 hours either side a new record in the schedule.</p>

```sql
CREATE
OR
replace TRIGGER "SCHEDULE_OFFICIAL_TIME_T1" BEFORE
INSERT
ON "SCHEDULE" FOR EACH ROW WHEN (
              NEW.date_time IS NOT NULL) BEGIN DECLARE l_exists INTEGER;

BEGIN
  SELECT count(*)
  INTO   l_exists
  FROM   schedule
  WHERE  official_id = :new.official_id
  AND    date_time BETWEEN :new.date_time - interval '120' minute AND :new.date_time + interval '120' minute
  AND    ROWNUM = 1;

  IF l_exists = 1 THEN
    Raise_application_error(-20634, 'This time is within 2 hours of another scheduled time for this official.');
  END IF;
END;
END;
​
```

<p>The finished web app allowed you to view a few reports I had created, including one official's schedule.  It also allowed you to create and edit venues, events, officials, schedules etc.  I got apex to allow a drop down date and time picker, drop down lists of available venues and so on.</p>
<p>I got a distinction for this module.</p>

[![A single athlete's schedule](/assets/olympics/l2012_mia-300x221.png)](/assets/olympics/l2012_mia.png)
[![Four day schedule](/assets/olympics/l2012_4-300x221.png)](/assets/olympics/l2012_4.png)
[![Officials and supervisors](/assets/olympics/l2012_o_s-300x221.png)](/assets/olympics/l2012_o_s.png)
[![Creating a supervisor](/assets/olympics/l2012_sup-300x221.png)](/assets/olympics/l2012_sup.png)
[![Adding an event](/assets/olympics/l2012_edit-300x221.png)](/assets/olympics/l2012_edit.png)
