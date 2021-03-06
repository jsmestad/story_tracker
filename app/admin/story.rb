ActiveAdmin.register Story do
  permit_params :name, :description, :comment, :user_id

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

  config.sort_order = 'created_at_desc'
  scope("Pending") {|scope| scope.status('submitted')}
  scope("Approved") {|scope| scope.status('approved')}
  scope("Completed") {|scope| scope.status('completed')}
  scope("Rejected") {|scope| scope.status('rejected')}

  scope("Feature") {|scope| scope.feature }
  scope("Defect") {|scope| scope.defect }
  index do
    selectable_column
    column :name
    column :story_type
    column :external_ref
    column :guid, sortable: false
    column :state, storable: false
    column :created_at
    column :updated_at
    actions
  end

  filter :user
  filter :external_ref
  filter :guid
  filter :state, as: :select, collection: proc { Story.states }
  filter :name
  filter :description
  filter :estimate, as: :numeric
  filter :created_at, as: :date_range
  filter :updated_at, as: :date_range

  form do |f|
    semantic_errors(*f.object.errors.keys)
    tabs do
      tab 'Basic' do
        inputs 'Details' do
          input :name
          input :description
          input :user
        end

        inputs 'Update Details' do
          input :comment
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

    panel "Versions" do
      table_for story.versions.reverse do
        column('Version #') { |version| link_to( version.index == 0 ? "Original" : "Version #{version.index+1}", {version: (version.index+1)}) }
        column 'Comment', :comment
        column 'Created', :created_at
      end
    end

    attributes_table do
      row(:version) { |story|
        version = story.version || story.versions.last
        version.index == 0 ? 'Original' : "Version #{version.index+1}"
      }
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
        text_node raw(RDiscount.new(story.latest_description || '#### No External Reference').to_html)
        row 'Update Comment', :comment do |story|
          if story.live?
            nil
          else
            story.version.comment
          end
        end
      end
    end

    panel "Original Description" do
      attributes_table_for story do
        text_node raw(RDiscount.new(story.description || '#### No External Reference').to_html)
      end
    end

  end

  controller do
    def find_resource
      Story.find_by_guid(params[:id])
    end

    def show
      @story = find_resource
      @versions = @story.versions
      @story = @story.versions[params[:version].to_i-1].reify if params[:version]
      show!
    end
  end
  # sidebar :versions, :partial => "admin/layouts/version", :only => :show

end
