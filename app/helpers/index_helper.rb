module IndexHelper
  def main_page_search(search)
    if search && search["location_name"] == 'Australia'
      default = Location.default
      search["location_id"] = default.id
      search["location_name"] = default.name
    end
    react_component("MainPageSearch", name: "main_search", search: search)
  end
end