class CartsController < ApplicationController
  before_action :set_cart
  after_action :save_cart_to_session

  def create
    @cart_item = @cart.cart_items.find_or_initialize_by(product_id: cart_items_params[:product_id])
    @cart_item.quantity += cart_items_params[:quantity].to_i
    @cart_item.save
    @cart.update_total_price

    render json: @cart, serializer: CartSerializer, status: :created
  end

  def show
    if @cart
      render json: @cart, serializer: CartSerializer, status: :ok
    else
      render json: { error: 'Cart not found' }, status: :not_found
    end
  end

  def add_item
    @cart_item = @cart.cart_items.find_or_initialize_by(product_id: cart_items_params[:product_id])
    @cart_item.quantity += cart_items_params[:quantity].to_i
    @cart_item.save
    @cart.update_total_price
    render json: @cart, serializer: CartSerializer, status: :ok
  end

  def destroy
    @cart_item = @cart.cart_items.find_by(product_id: cart_items_params[:product_id])
    if @cart_item
      @cart_item.destroy
      @cart.update_total_price
      render json: @cart, serializer: CartSerializer, status: :ok
    else
      render json: { error: "Product with id #{cart_items_params[:product_id]} not found in cart" }, status: :not_found
    end
  end

  private

  def cart_items_params
    params.permit(:product_id, :quantity)
  end

  def set_cart
    @cart = Cart.find_by_id(session[:cart_id])
    return if @cart

    @cart = Cart.create
    session[:cart_id] = @cart.id
  end

  def save_cart_to_session
    session[:cart_id] = @cart.id
  end
end
