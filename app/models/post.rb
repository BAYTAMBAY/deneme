class Post < ApplicationRecord
  STATUSES = %w[draft published].freeze

  before_validation :normalize_slug
  before_validation :set_published_at, if: :published?

  validates :title, presence: true
  validates :body, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :status, inclusion: { in: STATUSES }

  scope :recent_first, -> { order(published_at: :desc, created_at: :desc) }
  scope :published, lambda {
    where(status: "published")
      .where("published_at IS NULL OR published_at <= ?", Time.current)
      .recent_first
  }

  def to_param
    slug
  end

  def published?
    status == "published"
  end

  def seo_title
    meta_title.presence || title
  end

  def seo_description
    meta_description.presence || excerpt.presence || body.to_s.truncate(160)
  end

  private

  def normalize_slug
    base_slug = slug.presence || title.to_s
    base_slug = base_slug.parameterize.presence || "post"

    candidate = base_slug
    suffix = 2

    while Post.where.not(id: id).exists?(slug: candidate)
      candidate = "#{base_slug}-#{suffix}"
      suffix += 1
    end

    self.slug = candidate
  end

  def set_published_at
    self.published_at ||= Time.current
  end
end
