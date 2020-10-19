# Authy Devise Demo

This is a demo of using [Devise](https://github.com/plataformatec/devise) and [Authy](https://www.twilio.com/docs/authy) together with the [`authy-devise`](https://github.com/twilio/authy-devise) gem to add two factor authentication to a Rails application.
### Description of the issue being solved in this example.
You have content on the resource that can only be accessed after a single user identification by phone number. During registration, you confirm your phone number by receiving a code from an SMS. During subsequent authorizations, you no longer ask the user for a confirmation code. If necessary, you still have the option to re-identify the user with two-factor authentication.

## Running this demo

This demo was built with Ruby 2.5.1, but should run with any Ruby version that is supported by Rails/Devise.

To run this application download or clone it from GitHub, change into the directory and install the dependencies:

```bash
git clone https://github.com/rubygitflow/authy-devise-demo.git
cd authy-devise-demo
bundle install
```

Create and migrate the database:

```bash
rails db:create db:migrate
```

Get your Authy application API key from the [Twilio console](https://www.twilio.com/console/authy/applications) and set it in your environment variables:

Through CLI:

```bash
export AUTHY_API_KEY=YOUR_API_KEY
```

Or in .env:

```bash
cp .env{.example,}
```

Place API key in .env file generated from above command.

Run the Rails application:

```bash
rails server
```

Visit [localhost:3000](http://localhost:3000) and sign up as a new user.


## Building this demo yourself

1. Create a new Rails application

   ```bash
   rails new authy-devise-demo
   cd authy-devise-demo
   ```

2. Generate a controller

   ```bash
   rails generate controller welcome index guide
   ```

3. Add a root path and guide path to your `config/routes.rb`

   ```ruby
   Rails.application.routes.draw do
     get "guide", to: "welcome#guide"
     root :to => 'welcome#index'
   end
   ```

4. Update the root and guide views

   ```erb
   # app/views/welcome/index.html.erb
   <h1>Welcome to the sample app</h1>
   <p><%= link_to "Sign up", new_user_registration_path %></p>
   <p><%= link_to "Sign in", new_user_session_path %></p>
   ```

   ```erb
   # app/views/welcome/guide.html.erb
   <h1>Welcome to the sample app</h1>
   <p>You are signed in as <%= current_user.email %></p>
   ```

5. Add the `devise`, `devise-authy` and `phony_rails` gems to your `Gemfile` and install

   ```ruby
   gem 'devise', '~> 4.5'
   gem 'devise-authy', '~> 1.9'
   gem 'phony_rails'
   ```

   ```bash
   bundle install
   ```

6. Install devise

   ```bash
   rails generate devise:install
   ```

7. Add flash messages to the `app/views/layouts/application.html.erb` and update the default URL options in `config/environments/development.rb`

   ```html
   <p class="notice"><%= notice %></p>
   <p class="alert"><%= alert %></p>
   ```

   ```ruby
   config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
   ```

8. Generate a user model with Devise and migrate the database

   ```bash
   rails generate devise User
   rails db:migrate
   ```

8. Edit actions index and guide in `app/controllers/welcome_controller.rb`:

9. Install `authy-devise`

   ```bash
   rails generate devise_authy:install
   ```

10. Open `config/initializers/authy.rb` and add your Authy API key (generate one in the [Twilio Console](https://www.twilio.com/console/authy/applications))

    ```ruby
    Authy.api_key = "YOUR_API_KEY"
    Authy.api_uri = "https://api.authy.com/"
    ```

11. Add `authy-devise` to the `User` model, change the default value `:authy_enabled` to the `true` and run the resulting migration

    ```bash
    rails generate devise_authy User
    rails db:migrate
    ```
    
12. Add the `phone` field to the User table.

    ```bash
    rails generate migration AddPhoneToUsers
    ```
    Change description in up- and down- functions
    ```bash
    rails db:migrate
    ```
    
13. Сonfigure permitted parameter `phone` for `devise_controller` in `ApplicationController`.

14. Add `text_field` (form-group item) for the parameter `phone` in `views/devise/registrations`.

15. Implement the logic for managing two-factor user authentication.

    1. Insert redirects to `user_enable_authy_path` and `user_verify_authy_installation_path` in `welcome#index` according to the `user_signed_in?` status and the values of user parameters `authy_enabled`, `authy_id`, and `last_sign_in_with_authy`.
    
    ```ruby
    if user_signed_in? && current_user.authy_enabled && !current_user.authy_id && !current_user.last_sign_in_with_authy
		redirect_to user_enable_authy_path
	 elsif user_signed_in? && current_user.authy_enabled && current_user.authy_id && !current_user.last_sign_in_with_authy
		current_user.authy_turn_off 
		redirect_to user_verify_authy_installation_path
    end
    ```
    
    2. Set to disable 2FA in `ApplicationController` using the same set of parameters after oathy-confirmation.
    
     ```ruby
     before_action :oathy_confirmation
     private
     def oathy_confirmation
       if user_signed_in? && current_user.authy_enabled && current_user.last_sign_in_with_authy
         current_user.authy_turn_off
       end
     end
    ```

16. Run the server and visit http://localhost:3000/users/sign_up to create a user

    ```bash
    rails server
    ```

17. When signed in, visit http://localhost:3000/users/enable_authy to enable 2FA

18. Sign out and sign back in again and you will be required to enter your 2FA token
