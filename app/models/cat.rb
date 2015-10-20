class Cat < ActiveRecord::Base

  validates :birth_date, :color, :name, :sex, :description, presence: true
  validates_inclusion_of :sex, in: ["M", "F"]

  def age
    (Date.today - birth_date).to_i / 365
  end

  def self.colors
    ["blue", "orange", "black", "brown", "white"]
  end
end
