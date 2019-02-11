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
<p>[rb]<br />
Articles.where("site_id = ?", site.id)<br />
[/rb]</p>
<p>It's not too bad, but it gets a bit much writing out a lot of times.</p>
<p>Now, I've added a scope.  In my article model I have</p>
<p>[rb title="app/models/article.rb"]<br />
class Article < ActiveRecord::Base<br />
  belongs_to :site</p>
<p>  scope :by_site, lambda {|site| where(:site_id => site.id) }</p>
<p>end<br />
[/rb]</p>
<p>Then you can write<br />
[rb]<br />
Articles.by_site(site)<br />
[/rb]<br />
and get the same thing as before.  Much clearer and also DRYer.</p>
