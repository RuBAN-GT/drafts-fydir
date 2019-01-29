module BungieHelper
  # Get bungie full path
  def bungie_uri(path = '')
    uri = '//bungie.net'

    path = path.to_s

    uri += "/#{path.to_s.sub(/^\//, '').sub(/\/$/, '')}" unless path.blank?

    uri
  end
end
