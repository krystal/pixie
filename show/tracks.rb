track :nothing do
  frame_rate 50
  music_file 'wow.m4a'

  at 0 do
    start_music
    run :Static, :on => :bottom_strip, :repeat => true
    modify :Pulsate, :on => :bottom_strip, :repeat => 5, :options => {:speed => 30} do
      run :Static, :on => :bottom_strip, :options => {:color => State[:off]}
      run :Worm,
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
      run :Worm,
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
    modify :FadeOut, :on => :bottom_strip do
      stop :bottom_strip
    end
    modify :FadeOut, :on => :top_strip do
      stop :top_strip
    end
  end

  at 20 do
    run :Static, :on => :spot1, :repeat => 15, :options => {:color => Color[255,255,0]} do
      run :Static, :on => :spot3, :repeat => 15, :options => {:color => Color[0,255,255]} do
        run :Static, :on => :spot5, :repeat => 15, :options => {:color => Color[255,0,255]} do
          run :Static, :on => :spot7, :repeat => 15, :options => {:color => Color[255,255,0]} do
            run :Static, :on => :spot9, :repeat => 15, :options => {:color => Color[255,255,255]} do
              run :Static, :on => :spot11, :repeat => 15, :options => {:color => Color[255,0,0]} do
                run :Static, :on => :spot13, :repeat => 15, :options => {:color => Color[0,0,255]} do
                  run :Static, :on => :spot15, :repeat => 15, :options => {:color => Color[0,255,0]}
                end
              end
            end
          end
        end
      end
    end
  end

  at 30.8 do
    modify :FadeOut, :on => :spot1
    modify :FadeOut, :on => :spot3
    modify :FadeOut, :on => :spot5
    modify :FadeOut, :on => :spot7
    modify :FadeOut, :on => :spot9
    modify :FadeOut, :on => :spot11
    modify :FadeOut, :on => :spot13
    modify :FadeOut, :on => :spot15
  end


end
