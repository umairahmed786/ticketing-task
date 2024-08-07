class RenameSiteToSubdomainInOrganizations < ActiveRecord::Migration[6.1]
  def change
    rename_column :organizations, :site, :subdomain
  end
end
