class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  validates_numericality_of :total_price, greater_than_or_equal_to: 0

  enum status: { active: 0, completed: 1, abandoned: 2 }

  after_update :schedule_cart_abandonment_job, if: :active?
  after_update :schedule_cart_deletion_job, if: :abandoned?

  def update_total_price
    self.total_price = cart_items.inject(0) { |sum, item| sum + (item.product.price * item.quantity) }
    save
  end

  private

  def schedule_cart_abandonment_job
    MarkCartAsAbandonedJob.perform_at(3.hours.from_now, id, 'abandon')
  end

  def schedule_cart_deletion_job
    MarkCartAsAbandonedJob.perform_at(7.days.from_now, id, 'delete')
  end
end
