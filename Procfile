web: bundle exec rackup config.ru -p $PORT
worker: bundle exec sidekiq -c 3 -e production -r ./workers/send_daily_lesson.rb
