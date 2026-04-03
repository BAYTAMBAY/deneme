class DailyBriefingsController < ApplicationController
  def index
    ensure_latest_briefing
    @latest_briefing = DailyBriefing.recent_first.first
    @recent_briefings = DailyBriefing.recent_first.limit(7)
  end

  def refresh
    DailyBriefingPublisher.call(date: Date.current)
    redirect_to gundem_path, notice: "Bugunun gundemi guncellendi."
  rescue StandardError => error
    Rails.logger.warn("Daily briefing manual refresh failed: #{error.class} - #{error.message}")
    redirect_to gundem_path, alert: "Gundem su an yenilenemedi. Biraz sonra tekrar dene."
  end

  def show
    @briefing = DailyBriefing.find_by!(slug: params[:id])
    @recent_briefings = DailyBriefing.recent_first.where.not(id: @briefing.id).limit(7)
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
