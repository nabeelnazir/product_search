require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'Validation' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:country) }
    it { should validate_presence_of(:tags) }
    it { should validate_presence_of(:price) }
  end

  describe 'Products can be created' do
    it 'can create a regular product' do
      product = Product.create(
        title: "Passionfruit and Guava Bath Bomb, Bath Fizzy",
        description: "Made with almond oil.",
        country: "United States",
        tags: "bath, bomb, bath bomb",
        price: 4
      )
      expect(product.title).to eq("Passionfruit and Guava Bath Bomb, Bath Fizzy")
      expect(product.description).to eq("Made with almond oil.")
      expect(product.country).to eq("United States")
      expect(product.tags).to eq("bath, bomb, bath bomb",)
      expect(product.price).to eq(4)
    end
  end
end
