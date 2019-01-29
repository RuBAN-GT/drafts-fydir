class ContactsValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if !options[:domain].nil? && value.present?
      if !options[:nickname].nil? && options[:nickname]
        result = value.match /\A([\da-z\-?.]{2,})\Z/i

        unless result.nil?
          record.send "#{attribute}=", "https://#{options[:domain]}/#{value}"

          return true
        end
      end

      result = value.match /\A(https?:\/\/)(www.)?(#{options[:domain].to_s})\/([\da-z\-?.]{2,})\Z/i

      record.errors.add attribute, I18n.t('activerecord.errors.models.user.attributes.contact.wrong') if result.nil?
    end
  end
end
