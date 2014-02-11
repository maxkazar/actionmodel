require 'active_support/core_ext/array/extract_options'
require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/object/blank'
require 'active_support/concern'
require 'actionmodel/context'

module ActionModel
  module Concern
    extend ActiveSupport::Concern

    # Return actions context hash for model instance.
    def actions
      self.class.actions
    end

    module ClassMethods

      # Add actions to model.
      #
      # Add single action to model
      #
      #   class Post
      #     act_as :searchable
      #     ...
      #   end
      #
      # Add actions to model
      #
      #   class Post
      #     act_as :searchable, :viewable
      #     ...
      #   end
      #
      # Actions can be added with options. Options applied for each action
      #
      #   class Post
      #     act_as :searchable, ignorecase: true
      #     ...
      #   end
      def act_as(*args)
        options = args.extract_options!

        args.each { |action_name| include_action action_name, options }
      end

      # Return actions context hash for model class.
      def actions
        @actions ||= {}
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
          super method, *args, &block
        else
          include_action *args.unshift(action)
        end
      end

      private

      # Include action into model
      def include_action(*args)
        return if args.empty?

        action_name = args.shift.to_sym

        action = action_module action_name
        unless action
          raise 'Action %1$s is not found in [%2$s::%3$s, Actions::%3$s].' %
                    [ action_name, self.name.demodulize, action_name.to_s.camelize ]
        end

        find_or_create_action(action_name).update *args

        include action unless include? action
      end

      # Find or create action by action name
      def find_or_create_action(action_name)
        actions[action_name] ||= ActionModel::Context.new
      end

      # Return action module by action name
      def action_module(action)
        "#{self.name.demodulize}::#{action.to_s.camelize}".safe_constantize ||
            "Actions::#{action.to_s.camelize}".safe_constantize
      end
    end
  end
end

