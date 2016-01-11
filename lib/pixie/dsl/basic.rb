module Pixie
  module DSL
    class Basic

      def initialize(object)
        @object = object
      end

      def parse(block)
        instance_eval(&block)
      end

      def method_missing(name, value = nil, &block)
        if @object.respond_to?("#{name}=")
          @object.send("#{name}=", value)
        elsif @object.respond_to?(pluralize(name)) && @object.send(pluralize(name)).is_a?(Hash)
          klass = Object.const_get("Pixie::#{name.capitalize.to_s}")
          klass_object = klass.new(value)
          if klass.respond_to?(:dsl)
            dsl = klass.dsl.new(klass_object)
          else
            dsl = self.class.new(klass_object)
          end
          dsl.parse(block)
          @object.send(pluralize(name))[value] = klass_object
        else
          super
        end
      end

      def pluralize(name)
        "#{name}s"
      end

    end
  end
end
