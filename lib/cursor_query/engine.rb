module CursorQuery
  class Engine < ::Rails::Engine
  #    require 'cursor_query/path/to/concerns/models/post'
  #
  #        initializer 'engine_name.include_concerns' do
  #                ActionDispatch::Reloader.to_prepare do
  #                          Blorgh::Post.send(:include, Concerns::Models::Post)
  #                                end
  #                    end

             # Autoload from lib directory
         #     config.autoload_paths << File.expand_path('../../', __FILE__)
    isolate_namespace CursorQuery
  end
end
