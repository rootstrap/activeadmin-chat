# ActiveAdmin::Chat

[![Build Status](https://travis-ci.org/rootstrap/activeadmin-chat.svg?branch=master)](https://travis-ci.org/rootstrap/activeadmin-chat)
[![Maintainability](https://api.codeclimate.com/v1/badges/7a8d43aef79218e8f772/maintainability)](https://codeclimate.com/github/rootstrap/activeadmin-chat/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/7a8d43aef79218e8f772/test_coverage)](https://codeclimate.com/github/rootstrap/activeadmin-chat/test_coverage)

Get a chat for your ActiveAdmin app out of the box.

![](images/activeadmin-chat.gif)

## Prerequisites
- It assumes you have models for your admins and users in place.
- It assumes that your users have an `email` attribute.
- For production you need to configure ActionCable by providing it with a Redis or Postgres connection in `config/cable.yml`.

## Installation
Add to Gemfile:
```ruby
gem 'activeadmin-chat'
```

And then run:
```bash
$ bundle install
```

Install `ActiveAdmin::Chat`:
```bash
$ rails generate active_admin:chat:install
```
It will generate:
  - `Conversation` and `Message` models and migrations.
  - Initializer that configures the model names for conversation, message, admin user and user.
  - Default chat page.

You can customize the namings of the models when installing `ActiveAdmin::Chat` with the usage of the `--conversation_model_name`, `--message_model_name`, `--admin_user_model_name` and `--user_model_name` flags.

For example:
```bash
$ rails generate active_admin:chat:install --conversation_model_name=chat
```

Once you've successfully installed `ActiveAdmin::Chat`, run:
```bash
$ rails db:migrate
```

Add including of CSS to `app/assets/stylesheets/active_admin.css.scss`:
```css
@import 'active_admin/chat';
```

And including of JS to `app/assets/javascripts/active_admin.js`:
```js
#= require active_admin/chat
```

### Example diagram
![](images/activeadmin-chat_diagram.png?raw=true "Chat diagram")

## Usage
All you need to get the chat up and running is to authenticate your users in the websocket connection in `app/channels/application_cable/connection.rb`. It's important that you identify them as the `current_user` here, this will be used by the gem internally.

For example with the `devise` gem:
```ruby
module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      verified_user = env['warden'].user

      reject_unauthorized_connection unless verified_user

      verified_user
    end
  end
end
```

## Customization
You can change the chat page name and namespace the same way you do with other ActiveAdmin pages.

If you'd like to change the chat styling you can override the following classes:
 - `.active-admin-chat__title`: Title above the conversations list
 - `.active-admin-chat__conversations-list-container`, `.active-admin-chat__conversations-list` and `.active-admin-chat__conversation-item`: List of conversations
 - `.active-admin-chat__conversation-history-container` and `.active-admin-chat__conversation-history`: Conversation panel
 - `.active-admin-chat__message-container`: Message in the conversation panel
 - `.active-admin-chat__send-message-container`: Send message button

If you'd like to change the whole HTML you can do it in the chat page by specifying its content:
```ruby
ActiveAdmin.register_chat 'Chat' do
  content do
    # your code
  end
end
```

If you'd like to change the controller actions you can do it in the chat page by specifying its controller:
```ruby
ActiveAdmin.register_chat 'Chat' do
  controller do
    def show
      # your code
    end
  end
end
```


If you'd like to add a button in the user's index in the admin dashboard to start a chat with a user:
```ruby
ActiveAdmin.register_chat User do
  index do
    # your code
    actions do |user|
      send_message_link user
    end
  end
end
```

## Contributing
Bug reports (please use Issues) and pull requests are welcome on GitHub at https://github.com/rootstrap/activeadmin-chat. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Credits
**Active Admin Chat** is maintained by [Rootstrap](http://www.rootstrap.com) with the help of our [contributors](https://github.com/rootstrap/activeadmin-chat/contributors).

[<img src="https://s3-us-west-1.amazonaws.com/rootstrap.com/img/rs.png" width="100"/>](http://www.rootstrap.com)
