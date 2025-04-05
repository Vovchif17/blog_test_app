class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def new
  end

  def create
    user = User.find_by(email_address: params[:email_address])

    if user&.authenticate(params[:password])
      session[:user_id] = user.id

      redirect_to root_path, notice: "You are log in!"
    else
      flash.now[:alert] = "Bad password or email"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    Rails.logger.debug "Before logout: #{session[:user_id]}" 
    session[:user_id] = nil
    Rails.logger.debug "After logout: #{session[:user_id]}" 
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("navbar", partial: "shared/navbar") }
      format.html { redirect_to root_path, notice: "You are log in!" }
    end
  end
end

