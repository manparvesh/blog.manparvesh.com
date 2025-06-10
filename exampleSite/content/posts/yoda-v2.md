---
title: "Yoda V2"
subtitle: Rewriting and revamping Yoda
author: Man Parvesh Singh Randhawa
date: "2024-09-21T01:21:22-07:00"
meta: true
math: false
toc: true
hideDate: false
hideReadTime: false
tags: [python, yoda]
series: [Yoda]
draft: false
description: "A brief history of Yoda and why I decided to rewrite it"
---

{{< figure
  src="https://github.com/yoda-pa/yoda/raw/v2/logo.png"
  type="full"
  label="mn-yoda"
  caption=``
  ind="⊕"
  alt="Yoda logo"
>}}


## Why is it called Yoda
Since Yoda was a movie character considered wise and knowledgeable, I named it Yoda and made it open source[^1].

[^1]: _[Github: yoda-pa/yoda](https://github.com/yoda-pa/yoda/)_

## History of the project 🕰️

I started Yoda PA as a hobby project after graduating from college and starting my first job (circa 2017). My original intention for this project was to learn how several small things in software work, so I decided to build miniature versions of everything I wanted to learn and group them under a large project—my original to-do list. As you can see, it’s a mess. 

## Uprise 📈

As I kept working on it, I kept sharing the project and my ideas in multiple places on the internet. This led to an interest in several developers from all over the world to contribute to the project.

As it grew more prominent, it became complicated for a software newbie like me to manage, and the code became too bloated. I eventually stopped working on it as I went on to pursue higher education

## Why V2 after so long?

Command-line tools are making a comeback, and many excellent CLI tools are being developed. Yoda had a lot of potential to become an excellent general-purpose utility tool. I want to give it another shot at greatness and hopefully learn even more than I did the last time.
There’s also been a recent rise in TUI apps (user interfaces inside the terminal—https://github.com/agarrharr/awesome-cli-apps), which fascinates me. I want to build something related to it, and maybe we can have Yoda plugins around it in the future.

## How is Yoda V2 going to look like

1. Something that’s going to be usable in daily life.
2. Provide standard packages for multiple environments.
3. Allow users to write plugins to allow maximum customization.
4. In-built plugin manager
5. Inbuilt config manager to manage plugins and other settings.
6. Make output pretty (using tools like 
rich)
7. Allow writing plugins in other languages (like Golang/rust for low-level stuff, etc.)
8. Create a starter webpage for this app.
9. Create a website with documentation on how to do contribute to the project and how to write plugins etc.

## So, what next?

I’m open to more ideas! I will write a document that will contain more technical details on how the newer version of yoda is going to work, and write another post around it. 

I believe writing a design doc would give me more clarity on how to proceed with this, so that’s going to be the next step for this project. Stay tuned!
