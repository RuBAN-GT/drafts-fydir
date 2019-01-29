class ApiResponse
  def error_code
    @error_code || 0
  end
  def error_code=(v)
    @error_code = v if v.is_a? Integer
  end

  def error_status
    I18n.t "api_response.status.#{error_code}"
  end

  def messages
    @messages || {}
  end
  def messages=(messages)
    @messages = messages if messages.is_a? Hash
  end
  def message(k, v)
    @messages = {} if @messages.nil?

    @messages[k] = v
  end

  def response
    @response = yield if block_given?

    @response || []
  end
  def response=(content)
    @response = content
  end

  def builder(json)
    json.ErrorCode error_code
    json.ErrorStatus error_status

    if block_given?
      json.Response do
        yield
      end
    else
      json.Response response
    end

    json.Messages messages
  end

  def collection(json, collection)
    json.count collection.count
    json.current collection.current_page if collection.respond_to? :current_page
    json.total collection.total_pages if collection.respond_to? :total_pages
    json.data do
      json.array! collection,
        :partial => "/api/v1/#{collection.name.underscore.pluralize}/shared/#{collection.name.underscore}",
        :as => collection.name.underscore
    end
  end
end
