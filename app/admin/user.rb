ActiveAdmin.register User do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end

  permit_params :name, :email_address, :role

  controller do
    def find_resource
      User.find_by_guid(params[:id])
    end
  end


  form do |f|
    semantic_errors(*f.object.errors.keys)
    tabs do
      tab 'Basic' do
        inputs 'Details' do
          input :name
          input :email_address
          input :role, as: :select, collection: User.roles.keys.map {|role| [role.titleize,role]}, include_blank: false
        end
      end
    end
    actions
  end
end
