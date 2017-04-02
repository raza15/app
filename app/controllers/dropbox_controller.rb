require 'dropbox_sdk'

APP_KEY = 'yxi5sdfemh1m2zl'
APP_SECRET = 'bj1ptqnzgbrvxbu'
ACCESS_TYPE = "dropbox" 

class DropboxController < ApplicationController

before_filter :auth_user, :only => [:index, :search, :searchresult, :create_folder, :download_file, :delete_file, :upload]  
  
  def authorize
    if not params[:oauth_token] then
      dbsession = DropboxSession.new(APP_KEY, APP_SECRET)
      session[:dropbox_session] = dbsession.serialize
      redirect_to dbsession.get_authorize_url url_for(:action => 'authorize')
    else
      # the user has returned from Dropbox
      dbsession = DropboxSession.deserialize(session[:dropbox_session])
      dbsession.get_access_token  #we've been authorized, so now request an access_token
      session[:dropbox_session] = dbsession.serialize
      redirect_to root_path, :notice => "You are now authorized! Try upload again."
    end
  end
    
  def auth_user
    return redirect_to(:action => 'authorize') unless session[:dropbox_session]
     dbsession = DropboxSession.deserialize(session[:dropbox_session])
     @client = DropboxClient.new(dbsession, ACCESS_TYPE)
     @info = @client.account_info().inspect
  end
     
  def index
    # Ensure user has authorized app    
    @entries = @client.metadata('/')
    # puts "HAHA HERE START"
    # puts @entries["contents"]
    # puts "HAHA HERE END"
  end

  def search    
    @entries = @client.metadata('/')
    # puts "HAHA HERE START SEARCH"
    # puts @entries["contents"]
    # puts "HAHA HERE END SEARCH"
  end

  def searchresult    
    @entries = @client.metadata('/')
    @search_params = params[:search]
    puts "HAHA HERE START SEARCH"
    all_files = [] 
    for entry in @entries["contents"] do
      if entry["is_dir"] == false
        all_files.push(entry["path"])
      end
    end
    puts @search_results
    puts "HAHA HERE END SEARCH"
    @search_results = []
    for file in all_files do
      if file.include? ".txt" 
        contents, metadata = @client.get_file_and_metadata(file)        
        if contents.include? @search_params
          @search_results.push(file)
          # puts "\n\n\n\n#{contents}\n\n\n"
        end
      end
    end
  end
    
  def create_folder
    folder = @client.file_create_folder(params[:foldername])
    flash[:notice] = "A new folder '#{params[:foldername]}' was created successfully!"
    redirect_to root_path
  end
    
  def download_file
    contents = @client.get_file(params[:id])
    # puts "--------------------"
    # puts contents
    File.open(params[:id], 'wb') do |f|
      f.write(contents)
    end
    flash[:notice] = "#{params[:id]}' was downloaded successfully!"
    redirect_to root_path
  end
    
  def delete_file
    removefile = @client.file_delete(params[:id])
    flash[:notice] = "'#{params[:id]}' has been removed!"
    redirect_to root_path
  end

  def upload
    if request.method != "POST"
    # show a file upload page
      render :inline =>
      "#{info['email']} <br/><%= form_tag({:action => :upload}, :multipart => true) do %><%=          file_field_tag 'file' %><%= submit_tag %><% end %>"
      return
    else
      # upload the posted file to dropbox keeping the same name
      resp = @client.put_file(params[:myfile].original_filename, params[:myfile].read, true)
      flash[:notice] = "Upload successful! File location: #{resp['path']}, version: #{resp['revision']}"       
      redirect_to root_path
    end
  end
end