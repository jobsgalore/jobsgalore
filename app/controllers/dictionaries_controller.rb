class DictionariesController < ApplicationController
  def search
    @search = Dictionary.where(params[:query])
  end
end