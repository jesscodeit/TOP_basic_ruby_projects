require './lib/connect_four'

describe ConnectFour do
  subject(:the_game) { described_class.new }

  describe '#get_play' do
    context 'when input is a valid column, and column is not full' do
      before do
        valid_input = 5
        allow(the_game).to receive(:puts_choose_column)
        allow(the_game).to receive(:get_player_input).and_return(valid_input)
      end

      it 'does not display error message' do
        expect(the_game).not_to receive(:puts)
        the_game.get_play
      end
    end

    context 'when input is a valid column but column is full, and next input is valid' do
      before do
        first_input = 0
        second_input = 5
        the_game.cage = [[1,2,3,4,5,6], [], [], [], [], [], []]
        allow(the_game).to receive(:puts_choose_column)
        allow(the_game).to receive(:get_player_input).and_return(first_input, second_input)
      end

      it 'displays error message once' do
        expect(the_game).to receive(:puts).once
        the_game.get_play
      end
    end
  end

  describe '#add_to_cage' do
    context 'when method run with a valid column choice' do
      it 'adds player coin to the cage column of choice' do
        column = 0
        expect(the_game.cage[column]).not_to be_nil
        the_game.add_to_cage(column)
      end
    end
  end

  describe '#tie?' do
    context 'when cage has no spots remaining' do
      before do
        the_game.cage = [[1,2,3,4,5,6], [1,2,3,4,5,6], [1,2,3,4,5,6], [1,2,3,4,5,6], [1,2,3,4,5,6], [1,2,3,4,5,6], [1,2,3,4,5,6]]
      end

      it 'returns true' do
        expect(the_game.tie?).to be true
      end 
    end

    context 'when cage still has available spots' do
      it 'returns false' do
        expect(the_game.tie?).to be false
      end
    end
  end

  describe '#winner?' do
    context 'when there is a row alignment of four coins' do
      before do
        the_game.cage = [["⚫"],["⚫"],["⚫"],["⚫"],[],[]]
        the_game.last_drop = 1
      end
      it 'returns true' do
        expect(the_game.winner?).to be true
      end
    end

    context 'when there is a column alignment of four coins' do
      before do 
        the_game.cage = [["⚫", "⚫", "⚫", "⚫"],[],[],[],[],[]]
        the_game.last_drop = 0
      end

      it 'returns true' do
        expect(the_game.winner?).to be true
      end
    end

    context 'when there is a diagonal alignment of four coins' do
      before do
        the_game.cage = [["⚫"],["⚪","⚫"],["⚪","⚪","⚫"],["⚪","⚪","⚪","⚫"],[],[]]
        the_game.last_drop = 2
      end

      it 'returns true' do
        expect(the_game.winner?).to be true
      end
    end

    context 'when there are no coin alignments of atleast four' do
      before do
        the_game.cage = [["⚫"],["⚪","⚫"],["⚫","⚪"],["⚪"],["⚫"],["⚪"]]
        the_game.last_drop = 1
      end

      it 'returns false' do
        expect(the_game.winner?).to be false
      end
    end
  end

  describe '#game_over?' do
    context 'if game is tied' do
      it 'returns true' do
        allow(the_game).to receive(:tie?).and_return(true)
        expect(the_game.game_over?).to be true
      end
    end

    context 'if a player has won' do
      it 'returns true' do
        allow(the_game).to receive(:tie?).and_return(false)
        allow(the_game).to receive(:winner?).and_return(true)
        expect(the_game.game_over?).to be true
      end
    end

    context 'if no winner and no tie' do
      it 'returns false' do
        allow(the_game).to receive(:tie?).and_return(false)
        allow(the_game).to receive(:winner?).and_return(false)
        expect(the_game.game_over?).to be false
      end
    end
  end

  describe '#switch_player' do
    before do
      the_game.player_up = @player1
    end

    context 'if player_up is ⚫' do
      it 'changes player_up to ⚪' do
        expect(the_game.player_up).to be(@player2)
      end
    end

    context 'if player_up is ⚪' do
      before do
        the_game.player_up = @player2
      end

      it 'changes player_up to ⚫' do
        expect(the_game.player_up).to be(@player1)
      end
    end
  end

end