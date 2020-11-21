# frozen_string_literal: true
#Манкин патчинг некоторых свтроенных хелперов

require "active_support/core_ext/array/extract_options"
require "active_support/core_ext/hash/keys"
require "active_support/core_ext/object/inclusion"
require "active_support/core_ext/object/try"
require "action_view/helpers/asset_url_helper"
require "action_view/helpers/tag_helper"

module ActionView::Helpeer::AssetTagHelper
=begin
  def image_tag(source, options = {})
    options[:class] = options[:class].to_s + ' b-lazy'
    options["data-src"] = source
    source = 'data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw=='
    super(source, options)
  end
=end
end
