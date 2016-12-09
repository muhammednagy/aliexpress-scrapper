class HomeController < ApplicationController
	def index 
		if !params[:q].nil?
			params.permit!
			session[:url] = params[:q]
			redirect_to home_search_path
		end
	end
	def search
		if session[:url].nil?  
			redirect_to root_path
		else
			url = session[:url]
			doc = Nokogiri::HTML(open(url))
			@price =  doc.css('span.p-price').text.strip
			@title =  doc.css('h1.product-name').text.strip
			@size = doc.xpath('//span[contains(text(), "Size")]')[0].next.next.text.strip
			@packageSize = doc.xpath('//span[contains(text(), "Size")]')[1].next.next.text.strip
			@discount = doc.at_css('span#j-sku-discount-price')
			@colors = doc.search("a[@data-role='sku']" )
			@availableColors ||= []
			if !@colors.nil?
				@colors.each do |color|
					@availableColors.push(color.values[3])
				end
				@availableColors.delete_if {|x| x == "javascript:void(0)" }
			else
				@availableColors = "there is no optional colors"
			end
			if !@discount.nil? 
				@price = @discount.text
			end
			session[:url] = nil
		end
	end
end
