class Module
  # a variation on attr_accessor that defines a method that can set or
  # retrieve the value of an instance varible.  If called with an argument
  # the method will act as a writer otherwise it will act as a reader
  def attr_func(*attrs)
    attrs.each do |attr|
      define_method(attr) do |value=nil|
        if(value)
          instance_variable_set(:"@#{attr}", value)
        else
          instance_variable_get(:"@#{attr}")
        end
      end
    end
  end
end