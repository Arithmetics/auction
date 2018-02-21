class HomeController < ApplicationController
  def index
    @drafts = Draft.all
  end
end
