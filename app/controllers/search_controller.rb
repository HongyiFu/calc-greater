require 'rest-client'
require 'csv'

class SearchController < ApplicationController
	include SessionsHelper

	before_action :require_login

	def search
		if params[:sym].present?
			res = RestClient.get("http://finance.yahoo.com/d/quotes.csv?s=#{params[:sym]}&f=nxab")
			@arr = CSV.parse(res.body)
		end
	end


	private
 
  def require_login
    unless logged_in?
      redirect_to root_path, danger: "You must be logged in to use this functionality."
    end
  end
end
