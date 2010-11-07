module EventRegistrationMetamodel

module Page::ClassModule
  def exists?(record)
    !guardCondition || guardCondition.check(record)
  end
  def input_element
    elements.select{|e| e.is_a?(Content::DataInput)}
  end
end

module Expression

module SimpleExpression::ClassModule
  def data_value(record, context)
    record.send((context || self.data).name)
  end
  def adapt_type(value, reference)
    return unless value
    value = value.to_i if reference.is_a?(Integer)
    value = value.to_f if reference.is_a?(Float)
    if reference.is_a?(FalseClass) || reference.is_a?(TrueClass)
      value = true if value == "true"
      value = false if value == "false"
    end
    value
  end
end

module OneOf::ClassModule
  def check(record, context=nil)
    cv = data_value(record, context)
    values.collect{|l| adapt_type(l, cv)}.include?(cv)
  end
end

module Equals::ClassModule
  def check(record, context=nil)
    cv = data_value(record, context)
    adapt_type(value, cv) == cv
  end
end

module Empty::ClassModule
  def check(record, context=nil)
    cv = data_value(record, context)
    cv.nil? || (cv.is_a?(String) && cv.strip.empty?) 
  end
end

module LessThan::ClassModule
  def check(record, context=nil)
    cv = data_value(record, context)
    cv < adapt_type(value, cv)
  end
end

module GreaterThan::ClassModule
  def check(record, context=nil)
    cv = data_value(record, context)
    cv > adapt_type(value, cv)
  end
end

module Not::ClassModule
  def check(record)
    !expression.check(record)
  end
end

module And::ClassModule
  def check(record)
    expression1.check(record) && expression2.check(record)
  end
end

module Or::ClassModule
  def check(record)
    expression1.check(record) || expression2.check(record)
  end
end

end

end

