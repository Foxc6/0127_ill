module ApplicationHelper

	def display_social_networks(contact)
		str = ""
		contact.social_reaches.each do |social_reach|
    	str = "#{str}<a href=\"#{social_reach.url}\" target=\"_blank\"><i class=\"fa fa-#{social_reach.name.downcase}\"></i></a>&nbsp;"
    end
    raw(str)
	end

	def display_email_linkedin(contact)
		str = ""
		contact.social_reaches.each do |social_reach|
			if social_reach.name.downcase == 'linkedin'
    	str = "#{str}<a href=\"#{social_reach.url}\" target=\"_blank\"><i class=\"fa fa-#{social_reach.name.downcase}\"></i></a>&nbsp;"
    	end
    end

    str = "#{str}<a href=\"mailto:#{contact.email}\"><i class=\"fa fa-envelope\"></i></a>&nbsp;"
    raw(str)
	end

	def display_social_reach(social_reach)
		str = ""

		if social_reach.name.downcase == "twitter"
			str = "<strong>#{number_to_human(social_reach.total_reach)}</strong> #{'Follower'.pluralize(social_reach.total_reach)}"
		elsif social_reach.name.downcase == "pinterest"
			str = "<strong>#{number_to_human(social_reach.total_reach)}</strong> #{'Follower'.pluralize(social_reach.total_reach)}"
		elsif social_reach.name.downcase == "facebook"
			str = "<strong>#{number_to_human(social_reach.total_reach)}</strong> #{'Like'.pluralize(social_reach.total_reach)}"
		elsif social_reach.name.downcase == "youtube"
			str = "<strong>#{number_to_human(social_reach.total_reach)}</strong> #{'Subscriber'.pluralize(social_reach.total_reach)}"
		elsif social_reach.name.downcase == "instagram"
			str = "<strong>#{number_to_human(social_reach.total_reach)}</strong> #{'Follower'.pluralize(social_reach.total_reach)}"
		elsif social_reach.name.downcase == "linkedin"
			str = "<strong>#{number_to_human(social_reach.total_reach)}</strong> #{'Connections'.pluralize(social_reach.total_reach)}"
		else
			str = "<strong>#{number_to_human(social_reach.total_reach)}</strong>"
		end

		str
	end

	def client_path(contact)
		'/clients/'+contact.slug
	end

	def team_path(contact)
		'/teams/'+contact.id.to_s
	end

	def sales_case_path(project)
		'/sales/'+project.case_number
	end

	def sortable(column, title = nil)
  		title ||= column.titleize
  		css_class = column == sort_column ? "current #{sort_direction}" : nil
  		direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
  		link_to title, {:sort => column, :direction => direction, :filter => params['filter']}, {:class => css_class}
	end

end
