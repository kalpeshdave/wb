module CompaniesHelper
  def init_company(company)
    returning(company) do |c|
      c.build_address if c.address.blank?
    end
  end
end
