class Movie < ApplicationRecord
  has_many :rentals
  has_many :customers, through: :rentals

  validates :external_id, presence:true, uniqueness: true

  def available_inventory
    self.inventory - Rental.where(movie: self, returned: false).length
  end

  def image_url
    orig_value = read_attribute :image_url
    puts orig_value
    if !orig_value
      MovieWrapper::DEFAULT_IMG_URL
    elsif external_id ##&& id < 100
      MovieWrapper.construct_image_url(orig_value)
    # elsif external_id && id > 100
    #   MovieWrapper.construct_image_url_new(orig_value)
    else
      orig_value
    end
  end
end
