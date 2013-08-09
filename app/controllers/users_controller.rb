class UsersController < ApplicationController

  def new
    @reg = RegisterForm.new params[:register_form]
  end

  def create
    @reg = RegisterForm.new params[:register_form]

    user = @reg.save
    if user.present?
      Invite.activate_for(user)
      redirect_to time_shifts_url, :notice => t(:signed_up)
    else
      render :new
    end
  end

end
