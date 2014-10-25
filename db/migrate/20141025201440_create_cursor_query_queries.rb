class CreateCursorQueryQueries < ActiveRecord::Migration
  def change
    create_table :cursor_query_queries do |t|
      t.string :etag
      t.integer :top_id
      t.integer :bottom_id
      t.text :missing_list

      t.timestamps
    end
  end
end
