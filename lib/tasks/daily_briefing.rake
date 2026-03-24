namespace :daily_briefing do
  desc "Fetches daily agenda and publishes it to the site"
  task publish: :environment do
    briefing = DailyBriefingPublisher.call
    puts "Gundem yayini hazirlandi: #{briefing.title}"
  end
end
