require 'mandrill'
include ActionView::Helpers::NumberHelper
include Rails.application.routes.url_helpers
namespace :invoice do

  desc 'send account manger daily email of invoices due'
  task :invoice_email => :environment do
    projects = Project.active_scope()
    email_projects_list = []
    projects.each do |project|
      project.payment_schedules.each do |ps|
        if ps.invoice_date.present?
          if ps.invoice_date.to_date == Date.tomorrow
            if ps.payment_status.name == 'Pending'
              invoice_object = {}
              invoice_object["project"] = project
              invoice_object["invoice"] = ps
              email_projects_list.push(invoice_object)
              puts "#{project.project_number}, has an Invoice Due Tomorrow!!"
            end
            # payment_status
          end
          # invoice date
        end
        # invoice date present
      end
      # payment schedule loop
    end
    # projects_loop



    def send_invoice_due_email(email_projects_list)
      emails = Option.find_by(key: 'account_manager_email').value
      content = ""
      content = "<p>Hello, Please send the following " + ActionController::Base.helpers.pluralize(email_projects_list.length, 'invoice') + "</p>"

      email_projects_list.each do |ep|
        @project = ep["project"]
        @invoice = ep["invoice"]

        if @project.client.present?
          content = content + '<div>' + @project.client.company_name + '</div>'
          if @project.client.addresses.any?
            content = content + '<br>' + '<div>' + @project.client.addresses.first + '</div>'
          else
            if @invoice.contact.company_contact.present?
              if @invoice.contact.company_contact.addresses.any?
                content = content + '<br>' + '<div>' + @invoice.contact.company_contact.addresses.first + '</div>'
              else
                content = content + '<br>' + '<div>' + 'NO ADDRESS FOUND' + '</div>'
              end

            else
              content = content + '<br>' + '<div>' + 'No Address found. Searched in Project Client addresses and Invoice Contact Company Adresses. Please update.' + '</div>'
            end
            # invoice company contact present
          end
          # project client address check
        end
        # project client check

        if @invoice.contact.present?
          content = content + '<br>' + '<div>' + @invoice.contact.full_name + '</div>'
        end
        if @invoice.contact.email.present?
          content = content + '<br>' + '<div>' + @invoice.contact.email + '</div>'
        else
          content = content + '<br>' + '<div>' + 'NO EMAIL FOUND' + '</div>'
        end
        content = content + '<br>' + '<div>' + @invoice.invoice_number.to_s + '</div>'
        content = content + '<br>' + '<div>' + @invoice.description.html_safe + ' -- ' + number_to_currency(@invoice.total) + '</div>'
        content = content + '<br>' + '<div>' + @invoice.payment_term.name + '</div>'
        content = content + '<br>' + '<div>' + 'Send invoice to: ' + @invoice.contact.email + '</div>'

      end
      m = Message.new
      m.subject = "Invoices Due"
      m.to = emails
      m.body = content
      m.message_type = "Invoice Alert"
      m.template = "invoice-alert"
      m.save!
      # email projects list
    end

    if email_projects_list.any?
      send_invoice_due_email(email_projects_list)
    end
  end

  desc 'send manger invoice update of overdue invoices'
  task :overdue_email => :environment do

    overdue_id = PaymentStatus.find_by(name: 'Overdue').id
    projects = Project.active_scope()
    update_list = {
      'due_on_receipt_list' => [],
      'net_30_list' => [],
      'net_60_list' => [],
      'net_90_list' => []
    }
    projects.each do |project|
      project.payment_schedules.each do |ps|
        if ps.invoice_date.present?
            if ps.payment_status.name == 'In Progress'
              invoice_object = {}
              invoice_object["project"] = project
              invoice_object["invoice"] = ps

              case ps.payment_term.name
                when "Due on receipt"
                  if ps.invoice_date.to_date < 14.day.ago
                    puts "#{project.project_number}, has an Invoice past Due!!"
                    update_list["due_on_receipt_list"].push(invoice_object)
                    ps.payment_status_id = overdue_id
                    ps.save!
                  end

                when "Net 30"
                  if ps.invoice_date.to_date < 30.day.ago
                    puts "#{project.project_number}, has an Invoice 30 days past Due!!"
                    update_list["net_30_list"].push(invoice_object)
                    ps.payment_status_id = overdue_id
                    ps.save!
                  end
                when "Net 60"
                  if ps.invoice_date.to_date < 60.day.ago
                    puts "#{project.project_number}, has an Invoice 60 days past Due!!"
                    update_list["net_60_list"].push(invoice_object)
                    ps.payment_status_id = overdue_id
                    ps.save!
                  end
                when "Net 90"
                  if ps.invoice_date.to_date < 90.day.ago
                    puts "#{project.project_number}, has an Invoice 90 days past Due!!"
                    update_list["net_90_list"].push(invoice_object)
                    ps.payment_status_id = overdue_id
                    ps.save!
                  end
              else
              end
              # end case
            end
            # payment status name
        end
        # invoice date check
      end
      # payment schedules
    end
    # projects each


    def invoice_overdue_email(update_list)

      emails = Option.find_by(key: 'account_manager_email').value
      content = ""
      content = "<p>Hello, The following " + ActionController::Base.helpers.pluralize(update_list.length, 'invoice') + " are overdue: </p>"

      update_list.each do |key, value|
        value.each do |obj|
          @project = obj["project"]
          @invoice = obj["invoice"]
          site_url = Preference.first.url
          proj_title = "#{@project.project_number}"
          content = content + '<div class="project_title">'
          content = content + '<br><h4>Project: </h4><br>'
          content = content + '<a href="' + site_url + project_path(@project) + '">' + proj_title.to_s + '</a>'
          content = content + '</div>'

          if @project.client.present?
            content = content + '<div>' + @project.client.company_name + '</div>'
            if @project.client.addresses.any?
              content = content + '<br>' + '<div>' + @project.client.addresses.first + '</div>'
            else
              if @invoice.contact.company_contact.present?
                if @invoice.contact.company_contact.addresses.any?
                  content = content + '<br>' + '<div>' + @invoice.contact.company_contact.addresses.first + '</div>'
                else
                  content = content + '<br>' + '<div>' + 'NO ADDRESS FOUND' + '</div>'
                end

              else
                content = content + '<br>' + '<div>' + 'No Address found. Searched in Project Client addresses and Invoice Contact Company Adresses. Please update.' + '</div>'
              end
              # invoice company contact present
            end
            # project client address check
          end
          # project client check

          if @invoice.contact.present?
            content = content + '<br>' + '<div>' + @invoice.contact.full_name + '</div>'
          end
          if @invoice.contact.email.present?
            content = content + '<br>' + '<div>' + @invoice.contact.email + '</div>'
          else
            content = content + '<br>' + '<div>' + 'NO EMAIL FOUND' + '</div>'
          end
          content = content + '<br>' + '<div>' + @invoice.invoice_number.to_s + '</div>'
          content = content + '<br>' + '<div>' + @invoice.description.html_safe + ' -- ' + number_to_currency(@invoice.total) + '</div>'
          content = content + '<br>' + '<div>' + @invoice.payment_term.name + '</div>'
          content = content + '<br>' + '<div>' + 'Send invoice to: ' + @invoice.contact.email + '</div>'


        end
    end

      m = Message.new
      m.subject = "Invoices Overdue"
      m.to = emails
      m.body = content
      m.message_type = "Overdue Alert"
      m.template = "overdue-alert"
      m.save!

    end
    # overdue
    update_list.each do |key, value|
      if value.any?
        invoice_overdue_email(update_list)
      end
    end
  end

end
# namespace
