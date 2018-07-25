# Clickety
Short description and motivation.

## Usage
First, include the gem in your gemfile
```ruby
gem 'clickety', git: 'https://github.com/thoughtbot/paperclip.git'
```

For client side goals, specify a route
```ruby
mount Clickety::Engine, at: "/api/clickety"
```

Set Clickety API key in an environment variable:
```
CLICKETY_API_KEY=TEgsBMGyZCck1eTi9YvoukddgWdAwrHj
```

Set goals in an environment variable:
```
CLICKETY_GOALS=goal_name:JwbLyiUC5ohuSv6xonNE
```

To call a client-side goal
```
$('.element-class').click(function() {
	$.post("<%= url_for clickety_goal_path(goal: 'goal_name') %>");
});
```

On the server side, to account for an ad click
```ruby
  def track_ad
    if params[:ad_name].present?
      clickety_data = {
        ip_address: request.remote_ip,
        user_agent: request.user_agent,
        user: true,
        visit: true,
        replace: true,
        ad_name: params[:ad_name]
      }

      clickety_data[:campaign_id] = params[:campaign_id] if params[:campaign_id].present?
      clickety_data[:ad_group_name] = params[:ad_group_name] if params[:ad_group_name].present?
      clickety_data[:user_id] = user_id if user_id.present?
      clickety_data[:keywords] = params[:keywords] if params[:keywords].present?

      Clickety.track_user(clickety_data)
    end
  end
```

Conversion:

- Retrieve user ID, if one exists:
```
user_id = cookies.signed[:clickety_user_id]
```
- If user ID is present or user = true:
  - Call clickety method with appropriate parameters: 
  ```
  Clickety.track_user({user_id: ’1234’, conversion_amount: ’19.99’})
  ```

Completion

- Retrieve user ID, if one exists:
```
user_id = cookies.signed[:clickety_user_id]
```
- Check for completion_goal_id in cookie
  - If completion_goal_id is not in cookie, call clickety method with appropriate parameters:
  ```
  Clickety.track_user({user_id: ’1234’, completion: true, completion_goal_id: ’696969’})
  ```
  - Record completion_goal_id in cookie

Completion and conversion

- Retrieve user ID, if one exists: user_id = cookies.signed[:clickety_user_id]
- Check for completion_goal_id in cookie.
  - completion_goal_id is not present in cookie
    - Add completion and completion_goal_id to Clickety call
    - Save completion_goal_id to cookie
- Set appropriate parameters: 
```
function_args = {
	user_id: user_id, 
	completion: true, 
	completion_goal_id: ’696969’, 
	conversion: true, 
	conversion_amount: ’19.99’
}
```
- Send data to clickety: 
```
result = Clickety.track_user(function_args)
```

Update a user’s ID

```
Clickety.update_user({user_id: 'old_id', user_data: {user_id: 'new_id'}})
```

Update a user’s campaign ID

```
Clickety.update_user({user_id: 'user_id', campaign_id: 'campaign_id'})
```

Conversion:

- Retrieve user ID, if one exists: 
```
user_id = cookies.signed[:clickety_user_id]
```
- If user ID is present or user = true:
  - Call clickety method with appropriate parameters: 
  ```
  Clickety.track_user({user_id: ’1234’, conversion_amount: ’19.99’})
  ```

Completion

- Retrieve user ID, if one exists: user_id = cookies.signed[:clickety_user_id]
- Check for completion_goal_id in cookie
  - If completion_goal_id is not in cookie, call clickety method with appropriate parameters:
  ```
  Clickety.track_user({user_id: ’1234’, completion: true, completion_goal_id: ’696969’})
  ```
  - Record completion_goal_id in cookie

Completion and conversion

- Retrieve user ID, if one exists: user_id = cookies.signed[:clickety_user_id]
- Check for completion_goal_id in cookie.
  - completion_goal_id is not present in cookie
    - Add completion and completion_goal_id to Clickety call
    - Save completion_goal_id to cookie
- Set appropriate parameters: 
```
function_args = {
	user_id: user_id, 
	completion: true, 
	completion_goal_id: ’696969’, 
	conversion: true, 
	conversion_amount: ’19.99’
}
```
- Send data to clickety: 
```
result = Clickety.track_user(function_args)
```

Update a user’s ID
```
Clickety.update_user({user_id: 'old_id', user_data: {user_id: 'new_id'}})
```

Update a user’s campaign ID
```
Clickety.update_user({user_id: 'user_id', campaign_id: 'campaign_id'})
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'clickety'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install clickety
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
