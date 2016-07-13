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
                @files = []
                render action: @action.template_name

              elsif request.post?
                begin
                  child_model  = params[:child_model].to_s
                  child_field  = params[:child_field].to_s

                  child_model_upload_field  = params[:child_model_upload_field].to_s
                  child_model_upload_field  = "image" if child_model_upload_field.blank?

                  _file = params[child_field][child_model_upload_field]
                  if ["undefined", "blob", '', nil].include?(_file.original_filename)
                    ext = _file.content_type.split("/").last
                    _file.original_filename = "#{(Time.new.to_f*1_000_000).to_i}.#{ext}"
                  end

                  main_obj = @object
                  child = main_obj.send(child_field).new
                  child.send(child_model_upload_field + "=", params[child_field][child_model_upload_field])
                  if child.save
                    message = "<strong>#{I18n.t('admin.actions.multiple_file_upload.success')}!</strong>"
                  else
                    message = "<strong>#{I18n.t('admin.actions.multiple_file_upload.save_error')}</strong>: #{child.errors.full_messages}"
                  end

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
