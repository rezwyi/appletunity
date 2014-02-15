class PagesController < ApplicationController
  respond_to :html
  
  def about
    respond_with({})
  end

  def terms
    respond_with({})
  end
end
