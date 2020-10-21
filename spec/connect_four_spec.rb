# frozen_string_literal: true

require './lib/connect_four.rb'

describe Player do
  before do
    allow($stdout).to receive(:write)
  end
  
  subject { Player.new('player 1', '@')}
  describe '#request_input' do
    it 'asks the user for input' do
      output_string = "Enter a number 1 - 7 to pick a column\n"
      expect do
        subject.request_input
      end.to output(output_string).to_stdout
    end
  end

  describe '#input_valid?' do
    context 'when valid input given' do
      it 'returns true' do
      expect(subject.input_valid?(3)).to be true
      end
    end

    context 'when invalid input given' do
      it 'returns false' do
        expect(subject.input_valid?('foo')).to be false
      end
    end
  end

  describe '#choose_column' do
    context 'when valid input is given' do
      it 'returns column choice' do
        allow(subject).to receive(:gets).and_return(2.to_s)
        expect(subject.choose_column).to eql(1)
      end
    end

    context 'when invalid input is given' do
      it 'returns column choice' do
        allow(subject).to receive(:gets).and_return('foo', 'bar', 7.to_s)
        expect(subject.choose_column).to eql(6)
      end
    end
  end
end