module ApplicationHelper

	#Returns the full title of a page
	def full_title(page_title) 
		base_title = "Ruby on Rails Tutorial Sample App"
		if page_title.empty?
			full_title = "Ruby on Rails Tutorial Sample App"
		else
			"#{base_title} | #{page_title}"
		end
	end
end
