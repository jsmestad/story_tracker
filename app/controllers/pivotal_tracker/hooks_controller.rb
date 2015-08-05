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

    EVENTS = %w[ story_move_activity story_update_activity story_delete_activity ].freeze

    def callback
      if ENV['CALLBACK_TOKEN'] != params[:token]
        render nothing: true, status: :not_found and return
      end

      payload = WebhookPayload.new(payload_params)

      unless EVENTS.include?(payload.kind)
        render nothing: true, status: :not_found and return
      end

      updated = false
      payload.primary_resources.each do |resource|
        next if resource['kind'] != 'story'
        if story = Story.find_by(external_ref: resource['id'])
          if payload.kind == 'story_delete_activity'
            story.destroy
          else
            story.handle_callback!(payload)
          end
          updated = true
        end
      end

      if updated
        head :created
      else
        head :ok
      end
    end

  protected

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
                        :after_id
                      ],
                      :new_values => [
                        :current_state,
                        :updated_at,
                        :before_id,
                        :after_id
                      ]],
                      :primary_resources => [:kind, :id, :name, :story_type, :url],
                      :performed_by => [:kind, :id, :name, :initials],
                      :project => [:kind, :id, :name])
    end

  end
end
