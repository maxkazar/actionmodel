module Concern

  # Add action to model.
  #
  # @example Add viewable action
  #   class Post
  #     act_as :viewable
  #     ...
  #   end
  #
  # @example Add sortable action
  #   class User
  #     act_as_sortable :email, :name
  #     ...
  #   end
  def act_as(*args)
    args.each do |action|
      action_class = action_module(action)
      unless action_class
        raise ActionModel::NameError, "Action #{action} is not found in [#{self.name.demodulize}::#{action.to_s.camelize}, Actions::#{action.to_s.camelize}]."
      end

      actions[action.to_sym] ||= ActionModel::Context.new

      include action_class
    end
  end

  # Action module for action name
  #
  # @param action [Symbol/String] action name
  def action_module(action)
    "#{self.name.demodulize}::#{action.to_s.camelize}".safe_constantize ||
        "Actions::#{action.to_s.camelize}".safe_constantize
  end

  # Add action to model.
  #
  #
  # @example Add historyable action
  #   class Rank
  #     act_as_historyable :value, :boost, autofill: true
  #     ...
  #   end
  def method_missing(method, *args, &block)
    action = method[/^act_as_(.+)/, 1]
    if action.nil?
      super(method, *args, &block)
    else
      options = args.extract_options!
      action = action.to_sym
      actions[action] = OpenStruct.new(args: args, options: options)

      act_as action
    end
  end
end