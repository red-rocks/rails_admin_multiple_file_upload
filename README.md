# RailsAdminMultipleFileUpload

### Rails 5 Support

rails_admin + dropzone.js + mongoid(embedded)

## Installation

Add this line to your application's Gemfile:

    gem 'rails_admin_multiple_file_upload', '~> 0.5.0'

And then execute:

    $ bundle

## Usage with rails_admin

Add the sort_embedded action for each model or only for models you need

```ruby
    RailsAdmin.config do |config|
      config.actions do
        ......
        multiple_file_upload do
          visible do
            %w(Page).include? bindings[:abstract_model].model_name
          end
        end
      end
    end
```

In embedded model:

```ruby
    has_mongoid_attached_file :image, styles: {main: "1000x1000>"}
```

In rails_admin block for parent model:

```ruby
    multiple_file_upload(
        {
            fields: [:my_news_images],
            thumbnail_size: :main #default :thumb
        }
    )
```

In config/locales/* :


```yml
I18n:

    ru:
      rails_admin:
        multiple_file_upload:
          my_news:
            my_news_images: Фотогалерея

    # or with specified fields
    ru:
      rails_admin:
        multiple_file_upload:
          my_news:
            my_news_images:
              image: Фотогалерея
              image2: Фотогалерея вторая

```

## Copy and paste support

  After clicking on grey area around dropzone block You can use clipboard.
  You can paste screenshots (or any images if clipboard) and URL.
  System add it to dropzone as image (if it`s a really image)



## TODO

  * Documentation fixes
  * Carrierwave support
  * More configs
  * Style
  * Find and fix bugs. I am sure, bugs are here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Credits

Some ideas and code for this gem are taken from:
