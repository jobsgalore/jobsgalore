class Order < ApplicationRecord
  include AASM
  belongs_to :product
  belongs_to :payment

  aasm do
    state :expect_the_payment, initial: true
    state :error
    state :finished

    event :finish do
      transitions from: :expect_the_payment, to: :finished
      transitions from: :error, to: :finished
    end

    event :error do
      transitions from: :expect_the_payment, to: :error
    end
  end

  def pay(payment_id)
    begin
      self.params.each do |t|
        Option.select_options(
                  option: t["option"].to_sym,
                  type: t["type"],
                  id:  t["id"]
        )
      end
      self.update(payment_id: payment_id)
      self.finish!
    rescue
      self.params.push({error: $!})
      self.payment_id =  payment_id
      self.save
      self.error!
    end
  end

end
