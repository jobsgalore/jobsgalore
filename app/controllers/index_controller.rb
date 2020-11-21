class IndexController < ApplicationController
  #authorize_resource only:[:admin]
  skip_before_action :verify_authenticity_token, only: [:file_to_html]
  before_action :i_frame_app, only: :main

  def main
      i_frame_app?
      @first = i_frame_app_first
      @main = Main.call(query:@search)
      @number_of_jobs = NumberOfJobsQuery.new.call
  end

  def advertising_terms_of_use;  end

  def category_view
    @category_view = CategoryView.call(params:params.permit(:category, :object, :page))
    unless @category_view.success?
      render_404
    end
  end

  def main_search
    @result = MainSearch.call(params:main_search_params)
    a = @result.param.to_h
    cookies[:query] = {
        value: JSON.generate({
                                 type: a["type"],
                                 value: "",
                                 category: a["category"],
                                 location_id: a["location_id"],
                                 location_name: a["location_name"],
                                 open: false
                             }),
        expires: 1.year
    }
    puts cookies[:query]
    @search = @result.param
    if @result.failure?
      render_404
    end
  end

  def by_category
    @by_category = ByCategory.call(params:params[:obj])
    unless @by_category.success?
      render_404
    end
  end

  def about;  end

  def contact;  end

  def send_mail
    ContactUsMailer.send_mail(params.require(:contact).permit(:firstname, :lastname, :email, :subject, :message, :phone).to_h).deliver_later
    redirect_to(contact_path, notice: 'Email sent')
  end

  def send_to_customers
      Email.all.each do |adress|
        ContactUsMailer.send_to_customers(adress.email).deliver_later
      end
    redirect_to(root_path, notice: "Show must go on!!!")
  end

  def terms_and_conditions;  end

  def privacy;  end

  def admin;  end

  def sitemap
    render file: 'public/sitemap/sitemap.xml', formats: :xml
  end

  def sitemaps
    begin
      render file: "public/sitemap/sitemaps#{params[:id]}.xml", formats: :xml
    rescue
      Rails.logger.info("Error : Запрос несуществующего sitemaps")
      render inline: '<?xml version="1.0" encoding="UTF-8"?><urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"></urlset>'
    end
  end

  def robot
    respond_to do |format|
      format.txt{render file: 'public/robots.txt'}
      format.html{redirect_to root_url}
    end
  end

  def ads
    respond_to do |format|
      format.txt{render file: 'public/ads.txt'}
      format.html{redirect_to root_url}
    end
  end

  def sw
    respond_to do |format|
      format.js{render file: 'public/sw.js'}
      format.html{redirect_to root_url}
    end
  end


  def rss
    t = Time.now
    @obj = Job.select(:id,:title,:company_id, :location_id, :industry_id, :updated_at, :created_at, :description).includes(:company, :industry, :location).where(created_at:t-1.week..t).decorate
    render :rss, formats: :xml
  end

  def file_to_html
    @file = OfficeDocumentToHtml.call(params: params.permit(:file))
    render :file_to_html, formats: :json
  end

  def logo
    send_file 'public/jg.png', type: 'image/png', disposition: 'inline'
  end

  def jg
    send_file 'public/face.jpg', type: 'image/png', disposition: 'inline'
  end

  private

  def main_search_params
    params.permit(:page, main_search: [:type, :value, :page, :salary,  :options, :category, :location_id, :location_name, :urgent, :open, :sort])
  end


end
