class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  validates_numericality_of :total_price, greater_than_or_equal_to: 0

  enum status: { active: 0, completed: 1, abandoned: 2 }

  def update_total_price
    self.total_price = cart_items.inject(0) { |sum, item| sum + (item.product.price * item.quantity) }
    save
  end
end
