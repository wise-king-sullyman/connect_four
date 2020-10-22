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

describe Board do
  before do
    allow($stdout).to receive(:write)
  end
  
  subject { Board.new }
  
  describe '#create_grid' do
    it 'returns a blank grid' do
      grid_example = [[0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0]]
      expect(subject.create_grid).to eql(grid_example)
    end
  end

  describe '#to_s' do
    it 'returns grid in a readable pattern' do
      grid_example = "[0, 0, 0, 0, 0, 0, 0]\n[0, 0, 0, 0, 0, 0, 0]\n[0, 0, 0, 0, 0, 0, 0]\n[0, 0, 0, 0, 0, 0, 0]\n[0, 0, 0, 0, 0, 0, 0]\n[0, 0, 0, 0, 0, 0, 0]\n"
      expect(subject.to_s).to eql(grid_example)
    end
  end

  describe '#update' do
    let(:player) { Player.new('player 1', '#') }
    context 'column is empty' do
      it 'adds symbol to last row of desired column' do
        grid_example = [[0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, '#'], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0]]
        subject.update(1, player.symbol)
        expect(subject.instance_variable_get('@grid')).to eql(grid_example)
      end
    end

    context 'column is partially blank' do
      it 'adds symbol to next available slot in column' do
        existing_grid = [[0, 0, 0, 0, 0, 0], [0, 0, 0, 0, '@', '#'], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0]]
        grid_example = [[0, 0, 0, 0, 0, 0], [0, 0, 0, '#', '@', '#'], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0]]
        subject.instance_variable_set('@grid', existing_grid)
        subject.update(1, player.symbol)
        expect(subject.instance_variable_get('@grid')).to eql(grid_example)
      end
    end

    context 'column is full' do
      it 'does not change the grid' do
        existing_grid = [[0, 0, 0, 0, 0, 0], ['#', '#', '@', '#', '@', '#'], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0]]
        grid_example = [[0, 0, 0, 0, 0, 0], ['#', '#', '@', '#', '@', '#'], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0]]
        subject.instance_variable_set('@grid', existing_grid)
        subject.update(1, player.symbol)
        expect(subject.instance_variable_get('@grid')).to eql(grid_example)
      end

      it 'prints column full' do
        #allow($stdout).to receive(:write)
        existing_grid = [[0, 0, 0, 0, 0, 0], ['#', '#', '@', '#', '@', '#'], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0]]
        subject.instance_variable_set('@grid', existing_grid)
        expect do
          subject.update(1, player.symbol)
        end.to output("column full\n").to_stdout
      end
    end
  end
end