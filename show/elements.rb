element :bottom_strip do
  unit        1
  leds        (0..59).to_a
end

element :top_strip do
  unit        2
  leds        (0..59).to_a
end

15.times do |i|
  element "spot#{i + 1}".to_sym do
    i = i * 4
    unit  1
    pin   9
    leds  [
      60 + i, 61 + i, 62 + i, 63 + i,
      59 - i, 58 - i, 57 - i, 56 -i
    ]
  end
end
