after :activities, :users do
  10.times do |i|
    l = LookingRequest.new

    u = User.random

    l.description = Faker::Lorem.paragraph
    l.looking_type = ['group', 'member'].sample
    l.min_light = rand(0..400)
    l.microphone = [true, false].sample
    l.looking_activity = [nil, LookingActivity.random].sample
    l.user = u
    l.platform = u.platform
    l.experience = ['every', 'sherpa', 'novice'].sample

    l.save
  end

  'Requests was generated'
end
