require 'prawn/table'
require "open-uri"
class EstimatePdf < Prawn::Document
	def initialize(estimate, view)
		super(top_margin: 70)
		@estimate = estimate
      @view = view
		@client = @estimate.client
      @company = Contact.find_by(id: @estimate.company_id)

   
     #### Being PDF layout ####
      company_logo

      title

      estimate_number_title
      estimate_number

      estimate_company_name
      company_address
      company_url

      client_title
		client_company_name
      client_address1
      client_address2

		date_title
      date

      stroke do
         move_down 50
         line_items_header
      end

      stroke do
         move_down 10
         line_items
         horizontal_line 320, 550, :at => 35
      end

      total_title
		total
      #### End PDF layout ####
   end

   def date_title
      draw_text "Date",:at => [380, 542], :style => :bold, :size => 10
   end

   def date
      draw_text "#{@estimate.date.strftime('%x')}", :at => [380, 525], :size => 10, :color => "00FF00"
   end

   def estimate_number_title
      draw_text "Estimate No.",:at => [475, 542], :style => :bold, :size => 10
   end

   def estimate_number
      draw_text "#{@estimate.number}", :at => [475, 525], :size => 10, :color => "00FF00"
	end

   def client_title
      draw_text "Client",:at => [0, 542], :style => :bold, :size => 10
   end

	def client_company_name
      move_down 55
		text "#{@client.company_name}", :size => 10, :color => "666666"
	end

   def client_address1
      move_down 1
      @client_address = Address.where(contact_id: @estimate.client_id).where(id: @estimate.client_address_id).first
      if @client_address.present?
         text "#{@client_address.address1} #{@client_address.address2}",:max_width => 100, :size => 10, :color => "666666"
      else
         text "There is currently no address for #{@client.company_name} saved on the Estimate form!",:width => 130, :size => 10, :color => "666666"
      end
   end

   def client_address2
      move_down 1
      @client_address = Address.where(contact_id: @estimate.client_id).where(id: @estimate.client_address_id).first
      if @client_address.present?
         @client_state = State.where(id: @client_address.state_id).first
         @client_state_name = @client_state.abbr
         text "#{@client_address.city}, #{@client_state_name} #{@client_address.postal_code}",:max_width => 100, :size => 10, :color => "666666"
      end
   end

   def total_title
      draw_text "Total", :at => [515, 55], :style => :bold, :size => 10
   end

	def total
		text_box "#{price(@estimate.total)}", 
      :at => [470, 15], :align  => :right, :size => 10
	end

   def estimate_company_name
      move_down 50
      text "#{@company.company_name}", :size => 10, :color => "666666"
   end

   def company_address
      move_down 1
      @company_address = Address.where(contact_id: @estimate.company_id).first
      @company_state = State.where(id: @company_address.state_id).first
      @company_state_name = @company_state.abbr
      text "#{@company_address.address1} #{@company_address.address2} \n #{@company_address.city}, #{@company_state_name} #{@company_address.postal_code}", :size => 10, :color => "666666"
   end

   def company_url
      move_down 1
      text "#{@company.website_url}", :size => 10, :color => "666666"
   end

   def company_logo
      ## Use to link an image using an URL
      #image open("IMAGE URL GOES HERE"), :width => 40, :height => 45

      ## Use to link an image using an direct file path
      image "#{Rails.root}/app/assets/images/test.jpg", :width => 40, :height => 45, :at => [-8, 725]
   end

   def title
      font "Helvetica"
      draw_text "Estimate",
      :at => [375, 695],
      :size => 20
   end

	def line_items
	  move_down 20
	  table line_item_rows do
         rows(0..100).size = 10
         column(0).text_color = "666666"
         cells.borders = [:bottom]
         cells.padding = [5, 0, 5, 0]
         cells.border_color = "FFFFFF"
         column(0).width = 440
         column(1).width = 100
         column(1).align = :right
		end
	end

   def line_items_header
     move_down 25
     table line_item_headers do
         row(0).text_color = "000000"
         row(0).font_style = :bold
         row(0).size = 10
         cells.borders = [:bottom]
         cells.padding = [5, 0, 5, 0]
         cells.border_color = "FFFFFF"
         column(0).width = 380
         column(1).width = 160
         column(1).align = :right
         self.header = true
      end
      stroke_horizontal_rule
   end

   def price(num)
      @view.number_to_currency(num)
   end

   def line_item_headers
      [["Description", "Amount"]] + 
      @estimate.estimate_line_items.map do |item|
         []
      end
   end

	def line_item_rows
		@estimate.estimate_line_items.map do |item|
		  [item.description, price(item.price)]
		end	
	end
end