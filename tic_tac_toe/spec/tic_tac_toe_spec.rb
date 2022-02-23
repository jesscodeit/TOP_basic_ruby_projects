require './lib/tic_tac_toe'

describe Game do
  subject(:game) { described_class.new }

  describe '#get_spot_choice' do
    context 'when given valid input' do
      before do
        valid_input = '1'
        allow(game).to receive(:player_input).and_return(valid_input)
      end

      it 'stops loop and does not display error message' do
        error = "\nERROR! Please pick a number (1-9) that has not already been marked."
        expect(game).not_to receive(:puts).with(error)
        game.get_spot_choice
      end
    end

    context 'when given invalid input once' do
      before do
        invalid_input = 'a'
        valid_input = '9'
        allow(game).to receive(:player_input).and_return(invalid_input, valid_input)
      end

      it 'completes loop, displays error message once' do 
        error = "\nERROR! Please pick a number (1-9) that has not already been marked."
        expect(game).to receive(:puts).with(error).once
        game.get_spot_choice
      end
    end
  end

  describe '#switch' do
    context 'when current player is X' do 
      before do
        @current_p = @player_x
        allow(game).to receive(:switch).and_return(@current_p)
      end

      it 'switches current player to O' do
        expect(@current_p).to be(@player_o)
      end
    end

    context 'when curent player is O' do
      before do 
        @current_p = @player_o
        allow(game).to receive(:switch).and_return(@current_p)
      end

      it 'switches current player to X' do
        expect(@current_p).to be(@player_x)
      end
    end
  end

  describe '#tie?' do
    context 'when there are no open spots remaining' do 
      before do
        game.board = ['X', 'O', 'X', 'O', 'X', 'O', 'O', 'X', 'O']
      end

      it 'returns true' do
        answer = game.tie?
        expect(answer).to be(true)
      end
    end

    context 'when there are still open spots' do
      before do
        game.board = [1, 2, 3, 'O', 'X', 'O', 'O', 'X', 'O']
      end

      it 'returns false' do
        answer = game.tie?
        expect(answer).to be(false)
      end
    end
  end

  describe '#winner?' do
    context 'when there is no winner' do
      before do
        game.board = [1,2,3,4,5,6,7,8,9]
        allow(@current_p).to receive(:mark).and_return('X')
      end

      it 'returns false' do
        answer = game.winner?(@current_p)
        expect(answer).to be(false)
      end
    end

    context 'when there is a horizontal win' do
      before do
        game.board = ['X', 'X', 'X', 4, 5, 6, 7, 8, 9]
        allow(@current_p).to receive(:mark).and_return('X')
      end
      
      it 'returns true' do
        answer = game.winner?(@current_p)
        expect(answer).to be(true)
      end
    end

    context 'when there is a vertical win' do
      before do
        game.board = ['X', 2, 3, 'X', 5, 6, 'X', 8, 9]
        allow(@current_p).to receive(:mark).and_return('X')
      end

      it 'returns true' do
        answer = game.winner?(@current_p)
        expect(answer).to be(true)
      end
    end

    context 'when there is a diagonal win' do
      before do
        game.board = ['X', 2, 3, 4, 'X', 6, 7, 8, 'X']
        allow(@current_p).to receive(:mark).and_return('X')
      end

      it 'returns true' do
        answer = game.winner?(@current_p)
        expect(answer).to be(true)
      end
    end
  end

  describe '#reset_game' do
    context 'when reset_game is called' do
      before do
        game.board = ['X', 2, 3, 4, 'X', 6, 7, 8, 'X']
        @current_p = @player_o
      end

      it 'resets the board' do
        game.reset_game
        expect(game.board).to eq([1,2,3,4,5,6,7,8,9])
      end

      it 'resets current player to X' do
        game.reset_game
        expect(@current_p).to be(@player_x)
      end
    end
  end
end