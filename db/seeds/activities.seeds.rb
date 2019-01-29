need = YAML.load_file "#{Rails.root}/config/data/activities.yml"

need.each do |activity|
  LookingActivity.new(:slug => activity).save if LookingActivity.find_by_slug(activity).nil?
end

p 'Activities was generated'
