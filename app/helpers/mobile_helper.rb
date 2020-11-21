module MobileHelper
  def head_menu(search)
    react_component("HeadMenu",
      root: root_path,
      industries_url: industries_url,
      search:search)
  end
end