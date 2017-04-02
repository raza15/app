require 'mechanize'
require 'logger'
require 'socket' 

class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
    # puts "HAHAHA start"
    # puts current_user
    # puts "HAHAHA end"
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    if (User.find_by(email: user_params[:email]))==nil then
      respond_to do |format|
        if @user.save
          log_in @user
          format.html { redirect_to @user, notice: 'User was successfully created.' }
          format.json { render :show, status: :created, location: @user }
        else
          format.html { render :new }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to signup_path
    end
  end
  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def face_book
    @website = 'https://www.facebook.com/login.php?login_attempt=1&lwv=110' 
    agent = Mechanize.new
    agent.log = Logger.new "mechanize.log"
      agent.user_agent_alias = 'Mac Safari'
      agent.follow_meta_refresh = true
      agent.redirect_ok = true
    login_page  = agent.get (@website)
    login_form = login_page.forms.first 
    email_field = login_form.field_with(name: "email")
    password_field = login_form.field_with(name: "pass")  
    email_field.value = ''
    password_field.value = ''
    home_page = login_form.click_button
    @blah = agent.get("https://m.facebook.com/")
    # puts "BEGIN...",button,"END..."
  end

  def twitter
    @website = 'https://twitter.com/login' 
    agent = Mechanize.new
    agent.log = Logger.new "mechanize.log"
      agent.user_agent_alias = 'Mac Safari'
      agent.follow_meta_refresh = true
      agent.redirect_ok = true
    login_page  = agent.get (@website)
    login_form = login_page.forms.second 
    email_field = login_form.field_with(name: "session[username_or_email]")
    password_field = login_form.field_with(name: "session[password]")  
    email_field.value = ''
    password_field.value = ''
    home_page = login_form.click_button
    @blah = agent.get("https://twitter.com/")
    # puts "BEGIN...",button,"END..."
  end

  def stack_overflow
    @website = 'https://stackoverflow.com/users/login' 
    agent = Mechanize.new
    agent.log = Logger.new "mechanize.log"
      agent.user_agent_alias = 'Mac Safari'
      agent.follow_meta_refresh = true
      agent.redirect_ok = true
    login_page  = agent.get (@website)
    login_form = login_page.forms.second 
    email_field = login_form.field_with(name: "email")
    password_field = login_form.field_with(name: "password")  
    email_field.value = ''
    password_field.value = ''
    home_page = login_form.click_button
    @blah = agent.get("https://stackoverflow.com/")
    # puts "BEGIN...",button,"END..."
  end

  def g_mail

    @website = 'https://accounts.google.com/ServiceLogin?service=mail&passive=true&rm=false&continue=https://mail.google.com/mail/&ss=1&scc=1&ltmpl=default&ltmplcache=2&emr=1&osid=1#identifier' 
    agent = Mechanize.new
    agent.log = Logger.new "mechanize.log"
      agent.user_agent_alias = 'Mac Safari'
      agent.follow_meta_refresh = true
      agent.redirect_ok = true
    login_page  = agent.get (@website)
    login_form = login_page.forms.first 
    email_field = login_form.field_with(name: "Email")
    email_field.value = ''
    login_page = login_form.click_button
    # login_page  = agent.get ("https://accounts.google.com/ServiceLogin?service=mail&passive=true&rm=false&continue=https://mail.google.com/mail/&ss=1&scc=1&ltmpl=default&ltmplcache=2&emr=1&osid=1#password")
    login_form = login_page.forms.first
    password_field = login_form.field_with(name: "Passwd")  
    password_field.value = ''
    home_page = login_form.click_button
    @blah = agent.get("https://mail.google.com/mail/u/0/h/xhur4t66hu4s/")
    # puts "BEGIN...",button,"END..."
  end  


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :password)
    end
end
