module F2fIncoming
  module Command
    module ClassMethods
      def method_missing(method, *args)
        if instance_method(method)
          new.send(method, *args)
        else
          super
        end
      end
    end

    def self.included(base)
      base.extend ClassMethods
    end
  end
end
