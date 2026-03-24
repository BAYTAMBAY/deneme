class CreateDailyBriefings < ActiveRecord::Migration[7.1]
  def change
    create_table :daily_briefings do |t|
      t.string :title, null: false
      t.text :summary, null: false
      t.text :body, null: false
      t.string :slug, null: false
      t.string :source_name, null: false, default: "Google News RSS"
      t.string :source_url, null: false
      t.date :published_on, null: false

      t.timestamps
    end

    add_index :daily_briefings, :slug, unique: true
    add_index :daily_briefings, :published_on, unique: true
  end
end
