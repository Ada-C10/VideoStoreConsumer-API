class Customer < ApplicationRecord
  has_many :rentals
  has_many :movies, through: :rentals

  def movies_checked_out_count
    self.rentals.where(returned: false).length
  end

  def movies_checked_out
    outstanding_rentals = self.rentals.where(returned: false)

    checked_out = outstanding_rentals.map do |rental|
      {
        title: rental.movie.title,
        checkout_date: rental.checkout_date,
        due_date: rental.due_date,
        overdue: (rental.due_date < Date.today ? true : false)
      }
    end

    return checked_out
  end
end
