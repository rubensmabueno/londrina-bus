require 'rails_helper'

RSpec.describe TCGL::Lists::Concerns::Base do
  subject { described_klass.new }

  let(:described_klass) { Class.new.include(described_class) }

  describe '.model_name' do
    before { allow(described_klass).to receive(:name) { 'Foo::Bar' } }

    it { expect(described_klass.model_name).to eq 'Bar' }
  end

  describe '#initialize' do
    subject { described_klass.new(options) }

    let(:options) { double }

    it 'stores the options' do
      expect(subject.options).to eq options
    end
  end

  describe '#collection' do
    let(:raw_data) { [{ foo: :bar }, { foo: :bar }] }
    let(:model_class) { double }

    before do
      allow(subject).to receive(:raw_data) { raw_data }
      allow(described_klass).to receive(:model_class) { model_class }
    end

    it 'instantiates a new model_class passing raw_data' do
      expect(model_class).to receive(:new).with(foo: :bar).twice
      subject.collection
    end
  end

  describe '#raw_data' do
    let(:request_class) { double }

    before do
      allow(subject).to receive(:request_class_instance) { request_class }
    end

    it 'fetches on request_class instance' do
      expect(request_class).to receive(:fetch)
      subject.raw_data
    end
  end

  describe '#request_class_instance' do
    subject { described_klass.new(options) }

    let(:request_class) { double }
    let(:options) { double }

    it 'instantiate a request_class with options' do
      allow(subject.class).to receive(:request_class) { request_class }
      allow(request_class).to receive(:new).with(options)

      subject.request_class_instance
    end
  end

  describe '#each' do
    let(:collection) { [1, 2] }

    before { allow(subject).to receive(:collection) { collection } }

    it 'yields as much collection exists' do
      expect { |b| subject.each(&b) }.to yield_successive_args(1, 2)
    end
  end
end
