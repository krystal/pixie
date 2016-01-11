track :raindown do
  frame_rate 60
  music_file 'raindown.m4a'

  at 0 do
    start_music
    modify Modifiers::FadeIn, :on =>:bottom_strip, :options => {:speed => 100} do
      modify Modifiers::Pulsate, :on => :bottom_strip, :reverse => true, :repeat => true, :options => {:speed => 30}
    end
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
  end

  at 9 do
    run Sequences::Worm,
      :on => :top_strip,
      :repeat => false,
      :options => {
        :worm_length => 4,
        :color => Color[255,255,255].brightness(50),
        :mirror => true,
        :number_of_worms => 500,
        :gap_between_worms => 3
      }
  end

  at 20 do
    finish
    stop_music
  end

end
