require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
    
    #Products will be created from a json file of 30 records. This approach is generic and can run the test suite on any machine.
    file = File.open "SpocketProducts.json"
    data = JSON.load file
    data.each {|d| FactoryBot.create(
                :product, 
                title: d["title"],
                description: d["description"],
                tags: d["tags"],
                country: d["country"],
                price: d["price"]
        )
    }
    
    #This method will call the products controller index method with the search params.
    def search(options = {})
        get 'index', params: options.merge!({page: 1, per_page: 30})
    end

    def random_product
        Product.all.shuffle.first
    end 

    # binding.pry

    context "Products search and products listing" do
        
        before :each do
            request.env["HTTP_ACCEPT"] = 'application/json'
        end
        
        it "will load the products correctly" do
            search
            expect(JSON.parse(response.body).length).to be > (1)
        end

        it "will do the full text with product title" do
            product = random_product
            search({search: product.title})
            expect(JSON.parse(response.body).map{|r| r["title"]}.include?(product.title)).to eq(true)
        end

        it "will do the full text with product description" do
            product = random_product
            search({search: product.description})
            expect(JSON.parse(response.body).map{|r| r["description"]}.include?(product.description)).to eq(true)
        end

        it "will search the products by country" do
            product = random_product
            search({country: product.country})
            expect(JSON.parse(response.body).map{|r| r["country"]}.uniq.first).to eq(product.country)
        end

        it "will search the products by price equals to the given price" do
            product = random_product
            search({price: product.price, price_type: "Equal To"})
            expect(JSON.parse(response.body).map{|r| r["price"]}.uniq.first).to eq(product.price)
        end
        
        it "will search the products by price greater than to the given price" do
            product = random_product
            search({price: product.price, price_type: "Greater Than"})
            expect(JSON.parse(response.body).map{|r| r["price"]}.uniq.min).to be > product.price
        end

        it "will search the products by price less than to the given price" do
            product = random_product
            search({price: product.price, price_type: "Less Than"})
            expect(JSON.parse(response.body).map{|r| r["price"]}.uniq.max).to be < product.price
        end

    end

    context "Products sorting" do
        
        before :each do
            request.env["HTTP_ACCEPT"] = 'application/json'
        end

        it "will sort the products by relevance" do
            product = random_product
            search({sort_order: "Relevance", search: product.title})
            expect(JSON.parse(response.body).map{|r| r["title"]}.include?(product.title)).to eq(true)
        end

        it "will sort the products by highest price" do
            search({sort_order: "Highest Price"})
            prices = JSON.parse(response.body).map{|r| r["price"]}
            my_price = prices.shift
            flag = prices.all? { |price| price <= my_price }
            expect(flag).to eq(true)
        end

        it "will sort the products by lowest price" do
            search({sort_order: "Lowest Price"})
            prices = JSON.parse(response.body).map{|r| r["price"]}
            my_price = prices.shift
            flag = prices.all? { |price| price >= my_price }
            expect(flag).to eq(true)
        end
    
        it "will sort the newest products" do
            search({sort_order: "Newest"})
            dates = JSON.parse(response.body).map{|r| r["created_at"].to_date}
            my_date = dates.shift
            flag = dates.all? { |created_at| created_at <= my_date }
            expect(flag).to eq(true)
        end

    end
end
