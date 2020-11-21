module AdminCompanyHelper
  def company_description(company)
    react_component(
        'CompanyEdit',
        size: {all: Size.all.select(:id, :size).map{|t| {id:t.id, name: t.size}}, value: company.size_id},
        location: {className: "form-control dropdown-toggle",
                   name: "company[location",
                   id: "company_location_id",
                   route: '/search_locations/',
                   defaultName: @company.location ? @company.location.name : Location.default.name,
                   defaultId: @company.location ? @company.location.id : Location.default.id},
        industry: {all: Industry.all.select(:id, :name), value: company.industry_id},
        name: company.name,
        site: company.site,
        recruitmentagency: company.recrutmentagency,
        description: company.description,
        route: admin_company_url,
        update_route: admin_get_company_url
    )
  end

  def input_emails(company)
    react_component(
        'Grid_Inputs',
        emails: company.emails_to_grid,
        location_name: company.location ? company.location.name : Location.default.name,
        location_id: company.location ? company.location.id : Location.default.id,
        route: admin_company_url,
        update_route: admin_get_emails_url
    )
  end

  def input_logo(company)
    react_component(
        'EditPicture',
        image: company.logo_uid ? Dragonfly.app.remote_url_for(company.logo_uid) : company.logo_uid,
        defaultImage: image_url("company_profile.jpg"),
        route: admin_company_url,
        update_route: admin_get_logo_url
    )
  end

  def duplicate
    react_component(
       'Duplicate',
        route: admin_company_url,
    )
  end
end