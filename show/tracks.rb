track :nothing do
  frame_rate 50
  music_file 'wow.m4a'

  at 0 do
    start_music
    run Sequences::Static, :on => :bottom_strip, :repeat => true
    modify Modifiers::Pulsate, :on => :bottom_strip, :repeat => 5, :options => {:speed => 30} do
      run Sequences::Static, :on => :bottom_strip, :options => {:color => State[:off]}
      run Sequences::Worm,
        :on => :bottom_strip,
        :repeat => false,
        :options => {
          :worm_length => 10,
          :worm_colors => [
            Color[255,0,0],
            Color[255,127,0],
            Color[255,255,0],
            Color[0,255,0],
            Color[0,0,255],
            Color[75,0,130],
            Color[143,0,255]
          ],
          :mirror => true,
          :number_of_worms => 500,
          :gap_between_worms => 6
        }
      run Sequences::Worm,
        :on => :top_strip,
        :repeat => false,
        :options => {
          :worm_length => 4,
          :color => Color[255,255,255],
          :mirror => true,
          :number_of_worms => 500,
          :gap_between_worms => 6
        }
    end
  end

  at 15.4 do
    modify Modifiers::FadeOut, :on => :bottom_strip do
      stop :bottom_strip
    end
    modify Modifiers::FadeOut, :on => :top_strip do
      stop :top_strip
    end
  end

  at 20 do
    run Sequences::Static, :on => :spot1, :repeat => 15, :options => {:color => Color[255,255,0]} do
      run Sequences::Static, :on => :spot3, :repeat => 15, :options => {:color => Color[0,255,255]} do
        run Sequences::Static, :on => :spot5, :repeat => 15, :options => {:color => Color[255,0,255]} do
          run Sequences::Static, :on => :spot7, :repeat => 15, :options => {:color => Color[255,255,0]} do
            run Sequences::Static, :on => :spot9, :repeat => 15, :options => {:color => Color[255,255,255]} do
              run Sequences::Static, :on => :spot11, :repeat => 15, :options => {:color => Color[255,0,0]} do
                run Sequences::Static, :on => :spot13, :repeat => 15, :options => {:color => Color[0,0,255]} do
                  run Sequences::Static, :on => :spot15, :repeat => 15, :options => {:color => Color[0,255,0]}
                end
              end
            end
          end
        end
      end
    end
  end


end
