class Product < ApplicationRecord
    searchable do
        text :title, :description, :country, :tags
        date :created_at
        integer :price
    end
    validates :title, :description, :country, :tags, :price, presence: true
end
