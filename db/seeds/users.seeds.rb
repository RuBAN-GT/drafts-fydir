after :admin do
  r = Role.find_by_slug 'user'

  5.times do |i|
    next unless User.find_by_email("test#{i}@test.test").nil?

    u = User.new(
      :realname => Faker::Name.first_name,
      :nickname => "#{Faker::Internet.user_name(nil,%w(_-))}-#{i}",
      :email => "test#{i}@test.test",
      :password => "Qwerty",
      :password_confirmation => "Qwerty",
      :motto => Faker::Lorem.sentence(3),
      :about => Faker::Lorem.paragraph(3),
      :roles => [r],
      :platform => Platform.random,
      :telegram => Faker::Internet.domain_word
    )

    Role.offset(rand(Role.count)).first

    u.skip_confirmation! if u.respond_to? :skip_confirmation!

    u.save!
  end

  p 'Users was creates'
end
