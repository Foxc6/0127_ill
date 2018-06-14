class SearchController < ApplicationController

  def show
    # @search = search(params)
    # @total_hits = @search.hits.length
    # @query = params["search"]
  end

  protected
    def search(options)
      #   Sunspot.search(Project, Contact) do
      #   keywords options[:search]
      #   paginate :page => options[:page]
      # end
    end
end
