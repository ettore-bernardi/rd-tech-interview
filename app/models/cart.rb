class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  validates_numericality_of :total_price, greater_than_or_equal_to: 0

  enum status: { active: 0, completed: 1, abandoned: 2 }

  after_update :schedule_cart_abandonment_job
  after_update :activate_cart

  def update_total_price
    self.total_price = cart_items.inject(0) { |sum, item| sum + (item.product.price * item.quantity) }
    save!
  end

  private

  def schedule_cart_abandonment_job
    return if job_id_changed?
    return if abandoned?

    HandleCartAbandonmentService.new(id).call
  end

  def activate_cart
    return if active?
    return if saved_change_to_attribute?(:status)
    return if job_id_changed?

    active!
  end

  def job_id_changed?
    saved_change_to_attribute?(:deletion_job_id) || saved_change_to_attribute?(:abandonment_job_id)
  end
end
