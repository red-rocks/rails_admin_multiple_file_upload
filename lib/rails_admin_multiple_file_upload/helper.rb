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
      id = "ns_#{rand(100_000_000..999_999_999)}"
      config = {
          update_url: multiple_file_upload_path(model_name: @abstract_model),
          child_field: opts[:child_field],
          child_model_upload_field: opts[:child_model_upload_field] || "image",
          child_model: @abstract_model.model.new.send(opts[:child_field]).new.class.name
      }
      content_tag(:div, rails_admin_multiple_file_upload_builder(files, config), id: id, class: 'rails_admin_multiple_file_upload')
    end

    def rails_admin_multiple_file_upload_builder(files, config)
      ret = []
      _ret = []
      @object.send(config[:child_field]).sorted.each do |ef|
        if multiple_file_upload_paperclip?
          if ef.send(config[:child_model_upload_field] + "_content_type") =~ /\Aimage/
            file_url = ef.send(config[:child_model_upload_field]).url(multiple_file_upload_thumbnail_size)
            _ret << content_tag(:span, image_tag(file_url), class: "file_block_load_already")

          else
            if ef.respond_to?(:name)
              file_name = ef.name
            else
              file_name = ef.send(config[:child_model_upload_field] + "_file_name")
            end
            _ret << content_tag(:span, link_to(ef.name), class: "file_block_load_already")
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



    def multiple_file_upload_fields
      @conf.options[:fields]
    end

    def multiple_file_upload_paperclip?
      @conf.options[:upload_gem] == :paperclip
    end
    def multiple_file_upload_carrierwave?
      @conf.options[:upload_gem] == :carrierwave
    end
    def multiple_file_upload_thumbnail_size
      @conf.options[:thumbnail_size]
    end

  end
end
