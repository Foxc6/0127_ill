# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161122193210) do

  create_table "activities", force: true do |t|
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "activity_type_id"
    t.integer  "user_id"
    t.integer  "contact_id"
    t.integer  "locale_id"
    t.integer  "activity_object_id"
    t.integer  "project_id"
  end

  add_index "activities", ["activity_object_id"], name: "index_activities_on_activity_object_id", using: :btree
  add_index "activities", ["activity_type_id"], name: "index_activities_on_activity_type_id", using: :btree
  add_index "activities", ["contact_id"], name: "index_activities_on_contact_id", using: :btree
  add_index "activities", ["project_id"], name: "index_activities_on_project_id", using: :btree
  add_index "activities", ["user_id"], name: "index_activities_on_user_id", using: :btree

  create_table "activity_objects", force: true do |t|
    t.string   "name"
    t.integer  "locale_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activity_objects", ["locale_id"], name: "index_activity_objects_on_locale_id", using: :btree

  create_table "activity_types", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "icon_image_file_name"
    t.string   "icon_image_content_type"
    t.integer  "icon_image_file_size"
    t.datetime "icon_image_updated_at"
    t.integer  "activity_id"
    t.integer  "locale_id"
  end

  add_index "activity_types", ["activity_id"], name: "index_activity_types_on_activity_id", using: :btree

  create_table "addresses", force: true do |t|
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "postal_code"
    t.integer  "state_id"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "contact_id"
    t.string   "name"
  end

  add_index "addresses", ["contact_id"], name: "index_addresses_on_contact_id", using: :btree

  create_table "admins", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "locale_id"
    t.boolean  "super_user"
    t.integer  "activity_id"
  end

  add_index "admins", ["activity_id"], name: "index_admins_on_activity_id", using: :btree
  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["locale_id"], name: "index_admins_on_locale_id", using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "api_keys", force: true do |t|
    t.string   "access_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "client_contacts", force: true do |t|
    t.string  "name"
    t.integer "contact_id"
    t.integer "client_id"
  end

  add_index "client_contacts", ["client_id"], name: "index_client_contacts_on_client_id", using: :btree
  add_index "client_contacts", ["contact_id"], name: "index_client_contacts_on_contact_id", using: :btree

  create_table "contact_skills", force: true do |t|
    t.string   "name"
    t.integer  "contact_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contact_skills", ["contact_id"], name: "index_contact_skills_on_contact_id", using: :btree

  create_table "contact_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.text     "about"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "profile_image_file_name"
    t.string   "profile_image_content_type"
    t.integer  "profile_image_file_size"
    t.datetime "profile_image_updated_at"
    t.integer  "contact_type_id"
    t.string   "title"
    t.integer  "locale_id"
    t.text     "agenda"
    t.text     "wants_general"
    t.text     "wants_specifically"
    t.text     "values"
    t.integer  "time_zone_id"
    t.integer  "directional_motivation_id"
    t.integer  "self_expression_type_id"
    t.boolean  "is_client",                                                      default: false
    t.string   "company_name"
    t.string   "slug"
    t.string   "website_url"
    t.boolean  "invisible",                                                      default: false
    t.boolean  "is_team",                                                        default: false
    t.integer  "company_contact_id"
    t.string   "contact_skill"
    t.string   "payee_name"
    t.float    "score",                      limit: 24,                          default: 0.0
    t.string   "tag_name"
    t.decimal  "project_value",                         precision: 10, scale: 2, default: 0.0
    t.decimal  "total_value",                           precision: 10, scale: 2, default: 0.0
    t.decimal  "referral_value",                        precision: 10, scale: 2, default: 0.0
  end

  add_index "contacts", ["contact_type_id"], name: "index_contacts_on_contact_type_id", using: :btree
  add_index "contacts", ["directional_motivation_id"], name: "index_contacts_on_directional_motivation_id", using: :btree
  add_index "contacts", ["self_expression_type_id"], name: "index_contacts_on_self_expression_type_id", using: :btree
  add_index "contacts", ["time_zone_id"], name: "index_contacts_on_time_zone_id", using: :btree

  create_table "countries", force: true do |t|
    t.string   "iso_name"
    t.string   "iso"
    t.string   "iso3"
    t.string   "name"
    t.integer  "numcode"
    t.boolean  "states_required", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "directional_motivations", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "emails", force: true do |t|
    t.string   "email"
    t.integer  "contact_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  add_index "emails", ["contact_id"], name: "index_emails_on_contact_id", using: :btree

  create_table "estimate_line_items", force: true do |t|
    t.text     "description"
    t.decimal  "price",       precision: 10, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "estimate_id"
    t.integer  "position"
    t.integer  "parent_id"
  end

  add_index "estimate_line_items", ["estimate_id"], name: "index_estimate_line_items_on_estimate_id", using: :btree

  create_table "estimates", force: true do |t|
    t.integer  "company_id"
    t.integer  "client_id"
    t.datetime "date"
    t.string   "number"
    t.decimal  "total",             precision: 14, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "client_address_id"
    t.integer  "project_id"
  end

  add_index "estimates", ["project_id"], name: "index_estimates_on_project_id", using: :btree

  create_table "file_attachments", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "activity_id"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
  end

  add_index "file_attachments", ["activity_id"], name: "index_file_attachments_on_activity_id", using: :btree

  create_table "issues", force: true do |t|
    t.string   "name"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id"
  end

  add_index "issues", ["project_id"], name: "index_issues_on_project_id", using: :btree

  create_table "links", force: true do |t|
    t.integer  "source"
    t.integer  "target"
    t.string   "link_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locales", force: true do |t|
    t.string   "code"
    t.string   "fb_locale"
    t.string   "fb_page"
    t.string   "fb_page_id"
    t.string   "redirect_link"
    t.string   "logo_link"
    t.boolean  "active",          default: false
    t.boolean  "isAPAC",          default: false
    t.string   "tracking_code"
    t.string   "tracking_domain"
    t.string   "twitter_link"
    t.string   "name"
    t.string   "facebook_url"
    t.string   "twitter_url"
    t.string   "youtube_url"
    t.string   "pinterest_url"
    t.string   "instagram_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "start_date"
    t.datetime "end_date"
  end

  create_table "messages", force: true do |t|
    t.string   "subject"
    t.string   "to"
    t.text     "body"
    t.string   "message_type"
    t.string   "template"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "options", force: true do |t|
    t.string   "key"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payment_line_items", force: true do |t|
    t.integer  "payment_schedule_id"
    t.decimal  "amount",              precision: 10, scale: 2, default: 0.0
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "recieved_date"
  end

  add_index "payment_line_items", ["payment_schedule_id"], name: "index_payment_line_items_on_payment_schedule_id", using: :btree

  create_table "payment_schedules", force: true do |t|
    t.integer  "project_id"
    t.string   "description"
    t.integer  "payment_term_id"
    t.datetime "invoice_date"
    t.decimal  "total",                        precision: 10, scale: 2, default: 0.0
    t.integer  "duration"
    t.integer  "payment_status_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "contact_id"
    t.integer  "invoice_number"
    t.datetime "received_date"
    t.float    "progress",          limit: 24
    t.integer  "sortorder"
    t.integer  "parent"
  end

  add_index "payment_schedules", ["contact_id"], name: "index_payment_schedules_on_contact_id", using: :btree
  add_index "payment_schedules", ["payment_status_id"], name: "index_payment_schedules_on_payment_status_id", using: :btree
  add_index "payment_schedules", ["payment_term_id"], name: "index_payment_schedules_on_payment_term_id", using: :btree
  add_index "payment_schedules", ["project_id"], name: "index_payment_schedules_on_project_id", using: :btree

  create_table "payment_statuses", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payment_terms", force: true do |t|
    t.string   "name"
    t.integer  "payment_schedule_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "payment_terms", ["payment_schedule_id"], name: "index_payment_terms_on_payment_schedule_id", using: :btree

  create_table "phone_numbers", force: true do |t|
    t.string   "number"
    t.integer  "contact_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  add_index "phone_numbers", ["contact_id"], name: "index_phone_numbers_on_contact_id", using: :btree

  create_table "preferences", force: true do |t|
    t.string   "name"
    t.string   "company"
    t.string   "url"
    t.text     "meta_description"
    t.text     "meta_keywords"
    t.string   "seo_title"
    t.string   "mail_from_address"
    t.boolean  "default",              default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.integer  "default_country_code"
    t.boolean  "is_domestic",          default: true
    t.boolean  "is_setup",             default: false
  end

  create_table "primary_contacts", force: true do |t|
    t.integer  "contact_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "primary_contacts", ["contact_id"], name: "index_primary_contacts_on_contact_id", using: :btree
  add_index "primary_contacts", ["project_id"], name: "index_primary_contacts_on_project_id", using: :btree

  create_table "project_contacts", force: true do |t|
    t.string   "name"
    t.integer  "contact_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "project_contacts", ["contact_id"], name: "index_project_contacts_on_contact_id", using: :btree
  add_index "project_contacts", ["project_id"], name: "index_project_contacts_on_project_id", using: :btree

  create_table "project_images", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "project_id"
  end

  add_index "project_images", ["project_id"], name: "index_project_images_on_project_id", using: :btree

  create_table "project_states", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_team_members", force: true do |t|
    t.string   "name"
    t.integer  "contact_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "project_team_members", ["contact_id"], name: "index_project_team_members_on_contact_id", using: :btree
  add_index "project_team_members", ["project_id"], name: "index_project_team_members_on_project_id", using: :btree

  create_table "project_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", force: true do |t|
    t.string   "name"
    t.integer  "project_state_id"
    t.integer  "client_contact_id"
    t.integer  "project_type_id"
    t.string   "tags"
    t.string   "url"
    t.string   "project_number"
    t.integer  "referral_contact_id"
    t.integer  "sale_contact_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "sow_file_file_name"
    t.string   "sow_file_content_type"
    t.integer  "sow_file_file_size"
    t.datetime "sow_file_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "notes"
    t.integer  "primary_contact_id"
    t.integer  "agency_client_contact_id"
    t.float    "score",                        limit: 24,                          default: 0.0
    t.boolean  "team_contact_id"
    t.string   "case_number"
    t.string   "thumbnail_image_file_name"
    t.string   "thumbnail_image_content_type"
    t.integer  "thumbnail_image_file_size"
    t.datetime "thumbnail_image_updated_at"
    t.integer  "duration"
    t.float    "progress",                     limit: 24
    t.integer  "sortorder"
    t.integer  "parent"
    t.integer  "sale_case_status_id"
    t.datetime "status_updated_at"
    t.boolean  "was_sale_case"
    t.decimal  "total",                                   precision: 10, scale: 2, default: 0.0
    t.decimal  "estimated_total",                         precision: 10, scale: 2, default: 0.0
  end

  add_index "projects", ["client_contact_id"], name: "index_projects_on_client_contact_id", using: :btree
  add_index "projects", ["project_state_id"], name: "index_projects_on_project_state_id", using: :btree
  add_index "projects", ["sale_case_status_id"], name: "index_projects_on_sale_case_status_id", using: :btree

  create_table "recievers", force: true do |t|
    t.integer  "contact_id"
    t.integer  "payment_schedule_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "recievers", ["contact_id"], name: "index_recievers_on_contact_id", using: :btree
  add_index "recievers", ["payment_schedule_id"], name: "index_recievers_on_payment_schedule_id", using: :btree

  create_table "referral_contacts", force: true do |t|
    t.integer  "contact_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "referral_contacts", ["contact_id"], name: "index_referral_contacts_on_contact_id", using: :btree
  add_index "referral_contacts", ["project_id"], name: "index_referral_contacts_on_project_id", using: :btree

  create_table "roles", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sale_case_statuses", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sale_contacts", force: true do |t|
    t.integer  "contact_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sale_contacts", ["contact_id"], name: "index_sale_contacts_on_contact_id", using: :btree
  add_index "sale_contacts", ["project_id"], name: "index_sale_contacts_on_project_id", using: :btree

  create_table "self_expression_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "services", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "social_networks", force: true do |t|
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "api_key"
    t.string   "api_secret"
    t.string   "logo_image_file_name"
    t.string   "logo_image_content_type"
    t.integer  "logo_image_file_size"
    t.datetime "logo_image_updated_at"
  end

  create_table "social_reaches", force: true do |t|
    t.integer  "total_reach"
    t.string   "username"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "social_network_id"
    t.integer  "contact_id"
  end

  add_index "social_reaches", ["contact_id"], name: "index_social_reaches_on_contact_id", using: :btree
  add_index "social_reaches", ["social_network_id"], name: "index_social_reaches_on_social_network_id", using: :btree

  create_table "states", force: true do |t|
    t.string   "name"
    t.string   "abbr"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "states", ["country_id"], name: "index_states_on_country_id", using: :btree

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: true do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "task_types", force: true do |t|
    t.string   "name"
    t.string   "icon_image_file_name"
    t.string   "icon_image_content_type"
    t.integer  "icon_image_file_size"
    t.datetime "icon_image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "locale_id"
  end

  create_table "tasks", force: true do |t|
    t.integer  "user_id"
    t.integer  "contact_id"
    t.integer  "task_type_id"
    t.datetime "completed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.integer  "locale_id"
    t.datetime "started_at"
    t.integer  "project_id"
  end

  add_index "tasks", ["contact_id"], name: "index_tasks_on_contact_id", using: :btree
  add_index "tasks", ["project_id"], name: "index_tasks_on_project_id", using: :btree
  add_index "tasks", ["task_type_id"], name: "index_tasks_on_task_type_id", using: :btree
  add_index "tasks", ["user_id"], name: "index_tasks_on_user_id", using: :btree

  create_table "time_zones", force: true do |t|
    t.decimal  "offset",     precision: 10, scale: 0
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "abbr"
  end

  create_table "urls", force: true do |t|
    t.string   "name"
    t.string   "url"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "urls", ["project_id"], name: "index_urls_on_project_id", using: :btree

  create_table "user_connections", force: true do |t|
    t.string   "name"
    t.integer  "connector_id"
    t.integer  "connectie_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "username"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "locale_id"
    t.integer  "role_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["locale_id"], name: "index_users_on_locale_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["role_id"], name: "index_users_on_role_id", using: :btree

  create_table "website_urls", force: true do |t|
    t.string   "url"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "contact_id"
  end

  add_index "website_urls", ["contact_id"], name: "index_website_urls_on_contact_id", using: :btree

end
