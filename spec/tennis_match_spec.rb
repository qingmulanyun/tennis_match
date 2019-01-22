require 'tennis_match'

describe TennisMatch do
  let(:tennis_match) { described_class.new('p1', 'p2') }

  describe '#point_won_by #score' do
    context 'when pass a player as an argument' do
      it 'set a game score for the player' do
        tennis_match.point_won_by('p1')
        expect(tennis_match.score).to eql("0-0, 15-0")
      end
    end

    context 'when the score is 40-40' do
      it 'returns Deuce' do
        tennis_match.point_won_by('p1')
        tennis_match.point_won_by('p1')
        tennis_match.point_won_by('p1')
        tennis_match.point_won_by('p2')
        tennis_match.point_won_by('p2')
        tennis_match.point_won_by('p2')
        expect(tennis_match.score).to eql("0-0, Deuce")
      end
    end

    context 'when the score is Deuce' do
      it 'returns Deuce' do
        tennis_match.point_won_by('p1')
        tennis_match.point_won_by('p1')
        tennis_match.point_won_by('p1')
        tennis_match.point_won_by('p2')
        tennis_match.point_won_by('p2')
        tennis_match.point_won_by('p2')
        tennis_match.point_won_by('p1')
        tennis_match.point_won_by('p2')
        tennis_match.point_won_by('p1')
        tennis_match.point_won_by('p2')
        tennis_match.point_won_by('p1')
        tennis_match.point_won_by('p2')
        expect(tennis_match.score).to eql("0-0, Deuce")
      end
    end

    context 'when p1 scores after Deuce' do
      it 'returns Advantage player 1' do
        tennis_match.point_won_by('p1')
        tennis_match.point_won_by('p1')
        tennis_match.point_won_by('p1')
        tennis_match.point_won_by('p2')
        tennis_match.point_won_by('p2')
        tennis_match.point_won_by('p2')
        tennis_match.point_won_by('p1')
        expect(tennis_match.score).to eql("0-0, Advantage p1")
      end
    end

    context 'when p2 scores after Deuce' do
      it 'returns Advantage player 2' do
        tennis_match.point_won_by('p1')
        tennis_match.point_won_by('p1')
        tennis_match.point_won_by('p1')
        tennis_match.point_won_by('p2')
        tennis_match.point_won_by('p2')
        tennis_match.point_won_by('p2')
        tennis_match.point_won_by('p2')
        expect(tennis_match.score).to eql("0-0, Advantage p2")
      end
    end

    context 'when p1 scores 2 points in a row after Deuce' do
      it 'returns set score' do
        tennis_match.point_won_by('p1')
        tennis_match.point_won_by('p1')
        tennis_match.point_won_by('p1')
        tennis_match.point_won_by('p2')
        tennis_match.point_won_by('p2')
        tennis_match.point_won_by('p2')
        tennis_match.point_won_by('p1')
        tennis_match.point_won_by('p1')
        expect(tennis_match.score).to eql("1-0")
      end
    end

    context 'when p1 wons 2 games' do
      it 'returns set score' do
        # p1 won first game
        tennis_match.point_won_by('p1')
        tennis_match.point_won_by('p1')
        tennis_match.point_won_by('p1')
        tennis_match.point_won_by('p1')
        tennis_match.score
        # p1 won second game
        tennis_match.point_won_by('p1')
        tennis_match.point_won_by('p1')
        tennis_match.point_won_by('p1')
        tennis_match.point_won_by('p1')
        expect(tennis_match.score).to eql("2-0")
      end
    end

    context 'when p1 wins 6 games and 2 games more than the opponent' do
      before { tennis_match.instance_variable_set(:@set_score, [5, 4]) }
      it 'returns match winner p1' do
        tennis_match.point_won_by('p1')
        tennis_match.point_won_by('p1')
        tennis_match.point_won_by('p1')
        tennis_match.point_won_by('p1')
        expect(tennis_match.score).to eql("6-4")
        expect(tennis_match.match_winner).to eql("p1")
      end
    end

    context 'when p2 wins 6 games and 2 games more than the opponent' do
      before { tennis_match.instance_variable_set(:@set_score, [4, 5]) }
      it 'returns match winner p2' do

        tennis_match.point_won_by('p2')
        tennis_match.point_won_by('p2')
        tennis_match.point_won_by('p2')
        tennis_match.point_won_by('p2')
        expect(tennis_match.score).to eql("4-6")
        expect(tennis_match.match_winner).to eql("p2")
      end
    end

    context 'when p1 wins 7 games and p2 wins 5 games' do
      before { tennis_match.instance_variable_set(:@set_score, [6, 5]) }
      it 'returns set score' do

        tennis_match.point_won_by('p1')
        tennis_match.point_won_by('p1')
        tennis_match.point_won_by('p1')
        tennis_match.point_won_by('p1')
        expect(tennis_match.score).to eql("7-5")
        expect(tennis_match.match_winner).to eql("p1")
      end
    end

    describe 'tie_breaker' do
      before do
        tennis_match.instance_variable_set(:@set_score, [6, 6])
      end
      context 'when p1 wins 6 games and p2 wins 7 games' do
        it 'returns winner' do
          tennis_match.instance_variable_set(:@set_score, [6, 6])
          tennis_match.point_won_by('p2')
          tennis_match.point_won_by('p2')
          tennis_match.point_won_by('p2')
          tennis_match.point_won_by('p2')
          tennis_match.point_won_by('p2')
          tennis_match.point_won_by('p2')
          tennis_match.point_won_by('p2')

          expect(tennis_match.score).to eql("6-7")
          expect(tennis_match.match_winner).to eql("p2")
        end
      end

      context 'when p1 wins 6 points and p2 wins 6 points' do
        it 'returns current score' do

          tennis_match.point_won_by('p1')
          tennis_match.point_won_by('p1')
          tennis_match.point_won_by('p1')
          tennis_match.point_won_by('p1')
          tennis_match.point_won_by('p1')
          tennis_match.point_won_by('p1')
          tennis_match.point_won_by('p2')
          tennis_match.point_won_by('p2')
          tennis_match.point_won_by('p2')
          tennis_match.point_won_by('p2')
          tennis_match.point_won_by('p2')
          tennis_match.point_won_by('p2')

          expect(tennis_match.score).to eql("6-6, 6-6")
        end
      end

      context 'when p1 wins 7 points by a margin of two or more points.' do
        it 'returns winner' do
          tennis_match.point_won_by('p1')
          tennis_match.point_won_by('p1')
          tennis_match.point_won_by('p1')
          tennis_match.point_won_by('p1')
          tennis_match.point_won_by('p1')
          tennis_match.point_won_by('p1')
          tennis_match.point_won_by('p2')
          tennis_match.point_won_by('p2')
          tennis_match.point_won_by('p2')
          tennis_match.point_won_by('p2')
          tennis_match.point_won_by('p2')
          tennis_match.point_won_by('p2')
          tennis_match.point_won_by('p1')
          tennis_match.point_won_by('p1')
          expect(tennis_match.score).to eql('7-6')
          expect(tennis_match.match_winner).to eql("p1")
        end
      end
    end
  end
end