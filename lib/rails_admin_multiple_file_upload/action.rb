module RailsAdmin
  module Config
    module Actions
      class MultipleFileUpload < Base
        RailsAdmin::Config::Actions.register(self)

        # Is the action acting on the root level (Example: /admin/contact)
        register_instance_option :root? do
          false
        end

        register_instance_option :collection? do
          false
        end

        # Is the action on an object scope (Example: /admin/team/1/edit)
        register_instance_option :member? do
          true
        end

        register_instance_option :route_fragment do
          'multiple_file_upload'
        end

        register_instance_option :controller do
          Proc.new do |klass|
            @conf = ::RailsAdminMultipleFileUpload::Configuration.new @abstract_model

            if params['id'].present?
              if request.get?
                # @nodes = list_entries(@model_config, :index, nil, nil).sort { |a,b| a.lft <=> b.lft }
                @files =
                render action: @action.template_name

              elsif request.post?
                begin
                  embedded_model  = params[:embedded_model].to_s
                  embedded_field  = params[:embedded_field].to_s

                  embedded_model_upload_field  = params[:embedded_model_upload_field].to_s
                  embedded_model_upload_field  = "image" if embedded_model_upload_field.blank?

                  main_obj = @object
                  embedded = main_obj.send(embedded_field).new
                  embedded.send(embedded_model_upload_field + "=", params[embedded_model_upload_field])
                  embedded.save

                  message = "<strong>#{I18n.t('admin.actions.multiple_file_upload.success')}!</strong>"
                rescue Exception => e

                  message = "<strong>#{I18n.t('admin.actions.multiple_file_upload.error')}</strong>: #{e}"
                end

                render text: message
              end
            end
          end
        end

        register_instance_option :link_icon do
          'icon-upload'
        end

        register_instance_option :http_methods do
          [:get, :post]
        end
      end
    end
  end
end
