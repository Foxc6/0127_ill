configatron.application.name = 'Positron'

configatron.email_addresses.do_not_reply = 'info@illcreative.com'

configatron.illcreative_url = 'http://illcreative.com'

configatron.date_formats.short = '12/31/99'
configatron.date_formats.long = 'Sunday, May 1, 2000'
configatron.date_formats.on_at = 'Sunday, May 1, 2000 at 2:30 PM'

configatron.alphanumeric_regex = /^[a-zA-Z0-9.-\/]+$/
configatron.email_regex = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/

configatron.api.holiday_game.v1.accept_header = 'application/vnd.v1+json'

dragonfly_config = YAML.load_file(Rails.root.join('config/dragonfly.yml'))[Rails.env].symbolize_keys!
configatron.cdn_base = "https://#{dragonfly_config[:url_host]}"

configatron.featured_apps.types = %w(app ebook)
configatron.featured_apps.supported_devices = %w(iPhone iPod)
