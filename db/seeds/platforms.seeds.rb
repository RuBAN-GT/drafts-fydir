need = YAML.load_file "#{Rails.root}/config/data/platforms.yml"

need.each do |platform|
  next unless Platform.find_by_slug(platform['slug']).nil?

  pl = Platform.new platform

  pl.save
end

p 'Platforms was created'
