require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validations' do
    it 'It must be created with a password and password_confirmation fields' do


      @user1 = User.new({
        :first_name => 'Ali',
        :last_name => 'Salim',
        :email => 'user1@gmail.com',
        :password => '12345',
        :password_confirmation => '54321'
      })

      @user1.validate
      expect(@user1.errors.full_messages).to include("Password confirmation doesn't match Password")
      expect(@user1.save).to be_falsey
      expect(@user1.id).to_not be_present

      @user2 = User.new({
        :first_name => 'Ali',
        :last_name => 'Salim',
        :email => 'user2@gmail.com',
        :password => '12345',
        :password_confirmation => ''
      })

      @user2.validate
      expect(@user2.errors.full_messages).to include("Password confirmation doesn't match Password")
      expect(@user2.save).to be_falsey
      expect(@user2.id).to_not be_present

      @user3 = User.new({
        :first_name => 'Ali',
        :last_name => 'Salim',
        :email => 'user3@gmail.com',
        :password => '12345',
        :password_confirmation => '12345'
      })
      
      @user3.validate
      expect(@user3.save).to be_truthy
      expect(@user3.id).to be_present


    end

    it 'Should not allow create user if the email already exists (case sensitive)' do

      @user4 = User.new({
        :first_name => 'Ali',
        :last_name => 'Salim',
        :email => 'unique@gmail.com',
        :password => '12345',
        :password_confirmation => '12345'
      })

      @user4.validate
      expect(@user4.save).to be_truthy
      expect(@user4.id).to be_present

      @user5 = User.new({
        :first_name => 'salim',
        :last_name => 'Ali',
        :email => 'unique@gmail.com',
        :password => '12345',
        :password_confirmation => '12345'
      })

      @user5.validate
      expect(@user5.errors.full_messages).to include("Email has already been taken")
      expect(@user5.save).to be_falsey
      expect(@user5.id).to_not be_present


    end

    it 'Should be required : first name, last name and email' do

      @user = User.new({:password => '12345', :password_confirmation => '12345'})
      
      @user.validate

      expect(@user.errors.full_messages).to include("First name can't be blank")
      expect(@user.errors.full_messages).to include("Last name can't be blank")
      expect(@user.errors.full_messages).to include("Email can't be blank")
    end

    

  end
end
