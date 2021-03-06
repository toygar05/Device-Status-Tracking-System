class AuthenticationController < ApplicationController
  before_filter :authenticate_user, :only => [:account_settings, :set_account_info]

  def sign_in
    @user = User.new
  end

  def signed_out
    session[:user_id] = nil
    flash[:notice] = "Cikis yaptiniz"
    redirect_to :root
  end

  def new_user
    @user = User.new
  end

  def account_settings
    @user = current_user
  end

  def set_account_info
    old_user = current_user

    # verify the current password by creating a new user record.
    @user = User.authenticate_by_username(old_user.username, params[:user][:password])

    # verify
    if @user.nil?
      @user = current_user
      @user.errors[:password] = "Girdiginiz sifre yanlis."
      render :action => "account_settings"
    else
      # update the user with any new username and email
      @user.update(params[:user])
      # Set the old email and username, which is validated only if it has changed.
      @user.previous_email = old_user.email
      @user.previous_username = old_user.username

      if @user.valid?
        # If there is a new_password value, then we need to update the password.
        @user.password = @user.new_password unless @user.new_password.nil? || @user.new_password.empty?
        @user.save
        flash[:notice] = 'Hesap ayarlariniz degistirildi.'
        redirect_to :root
      else
        render :action => "account_settings"
      end
    end
  end

  def register
    @user = User.new(params[:user])

    if @user.valid?
      @user.save
      session[:user_id] = @user.id
      flash[:notice] = 'Welcome.'
      redirect_to :root
    else
      render :action => "new_user"
    end
  end

  def login
    username_or_email = params[:user][:username]
    password = params[:user][:password]

    if username_or_email.rindex('@')
      email=username_or_email
      user = User.authenticate_by_email(email, password)
    else
      username=username_or_email
      user = User.authenticate_by_username(username, password)
    end

    if user
      session[:user_id] = user.id
      flash[:notice] = 'Hosgeldin ' + user.username.to_s + "."
      redirect_to :root
    else
      @user = User.new
      flash.now[:error] = 'Girdiginiz kullanici adi ve ya sifre yanlis.'
      render :action => "sign_in"
    end
  end
end