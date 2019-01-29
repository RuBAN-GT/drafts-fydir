namespace :deploy do
  desc "Update permissions"
  task :fix_permissions do
    on roles(:web) do
      execute "chown -R rVisor:rVisor #{current_path}"
      execute "chmod -R 775 #{current_path}"
      execute "chmod -R 775 #{shared_path}"
    end
  end
end

before 'passenger:restart', 'deploy:fix_permissions'
