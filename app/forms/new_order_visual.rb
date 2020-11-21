class NewOrderVisual
  include Virtus.model(strict: true)
  include ActiveModel::Model
  attribute :urgent, Boolean, :default => true
  attribute :current
  attribute :urgent_price
  attribute :highlight,  Boolean, :default => true
  attribute :highlight_price
  attribute :urgent_and_highlight_price
  attribute :object
  attribute :id, Integer
  attribute :type, Symbol
  attribute :product
  attribute :price
  attribute :order

  validates :id, :type, :product, presence: true

  def initialize(type:, id:, ip:)
    raise "Incorrect params" if type.blank? or id.blank?
    self.id, self.type = id, type.downcase.to_sym
    if self.type == :job
      self.object = Job.find_by_id(id).decorate
    elsif self.type == :resume
      self.object = Resume.find_by_id(id).decorate
    else
       raise "Type do not defined"
    end

    self.current =  Country.currency_by_country(ip)
    self.urgent_price = Product.find_by_type_and_option(type: type, urgent: true, highlight:false)
                            .price_by_currency(self.current)
    self.highlight_price = Product.find_by_type_and_option(type: type, urgent: false, highlight:true)
                               .price_by_currency(self.current)
    self.urgent_and_highlight_price = Product.find_by_type_and_option(type: type, urgent: true, highlight:true)
                                          .price_by_currency(self.current)
  end

  def set_product(product)
    self.urgent = product.scan('urgent').present?
    self.highlight  = product.scan('highlight').present?
    self.product = Product.find_by_type_and_option(
        type: type,
        urgent: self.urgent,
        highlight:self.highlight
    )
    self.price = self.product.price_by_currency(self.current)

  end

  def urgent_object
    object.urgent = Time.now
    object.highlight = nil
    object
  end

  def highlight_object
    object.urgent = nil
    object.highlight = Time.now
    object
  end

  def urgent_and_highlight_object
    object.urgent = Time.now
    object.highlight = Time.now
    object
  end

  def save
    return false unless self.valid?
    params = []
    params.push({
                     type: self.type,
                     id: self.id,
                     option: Option::URGENT
                  })  if self.urgent
    params.push({
                    type: self.type,
                    id: self.id,
                    option: Option::HIGHLIGHT
                })  if self.highlight
    self.order = Order.new(product_id: self.product.id, params: params)
    self.order.save
  end

  #TODO Доделать


  def id_for_paypal
    "55#{self.order.id}"
  end

  def job?
    self.type == :job
  end

  def resume?
    self.type == :resume
  end

  private

end