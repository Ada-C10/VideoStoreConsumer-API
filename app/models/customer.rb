class Customer < ApplicationRecord
  has_many :rentals
  has_many :movies, through: :rentals

  def movies_checked_out_count
    self.rentals.where(returned: false).length
  end

  def movies_checked_out
    self.movies
  end

  # def overdue_movies_checked_out
  #   self.rentals.where(returned: false)
  # end
end
