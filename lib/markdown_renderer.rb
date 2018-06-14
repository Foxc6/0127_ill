class MarkdownRenderer
  def initialize(text)
    @text = text
  end

  def render
    markdown.render(@text).html_safe
  end

  private

  def markdown
    Redcarpet::Markdown.new(IllHtmlRenderer, extensions)
  end

  def extensions
    {
      :autolink => true,
      :fenced_code_blocks => true,
      :no_intra_emphasis => true,
      :space_after_headers => true,
      :tables => true
    }
  end
end
