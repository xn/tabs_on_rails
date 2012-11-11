#--
# Tabs on Rails
#
# A simple Ruby on Rails plugin for creating and managing Tabs.
#
# Copyright (c) 2009-2012 Simone Carletti <weppos@weppos.net>
#++


module TabsOnRails
  class Tabs

    #
    # = Tabs Builder
    #
    # The TabsBuilder is and example of custom Builder.
    #
    class BootstrapNavBuilder < Builder

      # Returns a link_to +tab+ with +name+ and +options+ if +tab+ is not the current tab,
      # a simple tab name wrapped by a span tag otherwise.
      #
      #   current_tab? :foo   # => true
      #
      #   tab_for :foo, 'Foo', foo_path
      #   # => "<li class="current"><span>Foo</span></li>"
      #
      #   tab_for :bar, 'Bar', bar_path
      #   # => "<li><a href="/link/to/bar">Bar</a></li>"
      #
      # You can pass a hash of <tt>item_options</tt>
      # to customize the behavior and the style of the li element.
      #
      #   # Pass a custom class to the element
      #   tab_for :bar, 'Bar', bar_path, :class => "custom"
      #   # => "<li class="custom"><a href="/link/to/bar">Bar</a></li>"
      #
      # Implements Builder#tab_for.
      #
      def tab_for(tab, name, options, item_options = {}, &block)
        remote = item_options.delete :remote || false
        item_options[:class] = item_options[:class].to_s.split(" ").push("active").join(" ") if current_tab?(tab)
        if tab.to_s.ends_with?('dropdown')
          item_options[:class] = item_options[:class].to_s.split(" ").push("dropdown").join(" ")
          content = @context.content_tag(:a, ("#{name}" + @context.content_tag(:b, '',:class => 'caret')).html_safe, :href => "#", :class => 'dropdown-toggle', :"data-toggle" => 'dropdown').html_safe
          content << @context.content_tag(:ul, :class => 'dropdown-menu') do
            @context.capture(&block) if block_given?
          end
        else
          content = @context.link_to(name, options, :remote => remote)
        end
        @context.content_tag(:li, content, item_options)
      end

      # Returns an unordered list open tag.
      #
      # The <tt>options</tt> hash is used to customize the HTML attributes of the tag.
      #
      #   open_tag
      #   # => "<ul>"
      #
      #   open_tag :class => "centered"
      #   # => "<ul class=\"centered\">"
      #
      # Implements Builder#open_tabs.
      #
      def open_tabs(options = {})
        @context.tag("ul", options, open = true)
      end

      # Returns an unordered list close tag.
      #
      # The <tt>options</tt> hash is ignored here.
      # It exists only for coherence with the parent Builder API.
      #
      #   close_tag
      #   # => "</ul>"
      #
      #   close_tag :class => "centered"
      #   # => "</ul>"
      #
      # Implements Builder#close_tabs.
      #
      def close_tabs(options = {})
        "</ul>".html_safe
      end

    end

  end
end
