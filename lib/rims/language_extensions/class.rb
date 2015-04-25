class Class
  # defines a class instance variable that is inheritable,
  # it's possible to opt-out of the reader or writer by
  # passing reader: false or writer: false as an option.
  def attr_class(attrs, options = {})
    options = {reader: true, writer: true, :default => nil}.merge(options)

    Array(attrs).each do |attr|
      if options[:writer]
        define_singleton_method("#{attr}=") do |value|
          instance_variable_set(:"@#{attr}", value)
        end
      end

      if options[:reader]
        define_singleton_method(attr) do
          if ivar = instance_variable_get(:"@#{attr}")
            ivar
          elsif superclass.respond_to?(attr)
            value = superclass.send(attr)
            instance_variable_set(:"@#{attr}", value.dup) if value
          else
            instance_variable_set(:"@#{attr}", options[:default])
          end
        end
      end
    end
  end
end