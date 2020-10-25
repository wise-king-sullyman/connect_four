# frozen_string_literal: true

require './lib/connect_four.rb'

describe Player do
  before do
    allow($stdout).to receive(:write)
  end

  subject { Player.new('player 1', '@') }
  describe '#request_input' do
    it 'asks the user for input' do
      output_string = "player 1 enter a number 1 - 7 to pick a column\n"
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
      grid_example = [
        %w[O O O O O O], %w[O O O O O O], %w[O O O O O O], %w[O O O O O O],
        %w[O O O O O O], %w[O O O O O O], %w[O O O O O O]
      ]
      expect(subject.create_grid).to eql(grid_example)
    end
  end

  describe '#to_s' do
    it 'returns grid in a readable pattern' do
      grid_example =
        " 1  2  3  4  5  6  7\n O  O  O  O  O  O  O \n O  O  O  O  O  O  O \n"\
       " O  O  O  O  O  O  O \n O  O  O  O  O  O  O \n O  O  O  O  O  O  O \n"\
        " O  O  O  O  O  O  O \n"
      expect(subject.to_s).to eq(grid_example)
    end
  end

  describe '#update' do
    let(:player) { Player.new('player 1', '#') }
    context 'when column is empty' do
      it 'adds symbol to last row of desired column' do
        grid_example = [
          %w[O O O O O O], %w[O O O O O #], %w[O O O O O O], %w[O O O O O O],
          %w[O O O O O O], %w[O O O O O O], %w[O O O O O O]
        ]
        subject.update(1, player.symbol)
        expect(subject.instance_variable_get('@grid')).to eql(grid_example)
      end
    end

    context 'when column is partially blank' do
      it 'adds symbol to next available slot in column' do
        existing_grid = [
          %w[O O O O O O], %w[O O O O @ #], %w[O O O O O O], %w[O O O O O O],
          %w[O O O O O O], %w[O O O O O O], %w[O O O O O O]
        ]
        grid_example = [
          %w[O O O O O O], %w[O O O # @ #], %w[O O O O O O], %w[O O O O O O],
          %w[O O O O O O], %w[O O O O O O], %w[O O O O O O]
        ]
        subject.instance_variable_set('@grid', existing_grid)
        subject.update(1, player.symbol)
        expect(subject.instance_variable_get('@grid')).to eql(grid_example)
      end
    end

    context 'when column is full' do
      it 'does not change the grid' do
        existing_grid = [
          %w[O O O O O O], %w[# # @ # @ #], %w[O O O O O O], %w[O O O O O O],
          %w[O O O O O O], %w[O O O O O O], %w[O O O O O O]
        ]
        grid_example = [
          %w[O O O O O O], %w[# # @ # @ #], %w[O O O O O O], %w[O O O O O O],
          %w[O O O O O O], %w[O O O O O O], %w[O O O O O O]
        ]
        subject.instance_variable_set('@grid', existing_grid)
        subject.update(1, player.symbol)
        expect(subject.instance_variable_get('@grid')).to eql(grid_example)
      end

      it 'prints column full' do
        existing_grid = [
          %w[O O O O O O], %w[# # @ # @ #], %w[O O O O O O], %w[O O O O O O],
          %w[O O O O O O], %w[O O O O O O], %w[O O O O O O]
        ]
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
    allow($stdout).to receive(:write)
  end

  subject { Game.new }

  describe '#welcome' do
    it 'prints the welcome message' do
      expect do
        subject.welcome
      end.to output("Welcome to connect four!\n").to_stdout
    end
  end

  describe '#end_message' do
    let(:player) { Player.new('player 1', '#') }
    context 'when game ended in a tie' do
      it 'prints tie game' do
        subject.instance_variable_set('@winner', true)
        expect { subject.end_message }.to output("Tie Game!\n").to_stdout
      end
    end

    context 'when game ended in a win' do
      it 'prints {winner} won!' do
        subject.instance_variable_set('@winner', player)
        expect { subject.end_message }.to output("player 1 Won!\n").to_stdout
      end
    end
  end

  describe '#game_over' do
    let(:player) { Player.new('player 1', '#') }
    context 'when a column win is present' do
      it 'returns winning player' do
        grid = [
          %w[O O O O O O], %w[O # # # # O], %w[O O O O O O], %w[O O O O O O],
          %w[O O O O O O], %w[O O O O O O], %w[O O O O O O]
        ]
        expect(subject.game_over(grid, player)).to equal(player)
      end
    end

    context 'when a row win is present' do
      it 'returns winning player' do
        grid = [
          %w[O O O O # O], %w[O O O O # O], %w[O O O O # O], %w[O O O O # O],
          %w[O O O O O O], %w[O O O O O O], %w[O O O O O O]
        ]
        expect(subject.game_over(grid, player)).to equal(player)
      end
    end

    context 'when an upper diagonal win is present' do
      it 'returns winning player' do
        grid = [
          %w[O O O O # #], %w[O O # # # @], %w[O O # # O O], %w[O O # O # O],
          %w[O O O O O O], %w[O O O O O O], %w[O O O O O O]
        ]
        expect(subject.game_over(grid, player)).to equal(player)
      end
    end

    context 'when a lower diagonal win is present' do
      it 'returns winning player' do
        grid = [
          %w[O O # O @ O], %w[O # O # # #], %w[O O O O # O], %w[O O O O # #],
          %w[O O O O O O], %w[O O O O O O], %w[O O O O O O]
        ]
        expect(subject.game_over(grid, player)).to equal(player)
      end
    end

    context 'when the game is ended with a tie' do
      it 'returns true' do
        grid = [
          %w[# @ # @ # @], %w[@ # @ # # #], %w[@ # @ # @ #], %w[@ # @ # @ #],
          %w[# @ # @ # @], %w[# # # @ @ #], %w[@ # # @ # #]
        ]
        expect(subject.game_over(grid, player)).to eql(true)
      end
    end

    context 'when the game is not over' do
      it 'returns false' do
        grid = [
          %w[O O O O # O], %w[O O # # # @], %w[O O O O @ @],
          %w[O O O O # O], %w[O O O O O O], %w[O O O O O O], %w[O O O O O O]
        ]
        expect(subject.game_over(grid, player)).to be false
      end
    end
  end

  describe '#play' do
    let(:players) { subject.instance_variable_get('@players') }

    context 'when player 1 gets a column win' do
      it 'returns "player 1"' do
        allow(players.first).to receive(:gets).and_return(
          1.to_s,
          1.to_s,
          1.to_s,
          1.to_s
        )
        allow(players.last).to receive(:gets).and_return(
          2.to_s,
          2.to_s,
          2.to_s,
          2.to_s
        )
        expect(subject.play.name).to eql('player 1')
      end
    end

    context 'when player 1 gets a row win' do
      it 'returns "player 1"' do
        allow(players.first).to receive(:gets).and_return(
          1.to_s,
          2.to_s,
          3.to_s,
          4.to_s
        )
        allow(players.last).to receive(:gets).and_return(
          1.to_s,
          2.to_s,
          3.to_s,
          4.to_s
        )
        expect(subject.play.name).to eql('player 1')
      end
    end

    context 'when player 1 gets a diagonal win' do
      it 'returns "player 1"' do
        allow(players.first).to receive(:gets).and_return(
          1.to_s,
          2.to_s,
          3.to_s,
          3.to_s,
          4.to_s,
          4.to_s
        )
        allow(players.last).to receive(:gets).and_return(
          2.to_s,
          2.to_s,
          3.to_s,
          4.to_s,
          4.to_s
        )
        expect(subject.play.name).to eql('player 1')
      end
    end

    context 'when player 2 gets a diagnoal win' do
      it 'returns "player 2"' do
        allow(players.first).to receive(:gets).and_return(
          1.to_s,
          1.to_s,
          2.to_s,
          3.to_s,
          5.to_s,
          5.to_s
        )
        allow(players.last).to receive(:gets).and_return(
          1.to_s,
          1.to_s,
          2.to_s,
          2.to_s,
          3.to_s,
          4.to_s
        )
        expect(subject.play.name).to eql('player 2')
      end
    end

    context 'when game ends in tie' do
      it 'returns true' do
        board = Board.new
        board.grid = [
          %w[# @ # @ # @], %w[@ # @ # # #], %w[@ # @ # @ #], %w[@ # @ # @ #],
          %w[# @ # @ # @], %w[# # # @ @ #], %w[@ # # @ # #]
        ]
        subject.instance_variable_set('@board', board)
        allow(players.first).to receive(:gets).and_return(1.to_s)
        allow(players.last).to receive(:gets).and_return(1.to_s)
        expect(subject.play).to eql(true)
      end
    end
  end
end
