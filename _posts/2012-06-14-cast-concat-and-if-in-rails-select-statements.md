---
layout: post
status: publish
published: true
title: CAST, CONCAT and IF in rails select statements
author: Edward Andrews
date: "2012-06-14 15:13:56 +0100"
date_gmt: "2012-06-14 14:13:56 +0100"
categories:
  - database
  - ruby on rails
tags:
  - database
  - ruby on rails
  - mysql
comments: []
---

<p>I've been creating a feed for a legacy mobile app, which expects a json feed with a very different structure to what my new rails app produces.</p>
<p>Initially I was doing this using lots of ruby loops, but it quickly became apparent that this was far too processor intensive.  So my alternative approach has been to dig down into the database layer and use some interesting MYSQL.</p>
<p>This is about the most compicated call I've had to use.  As you can see it adds in extra fields, CASTs integers into CHARs, strips "static_images/" off the front of the image file name using SUBSTRING and CONCATs '/image/' onto it.  And finally, it uses an IF to decide whether to output the link_title or '' as the minitipTitle.</p>

##### mobile_feed.rb:

```ruby
gateways = Article.joins("LEFT OUTER JOIN front_page_time_based_articles ON front_page_time_based_articles.article_id = articles.id")
            .where(
              "type = 'Gateway'
              AND articles.updated_at > :date", date: date
            )
            .select(
              "articles.created_at,
              articles.updated_at,
              body AS gatewayDescription,
              CONCAT('/images/', SUBSTRING(image, 15)) AS gatewayAppImage,
              CAST(old_id AS CHAR) AS gatewayID,
              '1' AS visible,
              '' AS gatewayCode,
              name AS gatewayName,
              IF(front_page_time_based_articles.link_title IS NOT NULL, front_page_time_based_articles.link_title, '') AS minitipTitle,
              IF(front_page_time_based_articles.link_text IS NOT NULL, front_page_time_based_articles.link_text, '') AS minitipDesc"
            )
```
