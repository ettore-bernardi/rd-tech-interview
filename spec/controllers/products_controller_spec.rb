require 'rails_helper'

RSpec.describe ProductsController, type: :controller do # rubocop:disable Metrics/BlockLength
  let!(:product) { create(:product) }

  describe 'GET #index' do
    it 'returns a list of products' do
      get :index
      expect(response).to be_successful
      expect(response.body).to include(product.name)
    end
  end

  describe 'GET #show' do
    it 'returns the requested product' do
      get :show, params: { id: product.id }
      expect(response).to be_successful
      expect(response.body).to include(product.name)
    end
  end

  describe 'POST #create' do
    it 'creates a new product' do
      expect do
        post :create, params: { product: { name: 'New Product', price: 9.99 } }
      end.to change(Product, :count).by(1)
    end
  end

  describe 'PUT #update' do
    it 'updates the requested product' do
      put :update, params: { id: product.id, product: { name: 'Updated Product' } }
      expect(product.reload.name).to eq('Updated Product')
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the requested product' do
      product
      expect do
        delete :destroy, params: { id: product.id }
      end.to change(Product, :count).by(-1)
    end
  end
end
