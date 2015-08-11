# ActionModel

[![Build Status](https://travis-ci.org/maxkazar/actionmodel.png?branch=master)](https://travis-ci.org/maxkazar/actionmodel) [![Coverage Status](https://coveralls.io/repos/maxkazar/actionmodel/badge.png?branch=master)](https://coveralls.io/r/maxkazar/actionmodel?branch=master) [![Code Climate](https://codeclimate.com/repos/52f8ba86e30ba04a62003cdb/badges/84d12fb736e9a2d3331b/gpa.png)](https://codeclimate.com/repos/52f8ba86e30ba04a62003cdb/feed)

Clean up complex model logic using action.

## Installation

Add this line to your application's Gemfile:

    gem 'actionmodel'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install actionmodel

## Usage

If you have complex model class it can be split into clear model class and actions. For example, `Post` model

```ruby
class Post
  scope :search, ->(title) { where tile: title }
  scope :page, ->(page, size) { ... }

  def add_tags(tags)
    ...
  end

  def remove_tags(tags)
    ...
  end
end
```

can be split into pretty `Post` model and actions: `searchable`, `pageable`, `tagable`

```ruby
class Post
  include ActionModel::Concern

  acts_as_searchable :title, ignorecase: true
  acts_as :pageable, :tagable
end
```

Searchable action

```ruby
module Actions
  module Searchable
    extend ActiveSupport::Concern

    included do
      scope :search, ->(text) do
        actions[:searchable].fields.each do |field, options|
          # field is title
          # options is { ignorecase: true }
          ...
        end
      end
    end
  end
end
```

Pageable action

```ruby
module Actions
  module Pageable
    extend ActiveSupport::Concern

    included do
      scope :page, ->(page, size) { ... }
    end
  end
end
```

Tagable action

```ruby
module Actions
  module Tagable
    def add_tags(tags)
      ...
    end

    def remove_tags(tags)
      ...
    end
  end
end
```

Action is a ruby module and can be included into model class with DSL `acts_as` very easy

```ruby
acts_as :action1, :action2, ...
```  

or with fields and options

```ruby
acts_as_action1 :field1, :field2, option1: 1, options2: 2
```  

Inside action module you can get fields and options through actions method.

```ruby
module Actions
  module Action1
    # class method actions

    # get action fields
    actions(:action1).field.keys

    # iterate each field with options
    actions(:action1).field.each do |field, options|
      ...
    end

    def do_somthing
      # instance method actions do the same
    end
  end
end
```

ActionModel works with rails folder structure. Actions can be stored into some folders:

* local action folder path is `/app/model/post`
* global action folder path is `/app/models/actions` and `/lib/actions`

Local action has more priority then global. When actions with the same name are stored in both folder, then local action will be included.
It helps to override some action for specific model.

## Contributing

1. Fork it ( http://github.com/<my-github-username>/actionmodel/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
