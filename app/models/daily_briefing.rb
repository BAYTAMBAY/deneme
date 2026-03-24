class DailyBriefing < ApplicationRecord
  before_validation :normalize_slug

  validates :title, :summary, :body, :slug, :source_name, :source_url, :published_on, presence: true
  validates :slug, uniqueness: true
  validates :published_on, uniqueness: true

  scope :recent_first, -> { order(published_on: :desc, created_at: :desc) }

  def to_param
    slug
  end

  private

  def normalize_slug
    base = slug.presence || title.to_s
    self.slug = base.parameterize.presence || "gunluk-gundem"
  end
end
