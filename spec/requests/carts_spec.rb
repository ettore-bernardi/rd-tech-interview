require 'rails_helper'

RSpec.describe '/carts', type: :request do
  describe 'POST /add_items' do
    let!(:cart) { create(:cart) }
    let(:product) { create(:product, name: 'Test Product', price: 10.0) }
    let!(:cart_item) { create(:cart_item, cart: cart, product: product, quantity: 1) }

    context 'when the product already is in the cart' do
      before do
        allow_any_instance_of(ApplicationController).to receive(:session).and_return({ cart_id: cart.id })
      end

      subject do
        post '/cart/add_item', params: { product_id: product.id, quantity: 1 }, as: :json
        post '/cart/add_item', params: { product_id: product.id, quantity: 1 }, as: :json
      end

      it 'updates the quantity of the existing item in the cart' do
        expect { subject }.to change { cart_item.reload.quantity }.by(2)
      end
    end
  end
end
