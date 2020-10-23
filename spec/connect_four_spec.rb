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
      it 'returns column choice once valid' do
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
      grid_example = [['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O', 'O']]
      expect(subject.create_grid).to eql(grid_example)
    end
  end

  describe '#to_s' do
    it 'returns grid in a readable pattern' do
      #grid_example =  "[\"O\", \"O\", \"O\", \"O\", \"O\", \"O\", \"O\",]\n[\"O\", \"O\", \"O\", \"O\", \"O\", \"O\", \"O\",]\n[\"O\", \"O\", \"O\", \"O\", \"O\", \"O\", \"O\",]\n[\"O\", \"O\", \"O\", \"O\", \"O\", \"O\", \"O\",]\n[\"O\", \"O\", \"O\", \"O\", \"O\", \"O\", \"O\",]\n[\"O\", \"O\", \"O\", \"O\", \"O\", \"O\", \"O\"]\n"
      grid_example = "[\"O\", \"O\", \"O\", \"O\", \"O\", \"O\", \"O\"]\n[\"O\", \"O\", \"O\", \"O\", \"O\", \"O\", \"O\"]\n[\"O\", \"O\", \"O\", \"O\", \"O\", \"O\", \"O\"]\n[\"O\", \"O\", \"O\", \"O\", \"O\", \"O\", \"O\"]\n[\"O\", \"O\", \"O\", \"O\", \"O\", \"O\", \"O\"]\n[\"O\", \"O\", \"O\", \"O\", \"O\", \"O\", \"O\"]\n"
      expect(subject.to_s).to eq(grid_example)
    end
  end

  describe '#update' do
    let(:player) { Player.new('player 1', '#') }
    context 'when column is empty' do
      it 'adds symbol to last row of desired column' do
        grid_example = [['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O', '#'], ['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O', 'O']]
        subject.update(1, player.symbol)
        expect(subject.instance_variable_get('@grid')).to eql(grid_example)
      end
    end

    context 'when column is partially blank' do
      it 'adds symbol to next available slot in column' do
        existing_grid = [['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', '@', '#'], ['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O', 'O']]
        grid_example = [['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', '#', '@', '#'], ['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O', 'O']]
        subject.instance_variable_set('@grid', existing_grid)
        subject.update(1, player.symbol)
        expect(subject.instance_variable_get('@grid')).to eql(grid_example)
      end
    end

    context 'when column is full' do
      it 'does not change the grid' do
        existing_grid = [['O', 'O', 'O', 'O', 'O', 'O'], ['#', '#', '@', '#', '@', '#'], ['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O', 'O']]
        grid_example = [['O', 'O', 'O', 'O', 'O', 'O'], ['#', '#', '@', '#', '@', '#'], ['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O', 'O']]
        subject.instance_variable_set('@grid', existing_grid)
        subject.update(1, player.symbol)
        expect(subject.instance_variable_get('@grid')).to eql(grid_example)
      end

      it 'prints column full' do
        existing_grid = [['O', 'O', 'O', 'O', 'O', 'O'], ['#', '#', '@', '#', '@', '#'], ['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O', 'O']]
        subject.instance_variable_set('@grid', existing_grid)
        expect do
          subject.update(1, player.symbol)
        end.to output("column full\n").to_stdout
      end
    end
  end
end

describe Game do
  before do
    #allow($stdout).to receive(:write)
  end

  subject { Game.new }

  describe '#welcome' do
    it 'prints the welcome message' do
      expect do
        subject.welcome
      end.to output("Welcome to connect four!\n").to_stdout
    end
  end

  describe '#end' do
    context 'when game ended in a tie' do
      it 'prints tie game' do
        expect { subject.end }.to output("Tie Game!\n").to_stdout
      end
    end

    context 'when game ended in a win' do
      it 'prints {winner} won!' do
        subject.instance_variable_set('@winner', 'player 1')
        expect { subject.end }.to output("player 1 Won!\n").to_stdout
      end
    end
  end

  describe '#inline_win' do
    let(:player) { Player.new('player 1', '#') }
    context 'when a winning combination exists' do
      it 'returns true' do
        grid = [['O', 'O', 'O', 'O', 'O', 'O'], ['O', '#', '#', '#', '#', '@'], ['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O', 'O']]
        expect(subject.inline_win(grid, player)).to be true
      end
    end

    context 'when a winning combination does not exist' do
      it 'returns false' do
        grid = [['O', 'O', 'O', 'O', 'O', 'O'], ['O', '#', '#', '#', '@', '@'], ['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O', 'O']]
        expect(subject.inline_win(grid, player)).to be false
      end
    end
  end

  describe '#column_win' do
    let(:player) { Player.new('player 1', '#') }
    context 'when a column win is present' do
      it 'returns true' do
        grid = [['O', 'O', 'O', 'O', 'O', 'O'], ['O', '#', '#', '#', '#', '@'], ['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O', 'O']]
        expect(subject.column_win(grid, player)).to be true
      end
    end

    context 'when no win is present' do
      it 'returns false' do
        grid = [['O', 'O', 'O', 'O', 'O', '#'], ['O', '#', '#', '#', '@', '#'], ['O', 'O', 'O', 'O', 'O', '#'], ['O', 'O', 'O', 'O', 'O', '#'], ['O', 'O', 'O', 'O', 'O', '#'], ['O', 'O', 'O', 'O', 'O', '#'], ['O', 'O', 'O', 'O', 'O', '#']]
        expect(subject.column_win(grid, player)).to be false
      end
    end
  end

  describe '#row_win' do
    let(:player) { Player.new('player 1', '#') }
    context 'when a row win is present' do
      it 'returns true' do
        grid = [['O', 'O', 'O', 'O', '#', 'O'], ['O', '#', '#', '#', '#', '@'], ['O', 'O', 'O', 'O', '#', 'O'], ['O', 'O', 'O', 'O', '#', 'O'], ['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O', 'O']]
        expect(subject.row_win(grid, player)).to be true
      end
    end

    context 'when no win is present' do
      it 'returns false' do
        grid = [['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', '#', '#', '#', '@'], ['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O', 'O']]
        expect(subject.row_win(grid, player)).to be false
      end
    end
  end

  describe '#diagonal_win' do
    let(:player) { Player.new('player 1', '#') }
    context 'when an upper diagonal win is present' do
      it 'returns true' do
        grid = [['O', 'O', 'O', 'O', '#', '#'], ['O', 'O', '#', '#', '#', '@'], ['O', 'O', 'O', '#', 'O', 'O'], ['O', 'O', '#', 'O', '#', 'O'], ['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O', 'O']]
        expect(subject.diagonal_win(grid, player)).to be true
      end
    end

    context 'when a lower diagonal win is present' do
      it 'returns true' do
        grid = [['O', 'O', '#', 'O', '#', 'O'], ['O', '#', 'O', '#', '#', '#'], ['O', 'O', 'O', 'O', '#', 'O'], ['O', 'O', 'O', 'O', '#', '#'], ['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O', 'O']]
        expect(subject.diagonal_win(grid, player)).to be true
      end
    end

    context 'when no win is present' do
      it 'returns false' do
        grid = [['O', 'O', 'O', 'O', '#', 'O'], ['O', 'O', '#', '#', '#', '@'], ['O', 'O', 'O', 'O', '#', 'O'], ['O', 'O', 'O', 'O', '#', 'O'], ['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O', 'O'], ['O', 'O', 'O', 'O', 'O', 'O']]
        expect(subject.diagonal_win(grid, player)).to be false
      end
    end
  end
end