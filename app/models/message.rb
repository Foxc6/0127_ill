class Message < ActiveRecord::Base
  after_save :send_message

  def send_message
    emails = self.to.split(',')
    merge_vars = []
    to_vars =[]

    emails.each do |email|
      merge_vars.push({"rcpt"=> email,"vars"=>[{"name"=> "main", "content"=> self.body}]})
      to_vars.push({"type"=>"to","name"=> 'Account Manager',"email"=> email})
    end

    mandrill = Mandrill::API.new ENV['MANDRILL_API_KEY']
    template_name = self.template
    template_content = [{"content"=>"example content", "name"=>"example name"}]
    message = {
      "preserve_recipients"=>false,
      "view_content_link"=>true,
      "from_email"=>ENV['NOTIFICATION_EMAIL'],
      "to"=> to_vars,
      "merge"=>true,
      "merge_language"=>"mailchimp",
      "global_merge_vars"=> [
          {
            "name"=>"merge1",
            "content"=>"merge1 content"
          }
        ],
      "merge_vars"=> merge_vars,
      "from_name"=>ENV['NOTIFICATION_EMAIL'],
      "text"=>"Example text content",
      "auto_text"=>nil,
      "track_opens"=>nil,
      "headers"=>{"Reply-To"=>ENV['NOTIFICATION_EMAIL']},
      "subject"=>self.subject}
    result = mandrill.messages.send_template template_name, template_content, message

    rescue Mandrill::Error => e
    # Mandrill errors are thrown as exceptions
    puts "A mandrill error occurred: #{e.class} - #{e.message}"
    # A mandrill error occurred: Mandrill::UnknownSubaccountError - No subaccount exists with the id 'customer-123'
    raise
  end
end
