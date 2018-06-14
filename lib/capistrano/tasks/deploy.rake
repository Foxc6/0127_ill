namespace :deploy do
  desc 'Run test suite before deployment'
  task :rspec do
    run_locally do
      execute :rake, 'spec'
    end
  end
end
