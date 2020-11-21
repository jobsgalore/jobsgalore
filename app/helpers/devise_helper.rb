module DeviseHelper

  def devise_error_messages!
    return '' if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    html = <<-HTML
    <div class="alert alert-error alert-danger"> <button type="button"
    class="close" data-dismiss="alert">x</button>
      #{messages}
    </div>
    HTML

    html.html_safe
  end

  def sm?
    browser.device.tablet?
  end

  def xs?
    browser.device.mobile?
  end

  def md?
    !(browser.device.mobile? || browser.device.tablet?)
  end
end