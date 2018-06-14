RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    if !current_user
      redirect_to '/'
    else
      unless current_user.role_id == Role.where(name:'admin').first.id
        flash[:error] = "You must be an admin"
        redirect_to '/'
      end
    end
  end

  config.label_methods << :email
  config.current_user_method(&:current_user)

  #config.included_models = ['Admin', 'Activity', 'ActivityType', 'Admin', 'Contact', 'ContactType', 'Locale', 'SocialNetwork', 'SocialReach', 'Task', 'TaskType', 'User']
  #config.exclude_model << 'Activity'

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration


  config.model 'Activity' do
    list do
      scopes [:user_scope]
      field :user
      field :activity_type
      field :contact
      field :project
    end
    edit do
      field :note
      field :activity_type, :belongs_to_association do
        inline_add false
        inline_edit false
      end
      field :user do
        inline_add false
        inline_edit false
      end
      field :contact
      field :project
      field :file_attachments do
          inline_add true
          associated_collection_cache_all false
          associated_collection_scope do
            activity = bindings[:object]
            Proc.new { |scope|
              scope = scope.where(activity_id: activity.id) if activity.present?
            }
          end
        end
      end
      field :user do
        inverse_of :activities
      end
  end

  config.model 'ActivityType' do
    list do
      scopes [:user_scope]
      field :name
      field :icon_image
    end
    edit do
      field :name
      field :icon_image do
        help '385px x 350px JPEG or PNG FIle'
        delete_method :delete_icon_image
      end
    end
  end

  config.model 'Address' do
    visible false
    list do
      field :contact
    end
    edit do
      field :name
      field :address1
      field :address2
      field :city
      field :postal_code
      field :state
      field :country
    end
      field :contact do
        inverse_of :address
      end
  end

  config.model 'Contact' do
    object_label_method do
      :full_name
     end
    list do
      sort_by :last_name
      scopes [:user_scope]
      field :is_client
      field :is_team
      field :invisible
      field :company_name
      field :slug
      field :title
      field :website_url
      field :contact_skill
      field :first_name
      field :last_name
      field :email
      field :payee_name
      field :contact_type
      field :directional_motivation
      field :about
      field :locale
      field :agenda
      field :wants_general
      field :wants_specifically
      field :values
      field :time_zone
      field :self_expression_type
      field :score
      field :connections
    end
    edit do
      field :is_client
      field :is_team
      field :invisible
      field :company_name
      field :slug
      field :title
      field :website_url
      field :contact_skill
      field :first_name
      field :last_name
      field :email
      field :payee_name
      field :agenda
      field :wants_general
      field :wants_specifically
      field :values
      field :time_zone
      field :self_expression_type
      field :score
      field :connections do
        associated_collection_cache_all true  # REQUIRED if you want to SORT the list as below
        associated_collection_scope do
          # bindings[:object] & bindings[:controller] are available, but not in scope's block!
          contact = bindings[:object]
          Proc.new { |scope|
            # scoping all SocialReaches currently, let's limit them to the contact's league
            # Be sure to limit if there are a lot of SocialReaches and order them by position
            scope = scope.people_not_team_scope
          }
        end
      end
      field :contact_type do
        inline_add false
        inline_edit false
      end
      field :directional_motivation
      field :phone_numbers do
        inline_add true
        associated_collection_cache_all false  # REQUIRED if you want to SORT the list as below
        associated_collection_scope do
          # bindings[:object] & bindings[:controller] are available, but not in scope's block!
          contact = bindings[:object]
          Proc.new { |scope|
            # scoping all SocialReaches currently, let's limit them to the contact's league
            # Be sure to limit if there are a lot of SocialReaches and order them by position
            scope = scope.where(contact_id: contact.id) if contact.present?
          }
        end
      end
      field :emails do
        inline_add true
        associated_collection_cache_all false
        associated_collection_scope do
          contact = bindings[:object]
          Proc.new { |scope|
            scope = scope.where(contact_id: contact.id) if contact.present?
          }
        end
      end
      field :addresses do
        inline_add true
        associated_collection_cache_all false  # REQUIRED if you want to SORT the list as below
        associated_collection_scope do
          # bindings[:object] & bindings[:controller] are available, but not in scope's block!
          contact = bindings[:object]
          Proc.new { |scope|
            # scoping all SocialReaches currently, let's limit them to the contact's league
            # Be sure to limit if there are a lot of SocialReaches and order them by position
            scope = scope.where(contact_id: contact.id) if contact.present?
          }
        end
      end
      field :about
      field :profile_image do
        help '385px x 350px JPEG or PNG FIle'
        delete_method :delete_profile_image
      end
      field :social_reaches do
        associated_collection_cache_all false  # REQUIRED if you want to SORT the list as below
        associated_collection_scope do
          # bindings[:object] & bindings[:controller] are available, but not in scope's block!
          contact = bindings[:object]
          Proc.new { |scope|
            # scoping all SocialReaches currently, let's limit them to the contact's league
            # Be sure to limit if there are a lot of SocialReaches and order them by position
            scope = scope.where(contact_id: contact.id) if contact.present?
          }
        end
      end
    end
  end

  config.model 'ContactType' do
    list do
      field :name
    end
    edit do
      field :name
    end
  end

  config.model 'Country' do
    list do
      sort_by :name
      field :iso_name
      field :iso
      field :iso3
      field :name
      field :numcode
      field :states_required
    end
  end

