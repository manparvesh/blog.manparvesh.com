---
title: "I wrote a telegram bot to lose weight"
subtitle: Building Sehat Bot
author: Man Parvesh Singh Randhawa
date: "2025-04-04T23:59:47-07:00"
meta: true
math: false
toc: false
hideDate: false
hideReadTime: false
series: []
tags: []
draft: false
description: Building Sehat Bot
---

I needed an automated solution to track my weight loss progress and keep track of my habits, so instead of searching and paying for an app, I wrote my own!

## Why Telegram?

Because it's free, the bot API is well-documented and easy to build on. The incoming messages are first handled by the telegram bot infrastructure, so you can just have a small server to process incoming messages (might be slow, but works for me as there are no other users).

## How It Works

**Daily Check-ins:** The bot sends a 7 AM PST reminder with five yes/no questions about yesterday's habits. These questions are based on whether previous day you did weight training, cardio, follow the deit plan, had enough sleep (8+ hrs), and took enough steps (5k+). 

**Weekly Tracking:** Every Monday, you log weight and waist measurements. The bot shows your progress over time.

## Why this style of Check-ins instead of a single, weekly checkin with all details?

1. Consistency is important. Slowly, over the time, it makes a huge difference.
2. Automated reminders help. With daily reminders, you keep getting reminded of your goals and that you need to stay on track.
3. Seeing your numbers is motivating.

## Try It

Search for [@sehatmand_bot](https://t.me/sehatmand_bot) on Telegram. Use `/start` to register, `/daily` for check-ins, and `/weekly` for measurements.

## Future Plans

- BMI tracking
- Achievement streaks
- Better visualization
- Custom reminder times

The best tracker is one you'll actually use - so I'm aiming to keep using this one as much as I can, and keep improving it.

---
*"Sehatmand" means "healthy" in Punjabi/Hindi*
