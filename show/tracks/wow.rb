track :wow do
  frame_rate 70
  music_file 'wow.m4a'

  at 0 do
    start_music
    run :worm, :on => :bottom_strip, :repeat => false, :options => {:worm_length => 10, :color => Color[255,255,255], :number_of_worms => 50, :gap_between_worms => 25}
    run :worm, :on => :top_strip, :repeat => false, :options => {:worm_length => 25, :worm_colors => [Color[255,0,0], Color[255,127,0], Color[255,255,0], Color[0,255,0], Color[0,0,255], Color[75,0,130], Color[143,0,255]], :randomize_color => false, :number_of_worms => 50, :gap_between_worms => 0, :fade_tail => false}
  end

  at 8.6 do
    run :off, :on => :top_strip
    run :off, :on => :bottom_strip
  end

  at 10.78 do
    run :strobe, :on => :top_strip, :repeat => true, :options => {:color => Color[0,0,255]}
  end

  at 12.76 do
    run :off, :on => :top_strip
    run :strobe, :on => :bottom_strip, :repeat => true, :options => {:color => Color[255,255,0]}
  end

  at 16.2 do
    run :off, :on => :bottom_strip
    run :flash, :on => :spot1, :options => {:color => Color[255,0,0]}
  end

  at 17.2 do
    run :flash, :on => :spot3, :options => {:color => Color[255,255,0]}
  end

  at 18.2 do
    run :flash, :on => :spot5, :options => {:color => Color[255,0,255]}
  end

  at 19.2 do
    run :flash, :on => :spot7, :options => {:color => Color[255,128,0]}
  end

  at 20.2 do
    run :flash, :on => :spot9, :options => {:color => Color[0,255,128]}
  end

  at 21.2 do
    run :flash, :on => :spot11, :options => {:color => Color[255,0,128]}
  end

  at 22.2 do
    run :flash, :on => :spot13, :options => {:color => Color[255,0,0]}
  end

  at 23.2 do
    run :flash, :on => :spot15, :options => {:color => Color[0,255,0]}
  end

  at 24.4 do
    run :flash, :on => :top_strip, :options => {:color => Color[128,128,128]}
    run :flash, :on => :bottom_strip, :options => {:color => Color[128,128,128]}
  end

  at 31.7 do
    run :flash, :on => :top_strip, :options => {:color => Color[0,0,255]}
    run :worm,
      :on => :bottom_strip,
      :repeat => false,
      :options => {
        :worm_length => 3,
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
        :gap_between_worms => 3
      }
  end

  at 35.7 do
    run :flash, :on => :top_strip, :options => {:color => Color[0,255,0]}
  end

  at 39.7 do
    run :flash, :on => :top_strip, :options => {:color => Color[255,0,0]}
  end

  at 47.48 do
    stop :bottom_strip
    run :off, :on => :top_strip
  end

  at 160 do
    stop_music
    finish
  end

end
