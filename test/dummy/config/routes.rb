Rails.application.routes.draw do

  mount CursorQuery::Engine => "/cursor_query"
end
