# Oversized Clock

This Flutter clock is a submission for 
[Flutter Clock challenge](https://flutter.dev/clock).

## Idea

I had the vision of the clock from the very beginning 
but it was quite hard to implement it for real. 

I would want my real Lenovo Clock to be not just a clock
but a part of a design solution of a room as a whole. 
It should be something ambient and flowing but still follow
a modern techy design style: comprise of simple edgy shapes 
and few colors.

In my vision I saw lines and figures slowly moving on the screen,
representing nothing from the first glance, being just a part of 
room decoration. But a closer look would show that it's 
a clock (wow!). It shouldn't be easy to see what time it is exactly 
but still possible. 

I tried out a dozen different fonts, backgrounds and layouts 
to get closer to what I saw in my imagination. 
After some time playing around, I decided not to include
date and weather information, because they didn't 
fit the concept. 

So, this clock is not super informative
but it is supposed to be beautiful.

## Widget Structure Overview

```
// provided by organizers
- MaterialApp
    - AspectRatio
        - ClockCustomizer
            // challenge submission
            - OversizedClock
                - FloatingContainer
                    - Background
                    - Watchface
```

## Modifications of ClockCustomizer

There was a 2px border in ClockCustomizer that was 
removed for a better look.

## Floating container and animation

That's, probably, the most interesting part of the clock.
I wanted to have a moving view box that would float
over a scaled watchface. 

It was decided to move on with a simple `Container` widget
and apply `transform` property with animation to it, 
so the watchface would be scaled and moving at the same time. 

### Size problem

I managed to quickly progress with a scaled part
but there still was an issue with translation (moving) and 
dynamic screen size. I had to know the exact size
of the container in pixels to able to translate-transform it properly. 
It's because this transformation is defined 
in pixels and not relative values like scaling transform. 

So I had to let the first frame render and then get the 
size of it using `SchedulerBinding.instance.addPostFrameCallback`. 
To handle screen rotations and size changes, I used
`SizeChangedLayoutNotifier` and `NotificationListener`.

### Performance optimization of animation

In the beginning, I used `Animation`, `AnimationController`
and `setState` method on every tick of the controller. This 
appeared to be a not very efficient way of animating the widget,
because the watchface was rerendered on every animation tick 
(60 times per second, I guess). There were noticeable glitches, 
especially when the watchface part was not optimized.
That's why I moved on to `AnimatedBuilder` that caches child 
widget: exactly what I needed. Results were great: 
rendering on the emulator went down from 120ms/frame 
to 4ms/frame on average.

### Animation shape - ellipse

By design, there should have been a floating view box and 
an animation should define the trajectory. I was looking into
how animations work in Flutter, played with different kinds of 
`Tween`s. I was on my way to use a combination of `CurveTween`s
when I decided to make my own `EllipseTween` which worked out 
perfectly. It was fun to pick up on a little bit of math.

## Background

Background implementation is quite simple: it's just a linear 
gradient. 

## Watchface

The watchface widget represents two layers:
- front layer showing hour and minute
- back layer showing current weekday with a huge font 
(mostly, for decoration purposes)

### Finding THE font

The watchface should have had some kind of lines and shapes.
Originally, I was playing with a couple of Sans fonts that
were supposed to be quite "tall" and "narrow", have uniform 
lines width and simple shapes. 

While searching for more interesting
fonts I found Freeware 
[Vertigo](https://www.1001fonts.com/vertigo-font.html#styles) font. 
At first, it didn't match my concept
but later on, I tried it again and understood that this is 
exactly what I was looking for.

There was only one problem: the problem of "one". 
Or, to be more precise, of "1". 

### The "1" problem

So in `Vertigo`, like in many other fonts, number `1` is very narrow,
comparing to other characters. It's basically, just a 
tall rectangle. While other characters take a significant amount 
of space, "1" takes almost no space leaving a huge "empty" hole.

The situation becomes even more absurd when you have time `11:11`.
So I had to do something about it, fill the void, so to say.

### Back-layer with weekday

After many different tries, I ended up putting a two-letter 
weekday code as a full-size semi-transparent background. 
It is using a solid version of `Vertigo` font, comparing
to the outlined version used for hours and minutes. 
I believe, it worked out well, giving the background 
some shapes similar to those used as the primary text.
I don't think anyone would be able to read the text of
`MO`, `TU`, etc. but it adds some dynamics for the clock
and maintains (even further develops!) the original concept.

### Going from flexible to scaled pixel-perfect layout

I was trying to use a flexible layout when arranging pieces
of text but it appeared not predictable enough to make 
a pixel-perfect solution. The main problem was around rendering
of the fonts and their ascend/descend which is not configurable.

In the end, I used a big container of 5:3 aspect ratio
and just scaled it down with `FittedBox`.

### Performance optimization

At some point, there was an `Opacity` widget used for the 
back-layer. It appeared to be very inefficient when rendered 
during an animation, so I replaced it with semi-transparent 
versions of white and black colors as a font color.

## Themes

**Disclaimer**: in this clock, I didn't consider themes and colors
as something important for the concept. So I stopped on solutions
"that worked". I was planning to have a dozen themes 
rotating during the day. Unfortunately, I didn't get time to 
find all the nice themes and implement this.

I ended up having a light and a dark theme and the right way would 
be to use theming capabilities of `MaterialApp` widget. I decided
to implement my own simplistic theming mechanism due to two reasons:

* According to the contest rules, it was not allowed to 
modify anything in `flutter_clock_helper`, which contains `MaterialApp`
and defines themes. 
* Flutter's `ThemeData` class does not allow defining gradients for 
the background (I could subclass it, I guess?).

## Accessibility 

I've wrapped the watchface with `Semantics` widget to tell the time.

## Personalize it yourself

Feel free to play around with `FloatingContainer` params like
`scale` and `duration` in `oversized_clock.dart`. I chose some 
values which I liked best but if it would be possible by the 
challenge rules, I would make these params configurable.

## Other thoughts

I modified some of the Android and iOS project files to allow
only a landscape orientation of the app. These projects are not 
part of the original challenge submission, though.

Also, for Android-sake, I used 
`SystemChrome.setEnabledSystemUIOverlays([]);` to make the 
watchface full-screen. This had no effect on the iPhone.

For real-device testing with iPhone, I used a `wakelock` package 
to prevent the screen from locking and breaking the connection to the
debugger.

## References

* [Vertigo font](https://www.1001fonts.com/vertigo-font.html#styles)
* [wakelock package](https://pub.dev/packages/wakelock)