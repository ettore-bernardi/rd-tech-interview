class MarkCartAsAbandonedJob
  include Sidekiq::Job

  def perform(*args)
    cart_id = args[0]
    cart = Cart.find_by(id: cart_id)
    return unless cart

    cart.abandoned!
    schedule_cart_deletion_job(cart)
  end

  def schedule_cart_deletion_job(cart)
    job_id = DeleteAbandonedCartJob.perform_at(7.days.from_now, cart.id)
    cart.update_attribute(:deletion_job_id, job_id)
  end
end
