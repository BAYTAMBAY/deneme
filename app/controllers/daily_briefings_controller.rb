class DailyBriefingsController < ApplicationController
  def index
    ensure_latest_briefing
    @latest_briefing = DailyBriefing.recent_first.first
    @recent_briefings = DailyBriefing.recent_first.limit(7)
  end

  private

  def ensure_latest_briefing
    latest_briefing = DailyBriefing.recent_first.first
    return if latest_briefing&.published_on == Date.current

    DailyBriefingPublisher.call(date: Date.current)
  rescue StandardError => error
    @briefing_error = "Bugunun gundemi su an cekilemedi. Son kayit gosteriliyor."
    Rails.logger.warn("Daily briefing refresh failed: #{error.class} - #{error.message}")
  end
end
