class FeedController < ApplicationController

  def index
  end

  def items
    @news = Item.get_on_page params[:user_id], params[:page]
    @last_page = Item.last_page params[:user_id]
    render :json => {items: @news, lastPage: @last_page}
  end

end
