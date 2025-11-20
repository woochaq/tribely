class DocsController < ApplicationController
  before_action :authenticate_user!, except: [ :show ]
  skip_after_action :verify_authorized, only: :show

  def show
    render Views::Docs::Show.new
  end
end
