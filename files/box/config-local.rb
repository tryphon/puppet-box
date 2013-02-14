<% if has_variable? "release_server" %>
Box::Release.download_server = "<%= release_server %>"
<% end %>
