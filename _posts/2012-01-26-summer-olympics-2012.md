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
<p><a href="http://epa.me.uk/wp-content/uploads/2012/03/First-QSEE-Olympic-games-model.jpg"><img class="alignleft size-thumbnail wp-image-83" title="First QSEE Olympic games model" src="http://epa.me.uk/wp-content/uploads/2012/03/First-QSEE-Olympic-games-model-150x150.jpg" alt="" width="150" height="150" /></a><a href="http://epa.me.uk/wp-content/uploads/2012/03/Composite-QSEE-Olympic-games-model.jpg"><img class="size-thumbnail wp-image-82 alignnone" title="Composite QSEE Olympic games model" src="http://epa.me.uk/wp-content/uploads/2012/03/Composite-QSEE-Olympic-games-model-150x150.jpg" alt="" width="150" height="150" /></a></p>
<p>Then we implemented parts of the system in Oracle Apex to produce a web accessible database.</p>
<p>The most complicated thing I made was a trigger that would check to see if an official already had something in their schedule 2 hours either side a new record in the schedule.</p>
<p>[sql]<br />
create or replace trigger "SCHEDULE_OFFICIAL_TIME_T1"<br />
BEFORE<br />
INSERT ON "SCHEDULE"<br />
FOR EACH row<br />
WHEN (new.date_time IS NOT null)<br />
BEGIN<br />
DECLARE<br />
l_exists INTEGER;<br />
BEGIN<br />
SELECT COUNT(*) INTO l_exists<br />
FROM schedule<br />
WHERE official_id = :new.official_id<br />
AND date_time<br />
BETWEEN :new.date_time - interval '120' minute<br />
AND :new.date_time + interval '120' minute</p>
<p>AND ROWNUM = 1;<br />
IF l_exists = 1 THEN<br />
raise_application_error(-20634, 'This time is within 2 hours of another<br />
scheduled time for this official.');<br />
END IF;<br />
END;<br />
END;​<br />
[/sql]</p>
<p>The finished web app allowed you to view a few reports I had created, including one official's schedule.  It also allowed you to create and edit venues, events, officials, schedules etc.  I got apex to allow a drop down date and time picker, drop down lists of available venues and so on.</p>
<p>I got a distinction for this module.</p>
<p>[gallery link="file"]</p>
