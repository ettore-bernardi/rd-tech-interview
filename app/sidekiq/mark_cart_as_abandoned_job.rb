class MarkCartAsAbandonedJob
  include Sidekiq::Job

  def perform(*args)
    cart_id = args[0]
    action = args[1]

    cart = Cart.find_by(id: cart_id)
    return unless cart

    handle_cart_action(cart, action)
  end

  def handle_cart_action(cart, action)
    case action.to_sym
    when :abandon
      cart.abandoned!
    when :delete
      cart.destroy
    else
      Rails.logger.error("Unknown action: #{action}")
    end
  rescue StandardError => e
    Rails.logger.error("Error processing cart action: #{e.message}")
  end
end
