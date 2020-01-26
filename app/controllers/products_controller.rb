class ProductsController < ApplicationController
  def index
    begin
      search = Sunspot.search(Product) do
        fulltext search_params[:search] do
          fields(:description, :country, :tags, :title)
          fields(:description, :country, :tags, :title => 2.0) if sort_order("Relevance")
        end
        with :country, search_params[:country] if country?
        with :price, search_params[:price] if price_and_price_type("Equal To")
        with(:price).less_than(search_params[:price].to_i) if price_and_price_type("Less Than")
        with(:price).greater_than(search_params[:price].to_i) if price_and_price_type("Greater Than")
        order_by :created_at, :desc if sort_order("Newest")
        order_by :price, :asc if sort_order("Lowest Price")
        order_by :price, :desc if sort_order("Highest Price")
        paginate(:page => search_params[:page], :per_page => search_params[:per_page] || 5)
      end
      @products = search.results
      respond_to do |format|
        format.html
        format.json { render json: @products }
      end
    rescue => exception
      flash[:error] = "Something went wrong! #{exception}"
    end
  end

  def show
    @product = Product.find_by_id(search_params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def search_params
    params.permit(:id, :search, :country, :price, :sort_order, :price_type, :per_page, :page)
  end

  def country?
    search_params[:country].present?
  end

  def price?
    search_params[:price].present?
  end

  def sort_order(value)
    search_params[:sort_order].eql?(value)
  end

  def price_type(value)
    search_params[:price_type].eql?(value)
  end

  def price_and_price_type(value)
    price? && price_type(value)
  end

end
