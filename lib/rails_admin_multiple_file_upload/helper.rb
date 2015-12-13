module RailsAdminMultipleFileUpload
  module Helper
    def rails_admin_multiple_file_upload(files, opts= {})
      files = files.to_a.sort_by { |m| m.send(opts[:embedded_model_order_field] || "order").to_i }
      id = "ns_#{rand(100_000_000..999_999_999)}"
      config = {
          update_url: multiple_file_upload_path(model_name: @abstract_model),
          embedded_field: opts[:embedded_field],
          embedded_model_upload_field: opts[:embedded_model_upload_field] || "image",
          embedded_model: @abstract_model.model.new.send(opts[:embedded_field]).new.class.to_s
      }
      content_tag(:div, rails_admin_multiple_file_upload_builder(files, config), id: id, class: 'rails_admin_multiple_file_upload')
    end

    def rails_admin_multiple_file_upload_builder(files, config)
      ret = []
      _ret = []
      @object.send(config[:embedded_field]).sorted.each do |ef|
        if multiple_file_upload_paperclip?
          if ef.send(config[:embedded_model_upload_field] + "_content_type") =~ /\Aimage/
            file_url = ef.send(config[:embedded_model_upload_field]).url(multiple_file_upload_thumbnail_size)
            _ret << content_tag(:div, image_tag(file_url), class: "file_block_load_already")

          else
            if ef.respond_to(:name)
              file_name = ef.name
            else
              file_name = ef.send(config[:embedded_model_upload_field] + "_file_name")
            end
            _ret << content_tag(:div, link_to(ef.name), class: "file_block_load_already")
          end
        end
      end
      ret << content_tag(:div, _ret.join.html_safe)
      ret << content_tag(:div, "", class: "clearfix")
      ret << rails_admin_form_for(@object, url: config[:update_url], html: {method: :post, multipart: true, class: "form-horizontal denser dropzone"})do |f|
        _ret = []
        _ret << hidden_field_tag(:embedded_field,              config[:embedded_field])
        _ret << hidden_field_tag(:embedded_model_upload_field, config[:embedded_model_upload_field])
        _ret.join.html_safe
        # f.fields_for config[:embedded_field] do |ef|
        #   @object.send(config[:embedded_field]).each do |field|
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
