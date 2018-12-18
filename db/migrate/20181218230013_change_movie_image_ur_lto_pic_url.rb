class ChangeMovieImageUrLtoPicUrl < ActiveRecord::Migration[5.2]
  def change
    rename_column :movies, :image_url, :pic_url
  end
end
