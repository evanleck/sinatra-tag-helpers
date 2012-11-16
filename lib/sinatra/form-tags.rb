module Sinatra
  module TagHelpers
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
        type:   'text',
        value:  params[param.to_sym] || '',
        name:   param,
        id:     param
      }.merge(attributes)

      tag('input', attributes)
    end

    # radio_for creates an input tag of type radio and marks it `checked` if the param argument is set to the same value in the `params` hash
    def radio_for(param, attributes = {})
      attributes = {
        type: 'radio'
      }.merge(attributes)

      if params[param.to_sym].to_s == attributes[:value].to_s
        attributes.merge!({ checked: true })
      end

      input_for(param, attributes)
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
        type:   'checkbox',
        value:  'true'
      }.merge(attributes)

      if checked_if || params[param.to_sym] == 'true'
        attributes.merge!({ checked: true })
      end

      input_for(param, attributes)
    end

    # creates a simple <textarea> tag
    def textarea_for(param, attributes = {})
      attributes = {
        name: param,
        id:   param
      }.merge(attributes)

      content_tag('textarea', params[param.to_sym] || '', attributes)
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

      if params[param.to_sym].present?
        default = params[param.to_sym].to_s
      end

      attributes.merge!({ selected: true }) if default == attributes[:value].to_s
      key = attributes.delete(:key)

      content_tag('option', key, attributes)
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
      select = [ tag('select', { :name => param, :id => param, :size => '1' }.merge(attributes)) ]

      options.collect do |key, val|
        select.push option_for(param, key: key, value: val, default: attributes[:default])
      end

      select.push(close_tag('select')).join(' ').chomp
    end

    # shortcut to generate a month list
    def months_for(param, attributes = {})
      select_for(param, { 'Month' => '', '1 - Janunary' => '01', '2 - February' => '02', '3 - March' => '03', '4 - April' => '04', '5 - May' => '05', '6 - June' => '06', '7 - July' => '07', '8 - August' => '08', '9 - September' => '09', '10 - October' => '10', '11 - November' => '11', '12 - December' => '12' }, attributes)
    end

    def years_for(param, range = 1940..Date.today.year, attributes = {})
      options = { 'Year' => '' }

      range.last.downto(range.first) do |r|
        options[r] = r
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

    def states_for(param, attributes = {})
      select_for(param, { 'State' => '', 'AL' => 'AL', 'AK' => 'AK', 'AZ' => 'AZ', 'AR' => 'AR', 'CA' => 'CA', 'CO' => 'CO', 'CT' => 'CT', 'DE' => 'DE', 'DC' => 'DC', 'FL' => 'FL', 'GA' => 'GA', 'HI' => 'HI', 'ID' => 'ID', 'IL' => 'IL', 'IN' => 'IN', 'IA' => 'IA', 'KS' => 'KS', 'KY' => 'KY', 'LA' => 'LA', 'ME' => 'ME', 'MD' => 'MD', 'MA' => 'MA', 'MI' => 'MI', 'MN' => 'MN', 'MS' => 'MS', 'MO' => 'MO', 'MT' => 'MT', 'NE' => 'NE', 'NV' => 'NV', 'NH' => 'NH', 'NJ' => 'NJ', 'NM' => 'NM', 'NY' => 'NY', 'NC' => 'NC', 'ND' => 'ND', 'OH' => 'OH', 'OK' => 'OK', 'OR' => 'OR', 'PA' => 'PA', 'RI' => 'RI', 'SC' => 'SC', 'SD' => 'SD', 'TN' => 'TN', 'TX' => 'TX', 'UT' => 'UT', 'VT' => 'VT', 'VA' => 'VA', 'WA' => 'WA', 'WV' => 'WV', 'WI' => 'WI', 'WY' => 'WY' }, attributes)
    end
  end
end