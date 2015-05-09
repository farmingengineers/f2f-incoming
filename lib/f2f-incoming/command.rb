module F2fIncoming
  module Command
    def self.method_missing(method, *args)
      if instance_method(method)
        new.send(method, *args)
      else
        super
      end
    end
  end
end
