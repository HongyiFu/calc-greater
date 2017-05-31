class PortfoliosController < ApplicationController
	include SessionsHelper

	before_action :require_login

	def index
		@portfolios = current_user.portfolios
	end

	def show
		@portfolio = current_user.portfolios.find_by(id:params[:id])
	end

	def new
		@portfolio = current_user.portfolios.new
	end

	def create
		@portfolio = current_user.portfolios.new(portfolio_params)
		if @portfolio.save
			redirect_to portfolios_path, success:"Portfolio successfully created!"
		else
			flash.now[:danger] = "#{@portfolio.errors.full_messages.join(". ")}."
			render 'new'
		end
	end

	def update

	end

	private
 
  def require_login
    unless logged_in?
      redirect_to root_path, danger: "You must be logged in to use this functionality."
    end
  end

  def portfolio_params
  	params.require(:portfolio).permit(:name,:description,:cash)
  end

end
