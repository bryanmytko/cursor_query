module Cursor
  require 'securerandom'
  extend ActiveSupport::Concern

  module ClassMethods
    def cursor(params)
      @params = params || {}
      response
    end

    private

    def response
      if cursor_query && !cursor_query.expired?
        update_response
      else
        create_response || {}
      end
    end

    def etag
      @params[:etag]
    end

    def page_size
      @params[:page_size] || 10
    end

    def latest?
      @params[:latest]
    end

    def previous?
      @params[:previous]
    end

    def cursor_query
      @cursor_query ||= CursorQuery.find_by(etag: etag)
    end

    def create_response
      @response = {
        etag:   generate_etag,
        latest: order('created_at desc').limit(page_size.to_i)
      }
      @response if !@response[:latest].blank? && create_cursor_query
    end

    def create_cursor_query
      CursorQuery.create(
        etag:           @response[:etag],
        top_id:         @response[:latest].first.id,
        bottom_id:      @response[:latest].last.id,
        missing_list:   initial_missing_list.to_json
      )
    end

    def initial_missing_list
      initial_list = @response[:latest].map { |r| r.id }.reverse
    end

    def update_response
      @response = {
        latest:   populate_latest,
        previous: populate_previous,
        edited:   populate_edits,
        deleted:  populate_deleted
      }
      update_cursor_query
      @response
    end

    def populate_latest
      more_posts('>', upper_lim, 'id asc').reverse if latest?
    end

    def populate_previous
      more_posts('<', lower_lim, 'id desc') if previous?
    end

    def populate_edits
      where(id: cursor_query.bottom_id..cursor_query.top_id)
        .where('updated_at > ?', cursor_query.updated_at)
    end

    def populate_deleted
      updated_list = where(id: JSON.parse(cursor_query.missing_list))
        .map { |r| r.id }

      JSON.parse(cursor_query.missing_list) - updated_list
    end

    def update_cursor_query
      cursor_query.update_attributes({
        top_id:       update_top_id,
        bottom_id:    update_bottom_id,
        missing_list: update_missing_list.to_json
      })
    end

    def update_top_id
      if !@response[:latest].blank?
        @response[:latest].last.id
      else
        cursor_query.top_id
      end
    end

    def update_bottom_id
      if !@response[:previous].blank?
        @response[:previous].last.id
      else
        cursor_query.bottom_id
      end
    end

    def update_missing_list
      list = (JSON.parse(cursor_query.missing_list) - @response[:deleted])
      list += @response[:previous].map { |r| r.id }
      list += @response[:latest].map { |r| r.id }
    end

    def more_posts(comparison, limit, order = nil)
      where("id #{comparison} ?", limit).order(order).limit(page_size.to_i)
    end

    def upper_lim
      cursor_query.top_id
    end

    def lower_lim
      cursor_query.bottom_id
    end

    def generate_etag
      begin
        etag = SecureRandom.hex
      end while CursorQuery.find_by(etag: etag)
      etag
    end
  end
end
