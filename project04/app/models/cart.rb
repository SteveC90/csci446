class Cart < ActiveRecord::Base
  has_many :line_tems, dependent: :destroy
end
