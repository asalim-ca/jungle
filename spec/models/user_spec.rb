require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validations' do
    it 'Should be required : first name, last name and email' do

      user = User.new({:password => '123456', :password_confirmation => '123456'})
      
      user.validate

      expect(user.errors.full_messages).to include("First name can't be blank")
      expect(user.errors.full_messages).to include("Last name can't be blank")
      expect(user.errors.full_messages).to include("Email can't be blank")
    end

    it 'It must be created with a password and password_confirmation fields' do


      user = User.new({
        :first_name => 'Ali',
        :last_name => 'Salim',
        :email => 'user@gmail.com',
        :password => '123456',
        :password_confirmation => '123457'
      })

      user.validate
      expect(user.errors.full_messages).to include("Password confirmation doesn't match Password")
      expect(user.save).to be_falsey
      expect(user.id).to_not be_present

      user = User.new({
        :first_name => 'Ali',
        :last_name => 'Salim',
        :email => 'user@gmail.com',
        :password => '123456',
        :password_confirmation => ''
      })

      user.validate
      expect(user.errors.full_messages).to include("Password confirmation doesn't match Password")
      expect(user.save).to be_falsey
      expect(user.id).to_not be_present

      user = User.new({
        :first_name => 'Ali',
        :last_name => 'Salim',
        :email => 'user@gmail.com',
        :password => '123456',
        :password_confirmation => '123456'
      })
      
      user.validate
      expect(user.save).to be_truthy
      expect(user.id).to be_present


    end

    it 'Should not allow create user if the email already exists (case sensitive)' do

      user = User.new({
        :first_name => 'Ali',
        :last_name => 'Salim',
        :email => 'unique@gmail.com',
        :password => '123456',
        :password_confirmation => '123456'
      })

      user.validate
      expect(user.save).to be_truthy
      expect(user.id).to be_present

      user = User.new({
        :first_name => 'salim',
        :last_name => 'Ali',
        :email => 'unique@gmail.com',
        :password => '123456',
        :password_confirmation => '123456'
      })

      user.validate
      expect(user.errors.full_messages).to include("Email has already been taken")
      expect(user.save).to be_falsey
      expect(user.id).to_not be_present


    end


    it "Should have a minimum length" do
      
      user = User.new({
        :first_name => 'salim',
        :last_name => 'Ali',
        :email => 'unique@gmail.com',
        :password => '12345',
        :password_confirmation => '12345'
      })

      user.validate
      expect(user.errors.full_messages).to include("Password is too short (minimum is 6 characters)")
      expect(user.save).to be_falsey
      expect(user.id).to_not be_present

    end
  end

  describe '.authenticate_with_credentials' do
    
    it 'should return: an instance of the user (if successfully authenticated)' do

      user = User.new({
        :first_name => 'alilog',
        :last_name => 'salimlog',
        :email => 'forlogin@gmail.com',
        :password => '123456',
        :password_confirmation => '123456'
      })

      user.validate
      expect(user.save).to be_truthy
      expect(user.id).to be_present

      logged_user = User.authenticate_with_credentials('forlogin@gmail.com', '123456')
      expect(logged_user).to be_truthy
      expect(logged_user.first_name).to eq('alilog')
      expect(logged_user.last_name).to eq('salimlog')

      f_logged_user_rp = User.authenticate_with_credentials('forlogin@gmail.com', '654321')
      expect(f_logged_user_rp).to be_falsey

      f_logged_user_re = User.authenticate_with_credentials('whatever@gmail.com', '123456')
      expect(f_logged_user_re).to be_falsey
    end

    it 'should let login  if email has spaces before or after' do

      user = User.new({
        :first_name => 'alilog',
        :last_name => 'salimlog',
        :email => 'forlogin@gmail.com',
        :password => '123456',
        :password_confirmation => '123456'
      })

      user.validate
      expect(user.save).to be_truthy
      expect(user.id).to be_present

      logged_user = User.authenticate_with_credentials('   forlogin@gmail.com   ', '123456')
      expect(logged_user).to be_truthy
      expect(logged_user.first_name).to eq('alilog')
      expect(logged_user.last_name).to eq('salimlog')

    end

    it 'should let login even with wrong case' do

      user = User.new({
        :first_name => 'alilog',
        :last_name => 'salimlog',
        :email => 'eXample@domain.COM',
        :password => '123456',
        :password_confirmation => '123456'
      })

      user.validate
      expect(user.save).to be_truthy
      expect(user.id).to be_present

      logged_user = User.authenticate_with_credentials('EXAMPLe@DOMAIN.CoM', '123456')
      expect(logged_user).to be_truthy
      expect(logged_user.first_name).to eq('alilog')
      expect(logged_user.last_name).to eq('salimlog')

    end
  end
end
