require "net/http"
require "rss"
require "cgi"

class DailyBriefingPublisher
  DEFAULT_RSS_URL = "https://news.google.com/rss?hl=tr&gl=TR&ceid=TR:tr".freeze

  def self.call(date: Date.current)
    new(date: date).call
  end

  def initialize(date:)
    @date = date
  end

  def call
    existing = DailyBriefing.find_by(published_on: @date)
    return existing if existing.present?

    items = fetch_items
    raise "Gundem kaynagindan veri alinamadi." if items.empty?

    DailyBriefing.create!(
      title: title,
      summary: build_summary(items),
      body: build_body(items),
      slug: "gundem-#{@date}",
      source_name: "Google News RSS",
      source_url: rss_url,
      published_on: @date
    )
  end

  private

  def fetch_items
    response = Net::HTTP.get_response(URI(rss_url))
    return [] unless response.is_a?(Net::HTTPSuccess)

    feed = RSS::Parser.parse(response.body, false)
    Array(feed&.items).first(5)
  rescue StandardError
    []
  end

  def title
    "Gunluk Gundem Ozeti - #{@date.strftime('%d %B %Y')}"
  end

  def build_summary(items)
    first_titles = items.first(3).map { |item| sanitize_text(item.title) }.join(", ")
    "Bugunun one cikan basliklari: #{first_titles}."
  end

  def build_body(items)
    lines = []
    lines << "Bugunun gundeminden secilen basliklar:"
    lines << ""

    items.each_with_index do |item, index|
      headline = sanitize_text(item.title)
      description = sanitize_text(item.description).presence || "Detay icin kaynak baglantisini inceleyebilirsin."
      lines << "#{index + 1}. #{headline}"
      lines << description.truncate(260)
      lines << "Kaynak: #{item.link}"
      lines << ""
    end

    lines.join("\n").strip
  end

  def sanitize_text(value)
    CGI.unescapeHTML(ActionController::Base.helpers.strip_tags(value.to_s)).squish
  end

  def rss_url
    ENV.fetch("DAILY_BRIEFING_RSS_URL", DEFAULT_RSS_URL)
  end
end
