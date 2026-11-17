class ProductSpecification < ApplicationRecord
  belongs_to :product
  belongs_to :category_attribute
  
  validate :validate_value_fields

  private

  def validate_value_fields
    return unless category_attribute

    expected_column = {
      "string" => :value_string,
      "number" => :value_number,
      "boolean" => :value_boolean
    }[category_attribute.data_type]
    # check the category attribute data type to define which column using to save data

    unless expected_column
      errors.add(:category_attribute, "has an unsupported data type")
      return
    end

    value_columns = %i[value_string value_number value_boolean]

    value_columns.each do |column| # check columns
      next if column == expected_column

      value = public_send(column) 
      # public_send: dynamic name, column = string --> call value of string; column = number --> call value of number
      has_value = column == :value_string ? value.present? : !value.nil?
      # it must be blank for unexpected column

      errors.add(column, "must be blank") if has_value
    end

    value = public_send(expected_column)
    missing_value = value.nil? || (expected_column == :value_string && value.blank?)

    if category_attribute.is_required && missing_value
      errors.add(expected_column, "can't be blank")
    end
  end
end