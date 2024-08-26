# Creates an output log to view previously run cron jobs
set :output, { error: 'log/cron_error_log.log', standard: 'log/cron_log.log' }

# Sets the environment to run during development mode (Set to production by default)
set :environment, 'development'

every 1.day, at: '12:00 am' do
  rake 'daily_summary:send_emails'
end
