class Entry < ApplicationRecord
  belongs_to :blog
  has_many :comments, dependent: :destroy
  # accepts_nested_attributes_for :comments, allow_destroy: true
  validates :title, presence: true
end
