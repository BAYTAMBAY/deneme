class DailyBriefingsController < ApplicationController
  def index
    @latest_briefing = DailyBriefing.recent_first.first
    @recent_briefings = DailyBriefing.recent_first.limit(7)
  end
end
