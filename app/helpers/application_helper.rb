# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def title(page_title)
    @title = "Vote! - #{page_title}"
  end
  
  def section(page_section)
    @section = page_section
  end
  
  def display_flash
     for name in [:notice, :warning, :error]
       if flash[name]
         open :div, flash[name], {:id => name.to_s, :class => 'flash'}
       end
     end
     nil
   end

   def error_messages_for(*params)

     options = params.extract_options!.symbolize_keys

     if object = options.delete(:object)
       objects = [object].flatten
     else
       objects = params.collect {|object_name| instance_variable_get("@#{object_name}") }.compact
     end

     count = objects.inject(0) {|sum, object| sum + object.errors.count }

     unless count.zero?
       options[:object_name]    ||= params.first
       options[:header_message] ||= "#{pluralize(count, 'error')} prohibited this #{options[:object_name].to_s.gsub('_', ' ')} from being saved"
       options[:message]        ||= 'There were problems with the following fields:'

       error_messages = objects.map {|object| object.errors.full_messages }.flatten

       open :div, { :id => 'error_explanation' } do
         open :h2, options[:header_message] unless options[:header_message].blank?
         open :p,  options[:message]        unless options[:message].blank?
         open :ul do
           for error_message in error_messages
             open :li, error_message
           end
         end
       end
     end
   end
  
end
