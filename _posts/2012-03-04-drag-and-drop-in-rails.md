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
---

<p>As I said in my earlier <a href="http://epa.me.uk/rails-self-referential-has_many-through/">post</a>, the product I'm developing has lots of self referential links between articles.  Now that I'm comfortable modeling them with has_many through relationships, I need to start thinking about how to build these links.  I need to have a nice graphical back end, in which I can drag thumbnail images representing articles and drop onto another article to make a link.</p>
<p>Enter <a href="http://jqueryui.com/demos/draggable/">jquery draggable</a>!  There are some great tutorials on the web on jquery, particularly this <a href="http://www.elated.com/articles/drag-and-drop-with-jquery-your-essential-guide/">one</a>, but no really good ones on using jquery draggable with rails.  It took me quite a long time to get this sorted out, especially as I was learning so many new things at once.</p>
<p>Continuing from the earlier article, I've added images to my articles - here's my current schema:</p>

##### db/schema.rb

```rb
ActiveRecord::Schema.define(:version => 20120304112520) do
  create_table "articles", :force => true do |t|
    t.string   "name"
    t.string   "body"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
  create_table "links", :force => true do |t|
    t.integer  "parent_id"
    t.integer  "child_id"
    t.integer  "weight"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
end
```

On the show page, I've added graphical links to each of the article's children:

[![Drag and drop - show article page](/assets/drag-n-drop/dd_show-258x300.png)](/assets/drag-n-drop/dd_show.png)

The edit page is very similar, with a blank placeholder image to drag new links into and a list of all the articles that can be linked to:

[![Drag and drop - edit article page](/assets/drag-n-drop/dd_edit-258x300.png)](/assets/drag-n-drop/dd_edit.png)

Here's the code for the edit page:

##### app/views/articles/edit.html.erb

```erb
<h1>Editing article</h1>

<%= render 'form' %>
<%= render 'edit_child_articles' %>
<div id="all-articles">
  <%= render partial: @articles, locals: {in_edit: true} %>
</div>

<%= link_to 'Show', @article %> |
<%= link_to 'Back', articles_path %>
```

The form is the same as normal, so here's the edit_child_articles partial:

##### app/views/articles/\_edit_child_articles.html.erb

```erb
<div id="edit-article-children">
  <h2>You might also like...</h2>
  <ul id="child-links" >
    <%= render @article.child_links if @child_links %>
    <li id="droppable-li">
      <%= image_tag "placeholder.png", class: "this_is_droppable", id: @article.id, size: "80x80" %>
    </li>
  </ul>
</div>
```

And the articles partial:

##### app/views/articles/\_article.html.erb

```erb
<div id="all-articles">
  <%= link_to (image_tag article.image), article unless in_edit %>
  <%= image_tag article.image, class: "this_is_draggable", id: article.id if in_edit %>
</div>
```

<p>Now the clever bit is in the javascript.  First of all as jquery draggable and droppable are in jquery ui, you must include that in the application:</p>
##### app/assets/javascripts/application.js
```js
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require_tree .
```

<p>Then in articles.js, I make the the article images in the list of all articles draggable, the empty box droppable and add a function to run when something draggable is dropped into the droppable box.</p>

##### app/assets/javascripts/articles.js

```js
$(function() {
  $(make_draggable_and_droppable());

  function make_draggable_and_droppable() {
    $(".this_is_draggable").draggable({
      helper: "clone",
      snap: ".this_is_droppable",
      cursor: "move"
    });

    $(".this_is_droppable").droppable({
      drop: drop_article
    });
  }

  function drop_article(event, ui) {
    $.ajax({
      type: "POST",
      url: "/links/",
      data: {
        link: {
          parent_id: this.id,
          child_id: ui.draggable.attr("id")
        }
      },
      dataType: "script",
      remote: "true",
      success: function() {}
    });
  }
});
```

<p>What does this do?</p>
<p>At the start; the make_draggable_and_droppable function makes the article images draggable and the empty placeholder image droppable and adds the drop_article function as the function to run when an article is dropped into the droppable space.  The drop_article function creates a new link by doing a jquery ajax call to the links controller.</p>
<p>Now...  When the drop_article function is run, the create.js.erb links view is called</p>

##### app/assets/views/links/create.js.erb

```js
$("#link_<%= @link.id %>").hide();
$("#droppable-li").before("<%= escape_javascript(render(@link)) %>");
$("#droppable-li").show("slide", { direction: "left" }, 1000);
$("#link_<%= @link.id %>").show("drop", { direction: "left" }, 1000);
```

<p>The new link is hidden first, then slides into view.</p>
<p>If the delete link is clicked, the destroy.js.erb link view is called which hides the appropriate image.</p>
<p>The app is on github <a href="https://github.com/aldreth/drag-and-drop">here</a> and there's a demo app on heroku <a href="http://rails-drag-drop.herokuapp.com/">here</a>.  For some reason it doesn't always seem to work in google chrome, but does in any other browser.</p>
