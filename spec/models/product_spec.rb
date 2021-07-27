require 'rails_helper'

RSpec.describe Product, type: :model do
  
  describe 'Validation' do


    it 'should save successfully with all 4 fields set' do
      
      @product = Product.new
      @category = Category.create

      @product.name = "For_test"
      @product.price_cents = 999
      @product.quantity = 25
      @product.category = @category

      @product.save!

      expect(@product.id).to be_present
    end

    it 'should not save if there is no name' do
      
      @product = Product.new
      @category = Category.create



      @product.price_cents = 999
      @product.quantity = 25
      @product.category = @category


      @product.validate


      expect(@product.errors.full_messages.first).to eq("Name can't be blank")
    end

    it 'should not save if there is no price' do
      
      @product = Product.new
      @category = Category.create

      @product.name = "For_test"
      @product.quantity = 25
      @product.category = @category

      @product.validate

      expect(@product.errors.full_messages.first).to eq("Price cents is not a number")
    end
    it 'should not save if there is no quantity' do
      
      @product = Product.new
      @category = Category.create

      @product.name = "For_test"
      @product.price_cents = 999
      @product.category = @category

      @product.validate

      expect(@product.errors.full_messages.first).to eq("Quantity can't be blank")
    end

    it 'should save successfully with all 4 fields set' do
      
      @product = Product.new
      @category = Category.create

      @product.name = "For_test"
      @product.price_cents = 999
      @product.quantity = 25

      @product.validate

      expect(@product.errors.full_messages.first).to eq("Category can't be blank")
    end
  end
end
