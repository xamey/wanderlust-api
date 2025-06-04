class Search < ApplicationRecord
  belongs_to :user
  enum :status, { pending: 0, researching: 1, success: 2, failed: 3 }
  has_many :search_results, dependent: :destroy
end
