module CurrencyHelper
  def currency(cur, sum)
    logger.info("Валюта = #{cur} сумма #{sum}")
    select_format = {
        'RUB' => rub(sum),
        'AUD' => aud(sum),
        'EUR' => eur(sum),
        'USD' => usd(sum),
        'INR' => inr(sum),
        'CAD' => cad(sum),
    }

    select_format[cur.to_s.upcase]
  end

  private
  def eur(sum)
    "€#{sum}"
  end

  def rub(sum)
    "#{sum} RUB"
  end

  def aud(sum)
    "$#{sum}"
  end

  def usd(sum)
    "$#{sum}"
  end

  def inr(sum)
    "#{sum} INR"
  end

  def cad(sum)
    "$#{sum}"
  end
end