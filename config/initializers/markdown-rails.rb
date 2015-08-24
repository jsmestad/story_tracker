MarkdownRails.configure do |config|
  markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
    fenced_code_blocks: true,
    autolink: true,
    lax_html_blocks: true,
    tables: true,
    strikethrough: true)
  config.render do |markdown_source|
    markdown.render(markdown_source)
  end
end
