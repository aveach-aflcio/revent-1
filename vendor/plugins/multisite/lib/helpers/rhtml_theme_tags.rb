#
# These are theme helper tags
#
module ActionView::Helpers::AssetTagHelper
  def compute_theme_path source, relative_path, extension
    "/#{relative_path}/#{source}.#{extension}"
  end
   # returns the public path to a theme stylesheet
   def theme_stylesheet_path( source=nil, theme=nil )
      theme = theme || controller.current_theme
      compute_theme_path(source || "theme", "themes/#{theme}/stylesheets", 'css')
   end

   # returns the path to a theme image
   def theme_image_path( source, theme=nil )
      theme = theme || controller.current_theme
      compute_theme_path(source, "themes/#{theme}/images", 'png')
   end

   # returns the path to a theme javascript
   def theme_javascript_path( source, theme=nil )
      theme = theme || controller.current_theme
      compute_theme_path(source, "themes/#{theme}/javascript", 'js')
   end
   

   # This tag it will automatially include theme specific css files
   def theme_stylesheet_link_tag(*sources)
      sources.uniq!
      options = sources.last.is_a?(Hash) ? sources.pop.stringify_keys : { }
      sources.collect { |source|
         source = theme_stylesheet_path(source)
         tag("link", { "rel" => "Stylesheet", "type" => "text/css", "media" => "screen", "href" => source }.merge(options))
      }.join("\n")
   end
   
   # This tag will return a theme-specific IMG
   def theme_image_tag(source, options = {})
     options.symbolize_keys

     options[:src] = theme_image_path(source)
     options[:alt] ||= File.basename(options[:src], '.*').split('.').first.capitalize

     if options[:size]
       options[:width], options[:height] = options[:size].split("x")
       options.delete :size
     end

     tag("img", options)
   end
   
   # This tag can be used to return theme-specific javscripts
   def theme_javascript_include_tag(*sources)
     options = sources.last.is_a?(Hash) ? sources.pop.stringify_keys : { }
     sources = ['prototype', 'effects', 'controls', 'dragdrop'] if sources.first == :defaults
     sources.collect { |source|
       source = theme_javascript_path(source)        
       content_tag("script", "", { "type" => "text/javascript", "src" => source }.merge(options))
     }.join("\n")
   end

end