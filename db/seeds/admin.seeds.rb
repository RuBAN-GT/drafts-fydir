after :platforms, :roles do
  return unless User.find_by_nickname('RuBAN-GT').nil?

  r = Role.find_by_slug 'admin'

  u = User.new(
    :realname => "Dmitry",
    :nickname => "RuBAN-GT",
    :email => "dkruban@gmail.com",
    :password => "Qwerty",
    :password_confirmation => "Qwerty",
    :motto => 'Гардиан-программист в домашних тапочках.',
    :about => 'Хантер-пвешник, варлок-пвпшник, программист-рубист-пэхэпэшник.',
    :vkontakte => 'https://vk.com/dkruban',
    :telegram => 'dkruban',
    :twitter => 'dkruban',
    :roles => [r],
    :platform => Platform.find_by_slug('ps4'),
    :guardian_name => 'RuBAN-GT'
  )

  u.skip_confirmation! if u.respond_to? :skip_confirmation!

  u.guardian_verify!

  u.save!

  p 'Admin was created'
end
