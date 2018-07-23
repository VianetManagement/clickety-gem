# Clickety
Short description and motivation.

## Usage
First, include the gem in your gemfile
```ruby
gem 'clickety'
```

For client side goals, specify a route
```ruby
mount Clickety::Engine, at: "/api/clickety"
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
