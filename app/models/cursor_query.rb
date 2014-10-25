class CursorQuery < ActiveRecord::Base
  def expired?
    # TODO set expiration time as configuration
    destroy! if DateTime.now > updated_at + 3.hours
  end
end
