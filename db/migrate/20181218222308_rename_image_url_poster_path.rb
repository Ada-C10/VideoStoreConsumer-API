class RenameImageUrlPosterPath < ActiveRecord::Migration[5.2]
  def change
    rename_column :movies, :image_url, :poster_path
  end
end