config.model 'Email' do
    visible false
    list do
      field :name
      field :email
      field :contact
    end
    edit do
      field :name
      field :email
      field :contact do
        inverse_of :email
        inline_add false
        inline_edit false
      end
    end
  end

  config.model 'Locale' do
    visible do
      bindings[:controller].current_user.role == 'admin'
    end
     list do
      field :name
      field :code
      field :active
      field :updated_at
    end
    edit do
      field :code
      field :fb_locale
      field :fb_page
      field :redirect_link
      field :logo_link
      field :active
      field :isAPAC do
        label "isAPAC"
      end
      field :tracking_code
      field :tracking_domain
      field :twitter_link
      field :name
      field :facebook_url
      field :twitter_url
      field :youtube_url
      field :pinterest_url
      field :instagram_url
      field :users do
        inline_add false
      end
    end
  end

  config.model 'PaymentSchedule' do
    list do
      field :project
      field :invoice_number
      field :description
      field :payment_term
      field :invoice_date
      field :total
      field :duration
      field :payment_status
      field :contacts
    end
    edit do
      field :project
      field :invoice_number
      field :description
      field :payment_term
      field :invoice_date
      field :total
      field :duration
      field :payment_status
      field :contacts
    end
  end

  config.model 'PaymentTerm' do
    list do
      field :name
      field :payment_schedules
    end
    edit do
      field :name
      field :payment_schedules
    end
  end

  config.model 'PhoneNumber' do
    visible false
    list do
      field :number
      field :contact
    end
    edit do
      field :name
      field :number
    end
      field :contact do
        inverse_of :phone_number
        inline_add false
        inline_edit false
      end
  end

  config.model 'Project' do
    list do
      field :thumbnail_image
      field :name
      field :notes
      field :project_state
      field :project_type
      field :tags
      field :url
      field :project_number
      field :sale_contacts
      field :start_date
      field :end_date
      field :sow_file
      field :contacts
      field :referral_contacts
      field :issues
      field :primary_contact
      field :team_contacts
      field :score
      field :project_images
    end
    edit do
      field :thumbnail_image
      field :name
      field :project_state
      field :project_type
      field :tags
      field :url
      field :primary_contact
      field :sale_contacts
      field :start_date
      field :end_date
      field :sow_file
      field :contacts
      field :referral_contacts
      field :notes
      field :issues
      field :score
      field :project_images
      field :payment_schedules
    end
  end

  config.model 'PrimaryContact' do
    list do
      field :contact
      field :project
    end
    edit do
      field :contact
      field :project
    end
  end

  config.model 'ReferralContact' do
    object_label_method do
      :full_name
     end
    list do
      field :contact
      field :project
    end
    edit do
      field :contact
      field :project
    end
  end

  config.model 'SaleContact' do
    object_label_method do
      :full_name
     end
    list do
      field :contact
      field :project
    end
    edit do
      field :contact
      field :project
    end
  end

  config.model 'SocialNetwork' do
    list do
      field :logo_image
      field :name
      field :url
    end
    edit do
      field :logo_image do
        help '385px x 350px JPEG or PNG FIle'
        delete_method :delete_logo_image
      end
      field :name
      field :url
      field :api_key
      field :api_secret
    end
  end

  config.model 'SocialReach' do
    visible false
    list do
      field :contact
      field :total_reach
      field :social_network
      field :username
    end
     edit do
      field :total_reach
      field :username
      field :social_network, :belongs_to_association
    end
  end

  config.model 'State' do
    list do
      sort_by :name
      field :name
      field :abbr
      field :country
    end
    edit do
      field :name
      field :abbr
      field :country
    end
  end

  config.model 'Task' do
    list do
      scopes [:user_scope]
      field :user
      field :contact
      field :project
      field :task_type
      field :description
      field :started_at
      field :completed_at
    end
    edit do
      field :description
      field :user do
        inline_add false
        inline_edit false
      end
      field :contact do
        inline_add false
        inline_edit false
      end
      field :project do
        inline_add false
        inline_edit false
      end
      field :task_type do
        inline_add false
        inline_edit false
      end
      field :started_at
      field :completed_at
    end
     field :user do
        inverse_of :tasks
      end
  end

  config.model 'TaskType' do
    list do
      scopes [:user_scope]
      field :name
      field :icon_image
    end
    edit do
      field :name
      field :icon_image do
        help '385px x 350px JPEG or PNG FIle'
        delete_method :delete_icon_image
      end
    end
  end

  config.model 'User' do
     list do
      field :first_name
      field :last_name
      field :email
      field :locale
      field :role
    end
    edit do
      field :first_name
      field :last_name
      field :email
      field :password
      field :password_confirmation
      field :locale do
        required true
        inline_add false
        inline_edit false
      end
      field :role do
        required true
        inline_add false
        inline_edit false
      end
      field :avatar do
        help '385px x 350px JPEG or PNG FIle'
        delete_method :delete_avatar
      end
      field :activities do
        associated_collection_cache_all false  # REQUIRED if you want to SORT the list as below
        associated_collection_scope do
          # bindings[:object] & bindings[:controller] are available, but not in scope's block!
          user = bindings[:object]
          Proc.new { |scope|
            # scoping all SocialReaches currently, let's limit them to the contact's league
            # Be sure to limit if there are a lot of SocialReaches and order them by position
            scope = scope.where(user_id: user.id) if user.present?
          }
        end
      end
      field :tasks do
        associated_collection_cache_all false  # REQUIRED if you want to SORT the list as below
        associated_collection_scope do
          # bindings[:object] & bindings[:controller] are available, but not in scope's block!
          user = bindings[:object]
          Proc.new { |scope|
            # scoping all SocialReaches currently, let's limit them to the contact's league
            # Be sure to limit if there are a lot of SocialReaches and order them by position
            scope = scope.where(user_id: user.id) if user.present?
          }
        end
      end
    end
  end

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
