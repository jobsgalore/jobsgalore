class ErrorsController < ApplicationController
  def error_404
    @main = Main.call(query:@search)
    render "errors/error_404", status: :not_found, formats: :html
  end
end