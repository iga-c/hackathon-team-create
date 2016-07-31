Participant = Struct.new(:name, :score)

def init
  participants_array = []
  
  loop do
    input_text = gets.chomp
    break if input_text == ""
    name, score = input_text.split(' ')
    participants_array << Participant.new(name, score.to_f)
  end

  participants_array
end

# スコア合計値の(最大-最小)が1以内
def scoreMinMaxValidate(team_array)
  max_score = 0
  min_score = 999999

  team_array.each do |team|
    team_score = 0

    team.each do |p|
      team_score += p.score
    end

    max_score = [max_score, team_score].max
    min_score = [min_score, team_score].min
  end

  max_score - min_score <= 1.000001 # 誤差は適当
end

# 企画メンバーがチーム内に最大2人までになっているか
def plannerDiffTeamValidate(team_array)
  planner_list = ["snakazawa", "uryoya", "kaseiaoki", "iga-c"] # とりあえずgithubのID
  team_array.each do |team|
    targets = team.select { |p| planner_list.include?(p.name) }
    return false if targets.length > 2
  end

  true
end

# N氏とigaが同じチームでないようにする
def igaNValidate(team_array)
  iga_n_list = ["snakazawa", "iga-c"] # とりあえずgithubのID
  team_array.each do |team|
    targets = team.select { |p| iga_n_list.include?(p.name) } 
    return false if targets.length == 2
  end

  true
end

if __FILE__ == $0
  participants_array = init()
  valid_team_list = []

  (0...100000).each do |i|
    shuffle_participants_array = participants_array.shuffle
    team_array = shuffle_participants_array.each_slice(3).to_a
    
    # 参加者数が3で割り切れなかったら4人チームにする。8人以下は考慮していない。
    if team_array[-1].length != 3
      (0...team_array[-1].length).each do |idx|
        team_array[idx] << team_array[-1][idx]
      end
      team_array.delete_at(-1)
    end

    
    next unless scoreMinMaxValidate(team_array)
    next unless plannerDiffTeamValidate(team_array)
    next unless igaNValidate(team_array)
    valid_team_list << team_array
  end

  used_team_list = valid_team_list.sample
  
  used_team_list.each_with_index do |team, idx|
    print("Team #{idx+1}\n")
    team.each do |p|
      print("・#{p.name}\n")
    end
    print("\n")
  end
end
