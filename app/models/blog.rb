class Blog < ApplicationRecord
  has_many :entries, dependent: :destroy
  # accepts_nested_attributes_for :entries, allow_destroy: true
  validates :title, presence: true
end
