class Product < ApplicationRecord
    searchable do
        text :title, :description, :country, :tags
        date :created_at
        integer :price
    end
end
