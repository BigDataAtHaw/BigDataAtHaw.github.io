---
layout: post
title:  JSON value '<null>'...
date:   2017-10-26 18:41:18 +0200
categories: React Native
---
# JSON value '<null>' of type NSNull cannot be converted to NSString

## Content

* Background
* Error
* Solving
* Reasoning

## Background

This error is the most annoying error that occurred in my short React Native carreer so far. I had such a hard time to solve this Issue that I try to abstract it in this blog post.

If you are a React Native geek, this is not for you. But for all beginners like me. This might help you.

At my company is a huge Summit event in a couple of weeks. The idea was to build an App and every attendee can download it to read the schedule, vote presentations, have a map with all locations marked on it and a small facebook for all the people involved.

So we started and after a short time we already had quite a lot to show and play around. I mean it is just a fancy UI with a firebase back end.

## Error
Anyway after we implemented a objective C library for some reasons and its pendent in java, we faced a cryptic error:
`JSON value '<null>' of type NSNull cannot be converted to NSString`

You might think, well, thats an easy solveable problem. This guy is nuts.

But the error occoured so far away from its actual origin, that I had no idea.

I downloaded some Ide enhancements like flow and linter and nuclide and then I deleted half of it because it sloved everything down for some reason. 

## Solving
In the end I just did the obvious. I commented every method to see, if the error still happens.
And after half an hour I found the reason.

A Webview props that had a null value.

## Reasoning
My guess is, that React Native does not check for null values in UI-Element-Props. In our example we did a mistake by setting the uri prop of a webview on null. We wanted to check against it to decide wether we show the webview or not.
But this did not work and when the App reached the position where it checks the webviews props. The whole app crashed.

Again this just happens on iOS devices. 

Cheers.
