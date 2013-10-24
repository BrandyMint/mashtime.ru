class MembershipsController < ApplicationController
	before_filter :require_login
	inherit_resources
	belongs_to :project

	def index
		@invite = Invite.new
		super
	end

	def create
		@project = parent

		@membership = @project.memberships.build user: current_user
		authorize_action_for(@membership)

		user = User.where(email: invite_params[:email]).first

		if user.present?
			@new_membership = @project.memberships.create user: user, role: invite_params[:role]
		else
			@invite = @project.invites.build invite_params.merge(user: current_user)
			if @invite.save
				flash[:notice] = t('invite_sent', email: @invite.email)
			else
				render :index and return
			end
		end

    respond_to do |format|
      format.html { redirect_to project_memberships_url(@project) }
      format.js
    end
	end

	def destroy
		@membership = Membership.find params[:id]
		authorize_action_for(@membership)
		@membership.destroy

		redirect_to project_memberships_url(parent)
	end

	def update
		@membership = Membership.find params[:id]
		authorize_action_for(@membership)
		@membership.role = membership_params[:role]
		@membership.save!

		redirect_to project_memberships_url(parent)
	end

	protected

	def membership_params
		params.require(:membership).permit(:role)
	end

	def invite_params
		params.require(:invite).permit(:email, :role)
	end
end
