require 'spec_helper'

describe ActionModel::Context do
  let(:context) { ActionModel::Context.new }

  describe '#update' do
    it 'update action options' do
      context.update disabled: true
      expect(context.options).to eq disabled: true
    end

    it 'update action fields' do
      context.update :name, :email
      expect(context.fields.keys).to eq [:name, :email]
    end

    it 'update action fields options' do
      context.update :name, :email, ignorecase: true
      expect(context.fields).to eq({ name: {ignorecase: true}, email: {ignorecase: true} })
    end

    context 'when action context has options' do
      before { context.options[:disabled] = true }

      it 'update action options' do
        context.update disabled: false, inverse: true
        expect(context.options).to eq disabled: false, inverse: true
      end
    end

    context 'when action context has field' do
      before { context.fields[:name] = {ignorecase: true} }

      it 'update action field options' do
        context.update :name, :email, ignorecase: false
        expect(context.fields).to eq({ name: {ignorecase: false}, email: {ignorecase: false} })
      end
    end
  end
end