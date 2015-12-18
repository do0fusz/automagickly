class SubscriptionsController < ApplicationController

	def create
		unless current_user.credit_card_token
			redirect_to new_payment_method_path
			return 
		end
		
		result = Braintree::Subscription.create(
			payment_method_token: current_user.credit_card_token,
			plan_id: params[:plan_id]
			)
		if result.success? 
			flash[:notice] = "Subscribed"
		else
			flash[:error] = "Something went wrong"
			logger.error "Could not create subscription for email #{current_user.email}, due to #{result.errors.inspect }"
		end
		redirect_to root_path
	end

end