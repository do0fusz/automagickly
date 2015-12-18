class PaymentMethodsController < ApplicationController
	before_action :authorize 
	
	def new
		@tr_data = Braintree::TransparentRedirect.create_credit_card_data(
			redirect_url: confirmation_payment_methods_url,
			credit_card: {
				customer_id: current_user.customer_id
				}
			)
	end


	def confirmation
		result = Braintree::TransparentRedirect.confirm(request.query_string)
		if result.success?
			current_user.update_attribute(:credit_card_token, result.credit_card.token)
		else
			logger.error "Could not create card for email #{current_user.email}, because #{result.errors.inspect}"
		end
		redirect_to root_path
	end

end