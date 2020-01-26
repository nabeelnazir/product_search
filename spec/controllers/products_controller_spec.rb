require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
    #Products will be created in the test database from seed file and loaded here in this test suite.

    #This method will call the products controller index method with the search params.
    def search(options = {})
        get 'index', params: options.merge!({page: 1, per_page: 30})
    end

    context "Products search and products listing" do
        
        before :each do
            request.env["HTTP_ACCEPT"] = 'application/json'
        end
        
        it "will bring the 30 products correctly" do
            search
            expect(JSON.parse(response.body).length).to be (30)
        end

        it "will do the full text with product title and description" do
            search({search: "bath"})
            expect(JSON.parse(response.body).map{|r| r["title"]}.join.include?("bath".capitalize)).to eq(true)
            expect(JSON.parse(response.body).map{|r| r["description"]}.join.include?("bath")).to eq(true)
        end

        it "will search the products by country United States" do
            search({country: 'United States'})
            expect(JSON.parse(response.body).map{|r| r["country"]}.uniq.first).to eq('United States')
        end

        it "will search the products by price equals to $3" do
            search({price: 3, price_type: "Equal To"})
            expect(JSON.parse(response.body).map{|r| r["price"]}.uniq.first).to eq(3)
        end
        
        it "will search the products by price greater than to $3" do
            search({price: 3, price_type: "Greater Than"})
            expect(JSON.parse(response.body).map{|r| r["price"]}.uniq.min).to be > 3
        end

        it "will search the products by price less than to $3" do
            search({price: 3, price_type: "Less Than"})
            expect(JSON.parse(response.body).map{|r| r["price"]}.uniq.max).to be < 3
        end

    end

    context "Products sorting" do
        
        before :each do
            request.env["HTTP_ACCEPT"] = 'application/json'
        end

        it "will sort the products by relevance" do
            search({sort_order: "Newest"})
            dates = JSON.parse(response.body).map{|r| r["created_at"].to_date}
            my_date = dates.shift
            flag = dates.all? { |created_at| created_at <= my_date }
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
