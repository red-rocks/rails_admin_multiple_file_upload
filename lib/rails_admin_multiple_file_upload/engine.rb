require 'dropzonejs-rails'

module RailsAdminMultipleFileUpload
  class Engine < ::Rails::Engine

    initializer "RailsAdminMultipleFileUpload precompile hook", group: :all do |app|

      app.config.assets.precompile += %w(rails_admin/rails_admin_multiple_file_upload.js rails_admin/rails_admin_multiple_file_upload.css)
    end

    initializer 'Include RailsAdminMultipleFileUpload::Helper' do |app|
      ActionView::Base.send :include, RailsAdminMultipleFileUpload::Helper
    end
  end
end
