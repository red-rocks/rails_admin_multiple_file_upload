module RailsAdminMultipleFileUpload
  module Helper
    def rails_admin_multiple_file_upload(files, opts= {})
      # backward compatibility
      opts[:child_field] ||= opts[:embedded_field]
      opts[:child_model_order_field] ||= opts[:embedded_model_order_field]
      opts[:child_model_upload_field] ||= opts[:embedded_model_upload_field]

      files = files.to_a.sort_by do |m|
        _meth = opts[:child_model_order_field]
        _meth = "order" if _meth.blank?
        _meth = "sort" unless m.respond_to?(_meth)
        _meth = "lft" unless m.respond_to?(_meth)
        if _meth and m.respond_to?(_meth)
          m.send(_meth).to_i
        end
      end
      id = "ns_#{rand(100_000_000..999_999_999)}".freeze
      config = {
          update_url: multiple_file_upload_path(model_name: @abstract_model),
          child_field: opts[:child_field],
          child_model_upload_field: opts[:child_model_upload_field] || "image",
          child_model: @abstract_model.model.new.send(opts[:child_field]).new.class.name
      }
      content_tag(:div, rails_admin_multiple_file_upload_builder(files, config), id: id, class: 'rails_admin_multiple_file_upload'.freeze)
    end

    def rails_admin_multiple_file_upload_builder(files, config)
      ret = []
      _ret = []
      files.each do |ef|
        if multiple_file_upload_paperclip?
          if ef.send(config[:child_model_upload_field] + "_content_type") =~ /\Aimage/
            file_url = ef.send(config[:child_model_upload_field]).url(multiple_file_upload_thumbnail_size)
            _ret << content_tag(:span, image_tag(file_url), class: "file_block_load_already")

          else
            if ef.respond_to?(:name)
              file_name = ef.name
            end
            file_name = ef.send(config[:child_model_upload_field] + "_file_name") if file_name.blank?
            _ret << content_tag(:span, link_to(file_name), class: "file_block_load_already")
          end

        elsif multiple_file_upload_shrine?
          attach = ef.send(config[:child_model_upload_field])
          if attach
            file_obj = attach[multiple_file_upload_thumbnail_size.to_sym]
            if file_obj.metadata['mime_type'] =~ /\Aimage/
              file_url = file_obj.url
              _ret << content_tag(:span, image_tag(file_url), class: "file_block_load_already")

            else
              if ef.respond_to?(:name)
                file_name = ef.name
              end
              file_name = file_obj.metadata['filename'] if file_name.blank?
              _ret << content_tag(:span, link_to(file_name), class: "file_block_load_already")
            end
          end
        end
      end
      ret << content_tag(:div, _ret.join.html_safe)
      ret << content_tag(:div, "", class: "clearfix")
      ret << rails_admin_form_for(@object, url: config[:update_url], html: {method: :post, multipart: true, class: "form-horizontal denser dropzone"})do |f|
        _ret = []
        _ret << hidden_field_tag(:child_field,              config[:child_field])
        _ret << hidden_field_tag(:child_model_upload_field, config[:child_model_upload_field])
        _ret.join.html_safe
        # f.fields_for config[:child_field] do |ef|
        #   @object.send(config[:child_field]).each do |field|
        #     ef.input_for field
        #   end
        # end
        # f.submit
      end
      ret.join.html_safe
    end




    def rails_admin_multiple_file_upload_collection(files, opts= {})

      id = "ns_#{rand(100_000_000..999_999_999)}".freeze
      config = {
          update_url: multiple_file_upload_collection_path(model_name: @abstract_model),
          upload_field: opts[:upload_field]
      }
      content_tag(:div, rails_admin_multiple_file_upload_collection_builder(files, config), id: id, class: 'rails_admin_multiple_file_upload_collection'.freeze)
    end

    def rails_admin_multiple_file_upload_collection_builder(files, config)
      ret = []
      _ret = []
      _upload_field = (config[:upload_field].blank? ? "image" : config[:upload_field]).to_s
      files.each do |ef|
        if multiple_file_upload_paperclip?
          if ef.send(_upload_field + "_content_type") =~ /\Aimage/
            file_url = ef.send(_upload_field).url(multiple_file_upload_thumbnail_size)
            _ret << content_tag(:span, image_tag(file_url), class: "file_block_load_already".freeze)

          else
            if ef.respond_to?(:name)
              file_name = ef.name
            end
            file_name = ef.send(_upload_field + "_file_name") if file_name.blank?
            _ret << content_tag(:span, link_to(file_name), class: "file_block_load_already".freeze)
          end        

        elsif multiple_file_upload_shrine?
          attach = ef.send(_upload_field)
          if attach
            file_obj = ef.send(_upload_field)[multiple_file_upload_thumbnail_size.to_sym]
            if file_obj.metadata['mime_type'] =~ /\Aimage/
              file_url = file_obj.url
              _ret << content_tag(:span, image_tag(file_url), class: "file_block_load_already")

            else
              if ef.respond_to?(:name)
                file_name = ef.name
              end
              file_name = file_obj.metadata['filename'] if file_name.blank?
              _ret << content_tag(:span, link_to(file_name), class: "file_block_load_already")
            end
          end
        end
      end
      ret << content_tag(:div, _ret.join.html_safe)
      ret << content_tag(:div, "", class: "clearfix")
      @object = @abstract_model.model.new
      ret << rails_admin_form_for(@object, url: config[:update_url], html: {method: :post, multipart: true, class: "form-horizontal denser dropzone".freeze})do |f|
        _ret = []
        _ret << hidden_field_tag(:upload_field, _upload_field)
        _ret.join.html_safe
        # f.fields_for config[:child_field] do |ef|
        #   @object.send(config[:child_field]).each do |field|
        #     ef.input_for field
        #   end
        # end
        # f.submit
      end
      ret.join.html_safe
    end





    def multiple_file_upload_fields
      @conf.options[:fields]
    end

    def multiple_file_upload_paperclip?
      @conf.options[:upload_gem] == :paperclip
    end
    def multiple_file_upload_carrierwave?
      @conf.options[:upload_gem] == :carrierwave
    end
    def multiple_file_upload_shrine?
      @conf.options[:upload_gem] == :shrine
    end

    def multiple_file_upload_thumbnail_size
      @conf.options[:thumbnail_size]
    end

    def set_name_from_filename?
      @conf.options[:name_from_filename]
    end

  end
end
