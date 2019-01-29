class ApiVersion
  def initialize(version)
    @version = version
  end

  def matches?(request)
    versioned_accept_header?(request) || version_one?(request)
  end

  protected

    def versioned_accept_header?(request)
      accept = request.headers['Accept']

      accept && accept[/application\/vnd\.fydir#{@version}\+json/]
    end

    def unversioned_accept_header?(request)
      accept = request.headers['Accept']
      accept.blank? || accept[/application\/vnd\.fydir/].nil?
    end

    def version_one?(request)
      @version == 1 && unversioned_accept_header?(request)
    end
end
