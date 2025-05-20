require 'rails_helper'

describe CartsController, type: :controller do
  let(:cart) { create(:cart) }

  before do
    allow_any_instance_of(ApplicationController).to receive(:session).and_return({ cart_id: cart.id })
  end

  describe 'POST #create' do
    let(:product) { create(:product) }

    it 'creates a new cart item' do
      expect do
        post :create, params: { product_id: product.id, quantity: 1 }
      end.to change(CartItem, :count).by(1)
    end
  end

  describe 'GET #show' do
    it 'returns the current cart' do
      get :show
      expect(response).to be_successful
      expect(response.body).to include(cart.id.to_s)
    end
  end

  describe 'POST #add_item' do
    let(:product) { create(:product) }

    it 'adds an item to the cart' do
      expect do
        post :add_item, params: { product_id: product.id, quantity: 1 }
      end.to change(cart.cart_items, :count).by(1)
    end

    it 'updates the quantity of an existing item' do
      cart_item = create(:cart_item, cart: cart, product: product, quantity: 1)
      post :add_item, params: { product_id: product.id, quantity: 2 }
      expect(cart_item.reload.quantity).to eq(3)
    end
  end

  describe 'DELETE #destroy' do
    let(:product) { create(:product) }
    let!(:cart_item) { create(:cart_item, cart: cart, product: product, quantity: 1) }

    it 'removes an item from the cart' do
      expect do
        delete :destroy, params: { product_id: product.id }
      end.to change(cart.cart_items, :count).by(-1)
    end

    it 'returns a not found error if the item does not exist' do
      delete :destroy, params: { product_id: 9999 }
      expect(response).to have_http_status(:not_found)
      expect(response.body).to include('Product with id 9999 not found in cart')
    end
  end
end
