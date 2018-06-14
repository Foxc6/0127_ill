require 'mandrill'
include Rails.application.routes.url_helpers
namespace :sale_cases do

  desc 'update sale_case_status on a sales project after 15 days of inactivity'

  task :update_status => :environment do
    sale_case = Project.sales_case_scope()

    hot_id = SaleCaseStatus.find_by(name: "Hot").id
    warm_id = SaleCaseStatus.find_by(name: "Warm").id
    cold_id = SaleCaseStatus.find_by(name: "Cold").id
    killed_id = SaleCaseStatus.find_by(name: "Killed").id

    hot_cases = sale_case.where('status_updated_at <= :fifteen_days_ago', :fifteen_days_ago  => Time.now - 15.days).hot_sale_scope()
    warm_cases = sale_case.where('status_updated_at <= :thirty_days_ago', :thirty_days_ago  => Time.now - 30.days).warm_sale_scope()
    cold_cases = sale_case.where('status_updated_at <= :forty_five_days_ago', :forty_five_days_ago  => Time.now - 45.days).cold_sale_scope()
    updated_cases = []

    hot_cases.each do |h|
      h.update_attribute :sale_case_status_id, warm_id
      updated_cases.push(h)
    end
    warm_cases.each do |w|
      w.update_attribute :sale_case_status_id, cold_id
      updated_cases.push(w)
    end
    cold_cases.each do |c|
      c.update_attribute :sale_case_status_id, killed_id
      updated_cases.push(c)
    end


    def send_update_status_email(updated_cases)
      emails = Option.find_by(key: 'sales_manager_email').value
      content = "<p>Hello, The following " + ActionController::Base.helpers.pluralize(updated_cases.length, ' Sales Case') + " have been updated:</p>"

      updated_cases.each do |ep|
        @project = ep
        site_url = Preference.first.url
        proj_title = "#{@project.case_number}"
        content = content + '<div class="project_title">'
        content = content + '<br><h4>Sales Case: ' + @project.case_number + ', has been updated to: ' + @project.sale_case_status.name + '</h4>'
        content = content + '<a href="' + site_url + sale_path(@project) + '">' + @project.name.to_s + '</a>'
        content = content + '</div>'
      end

      m = Message.new
      m.subject = "Sales Case Status Update"
      m.to = emails
      m.body = content
      m.message_type = 'Sales Case Status Update'
      m.template = 'sales-case-status-update'
      m.save!
    end

    if updated_cases.any?
      send_update_status_email(updated_cases)
    end

  end
  # update_status
end
