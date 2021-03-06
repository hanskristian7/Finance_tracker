class StocksController < ApplicationController
    def search
        # byebug
        
        if params[:stock].present?
            @stock = Stock.new_lookup(params[:stock])
            if @stock
                respond_to do |format|
                    # expecting partial js file
                    format.js { render partial: 'users/result/stock' }
                end
            else
                respond_to do |format|
                    flash.now[:alert] = "Please enter a valid symbol"
                    format.js { render partial: 'users/result/stock' }
                end
            end 
        else
            respond_to do |format|
                flash.now[:alert] = "Please enter symbol to search"
                format.js { render partial: 'users/result/stock' }
            end
        end
    end
end