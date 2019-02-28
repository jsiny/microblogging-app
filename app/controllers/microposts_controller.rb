class MicropostsController < ApplicationController
  
  before_action :logged_in_user,    only: [:destroy, :create]
  
  def create
  end
  
  def destroy
  end
  
  
  
end
