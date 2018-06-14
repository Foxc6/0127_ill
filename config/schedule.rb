set :environment, 'development'

set :output, {:error => "log/cron_error_log.log", :standard => "log/cron_log.log"}


# Learn more: http://github.com/javan/whenever

set :output, "/log/cron_log.log"

every 30.days do
  puts '------------ Running Sales Case Update ----------------------'
  #rake 'sale_cases:update_status'
  command 'cd /Users/admin/Documents/Projects/0127_ill && RAILS_ENV=development bundle exec rake sale_cases:update_status'
end

every 1.days do
  puts '------------ Running Invoice Email ----------------------'
  command 'cd /Users/admin/Documents/Projects/0127_ill && RAILS_ENV=development bundle exec rake invoice:invoice_email'
end

