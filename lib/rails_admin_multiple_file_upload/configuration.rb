module RailsAdminMultipleFileUpload
  class Configuration
    def initialize(abstract_model)
      @abstract_model = abstract_model
    end

    def options
      @options ||= {
          fields: [{}],
          thumbnail_size: :thumb,
          upload_gem: :paperclip,
          name_from_filename: true,
          set_order_as_max_plus_one: true
      }.merge(config || {})
    end

    protected
    def config
      ::RailsAdmin::Config.model(@abstract_model.model).multiple_file_upload || {}
    end
  end
end

module RailsAdminMultipleFileUploadCollection
  class Configuration
    def initialize(abstract_model)
      @abstract_model = abstract_model
    end

    def options
      @options ||= {
          fields: [],
          thumbnail_size: :thumb,
          upload_gem: :paperclip,
          name_from_filename: true
      }.merge(config || {})
    end

    protected
    def config
      ::RailsAdmin::Config.model(@abstract_model.model).multiple_file_upload_collection || {}
    end
  end
end
