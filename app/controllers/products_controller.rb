class ProductsController < ApplicationController
  def index
    search = Sunspot.search(Product) do
      fulltext params[:search] do
        fields(:description, :country, :tags, :title)
        fields(:description, :country, :tags, :title => 2.0) if params[:sort_order]&.eql?("Relevance")
      end
      with :country, params[:country] if params[:country].present?
      with :price, params[:price] if params[:price].present? && params[:price_type]&.eql?("Equal To")
      with(:price).less_than(params[:price].to_i) if params[:price].present? && params[:price_type]&.eql?("Less Than")
      with(:price).greater_than(params[:price].to_i) if params[:price].present? && params[:price_type]&.eql?("Greater Than")
      order_by :created_at, :desc if params[:sort_order]&.eql?("Newest")
      order_by :price, :asc if params[:sort_order]&.eql?("Lowest Price")
      order_by :price, :desc if params[:sort_order]&.eql?("Highest Price")
      paginate(:page => params[:page], :per_page => params[:per_page] || 5)
    end
    @products = search.results
    respond_to do |format|
      format.html
      format.json { render json: @products }
    end
  end

  def show
    @product = Product.find_by_id(params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end

end
