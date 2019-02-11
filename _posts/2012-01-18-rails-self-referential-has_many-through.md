---
layout: post
status: publish
published: true
title: Rails self referential has_many through
author: Edward Andrews
date: "2012-01-18 18:02:26 +0000"
date_gmt: "2012-01-18 18:02:26 +0000"
categories:
  - ruby on rails
tags:
  - rails
  - ruby on rails
  - self referential
  - link
  - children
  - parents
  - has_many
  - has_many through
comments:
  - id: 2
    author: Drag and drop in rails | epa.me.uk
    author_email: ""
    author_url: http://epa.me.uk/drag-and-drop-in-rails/
    date: "2012-03-04 11:45:32 +0000"
    date_gmt: "2012-03-04 11:45:32 +0000"
    content:
      "[...] I said in my earlier post, the product I&#8217;m developing has
      lots of self referential links between articles. Now that [...]"
---

<p>My first ruby on rails project is to redevelop the database, backend and frontend of an existing product.  It is an information resource for staff wellbeing used by universities, nhs trusts and large companies.  The resource consists of about 300 articles which are linked in a diagnostic "How are you today?" tree.  This means a lot of the value of the application is in the links between the articles.</p>
<p>So my first task was to learn how to do self referential links between articles in ruby on rails.</p>
<p>To demonstrate how it works here's a small demo app, just of articles and links. Here's the schema - articles have a name and body; links have parent_id and child_id to make the links between articles and weight to enable sorting.</p>
<p>[rb title="db/schema.rb"]ActiveRecord::Schema.define(:version => 20120115171005) do</p>
<p>  create_table "articles", :force => true do |t|<br />
    t.string   "name"<br />
    t.string   "body"<br />
    t.datetime "created_at"<br />
    t.datetime "updated_at"<br />
  end</p>
<p>  create_table "links", :force => true do |t|<br />
    t.integer  "parent_id"<br />
    t.integer  "child_id"<br />
    t.integer  "weight"<br />
    t.datetime "created_at"<br />
    t.datetime "updated_at"<br />
  end</p>
<p>end<br />
[/rb]</p>
<p>Here are the article and link models:</p>
<p>[rb title="app/models/article.rb"]<br />
class Article < ActiveRecord::Base<br />
  has_many :child_links, :class_name => "Link", :foreign_key => :parent_id<br />
  has_many :children, :through => :child_links, :source => :child</p>
<p>  has_many :parent_links, :class_name => "Link", :foreign_key => :child_id<br />
  has_many :parents, :through => :parent_links, :source => :parent<br />
end<br />
[/rb]</p>
<p>[rb title="app/models/link.rb"]<br />
class Link < ActiveRecord::Base<br />
  belongs_to :parent, :class_name => "Article"<br />
  belongs_to :child, :class_name => "Article"<br />
end<br />
[/rb]</p>
<p>How does it work?</p>
<p>You make the links belong_to parent and child - both of class_name "Article". This means you can refer to articles as parents or children.</p>
<p>Then in the article model, you make sure you set up the foreign key for the has_many, and the source for the has_many through the right way round:<br />
[rb]<br />
  has_many :child_links, :class_name => "Link", :foreign_key => :parent_id<br />
  has_many :children, :through => :child_links, :source => :child<br />
[/rb]<br />
parent_id is the foreign_key because child_links links from a parent to a child, and the article creating the link is the parent. Then the children come through this link (which is turned into the singular in the link model - rails is clever with all this pluralization stuff) as the source.</p>
<p>And visa versa with parent_links and parents.</p>
<p>Then in the rails console, if you create 2 articles id 1 & 2, you can do</p>
<p>[rb]<br />
Article.find(1).children<br />
[/rb]<br />
and get Article 2.<br />
[rb]<br />
Article.find(2).parents<br />
[/rb]<br />
to get Article 1.</p>
<p>Very useful once you get your head round it!</p>
<p>I've put a small demo app on github <a href="https://github.com/aldreth/self-referential-has_many-through">here</a>.</p>
