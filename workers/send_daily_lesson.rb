require 'sidekiq'
require 'sidekiq-scheduler'
require_relative '../app/controllers/application_controller'
require_relative '../lib/send_lesson'

# Configure Sidekiq
Sidekiq.configure_server do |config|
  config.on(:startup) do
    config.redis = {size: 27}
    Sidekiq.schedule = YAML.load_file(File.expand_path('../sidekiq_scheduler.yml', __FILE__))
    SidekiqScheduler::Scheduler.instance.reload_schedule!
  end
end

class SendDailyLesson
  include Sidekiq::Worker
  uri = URI.parse(ENV["REDISCLOUD_URL"] || "redis://localhost:6379/")
  $redis = Redis.new(host: uri.host, port: uri.port, password: uri.password)
  def perform
    SendLesson.send_daily_lessons
  end
end
