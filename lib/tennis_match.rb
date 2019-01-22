require 'byebug'

class TennisMatch
  attr_accessor :p1_name, :p2_name, :game_score, :set_score, :match_winner

  def initialize(p1, p2)
    @p1_name = p1
    @p2_name = p2
    @game_score = [0, 0]
    @set_score = [0, 0]
    @match_winner = nil
  end

  def score
    return "#{display_set_score}, Deuce" if deuce?
    return "#{display_set_score}, Advantage #{advantage_player}" if advantage?
    return "#{display_set_score}" if won_set?
    fresh_game? ? "#{display_set_score}" : "#{display_set_score}, #{display_game_score}"
  end

  def point_won_by(player_name)
    return if match_winner
    calculate_game_score(player_name)
    check_game
    check_set
  end

  private

  def calculate_game_score(player_name)
    case player_name
      when p1_name
        game_score[0] += 1
      when p2_name
        game_score[1] += 1
      else
        puts 'undefined player name'
    end
  end

  def check_game
    if won_game?
      # calculate set score
      game_score[0] > game_score[1] ? set_score[0] += 1 : set_score[1] += 1
      # game over, start a new game
      game_score.map!{ | x | x = 0 }
    end
  end

  def check_set
    puts 'Tie break' if tie_break?
    if won_set?
    #  match over, winner
      @match_winner = set_score[0] > set_score[1] ? p1_name : p2_name
    end
  end

  def points_to_score(points)
    case points.to_i
      when 1
        15
      when 2
        30
      when 3
        40
      else
        points
    end
  end

  # game methods
  def fresh_game?
    game_score[0].zero? && game_score[1].zero?
  end

  def won_game?
    normal_game_won? || tie_break_game_won?
  end

  def normal_game_won?
    !tie_break? && game_score.max >= 4 && (game_score[0] - game_score[1]).abs >= 2
  end

  def tie_break_game_won?
    tie_break? && game_score.max >= 7 && (game_score[0] - game_score[1]).abs >= 2
  end

  def deuce?
    !tie_break? && (game_score[0] >= 3) && (game_score[0] == game_score[1])
  end

  def advantage?
    game_score.min >= 3 && (game_score[0] - game_score[1]).abs == 1
  end

  def display_game_score
    return game_score.join('-') if tie_break? || game_score.max >= 4
    game_score.map {|score| points_to_score(score) }.join('-')
  end

  def advantage_player
    game_score[0] > game_score[1] ? p1_name : p2_name
  end

  # set methods
  def won_set?
    tie_break_set_won? || normal_set_won?
  end

  def normal_set_won?
    set_score.max >= 6 && (set_score[0] - set_score[1]).abs >= 2
  end

  def tie_break_set_won?
    set_score.max ==7 && set_score.min == 6
  end

  def tie_break?
    set_score[0] == set_score[1] && set_score[0] == 6
  end

  def display_set_score
    set_score.join('-')
  end
end