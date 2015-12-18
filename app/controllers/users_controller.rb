class UsersController < ApplicationController

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)
		if @user.save 
			create_braintree_customer(user: @user)
			session[:user_id] = @user.id 
			redirect_to '/'
		else 
			render :new
		end
	end

	private 
	
	def user_params 
		params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
	end

	def create_braintree_customer(user:)
		result = Braintree::Customer.create(
				user_params.slice(:first_name, :last_name, :email)
			)
		if result.success? 
			user.update_attribute(:customer_id, result.customer.id)
		else
			logger.error "Could not create braintree customer for email #{user.email}, because of #{ result.errors.inspect}. "
		end
	end
end