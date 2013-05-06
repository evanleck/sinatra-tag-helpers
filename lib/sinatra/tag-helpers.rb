require 'sinatra/base'
require 'sinatra/tag-helpers/version'

module Sinatra
  module TagHelpers
    # don't even try it
    def html_escape(text = '')
      EscapeUtils.escape_html(text || '')
    end
    alias_method :h, :html_escape

    # converts a hash into HTML style attributes
    def to_attributes(hash)
      hash.collect do |key, value|
        # for things like data: { stuff: 'hey' }
        if value.is_a? Hash
          value.collect do |k, v|
            "#{key}-#{k}='#{v}'"
          end
        else
          value.is_a?(TrueClass) ? key.to_s : "#{key}='#{value}'"
        end
      end.join(' ').chomp
    end

    # mostly so we can override this if we need to look anywhere besides the params
    # * cough * session * cough *
    def param_value(param_name)
      html_escape(params[param_name.to_sym] || '')
    end

    # link helper
    # examples:
    #
    #   link_to 'Overview', '/account/overview' # => <a href='/account/overview'>Overview</a>
    #
    # when on /account/overview
    #
    #   <a href='/account/overview' class='current'>Overview</a>
    #
    def link_to(text, link, attributes = {})
      if link == request.path_info
        attributes[:class] = "#{ attributes[:class] } current"
      end

      attributes.merge!({ :href => to(link) })

      "<a #{ to_attributes(attributes) }>#{ text }</a>"
    end

    # input_for creates an <input> tag with a number of configurable options
    #   if `param` is set in the `params` hash, the values from the `params` hash will be populated in the tag.
    #
    #   <%= input_for 'something_hidden', type: 'hidden', value: 'Shhhhhh' %>
    #
    # Yields:
    #
    #   <input type='hidden' name='something_hidden' id='something_hidden' value='Shhhhhh'>
    #
    def input_for(param, attributes = {})
      attributes = {
        :type  => 'text',
        :value => param_value(param),
        :name  => param,
        :id    => param
      }.merge(attributes)

      "<input #{ to_attributes(attributes) }>"
    end

    # radio_for creates an input tag of type radio and marks it `checked` if the param argument is set to the same value in the `params` hash
    def radio_for(param, attributes = {})
      attributes = {
        :type => 'radio'
      }.merge(attributes)

      if param_value(param) == attributes[:value].to_s
        attributes.merge!({ :checked => true })
      end

      input_for param, attributes
    end

    # checkbox_for creates an input of type checkbox with a `checked_if` argument to determine if it should be checked
    #
    #   <%= checkbox_for 'is_cool', User.is_cool? %>
    #
    # Yields:
    #
    #   <input type='checkbox' name='is_cool' id='is_cool' value='true'>
    #
    # Which will be marked with `checked` if `User.is_cool?` evaluates to true
    #
    def checkbox_for(param, checked_if, attributes = {})
      attributes = {
        :type  => 'checkbox',
        :value => 'true'
      }.merge(attributes)

      if checked_if || param_value(param) == attributes[:value].to_s
        attributes.merge!({ checked: true })
      end

      input_for param, attributes
    end

    # creates a simple <textarea> tag
    def textarea_for(param, attributes = {})
      attributes = {
        :name => param,
        :id   => param
      }.merge(attributes)

      "<textarea #{ attributes.to_attr }>#{ param_value(param) }</textarea>"
    end

    # option_for creates an <option> element with the specified attributes
    #   if the param specified is set to the value of this option tag then it is marked as 'selected'
    #   designed to be used within a <select> element
    #
    #   <%= option_for 'turtles', key: 'I love them', value: 'love' %>
    #
    # Yields:
    #
    #   <option value='love'>I love them</option>
    #
    # If params[:turtle] is set to 'love' this yields:
    #
    #   <option value='love' selected>I love them</option>
    #
    def option_for(param, attributes = {})
      default = attributes.delete(:default).to_s

      if !params[param.to_sym].nil? && !params[param.to_sym].empty?
        default = param_value(param)
      end

      attributes.merge!({ :selected => true }) if default == attributes[:value].to_s
      key = attributes.delete(:key)

      "<option #{ to_attributes(attributes) }>#{ key }</option>"
    end

    # select_for creates a <select> element with the specified attributes
    #   options are the available <option> tags within the <select> box
    #
    #   <%= select_for 'days', { monday: 'Monday', myday: 'MY DAY!' } %>
    #
    # Yields:
    #
    #   <select name='days' id='days' size='1'>
    #     <option value='monday'>Monday</option>
    #     <option value='myday'>MY DAY!</option>
    #   </select>
    #
    def select_for(param, options, attributes = {})
      attributes = {
        :name => param,
        :id   => param,
        :size => 1
      }.merge(attributes)

      select = ["<select #{ to_attributes(attributes) }>"]

      options.collect do |key, val|
        select.push option_for(param, :key => key, :value => val, :default => attributes[:default])
      end

      select.push('</select>').join(' ').chomp
    end

    # shortcut to generate a month list
    def months_for(param, attributes = {})
      select_for(param, { 'Month' => '', '1 - January' => '01', '2 - February' => '02', '3 - March' => '03', '4 - April' => '04', '5 - May' => '05', '6 - June' => '06', '7 - July' => '07', '8 - August' => '08', '9 - September' => '09', '10 - October' => '10', '11 - November' => '11', '12 - December' => '12' }, attributes)
    end

    def years_for(param, range = 1940..Date.today.year, attributes = {})
      options = { 'Year' => '' }

      if range.last > range.first
        # top down
        range.last.downto(range.first) do |element|
          options[element] = element
        end
      else
        # bottom up
        range.last.upto(range.first) do |element|
          options[element] = element
        end
      end

      select_for(param, options, attributes)
    end

    def days_for(param, attributes = {})
      options = { 'Day' => '' }

      (1..31).each do |day|
        options[day] = day
      end

      select_for(param, options, attributes)
    end
  end

  helpers TagHelpers
end
