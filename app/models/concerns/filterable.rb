module Filterable
  extend ActiveSupport::Concern

  module ClassMethods
    def filter(filtering_params)
      results = self.where nil

      filtering_params.each do |key, value|
        results = results.public_send(key, value) if self.respond_to?(key) && value.present? && value.to_s != '0'
      end

      results
    end
  end
end
