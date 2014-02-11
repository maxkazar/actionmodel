require 'spec_helper'

describe ActionModel::Concern do
  let(:model) { Class.new { include ActionModel::Concern } }

  before do
    allow(model).to receive(:name).and_return 'Post'
    model.public_class_method :include_action, :find_or_create_action, :action_module
  end

  describe '.act_as' do
    it 'include action' do
      expect(model).to receive(:include_action).with :searchable, {}
      model.act_as :searchable
    end

    it 'include action with options' do
      expect(model).to receive(:include_action).with :searchable, { ignorecase: true }
      model.act_as :searchable, ignorecase: true
    end
  end

  describe '.include_action' do
    context 'action module exists' do
      let(:action) { double :action }

      before do
        allow(model).to receive(:action_module).and_return action
        allow(model).to receive(:include?).and_return false
      end

      it 'update action context' do
        allow(model).to receive(:include)
        expect_any_instance_of(ActionModel::Context).to receive(:update)
        model.include_action :searchable
      end

      it 'update action context with options' do
        allow(model).to receive(:include)
        expect_any_instance_of(ActionModel::Context).to receive(:update).with(ignorecase: true)
        model.include_action :searchable, ignorecase: true
      end

      it 'include action module' do
        expect(model).to receive(:include).with action
        model.include_action :searchable
      end
    end

    context 'action module does not exists' do
      before { allow(model).to receive(:action_module).and_return nil }

      it 'raise exception' do
        expect { model.include_action :unknownable }.to raise_error RuntimeError, 'Action unknownable is not found in [Post::Unknownable, Actions::Unknownable].'
      end
    end
  end

  describe '.action_module' do
    let(:action) { "#{model.name.demodulize}::Knownable" }

    context 'when a model action exists' do
      before { allow(ActiveSupport::Inflector).to receive(:safe_constantize).with(action).and_return action }

      subject { model.action_module :knownable }

      it { should eq action }
    end

    context 'when a global action exists' do
      let(:action) { 'Actions::Knownable' }

      before { allow(ActiveSupport::Inflector).to receive(:safe_constantize).and_return nil, action }

      subject { model.action_module :knownable }

      it { should eq action }
    end

    context 'when the action model is not exist' do
      before { allow(ActiveSupport::Inflector).to receive(:safe_constantize).and_return nil }

      subject { model.action_module(:unknownable) }

      it { should be_nil }
    end
  end

  describe '.method_missing' do
    context 'without action method' do
      it 'call class method' do
        expect(model).to receive(:class_method)
        model.class_method
      end
    end

    context 'with action method' do
      it 'config action' do
        expect(model).to receive(:include_action).with 'searchable', :name, ignorecase: true
        model.act_as_searchable :name, ignorecase: true
      end
    end
  end
end