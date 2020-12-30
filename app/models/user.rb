class User < ApplicationRecord
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, uniqueness: true

  def name
    "#{self.first_name} #{self.last_name}"
  end

  def self.all_names
    User.all.map(&:name)
  end
end
