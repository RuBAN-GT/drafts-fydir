after :users do
  c = Conversation.new
  c.join User.find(1), User.find(2)
  c.save

  30.times do |i|
    m = Message.new(
      :user_id => [1,2].sample,
      :body => "Hello #{i}",
      :conversation => c
    )

    m.save
  end

  p 'Messages was generated'
end
