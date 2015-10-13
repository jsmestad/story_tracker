require 'airbrake/rails/controller_methods'

module PivotalTracker
  class HooksController < ActionController::Metal
    include AbstractController::Rendering
    include ActionView::Rendering
    # include ActionController::ParamsWrapper
    include ActionController::Rescue
    include ActionController::StrongParameters
    include ActionController::Rendering
    include ActionController::Renderers::All
    include ActionController::Head
    include ActionController::Instrumentation
    include Airbrake::Rails::ControllerMethods

    EVENTS = %w[ story_create_activity story_started_activity story_estimated_activity story_move_activity story_update_activity story_delete_activity ].freeze

    def callback
      if ENV['CALLBACK_TOKEN'] != params[:token]
        render nothing: true, status: :not_found and return
      end

      payload = WebhookPayload.new(payload_params)

      unless EVENTS.include?(payload.kind)
        render nothing: true, status: :not_found and return
      end

      updated = false
      payload.changes.each do |resource|
        next unless resource['kind'] == 'story'
        if story = Story.find_by(external_ref: resource['id'])
          if resource['change_type'] == 'update'
            update_from_pivotal(story, resource)
          end
          story.activities.create!(highlight: payload.highlight)
          story.handle_callback!(payload)
          updated = true
        elsif payload.kind != 'story_delete_activity'
          # TODO create from payload

          Story.import_from_pivotal!(resource['id'])
          updated = true
        end
      end

      if updated
        head :created
      else
        head :ok
      end
    rescue => e
      notify_airbrake(e)
      render json: { message: "Internal Error: #{e}" }.to_json, status: 500
    end

    protected

    def update_from_pivotal(story, payload)
      changes = payload['new_values']
      %w(name story_type description).each do |field|
        story.send(:"#{field}=", changes[field]) if changes.has_key?(field)
      end
      story.save!
    end

    def payload_params
      params.permit(:kind, :occurred_at, :highlight, :message, :project_version,
                    :guid, :changes => [
                      :kind,
                      :change_type,
                      :id,
                      :name,
                      :story_type,
                      :original_values => [
                        :current_state,
                        :updated_at,
                        :before_id,
                        :after_id,
                        :story_type,
                        :description,
                        :name
                      ],
                      :new_values => [
                        :current_state,
                        :updated_at,
                        :before_id,
                        :after_id,
                        :story_type,
                        :description,
                        :name
                      ]],
                      :primary_resources => [:kind, :id, :name, :story_type, :url],
                      :performed_by => [:kind, :id, :name, :initials],
                      :project => [:kind, :id, :name])
    end

  end
end
