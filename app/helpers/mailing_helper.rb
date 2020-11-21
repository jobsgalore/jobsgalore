module MailingHelper

  def grid_contacts(elements, filter = nil, amount = 0)
     react_component(
        'Mailing',
        route: mailing_create_url,
        mailbox: show_mailings_path,
        filterCompany: filter,
        elements: elements,
        amount: amount,
        minPriceForResume: @price[:min_price_resume],
        minPriceForAd: @price[:min_price_message],
        oneEmailForResume: @price[:per_email_resume],
        oneEmailForAd: @price[:per_email_message],
        cur: @price[:cur],
        type: {ad: 'ad to companies', resume: 'resume to companies'},
        seeker: current_client&.applicant?,
        resumes: current_client.resumes_for_apply
    )
  end

  def show_letter(letters)
    react_component(
      'ShowLetters',
      letters: letters,
      newMessage: contacts_of_companies_url,
      url_for_synchronization: show_mailings_url
    )
  end


end