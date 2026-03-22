class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.text :excerpt
      t.text :body, null: false
      t.string :cover_image_url
      t.string :status, null: false, default: "draft"
      t.datetime :published_at
      t.string :meta_title
      t.text :meta_description

      t.timestamps
    end

    add_index :posts, :slug, unique: true
    add_index :posts, :status
    add_index :posts, :published_at
  end
end
