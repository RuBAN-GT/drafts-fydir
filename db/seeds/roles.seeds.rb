['admin', 'partner', 'user'].each do |role|
  r = Role.new :slug => role
  r.save rescue nil
end

p 'Roles was created'
