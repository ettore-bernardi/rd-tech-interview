class DeleteAbandonedCartJob
  include Sidekiq::Job

  def perform(*args)
    cart_id = args[0]
    cart = Cart.find_by(id: cart_id)
    return unless cart

    cart.destroy
  end
end
