require 'io/console'

# Keyboard Input module
module KBInput
  def kb_select(current_pos = [0, 0])
    input = ''
    marked = []
    cur_mark = []
    until input == "\r"
      input = STDIN.getch
      case input
      when 'w'
        current_pos[0] -= 1 if current_pos[0].between?(1, 7)
      when 'a'
        current_pos[1] -= 1 if current_pos[1].between?(1, 7)
      when 's'
        current_pos[0] += 1 if current_pos[0].between?(0, 6)
      when 'd'
        current_pos[1] += 1 if current_pos[1].between?(0, 6)
      when 'm'
        marked << current_pos.dup
      when "\r"
        cur_mark = current_pos
      when 'q'
        exit
      end
      # Print board with new cursor position
      board.render(current_pos, '', marked + cur_mark)
    end

    { current_pos: current_pos, marked: marked }
  end
end
