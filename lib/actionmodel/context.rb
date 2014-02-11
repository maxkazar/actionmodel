module ActionModel
  class Context
    def options
      @options ||= {}
    end

    def fields
      @fields ||= {}
    end

    def update(*args)
      options = args.extract_options!

      if args.empty?
        self.options.merge! options
      else
        args.each do |field|
          fields[field.to_sym] ||= {}
          fields[field.to_sym].merge! options
        end
      end
    end
  end
end