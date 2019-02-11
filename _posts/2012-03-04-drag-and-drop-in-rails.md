---
layout: post
status: publish
published: true
title: Drag and drop in rails
author: Edward Andrews
date: "2012-03-04 11:45:28 +0000"
date_gmt: "2012-03-04 11:45:28 +0000"
categories:
  - jquery
  - ajax
  - ruby on rails
tags:
  - jquery
  - ajax
  - rails
  - ruby on rails
  - drag
  - drop
  - drag and drop
comments:
  - id: 9
    author: Niklas
    author_email: niklas@sharpaxe.com
    author_url: http://www.sharpaxe.com
    date: "2012-08-10 06:22:27 +0100"
    date_gmt: "2012-08-10 05:22:27 +0100"
    content: Thanks, this helped me a lot!
---

<p>As I said in my earlier <a href="http://epa.me.uk/rails-self-referential-has_many-through/">post</a>, the product I'm developing has lots of self referential links between articles.  Now that I'm comfortable modeling them with has_many through relationships, I need to start thinking about how to build these links.  I need to have a nice graphical back end, in which I can drag thumbnail images representing articles and drop onto another article to make a link.</p>
<p>Enter <a href="http://jqueryui.com/demos/draggable/">jquery draggable</a>!  There are some great tutorials on the web on jquery, particularly this <a href="http://www.elated.com/articles/drag-and-drop-with-jquery-your-essential-guide/">one</a>, but no really good ones on using jquery draggable with rails.  It took me quite a long time to get this sorted out, especially as I was learning so many new things at once.</p>
<p>Continuing from the earlier article, I've added images to my articles - here's my current schema:</p>
<p>[rb title="db/schema.rb"]<br />
ActiveRecord::Schema.define(:version => 20120304112520) do</p>
<p>  create_table "articles", :force => true do |t|<br />
    t.string   "name"<br />
    t.string   "body"<br />
    t.string   "image"<br />
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
<p>On the show page, I've added graphical links to each of the article's children:<a href="http://epa.me.uk/wp-content/uploads/2012/03/dd_show.png"><img src="http://epa.me.uk/wp-content/uploads/2012/03/dd_show-258x300.png" alt="Drag and drop - show article page" title="Drag and drop - show article page" width="258" height="300" class="aligncenter size-medium wp-image-206" /></a></p>
<p>The edit page is very similar, with a blank placeholder image to drag new links into and a list of all the articles that can be linked to:<a href="http://epa.me.uk/wp-content/uploads/2012/03/dd_edit.png"><img src="http://epa.me.uk/wp-content/uploads/2012/03/dd_edit-258x300.png" alt="Drag and drop - edit article page" title="Drag and drop - edit article page" width="258" height="300" class="aligncenter size-medium wp-image-209" /></a></p>
<p>Here's the code for the edit page:<br />
[crayon title = "app/views/articles/edit.html.erb"]</p>
<h1>Editing article</h1>
<p><%= render 'form' %><br />
<%= render 'edit_child_articles' %></p>
<div id="all-articles">
  <%= render partial: @articles, locals: {in_edit: true} %>
</div>
<p><%= link_to 'Show', @article %> |<br />
<%= link_to 'Back', articles_path %><br />
[/crayon]</p>
<p>The form is the same as normal, so here's the edit_child_articles partial:<br />
[crayon title = "app/views/articles/_edit_child_articles.html.erb"]</p>
<div id="edit-article-children">
<h2>You might also like...</h2>
<ul id="child-links" >
    <%= render @article.child_links if @child_links %></p>
<li id="droppable-li">
      <%= image_tag "placeholder.png", class: "this_is_droppable", id: @article.id, size: "80x80" %>
    </li>
</ul>
</div>
<p>[/crayon]</p>
<p>And the articles partial:<br />
[crayon title = "app/views/articles/_article.html.erb"]</p>
<div id="all-articles">
<%= link_to (image_tag article.image), article unless in_edit %><br />
<%= image_tag article.image, class: "this_is_draggable", id: article.id if in_edit %><br />
[/crayon]</p>
<p>Now the clever bit is in the javascript.  First of all as jquery draggable and droppable are in jquery ui, you must include that in the application:</p>
<p>[js title="app/assets/javascripts/application.js"]<br />
//= require jquery<br />
//= require jquery_ujs<br />
//= require jquery-ui<br />
//= require_tree .<br />
[/js]</p>
<p>Then in articles.js, I make the the article images in the list of all articles draggable, the empty box droppable and add a function to run when something draggable is dropped into the droppable box.</p>
<p>[js title="app/assets/javascripts/articles.js"]<br />
$(function() {</p>
<p>  $( make_draggable_and_droppable() );</p>
<p>  function make_draggable_and_droppable() {<br />
    $('.this_is_draggable').draggable({<br />
      helper: 'clone',<br />
      snap: '.this_is_droppable',<br />
      cursor: 'move'<br />
    });</p>
<p>    $('.this_is_droppable').droppable( {<br />
      drop: drop_article<br />
    });<br />
  }</p>
<p>  function drop_article(event,ui) {<br />
    $.ajax({<br />
      type: 'POST',<br />
      url:    '/links/',<br />
      data: {link : {<br />
        parent_id : this.id,<br />
        child_id : ui.draggable.attr('id')<br />
      }<br />
    },<br />
    dataType: 'script',<br />
    remote: 'true',<br />
    success: function(){<br />
    }<br />
  });<br />
  }<br />
//closing document ready tag<br />
});<br />
[/js]</p>
<p>What does this do?</p>
<p>At the start; the make_draggable_and_droppable function makes the article images draggable and the empty placeholder image droppable and adds the drop_article function as the function to run when an article is dropped into the droppable space.  The drop_article function creates a new link by doing a jquery ajax call to the links controller.</p>
<p>Now...  When the drop_article function is run, the create.js.erb links view is called</p>
<p>[js title="app/assets/views/links/create.js.erb"]<br />
$('#link_<%= @link.id %>').hide();<br />
$("#droppable-li").before("<%= escape_javascript(render(@link)) %>")<br />
$("#droppable-li").show("slide", { direction: "left" }, 1000);<br />
$('#link_<%= @link.id %>').show("drop", { direction: "left" }, 1000);<br />
[/js]</p>
<p>The new link is hidden first, then slides into view.</p>
<p>If the delete link is clicked, the destroy.js.erb link view is called which hides the appropriate image.</p>
<p>The app is on github <a href="https://github.com/aldreth/drag-and-drop">here</a> and there's a demo app on heroku <a href="http://rails-drag-drop.herokuapp.com/">here</a>.  For some reason it doesn't always seem to work in google chrome, but does in any other browser.</p>
