require 'rgen/metamodel_builder'

module EventRegistrationMetamodel
   extend RGen::MetamodelBuilder::ModuleExtension
   include RGen::MetamodelBuilder::DataTypes

   DataType = Enum.new(:name => 'DataType', :literals =>[ :String, :Integer, :Boolean, :Date ])

   class Data < RGen::MetamodelBuilder::MMBase
      has_attr 'name', String, :lowerBound => 1 
      has_attr 'type', EventRegistrationMetamodel::DataType, :lowerBound => 1 
      has_attr 'optional', Boolean 
   end

   class Page < RGen::MetamodelBuilder::MMBase
      has_attr 'name', String, :lowerBound => 1 
   end

   class Constraint < RGen::MetamodelBuilder::MMBase
      has_attr 'message', String 
   end


   module Expression
      extend RGen::MetamodelBuilder::ModuleExtension
      include RGen::MetamodelBuilder::DataTypes


      class Expression < RGen::MetamodelBuilder::MMBase
         abstract
      end

      class SimpleExpression < Expression
         abstract
      end

      class OneOf < SimpleExpression
         has_many_attr 'values', String, :lowerBound => 1 
      end

      class Equals < SimpleExpression
         has_attr 'value', String, :lowerBound => 1 
      end

      class Empty < SimpleExpression
      end

      class LessThan < SimpleExpression
         has_attr 'value', String, :lowerBound => 1 
      end

      class GreaterThan < SimpleExpression
         has_attr 'value', String, :lowerBound => 1 
      end

      class Not < Expression
      end

      class And < Expression
      end

      class Or < Expression
      end

   end

   module Content
      extend RGen::MetamodelBuilder::ModuleExtension
      include RGen::MetamodelBuilder::DataTypes


      class ContentElement < RGen::MetamodelBuilder::MMBase
         abstract
      end

      class Text < ContentElement
         has_attr 'text', String, :lowerBound => 1 
      end

      class DataInput < ContentElement
         abstract
         has_attr 'label', String 
         has_attr 'description', String 
      end

      class TextInput < DataInput
      end

      class DropDownInput < DataInput
      end

      class RadioInput < DataInput
      end

      class CheckboxInput < DataInput
      end

      class DatePickerInput < DataInput
      end

   end
end

EventRegistrationMetamodel::Data.contains_many_uni 'constraints', EventRegistrationMetamodel::Constraint 
EventRegistrationMetamodel::Page.contains_many_uni 'elements', EventRegistrationMetamodel::Content::ContentElement 
EventRegistrationMetamodel::Page.many_to_many 'successors', EventRegistrationMetamodel::Page, 'predecessors' 
EventRegistrationMetamodel::Page.contains_one_uni 'guardCondition', EventRegistrationMetamodel::Expression::Expression 
EventRegistrationMetamodel::Page.contains_many_uni 'constraints', EventRegistrationMetamodel::Constraint 
EventRegistrationMetamodel::Constraint.contains_one_uni 'assert', EventRegistrationMetamodel::Expression::Expression, :lowerBound => 1 
EventRegistrationMetamodel::Expression::SimpleExpression.has_one 'data', EventRegistrationMetamodel::Data 
EventRegistrationMetamodel::Expression::Not.contains_one_uni 'expression', EventRegistrationMetamodel::Expression::Expression, :lowerBound => 1 
EventRegistrationMetamodel::Expression::And.contains_one_uni 'expression1', EventRegistrationMetamodel::Expression::Expression, :lowerBound => 1 
EventRegistrationMetamodel::Expression::And.contains_one_uni 'expression2', EventRegistrationMetamodel::Expression::Expression, :lowerBound => 1 
EventRegistrationMetamodel::Expression::Or.contains_one_uni 'expression1', EventRegistrationMetamodel::Expression::Expression, :lowerBound => 1 
EventRegistrationMetamodel::Expression::Or.contains_one_uni 'expression2', EventRegistrationMetamodel::Expression::Expression, :lowerBound => 1 
EventRegistrationMetamodel::Content::DataInput.has_one 'data', EventRegistrationMetamodel::Data, :lowerBound => 1 
