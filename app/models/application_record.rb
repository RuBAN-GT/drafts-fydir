class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.random
    self.offset(rand(self.count)).first
  end

  def export_hash
    as_json
  end
end
