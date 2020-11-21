class Bill
  include Interactor

  def call
    begin
      services = LazyHash.new('1'=>->{urgent}, '2'=>->{top}, '3'=>->{highlight})
      context.params[:type] == '2' ? context.ad = Job.find_by_id(context.params[:id]).decorate : context.ad = Resume.find_by_id(context.params[:id]).decorate
      services = services[context.params[:option]]
      context.url = { id: context.params[:id],
                      type: context.params[:type],
                      item_number:"#{context.params[:option]}#{context.params[:type]}#{context.params[:id]}",
                      item_name:services.name,
                      price: services.price,
                      return_url: context.ad.url}
      if context.ad.blank? or services.price.blank?
        context.fail!
      end
    rescue
      context.fail!
    end
  end

  def urgent
    context.ad.urgent = Date.today
    context.title = "You are buying - Urgent $#{Services::URGENT.price_integer} (7 days)"
    Services::URGENT
  end

  def top
    context.ad.top = Date.today
    context.title = "You are buying - Ad Top $20 (7 days)"
    Services::TOP
  end

  def highlight
    context.ad.highlight = Date.today
    context.title = "You are buying - Highlight $#{Services::HIGHLIGHT.price_integer} (7 days)"
    Services::HIGHLIGHT
  end

end
