class CalculatorController < ApplicationController
	
	def calculate
		if !empty_values?
			@array = Calculator.compute(num_of_yrs:params["num_of_yrs"].to_f, starting_amt:params["starting_amt"].to_f, contribution:params["contribution"].to_f, contribute_monthly_or_yearly:params["contribute_monthly_or_yearly"].to_i, rate_of_return:params["rate_of_return"].to_f, monthly_or_yearly:params["monthly_or_yearly"].to_i)
			respond_to do |format|
				format.js
			end
		else
			@array = empty_values?
			respond_to do |format|
				format.js { render:'calculate_error', status: 422 }
			end
		end
	end

	private
		def empty_values?
			arr = []
			params.each do |key,value|
				arr << key if value == ""
			end
			if arr.count > 0
				return arr
			else
				return false
			end
		end

end
