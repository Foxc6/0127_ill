class IllHtmlRenderer < Redcarpet::Render::HTML
  include Redcarpet::Render::SmartyPants

  def initialize(options = {})
    super options.merge(:hard_wrap => true, :filter_html => true)
  end
end
