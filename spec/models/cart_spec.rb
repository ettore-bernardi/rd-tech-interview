require 'rails_helper'

RSpec.describe Cart, type: :model do
  context 'when validating' do
    it 'validates numericality of total_price' do
      cart = described_class.new(total_price: -1)
      expect(cart.valid?).to be_falsey
      expect(cart.errors[:total_price]).to include('must be greater than or equal to 0')
    end
  end

  describe 'schedule_cart_abandonment_job' do
    context 'when cart is active and an interaction is made' do
      let(:cart) { create(:cart) }

      it 'schedules the cart for abandonment' do
        expect do
          cart.update(total_price: 100)
        end.to change { Sidekiq::ScheduledSet.new.size }.by(1)
      end
    end
  end
end
