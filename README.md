# Break.Down.Timer (B.D.T)

A timer with in-between notifications.

## What is this

This is a handy timer where you can define notifications while the timer is running. Imagine this scenario: You have 45 minutes time to go for a walk, so you should go back after the half of the time. So, set the timer duration to 45 minutes, define a break after the half of the time and start the timer. Now you get a notification (audio signal, vibration, device notification) when the half time is reached, AND of course when the whole time is reached.

Other scenarios could be to get notified every quarter of a duration to keep a feeling of the passing and remaining time. Or to get notifications short before the end of the duration.

## How it works

The notifications are encoded in patterns of audio beeps and/or vibrations to express the reached in-between break. The pattern is very simple: a short beep means "1", a long beeeeep means "5". So, e.g. "beeeeep beep" means "6". All signals are prefixed with a short "bepbep" sequence to attract attention.

To set a notification ("break"), just click on a slice of the wheel. To unset it, click again. Each placed "break" gets a number as identifier, used as notification pattern.

Set a timer duration by clicking on the center of the wheel. You can also set a destination time by switching the timer mode from "Timer" to "Clock".

Instead of placing breaks by your own, you can use the built-in presets of the app. You can also save your own presets. One favourite preset can be pinned to be present after app-start.

Fore more details, see [bdt.jepfa.de](https://bdt.jepfa.de).

## Download

**Important note**: There is an _ad-containing_ fork on **Google Play** abusing my AppId (`de.jepfa.bdt`) from another developer called "Schnupfeld". To get my origin ad-free version, use the badge below (AppId `de.jepfa.bdt.adfree`).

[<img src="https://fdroid.gitlab.io/artwork/badge/get-it-on.png"
     alt="Get it on F-Droid"
     height="80">](https://f-droid.org/packages/de.jepfa.bdt/)

[<img src="https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png"
alt="Get it on Google Play"
height="80">](https://play.google.com/store/apps/details?id=de.jepfa.bdt.adfree)

Or download the latest apk from [here.](https://bdt.jepfa.de/download/)
