ActiveAdmin.register Story do

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

  form do |f|
    semantic_errors(*f.object.errors.keys)
    tabs do
      tab 'Basic' do
        inputs 'Details' do
          input :name
          input :description
        end
      end
    end
    actions
  end

  Story.aasm.events.each do |aasm_event|
    action = aasm_event.name
    member_action action do
      @your_model = Story.find_by_guid(params[:id])
      @your_model.send(action.to_s + "!")
      redirect_to admin_story_path(@your_model)
    end

    action_item action, only: :show do
      link_to "#{action.capitalize} Story", send(action.to_s + "_admin_story_path") if story.aasm.events.map(&:name).include?(action)
    end
  end

  show do
    attributes_table do
      row :guid
      row :external_ref
      row :name
      row :story_type
      row :state
      row :created_at
      row :updated_at

    end
    panel "Current Description" do
      attributes_table_for story do
        text_node raw(RDiscount.new(story.latest_description || story.description).to_html)
      end
    end

    panel "Original Description" do
      attributes_table_for story do
        text_node raw(RDiscount.new(story.description).to_html)
      end
    end
  end

  controller do
    def find_resource
      Story.find_by_guid(params[:id])
    end
  end

end
