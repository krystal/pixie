# Pixie

Pixie is software to run an LED light show. It's written in Ruby and provides
an easy to use DSL for programming your whole show. We're hoping to use this
to control and orchestrate a 8,000 LED show during the year.

At the moment, this is still heavily under construction and likely broken in
lots of ways we haven't even thought of yet.

## Hardware

The software is designed to send packets over UDP to ethernet connected devices
(currently Arduinos) which will send data onto strips of LEDs as appropriate.

We're using Arduinos at the moment but strugging with performance so we're
looking to replace these with some other soft of network attached microcontroller.

To play audio/music we're currently undecided on how to approach this. At present
the library uses the [Music Player Daemon](http://www.musicpd.org/) however it
leaves much to be desired and we'll look at replacing this soon.

## Creating a Show

All Pixie shows are stored in directory and contain a number of Ruby-like files
which define the hardware you're using in your show. An example show is provided
in the `show` directory.

### Units

A **unit** is a single microcontroller that's connected to your network. Your
show will probably have a single `units.rb` file which defines all units you're
using.

```ruby
unit :unit1 do
  ip_address '10.0.2.99'
  port 8888
end
```

A unit definition is simple and just contains its IP address and the port that it
is listening on to receive UDP control packets.

### Elements

An element is one or more LEDs which can be addressed by the unit. For example,
if you created a LED shaped tree, you might have an element for the outline of
the tree.

```ruby
element :tree_outline do
  unit :unit1
  leds (1...1000).to_a
end
```

An element definition outlines which unit it is connected to and which LED numbers
it is made up on. This this example, all the LEDs are sequential but they don't
need to be.


### Tracks

All the shows we've created are set to music, therefore each piece of music has
its own script which outlines exactly how the LEDs should behave throughout
the track.

```ruby
track :example do
  frame_rate 50
  audio_file "example.mp3"

  at 0 do
    start_music
    run :Static, :on => :tree_outline, :repeat => true
  end

  at :end do
    clear :tree_outline
  end
end
```

In it's absolutely most basic form, a track might look like the above. This will
simple illuminate all the LEDs around your tree for the duration of the song
and turn them off at the end. This is rather boring but it will help describe
what's going on.

The first thing you'll notice is the `frame_rate`. This is the number of frames
per second that will be pushed out for this track. The actual smooth frame rate
that you can achieve will be based on your hardware performance and the complexity
of your show.

Next up is the `audio_file`. At the moment, this just references a track which
has already been loaded into MPD. This will be replaced.

After this, the script begins. The `at` method allows you to trigger _sequences_
at various points during the track. The first call runs at the start of the show,
and initially starts playing the music.

Once the music has started, we will `run` a sequence named `Static`. When you run
a sequence, Pixie will ask it which LEDs should be illuminated at every frame that
it is active in the track. The static sequence is a very simple one-frame sequence
that simply says that all LEDs on the provided element should be illuninated in a
single colour (by default, white). We use the repeat option to run this sequence
indefinitely so every frame from the beginning is on. More about sequences later.

Finally, at the end of the track, we use the `clear` command to turn off all
the LEDs on the `tree_outline` element.

### Built-in Sequences

There are a few built-in sequences which one use. All of these have defaults
which allow them to easily be slipped into a program. Additional information
about each of these can be found in the `doc/sequences` folder.

* `Strobe` - a fast flash
* `Static` - a single solid colour
* `Worm` - a moving "worm" which moves along/around a strip of sequential LEDs


### Modifiers

A modifier allows you to adjust how a sequence performance. For example, you
can use a modifier to fade in or out of a sequence. Here's an example of the
track above but with a fade in at the start and a fade out at the end.

```ruby
at 0 do
  run :Static, :on => :tree_outline, :repeat => true
  modify :FadeIn, :on => :tree_outline
end

at :end do
  modify :FadeOut, :on => :tree_outline
end
```

#### Built-in modifiers

There are a number of built-in modifiers which one can use. Additional information
about each of these can be found in the `doc/modifiers` folder.

* `FadeIn` - fade in
* `FadeOut` - fade out
* `Pulsate` - a fade in folldered by a fade out (starting from dark)

### Options

Both sequences and modifiers can accept options when they are defined in the
track's script. Here's an example, where we change the speed of the fade and the
colour of the static light.

```ruby
at 0 do
  run Sequences::Static, :on => :tree_outline, :repeat => true, :options => {:color => Color[0,0,255]}
  modify Modifiers::FadeIn, :on => :tree_outline, :options => {:speed => 240}
end
```

Here you'll see that we've set the color of the static sequence to be blue and
set the fade in to be over 240 frames.

### Colors & States

In the last section, you'll have seen we called `Color[0,0,255]`. Whenever you
reference a colour of LED state in Pixie, you must do so through the `Color`
or `State` methods.

```ruby
# To specify a specific colour
Color[255,255,0]

# To use standard red, blue or green
State[:red]
State[:green]
State[:blue]

# To turn an LED on (white) or off
State[:on]
State[:off]
```
