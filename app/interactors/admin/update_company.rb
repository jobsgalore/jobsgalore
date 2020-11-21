# frozen_string_literal: true

class Admin::UpdateCompany
  include Interactor

  def call
    services = LazyHash.new(
      'update_emails' => -> { emails },
      'update_company' => -> { company },
      'update_logo' => -> { logo },
      'absorb' => -> { absorb }
    )
    services[context.params['action_executed']]
  end

  def emails
    company_id = context.params['id']
    array_of_emails = JSON.parse(context.params['data'], opts = { symbolize_names: true }).try(:compact)
    delete_excess_emails(array_of_emails, company_id)
    if array_of_emails.present?
      array_of_emails.each do |t|
        t[:location_id] = nil if t[:location_name].blank?
        t.delete(:location_name)
        t[:company_id] = company_id
        t[:fio] = t[:fio].squish
        t[:email] = t[:email].squish
        t[:phone] = t[:phone].squish
        t[:id].present? ? update_email(t) : EmailHr.create(t)
      end
    end
  end

  def company
    saved_company = Company.find_by_id(context.params['id'])
    company = JSON.parse(context.params['data'], opts = { symbolize_names: true })
    need_to_save = false
    company.keys.each do |attr|
      value, need_to_save = comparison(saved_company.try(attr), company[attr], need_to_save)
      puts "#{attr}= #{value}"
      saved_company.try("#{attr}=", value)
    end
    saved_company.save if need_to_save
  end

  def logo
    saved_company = Company.find_by_id(context.params['id'])
    puts context.params['data']
    saved_company.logo = context.params['data']["img"]
    saved_company.save
  end

  def absorb
    Company.find_by_id(context.params['id']).absorb(context.params['data']['dup_id'].to_i)
  end

  private

  def delete_excess_emails(emails, company)
    saved_emails = Company.find_by_id(company).email_hr
    if saved_emails.present?
      if emails.present?
        for_delete = saved_emails.pluck(:id) - emails.map { |t| t[:id] }
        EmailHr.where(id: for_delete).destroy_all if for_delete.present?
      else
        saved_emails.destroy_all
      end
    end
  end

  def update_email(t)
    need_to_save = false
    email = EmailHr.find_by_id t[:id]
    t.keys.each do |attr|
      value, need_to_save = comparison(email.try(attr), t[attr], need_to_save)
      email.try("#{attr}=", value)
    end
    email.save if need_to_save
  end

  def comparison(old_value, new_value, need_to_save)
    if old_value != new_value
      [new_value, true]
    else
      [old_value, need_to_save]
    end
  end
end
