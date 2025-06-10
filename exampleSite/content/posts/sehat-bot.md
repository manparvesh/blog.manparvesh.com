---
title: "Building a Telegram Bot for Health Tracking"
subtitle: Sehat Bot - Automated Health and Fitness Companion
author: Man Parvesh Singh Randhawa
date: "2025-04-04T23:59:47-07:00"
meta: true
math: false
toc: false
hideDate: false
hideReadTime: false
series: []
tags: [go,telegram]
draft: false
description: A Telegram bot for automated health tracking through daily habit check-ins and weekly biometric measurements.
---

I built a custom Telegram bot for health tracking instead of using existing apps, providing complete control over data privacy and feature implementation.

## Why Telegram?

- **Free Infrastructure:** No hosting costs for bot interactions
- **Well-documented API:** Robust development framework
- **Minimal Server Requirements:** Telegram handles message routing
- **Universal Access:** Cross-platform without app store dependencies

## How It Works

**Daily Check-ins:** 7 AM PST reminders for five habit metrics: weight training, cardio, diet adherence, sleep (8+ hours), and steps (5,000+).

**Weekly Measurements:** Monday check-ins for weight and waist circumference with progress tracking.

Daily engagement was chosen over weekly reporting for better habit reinforcement, goal awareness, and progress visibility.

## Usage

Search [@sehatmand_bot](https://t.me/sehatmand_bot) on Telegram. Commands: `/start` to register, `/daily` for check-ins, `/weekly` for measurements, `/stats` for user history.

## Self-Hosting

Deploy privately with Docker:

1. Create `.env` file: `BOT_API_KEY=your_telegram_bot_token`
2. Create empty `app.db` file
3. Use docker-compose.yaml:
```yaml
version: "3.8"
services:
  sehat:
    image: ghcr.io/manparvesh/sehat:main
    volumes:
      - ./app.db:/data/app.db
    env_file:
      - .env
    restart: always
```
4. Run: `docker compose up`

## Future Plans

- BMI tracking and trends
- Achievement streaks  
- Better data visualization
- Custom reminder times

---
*"Sehatmand" means "healthy" in Punjabi/Hindi*
