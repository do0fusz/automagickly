class PagesController < ApplicationController
	before_action :authorize 

	def welcome 
		@plans = Braintree::Plan.all
	end

end