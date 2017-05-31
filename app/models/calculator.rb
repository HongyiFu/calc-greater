class Calculator < ApplicationRecord
	
	def self.compute(num_of_yrs:, starting_amt:, contribution:, contribute_monthly_or_yearly:, rate_of_return:, monthly_or_yearly:)

		# contribute_monthly_or_yearly: 0 => yearly, 1 => monthly
		# monthly_or_yearly: 0 => rate of return yearly, 1 => rate of return monthly

		num_of_contribution_terms = contribute_monthly_or_yearly == 0 ? num_of_yrs : num_of_yrs * 12
		num_of_terms = monthly_or_yearly == 0 ? num_of_yrs : num_of_yrs * 12
		if rate_of_return == 0 
			contributions = contribution * num_of_contribution_terms
			interests = 0
			total_amt = starting_amt + contributions
			yearly_increase = contribute_monthly_or_yearly == 0 ? contribution : contribution * 12
			yearly_networth = [starting_amt]
			num_of_yrs.to_i.times do 
				yearly_networth << yearly_networth[-1] + yearly_increase
			end
		else

			# formula S = a((1+i)^(n+1)-1)/i

			# change rate_of_return to monthly or annually depending on contribution frequency
			if num_of_terms < num_of_contribution_terms # contribute monthly but rate given is yearly
				rate_of_return = ((1 + rate_of_return/100.0) ** (1/12.0) - 1) * 100.0
			elsif num_of_terms > num_of_contribution_terms # contribute yearly but rate given is monthly
				rate_of_return = ((1 + rate_of_return/100.0) ** 12 - 1) * 100.0
			end

			# starting capital
			total_amt = starting_amt * ((1 + rate_of_return/100.0) ** num_of_contribution_terms)	
			
			# apply formula
			total_amt +=  contribution * ((1 + rate_of_return/100.0) ** (num_of_contribution_terms + 1) - 1) * 100.0 / rate_of_return 

			contributions = contribution * num_of_contribution_terms
			interests = total_amt - starting_amt - contributions

			yearly_increase = contribute_monthly_or_yearly == 0 ? contribution : contribution * ((1 + rate_of_return/100.0) ** 12 - 1) * 100.0 / rate_of_return
			yearly_networth = [starting_amt+contribution]
			num_of_yrs.to_i.times do 
				if contribute_monthly_or_yearly == 0
					growth_of_networth = (1 + rate_of_return/100.0)
				else 
					growth_of_networth = (1 + rate_of_return/100.0) ** 12.0
				end	
				yearly_networth << (yearly_networth[-1] * growth_of_networth + yearly_increase)
			end
		end

		[total_amt.round(2), starting_amt.round(2), contributions.round(2), interests.round(2), yearly_networth.map.with_index(0) {|v,i| [i,v.round(2)]}.to_h]

	end

end

