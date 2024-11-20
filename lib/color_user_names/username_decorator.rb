module ColorUserNames
  module UsernameDecorator
    def cooked(opts = nil)
      original_cooked = super(opts)

      doc = Nokogiri::HTML::DocumentFragment.parse(original_cooked)
      doc.css('span.username').each do |span|
        user = User.find_by(username: span.text)
        if user
          user.groups.order(:position).each do |group| # Maintain group order
            span['class'] = span['class'] + " group-#{group.id}-colored-name"
          end
        end
      end

      doc.to_html.html_safe
    end
  end
end