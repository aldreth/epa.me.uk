---
layout: post
status: publish
published: true
title: Scopes in ruby on rails
author: Edward Andrews
date: "2012-02-06 16:28:43 +0000"
date_gmt: "2012-02-06 16:28:43 +0000"
categories:
  - ruby on rails
tags:
  - ruby on rails
  - ruby
  - scope
  - search
  - block
  - proc.lambda
comments: []
---

<p>Reading through <a href="http://pragprog.com/book/rr2/rails-recipes">Rails Recipes: Rails 3 Edition</a> I discovered a much better way of doing my searches.</p>
<p>In my multi-domain application, articles belong to sites, sites have many articles.  I was finding articles that belonged to particular sites by doing</p>

```rb
Articles.where("site_id = ?", site.id)
```

<p>It's not too bad, but it gets a bit much writing out a lot of times.</p>
<p>Now, I've added a scope.  In my article model I have</p>

##### app/models/article.rb

```rb
class Article < ActiveRecord::Base
  belongs_to :site
  scope :by_site, lambda {|site| where(:site_id => site.id) }
end
```

Then you can write

```rb
Articles.by_site(site)
```

and get the same thing as before. Much clearer and also DRYer.
