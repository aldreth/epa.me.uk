---
layout: post
status: publish
published: true
title: Scaffolding Twitter Bootstrap
author: Edward Andrews
date: "2013-01-28 17:31:38 +0000"
date_gmt: "2013-01-28 17:31:38 +0000"
categories:
  - ruby on rails
tags:
  - rails
  - ruby on rails
  - configuration
  - generators
comments: []
---

<p>Like so many other people at the moment, I'm using <a href="http://twitter.github.com/bootstrap/">Twitter bootstrap</a> as the basis for sites at the moment. I was playing around with the rails scaffold generators and wondered how easy it would be to customise them to generate bootstrap compatible views.</p>
<p>Turns out of course, it's really easy!</p>
<p>The template files for the generators are in <a href="https://github.com/rails/rails/tree/master/railties">railties</a>, so if you <code>bundle open railties</code> you can see what the defaults are. At the moment (railties v3.2.10) the files are at lib/generators/erb/scaffold/templates.  I use haml for view templates, which means <a href="https://github.com/indirect/haml-rails">haml-rails</a> has put haml templates at lib/generators/haml/scaffold/templates.</p>
<p>To make the scaffolded files into exactly what you want, just create your own versions in corresponding locations in your application.</p>
<p>My application layout places the yield inside a span12, so I can either start with another row, with spans inside the row, or directly with content.  I've ended up with templates that look like this:</p>

##### lib/templates/haml/scaffold/new.html.haml:

```haml
%h1.page-header New <%= singular_table_name %>

=render 'form'

```

##### lib/templates/haml/scaffold/edit.html.haml:

```haml
%h1.page-header Editing <%= singular_table_name %>

=render 'form'
```

##### lib/templates/haml/scaffold/\_form.html.haml:

```haml
=simple_form_for(@<%= singular_table_name %>, validate: true, html: { class: 'form-horizontal' } ) do |f|
  =f.error_notification

  .form-inputs
  <%- attributes.each do |attribute| -%>
    =f.<%= attribute.reference? ? :association : :input %> :<%= attribute.name %>
  <%- end -%>

  .form-actions
    =f.button :submit
```

##### lib/templates/haml/scaffold/index.html.haml:

```haml
%h1.page-header All <%= plural_table_name %>

%table.table.table-bordered.table-striped
  %tbody
    -@<%= plural_table_name %>.each do |<%= singular_table_name %>|
      %tr
        %td=link_to <%= singular_table_name %>, <%= singular_table_name %>
        %td=link_to 'Edit', edit_<%= singular_table_name %>_path(<%= singular_table_name %>), class: 'btn btn-primary btn-mini'
        %td=link_to 'Destroy', <%= singular_table_name %>, <%= key_value :method, ":delete" %>, <%= key_value :data, "{ #{key_value :confirm, "'Are you sure?'"} }" %>, class: 'btn btn-danger btn-mini'

=will_paginate @<%= plural_table_name %>, renderer: BootstrapPagination::Rails

.details
  =link_to 'New <%= human_name %>', new_<%= singular_table_name %>_path, class: 'btn btn-primary'</pre>
<pre class="lang:default decode:true" title="lib/templates/haml/scaffold/show.html.haml">%h1.page-header=@<%= singular_table_name %>

%table.table.table-bordered.table-striped
  %tbody
<% attributes.each do |attribute| -%>
    %tr
      %td.strong <%= attribute.human_name %>:
      %td=@<%= singular_table_name %>.<%= attribute.name %>
<% end -%>

.details
  =link_to 'Edit', edit_<%= singular_table_name %>_path(@<%= singular_table_name %>), class: 'btn btn-primary'
  =link_to 'Delete', @<%= singular_table_name %>, confirm: 'Are you sure?', method: :delete, class: 'btn btn-danger'
  =link_to 'New <%= human_name %>', new_<%= singular_table_name %>_path, class: 'btn btn-primary'
```

<p>As you might have guessed from the form I use <a href="https://github.com/plataformatec/simple_form">simple_form</a> - this provides generators for its forms anyway, but I've added the <code>validates: true</code> bit - this is for the <a href="https://github.com/bcardarella/client_side_validations">client_side_validations</a> gem. And the pagination block in index.html.haml will have indicated to you that I'm over-riding the controller generator - this has to go in lib/templates/rails/scaffold_controller/controller.rb - I'm adding the pagination for the index action, and load_and_authorise_resource for <a href="https://github.com/ryanb/cancan">cancan</a> in my version.</p>
<p>It's possible to pass lots more options to the scaffold generator in application.rb - you can find out about them in the rails guide <a href="http://guides.rubyonrails.org/configuring.html#configuring-generators">Configuring Rails Applications</a>.</p>
<p>And what you end up with is a lovely scaffold generator that produces appropriate files for your application.  Makes scaffolding really useful again!</p>

```ruby
def foo
  puts 'foo'
end
```
